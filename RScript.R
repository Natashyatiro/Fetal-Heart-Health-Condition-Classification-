# ================================================================
# Purpose:      Rscript for AN6003 Analytics Strategy Project 
# Author:       Team 5 (Class B)
# DOC:          17-09-2022
# Updated:      
# Topics:       Machine Learning Models to Interpret CTG Data
# Data Source:  The Biomedical Engineering Institute and the Faculty of Medicine at the University of Porto
#=================================================================

#Libraries
library(data.table)
library(ggplot2)
library(caTools)
library(randomForest)
library(datasets)
library(caret)

#========= Data Exploration, Preparation, Cleaning =========
setwd("C:/Users/NATASHYA TIRO/OneDrive/Desktop/MSBA/AN6003 - Analytics Strategy - Copy/Team Project Proposal and Project Requirements/Project Deliverables")
df <- read.csv('CTG.csv')
summary(df)

# Delete unnecessary column / attribute
df =subset(df,select = -c(FileName, Date, SegFile, b, e, DR, CLASS))
## DR contains 0 which means in this case there is no Repetitive decelarations, and we remove this rare categorical X

# Check null values
sum(is.na(df))

null_rows = which(is.na(df[[1]])) 
null_rows # Only 3 rows so we decided to drop them

df=df[-c(null_rows),]#delete dirty rows

sum(is.na(df))

# Check several data columns into categorical data
df$DL=factor(df$DL)
df$DS=factor(df$DS)
df$DP=factor(df$DP)
df$A=factor(df$A)
df$B=factor(df$B)
df$C=factor(df$C)
df$D=factor(df$D)
df$E=factor(df$E)
df$Tendency=factor(df$Tendency,levels = c(-1,0,1),labels = c('left assymetric','symmetric','right assymetric'))
df$AD=factor(df$AD)
df$DE=factor(df$DE)
df$LD=factor(df$LD)
df$FS=factor(df$FS)
df$SUSP=factor(df$SUSP)
df$NSP <- factor(df$NSP, labels = c("Normal", "Suspect", "Pathological"))


# Check number of normal, suspect and pathological data in the dataset
summary(df$NSP)

# Visualize total number of normal, suspect and pathological data in the dataset
plot(df$NSP, main="Distribution of Normal, Suspect and Pathological Cases", ylab = "Number of Cases")

# Use subsample method handle unbalanced data
unique(df$NSP)
subset1 <- df[df$NSP == "Normal",] #controls
max(sum(df$NSP == "Normal"),sum(df$NSP == "Suspect"),sum(df$NSP == "Pathological"))
row.name1 <- rownames(df[df$NSP == "Suspect",])
row.name2 <- rownames(df[df$NSP == "Pathological",])

set.seed(1)
resample1 <- sample(row.name1, nrow(subset1), replace = T)
set.seed(1)
resample2 <- sample(row.name2, nrow(subset1), replace = T)#resampling
subset2 <- df[resample1,]
subset3 <- df[resample2,]#cases

df<- rbind(subset1,subset2,subset3)

# Visualize total number of normal, suspect and pathological data in the dataset
plot(df$NSP, main="Distribution of Normal, Suspect and Pathological Cases After Balancing", ylab = "Number of Cases")

#========= Feature Engineering =========
# Z-score normalization on columns / attributes with numerical data type
for(i in c(1:9,13:21)){
  df[,i]=(df[,i]-mean(df[,i]))/sd(df[,i])
}

# ========= Model Training =========
# Split the dataset into train and test set
dt = copy(df)
setDT(dt)
set.seed(1)
train <- sample.split(df$NSP, SplitRatio = 0.7)
trainset <- dt[train == T]
testset <- dt[train == F]

#========= Logistic Regression for Multicategory Y =========
# ---Training the Model ---
library(nnet)
m1=multinom(NSP~., data=trainset)
summary(m1)
library(stargazer)
stargazer(m1, type="text")
#stargazer(m1, type="html", out="logit.html")

# ---Test the Model ---
log.yhat = predict(m1,newdata = testset,'class')

# Construct a confusion matrix
confusionMatrix(log.yhat, testset$NSP)

#========= CART Model =========
library(rpart)
library(rpart.plot)

# ---Training the Model ---
set.seed(1) 
m2 <- rpart(NSP ~ ., data = trainset, method = "class",
            control = rpart.control(minsplit = 2, cp = 0))

# the maximal tree and results
rpart.plot(m2, nn = T, main = "Maximal Tree in CTG")
library("rattle")
fancyRpartPlot(m2, main = "Maximal Tree in CTG",
               type = 0, palettes = c("Greys", "Blues")) # visualization more beautiful
print(m2, digits = 3)

# display the pruning sequence and 10-folder CV errors
printcp(m2)
plotcp(m2)

# extract the best tree
CVerror.cap <- m2$cptable[which.min(m2$cptable[,"xerror"]), "xerror"] + 
  m2$cptable[which.min(m2$cptable[,"xerror"]), "xstd"]

i <- 1; j<- 4
while (m2$cptable[i,j] > CVerror.cap) {
  i <- i + 1
}

cp.opt = ifelse(i > 1, sqrt(m2$cptable[i,1] * m2$cptable[i-1,1]), 1)

set.seed(1) 
m2.best <- prune(m2, cp = cp.opt)
printcp(m2.best, digits = 3)

# get the variable importance
m2.best$variable.importance
m2.best.scaledVarImpt <- round(100*m2.best$variable.importance/sum(m2.best$variable.importance))
m2.best.scaledVarImpt

m2.best.rules <- rpart.rules(m2.best, nn = T, cover = T)
View(m2.best.rules)  ## View just the decision rules.
print(m2.best) ## View the tree on the console.
printcp(m2.best)  ## View Overall Errors at last row.

# To view surrogates
summary(m2.best)

# --- Testing the model ---
set.seed(1) 
cart.yhat <- predict(m2.best, newdata = testset, type = "class")

# Construct a confusion matrix
confusionMatrix(cart.yhat, testset$NSP)

#========= Random Forest =========
# ---Training the Model ---
set.seed(1)  # for Bootstrap sampling & RSF selection.

m.RF.final = randomForest(NSP  ~ . , data = trainset, na.action = na.omit, importance = T)
m.RF.final

# ---Testing the Model ---
RF.yhat = predict(m.RF.final, newdata = testset)

# Construct a confusion matrix
confusionMatrix(RF.yhat, testset$NSP)

# --- Visualization ---
# No. of nodes for the trees
hist(treesize(m.RF.final),
     main = "No. of Nodes for the Trees",
     col = "green")

# Variable Importance
varImpPlot(m.RF.final,
           sort = T,
           main = "Variable Importance")
