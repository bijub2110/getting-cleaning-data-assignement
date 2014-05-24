# Refs
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# Tasks
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# cleanup data (except functions)
rm(list = setdiff(ls(), lsf.str()))

# fetch and unzip the data set
baseDir <- "."
dataDir <- paste(baseDir, "data", sep="/")
if(!file.exists(dataDir)){dir.create(dataDir)}
zipFilePath <- paste(dataDir, "Dataset.zip", sep="/")
zipFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file (zipFileUrl, zipFilePath, method="curl")
dateDownloaded <- date()
unzip (zipFile, exdir=baseDir)
list.files(baseDir)
cat ("Dataset downloaded on:", dateDownloaded,"\n")

# read the data sets
dataSetDir <-  paste (baseDir, "UCI HAR Dataset", sep="/")

trainLabelsPath <- paste (dataSetDir, "train", "y_train.txt", sep="/")
testLabelsPath <-  paste (dataSetDir, "test", "y_test.txt", sep="/")
trainLabels <- read.table(trainLabelsPath, header = FALSE) 
testLabels  <- read.table(testLabelsPath, header = FALSE)
str(trainLabels)
str(testLabels)
table(trainLabels)
table(testLabels)

trainSubjectsPath <- paste (dataSetDir, "train", "subject_train.txt", sep="/")
testSubjectsPath <-  paste (dataSetDir, "test", "subject_test.txt", sep="/")
trainSubjects <- read.table(trainSubjectsPath, header = FALSE) 
testSubjects  <- read.table(testSubjectsPath, header = FALSE)
str(trainSubjects)
str(testSubjects)
table(trainSubjects)
table(testSubjects)

trainSetPath <- paste (dataSetDir, "train", "X_train.txt", sep="/")
testSetPath <-  paste (dataSetDir, "test", "X_test.txt", sep="/")
trainSet <- read.table(trainSetPath, header = FALSE) 
testSet  <- read.table(testSetPath, header = FALSE)
dim(trainSet)
dim(testSet)

# merge vertically, adding rows but keeping same columns
mergedSet <- rbind(trainSet,testSet)
dim(mergedSet)

mergedLabels <- rbind(trainLabels,testLabels)
dim(mergedLabels)

mergedSubjects <- rbind(trainSubjects,testSubjects)
dim(mergedSubjects)

# get feature and activity labels
featuresPath <-  paste (dataSetDir, "features.txt", sep="/")
activitiesPath <-  paste (dataSetDir, "activity_labels.txt", sep="/")

features <- read.table(featuresPath, header = FALSE) 
activities  <- read.table(activitiesPath, header = FALSE)
colnames(features) <- c("Feature_code","Feature_str")
colnames(activities) <- c("Activity_code","Activity_str")
str(features)
str(activities)
features
activities

# renames columns
colnames(mergedSet) <- features$Feature_str
names(mergedSet)
str(mergedSet)

# keep names with mean or std
mean_std <- names(mergedSet)[grep("mean|std", names(mergedSet))]
mean_std
mergedSet <- mergedSet[,mean_std]
dim(mergedSet)

# add subject and activities
mergedSet$Subject <- mergedSubjects
mergedSet$Activity_code <- mergedLabels
dim(mergedSet)
table(mergedSet$Subject)
table(mergedSet$Activity_code)
colnames(mergedSet)

# add descriptors to the merged dataset
# v1 ... replaced by feature name
# $Activity becomes a factor
str(mergedSet$Activity_code)
mergedSet$Activity_str = apply (mergedSet[,"Activity_code"],1,function(x) activities[x,2])
table(mergedSet$Activity_code)
table(mergedSet$Activity_str)
str(mergedSet$Activity_str)
dim(mergedSet)  
