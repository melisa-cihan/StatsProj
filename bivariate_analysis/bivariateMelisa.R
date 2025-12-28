# ==============================================================================
# 0. SETUP AND DATA LOADING
# ==============================================================================
library(tidyverse)
library(corrplot) # For correlation matrix
library(knitr)    # For nice tables

# Load the new comma-separated dataset
data <- read.csv("/Users/melisacihan/Desktop/Statistical Computing/StatsProj/Student_Performance/student-mat-selected.csv")

# Convert variables to correct types for analysis
# Nominal
data$internet <- as.factor(data$internet)
data$higher   <- as.factor(data$higher)
data$sex      <- as.factor(data$sex)

# Ordinal (Explicitly ordered)
data$studytime <- factor(data$studytime, ordered = TRUE, levels = 1:4, 
                         labels = c("<2h", "2-5h", "5-10h", ">10h"))
data$Medu      <- factor(data$Medu, ordered = TRUE, levels = 0:4)

# ==============================================================================
# 2. ONE CONTINUOUS & ONE CATEGORICAL
# Variables: 'G3' (Final Grade) vs. 'higher' (Wants Higher Edu)
# ==============================================================================

# A. Summary Statistics (Mean, SD) grouped by Category
data %>%
  group_by(higher) %>%
  summarise(
    Mean_Grade = mean(G3),
    SD_Grade = sd(G3),
    Median_Grade = median(G3),
    Count = n()
  ) %>%
  print()

# B. Visualization: Grouped Boxplot
ggplot(data, aes(x = higher, y = G3, fill = higher)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Final Grade Distribution by Higher Education Goal",
       x = "Wants Higher Education?", 
       y = "Final Grade (0-20)") +
  theme_minimal() +
  theme(legend.position = "none")

# ==============================================================================
# BIVARIATE ANALYSIS: Final Grade (G3) vs. Internet Access
# ==============================================================================
# 2. Descriptive Statistics
# We calculate the Mean and Standard Deviation to check for a difference in central tendency.
internet_stats <- data %>%
  group_by(internet) %>%
  summarise(
    Count = n(),
    Mean_Grade = mean(G3),
    Median_Grade = median(G3),
    SD_Grade = sd(G3),
    Min_Grade = min(G3),
    Max_Grade = max(G3)
  )

print("--- Summary Statistics: Final Grade by Internet Access ---")
kable(internet_stats, caption = "Table: Impact of Internet Access on Grades")

# 3. Visualization: Grouped Boxplot
# This visualizes the spread and median differences clearly.
p1 <- ggplot(data, aes(x = internet, y = G3, fill = internet)) +
  geom_boxplot(alpha = 0.7, outlier.colour = "red", outlier.shape = 1) +
  
  # Add the Mean as a white diamond to see skewness (Mean vs Median)
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3, fill = "white") +
  
  labs(title = "Impact of Internet Access on Final Grades",
       subtitle = "White diamond indicates the Mean value",
       x = "Internet Access at Home",
       y = "Final Grade (0-20)") +
  theme_minimal() +
  scale_fill_manual(values = c("#E69F00", "#56B4E9")) + # Colorblind friendly palette
  theme(legend.position = "none")

# 4. Visualization: Density Plot
# This shows the "shape" of the grade distribution for both groups.
p2 <- ggplot(data, aes(x = G3, fill = internet)) +
  geom_density(alpha = 0.5) +
  labs(title = "Grade Density Distribution",
       x = "Final Grade",
       y = "Density") +
  theme_minimal() +
  scale_fill_manual(values = c("#E69F00", "#56B4E9"))

# Display plots
library(patchwork)
p1 + p2

# ==============================================================================
# 5. ORDINAL vs. NOMINAL: Mother's Education (Medu) vs. Higher Edu (higher)
# ==============================================================================
# Hypothesis: Students with highly educated mothers are more likely to want higher education.

# A. Contingency Table
# We look at the counts of students wanting higher edu across Medu levels
table_medu_higher <- table(data$Medu, data$higher)
print("--- Contingency Table: Medu vs Higher Edu ---")
print(table_medu_higher)

# B. Visualization: Stacked Bar Chart (100% Fill)
# This shows the PROPORTION of "yes" for higher edu within each Medu level
ggplot(data, aes(x = Medu, fill = higher)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Influence of Mother's Education on Higher Education Goals",
       subtitle = "Higher Medu levels show a larger proportion of students aiming for higher edu",
       x = "Mother's Education Level (0=None, 4=Higher)",
       y = "Proportion",
       fill = "Wants Higher Edu") +
  theme_minimal() +
  scale_fill_manual(values = c("grey70", "steelblue"))

# ==============================================================================
# 6. CATEGORICAL vs. NUMERIC: Activities vs. Final Grade (G3)
# ==============================================================================
# Hypothesis: Extra-curricular activities might improve grades (or distract).

# A. Summary Statistics
activities_stats <- data %>%
  group_by(activities) %>%
  summarise(
    Mean_G3 = mean(G3),
    Median_G3 = median(G3),
    SD_G3 = sd(G3),
    Count = n()
  )
