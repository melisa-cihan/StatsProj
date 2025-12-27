library(tidyverse)
library(knitr)

# Load the dataset
taco_data <- read.csv('/Users/melisacihan/Downloads/taco_sales_(2024-2025).csv')

# Identify variable types
numeric_cols <- c("Delivery.Duration..min.", "Distance..km.", "Price...", "Tip...")
categorical_cols <- c("Restaurant.Name", "Location", "Taco.Type", "Weekend.Order")

# Rename columns for easier access (removing special characters)
names(taco_data) <- c("Order_ID", "Restaurant_Name", "Location", "Order_Time", 
                      "Delivery_Time", "Delivery_Duration_Min", "Taco_Size", 
                      "Taco_Type", "Toppings_Count", "Distance_KM", 
                      "Price_USD", "Tip_USD", "Weekend_Order")

# 1. Impute missing numeric values with the Median
taco_data <- taco_data %>%
  mutate(across(c(Delivery_Duration_Min, Distance_KM, Price_USD, Tip_USD), 
                ~ ifelse(is.na(.), median(., na.rm = TRUE), .)))

# 2. Drop rows with missing categorical data
taco_data <- taco_data %>%
  drop_na()

# 3. Convert 'Taco Size' to an Ordinal Factor
# This is crucial as 'Large' implies a higher rank than 'Regular'
taco_data$Taco_Size <- factor(taco_data$Taco_Size, 
                              levels = c("Regular", "Large"), 
                              ordered = TRUE)

# Verify the structure
str(taco_data)

#----------------------------------------------------------------------
#1. Nominal vs. Numerical: Delivery Efficiency by Location
# Calculate Summary Statistics by Location
location_stats <- taco_data %>%
  group_by(Location) %>%
  summarise(
    Mean_Duration = mean(Delivery_Duration_Min),
    Median_Duration = median(Delivery_Duration_Min),
    SD_Duration = sd(Delivery_Duration_Min),
    Count = n()
  ) %>%
  arrange(desc(Median_Duration))

kable(location_stats, caption = "Table 1: Delivery Duration Statistics by Location")

# Visualization: Boxplot
ggplot(taco_data, aes(x = reorder(Location, Delivery_Duration_Min, FUN = median), 
                      y = Delivery_Duration_Min, fill = Location)) +
  geom_boxplot() +
  labs(title = "Distribution of Delivery Duration by City",
       x = "Location",
       y = "Duration (Minutes)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none")

#----------------------------------------------------------------------

#2. Ordinal vs. Numerical: Pricing Strategy by Size
# Grouped Summary Statistics
size_stats <- taco_data %>%
  group_by(Taco_Size) %>%
  summarise(
    Avg_Price = mean(Price_USD),
    Median_Price = median(Price_USD),
    Max_Price = max(Price_USD)
  )

kable(size_stats, caption = "Table 2: Price Statistics by Taco Size")

# Visualization: Violin Plot with overlaid Boxplot
# A violin plot is chosen to show the density of prices for each size
ggplot(taco_data, aes(x = Taco_Size, y = Price_USD, fill = Taco_Size)) +
  geom_violin(alpha = 0.5, trim = FALSE) +
  geom_boxplot(width = 0.2, color = "black", outlier.shape = NA) +
  labs(title = "Price Distribution by Taco Size",
       x = "Taco Size (Ordinal)",
       y = "Price (USD)") +
  theme_minimal() +
  scale_fill_manual(values = c("#FFCC00", "#FF6600"))


#----------------------------------------------------------------------
#3. Numerical vs. Numerical: Tipping Behavior Analysis
# Scatterplot with Smoothing Line
ggplot(taco_data, aes(x = Price_USD, y = Tip_USD)) +
  geom_point(alpha = 0.6, color = "darkcyan") +
  geom_smooth(method = "loess", color = "red", se = FALSE) +
  labs(title = "Scatterplot: Price vs. Tip (Linearity Check)",
       x = "Order Price (USD)",
       y = "Tip Amount (USD)") +
  theme_minimal()


# 1. Pearson Correlation
correlation <- cor(taco_data$Price_USD, taco_data$Tip_USD, method = "pearson")
print(paste("Pearson Correlation Coefficient:", round(correlation, 4)))

# 2. Linear Regression Model
# Fitting the model: Tip depends on Price
lm_model <- lm(Tip_USD ~ Price_USD, data = taco_data)

# Display Coefficients
print(coef(lm_model))

# Display Full Regression Summary Table
summary(lm_model)



#--------------------------------------------------------------------------
#Nominal vs Numerical: The Weekend Bottleneck

# Calculate Summary Statistics
weekend_stats <- taco_data %>%
  group_by(Weekend_Order) %>%
  summarise(
    Mean_Duration = mean(Delivery_Duration_Min),
    Median_Duration = median(Delivery_Duration_Min),
    SD_Duration = sd(Delivery_Duration_Min)
  )

kable(weekend_stats, caption = "Table 1: Delivery Duration by Time of Week")

# Visualization: Boxplot
ggplot(taco_data, aes(x = Weekend_Order, y = Delivery_Duration_Min, fill = Weekend_Order)) +
  geom_boxplot() +
  labs(title = "Impact of Weekend Traffic on Delivery Speed",
       x = "Order Period",
       y = "Duration (Minutes)") +
  theme_minimal() +
  scale_fill_manual(values = c("#A6CEE3", "#1F78B4"))


