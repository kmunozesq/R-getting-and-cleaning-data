run_analysis <- function()
{
        #Checking if folder with training and test data exists under working 
        #directory        
        dir <- "data_cln_project"        
        if(file.exists(dir))
        {
                #1) Loading and Formating training data set
                tidy_data_file <- file.path(getwd(),dir,"tidy_data.txt")
                features_file <- file.path(getwd(),dir,"features.txt")
                activity_labels_file <- file.path(getwd(),dir,"activity_labels.txt")
                trainfile_data <- file.path(getwd(),dir,"train", "X_train.txt")
                trainfile_labels <-file.path(getwd(),dir,"train", "y_train.txt")
                trainsubjects_file <- file.path(getwd(),dir,"train","subject_train.txt")
                
                features <- scan(file = features_file, what = list(integer(),""))
                labels <- scan(file = activity_labels_file, what = list(integer(),""))
                subject <- scan(file = trainsubjects_file, what = integer())
                activity_lb <- scan(file = trainfile_labels, what = integer())
                
                #Creating a data frame of the training data
                DF <- read.table(trainfile_data, header=FALSE, na.strings="NA", stringsAsFactors=FALSE)
                #Adding labels to each column
                colnames(DF) = features[2][[1]]
                activity <- factor(activity_lb, labels = labels[2][[1]])
                DF <- cbind(DF, activity)
                DF <- cbind(DF, subject)
                
                #Loading and formating the testing data
                testfile_data <- file.path(getwd(),dir,"test", "X_test.txt")
                testfile_labels <-file.path(getwd(),dir,"test", "y_test.txt")
                testsubjects_file <- file.path(getwd(),dir,"test","subject_test.txt")
                
                activity_lb <- scan(file = testfile_labels, what = integer())
                subject <- scan(file = testsubjects_file, what = integer())
                
                DFtst <- read.table(testfile_data, header=FALSE, na.strings="NA", stringsAsFactors=FALSE) 
                colnames(DFtst) = features [2][[1]]
                activity <-  factor(activity_lb, labels = labels[2][[1]])
                DFtst <-cbind(DFtst, activity)
                DFtst <-cbind(DFtst, subject)        
                
                DF <- rbind(DF,DFtst)
                
                #Converting the dataframe to a datatable
                library(data.table)
                DT <- data.table(DF)
                setkeyv(DT,c("activity","subject"))
                
                #Replacing dash and parentheses in the name of the variables for "_" and "" respectively
                
                names_new <- names(DT)
                names_new <- gsub("-", "_", names_new) 
                names_new <- gsub("\\(", "", names_new)
                names_new <- gsub("\\)", "", names_new)
                names_new <- gsub(",", "", names_new)
                for(i in 1:length(names_new))
                {
                        setnames(DT, i, names_new[i])
                }
                rm("names_new")
                #print(str(DT))
                ####### Here TESTING AND TRAINING DATA ARE TOGETHER IN DT
                
                ##sUBSETTING DT to mean and std values + activity + subject
                library(dplyr)
                
                
                DT %>%  select(contains("mean"), contains("std"), activity, subject) %>%
                ##until here THE RESULT OF THE SUBSETTING IS IN DT
                        arrange(subject, activity) %>%
                        group_by(subject, activity) %>%
                        ##TIDYING DATA
                        #with the average of each variable for each subject and activity.                        
                        summarise(Average_tBodyAcc_mean_X = mean(tBodyAcc_mean_X, na.rm = TRUE),
                                  Average_tBodyAcc_mean_Y = mean(tBodyAcc_mean_Y,na.rm = TRUE),
                                  Average_tBodyAcc_mean_Z = mean(tBodyAcc_mean_Z,na.rm = TRUE),
                                  Average_tGravityAcc_mean_X = mean(tGravityAcc_mean_X,na.rm = TRUE),
                                  Average_tGravityAcc_mean_Y = mean(tGravityAcc_mean_Y,na.rm = TRUE),
                                  Average_tGravityAcc_mean_Z = mean(tGravityAcc_mean_Z,na.rm = TRUE),
                                  Average_tBodyAccJerk_mean_X = mean(tBodyAccJerk_mean_X,na.rm = TRUE),
                                  Average_tBodyAccJerk_mean_Y = mean(tBodyAccJerk_mean_Y,na.rm = TRUE),
                                  Average_tBodyAccJerk_mean_Z = mean(tBodyAccJerk_mean_Z,na.rm = TRUE),
                                  Average_tBodyGyro_mean_X = mean(tBodyGyro_mean_X,na.rm = TRUE),
                                  Average_tBodyGyro_mean_Y = mean(tBodyGyro_mean_Y,na.rm = TRUE),
                                  Average_tBodyGyro_mean_Z = mean(tBodyGyro_mean_Z,na.rm = TRUE),
                                  Average_tBodyGyroJerk_mean_X = mean(tBodyGyroJerk_mean_X,na.rm = TRUE),
                                  Average_tBodyGyroJerk_mean_Y = mean(tBodyGyroJerk_mean_Y,na.rm = TRUE),
                                  Average_tBodyGyroJerk_mean_Z = mean(tBodyGyroJerk_mean_Z,na.rm = TRUE),
                                  Average_tBodyAccMag_mean = mean(tBodyAccMag_mean,na.rm = TRUE),
                                  Average_tGravityAccMag_mean = mean(tGravityAccMag_mean,na.rm = TRUE),
                                  Average_tBodyAccJerkMag_mean = mean(tBodyAccJerkMag_mean,na.rm = TRUE),
                                  Average_tBodyGyroMag_mean = mean(tBodyGyroMag_mean,na.rm = TRUE),
                                  Average_tBodyGyroJerkMag_mean = mean(tBodyGyroJerkMag_mean,na.rm = TRUE),
                                  Average_fBodyAcc_mean_X = mean(fBodyAcc_mean_X,na.rm = TRUE),
                                  Average_fBodyAcc_mean_Y = mean(fBodyAcc_mean_Y,na.rm = TRUE),
                                  Average_fBodyAcc_mean_Z = mean(fBodyAcc_mean_Z,na.rm = TRUE),
                                  Average_fBodyAcc_meanFreq_X = mean(fBodyAcc_meanFreq_X,na.rm = TRUE),
                                  Average_fBodyAcc_meanFreq_Y = mean(fBodyAcc_meanFreq_Y,na.rm = TRUE),
                                  Average_fBodyAcc_meanFreq_Z = mean(fBodyAcc_meanFreq_Z,na.rm = TRUE),
                                  Average_fBodyAccJerk_mean_X = mean(fBodyAccJerk_mean_X,na.rm = TRUE),
                                  Average_fBodyAccJerk_mean_Y = mean(fBodyAccJerk_mean_Y,na.rm = TRUE),
                                  Average_fBodyAccJerk_mean_Z = mean(fBodyAccJerk_mean_Z,na.rm = TRUE),
                                  Average_fBodyAccJerk_meanFreq_X = mean(fBodyAccJerk_meanFreq_X,na.rm = TRUE),
                                  Average_fBodyAccJerk_meanFreq_Y = mean(fBodyAccJerk_meanFreq_Y,na.rm = TRUE),
                                  Average_fBodyAccJerk_meanFreq_Z = mean(fBodyAccJerk_meanFreq_Z,na.rm = TRUE),
                                  Average_fBodyGyro_mean_X = mean(fBodyGyro_mean_X,na.rm = TRUE),
                                  Average_fBodyGyro_mean_Y = mean(fBodyGyro_mean_Y,na.rm = TRUE),
                                  Average_fBodyGyro_mean_Z = mean(fBodyGyro_mean_Z,na.rm = TRUE),
                                  Average_fBodyGyro_meanFreq_X = mean(fBodyGyro_meanFreq_X,na.rm = TRUE),
                                  Average_fBodyGyro_meanFreq_Y = mean(fBodyGyro_meanFreq_Y,na.rm = TRUE),
                                  Average_fBodyGyro_meanFreq_Z = mean(fBodyGyro_meanFreq_Z,na.rm = TRUE),
                                  Average_fBodyAccMag_mean = mean(fBodyAccMag_mean,na.rm = TRUE),
                                  Average_fBodyAccMag_meanFreq = mean(fBodyAccMag_meanFreq,na.rm = TRUE),
                                  Average_fBodyBodyAccJerkMag_mean = mean(fBodyBodyAccJerkMag_mean,na.rm = TRUE),
                                  Average_fBodyBodyAccJerkMag_meanFreq = mean(fBodyBodyAccJerkMag_meanFreq,na.rm = TRUE),
                                  Average_fBodyBodyGyroMag_mean = mean(fBodyBodyGyroMag_mean,na.rm = TRUE),
                                  Average_fBodyBodyGyroMag_meanFreq = mean(fBodyBodyGyroMag_meanFreq,na.rm = TRUE),
                                  Average_fBodyBodyGyroJerkMag_mean = mean(fBodyBodyGyroJerkMag_mean,na.rm = TRUE),
                                  Average_fBodyBodyGyroJerkMag_meanFreq = mean(fBodyBodyGyroJerkMag_meanFreq,na.rm = TRUE),
                                  Average_angletBodyAccMeangravity = mean(angletBodyAccMeangravity,na.rm = TRUE),
                                  Average_angletBodyAccJerkMeangravityMean = mean(angletBodyAccJerkMeangravityMean,na.rm = TRUE),
                                  Average_angletBodyGyroMeangravityMean = mean(angletBodyGyroMeangravityMean,na.rm = TRUE),
                                  Average_angletBodyGyroJerkMeangravityMean = mean(angletBodyGyroJerkMeangravityMean,na.rm = TRUE),
                                  Average_angleXgravityMean = mean(angleXgravityMean,na.rm = TRUE),
                                  Average_angleYgravityMean = mean(angleYgravityMean,na.rm = TRUE),
                                  Average_angleZgravityMean = mean(angleZgravityMean,na.rm = TRUE),
                                  Average_tBodyAcc_std_X = mean(tBodyAcc_std_X,na.rm = TRUE),
                                  Average_tBodyAcc_std_Y = mean(tBodyAcc_std_Y,na.rm = TRUE),
                                  Average_tBodyAcc_std_Z = mean(tBodyAcc_std_Z,na.rm = TRUE),
                                  Average_tGravityAcc_std_X = mean(tGravityAcc_std_X,na.rm = TRUE),
                                  Average_tGravityAcc_std_Y = mean(tGravityAcc_std_Y,na.rm = TRUE),
                                  Average_tGravityAcc_std_Z = mean(tGravityAcc_std_Z,na.rm = TRUE),
                                  Average_tBodyAccJerk_std_X = mean(tBodyAccJerk_std_X,na.rm = TRUE),
                                  Average_tBodyAccJerk_std_Y = mean(tBodyAccJerk_std_Y,na.rm = TRUE),
                                  Average_tBodyAccJerk_std_Z = mean(tBodyAccJerk_std_Z,na.rm = TRUE),
                                  Average_tBodyGyro_std_X = mean(tBodyGyro_std_X,na.rm = TRUE),
                                  Average_tBodyGyro_std_Y = mean(tBodyGyro_std_Y,na.rm = TRUE),
                                  Average_tBodyGyro_std_Z = mean(tBodyGyro_std_Z,na.rm = TRUE),
                                  Average_tBodyGyroJerk_std_X = mean(tBodyGyroJerk_std_X,na.rm = TRUE),
                                  Average_tBodyGyroJerk_std_Y = mean(tBodyGyroJerk_std_Y,na.rm = TRUE),
                                  Average_tBodyGyroJerk_std_Z = mean(tBodyGyroJerk_std_Z,na.rm = TRUE),
                                  Average_tBodyAccMag_std = mean(tBodyAccMag_std,na.rm = TRUE),
                                  Average_tGravityAccMag_std = mean(tGravityAccMag_std,na.rm = TRUE),
                                  Average_tBodyAccJerkMag_std = mean(tBodyAccJerkMag_std,na.rm = TRUE),
                                  Average_tBodyGyroMag_std = mean(tBodyGyroMag_std,na.rm = TRUE),
                                  Average_tBodyGyroJerkMag_std = mean(tBodyGyroJerkMag_std,na.rm = TRUE),
                                  Average_fBodyAcc_std_X = mean(fBodyAcc_std_X,na.rm = TRUE),
                                  Average_fBodyAcc_std_Y = mean(fBodyAcc_std_Y,na.rm = TRUE),
                                  Average_fBodyAcc_std_Z = mean(fBodyAcc_std_Z,na.rm = TRUE),
                                  Average_fBodyAccJerk_std_X = mean(fBodyAccJerk_std_X,na.rm = TRUE),
                                  Average_fBodyAccJerk_std_Y = mean(fBodyAccJerk_std_Y,na.rm = TRUE),
                                  Average_fBodyAccJerk_std_Z = mean(fBodyAccJerk_std_Z,na.rm = TRUE),
                                  Average_fBodyGyro_std_X = mean(fBodyGyro_std_X,na.rm = TRUE),
                                  Average_fBodyGyro_std_Y = mean(fBodyGyro_std_Y,na.rm = TRUE),
                                  Average_fBodyGyro_std_Z = mean(fBodyGyro_std_Z,na.rm = TRUE),
                                  Average_fBodyAccMag_std = mean(fBodyAccMag_std,na.rm = TRUE),
                                  Average_fBodyBodyAccJerkMag_std = mean(fBodyBodyAccJerkMag_std,na.rm = TRUE),
                                  Average_fBodyBodyGyroMag_std = mean(fBodyBodyGyroMag_std,na.rm = TRUE),
                                  Average_fBodyBodyGyroJerkMag_std = mean(fBodyBodyGyroJerkMag_std,na.rm = TRUE)) %>%
                                ### THE TIDY DATA IS IN DT
                                write.table(file=tidy_data_file, row.name=FALSE)                
        }
}

