This code book describes the variables, the data and any transformations or work performed to clean up the initial data.

The purpose of this project is to demonstrate the ability to collect, work with and clean a data set. The goal is to prepare tidy data (tidy_Data.txt) that can be used for later analysis. 

This Github repository contains:

1. a tidy data set (tidy_Data.txt),
2. a script for performing the analysis (run_analysis.R),
3. a code book (CodeBook.md) that describes the variables, the data and any transformations or work performed to clean up the initial data,
4. a README.md. This repo explains how all of the scripts work and how they are connected.

The data used in this project represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The R script, run_analysis.R, does the following:

1. Merge the training and the test sets to create one data set,
2. Extract only the measurements on the mean and standard deviation for each measurement,
3. Use descriptive activity names to name the activities in the data set,
4. Label the data set with descriptive variable names,
5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

In order to perform the above actions, the following steps are required:

0. Prior steps:
	0.1. Create the "data" folder if it doesn't already exist and download zip file
	0.2. Download the data set 
	0.3. Load the dplyr library that will be used in step #5
	0.4. Extract the files from the compressed zip file

1. Merge the training and the test sets to create one data set:
	1.1. Load the training files (subject_train.txt, y_train.txt, X_train.txt) into R
	1.2. Load the test files (subject_test.txt, y_test.txt, X_test.txt) into R
	1.3. Combine the 3 training data sets (subjectTrain, yTrain, XTrain) by column
		# trainData contains 7352 rows and 563 columns
	1.4. Combine the 3 test data sets (subjectTest, yTest, XTest) by column
		# testData contains 2947 rows and 563 columns
	1.5. Combine the 2 above resulting data sets (trainData, testData) by row
		# allData contains 10299 rows and 563 columns

2. Extract only the measurements on the mean and standard deviation for each measurement:
	2.1. Load feature names, 2nd column of the features.txt file, into R
	2.2. Load feature identifiers, 1st column of the features.txt file, into R
	2.3. Use the grep function (with proper parameters) on the featuresNames data set (which only contains the names) to extract the column's headers matching the mean and standard deviation
		# 66 columns matching the mean and standard deviation
	2.4. Store all the measurements on the mean and standard deviation into a new data set, selectedData ("+2" since there're 2 columns in the allData data set prior the actual measurements)
		# selectedData contains 10286 rows and 68 columns
	2.5. Assign descriptive column headers to the selectedData data set (#1 being the subject ID, #2, the activity type, the other columns the mean and standard deviation previously selected)

3. Use descriptive activity names to name the activities in the data set:
	3.1. Load the activity labels file (activity_labels.txt) into R (column #1: activity identifers, column #2: activity labels)
		# activity_labels.txt has 6 rows, 2 columns (1st: activity identifiers, 2nd: activity labels)
	3.2. Replace the activity identifiers (from 1 to 6) with the activity labels (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) in the selectedData data set

4. Appropriately label the data set with descriptive variable names:
	4.1. Replace the letter "t" at the beginning of the variable nanes with the word "time" so it's more meaningful
	4.2. Replace the letter "f" at the beginning of the variable nanes with the word "frequence" so it's more meaningful
	4.3. Remove the parenthesis from variable names
	4.4. Remove the dash symbol from variable names for the mean
	4.5. Remove the dash symbol from variable names for the standard deviation 

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject:
	5.1. Create a new data set, "tidyData", for which the mean for each variable is grouped by subject and activity
		# tidyData contains 180 rows ((6 rows per subject identifier x 30 subjects) + column headers) and 68 columns (suject, activity, various means and standard deviation).
	5.2. Write the new data set, "tidyData", to the file system (tidy_Data.txt)

Files information

activity_labels.txt: 6 rows, 2 columns (activity identifiers, activity labels)
features_info.txt: information about the feature selection and the method to collect them
features.txt: 561 rows, 2 columns (feature identifiers, feature names)

In the test folder
- subject_test.txt: 2947 rows, 1 column (list of 9 out of 30 subject identifiers)
- X_test.txt: 2947 rows, 561 columns (measurements for all the features)
- y_test: 2947 rows, 1 column (list of activity identifiers)

In the train folder
- subject_train.txt : 7352 rows, 1 column (list of 21 out of 30 subject identifiers)
- X_train.txt : 7352 rows, 561 columns (measurements for all the features)
- y_train <- test/y_train.txt : 7352 rows, 1 columns (list of activity identifiers)