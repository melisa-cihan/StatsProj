# Load necessary libraries
library(ggplot2)
library(dplyr)
library(lubridate)

# 1. LOAD & CLEAN DATA
df <- read.csv("retail_data.csv", stringsAsFactors = FALSE, na.strings = c("", "NA", "null"))

clean_time_data <- df %>%
  # Crucial: Convert the string date into an actual R Date object
  mutate(Transaction.Date = as.Date(Transaction.Date)) %>%
  
  # Ensure Total Spent is numeric
  mutate(Total.Spent = as.numeric(Total.Spent)) %>%
  
  # Remove rows with missing dates or spend values
  filter(!is.na(Transaction.Date) & !is.na(Total.Spent)) %>%
  
  # Aggregate data by date to make the line chart cleaner 
  # (Calculating daily total revenue)
  group_by(Transaction.Date) %>%
  summarise(Daily_Revenue = sum(Total.Spent), .groups = 'drop')

# 2. BIVARIATE ANALYSIS: Date vs. Revenue
# We use geom_line for the raw data and geom_smooth for the trend
ggplot(clean_time_data, aes(x = Transaction.Date, y = Daily_Revenue)) +
  geom_line(color = "steelblue", alpha = 0.5) +  # The actual daily fluctuations
  geom_smooth(method = "loess", color = "red", se = TRUE) + # The LOESS smoothing trend line
  labs(
    title = "Retail Spending Trends Over Time",
    subtitle = "Daily Revenue with LOESS Smoothing Trend Line",
    x = "Transaction Date",
    y = "Total Daily Revenue ($)"
  ) +
  theme_minimal()

# 3. EXTRA STEP: Day-of-Week Analysis
# This adds more depth to your "Plausibility" discussion
clean_time_data <- clean_time_data %>%
  mutate(Day_of_Week = wday(Transaction.Date, label = TRUE))

dow_summary <- clean_time_data %>%
  group_by(Day_of_Week) %>%
  summarise(Avg_Daily_Revenue = mean(Daily_Revenue))

print(dow_summary)
