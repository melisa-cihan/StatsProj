# Raju Ahmed - Video Recording Script (10 Minutes)

## 1. Transition & Introduction (≈30 seconds)

**Screen: Report - Section 2.5 (Binary Variables)**

Hello, my name is Raju Ahmed.

Following Kezia's introduction and analysis of the final grade, absences, past failures, and study time variables, I will now continue with my sections.

I will be presenting the univariate analysis of binary variables, ordinal variables, and a numeric variable.

I will also cover the bivariate analysis examining the relationship between mother's education and final grades.

Let me begin with the binary variables.

---

## 2. Binary Variables: Paid Extra Classes, Higher Education Aspiration, Internet Access (≈2–2.5 minutes)

**Screen: Report Figure 5 - Binary Variables Grouped Bar Chart**

The first set of variables I analysed are three binary nominal variables: paid extra classes, higher education aspiration, and internet access.

These variables capture important aspects of student support, motivation, and resource availability.

### Paid Extra Classes

Starting with paid extra classes, this variable indicates whether a student takes additional paid tutoring in Mathematics outside of school.

Looking at the bar chart, we can see that 181 students, which is about 45.8%, take paid extra classes, while 214 students, or 54.2%, do not.

This tells us that less than half of the students invest in additional paid tutoring.

This is an interesting finding because it suggests that while paid tutoring is common, it is not the dominant approach to supplementary learning in this population.

### Higher Education Aspiration

The second binary variable is higher education aspiration, which asks whether students want to pursue higher education after secondary school.

Here we see a striking pattern: 375 students, an overwhelming 94.9%, aspire to higher education, while only 20 students, just 5.1%, do not.

This near-universal aspiration is remarkable and suggests a highly motivated student population.

It also implies that the students in this dataset have strong educational goals, which could positively influence their academic performance.

### Internet Access

The third binary variable is internet access at home.

The data shows that 329 students, or 83.3%, have internet access, while 66 students, about 16.7%, do not.

In today's educational context, internet access is increasingly important for research, online learning resources, and completing assignments.

The fact that about one in six students lacks internet access at home is noteworthy and could potentially be a disadvantage for these students.

**Interpretation Summary:**

To summarize the binary variables: paid tutoring is moderately common, nearly all students aspire to higher education, and internet access is available to the majority but not all students.

---

## 3. Ordinal Variables: Mother's Education and Family Relationship (≈2.5–3 minutes)

**Screen: Report Section 2.6 - Figure 6: Distribution of Ordinal Variables**

Next, I analysed two ordinal variables: mother's education level and family relationship quality.

### Mother's Education (Medu)

Mother's education is measured on a scale from 0 to 4:
- 0 means no formal education
- 1 represents primary education, up to 4th grade
- 2 represents 5th to 9th grade
- 3 represents secondary education
- 4 represents higher education

Looking at the left bar chart, we can observe a clear pattern.

The distribution is skewed toward higher education levels.

Only 3 mothers have no formal education at all, which is less than 1% of the sample.

The mode is 4, meaning the most common category is higher education, with 131 mothers.

The median is 3, indicating that at least half of the mothers have secondary education or above.

This tells us that the students in this dataset generally come from families where mothers have relatively high educational attainment.

This is important because parental education, particularly mother's education, is often associated with children's academic outcomes, a relationship we will explore later in the bivariate analysis.

### Family Relationship Quality (Famrel)

The second ordinal variable is family relationship quality, measured on a scale from 1 to 5:
- 1 represents very bad relationships
- 2 is bad
- 3 is neutral
- 4 is good
- 5 is excellent

Looking at the right bar chart, we see that family relationships are predominantly positive.

The mode is 4, meaning "good" relationships, with 195 students, which is the largest group.

The median is also 4, confirming that the typical student reports good family relationships.

If we combine categories 4 and 5, over 71% of students report good to excellent family relationships.

Very few students, only 8, report very bad relationships.

This suggests that most students in the sample have supportive home environments, which could be beneficial for their academic performance and well-being.

---

## 4. Numeric Variable: Age (≈2 minutes)

**Screen: Report Section 2.7 - Figure 7: Age Distribution**