print("--- Impact of Activities on Grades ---")
print(activities_stats)

# B. Visualization: Boxplot
ggplot(data, aes(x = activities, y = G3, fill = activities)) +
  geom_boxplot(alpha = 0.6) +
  stat_summary(fun = mean, geom = "point", shape = 20, size = 4, color = "white") +
  labs(title = "Final Grades: Activities vs No Activities",
       x = "Extra-curricular Activities",
       y = "Final Grade") +
  theme_minimal() +
  theme(legend.position = "none")

# ==============================================================================
# 7. SIMPLE LINEAR REGRESSION: Predicting G3 by Studytime
# ==============================================================================
# Objective: Check if G3 increases linearly as Studytime increases.

# A. Linearity Check
# Since studytime is Ordinal (Factor), we must convert it to Numeric (1,2,3,4) 
# to check for a linear trend.

# Create a temporary numeric version for plotting
data$studytime_num <- as.numeric(data$studytime)

# Scatterplot with Jitter (to see overlapping points) and Regression Line
ggplot(data, aes(x = studytime_num, y = G3)) +
  geom_jitter(width = 0.1, height = 0.5, alpha = 0.4, color = "darkgreen") +
  geom_smooth(method = "lm", color = "red", se = FALSE) + # Linear Fit
  scale_x_continuous(breaks = 1:4, labels = c("<2h", "2-5h", "5-10h", ">10h")) +
  labs(title = "Linearity Check: Study Time vs. Final Grade",
       subtitle = "Red line indicates the linear trend",
       x = "Weekly Study Time",
       y = "Final Grade") +
  theme_minimal()

# B. Simple Linear Regression Model
# We use the numeric version of studytime to get a single slope coefficient
lm_study <- lm(G3 ~ studytime_num, data = data)

print("--- Regression Output: G3 ~ Study Time ---")
print(summary(lm_study))

# Interpretation:
# Look at the 'Estimate' for studytime_num. 
# If it is e.g., 1.2, it means for every level jump in study time, 
# the grade increases by 1.2 points on average.

# ==============================================================================
# 9. NOMINAL vs. NUMERIC: Sex vs. Final Grade (G3)
# ==============================================================================
# Objective: Investigate if there is a significant difference in performance by gender.

# 1. Prepare Labels with Counts
# We calculate the number of students (n) for each sex to display on the plot
sex_counts_g3 <- data %>%
  group_by(sex) %>%
  summarise(
    count = n(),
    label = paste0(sex, "\n(n = ", count, ")") 
  )

# 2. Visualization: Boxplot with Jitter
ggplot(data, aes(x = sex, y = G3, fill = sex)) +
  # Boxplot shows the median and distribution
  geom_boxplot(alpha = 0.6, outlier.shape = NA) + 
  
  # Jitter shows the raw data points (helpful to see density)
  geom_jitter(width = 0.2, height = 0.1, alpha = 0.4, color = "grey30") +
  
  # Add the Mean as a white diamond
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3, fill = "white") +
  
  # Add text labels for the mean value
  stat_summary(fun = mean, geom = "text", aes(label = round(..y.., 2)), 
               vjust = -1.5, color = "black", fontface = "bold") +
  
  # LABELS & QUESTION
  labs(title = "Is There a Gender Gap in Final Grades?",
       subtitle = "Comparison of final grade distributions (mean values labeled)",
       x = "Gender",
       y = "Final Grade (0-20)",
       fill = "Gender") +
  
  # Apply the custom labels with counts to the X-axis
  scale_x_discrete(labels = setNames(sex_counts_g3$label, sex_counts_g3$sex)) +
  
  theme_minimal() +
  scale_fill_manual(values = c("pink3", "steelblue3")) +
  theme(legend.position = "none")

# ==============================================================================
# 10. ORDINAL vs. NOMINAL: Mother's Education vs. Paid Classes
# ==============================================================================
# Objective: Investigate if students with highly educated mothers are more likely 
# to have extra paid classes (potentially due to higher affordability or academic focus).

# 1. Contingency Table
# We look at the raw counts of paid classes across education levels
table_medu_paid <- table(data$Medu, data$paid)

print("--- Contingency Table: Medu vs Paid Classes ---")
print(table_medu_paid)

# Print Row Proportions (Percentages)
# This shows what % of mothers at each education level pay for classes
print("--- Proportions (Row-wise) ---")
print(round(prop.table(table_medu_paid, margin = 1), 2))

# 2. Visualization: Stacked Bar Chart (Percent)
ggplot(data, aes(x = Medu, fill = paid)) +
  # position = "fill" converts counts to percentages (0 to 1)
  geom_bar(position = "fill", alpha = 0.8) + 
  
  # Convert y-axis to readable percentages (0%, 25%, 50%...)
  scale_y_continuous(labels = scales::percent) +
  
  # LABELS & QUESTION
  labs(title = "Does Mother's Education Level Affect Paid Class Enrollment?",
       subtitle = "Proportion of students with paid classes across maternal education levels",
       x = "Mother's Education Level (0=None, 4=Higher Edu)",
       y = "Proportion of Students",
       fill = "Has Paid Classes") +
  
  theme_minimal() +
  scale_fill_manual(values = c("grey70", "steelblue")) # Distinct colors for Yes/No



