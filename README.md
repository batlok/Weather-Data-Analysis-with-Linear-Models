# Weather-Data-Analysis-with-Linear-Models
This project analyze **JFK airport weather data** and builds different regression models to predict 
It demonstrate data cleaning, visualization, linear regression modeling and model evaluation in **R**
## PROJECT STRUCTURE
-'weather analysis.R' -> main R script (data cleaning, model building, RMSE evaluation)
-'README.md -> Project Description
##  Dependencies
The following R packages are required:
- **tidyverse**
- **dplyr**
- **ggplot2**
- **stringr**
- **readxl**
- **tidymodels**
## Workflow
Data Cleaning
Replaced "T" values in HOURLYPrecip with 0.0
Converted character columns to numeric
Exploratory Data Analysis
Histograms and boxplots for variable distributions
Scatter plots with regression lines
Modeling
Simple linear regression (precip ~ humidity, precip ~ temperature, etc.)
Multiple regression (precip ~ humidity + temperature + wind + pressure)
Polynomial regression (poly(dry_bulb_temp_f, 2))
Model Evaluation
RMSE values computed for all models
Comparison table created for model performance
