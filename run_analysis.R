# Processes the UCI HAR dataset
library(reshape2)

## Measurements (1-561)
features = read.table("UCI HAR Dataset/features.txt")
colnames(features) = c("Number","Feature")

## Activity labels (1-6)
activity_labels = read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels) = c("Number","Activity.Label")

## Activity vectors
y_test = scan("UCI HAR Dataset/test/y_test.txt")
y_train = scan("UCI HAR Dataset/train/y_train.txt")

## Subject vectors (1-30)
subject_test = scan("UCI HAR Dataset/test/subject_test.txt")
subject_train = scan("UCI HAR Dataset/train/subject_train.txt")

## Datasets
X_test = read.table("UCI HAR Dataset/test/X_test.txt")
X_train = read.table("UCI HAR Dataset/train/X_train.txt")

# Label the data set with descriptive variable names
colnames(X_test) = features$Feature
colnames(X_train) = features$Feature

# Add subject and activity vectors
X_test$Subject = subject_test
X_train$Subject = subject_train
X_test$Activity = y_test
X_train$Activity = y_train

# Merge the training and the test sets to create one data set
X = rbind(X_test,X_train)

# Add descriptive activity names for the activities
X = merge(X,activity_labels,by.x="Activity",by.y="Number",all.x=TRUE)

# Extract only the measurements on the mean and standard deviation for each measurement
mean_features = grep("mean()",features$Feature,value=TRUE)
std_features = grep("std()",features$Feature,value=TRUE)

X_mstd = X[,c("Subject","Activity.Label",mean_features,std_features)]

# Create a second, independent tidy data set with the average of each variable for each activity and each subject
X_means = aggregate(data=X_mstd,.~Subject+Activity.Label,mean)
write.table(X_means,file="X_means.txt",sep='\t',quote=FALSE,row.names = FALSE)
