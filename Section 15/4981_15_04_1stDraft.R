#Volume 3
#Section 6
#Video 3

#Author: Dr. Fabio Veronesi

#Load Packages
library(caret)
library(hydroGOF)
library(rpart)
library(randomForest)
library(gbm)
library(MASS)


#Load Data
data(Boston)


#CART
CART.model <- rpart(medv~.,data=Boston)

printcp(CART.model)
plotcp(CART.model)


plot(CART.model, uniform=T, 
     main="")
text(CART.model, use.n=T, all=T, cex=.8, pos=1, offset=0.9)



Prune <- prune(CART.model, 
               cp=CART.model$cptable[
                 which.min(CART.model$cptable[,"xerror"]),"CP"])

predict(Prune, Boston)



#Cross-Validation - CART
load("K_folds.RData")

RMSE <- c()
for(i in 1:5){
  training <- Boston[-k_folds[[i]],]
  test     <- Boston[k_folds[[i]],]
  
  CART.model <- rpart(medv~.,data=training)
  
  Prune <- prune(CART.model, 
                 cp=CART.model$cptable[which.min(CART.model$cptable[,"xerror"]),"CP"])
  
  CART.pred <- predict(Prune, test)
  
  RMSE[i] <- rmse(CART.pred, test$medv)
}

mean(RMSE)





#Cross-Validation - Boosting
RMSE <- c()
for(i in 1:5){
  training <- Boston[-k_folds[[i]],]
  test     <- Boston[k_folds[[i]],]
  
  BOOST.model <- gbm(medv~.,data=training, n.trees=5000, 
                     shrinkage = 0.01, interaction.depth = 4)
  
  n.trees = seq(from = 100, to = 5000, by = 100)
  BOOST.pred <- predict(BOOST.model, newdata = test, n.trees = n.trees)
  
  rmse.list <- apply(BOOST.pred, 2, 
                     function(x){rmse(as.numeric(x),test$medv)})
  
  RMSE[i] <- rmse.list[which.min(rmse.list)]
}

mean(RMSE)




#Cross-Validation - RandomForest
RMSE <- c()
for(i in 1:5){
  training <- Boston[-k_folds[[i]],]
  test     <- Boston[k_folds[[i]],]
  
  RF.model <- randomForest(medv~.,data=training)
  
  RF.pred <- predict(RF.model, test)
  
  RMSE[i] <- rmse(as.numeric(RF.pred), test$medv)
}

mean(RMSE)


