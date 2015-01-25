---
title: "README"
author: "Karla Muñoz-Esquivel"
date: "Sunday, January 25, 2015"
output: html_document
---

This is an R Markdown document written to explain the functioning of the script 
**"run_analysis.R"** under this GitHub repo.

The main objective of this script is to create a tidy data set, which is saved 
in a *.txt file using as inputs training and testing data sets which are split 
in several files.

This training and testing data sets correpond to data collected from the 
accelerometers from the Samsung Galaxy S smartphone for 30 subjects perfoming 
activities of daily life. For more information about these data 
sets please see: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The steps followed by this script in order to achieve a tidy data set are:

1. Verifying that the directory with test and training data exists

2. Loading and Formatting training data

3. Loading and Formatting test data 

4. Putting together training and testing data

5. Subsetting data set to mean and std variables

6. Obtaining the average of each variable for each subject and activity

7. Saving the tidy data set in a txt file

Each step will be explained below in detail.



### Verifying that the directory with test and training data exists

This happens in lines 5 to 6:

`` dir <- "data_cln_project" ``        

`` if(file.exists(dir)){ ... ``

If the directory does not exist the script does not do and cannot do  anything
else and just finishes its execution normally  without throwing any message and 
without creating the **tidy_data.txt** file under the **data_cln_project** 
directory. In the body of this _if condition_ is where all the logic happens.

**tidy_data.txt** is the final result of this script, it is the name of the file
where the tidy data  will be finally saved



### Loading and Formatting training data

Then the script focuses on loading and formatting the training data set, because
the data is split in several files. This happens in lines 9 to 27.

In line 22 the training data is nearly all together and it is stored
in the data.frame object **DF**:

``DF <- read.table(trainfile_data, header=FALSE, na.strings="NA", stringsAsFactors=FALSE)``

Lines 24 to 27 focus on adding all the names of the variables and the labels of
the activities performed, which were stored in several character objects.
Also, these lines focus on including the subject of each observation. 
To achieve these, _colnames_ and _cbind_ are employed. 

``colnames(DF) = features[2][[1]]``

``DF <- cbind(DF, activity)``

``DF <- cbind(DF, subject)``

### Loading and Formatting test data

Lines 30-41 focus on loading and formatting the test data set, which was also
split into several files, subjects are included into the observations and  
names of the variables and labels of activities are added also using _colnames_ 
and _cbind_. The test data is stored in the data.frame object **DFtst**.

### Putting together testing and training data

In line 43, the loaded and formated training data sets were put together using
_rbind_. Training and testing data sets are stored in *DF*

``DF <- rbind(DF,DFtst)``

and **DF** is converted to a _data.table_ object **DT** in line 47 and _'subject'_ 
and _'activity'_ variables are specified as keys of this table in line 48.

``DT <- data.table(DF)``

``setkeyv(DT,c("activity","subject"))``

In lines 50 to 62 more formatting is performed, since the variable names 
obtained from the files provided contain characters such as *-* , *,* , *(* ,*)*,
which are not valid names of variables in _R language_. These characters are 
substituted by "_" and "" characters to set valid names of variables for the 
columns of this data set. This is done using the functions _gsub_ and _setnames_.

``names_new <- names(DT)``

``names_new <- gsub("-", "_", names_new) ...``

``for(i in 1:length(names_new)){setnames(DT, i, names_new[i])}``


###Subsetting data set to mean and std variables

To subset the data set easily the library _'dplyr'_ is employed. In line 69, 
_select_ is employed in combination with _contains_ to select the variables 
correponding to the keywords _mean_ and _std_:

``DT %>%  select(contains("mean"), contains("std"), activity, subject) %>%``

### Obtaining the average of each variable for each subject and activity
A combination of chain operations are performed in order to obtain the tidy data
set in lines 71 to 160. The function _summarise_ of the _dplyr_ package is 
employed with this objective, but before executing this function, it has to be
specified that this will be performed taking into account two groups of variables:
_'activity'_ and _'subject'_. All the observations in the data set were previously
arranged according to these two groups of variables in ascendent order.

``arrange(subject, activity) %>%``

``group_by(subject, activity) %>%``

``summarise(Average_tBodyAcc_mean_X = mean(tBodyAcc_mean_X, na.rm = TRUE),``
``          Average_tBodyAcc_mean_Y = mean(tBodyAcc_mean_Y,na.rm = TRUE), ...``
``          Average_fBodyBodyGyroJerkMag_std = mean(fBodyBodyGyroJerkMag_std,na.rm = TRUE)) %>%``



###Saving the tidy data set in a txt file

Finally in line 162, the tidy data set stored in *DT* is saved in the text file
*tidy_data.txt* under the **data_cln_project** folder using _write.table_.

``write.table(file=tidy_data_file, row.name=FALSE)``  