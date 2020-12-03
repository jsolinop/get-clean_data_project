## Run Analysis

This is my Course Project for Getting and Cleaning Data

The purpose of this project is to build a unique data set with the 
information from the __Human Activity Recognition Using Smartphones Dataset__. 

You can find the complete information of this Dataset 
[here](https://github.com/jsolinop/get-clean_data_project/blob/master/UCI%20HAR%20Dataset/README.txt)

You can find more information about the measurements 
[here](https://github.com/jsolinop/get-clean_data_project/blob/master/UCI%20HAR%20Dataset/features_info.txt)

The full data is from [UCI HAR Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

### Structure of the script `run_analysis.R`

The script has the next structure:

* Header with a title, my contact data, the date and version
* Libraries required: `dplyr` and `tidyverse`. Please, remember to install these packages, if you don't have installed yet. 
* The `run_analysis` function body (further detail below).
* Execution of `run_analysis` function and assign the result (data frame) to a variable `complete_set`.
* Summary of the previous variable, calculating the average for each variable, each activity and each subjetct. The result is assigned to variable `complete_colmeans`.

To make easy the test of the project, you only have to source the script, and you obtain the function `run_analisys()` and the variables `complete_set` and `complete_colmeans` loaded in your enviroment.


### The `run_analysis()` function

The function has no parameters and returns a complete data set of the HAR measures, performing the actions that you can find below.

* Read data from files and assign to variables.

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

* Selects measures related to mean and std

        ## Select measurements on the mean and std (standard deviation)
        total_set <-
                total_set %>% select(grep("([Mm]ean()|[Ss]td())", feature_names$feature))


* Merges train and test data sets and assign measure names

        ## Mege train and test data sets and assign names to each variable  ----
        
        total_set <- rbind(train_set, test_set)
        names(total_set) <- feature_names$feature


* Binds all together (subjects + activy names + measures)

        ## Merge Activity Labels and Join it with Activities Descrition table
        total_activities <- rbind(train_labels, test_labels)
        total_activities <- merge(total_activities,activity_names)
        total_activities <- select(total_activities, activity)
        total_subjects <- rbind(train_subject, test_subject)

        # Bind subjects, activities and the measure set with variable names
        total_set <- cbind(total_subjects,total_activities, total_set)


* Result: 
        
                total_set$id_subject <- as.factor(total_set$id_subject)
                return(total_set)        

        
### Execution and store results on project environmet
        

        # Execute run_analysis and asign result to complete_set variable
        complete_set <- run_analysis()
        
        
        # Create a tidy data set with the average of each variable, for each
        # activity and each subject
        complete_colmeans <-
                complete_set %>% group_by(id_subject, activity) %>% 
                        summarise_all(mean) %>% arrange(id_subject, activity)



===

Joaquín Soliño