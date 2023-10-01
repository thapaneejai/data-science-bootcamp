# load library and import data
library(tidyverse)
library(caret)
library(ggplot2)
library(readxl)

House_Price_India <- read_excel("House Price India.xlsx")
glimpse(House_Price_India)

## 0. Prepare data
# Select features and target
hpi <- House_Price_India %>%
  select(`living area`,
         `number of floors`,
         `Built Year`,
         Price)

# check price distribution
ggplot(hpi, aes(Price)) +
  geom_histogram()

# transform right skewed distribution using Log
# and check if there's any zero or minus datapoints
hpi$Price <- log(hpi$Price)
mean(hpi$Price <= 0)

# Re-check price distribution
ggplot(hpi, aes(Price)) +
  geom_density()

# check NA
hpi %>%
  complete.cases() %>%
  mean()

## 1. Split data
set.seed(42)
n <- nrow(hpi)
id <- sample(n, size = 0.8*n)
train_hpi <- hpi[id, ]
test_hpi <- hpi[-id, ]

nrow(train_hpi)
nrow(test_hpi)

## 2. Train model
hpi_lm_model <- train(Price ~ .,
                      data = train_hpi,
                      method = "lm")
hpi_lm_model

## 3. Score/Predict model
p <- predict(hpi_lm_model, newdata = test_hpi)

## 4. Evaluate model
rmse <- sqrt(mean((p - test_hpi$Price)**2))
mae <- mean(abs(p - test_hpi$Price))

## conclusion
hpi_lm_model
rmse
mae
