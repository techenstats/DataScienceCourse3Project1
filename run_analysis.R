## R Code for the Coursera Data Science Course #3: Getting and Cleaning Data Project

#############################
## Generate the tidy data set
#############################
## Read in the training and test data sets
data_train <- read.table("UCI HAR Dataset/train/X_train.txt")
act_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
data_test <- read.table("UCI HAR Dataset/test/X_test.txt")
act_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Add subject and activity as the leftmost columns
data_train <- cbind(sub_train, act_train, data_train)
data_test <- cbind(sub_test, act_test, data_test)

## Merge the training and test data sets
data <- rbind(data_train, data_test)

## Read in the features (variables) and set the column names
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
features <- c("Subject", "Activity", features[,2])
colnames(data) <- features

## Generate list of columns that contain "mean" or "std" in the variable name
## We always want columns 1 and 2, the Subject and Activity columns, respectively
colskeep <- c(1, 2, sort(c(grep("mean", features), grep("std", features))))

## Just keep the columns that we want
data <- data[,colskeep]

## Order the results
data <- data[order(data$Subject, data$Activity),]

## Clean up the column variable names
cnames <- colnames(data)
cnames <- gsub("-","",cnames)
cnames <- gsub("[()]","",cnames)
cnames <- gsub("mean","Mean",cnames)
cnames <- gsub("std","Std",cnames)
colnames(data) <- cnames

## Generate the Tidy data set of averages
datatidy <- aggregate(data, by=list(data$Subject, data$Activity), FUN=mean)
datatidy <- datatidy[,3:ncol(datatidy)]

## Replace activity numbers with descriptive activity names
datatidy$Activity[datatidy$Activity==1] <- "WALKING"
datatidy$Activity[datatidy$Activity==2] <- "WALKING UPSTAIRS"
datatidy$Activity[datatidy$Activity==3] <- "WALKING DOWNSTAIRS"
datatidy$Activity[datatidy$Activity==4] <- "SITTING"
datatidy$Activity[datatidy$Activity==5] <- "STANDING"
datatidy$Activity[datatidy$Activity==6] <- "LAYING"

# Round averages to 6 digits of precision
datatidy <- cbind(datatidy[,1:2], round(datatidy[,3:ncol(datatidy)],5))

## Write out the tidy data results to a text file.  Round to 6 digits of precision.
write.table(datatidy, file = "DataScienceCourse3Project1/TidySignalDataAverages.txt", row.names = FALSE)


#########################
## Generate the code book
#########################
vname <- character()
vwidth <- character()
vdef <- character()
vrange <- character()
for (n in 1:ncol(datatidy)) {
        if (n == 1) {
                vname <- c(vname, cnames[n])
                vwidth <- c(vwidth, "2 digits")
                vdef <- c(vdef, "The subject who performed the activity for each window sample")
                vrange <- c(vrange, "1 to 30")
        }
        else if (n == 2) {
                vname <- c(vname, cnames[n])
                vwidth <- c(vwidth, "18 characters")
                vdef <- c(vdef, "The activity performed")
                vrange <- c(vrange, "One of the following six values: WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, LAYING")
        }
        else {
                vname <- c(vname, cnames[n])
                vwidth <- c(vwidth, "Decimal value rounded to 6 digits of precision")
                vdef <- c(vdef, "")
                vrange <- c(vrange, "[-1, 1]")
        }
}

for (n in grep("tBody", cnames)) {vdef[n] <- "Time body"}
for (n in grep("tGravity", cnames)) {vdef[n] <- "Time gravity"}

for (n in grep("fBody", cnames)) {vdef[n] <- "Frequency body"}
for (n in grep("fGravity", cnames)) {vdef[n] <- "Frequency gravity"}

for (n in grep("AccMean", cnames)) {vdef[n] <- paste(vdef[n], "triaxial acceleration mean")}
for (n in grep("AccStd", cnames)) {vdef[n] <- paste(vdef[n], "triaxial acceleration standard deviation mean")}
for (n in grep("AccMagMean", cnames)) {vdef[n] <- paste(vdef[n], "triaxial acceleration magnitude mean")}
for (n in grep("AccMagStd", cnames)) {vdef[n] <- paste(vdef[n], "triaxial acceleration standard deviation magnitude mean")}

