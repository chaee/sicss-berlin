library(tidyverse)
library(ggplot2)
# install.packages("SentimentAnalysis")
library(SentimentAnalysis)
pacman::p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda"
)

save_path = "/Users/yunchaewon/sicss-berlin/ai_hype/clean_NYT_704.Rds"
nyt_articles <- readRDS(file=save_path, refhook = NULL)

# Number of articles acros time
nyt_plot <- ggplot(nyt_articles, aes(x = date)) +
  geom_histogram(stat = "count", fill = "steelblue") +
  labs(x = "Date", y = "Number of Observations") +
  theme_minimal() +
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red") +
  annotate("text", x = as.Date("2022-11-30"), y = 4.5, 
           label = "Introduction Chat GPT", vjust = -0.5, hjust = 0, angle = 90)

print(nyt_plot)


st# preprocessing

corpus <- corpus(nyt_articles, text_field = "body")
summary(corpus)
summary <- summary(corpus) 
sum(summary$Types)
sum(summary$Tokens)
mean(summary$Tokens)

cnt_w <- countWords(corpus, removeStopwords = TRUE)
sum(cnt_w$WordCount)
mean(cnt_w$WordCount)

cnt_wo <- countWords(corpus, removeStopwords = FALSE)
sum(cnt_wo$WordCount)
mean(cnt_wo$WordCount)

stopwords("en")

tokens_nyt <- tokens(
  corpus,
  remove_punct = TRUE,
  remove_symbols = TRUE,
  remove_numbers = TRUE,
  remove_separators = TRUE
) |>
  tokens_tolower() |>
  tokens_compound(pattern = phrase("not *")) |>
  tokens_remove(stopwords("en"), padding = TRUE) |> # show padding
  tokens_wordstem(language = "en")

#   tokens_compound(pattern = phrase("artifici intellig")) |>
#   tokens_compound(pattern = phrase("machin learn")) |>
#   tokens_compound(pattern = phrase("social media")) |>
#   tokens_compound(pattern = phrase("generat ai")) |>
#   tokens_compound(pattern = phrase("unit state")) |>
#   tokens_compound(pattern = phrase("search engin")) |>
#   tokens_compound(pattern = phrase("languag model")) |>
#   tokens_compound(pattern = phrase("a.i system")) |>
#   tokens_compound(pattern = phrase("biden administr")) |>
#   tokens_compound(pattern = phrase("climat chang"))

tok_summary <- summary(tokens_nyt) 
sum(tok_summary)
sum(tok_summary$Length)

dfm_nyt <- dfm(tokens_nyt)
head(dfm_nyt)
dim(dfm_nyt)

dfm_trim(dfm_nyt, min_termfreq = 2, termfreq_type = "count") |>
  dim()

textstat_frequency(dfm_nyt, n = 15)

# TF-IDF
tfidf_nyt <- dfm_tfidf(dfm_nyt)
tfifdf_nyt
# # N-grams; multi-word expression with lambda
ngrams <- textstat_collocations(tokens_nyt, size=2)

head(ngrams, 50)