# ==============================================================================
# 13. ORDINAL vs. ORDINAL: Travel Time vs. Study Time
# ==============================================================================
# Objective: See if travel time eats into study time.

ggplot(data, aes(x = factor(traveltime, labels = c("<15m", "15-30m", "30-60m", ">60m")), 
                 fill = studytime)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  
  labs(title = "The Trade-off: Travel Time vs. Study Time",
       subtitle = "Do students with longer commutes study less?",
       x = "Travel Time",
       y = "Proportion of Students",
       fill = "Weekly Study Time") +
  
  theme_minimal() +
  scale_fill_brewer(palette = "Blues")

# ==============================================================================
# 14. MULTIVARIATE ANALYSIS: Correlation Heatmap
# ==============================================================================
# Objective: Visualize relationships between all numeric and ordinal variables.

# 1. Select and Convert Variables
# We need a matrix of only numbers. We convert ordinal factors back to numbers.
numeric_data <- data %>%
  select(age, Medu, traveltime, studytime, failures, famrel, absences, G3) %>%
  mutate(
    # Ensure these are numeric for the correlation calculation
    Medu = as.numeric(Medu),
    traveltime = as.numeric(traveltime),
    studytime = as.numeric(studytime),
    famrel = as.numeric(famrel)
  )

# 2. Calculate Correlation Matrix
# use = "complete.obs" handles any missing values by removing the row
cor_matrix <- cor(numeric_data, use = "complete.obs", method = "pearson")

print("--- Correlation Matrix ---")
print(round(cor_matrix, 2))

# 3. Visualization: Correlation Heatmap (using corrplot)
library(corrplot)

# This creates a visual heat map where:
# Blue = Positive Correlation (Variables move together)
# Red = Negative Correlation (One goes up, the other goes down)
# Size/Intensity = Strength of the relationship

corrplot(cor_matrix, 
         method = "color",        # Use colored squares
         type = "lower",          # Show only the lower triangle (avoid duplicate info)
         addCoef.col = "black",   # Add the number (coefficient) on top
         tl.col = "black",        # Text label color
         tl.srt = 45,             # Rotate text labels
         diag = FALSE,            # Hide the diagonal (self-correlation is always 1)
         col = colorRampPalette(c("#D73027", "white", "#4575B4"))(200), # Red-White-Blue
         title = "Correlation Heatmap of Student Variables",
         mar = c(0,0,2,0)         # Fix margins for the title
)


# ==============================================================================
# 19. NUMERIC vs. ORDINAL: Age vs. Family Relationship (The "Rebellion" Hypothesis)
# ==============================================================================
# Objective: Investigate if family relationship quality deteriorates as students get older.

# 1. Data Preparation
# Convert 'famrel' to a Factor with descriptive labels for the plot
data$famrel_factor <- factor(data$famrel, levels = 1:5,
                             labels = c("Very Bad", "Bad", "Neutral", "Good", "Excellent"))

# 2. Visualization: Stacked Bar Chart (Proportions)
# We use position="fill" to compare the PERCENTAGE makeup of each age group
ggplot(data, aes(x = factor(age), fill = famrel_factor)) +
  geom_bar(position = "fill", width = 0.7) +
  scale_y_continuous(labels = scales::percent) +
  
  # LABELS & QUESTION
  labs(title = "Testing the 'Teenage Rebellion' Hypothesis",
       subtitle = "Does the proportion of 'Bad' relationships increase with age?",
       x = "Student Age",
       y = "Proportion of Students",
       fill = "Family Relationship") +
  
  theme_minimal() +
  scale_fill_brewer(palette = "RdYlGn") # Red=Bad, Green=Good (Intuitive colors)


# ==============================================================================
# 21. HEATMAP: Age vs. Family Relationship (The "Rebellion" Hypothesis)
# ==============================================================================
# Objective: Visualize if family relationships deteriorate as students age.

# 1. Data Preparation
# Group by Age and Family Relationship to get the count of students in each "cell"
rebellion_counts <- data %>%
  count(age, famrel)

# 2. Visualization: Red Heatmap
ggplot(rebellion_counts, aes(x = factor(age), y = factor(famrel), fill = n)) +
  # Create the tiles
  geom_tile(color = "white", lwd = 0.5) +
  
  # Add the numbers inside the tiles so you can see the exact count
  geom_text(aes(label = n), color = "black", size = 3) +
  
  # RED COLOR SCALE (Gradient from White to Dark Red)
  scale_fill_gradient(low = "#FFF5F0", high = "#CB181D") +
  
  # LABELS & QUESTION
  labs(title = "Testing the 'Rebellion Hypothesis' with Heatmap",
       subtitle = "Count of students by Age and Family Relationship (1=Very Bad, 5=Excellent)",
       x = "Student Age",
       y = "Family Relationship Quality",
       fill = "Student\nCount") +
  
  theme_minimal() +
  # Fix aspect ratio so tiles are square-ish
  coord_fixed(ratio = 1)

