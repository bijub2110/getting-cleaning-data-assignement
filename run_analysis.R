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
if (!file.exists(zipFilePath)) {
  download.file (zipFileUrl, zipFilePath, method="curl")
  dateDownloaded <- date()
  unzip (zipFile, exdir=baseDir)
  cat ("Dataset downloaded on:", dateDownloaded,"\n")
}
list.files(baseDir)

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

# 1. merge vertically, adding rows but keeping the same columns
mergedSet <- rbind(trainSet,testSet)
dim(mergedSet)
#str(mergedSet)

mergedLabels <- rbind(trainLabels,testLabels)
dim(mergedLabels)
str(mergedLabels)

mergedSubjects <- rbind(trainSubjects,testSubjects)
dim(mergedSubjects)
str(mergedSubjects)

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

# 2. keep names with mean or std
mean_std <- names(mergedSet)[grep("mean\\(\\)|std\\(\\)", names(mergedSet))]
mean_std
mergedSet <- mergedSet[,mean_std]
dim(mergedSet)

# add subject and activities
mergedSet = cbind(Subject = mergedSubjects[,1], Activity = mergedLabels[,1], mergedSet)
str(mergedSet$Subject)
str(mergedSet$Activity)
dim(mergedSet)
table(mergedSet$Subject)
table(mergedSet$Activity)
colnames(mergedSet)

# add descriptors to the merged dataset
# v1 ... replaced by feature name
# $Activity becomes a factor
str(mergedSet$Activity)
mergedSet$Activity <- apply (mergedSet["Activity"],1,function(x) activities[x,2])
table(mergedSet$Activity)
str(mergedSet$Activity)
dim(mergedSet)  

# aggregate and calculate mean of subject,activity
length(mergedSet$Subject)
length(mergedSet$Activity)
head(mergedSet[,3:ncol(mergedSet)])
tidy <- aggregate(mergedSet,by=list(mergedSet$Subject,mergedSet$Activity),mean)
dim(tidy)
tidyPath <- paste(dataDir, "tidy.txt", sep="/")
write.table(tidy, tidyPath, sep="\t")