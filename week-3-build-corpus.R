library(dplyr)
library(ggplot2)
library(tm)
library(RWeka)
library(NLP)
library(stringi)
library(stringr)
library(kableExtra)
library(tidytext)


setwd("C:/Users/mshi1/OneDrive - KPMG/Documents/Coursera - Data Capstone")

set.seed(12345)

data_source = "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"

if (!file.exists("Coursera-SwiftKey.zip")){
  download.file(url = data_source, destfile = "Coursera-SwiftKey.zip")
  unzip("Coursera-SwiftKey.zip")
}


blogs_filename <- "./final/en_US/en_US.blogs.txt"
blogs <- readLines(blogs_filename, encoding = "UTF-8", skipNul = TRUE, warn = FALSE)

news_filename <- "./final/en_US/en_US.news.txt"
news <- readLines(news_filename, encoding = "UTF-8", skipNul = TRUE, warn = FALSE)

twitter_filename <- "./final/en_US/en_US.twitter.txt"
twitter <- readLines(twitter_filename, encoding = "UTF-8", skipNul = TRUE, warn = FALSE)

sample_perc <- 0.01

#Combine samples
sample_blog <- sample(blogs, ceiling(length(blogs) * sample_perc), replace = FALSE)
sample_news <- sample(news, ceiling(length(news) * sample_perc), replace = FALSE)
sample_twitter <- sample(twitter, ceiling(length(twitter) * sample_perc), replace = FALSE)

sample_combined <- c(sample_blog, sample_news, sample_twitter)

rm(blogs)
rm(news)
rm(twitter)
rm(sample_blog)
rm(sample_news)
rm(sample_twitter)

#Remove non-english characters
sample_combined <- iconv(sample_combined, "latin1", "ASCII", sub = "")

sample_combined <-VCorpus(VectorSource(sample_combined))

#Remove white spaces
to_space <- content_transformer(function(x, pattern) gsub(pattern, " ", x))

sample_combined <- tm_map(sample_combined, stripWhitespace)

#Remove URLs and email addresses
sample_combined <- tm_map(sample_combined, to_space, "^https?://.*[\r\n]*")

sample_combined <- tm_map(sample_combined, to_space, "\\b[A-Z a-z 0-9._ - ]*[@](.*?)[.]{1,3} \\b")

# Convert all words to lowercase
sample_combined <- tm_map(sample_combined, content_transformer(tolower))

#Remove common english stop words
#sample_combined <- tm_map(sample_combined, removeWords, stopwords("english")) 

#Remove punctuation marks
sample_combined <- tm_map(sample_combined, removePunctuation)

#Remove numbers
sample_combined <- tm_map(sample_combined, removeNumbers)


