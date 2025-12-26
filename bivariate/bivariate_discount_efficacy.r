install.packages("dplyr")

# Load necessary libraries
library(ggplot2)
library(dplyr)
library(lubridate)

# 1. LOAD DATA
# Replace 'retail_data.csv' with your actual file path
df <- read.csv("/Users/hrusheekeshsawarkar/Projects/StatsProj/retail_store_sales.csv", stringsAsFactors = FALSE, na.strings = c("", "NA", "null"))

# 2. DATA CLEANING
clean_data <- df %>%
  # Convert Transaction Date to a proper Date object
  mutate(Transaction.Date = as.Date(Transaction.Date)) %>%
  
  # Ensure numeric columns are actually numeric
  mutate(
    Price.Per.Unit = as.numeric(Price.Per.Unit),
    Quantity = as.numeric(Quantity),
    Total.Spent = as.numeric(Total.Spent)
  ) %>%
  
  # Handle the 'Discount Applied' column
  # Convert to a factor and handle missing values
  mutate(Discount.Applied = ifelse(is.na(Discount.Applied), "Unknown", as.character(Discount.Applied))) %>%
  mutate(Discount.Applied = factor(Discount.Applied, levels = c("True", "False", "Unknown"))) %>%
  
  # Optional: Data Validation check
  # Remove rows where Total Spent doesn't match Price * Quantity (cleaning the 'dirty' data)
  filter(abs((Price.Per.Unit * Quantity) - Total.Spent) < 0.01) %>%
  
  # Remove the 'Unknown' discounts for this specific analysis to avoid bias
  filter(Discount.Applied != "Unknown")

# 3. BIVARIATE ANALYSIS: Discount vs. Quantity
# This helps see if discounts drive people to buy MORE items
ggplot(clean_data, aes(x = Discount.Applied, y = Quantity, fill = Discount.Applied)) +
  geom_boxplot(alpha = 0.7) +
  labs(
    title = "Impact of Discounts on Item Quantity",
    x = "Was a Discount Applied?",
    y = "Quantity of Items Purchased"
  ) +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

# 4. BIVARIATE ANALYSIS: Discount vs. Total Spent
# This helps see if discounts actually increase the revenue per transaction
ggplot(clean_data, aes(x = Discount.Applied, y = Total.Spent, fill = Discount.Applied)) +
  geom_boxplot(alpha = 0.7) +
  labs(
    title = "Impact of Discounts on Total Transaction Value",
    x = "Was a Discount Applied?",
    y = "Total Spent ($)"
  ) +
  theme_minimal() +
  scale_fill_brewer(palette = "Pastel1")

# 5. STATISTICAL SUMMARY
# Get the exact numbers to discuss in your report
summary_stats <- clean_data %>%
  group_by(Discount.Applied) %>%
  summarise(
    Avg_Quantity = mean(Quantity, na.rm = TRUE),
    Median_Spend = median(Total.Spent, na.rm = TRUE),
    Count = n()
  )

print(summary_stats)
