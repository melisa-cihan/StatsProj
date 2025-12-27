# ==============================================================================
# 1. SETUP AND DATA PREPARATION
# ==============================================================================

# Install and load necessary packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("patchwork")) install.packages("patchwork") # Modern replacement for gridExtra
if (!require("corrplot")) install.packages("corrplot")
if (!require("knitr")) install.packages("knitr")

library(tidyverse)
library(patchwork) 
library(corrplot)
library(knitr)

# Load the dataset (Semicolon separator)
# Ensure the file 'student-mat.csv' is in your working directory
full_data <- read.csv("/Users/melisacihan/Downloads/student-mat.csv", sep = ";")

# Select 13 interesting variables covering all data types
# Nominal: school, sex, address, Pstatus, schoolsup, romantic
# Ordinal: Medu (Mother's Education), studytime, goout
# Discrete Numeric: age, failures, absences
# Continuous Numeric: G3 (Final Grade)
subset_data <- full_data %>%
  select(school, sex, address, Pstatus, schoolsup, romantic, 
         Medu, studytime, goout, 
         age, failures, absences, G3)

# Data Type Conversion
# Convert Nominal variables to factors
subset_data$school    <- as.factor(subset_data$school)
subset_data$sex       <- as.factor(subset_data$sex)
subset_data$address   <- as.factor(subset_data$address)
subset_data$Pstatus   <- as.factor(subset_data$Pstatus)
subset_data$schoolsup <- as.factor(subset_data$schoolsup)
subset_data$romantic  <- as.factor(subset_data$romantic)

# Convert Ordinal variables (Defining order explicitly)
subset_data$Medu      <- factor(subset_data$Medu, ordered = TRUE, 
                                levels = 0:4, 
                                labels = c("None", "Primary", "5-9th Grade", "Secondary", "Higher"))
subset_data$studytime <- factor(subset_data$studytime, ordered = TRUE, 
                                levels = 1:4, 
                                labels = c("<2h", "2-5h", "5-10h", ">10h"))
subset_data$goout     <- factor(subset_data$goout, ordered = TRUE, levels = 1:5)

# Check structure
str(subset_data)

# ==============================================================================
# 2. UNIVARIATE ANALYSIS (Descriptive)
# ==============================================================================

# 2.1 Distribution of the Target Variable (G3 - Final Grade)
# Histogram
p1 <- ggplot(subset_data, aes(x = G3)) +
  geom_histogram(aes(y = ..density..), binwidth = 1, fill = "cornflowerblue", color = "black") +
  geom_density(color = "red", size = 1) +
  labs(title = "Distribution of Final Grades (G3)", x = "Grade (0-20)", y = "Density") +
  theme_minimal()

# 2.2 Frequency of Study Time
# Bar Chart
p2 <- ggplot(subset_data, aes(x = studytime)) +
  geom_bar(fill = "seagreen", color = "black") +
  geom_text(stat='count', aes(label=..count..), vjust=-0.5) +
  labs(title = "Count of Students by Study Time", x = "Study Time", y = "Count") +
  theme_minimal()

# Display Univariate plots side-by-side using patchwork
p1 + p2

# ==============================================================================
# 3. BIVARIATE ANALYSIS (No Hypothesis Testing)
# ==============================================================================

# ------------------------------------------------------------------------------
# 3.1 Nominal vs. Nominal: Romantic Relationship vs. School Support
# ------------------------------------------------------------------------------
# Objective: Compare proportions.

# Contingency Table (Counts)
counts_nom <- table(subset_data$romantic, subset_data$schoolsup)
print("Contingency Table (Counts):")
print(counts_nom)

# Proportional Table (Row Percentages)
prop_nom <- prop.table(counts_nom, margin = 1) 
print("Row Proportions (Romantic -> Support):")
print(round(prop_nom, 2))

# Visualization: 100% Stacked Bar Chart
ggplot(subset_data, aes(x = romantic, fill = schoolsup)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "School Support Distribution by Romantic Status",
       x = "Romantic Relationship", y = "Proportion", fill = "School Support") +
  theme_minimal()

# ------------------------------------------------------------------------------
# 3.2 Nominal vs. Metric: Address vs. Final Grade (G3)
# ------------------------------------------------------------------------------
# Objective: Compare measures of location (Mean/Median) and dispersion (IQR)

