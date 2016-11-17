---
title: "Imdb Movie Analyzing Project"
author: "Jing Hua"
date: "November 16,2016"
---


#Description
After scraping data from imdb, I tried to use R to analyze the data.  
But since my data is just a little, I used the complete data set from kaggle to do regression analysis.
Independent Variable: imdb_score

#Files explanation
movie_metadata.csv:original data set  
movie_clean.csv: cleaned data set  
cleandata.r: File used to clean data  
featureSelection.r:  File used to select top important features  
featureselectionresult.png: plot of important features
regressionmodeling.r: regression modeling file using sequentially sampling method  
regressionmodelingrandomsampling.r: regression modeling file using random sampling method  
RegressionResult.txt: Regression Result(MSE)
PredictionDistributionplots.png: Prediction Distribution Comparison Plots 

#Reference
kaggle imdb movie dataset [link][1]  
feature selection: boruta [link][2]
[1]: https://www.kaggle.com/deepmatrix/imdb-5000-movie-dataset
[2]: https://www.analyticsvidhya.com/blog/2016/03/select-important-variables-boruta-package/
