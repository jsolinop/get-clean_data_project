#------------------------------------------------------
# Title: run_analysis.R
# Description: This scripts includes the function run_analysis()
# Version: v1.0 
# Author: Joaquín Soliño (joaquin.solino@me.com)
# ChangeLog. El changeLog en muy pocas palabras las modificaciones realizadas en cada versión.
#------------------------------------------------------


## ---- Libraries required ----
library(dplyr)
library(tidyverse)


## ---- Functions ----

#  run_analysis() is a function with no params, that returns a dataframe 
#  as the result of the next processes:
#   a. Binds rows of train and test data sets in a new variable `total_set`
#   b. Include descritive activity name
#   c. Assign names of the features to the variables of `total_set`
#   d. Select only de measurements on the mean and standard deviation

run_analysis <- function(){

        ## ---- Variables: Read data from files ----
        # Read activities from "activity_labels.txt" and assign the content to a
        # dataframe `activity_labels`, with two variables: 1.- id_activity (int) 2.-
        # activity (factor)
        activity_names <-
                read.table(
                        "UCI HAR Dataset/activity_labels.txt",
                        sep = " ",
                        col.names = c("id_activity", "activity"),
                        colClasses = c("integer", "factor")
                )
        
        # Read features from "features.txt" and assign the content to a new variable
        # `feature_names` with names for de 561 measures
        feature_names <-
                read.table(
                        "UCI HAR Dataset/features.txt",
                        sep = " ",
                        col.names = c("id_feature", "feature"),
                        colClasses = c("integer", "character")
                )
        
        # Read subject vectors from subject_train.txt and subject_test.txt files
        train_subject <-
                read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "id_subject")
        test_subject <-
                read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "id_subject")
        
        
        # Read train set of measures ...
        train_set <- read.table("UCI HAR Dataset/train/X_train.txt")
        # ... and vector of train id_activities
        train_labels <-
                read.table("UCI HAR Dataset/train/y_train.txt", col.names = "id_activity")
        
        # Read test set of measures ...
        test_set <- read.table("UCI HAR Dataset/test/X_test.txt")
        # ... and vector of train id_activities
        test_labels <-
                read.table("UCI HAR Dataset/test/y_test.txt", col.names = "id_activity")
        

        ## Mege train and test data sets and assign names to each variable  ----
        
        total_set <- rbind(train_set, test_set)
        names(total_set) <- feature_names$feature
        
        # Select measurements on the mean and std (standard deviation)
        total_set <-
                total_set %>% select(grep("([Mm]ean()|[Ss]td())", feature_names$feature))
        
        ## Merge Activity Labels and Join it with Activities Descrition table
        total_activities <- rbind(train_labels, test_labels)
        total_activities <- left_join(total_activities,activity_names)
        total_activities <- select(total_activities, activity)

        total_subjects <- rbind(train_subject, test_subject)

        # Bind subjects, activities and the measure set with variable names
        total_set <- cbind(total_subjects,total_activities, total_set)
        total_set$id_subject <- as.factor(total_set$id_subject)
        return(total_set)        
} 



# Execute run_analysis and asign result to complete_set variable
complete_set <- run_analysis()

# Create a tidy data set with the average of each variable, for each
# activity and each subject
complete_colmeans <-
        complete_set %>% group_by(id_subject, activity) %>% 
                summarise_all(mean) %>% arrange(id_subject, activity)

write.table(complete_colmeans,"results/complete_colmeans.txt", row.names = FALSE)
