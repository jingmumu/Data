##### Read in the original dataset #####
movie <- read.csv(file = "movie_metadata.csv", header = TRUE, stringsAsFactors = FALSE, na.strings = "NA")

##### Clean the missing values #####
## var 1: color
table(movie$color) ## get a count of color
# there are 19 empty cells we need to treat as "Unknown"
movie$color[movie$color %in% c("")] <- "Unknown"
table(movie$color) ## check it

## var 2: director_name
movie$director_name[movie$director_name %in% c("")] <- "Unknown"

## var 3: num_critic_for_reviews
# get the summary
summary(movie$num_critic_for_reviews)
hist(movie$num_critic_for_reviews)
# use the mean 140 to instead of NAs
movie$num_critic_for_reviews[is.na(movie$num_critic_for_reviews)] <- 140
summary(movie$num_critic_for_reviews)
hist(movie$num_critic_for_reviews)

## var 4: duration
summary(movie$duration)
hist(movie$duration)
# use the mean 107 to instead of NA's
movie$duration[is.na(movie$duration)] <- 107
summary(movie$duration)
hist(movie$duration)

## var 5: director_facebook_likes
summary(movie$director_facebook_likes)
hist(movie$director_facebook_likes)
# use the mean 687 to instead of NA's
movie$director_facebook_likes[is.na(movie$director_facebook_likes)] <- 687
summary(movie$director_facebook_likes)
hist(movie$director_facebook_likes)

## var 6: actor_3_facebook_likes
summary(movie$actor_3_facebook_likes)
hist(movie$actor_3_facebook_likes)
# use the mean 645 to instead of NA's
movie$actor_3_facebook_likes[is.na(movie$actor_3_facebook_likes)] <- 645
summary(movie$actor_3_facebook_likes)
hist(movie$actor_3_facebook_likes)

## var 7:actor_2_name
movie$actor_2_name[movie$actor_2_name %in% c("")] <- "Unknown"

## var 8:actor_1_facebook_likes
summary(movie$actor_1_facebook_likes)
hist(movie$actor_1_facebook_likes)
# use the mean 6560 to instead of NA's
movie$actor_1_facebook_likes[is.na(movie$actor_1_facebook_likes)] <- 6560
summary(movie$actor_1_facebook_likes)
hist(movie$actor_1_facebook_likes)

## var 9: gross
# cause inflation, we need to fill the gross with year
movie$title_year[is.na(movie$title_year)] <- "Unknown"
# get a data frame without NA's in gross
temp <- cbind.data.frame(movie$title_year, movie$gross)
temp <- temp[!is.na(temp$`movie$gross`),]
temp_mean <- aggregate(`movie$gross` ~ `movie$title_year`, data = temp, mean)
## not all year are shown in the temp_mean
all_year <- unique(movie$title_year)
all_year <- as.data.frame(all_year)
# left_join
library(dplyr)
colnames(all_year) <- c("year")
colnames(temp_mean) <- c("year", "mean_gross")
all_year_mean <- left_join(x = all_year, y = temp_mean)
#sort
all_year_mean <- all_year_mean[order(all_year_mean$year),]
rownames(all_year_mean) <- c(1:92)
# inflation calculator http://www.usinflationcalculator.com/
all_year_mean$mean_gross[1] <- 1635000
all_year_mean$mean_gross[3] <- 2625000
all_year_mean$mean_gross[6] <- 1376016.52
all_year_mean$mean_gross[7] <- 2423846.15
all_year_mean$mean_gross[9] <- 2370769.23
all_year_mean$mean_gross[13] <- 181072870.73
all_year_mean$mean_gross[16] <- 84367500.00
all_year_mean$mean_gross[18] <- 109103723.62
all_year_mean$mean_gross[19] <- 110995696.09
all_year_mean$mean_gross[20] <- 20330769.23
all_year_mean$mean_gross[24] <- 2919203.32
all_year_mean$mean_gross[26] <- 8630705.39
all_year_mean$mean_gross[30] <- 4916186.02
all_year_mean$mean_gross[31] <- 26328825.62
all_year_mean$mean_gross[33] <- 27974377.22
# fill the empty
for (i in 1:length(movie$gross)) {
  if (is.na(movie$gross[i])) {
    movie$gross[i] <- all_year_mean$mean_gross[all_year_mean$year %in% c(movie$title_year[i])]
  }
}

## var 10: genres
library(stringr)
GENRES <- as.data.frame(movie$genres)
GENRES$`movie$genres` <- as.character(GENRES$`movie$genres`)
GENRES_split <- strsplit(GENRES$`movie$genres`, split ="[|]")
allgenres <- character(length = 100000000L)
for (i in 1:5043) {
  for (j in 1:length(GENRES_split[[i]])) {
    k = paste(i, j)
    k <- str_replace(k, " ", "")
    k <- as.integer(k)
    allgenres[k] <- GENRES_split[[i]][j]
  }
}
uniquegenres <- unique(allgenres)
uniquegenres_table <- as.data.frame(uniquegenres)
uniquegenres_table <- as.data.frame(uniquegenres_table[-1,])
dummygenres <- matrix(0, ncol = 26, nrow = 5043)
dummygenres <- data.frame(dummygenres)
colnames(dummygenres) <- c("Action", "Adventure", "Fantasy", "Sci-Fi", "Thriller",
                           "Documentary", "Romance", "Animation", "Comedy", "Family",
                           "Musical", "Mystery", "Western", "Drama", "History",
                           "Sport", "Crime", "Horror", "War", "Biography",
                           "Music", "Game-Show", "Reality-TV", "News", "Short",
                           "Film-Noir")
