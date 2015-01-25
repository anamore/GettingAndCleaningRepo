## read data
xtrain_data<-read.table("./UCI HAR Dataset/train/X_train.txt")
xtest_data<-read.table("./UCI HAR Dataset/test/X_test.txt")

ytrain_data<-read.table("./UCI HAR Dataset/train/y_train.txt")
ytest_data<-read.table("./UCI HAR Dataset/test/y_test.txt")

subjecttrain_data<-read.table("./UCI HAR Dataset/train/subject_train.txt")
subjecttest_data<-read.table("./UCI HAR Dataset/test/subject_test.txt")

features_data<-read.table("./UCI HAR Dataset/features.txt")
activity_data<-read.table("./UCI HAR Dataset/activity_labels.txt")

## add activity info to datasets
names(ytrain_data)<-"Activity"
names(ytest_data)<-"Activity"
xtrain_data<-cbind(ytrain_data, xtrain_data)
xtest_data<-cbind(ytest_data, xtest_data)

## add subject info to datasets
names(subjecttrain_data)<-"Subject"
names(subjecttest_data)<-"Subject"
xtrain_data<-cbind(subjecttrain_data, xtrain_data)
xtest_data<-cbind(subjecttest_data, xtest_data)

## merge train and test datasets
x_data<-rbind(xtrain_data,xtest_data)

## search for mean and std columns 
features_data$V2<-as.character(features_data$V2)
names_data<-rbind(c(0,"Subject"),c(0,"Activity"),features_data)
ind<-grep("mean\\(\\)|std\\(\\)", names_data$V2)
ind<-c(1,2,ind)

## select column names
names_sel<-names_data[ind,2]

## select variables
x_sel<-x_data[,ind]


## change to descriptive activity names
x_sel$Activity<-factor(x_sel$Activity)
levels(x_sel$Activity)<-activity_data$V2


## change to descriptive variables names
names_sel<-sub("^t","Time",names_sel)
names_sel<-sub("^f","Frequency",names_sel)
names_sel<-sub("mean","Mean",names_sel)
names_sel<-sub("std","Std",names_sel)
names_sel<-sub("Acc","Accelerometer",names_sel)
names_sel<-sub("Gyro","Gyroscope ",names_sel)
names_sel<-sub("Mag","Magnitude",names_sel)
names_sel<-sub("BodyBody","Body",names_sel)
names_sel<-gsub("[[:punct:]]","",names_sel)


## add variable names to dataset
names(x_sel)<-names_sel


## aggregate (mean) by subject and activity
tidy_data<-aggregate(x_sel[,3:ncol(x_sel)],by=list(x_sel$Activity,x_sel$Subject),mean)
tidy_data<-tidy_data[,c(2,1,3:ncol(tidy_data))]
names(tidy_data)[1]<-"Subject"
names(tidy_data)[2]<-"Activity"

## create table in txt file
write.table(tidy_data, file="tidy_data.txt", row.names=FALSE)
