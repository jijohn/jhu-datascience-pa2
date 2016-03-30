########################## run_analysis.R #####################################
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
########################## run_analysis.R #####################################
library(data.table)
library(dplyr)


# start read data #############################################################
# read train data
subjectTrain <- read.table("./train/subject_train.txt")
activityTrain <- read.table("./train/y_train.txt")
featuresTrain <- read.table("./train/X_train.txt")

# read metadata
featureNames <- read.table("./features.txt")
activityLabels <- read.table("./activity_labels.txt")

# read test data
subjectTest <- read.table("./test/subject_test.txt")
activityTest <- read.table("./test/y_test.txt")
featuresTest <- read.table("./test/X_test.txt")
# end read data ###############################################################


# merge test and trian data
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

# set colnames
# as in metadata
colnames(features) <- t(featureNames[2])
# add Acivity
colnames(activity) <- "Activity"
# add Subject
colnames(subject) <- "Subject"

# Step #1. merge all into one.
data <- cbind(features,activity,subject)

# get columns with mean or std
meanOrStdColumns  <- grep(".*mean*|.*std*", names(completeData), ignore.case = TRUE)

# add Subject and Activity columns
newColumns <- c(meanOrStdColumns, 562, 563)

# Step #2. create new dataset
newData <- data[,newColumns]

# Step #3. Add descriptive activity labels from metadata
newData$Activity <- activityLabels[newData$Activity,2]

# Step #4. change the variable names to more descriptive and meaningful.
names(newData)<-gsub("^t", "Time", names(newData))
names(newData)<-gsub("^f", "Frequency", names(newData))
names(newData)<-gsub("tBody", "TimeBody", names(newData))
names(newData)<-gsub("-mean", "Mean", names(newData))
names(newData)<-gsub("-std", "SD", names(newData))
names(newData)<-gsub("-meanFreq", "MeanFrequency", names(newData))
names(newData)<-gsub("gravity", "Gravity", names(newData))
names(newData)<-gsub("Mag", "Magnitude", names(newData))

# Step #5. Create a tidy data set with the average of each variable for each activity and each subject.
newData <- data.table(newData)
tidyData <- newData[, lapply(.SD, mean), by="Activity,Subject"]
write.table(tidyData,file="./tidy.txt", row.names=FALSE)