for (n in grep("AccJerkMean", cnames)) {vdef[n] <- paste(vdef[n], "jerk mean")}
for (n in grep("AccJerkStd", cnames)) {vdef[n] <- paste(vdef[n], "jerk standard deviation mean")}
for (n in grep("AccJerkMagMean", cnames)) {vdef[n] <- paste(vdef[n], "jerk magnitude mean")}
for (n in grep("AccJerkMagStd", cnames)) {vdef[n] <- paste(vdef[n], "jerk standard deviation magnitude mean")}

for (n in grep("GyroMean", cnames)) {vdef[n] <- paste(vdef[n], "gyroscrope angular velocity mean")}
for (n in grep("GyroStd", cnames)) {vdef[n] <- paste(vdef[n], "gyroscope angular velocity standard deviation mean")}
for (n in grep("GyroMagMean", cnames)) {vdef[n] <- paste(vdef[n], "gyroscrope angular velocity magnitude mean")}
for (n in grep("GyroMagStd", cnames)) {vdef[n] <- paste(vdef[n], "gyroscope angular velocity standard deviation magnitude mean")}

for (n in grep("GyroJerkMean", cnames)) {vdef[n] <- paste(vdef[n], "gyroscrope jerk mean")}
for (n in grep("GyroJerkStd", cnames)) {vdef[n] <- paste(vdef[n], "gyroscope jerk standard deviation mean")}
for (n in grep("GyroJerkMagMean", cnames)) {vdef[n] <- paste(vdef[n], "gyroscrope jerk magnitude mean")}
for (n in grep("GyroJerkMagStd", cnames)) {vdef[n] <- paste(vdef[n], "gyroscope jerk standard deviation magnitude mean")}

## Tack on direction stuff X, Y, or Z
for (n in 1:length(cnames)) {
        ## Grab the last character in the variable name
        lastchar <- sub('.*(?=.$)', '', cnames[n], perl=T)
        
        if (lastchar == "X") {
                vdef[n] <- paste(vdef[n], "in the X direction")
        }
        
        if (lastchar == "Y") {
                vdef[n] <- paste(vdef[n], "in the Y direction")
        }
        
        if (lastchar == "Z") {
                vdef[n] <- paste(vdef[n], "in the Z direction")
        }
}

## Write out the code book for this project
sink("DataScienceCourse3Project1/CodeBook.md")
        for (n in 1:length(cnames)) {
                cat(paste("Variable Name:", vname[n], "; \n"))
                cat(paste("Column:", n, "; \n"))
                cat(paste("Field Width:", vwidth[n], "; \n"))
                cat(paste("Definition:", vdef[n], "; \n"))
                cat(paste("Range:", vrange[n], "; \n"))
                cat("\r\n")
        }
sink()


#######################
## Generate README file
#######################
sink("DataScienceCourse3Project1/README.md")
        cat("Project: download the data set \"getdata_projectfiles_UCI HAR Dataset.zip\" from the Coursera
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
   5. Creates a tidy data set with the average of each variable for each combination of activity and subject.\n\n")

        cat("The original data files used are described as follows: \r
            UCI HAR Dataset/train/X_train.txt = Training subject measurements \r
            UCI HAR Dataset/train/Y_train.txt = Training subject activities \r
            UCI HAR Dataset/train/subject_train.txt = Training subject ID's (1 to 30) \r
            UCI HAR Dataset/test/X_test.txt = Test subject measurements \r
            UCI HAR Dataset/test/Y_test.txt = Test subject activities \r
            UCI HAR Dataset/test/subject_test.txt = Test subject ID's (1 to 30) \r
            UCI HAR Dataset/features.txt = The measurements recorded (561 measurements in total) \n\n")


        cat("After binding the subject and activity columns, the test and and training data asets are merged
with the rbind command.  Variable names are set according to the features.txt file, and only columns
containing the key words \"mean\" or \"std\" are kept.  This resulted in keeping 79 out of the 561 measurements
The variable names are cleaned up for improved readability, and descriptive names are given for each Activity
(replacing the numbered names).  The aggregate function is used to calculate the mean value by Subject and by
Activity.  Lastly, the tidy data set is written to a text file named \"TidySignalDataAverages.txt\".  There are
180 rows (30 Subjects by 6 Activities per Subject) and 81 columns in the tidy data set\n\n")
   
        cat("A code book describing each variable is included called CodeBook.md.  This file gives detailed
descriptions of what each tidy data set column represents.\n")
sink()