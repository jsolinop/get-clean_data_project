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
