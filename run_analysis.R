run <- function() {
    prepareDataSet()
}

prepareDataSet <- function() {
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    fileName <- "getdata-projectfiles-UCI HAR Dataset.zip"
    directoryName <- "UCI HAR Dataset"
    if (!file.exists(fileName) & !dir.exists(directoryName)) {
        print("Downloading and unzipping data set...")
        download.file(url = fileURL, destfile = fileName, method = "curl")
        unzip(fileName)   
    } else {
        print("Data Set already downloaded and unzipped")
    }
}