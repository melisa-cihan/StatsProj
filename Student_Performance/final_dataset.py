import pandas as pd

# Read the student performance dataset (semicolon-separated)
data = pd.read_csv('student-mat.csv', sep=';')

# Select only the columns of interest
selected_columns = [
    'sex', 'age', 'Medu', 'traveltime', 'studytime', 
    'failures', 'paid', 'activities', 'higher', 'internet', 
    'famrel', 'absences', 'G3'
]

# Create a new dataframe with only selected columns
data_selected = data[selected_columns]

# Save the filtered dataset to a new CSV file
data_selected.to_csv('student-mat-selected.csv', index=False)

# Print confirmation and basic info
print(f"Original dataset shape: {data.shape}")
print(f"Selected dataset shape: {data_selected.shape}")
print(f"\nSelected columns: {list(data_selected.columns)}")
print(f"\nNew file 'student-mat-selected.csv' has been created successfully!")
print(f"\nFirst few rows of the selected dataset:")
print(data_selected.head())

