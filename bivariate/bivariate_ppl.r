# Load necessary libraries
library(ggplot2)
library(dplyr)

# 1. LOAD & CLEAN DATA
# Use na.strings to catch empty cells in the "dirty" csv
df <- read.csv("retail_data.csv", stringsAsFactors = FALSE, na.strings = c("", "NA", "null"))

clean_payment_data <- df %>%
  # Select only the columns we need for this analysis
  select(Location, Payment.Method) %>%
  
  # Remove rows where either variable is missing (cleaning the dirty data)
  filter(!is.na(Location) & !is.na(Payment.Method)) %>%
  
  # Convert to factors for categorical analysis
  mutate(
    Location = as.factor(Location),
    Payment.Method = as.factor(Payment.Method)
  )

# 2. BIVARIATE ANALYSIS: Location vs. Payment Method
# We use position = "fill" to create the percentile-based (100%) stacked bar
ggplot(clean_payment_data, aes(x = Location, fill = Payment.Method)) +
  geom_bar(position = "fill") + 
  scale_y_continuous(labels = scales::percent) + # Converts 0.75 to 75%
  labs(
    title = "Payment Method Preference by Location",
    subtitle = "Comparing the proportional split of transactions",
    x = "Store Location",
    y = "Percentage of Transactions",
    fill = "Payment Method"
  ) +
  theme_minimal() +
  scale_fill_brewer(palette = "Set3")

# 3. STATISTICAL TABLE (Cross-tabulation)
# This creates a table of counts and percentages for your report
payment_summary <- clean_payment_data %>%
  group_by(Location, Payment.Method) %>%
  summarise(Count = n(), .groups = 'drop') %>%
  group_by(Location) %>%
  mutate(Percentage = round((Count / sum(Count)) * 100, 2))

print(payment_summary)
