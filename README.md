Project: download the data set "getdata_projectfiles_UCI HAR Dataset.zip" from the Coursera
website.  The link to download the data is the following:

     Link to Original Data Set: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This data set contains triaxial accelerometer and gyroscope measurements recorded from a
Samsung Galaxy S II smartphone.  Various metrics are recorded for this data set, as described in
the README.txt file included with the data set.  A group of 30 volunteers (Subjects) within an age
bracket of 19-48 years participated. Each person performed six activities (WALKING, WALKING_UPSTAIRS,
WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).  The data was randomly partitioned into two sets,
where 70% of the volunteers generated the training data and 30% generated the test data.

The goal of the project is to do the following:
   1. Merge the training and the test sets to create one data set.
   2. Extract only the measurements on the mean and standard deviation for each measurement.
   3. Use descriptive activity names to name the activities in the data set.
   4. Appropriately label the data set with descriptive variable names.
   5. Creates a tidy data set with the average of each variable for each combination of activity and subject.

The original data files used are described as follows: 
            UCI HAR Dataset/train/X_train.txt = Training subject measurements 
            UCI HAR Dataset/train/Y_train.txt = Training subject activities 
            UCI HAR Dataset/train/subject_train.txt = Training subject ID's (1 to 30) 
            UCI HAR Dataset/test/X_test.txt = Test subject measurements 
            UCI HAR Dataset/test/Y_test.txt = Test subject activities 
            UCI HAR Dataset/test/subject_test.txt = Test subject ID's (1 to 30) 
            UCI HAR Dataset/features.txt = The measurements recorded (561 measurements in total) 

After binding the subject and activity columns, the test and and training data asets are merged
with the rbind command.  Variable names are set according to the features.txt file, and only columns
containing the key words "mean" or "std" are kept.  This resulted in keeping 79 out of the 561 measurements
The variable names are cleaned up for improved readability, and descriptive names are given for each Activity
(replacing the numbered names).  The aggregate function is used to calculate the mean value by Subject and by
Activity.  Lastly, the tidy data set is written to a text file named "TidySignalDataAverages.txt".  There are
180 rows (30 Subjects by 6 Activities per Subject) and 81 columns in the tidy data set

A code book describing each variable is included called CodeBook.md.  This file gives detailed
descriptions of what each tidy data set column represents.
