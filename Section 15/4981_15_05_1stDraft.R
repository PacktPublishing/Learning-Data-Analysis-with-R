#Volume 3
#Section 6
#Video 3

#Author: Dr. Fabio Veronesi

#Load Packages
library(caret)
library(hydroGOF)
library(kernlab)
library(MASS)

#Load Data
data(Boston)


#Folds for CV
load("K_folds.RData")


#Cross-Validation - SVMLinear
RMSE <- c()
for(i in 1:5){
  training <- Boston[-k_folds[[i]],]
  test     <- Boston[k_folds[[i]],]
  
  control <- trainControl(method="repeatedcv", number=10, repeats=3)
  
  grid_rf <- expand.grid(.C = c(1, 2, 5, 10))
  
  SVM.model <- train(medv~., data=training, 
                     method="svmLinear", trControl=control,
                     tuneGrid = grid_rf)
  
  SVM.pred <- predict(SVM.model, test)
  
  RMSE[i] <- rmse(SVM.pred, test$medv)
}

mean(RMSE)



#Cross-Validation - SVM Radial
RMSE <- c()
for(i in 1:5){
  training <- Boston[-k_folds[[i]],]
  test     <- Boston[k_folds[[i]],]
  
  control <- trainControl(method="repeatedcv", number=10, repeats=3)
  
  grid_rf <- expand.grid(.C = c(1, 2, 5, 10), .sigma=c(0.25, 0.5, 1))
  
  SVM.model <- train(medv~., data=training, 
                     method="svmRadial", trControl=control,
                     tuneGrid = grid_rf)
  
  SVM.pred <- predict(SVM.model, test)
  
  RMSE[i] <- rmse(SVM.pred, test$medv)
}

mean(RMSE)