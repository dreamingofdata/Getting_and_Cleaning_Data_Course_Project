---
title: "README"
author: "Bill Kimler"
date: "August 23, 2015"
output: md_document
---

#README
This documents describes the work and methodolgy behind the `run_analysis.R` script submitted to fulfill the Course Project Requirement for Coursera "Getting and Cleaning Data"  (https://class.coursera.org/getdata-031/human_grading/view/courses/975115/assessments/3/submissions)

This project involved raw data from the "Human Activity Recognition Using Smartphones Dataset". The data and its documentation can be found at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##Output
The ultimate output of this project was a summarized "tidy" file that contained, by subject and activity, the mean of all of the mean and standard deviation measurements captured in the test and training data.

Assuming this script is launched inside the folder of the provided data, 'UCI HAR Dataset', it will produce the file `tidy_results.txt`. This file can be read and viewed by executing the following R commands:

```
data <- read.table("./tidy_results", header = TRUE) 
View(data)
```

##Libraries required by the script
* `plyr`: needed for `join()`
* `dplyr`: needed for `select()`, `summarise_each()`, `group_by()`

##Script Outline
The script begins by reading the `features.txt` which contains a list of the 500+ different measurements captured in each record of the dataset.

It then reads the raw data (X), the activity IDs for each record (y) and the ID of the subject associated with each record (subject). It does this for both the test and training data sets.

* test data
    + `test/X_test.txt`
    + `test/y_test.txt`
    + `test/subject_test.txt`
* training data
    + `train/X_train.txt`
    + `train/y_train.txt`
    + `train/subject_train.txt`

The conversion between the activity IDs found in `y_test` and `y_train` and their descriptive labels are pulled from the `activity_labels.txt` file.

The next step was to combine the test and training data. Using `rbind()`, `X_merged`, `y_merged` and `subject_merged` were created.

To fulfill the requirement of focusing only on variables that measured means and standard deviations, `grep()` was used on the features list pulled in the first step to determine the indices of any variable that contained `mean` or `std` in its name. with these indices, `X_merged` was pared down to just those variables that met the criteria.

The activity IDs found in `y_merged` were converted to their text descriptions found in `activity_labels` through a join on the `activity_id`.

Next, the subjects and activities were merged with `X_merged` through a `cbind()` call.

Finally, `X_merged` was grouped by subject and activity and with the `summarise_each()` command, the mean of each of the remaining variables was determined.

The final output is written to `./tidy_results.txt`. The output of this file is detailed in the `CodeBook.md` file.