# Load the dplyr library that will be used in step #5
library(dplyr)

# 1. Merge the training and the test sets to create one data set.

# Create the "data" folder if it doesn't already exist and download zip file
if(!file.exists("./data")) {dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/projectData.zip")

# Extract the files from the compressed zip file
zipFiles <- unzip("./data/projectData.zip", exdir = "./data")

# Load the training data set into R
subjectTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
yTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
XTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")

# Load the test data sets into R
subjectTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
yTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
XTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")

# Combine the 3 training files by column
trainData <- cbind(subjectTrain, yTrain, XTrain)

# Combine the 3 test files by column
testData <- cbind(subjectTest, yTest, XTest)

# Combine the 2 above resulting data sets (trainData and testData) by row
allData <- rbind(trainData, testData)

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 

# Read feature names into R
featureNames <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]

# Read feature identifiers into R
featureIds <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,1]

# 2. Extract only the measurements on the mean and standard deviation for each measurement.

# Apply the grep function on the featuresNames data set (which only contains the names)
selectedFeatures <- grep("mean\\(\\)|std\\(\\)", featureNames)

# Store all the measurements on the mean and standard deviation into a new data set, selectedData ("+2" because there're 2 columns in the fullData dataset before the actual measurements)
selectedData <- allData[, c(1, 2, selectedFeatures+2)]

# Assign descriptive column headers (#1: subject ID, #2: activity type, measurements on the mean and standard deviation)
colnames(selectedData) <- c("subject", "activity", featureNames[selectedFeatures])

# 3. Use descriptive activity names to name the activities in the data set.

# Read activity labels into R (column #1: activity_identifers, column #2: activity_labels)
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# Replace activity identifiers (from 1 to 6) with activity labels
selectedData$activity <- factor(selectedData$activity, levels = activityLabels[,1], labels = activityLabels[,2])

# 4. Appropriately label the data set with descriptive variable names

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

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

# Create a new data set, "meanData", for which the mean for each variable is grouped by subject and activity
meanData <- selectedData %>% group_by(subject, activity) %>% summarise_each(funs(mean))

# Write the new data set, "meanData", to the file system
write.table(meanData, "./data/UCI HAR Dataset/mean_Data.txt", row.names = FALSE)