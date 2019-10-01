###################
# 0. Prior steps. #
###################

# Create the "data" folder if it doesn't already exist and download zip file
if(!file.exists("./data")) {dir.create("./data")}

# Download the data set 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/projectData.zip")

# Load the dplyr library that will be used in step #5
library(dplyr)

# Extract the files from the compressed zip file
zipFiles <- unzip("./data/projectData.zip", exdir = "./data")

###################################################################
# 1. Merge the training and the test sets to create one data set. #
###################################################################

# Load the training files (subject_train.txt, y_train.txt, X_train.txt) into R
subjectTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
yTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
XTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")

# Combine the 3 training data sets (subjectTrain, yTrain, XTrain) by column
trainData <- cbind(subjectTrain, yTrain, XTrain)

# trainData contains 7352 rows and 563 columns

# Load the test files (subject_test.txt, y_test.txt, X_test.txt) into R
subjectTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
yTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
XTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")

# Combine the 3 test data sets (subjectTest, yTest, XTest) by column
testData <- cbind(subjectTest, yTest, XTest)

# testData contains 2947 rows and 563 columns

# Combine the 2 above resulting data sets (trainData, testData) by row
allData <- rbind(trainData, testData)

# allData contains 10299 rows and 563 columns

#############################################################################################
# 2. Extract only the measurements on the mean and standard deviation for each measurement. #
#############################################################################################

# Load feature names, 2nd column of the features.txt file, into R
featureNames <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]

# Load feature identifiers, 1st column of the features.txt file, into R
featureIds <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,1]

# Use the grep function (with proper parameters) on the featuresNames data set (which only contains the names) to extract the column's headers matching the mean and standard deviation
selectedFeatures <- grep("mean\\(\\)|std\\(\\)", featureNames)

# 66 columns matching the mean and standard deviation

# Store all the measurements on the mean and standard deviation into a new data set, selectedData ("+2" since there're 2 columns in the allData data set prior the actual measurements)
selectedData <- allData[, c(1, 2, selectedFeatures+2)]

# selectedData contains 10286 rows and 68 columns

# Assign descriptive column headers to the selectedData data set (#1 being the subject ID, #2, the activity type, the other columns the mean and standard deviation previously selected)
colnames(selectedData) <- c("subject", "activity", featureNames[selectedFeatures])

#############################################################################
# 3. Use descriptive activity names to name the activities in the data set. #
#############################################################################

# Load the activity labels file (activity_labels.txt) into R (column #1: activity identifers, column #2: activity labels)
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# activity_labels.txt has 6 rows, 2 columns (1st: activity identifiers, 2nd: activity labels)

# Replace the activity identifiers (from 1 to 6) with the activity labels (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) in the selectedData data set
selectedData$activity <- factor(selectedData$activity, levels = activityLabels[,1], labels = activityLabels[,2])

########################################################################
# 4. Appropriately label the data set with descriptive variable names. #
########################################################################

# Replace the letter "t" at the beginning of the variable nanes with the word "time" so it's more meaningful
names(selectedData) <- gsub("^t", "time", names(selectedData))

# Replace the letter "f" at the beginning of the variable nanes with the word "frequence" so it's more meaningful
names(selectedData) <- gsub("^f", "frequence", names(selectedData))

# Remove the parenthesis from variable names
names(selectedData) <- gsub("\\()", "", names(selectedData))

# Remove the dash symbol from variable names for the mean
names(selectedData) <- gsub("-mean", "Mean", names(selectedData))

# Remove the dash symbol from variable names for the standard deviation 
names(selectedData) <- gsub("-std", "Std", names(selectedData))

#####################################################################################################################################################
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. #
#####################################################################################################################################################

# Create a new data set, "tidyData", for which the mean for each variable is grouped by subject and activity
tidyData <- selectedData %>% group_by(subject, activity) %>% summarise_each(funs(mean))

# tidyData contains 180 rows ((6 rows per subject identifier x 30 subjects) + column headers) and 68 columns (suject, activity, various means and standard deviation).

# Write the new data set, "tidyData", to the file system
write.table(tidyData, "./data/UCI HAR Dataset/tidy_Data.txt", row.names = FALSE)