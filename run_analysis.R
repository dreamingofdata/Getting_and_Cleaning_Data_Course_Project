##################################################################
#run_anaysis.R
#
# Written to fullfill Course Project Requirement for
# Coursera "Getting and Cleaning Data"
# https://class.coursera.org/getdata-031/human_grading/view/courses/975115/assessments/3/submissions
# Author: Bill Kimler
# Submitted: 2015-08-23
##################################################################

#Assumes working directory is the UCI HAR Dataset

library(plyr)   #needed for join
library(dplyr)  #needed for select, summarise_each, group_by

# Grab list of the variable labels found in the subsequent X data sets
features_labels <- read.csv("features.txt", 
                            header=FALSE, 
                            sep = "", 
                            stringsAsFactors=FALSE, 
                            col.names=c("index","feature"))

# Read in test data (X, y and subject)
X_test <- read.csv("./test/X_test.txt", 
                   header=FALSE, 
                   sep="", 
                   stringsAsFactors=FALSE, 
                   col.names=features_labels$feature)

y_test <- read.csv("./test/y_test.txt", 
                    header=FALSE, 
                    sep="", 
                    stringsAsFactors=FALSE, 
                    col.names=c("activityID"))

subject_test <- read.csv("./test/subject_test.txt", 
                   header=FALSE, 
                   sep="", 
                   stringsAsFactors=FALSE, 
                   col.names=c("subject"))

# Read in training data (X, y and subject)
X_train <- read.csv("./train/X_train.txt", 
                   header=FALSE, 
                   sep="", 
                   stringsAsFactors=FALSE, 
                   col.names=features_labels$feature)

y_train <- read.csv("./train/y_train.txt", 
                   header=FALSE, 
                   sep="", 
                   stringsAsFactors=FALSE, 
                   col.names=c("activityID"))

subject_train <- read.csv("./train/subject_train.txt", 
                         header=FALSE, 
                         sep="", 
                         stringsAsFactors=FALSE, 
                         col.names=c("subject"))

# Read in the text description for the activity IDs found in the y files from above
activity_labels <- read.csv("./activity_labels.txt", 
                            header=FALSE, 
                            sep="", 
                            stringsAsFactors=FALSE, 
                            col.names=c("activityID", "activity_desc"))

# Merge the test and training data
X_merged <- rbind(X_test, X_train)
y_merged <- rbind(y_test, y_train)
subject_merged <- rbind(subject_test, subject_train)

# Determine the indexes of the feature labels we're interested in (mean and std only)
features_mean_indexes <- grep("mean",features_labels$feature)
features_std_indexes <- grep("std",features_labels$feature)
features_desired <- c(features_mean_indexes, features_std_indexes)

# Pare down the X data to just those columns containing "mean" or "std" in the variable label
X_merged <- select(X_merged, features_desired)

# Add the subject data and activity labels to the merged data set
#   note: join() keeps the original row order of y, while merge() sorts it
activity <- join(y_merged, activity_labels)$activity_desc
X_merged <- cbind(subject_merged, activity, X_merged)

# Produce the desired tidy results, with the average of each variable for each 
#   activity and each subject
X_merged_grouped <- group_by(X_merged, subject, activity)
tidy_results <- summarise_each(X_merged_grouped, funs(mean))

# output the tidy results to a text file
write.table(tidy_results, "./tidy_results.txt", row.name=FALSE)
