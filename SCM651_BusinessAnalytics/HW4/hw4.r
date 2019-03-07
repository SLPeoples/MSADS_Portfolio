fp <- "C:/Users/Ripti/Dropbox/Peoples/CSS143/Syracuse/1_Autumn18/SCM651_Business_Analytics/Assignments/HW4/"
dataset <- read.csv(paste(fp,'scm651_homework_4_universal_bank.csv', sep=''))

normalize <- function(x){(x-min(x))/(max(x)-min(x))}
dataset$Education <- normalize(dataset$Education)
dataset$Income <- normalize(dataset$Income)

#install.packages('neuralnet')
library(neuralnet)
library(caTools)


# Education, Income
dataset <- dataset[,c(2,5,9)]

split <- sample.split(dataset$PersonalLoan, SplitRatio = 0.75)
test_set <- subset(dataset, split == FALSE)
training_set <- subset(dataset, split == TRUE)

loan_net <- neuralnet(PersonalLoan ~ Education + Income
                        , training_set
                        , rep = 5
                        , hidden = 2
                        , lifesign = "minimal"
                        , linear.output = TRUE
                        , threshold = 0.15)

plot(loan_net, rep = "best")

loan_net.results <- compute(loan_net, test_set[,-1])
results <- data.frame(actual = test_set$PersonalLoan
                      , prediction = loan_net.results$net.result)
results$prediction <- round(results$prediction)
results$actual <- factor(results$actual, levels = c(0,1), labels = c("0","1"))
results$prediction <- factor(results$prediction, levels = c(0,1), labels = c("0","1"))

table(results$actual, results$prediction)

cm <- table(results$actual, results$prediction)
print(paste('Accuracy: ', 100*(cm[1]+cm[4])/sum(cm),'%',sep=''))


