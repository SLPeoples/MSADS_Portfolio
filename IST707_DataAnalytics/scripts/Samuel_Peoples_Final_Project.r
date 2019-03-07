# Author: Samuel L. Peoples
library(caTools)
library(rpart)
library(rpart.plot)
library(e1071)

fp = "C:/Users/Ripti/Dropbox/Peoples/CSS143/Syracuse/1_Autumn18/IST707_Data_Analytics/Assignments/Project/"
dataset = read.csv(paste(fp,'mushrooms_encoded.csv', sep=''))

which(is.na(dataset))
str(dataset)

# Most common among all
sums <- as.data.frame(colSums(dataset[,-1]))
names(sums) <- "sum"
sums$feature <- rownames(sums)
sums$class <- length(dataset$class)
sums$feature[which.max(sums$sum)]

# Most common among edible
dataset_e <- dataset[which(dataset$class == 'e'),]
sums <- as.data.frame(colSums(dataset_e[,-1]))
names(sums) <- "sum"
sums$feature <- rownames(sums)
sums$class <- length(dataset$class)
sums$feature[which.max(sums$sum)]

# Most common among poisonous
dataset_p <- dataset[which(dataset$class == 'p'),]
sums <- as.data.frame(colSums(dataset_p[,-1]))
names(sums) <- "sum"
sums$feature <- rownames(sums)
sums$class <- length(dataset$class)
sums$feature[which.max(sums$sum)]


# Ensuring the dataset is encoded properly
dataset[] <- lapply(dataset, factor)

# Reassigning the class factor labels
levels(dataset$class) <- c("Edible", "Poisonous")

str(dataset)

"
 Decision Trees
"
dt_result <- c()
dt_start <- proc.time()
for(i in 1:5){
  split <- sample.split(dataset$class, SplitRatio = 0.70)
  test_set <- subset(dataset, split == FALSE)
  training_set <- subset(dataset, split == TRUE)
  # Fitting Decision Tree Classification to the Training Set
  dt_classifier <- rpart(formula = class ~.,
                         data = training_set,
                         minsplit = 30,
                         maxdepth = 10,
                         cp = .01)
  if(i == 1){
    dt_classifier_1 <- dt_classifier
  }
  if(i == 2){
    dt_classifier_2 <- dt_classifier
  }
  if(i == 3){
    dt_classifier_3 <- dt_classifier
  }
  if(i == 4){
    dt_classifier_4 <- dt_classifier
  }
  if(i == 5){
    dt_classifier_5 <- dt_classifier
  }
  # Predicting the Test Set results
  dt_pred <- predict(dt_classifier, 
                     newdata = test_set[-1], 
                     type = 'class')
  # Creating the confusion_matrix
  dt_cm <- table(test_set[,1], dt_pred)
  dt_acc <- (dt_cm[1]+dt_cm[4]) / (dt_cm[1]+dt_cm[2]+dt_cm[3]+dt_cm[4])
  dt_result <- c(dt_result,dt_acc)
}
dt_end = proc.time()

"
Naive Bayes
"
nb_result <- c()
nb_start <- proc.time()
for(i in 1:5){
  split <- sample.split(dataset$class, SplitRatio = 0.70)
  test_set <- subset(dataset, split == FALSE)
  training_set <- subset(dataset, split == TRUE)
  # Fitting Naive Bayes Classifier to the training set
  nb_classifier <- naiveBayes(formula = class~.,
                              data = training_set,
                              laplace = .01,
                              threshold = .1)
  if(i == 1){
    nb_classifier_1 <- nb_classifier
  }
  if(i == 2){
    nb_classifier_2 <- nb_classifier
  }
  if(i == 3){
    nb_classifier_3 <- nb_classifier
  }
  if(i == 4){
    nb_classifier_3 <- nb_classifier
  }
  if(i == 5){
    nb_classifier_3 <- nb_classifier
  }
  # Predicting the Test Set results
  nb_pred <- predict(nb_classifier, 
                     newdata = test_set[-1])
  # Creating the confusion_matrix
  nb_cm <- table(test_set[,1], nb_pred)
  nb_acc <- (nb_cm[1]+nb_cm[4]) / (nb_cm[1]+nb_cm[2]+nb_cm[3]+nb_cm[4])
  nb_result <- c(nb_result,nb_acc)
}
nb_end <- proc.time()

print(paste("DT Result:", dt_result[1],dt_result[2]
            ,dt_result[3],dt_result[4],dt_result[5]))
dt_result <- (dt_result[1]+dt_result[2]+dt_result[3])/3
print(paste("DT Average:",dt_result))
print(paste("Time:",(dt_end-dt_start)[3],"seconds"))

print(paste("NB Result:",nb_result[1],nb_result[2]
            ,nb_result[3],nb_result[4],nb_result[5]))
nb_result <- (nb_result[1]+nb_result[2]+nb_result[3])/3
print(paste("NB Average:",nb_result))
print(paste("Time:",(nb_end-nb_start)[3],"seconds"))

# Plotting the Decision Tree
rpart.plot(dt_classifier_2)