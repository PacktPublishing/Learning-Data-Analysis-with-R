#Volume 3
#Section 6
#Video 3

#Author: Dr. Fabio Veronesi

#Load Packages
library(MASS)
library(caret)
library(hydroGOF)
library(glmnet)
library(lars)


#Load Data
data(Boston)


#Multi-Linear Regression
LM.model <- lm(medv~.,data=Boston)

summary(LM.model)

LM.pred <- predict(LM.model, Boston)

rmse(LM.pred, Boston$medv)


#Cross-Validation - Linear Model
k_folds <- createFolds(y=1:nrow(Boston),k=5)

save(k_folds, file="K_folds.RData")

RMSE <- c()
for(i in 1:5){
  training <- Boston[-k_folds[[i]],]
  test     <- Boston[k_folds[[i]],]
  
  LM.model <- lm(medv~.,data=training)
  
  LM.pred <- predict(LM.model, test)
  
  RMSE[i] <- rmse(LM.pred, test$medv)
}

mean(RMSE)





#Cross-Validation - LASSO
RMSE <- c()
for(i in 1:5){
  training <- Boston[-k_folds[[i]],]
  test     <- Boston[k_folds[[i]],]
  
  x <- model.matrix(medv~.,data=training) 
  y <- training$medv
  
  x.pred <- model.matrix(medv~.,data=test)
  
  LS.model <- lars(x, y, type="lasso")
  
  best_step <- LS.model$df[which.min(LS.model$RSS)]
  
  LS.pred <- predict(LS.model, x.pred, s=best_step, type="fit")$fit
  
  RMSE[i] <- rmse(as.numeric(LS.pred), test$medv)
}

mean(RMSE)




#Cross-Validation - Ridge Regression
RMSE <- c()
for(i in 1:5){
  training <- Boston[-k_folds[[i]],]
  test     <- Boston[k_folds[[i]],]
  
  x <- model.matrix(medv~.,data=training) 
  y <- training$medv
  
  x.pred <- model.matrix(medv~.,data=test)
  
  RR.CV <- cv.glmnet(x, y, family="gaussian", alpha=0)
  
  RR.model <- glmnet(x, y, family="gaussian", alpha=0, 
                     lambda=RR.CV$lambda.min)
  
  RR.pred <- predict(RR.model, x.pred, type="link")
  
  RMSE[i] <- rmse(as.numeric(RR.pred), test$medv)
}

mean(RMSE)