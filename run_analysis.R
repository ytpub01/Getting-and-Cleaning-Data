url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(url, temp)
unzip(temp)
unlink(temp)
library(tidyverse)
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subjects_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subjects_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)
#1. Merges the training and the test sets to create one data set.
X<-bind_rows(X_train, X_test)
subjects<-bind_rows(subjects_train, subjects_test)
y<-bind_rows(y_train, y_test)
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
features_mean_std <- filter(features, str_detect(V2, 'mean\\(\\)|std\\(\\)'))
X<-select(X, features_mean_std$V1)
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
colnames(X)<-features_mean_std$V2
subjects<-rename(subjects, subject=1)
y<-rename(y, activity = 1)
y$label<-factor(y$activity, labels = activity_labels$V2)
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
td<-bind_cols(X, select(y,label), subjects)
td_means <- summarize(group_by(td, subject, label), across(1:66, mean))
write.table(td_means, file = "tidy_dataset.txt", append=FALSE, row.names=FALSE)
