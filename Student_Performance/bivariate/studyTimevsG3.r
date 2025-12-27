# Load necessary libraries
rm(list = ls(all.names = TRUE))
library(ggplot2)

# 1. Load the dataset
# Replace 'student-mat.csv' with your actual filename. 
# Note: The UCI dataset often uses semicolons (sep=";")
df <- read.csv("/Users/hrusheekeshsawarkar/Projects/StatsProj/Student_Performance/student-mat-selected.csv", sep=",")
print("studytime" %in% names(df))
names(df)
# 2. Process 'studytime' as an ordered factor
df$studytime <- factor(df$studytime, 
                       levels = c(1, 2, 3, 4),
                       labels = c("<2 hours", "2-5 hours", "5-10 hours", ">10 hours"))

##### Study time vs G3
# 3. Create the Box Plot with variable width
ggplot(df, aes(x = studytime, y = G3, fill = studytime)) +
  # varwidth = TRUE makes the box width proportional to the square root of 
  # the number of observations in that group.
  geom_boxplot(varwidth = TRUE, outlier.colour = "red", alpha = 0.7) +
  # Add jittered points to see the individual "density" of students
  geom_jitter(color = "black", size = 0.4, alpha = 0.3, width = 0.1) +
  # Aesthetics and Labels
  labs(title = "Final Grade Distribution by Study Time",
       subtitle = "Box width is proportional to the number of students in each group",
       x = "Weekly Study Time",
       y = "Final Grade (G3)",
       fill = "Study Time") +
  theme_minimal() +
  scale_fill_brewer(palette = "Pastel1")




#####  famrel vs failiure
# 1. Ensure the variables are treated correctly
df$famrel <- factor(df$famrel, 
                    levels = 1:5, 
                    labels = c("Very Bad", "Bad", "Fair", "Good", "Excellent"))

# 2. Create a frequency table and convert to a dataframe for ggplot
relation_table <- as.data.frame(table(df$famrel, df$failures))
names(relation_table) <- c("FamilyRel", "Failures", "Count")

# 3. Plot the Heatmap
ggplot(relation_table, aes(x = FamilyRel, y = Failures, fill = Count)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "white", high = "firebrick") +
  geom_text(aes(label = Count), color = "black") + # Adds the actual number of students
  labs(title = "Bivariate Analysis: Family Relationships vs. Past Failures",
       subtitle = "Checking if household quality correlates with academic history",
       x = "Quality of Family Relationship",
       y = "Number of Past Failures",
       fill = "Student Count") +
  theme_minimal()



##### failiure vs absences
# 1. Ensure 'failures' is a factor for grouping
df$failures <- as.factor(df$failures)

# 2. Create the plot
library(ggplot2)
ggplot(df, aes(x = failures, y = absences, fill = failures)) +
  # Use a box plot to show the distribution of absences for each failure count
  geom_boxplot(outlier.colour = "red", alpha = 0.6) +
  # Add jittered points to see the individual students
  geom_jitter(width = 0.2, alpha = 0.2) +
  # Add a horizontal line for the overall median absences for context
  geom_hline(yintercept = median(df$absences), linetype = "dashed", color = "blue") +
  labs(title = "Bivariate Analysis: Absences vs. Past Failures",
       subtitle = "Does academic failure correlate with higher school absenteeism?",
       x = "Number of Past Class Failures",
       y = "Number of School Absences",
       caption = "Dashed blue line represents overall median absences") +
  theme_minimal() +
  scale_fill_brewer(palette = "YlOrRd")



##### paid vs g3
# 1. Ensure 'paid' is a factor for clear labeling
df$paid <- factor(df$paid, levels = c("no", "yes"), labels = c("No Extra Paid Classes", "Extra Paid Classes"))

# 2. Create the Overlaid Density Plot
library(ggplot2)
ggplot(df, aes(x = G3, fill = paid)) +
  # Use geom_density with transparency (alpha) to see where they overlap
  geom_density(alpha = 0.5) +
  # Add a vertical line for the mean of each group
  geom_vline(data = aggregate(G3 ~ paid, df, mean), 
             aes(xintercept = G3, color = paid), linetype = "dashed", size = 1) +
  labs(title = "Bivariate Analysis: Impact of Extra Paid Classes on Final Grade",
       subtitle = "Comparing the density distribution of G3 grades",
       x = "Final Grade (G3)",
       y = "Density",
       fill = "Paid Support",
       color = "Paid Support") +
  theme_minimal() +
  scale_fill_manual(values = c("No Extra Paid Classes" = "#E41A1C", "Extra Paid Classes" = "#377EB8")) +
  scale_color_manual(values = c("No Extra Paid Classes" = "#E41A1C", "Extra Paid Classes" = "#377EB8"))







