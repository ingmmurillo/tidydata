library(plyr); library(dplyr)

run <- function() {
    prepareDataSet()
    tidyData <- createTidyDataSet(mergeData())
}

prepareDataSet <- function() {
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    fileName <- "getdata-projectfiles-UCI HAR Dataset.zip"
    directoryName <- "UCI HAR Dataset"
    if (!file.exists(fileName) & !dir.exists(directoryName)) {
        print("Downloading and unzipping Data Set...")
        download.file(url = fileURL, destfile = fileName, method = "curl")
        unzip(fileName)   
    } else {
        print("Data Set already downloaded and unzipped")
    }
}

mergeData <- function() {
    print("Merging Data Set...")
    labelsFile <- "./UCI HAR Dataset/features.txt"
    activityLabelsFile <- "./UCI HAR Dataset/activity_labels.txt"
    
    testXDataFile <- "./UCI HAR Dataset/test/X_test.txt"
    testYDataFile <- "./UCI HAR Dataset/test/y_test.txt"
    testSubjectDataFile <- "./UCI HAR Dataset/test/subject_test.txt"
    
    trainXDataFile <- "./UCI HAR Dataset/train/X_train.txt"
    trainYDataFile <- "./UCI HAR Dataset/train/y_train.txt"
    trainSubjectDataFile <- "./UCI HAR Dataset/train/subject_train.txt"
    
    labels <- read.table(labelsFile, 
                         col.names = c("id", "label"),
                         colClasses = c("integer", "character"))
    labels <- rbind(labels, list(562, "subject"))
    labels <- rbind(labels, list(563, "activity_id"))
    activityLabels <- read.table(activityLabelsFile, 
                                 col.names = c("activity_id","activity"))
    
    testXData <- read.table(testXDataFile)
    testYData <- read.table(testYDataFile)
    testSubjectData <- read.table(testSubjectDataFile)
    testXData <- cbind(testXData, testSubjectData)
    testData <- cbind(testXData, testYData)
    
    trainXData <- read.table(trainXDataFile)
    trainYData <- read.table(trainYDataFile)
    trainSubjectData <- read.table(trainSubjectDataFile)
    trainXData <- cbind(trainXData, trainSubjectData)
    trainData <- cbind(trainXData, trainYData)
    
    data <- rbind(testData, trainData)
    colnames(data) <- as.list(t(select(labels, label)))
    data <- join(data, activityLabels, by = "activity_id")
    return(data)
}

createTidyDataSet <- function(data) {
    print("Creating Tidy Data Set...")
    validColumnNames <- make.names(names = names(data), unique = TRUE, allow_ = TRUE)
    names(data) <- validColumnNames
    tidyData <- select(data, subject, activity, contains(".mean.."), contains(".std.."))
    names(tidyData) <- gsub("\\.", "", names(tidyData))
    names(tidyData) <- gsub("mean", "MEAN", names(tidyData))
    names(tidyData) <- gsub("std", "STDEV", names(tidyData))
    names(tidyData) <- gsub("Acc", "Accelerometer", names(tidyData))
    names(tidyData) <- gsub("Gyro", "Gyroscope", names(tidyData))
    names(tidyData) <- gsub("Mag", "Magnitude", names(tidyData))
    View(tidyData)
}