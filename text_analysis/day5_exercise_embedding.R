library(word2vec)
library(tidyverse)
library(stringr)
library(lubridate)
pacman::p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda"
)

# Load data
textdata <- readRDS("sicss-berlin/text_analysis/data/CNN_complete.Rds")

# Exploratory steps

corpus <- corpus(textdata, text_field = "body")
tokens <- tokens(corpus) # easy tokens without pre-processing
types <- types(tokens) # types
head(types)[1:10]

  dfm <- dfm(tokens) # DFM, without pre-processing
  head(dfm)
  dim(dfm)
  
  tokens_pp <- tokens(
    corpus,
    remove_punct = TRUE,
    remove_symbols = TRUE,
    remove_numbers = TRUE,
    remove_separators = TRUE
  ) |>
    tokens_tolower() |>
    tokens_remove(c(stopwords("en"), "--"), padding = FALSE) |> # show padding if padding = TRUE, add more words to remove by using c(stopwords("en"), "black")
    tokens_wordstem(language = "en")
  

# Preprocess
typeof(stopwords("en"))
textdata_pp <- textdata %>%
  mutate(body = str_squish(body)) %>%
  mutate(body = str_to_lower(body, locale = "en")) 

# Word2vec

model <- word2vec(textdata_pp$body, type = "cbow", window = 5, dim = 50, stopwords=stopwords("en"))

embeddings <- as.matrix(model)
head(embeddings)
