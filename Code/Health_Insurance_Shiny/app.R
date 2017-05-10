### SHINY APP ###

## HEALTH INSURANCE ##

rm(list=ls())

library(shiny)
library(dygraphs)
library(leaflet)
library(maps)
library(rgdal)
library(magrittr)
library(readxl)
library(plyr)
library(dplyr)
library(tidyr)
library(readr)
library(stringi)
library(RColorBrewer)
library(countrycode)


# Import insurance data
insurance_shiny <- read.csv("shiny_insurance.csv")
#insurance_shiny <- read.csv("/Users/gracekongyx/Documents/*6_Data Science/QMSS G4063 Data Visualization/Final Project/R code/Health_Insurance_Shiny/shiny_insurance.csv")
#insurance_shiny <- read.csv("/Users/gracekongyx/Documents/*6_Data Science/QMSS G4063 Data Visualization/Final Project/Data/shiny_insurance.csv")

## DATA PROCESSING

# Save list of state abbreviations
state_abb_lookup <- insurance_shiny[ , c("state", "state_abb")]

# Obtain shape files of US states
map_states = map("state", fill = TRUE, plot = FALSE)

# Standardize name format with rest of assignment
# Function to conver to proper case
properCase <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}
# Convert to proper case
map_states$state <- sapply(map_states$names, properCase)
# Rename the main component of states with multiple parts in the map
map_states$state[map_states$state == "Massachusetts:main"] <- "Massachusetts"
map_states$state[map_states$state == "Michigan:south"] <- "Michigan"
map_states$state[map_states$state == "New York:main"] <- "New York"
map_states$state[map_states$state == "North Carolina:main"] <- "North Carolina"
map_states$state[map_states$state == "Virginia:main"] <- "Virginia"
map_states$state[map_states$state == "Washington:main"] <- "Washington"
# Match with state abbreviations
map_states$state_abb <- state_abb_lookup$state_abb[match(map_states$state, state_abb_lookup$state)]
# Then strip off all the extra location information for states with multiple parts (leaving just the state name)
for (i in 1:length(map_states$state)) {
  map_states$state[i] <- unlist(strsplit(map_states$state[i], ":"))[1]
}

# Import key indicators data, matched by state
# Remember to later match information based on state, not state abbreviation (due to how we labelled above)
map_states_ins <- map_states
map_states_ins$uninsured_pct_2008 <- insurance_shiny$uninsured_pct_2008[match(map_states$state, insurance_shiny$state)]
map_states_ins$uninsured_pct_2009 <- insurance_shiny$uninsured_pct_2009[match(map_states$state, insurance_shiny$state)]
map_states_ins$uninsured_pct_2010 <- insurance_shiny$uninsured_pct_2010[match(map_states$state, insurance_shiny$state)]
map_states_ins$uninsured_pct_2011 <- insurance_shiny$uninsured_pct_2011[match(map_states$state, insurance_shiny$state)]
map_states_ins$uninsured_pct_2012 <- insurance_shiny$uninsured_pct_2012[match(map_states$state, insurance_shiny$state)]
map_states_ins$uninsured_pct_2013 <- insurance_shiny$uninsured_pct_2013[match(map_states$state, insurance_shiny$state)]
map_states_ins$uninsured_pct_2014 <- insurance_shiny$uninsured_pct_2014[match(map_states$state, insurance_shiny$state)]
map_states_ins$uninsured_pct_2015 <- insurance_shiny$uninsured_pct_2015[match(map_states$state, insurance_shiny$state)]

# Get coordinates of state centers
states_centers <- state.center
state.center <- cbind(states_centers, state_abb_lookup)


## THE SHINY APP

# User interface
ui <- fluidPage(
  titlePanel("Uninsured Rate in the United States from 2008-2015"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "map_year",
                  label = "Year",
                  value = 2008,
                  min = 2008,
                  max = 2015,
                  sep = "",
                  round = TRUE)),
    mainPanel(
      leafletOutput("uninsured_map")
    )
  )
)

# Server
server <- function(input, output) {
  variable_name <- reactive({paste("uninsured_pct_", as.character(input$map_year), sep = "")})
  #variable <- reactive({map_states_ins[[paste("uninsured_pct_", input$map_year, sep = "")]]})
  output$uninsured_map <- renderLeaflet({
    map <- (leaflet(map_states_ins) %>%
       setView(lat=39.8282, lng=-96 , zoom=3.5))
    map
  })
  observe({
    classes <- 6
    pal <- colorNumeric(palette = "Oranges", domain = c(0:30), n = classes)
    map <- leafletProxy("uninsured_map") %>%
      clearShapes() %>%
      clearControls() %>%
      clearMarkers() %>%
      addPolygons(data = map_states_ins, fillColor = ~pal(map_states_ins[[variable_name()]]),
                  smoothFactor = 0.5, fillOpacity = 0.6, color = "#333333", weight = 1,
                  popup = paste("<b>State: </b>", map_states$state, "<br/>", "<b>Uninsured Rate: </b>", map_states_ins[[variable_name()]], "%")) %>%
      addLabelOnlyMarkers(data = filter(state.center, state_abb!="AK" & state_abb!="HI"),
                          lng = ~x, lat = ~y, label = ~state_abb,
                          labelOptions = labelOptions(textsize = "9px", noHide = T, direction = 'top', textOnly = T)) %>%
      addLegend(pal = pal, values = c(0:30),
                bins = classes, position = "bottomright",
                title = paste("Uninsured", "<br/>", "Rate ", "(", as.character(input$map_year), ")", "<br/>", "(%)", sep = ""),
                opacity = 0.7)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

