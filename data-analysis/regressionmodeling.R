# set path
setwd("");

# load the dataset
movie <- read.csv(file = "movie_clean.csv", header=T, stringsAsFactors=F)

#plot imdb_score
library(ggplot2)
#ggplot(movie, aes(x=imdb_score)) + geom_histogram()

nums <- sapply(movie, is.numeric)
temp <- movie[,nums]
temp<-temp[sample(nrow(temp)),]
folds <- cut(seq(1,nrow(temp)),breaks=10,labels=FALSE)

#to store each mse i  for each fold of each model
mseknn <- c(1:10)
msert <- c(1:10)
mselm <- c(1:10)
mserf <- c(1:10)

#try modeling with slected features
#temp <- movie[,-c(2,7,10,11,14,18,21)]
#moviedata <- temp[,c(3,8,14,16)]

library("class")
library("FNN")
for(i in 1:10){
  #Segement your data by fold using the which() function 
  train <- which(folds==i,arr.ind=TRUE)
  temp_train <- temp[train, ]
  temp_test <- temp[-train, ]
  
  ###KNN Regression Model
  #Use the test and train data partitions however you desire...
  train.knn <- knn.reg(temp_train,temp_test,y=temp_train$imdb_score,k=5,algorithm = "brute")
  knn_dataframe <- data.frame(train.knn$pred,temp_test$imdb_score)
  print(ggplot(knn_dataframe, aes(x=train.knn$pred)) + geom_histogram(fill="white", colour="black")+xlim(1, 10)+ ggtitle("Predict Distribution with KNN Regression Model")+xlab("Pred.imdb_score"))
  mseknn[i] <- mean((temp_test$imdb_score-train.knn$pred)^2)
  
  ###multiple linear model
  #lmfit = lm(imdb_score~num_voted_users+budget+Drama+num_voted_users*Drama+budget*Drama,data=temp_train)
  lmfit= lm(imdb_score~.,data=temp_train)
  summary(lmfit)
  pred <- predict(lmfit,temp_test)
  lm_dataframe <- data.frame(pred,temp_test$imdb_score)
  print(ggplot(lm_dataframe, aes(x=pred)) + geom_histogram(fill="white", colour="black")+xlim(1, 10)+ ggtitle("Predict Distribution with Multiple Linear Model")+xlab("Pred.imdb_score"))
  mselm[i] <-mean((temp_test$imdb_score-pred)^2)
  
  ###Regression Tree Model
  library(rpart)
  library(rpart.plot)
  set.seed(3)
  #m.rpart <- rpart(imdb_score~num_voted_users+budget+Drama,data=temp_train)
  m.rpart <- rpart(imdb_score~.,data=temp_train)
  #rpart.plot(m.rpart,digits = 6)
  p.rpart <- predict(m.rpart,temp_test)
  tree_dataframe <- data.frame(p.rpart,temp_test$imdb_score)
  print(ggplot(tree_dataframe, aes(x=p.rpart)) + geom_histogram(fill="white", colour="black")+xlim(1, 10)+ ggtitle("Predict Distribution With Regression Tree Model")+xlab("Pred.imdb_score"))
  msert[i] <- mean((p.rpart-temp_test$imdb_score)^2)
  
  ###Random Forest Model
  set.seed(5)
  library(randomForest)
  #rf <- randomForest(imdb_score~num_voted_users+budget+Drama,data=temp[train,],ntree=500,mtry=floor(dim(temp)[2]/3))
  rf <- randomForest(imdb_score~.,data=temp[train,],ntree=500,mtry=floor(dim(temp)[2]/3))
  pred_rf <- predict(rf,temp[-train,])
  rf_dataframe <- data.frame(pred_rf,temp_test$imdb_score)
  print(ggplot(rf_dataframe, aes(x=pred_rf)) + geom_histogram(fill="white", colour="black")+xlim(1, 10)+ ggtitle("Predict Distribution with Random Forest Model with ntree=500")+xlab("Pred.imdb_score"))
  mserf[i] <- mean((pred_rf-temp_test$imdb_score)^2)
  
  ###Print distribution of test data
  print(ggplot(temp_test, aes(x=temp_test$imdb_score)) + geom_histogram(fill="white", colour="black")+xlim(1, 10)+ ggtitle("TestData Distribution")+xlab("test.imdb_score"))
}
mean(mseknn)
mean(mselm)
mean(msert)
mean(mserf)