for (i in 1:5043) {
  for (j in 1:length(GENRES_split[[i]])) {
    for (k in 2:27) {
      if (GENRES_split[[i]][j] %in% uniquegenres[k]) {
        dummygenres[i,colnames(dummygenres) %in% uniquegenres[k]] <- 1
      }
    }
  }
}
# combine this dataframe with original movie
movie <- cbind.data.frame(movie, dummygenres)
# remove the generes
movie <- subset(movie, select = -genres)

## var 11: actor_1_name
movie$actor_1_name[movie$actor_1_name %in% c("")] <- "Unknown"

## var 12: movie_title
movie$movie_title[movie$movie_title %in% c("")] <- "Unknown"

## var 13: num_voted_users
summary(movie$num_voted_users)
hist(movie$num_voted_users)
# no NAs

## var 14: cast_total_facebook_likes
summary(movie$cast_total_facebook_likes)
# no NAs

## var 15: actor_3_name
movie$actor_3_name[movie$actor_3_name %in% c("")] <- "Unknown"  

## var 16: facenumber_in_poster
summary(movie$facenumber_in_poster)
movie$facenumber_in_poster[is.na(movie$facenumber_in_poster)] <- "Unknown"

## var 17: plot_keywords
keywords <- as.data.frame(movie$plot_keywords)
keywords$`movie$plot_keywords` <- as.character(keywords$`movie$plot_keywords`)
keywords_split <- strsplit(keywords$`movie$plot_keywords`, split ="[|]")
allkeywords <- character(length = 51000L)
for (i in 1:5043) {
  if (length(keywords_split[[i]]) < 1) {
    next
  }
  for (j in 1:length(keywords_split[[i]])) {
    k = paste(i, j)
    k <- str_replace(k, " ", "")
    k <- as.integer(k)
    allkeywords[k] <- keywords_split[[i]][j]
  }
}
library(tm)
library(SnowballC)
library(wordcloud)
allkeywords_table <- as.data.frame(allkeywords, stringsAsFactors = FALSE)
allkeywords_table <- allkeywords_table[!(allkeywords_table$allkeywords %in% c("")),]
allkeywords_table <- as.data.frame(allkeywords_table, stringsAsFactors = FALSE)
allkeywords_count <- as.data.frame(table(allkeywords_table$allkeywords_table))
## the most frequent 5 keywords are: love, friend, murder, death, police
dummykeywords <- matrix(0, ncol = 5, nrow = 5043) 
dummykeywords <- data.frame(dummykeywords)
colnames(dummykeywords) <- c("keyword_love", "keyword_friend", "keyword_murder", "keyword_death", "keyword_police")
top5 <- c("love", "friend", "murder", "death", "police")
for (i in 1:5043) {
  if (length(keywords_split[[i]]) < 1) {
    next
  }
  for (j in 1:length(keywords_split[[i]])) {
    for (k in 1:5) {
      if (keywords_split[[i]][j] %in% top5[k]) {
        dummykeywords[i,k] <- 1
      }
    }
  }
}
# combine original movie with dummykeywords
movie <- cbind(movie, dummykeywords)
# remove the plot_keywords
movie <- subset(movie, select = -plot_keywords)

## var 18: movie_imdb_link
# we don't need this variable
movie <- subset(movie, select = -movie_imdb_link)

## var 19: num_user_for_reviews
summary(movie$num_user_for_reviews)
movie$num_user_for_reviews[is.na(movie$num_user_for_reviews)] <- 273

## var 20: language
table(movie$language)
movie$language[movie$language %in% c("")] <- "Unknown"

## var 21: country
table(movie$country)
movie$country[movie$country %in% c("")] <- "Unknown"

## var 22: content_rating
table(movie$content_rating)
movie$content_rating[movie$content_rating %in% c("")] <- "Unknown"

## var 23: budget
# we also need to consider the inflation
summary(movie$budget)
# get a data frame without NA's in budget
temp <- cbind.data.frame(movie$title_year, movie$budget)

temp <- temp[!is.na(temp$`movie$budget`),]
temp_mean <- aggregate(`movie$budget` ~ `movie$title_year`, data = temp, mean)
## not all year are shown in the temp_mean
all_year <- unique(movie$title_year)
all_year <- as.data.frame(all_year)
# left_join
library(dplyr)
colnames(all_year) <- c("year")
colnames(temp_mean) <- c("year", "mean_budget")
all_year_mean <- left_join(x = all_year, y = temp_mean)
#sort
all_year_mean <- all_year_mean[order(all_year_mean$year),]
rownames(all_year_mean) <- c(1:92)
# fill the empty
for (i in 1:length(movie$budget)) {
  if (is.na(movie$budget[i])) {
    movie$budget[i] <- all_year_mean$mean_budget[all_year_mean$year %in% c(movie$title_year[i])]
  }
}
summary(movie$budget)

## var 24: title_year
# we have already deal with this var

## var 25: actor_2_facebook_likes
summary(movie$actor_2_facebook_likes)
movie$actor_2_facebook_likes[is.na(movie$actor_2_facebook_likes)] <- 1652

## var 26: imdb_score
summary(movie$imdb_score)
# this is what we need to predict, we don't need to deal with, no missing 

## var 27: aspect_ratio
summary(movie$aspect_ratio)
movie$aspect_ratio[is.na(movie$aspect_ratio)] <- "Unknown"

## var 28: movie_facebook_likes
summary(movie$movie_facebook_likes)
# no NAs

## output
write.csv(movie, "movie_clean.csv", col.names = TRUE, row.names = FALSE)
