library(rlang)
library(tidymodels)
library(tidyverse)
library(dplyr)
library(readxl)
library(stringr)
library(ggplot2)
head(jfk_weather_sample)
glimpse(jfk_weather_sample)
noaa_subset <- jfk_weather_sample %>%
  select(HOURLYRelativeHumidity,
         HOURLYDRYBULBTEMPF,
         HOURLYPrecip,
         HOURLYWindSpeed,
         HOURLYStationPressure)
head(noaa_subset, 10)
unique(noaa_subset$HOURLYPrecip)
noaa_clean <- noaa_subset %>%
  mutate(
    HOURLYPrecip = str_replace_all(HOURLYPrecip,"T", "0.0"),
    HOURLYPrecip = str_remove(HOURLYPrecip, "s$"),
    HOURLYPrecip = as.numeric(HOURLYPrecip))
glimpse(noaa_clean)
noaa_numeric <- noaa_clean %>%
  mutate(HOURLYPrecip = as.numeric(HOURLYPrecip))
glimpse(noaa_numeric)
final_df <- noaa_numeric %>%
  rename(
    relative_humidity = HOURLYRelativeHumidity,
    dry_bulb_temp_f = HOURLYDRYBULBTEMPF,
    precip = HOURLYPrecip,
    station_pressure = HOURLYStationPressure,
    wind_speed = HOURLYWindSpeed)
set.seed(1234)
n <- nrow(final_df)
train_index <- sample(1:n, size = 0.8*n)
train_set <- final_df[train_index, ]
test_set <- final_df[train_index, ]
ggplot(train_set, aes(x = relative_humidity)) +
  geom_histogram(bins = 30, fill = "skyblue", color = "black")
ggplot(train_set, aes(y = dry_bulb_temp_f)) +
  geom_boxplot(fill = "orange", color = "black")
model1 <- lm(precip ~ relative_humidity, data = train_set)
summary(model1)
ggplot(train_set, aes(x = relative_humidity, y = precip)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", col = "red")
model2 <- lm(precip ~ dry_bulb_temp_f, data = train_set)
summary(model2)
ggplot(train_set, aes(x = dry_bulb_temp_f, y = precip)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", col = "red")
model3 <- lm(precip ~ wind_speed, data = train_set)
summary(model3)
ggplot(train_set, aes(x = wind_speed, y = precip)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", col = "red")
model4 <- lm(precip ~ station_pressure, data = train_set)
summary(model4)
ggplot(train_set, aes(x = station_pressure, y = precip))+
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", col = "red")
model_multi <- lm(precip ~ relative_humidity + dry_bulb_temp_f + wind_speed + station_pressure,
                  data = train_set)
summary(model_multi)

model_poly <- lm(precip ~ poly(dry_bulb_temp_f,2) + relative_humidity, data = na.omit(train_set)) 
summary(model_poly)

rmse <- function(actual, predicted){
  sqrt(mean((actual - predicted)^2, na.rm = TRUE)) 
}
pred1 <- predict(model1, newdata = test_set)
rmse1 <- rmse(test_set$precip, pred1)

pred2 <- predict(model2, newdata = test_set)
rmse2 <- rmse(test_set$precip, pred2)

pred3 <- predict(model3, newdata = test_set)
rmse3 <- rmse(test_set$precip, pred3)

pred4 <- predict(model4, newdata = test_set)
rmse4 <- rmse(test_set$precip, pred4)

pred_multi <- predict(model_multi, newdata = test_set)
rmse_multi <- rmse(test_set$precip, pred_multi)

pred_poly <- predict(model_poly, newdata = test_set)
rmse_poly <- rmse(test_set$precip, pred_poly)

model_names <- c("Model 1 (humidity)",
                 "Model 2 (temp)",
                 "Model 3 (wind)",
                 "Model 4 (pressure)",
                 "Multi-variable",
                 "Polynomial")
test_rmse <- c(rmse1, rmse2, rmse3, rmse4, rmse_multi, rmse_poly)
comparison_df <- data.frame(Model = model_names, RMSE = test_rmse)
print(comparison_df)