# Required libraries
library(tidyverse)
library(knitr)
#--------------------------------------------------------------

#1. Data Loading and Cleansing

# Load the dataset
bmw_data <- read.csv("/Users/melisacihan/Downloads/BMW sales data (2010-2024).csv")

# Identify variable types
numeric_cols <- c("Engine_Size_L", "Mileage_KM", "Price_USD", "Sales_Volume")
categorical_cols <- c("Model", "Year", "Region", "Color", "Fuel_Type", "Transmission", "Sales_Classification")

# Impute missing numeric values with the Median
# We use the median as it is more robust against outliers than the mean
bmw_data <- bmw_data %>%
  mutate(across(all_of(numeric_cols), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)))

# Drop rows with missing categorical data
bmw_data <- bmw_data %>%
  drop_na()

# Convert character columns to factors for analysis
bmw_data[categorical_cols] <- lapply(bmw_data[categorical_cols], as.factor)

# Verify the cleaning process
str(bmw_data)

#-------------------------------------------------------------------
#Univairate Analysis
#------------------------------------------------------------------
#1. Categorical Variable Fuel Type
# Calculate Frequencies and Proportions
fuel_counts <- bmw_data %>%
  count(Fuel_Type) %>%
  mutate(
    Proportion = n / sum(n),
    Percentage = round(Proportion * 100, 2)
  ) %>%
  arrange(desc(n))

# Display the summary table
kable(fuel_counts, caption = "Table 1: Frequency Distribution of Fuel Types")

# Visualization: Bar Chart
ggplot(fuel_counts, aes(x = reorder(Fuel_Type, -n), y = n)) +
  geom_bar(stat = "identity", fill = "#4C72B0", color = "black", alpha = 0.8) +
  geom_text(aes(label = paste0(Percentage, "%")), vjust = -0.5) +
  labs(title = "Distribution of Vehicles by Fuel Type",
       x = "Fuel Type",
       y = "Number of Vehicles") +
  theme_minimal()



#-------------------------------------------------------------------
#Bivariate Analysis
#------------------------------------------------------------------
#1. Categorical vs. Categorical: Region and Transmission
# Contingency Table
cont_table <- table(bmw_data$Transmission, bmw_data$Region)
kable(cont_table, caption = "Table 3: Contingency Table (Transmission vs. Region)")

# Visualization: Stacked Bar Chart
ggplot(bmw_data, aes(x = Region, fill = Transmission)) +
  geom_bar(position = "fill", color = "black") +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Proportion of Transmission Types by Region",
       x = "Region",
       y = "Proportion",
       fill = "Transmission") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#2.Numerical vs. Categorical: Price by Fuel Type
# Visualization: Grouped Boxplots
ggplot(bmw_data, aes(x = reorder(Fuel_Type, Price_USD, FUN = median), y = Price_USD, fill = Fuel_Type)) +
  geom_boxplot() +
  labs(title = "Price Distribution by Fuel Type",
       x = "Fuel Type",
       y = "Price (USD)") +
  theme_minimal() +
  theme(legend.position = "none")

#3. Numerical vs. Numerical: Mileage vs. Price
# Scatterplot with Loess smooth line to check linearity
ggplot(bmw_data, aes(x = Mileage_KM, y = Price_USD)) +
  geom_point(alpha = 0.4, color = "grey30") +
  geom_smooth(method = "loess", color = "blue", se = FALSE) +
  labs(title = "Scatterplot: Price vs. Mileage (Linearity Check)",
       subtitle = "Blue line represents the local moving average",
       x = "Mileage (km)",
       y = "Price (USD)") +
  theme_minimal()

# 1. Pearson Correlation
cor_val <- cor(bmw_data$Mileage_KM, bmw_data$Price_USD, method = "pearson")

# 2. Linear Regression Model
lm_model <- lm(Price_USD ~ Mileage_KM, data = bmw_data)
model_summary <- summary(lm_model)
model_summary
# Extracting key metrics for reporting
intercept <- coef(lm_model)[1]
slope <- coef(lm_model)[2]
r_squared <- model_summary$r.squared

# Display Results
cat("Pearson Correlation (r):", round(cor_val, 3), "\n")
cat("Regression Intercept (b0):", round(intercept, 2), "\n")
cat("Regression Slope (b1):", round(slope, 4), "\n")
cat("Coefficient of Determination (R2):", round(r_squared, 4))






model_sales <- bmw_data %>%
  group_by(Model) %>%
  summarise(Total_Sales = sum(Sales_Volume), .groups = 'drop') %>%
  arrange(desc(Total_Sales))

# Calculate relative proportions for context
model_sales <- model_sales %>%
  mutate(Market_Share = round(Total_Sales / sum(Total_Sales) * 100, 2))

# Display the summary table
kable(model_sales, caption = "Table 5: Total Sales Volume and Market Share by Model")

# Visualization: Bar Chart (Vertical)
ggplot(model_sales, aes(x = reorder(Model, -Total_Sales), y = Total_Sales)) +
  geom_bar(stat = "identity", fill = "#2E8B57", color = "black", alpha = 0.8) +
  
  # Add labels above the bars
  geom_text(aes(label = paste0(Market_Share, "%")), vjust = -0.5, size = 3) +
  
  # Format Y-axis with commas (e.g., 10,000 instead of 1e+04)
  scale_y_continuous(labels = scales::comma) +
  
  labs(title = "Total Sales Volume by Model",
       subtitle = "Labels indicate market share percentage",
       x = "Model",
       y = "Total Units Sold") +
  theme_minimal() +
  
  # Rotate X-axis labels 45 degrees to prevent overlapping
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

