#Load data
whales_train<-read.csv('train.csv', header = T)

#Summary of data
summary(whales_train)

#Length of the training dataset
nrow(whales_train)
dim(whales_train)

## Number of individual whales in the training set
length(unique(whales_train$whaleID))

#Any missing data?
whales_train[is.na(whales_train)]
#Nope






