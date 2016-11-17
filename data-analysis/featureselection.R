#https://www.analyticsvidhya.com/blog/2016/03/select-important-variables-boruta-package/

# load the library
library(Boruta)

# load the dataset
train <- read.csv(file = "movie_clean.csv")

#print number of factors for each factor feature
for (n in names(train))
  if (is.factor(train[[n]])) {
    print(match(n,names(train)))
    print(n)
    print(summary(levels(train[[n]])))
  }

#get rid of those features with too many factors
traindata <- train[,-c(2,7,10,11,14,18,21)]

set.seed(123)
boruta.train <- Boruta(imdb_score~., data = traindata, maxRuns = 100, doTrace = 2)
print(boruta.train)

#plot importance
plot(boruta.train, xlab = "", xaxt = "n")
lz<-lapply(1:ncol(boruta.train$ImpHistory),function(i)
  boruta.train$ImpHistory[is.finite(boruta.train$ImpHistory[,i]),i])
names(lz) <- colnames(boruta.train$ImpHistory)
Labels <- sort(sapply(lz,median))
axis(side = 1,las=2,labels = names(Labels),
     at = 1:ncol(boruta.train$ImpHistory), cex.axis = 0.7)

#process tentative feature
final.boruta <- TentativeRoughFix(boruta.train)
print(final.boruta)
getSelectedAttributes(final.boruta, withTentative = F)
boruta.df <- attStats(final.boruta)
class(boruta.df)

print(boruta.df)

#store importance result
library(xlsx)
#write.xlsx(boruta.df, "finalselection2.xlsx")

boruta.sf1 <- boruta.df[order(boruta.df$meanZ, decreasing = TRUE),]
write.xlsx(boruta.sf1, "finalselectionsorteddecresing2.xlsx")

