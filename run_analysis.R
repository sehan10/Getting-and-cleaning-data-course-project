library(reshape2)

setwd("E:/Coursera/RCode/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")

# loading Activity Labels from activity_labels.txt

activity_label <- read.table("activity_labels.txt")
activity <- activity_label
activity_label <- activity_label$V2

# loading Feature from features.txt

features <- read.table("features.txt")
features <- features$V2

# Extracting only features having mean() or std() in it

featuresWanted <- grep(".*mean.*|.*std.*", features)
name <- features[featuresWanted]
name <- gsub('-mean', 'Mean', featuresWanted.name)
name <- gsub('-std', 'Std', featuresWanted.name)
name <- gsub('[-()]', '', featuresWanted.name)


# Loading training datasets
train_X <- read.table("train/X_train.txt")[featuresWanted]
train_Y <- read.table("train/Y_train.txt")
train_Subject <- read.table("train/subject_train.txt")
train <- cbind(train_Subject, train_Y, train_X)

# Loading testing datasets
test_X <- read.table("test/X_test.txt")[featuresWanted]
test_Y <- read.table("test/Y_test.txt")
test_Subject <- read.table("test/subject_test.txt")
test <- cbind(test_Subject, test_Y, test_X)


# merge datasets and add labels
Combine <- rbind(train, test)
colnames(Combine) <- c("subject", "activity", name)

# Converting activity and subject into factor 

Combine$activity <- factor(Combine$activity, levels = activity[,1], labels = activity[,2])
Combine$subject <- as.factor(Combine$subject)


Combine.melted <- melt(Combine, id = c("subject", "activity"))
Combine.mean <- dcast(Combine.melted, subject + activity ~ variable, mean)

# Writing to a text file
write.table(Combine.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