Now I will present the analysis of age, which is a numeric discrete variable.

### Descriptive Statistics

The sample includes 395 students with ages ranging from 15 to 22 years.

The mean age is 16.70 years, while the median is 17, and the mode is 16.

The standard deviation is 1.28 years, indicating relatively low variability in age.

The interquartile range is just 2 years, further confirming that most students fall within a narrow age band.

### Distribution Analysis

Looking at the histogram on the left, we can see that the distribution is slightly right-skewed.

The majority of students are concentrated in the typical secondary school age range of 15 to 18 years.

The red dashed line shows the mean at 16.70 years.

The boxplot on the right reveals potential outliers at the upper end, specifically students aged 19 to 22.

### Interpretation

The presence of older students, those aged 19 to 22, is noteworthy.

In a typical secondary school setting, students would normally be between 15 and 18 years old.

Older students may have repeated grades due to past academic difficulties, or they might have entered the school system later.

This is an important consideration because age could potentially be related to past failures and overall academic performance.

The low variability in age, with an IQR of only 2 years, tells us that despite some outliers, the student population is relatively homogeneous in terms of age.

---

## 5. Bivariate Analysis: Mother's Education vs Final Grade (≈2–2.5 minutes)

**Screen: Report Section 3.1 - Figure 8: Final Grade by Mother's Education**

Finally, I will present the bivariate analysis examining the relationship between mother's education and students' final Mathematics grade, G3.

### Why This Relationship?

I chose to investigate this relationship because educational research consistently shows that parental education, especially mother's education, is one of the strongest predictors of children's academic success.

Mothers with higher education may provide more academic support, have higher expectations, and create environments more conducive to learning.

### Statistical Analysis

To measure the strength of this relationship, I used Spearman's correlation coefficient.

Spearman correlation is appropriate here because mother's education is an ordinal variable, and we cannot assume a linear relationship between the categories.

The Spearman correlation coefficient is r = 0.225, indicating a weak but positive relationship.

### Examining the Pattern

Looking at the summary table on the left, we can see how mean grades vary across education levels.

However, I want to highlight an important caveat: the mean grade for Medu = 0, which is 13.0, appears unusually high.

This is actually a small sample artifact, as there are only 3 mothers with no formal education.

With such a small sample, the mean is not reliable and should be interpreted with caution.

Excluding this group, we see a clear and consistent pattern:
- Students whose mothers have primary education have a mean grade of 8.68
- Those with mothers who completed 5th to 9th grade score 10.17 on average
- Secondary education corresponds to a mean of 10.32
- And higher education is associated with the highest mean grade of 11.76

### Interpretation

The boxplot on the right visualizes this pattern clearly.

As mother's education increases, we see a general upward trend in the median final grade, along with the distribution shifting higher.

While the correlation of 0.225 is considered weak, it is still meaningful in an educational context.

This suggests that mother's education is a relevant predictor of student performance, though certainly not the only factor.

Other variables such as study time, absences, and personal motivation likely also play important roles.

---

## 6. Wrap-Up (≈30 seconds)

**Screen: Report conclusion section**

To summarize my analysis:

For the binary variables, we found that paid tutoring is moderately common, nearly all students aspire to higher education, and most have internet access at home.

For ordinal variables, mother's education tends to be high in this sample, and family relationships are predominantly positive.

For age, students are concentrated in the typical 15 to 18 age range, with some older students who may have repeated grades.

Finally, the bivariate analysis revealed a weak but positive correlation between mother's education and final grades, supporting the idea that family educational background plays a role in student academic performance.

These findings provide valuable context for understanding the factors associated with student success.

In the next video, Hrusheekesh will continue with additional bivariate analyses.

Thank you for watching.

---

## Timing Summary

| Section | Duration |
|---------|----------|
| Introduction | ~30 sec |
| Binary Variables | ~2–2.5 min |
| Ordinal Variables | ~2.5–3 min |
| Numeric Variable (Age) | ~2 min |
| Bivariate Analysis | ~2–2.5 min |
| Wrap-Up | ~30 sec |
| **Total** | **~10 minutes** |
