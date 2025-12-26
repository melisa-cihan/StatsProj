# Load necessary libraries
library(ggplot2)
library(dplyr)

# 1. LOAD & CLEAN DATA
# (Assuming the cleaning steps from the previous file are applied)
df <- read.csv("retail_data.csv", stringsAsFactors = FALSE, na.strings = c("", "NA", "null"))

clean_market_data <- df %>%
  mutate(
    Category = as.factor(Category),
    Price.Per.Unit = as.numeric(Price.Per.Unit),
    Total.Spent = as.numeric(Total.Spent)
  ) %>%
  filter(!is.na(Category) & !is.na(Total.Spent))

# 2. ANALYSIS A: Total Spent per Category (Reordered Bar Chart)
# We calculate the mean spending to see the "Big Earners"
category_summary <- clean_market_data %>%
  group_by(Category) %>%
  summarise(Mean_Spent = mean(Total.Spent, na.rm = TRUE)) %>%
  arrange(desc(Mean_Spent))

ggplot(category_summary, aes(x = reorder(Category, -Mean_Spent), y = Mean_Spent, fill = Category)) +
  geom_col() +
  labs(
    title = "Average Revenue per Transaction by Category",
    subtitle = "Identifying the 'Big Earners'",
    x = "Product Category",
    y = "Average Total Spent ($)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# 3. ANALYSIS B: Price Distribution (Violin Plot + Boxplot)
# This shows the "Price Variance" per category
ggplot(clean_market_data, aes(x = Category, y = Price.Per.Unit, fill = Category)) +
  geom_violin(trim = FALSE, alpha = 0.5) + # Shows density width
  geom_boxplot(width = 0.1, color = "black", outlier.shape = NA) + # Internal boxplot
  labs(
    title = "Price Distribution per Category",
    subtitle = "Visualizing Price Variance and Density",
    x = "Product Category",
    y = "Price Per Unit ($)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# 4. STATISTICAL TABLE FOR REPORT
# This provides the numbers for your "Plausibility Check"
market_stats <- clean_market_data %>%
  group_by(Category) %>%
  summarise(
    Avg_Price = mean(Price.Per.Unit),
    Price_SD = sd(Price.Per.Unit), # Standard Deviation (Variance)
    Transaction_Count = n()
  )

print(market_stats)
