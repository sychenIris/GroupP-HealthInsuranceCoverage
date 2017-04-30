# GroupP-HealthInsuranceCoverage

Title: Health Insurance Coverage in the US

Abstract: We are interested in finding out how health insurance coverage in the USA differs from state to state, its relationship to indicators of health performance, and whether it can be predicted by political factors. We will explore the following questions:

How does insurance coverage differ from state to state? We can also ask more detailed questions such as on employer-provided insurance coverage and coverage of different age groups.

How has the rate of insurance coverage changed over time over the last decade? In which states did insurance coverage expand under Obamacare? Which states observed the greatest decline in their uninsured rate?

How does health insurance coverage relate to regional variations in health outcomes? We can look at indicators of mortality and rates of major diseases, plotting these on a map as well. (Also find ways to control for income differences and other factors.)

How does healthcare access differ by state? How does health insurance coverage relate to participation / uptake in preventative measures and treatment options (such as vaccinations, mammograms)?

How do the sentiments towards Obamacare differ from state to state, and how does it relate to voting patterns? If feasible, we plan to analyze sentiments from twitter data, whether Obamacare is mentioned alongside positive or negative words.

We will make use of ggplot2, spatial data techniques, and text mining techniques in our visualization project.

Data: For our analysis, we would require data on the following areas:

General state-level data: To be determined, but should be easy to find.
We would require general data on the states including on population, age distribution and income distribution.

State data on the Affordable Care Act (ACA) (from US National Library of Medicine): https://aspe.hhs.gov/compilation-state-data-affordable-care-act
This state-level dataset includes coverage rates of the ACA, growth and expansion status of the ACA, employer vs. individual market coverage, and Medicaid / Medicare numbers. (filename: states_aca_general)

State scorecard on various health indicators (from the Commonwealth Fund): http://datacenter.commonwealthfund.org/#ind=1/sc=1
This state-level dataset has collated information about the health performance of the states along various dimensions. It includes insurance coverage rates, participation rates in prevention and treatment activities, and some measures of mortality. It also provides some differentiating information by race and income, allowing us to explore issues of equity.

Health Insurance Marketplace Data (from US Department of Health and Human Services): https://www.kaggle.com/hhs/health-insurance-marketplace
This dataset contains information on health and dental plans offered through the US Health Insurance Marketplace.

Twitter API data:
We will try to extract text data on individuals' thoughts and opinions on Obamacare, capturing positive and negative sentiments.
