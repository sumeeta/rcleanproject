
# set the directory totest
setwd("C:/Users/ssrprog/R/CleaningData/proj/UCI HAR Dataset/test")
#read files in test
test_X <- read.table("X_test.txt",sep="", header=FALSE)
test_label <- read.table("y_test.txt",sep="", header=FALSE)
test_subject <- read.table("subject_test.txt",sep="", header=FALSE)
# set descriptive column names
colnames(test_label) <- c("activityID")
colnames(test_subject) = c("subectID")

# set the directory to  train
setwd("C:/Users/ssrprog/R/CleaningData/proj/UCI HAR Dataset/train")

#read files in train
train_X <- read.table("X_train.txt",sep="", header=FALSE)
train_label <- read.table("y_train.txt",sep="", header=FALSE)
train_subject <- read.table("subject_train.txt",sep="", header=FALSE)

# set descriptive column names
colnames(train_label) <- c("activityID")
colnames(train_subject) = c("subjectID")

# set the directory to upper level
setwd("C:/Users/ssrprog/R/CleaningData/proj/UCI HAR Dataset/")

# read in the variable descriptions in features
feature_col <- read.table("features.txt",sep="", header=FALSE)
#delete the first column
feature_col$V1 = NULL
#transpose the data frame to get the variable names as a row
transp_feature <- t(feature_col)
# set column names for the train and test data frames
colnames(test_X) <- transp_feature[1,]
colnames(train_X) <- transp_feature[1,]

#drop all variables that do not have mean and standard deviationes
test_mean_std <- test_X[,grep("*-mean|-std*", names(test_X))]
train_mean_std <- train_X[,grep("*-mean|-std*", names(train_X))]

# read in activity labels and set new descriptive solumn names
activity_labels <- read.table("activity_labels.txt",sep="", header=FALSE)
colnames(activity_labels) <- c("activityID", "activity")

# merge the activity labesl with the test and train label data
test_activity_label_merge <- merge(test_label,activity_labels,by="activityID")
train_activity_label_merge <- merge(train_label,activity_labels,by="activityID")

# use cbind to join these with the test or train data
test_withlabels <- cbind(test_activity_label_merge,test_mean_std )
test <- cbind(test_subject,test_withlabels)
train_withlabels <- cbind(train_activity_label_merge,train_mean_std)
train <- cbind(train_subject,train_withlabels)

#use rbind to combine test and train data
test_train <- rbind(test,train)

#mean of variables by subject, activity
#mean_by_subject_by_activity <-aggregate(test_train, by=list(test_train$subectID,test_train$activityID),FUN=mean, na.rm=TRUE)
mean_by_subject_by_activity <- aggregate(. ~ (test_train$subectID + test_train$activityID), data = test_train, mean)
mean_by_subject_by_activity_labels <- merge(activity_labels,mean_by_subject_by_activity,by="activityID")

#drop extra variables
mean_by_subject_by_activity_labels$Group.1 = NULL
mean_by_subject_by_activity_labels$Group.2 = NULL
mean_by_subject_by_activity_labels$activity.y = NULL

#output results
write.table(test_train,"original_tidydata.txt")
write.table(mean_by_subject_by_activity_labels,"aggregated_tidydata.txt")