# Grouped Descriptive Statistics
subset_data %>%
  group_by(address) %>%
  summarise(
    Mean_G3 = mean(G3),
    Median_G3 = median(G3),
    SD_G3 = sd(G3),
    IQR_G3 = IQR(G3)
  ) %>%
  print()

# Visualization: Boxplot with Jitter
ggplot(subset_data, aes(x = address, y = G3, fill = address)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_jitter(width = 0.2, alpha = 0.3) +
  labs(title = "Final Grades: Urban (U) vs Rural (R)", 
       x = "Home Address", y = "Final Grade") +
  theme_minimal() +
  scale_fill_brewer(palette = "Pastel1")

# ------------------------------------------------------------------------------
# 3.3 Ordinal vs. Metric: Mother's Education vs. Final Grade (G3)
# ------------------------------------------------------------------------------
# Objective: Check for a trend.

# Grouped Statistics
medu_stats <- subset_data %>%
  group_by(Medu) %>%
  summarise(Mean_Grade = mean(G3))

print(medu_stats)

# Visualization: Boxplot with Mean Trend Line
ggplot(subset_data, aes(x = Medu, y = G3)) +
  geom_boxplot(fill = "lightblue") +
  # Add mean points to show the trend clearly
  stat_summary(fun = mean, geom = "point", shape = 18, size = 4, color = "red") +
  stat_summary(fun = mean, geom = "line", aes(group = 1), color = "red", linetype = "dashed") +
  labs(title = "Impact of Mother's Education on Student Grades",
       subtitle = "Red diamonds represent the Mean grade per group",
       x = "Mother's Education Level", y = "Final Grade") +
  theme_minimal()

# ------------------------------------------------------------------------------
# 3.4 Metric vs. Metric: Age vs. Absences
# ------------------------------------------------------------------------------
# Objective: Check correlation.

# Pearson Correlation
cor_age_abs <- cor(subset_data$age, subset_data$absences)
print(paste("Pearson Correlation (Age vs Absences):", round(cor_age_abs, 3)))

# Scatterplot with Linear Regression Line (Descriptive Model)
ggplot(subset_data, aes(x = age, y = absences)) +
  geom_point(alpha = 0.5, color = "purple") +
  geom_smooth(method = "lm", color = "black", se = FALSE) + # Line of Best Fit
  labs(title = "Relationship between Age and Absences",
       x = "Age", y = "Number of Absences") +
  theme_minimal()

# ------------------------------------------------------------------------------
# 3.5 Metric vs. Metric: Failures vs. Final Grade (G3) - Regression Analysis
# ------------------------------------------------------------------------------
# Objective: Quantify the impact of past class failures on current grade.

# 1. Linearity Check
ggplot(subset_data, aes(x = failures, y = G3)) +
  geom_jitter(width = 0.1, alpha = 0.4) + # Jitter used because 'failures' is discrete
  geom_smooth(method = "lm", color = "blue", se = FALSE) +
  labs(title = "Regression: Past Failures vs Final Grade",
       x = "Number of Past Class Failures", y = "Final Grade") +
  theme_minimal()

# 2. Linear Regression Model (Descriptive Output)
lm_failures <- lm(G3 ~ failures, data = subset_data)
model_summary <- summary(lm_failures)

# Display standard regression table
print(model_summary)

# Extract descriptive coefficients
cat("Intercept (Base Grade):", round(coef(lm_failures)[1], 2), "\n")
cat("Slope (Impact of 1 Failure):", round(coef(lm_failures)[2], 2), "\n")
cat("R-Squared (Explained Variance):", round(model_summary$r.squared, 4), "\n")

# ------------------------------------------------------------------------------
# 3.6 Multivariate Correlation Matrix (Numeric Variables)
# ------------------------------------------------------------------------------
# Select only numeric columns for matrix
numeric_vars <- subset_data %>% select(age, failures, absences, G3)

# Compute Correlation Matrix
cor_mat <- cor(numeric_vars)

# Visualization
corrplot(cor_mat, method = "color", type = "upper", 
         addCoef.col = "black", # Add numbers
         tl.col = "black", diag = FALSE,
         title = "Correlation Matrix of Numeric Variables", mar = c(0,0,2,0))