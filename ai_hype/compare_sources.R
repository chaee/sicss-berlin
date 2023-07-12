library(tidyverse)
library(ggplot2)
# remotes::install_github("quanteda/quanteda.sentiment")

pacman::p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda"
)
stopwords("en")
dict_pol <- data_dictionary_HuLiu

preprocess_articles <- function(corpus){
  tokens_pp <- tokens(
    corpus,
    remove_punct = TRUE,
    remove_symbols = TRUE,
    remove_numbers = TRUE,
    remove_separators = TRUE
  ) |>
    tokens_tolower() |>
    tokens_compound(pattern = phrase("not *")) |>
    tokens_remove(stopwords("en"), padding = TRUE) |> # show padding
    tokens_wordstem(language = "en") |>
    tokens_compound(pattern = phrase("artifici intellig")) |>
    tokens_compound(pattern = phrase("fox news")) |>
    tokens_compound(pattern = phrase("social media")) |>
    tokens_compound(pattern = phrase("machin learn"))
  
  return(tokens_pp)
}

article_to_dfm <- function(article){
  corpus <- corpus(article, text_field = "text")
  tokens <- preprocess_articles(corpus)
  dfm <- dfm(tokens)
  dfm <- dfm_trim(dfm, min_termfreq = 2, termfreq_type = "count")
  
  return(dfm)
}

add_sent_scores <- function(articles, dfm){
  polarity <- textstat_polarity(dfm, dict_pol)
  valence <- textstat_valence(dfm, data_dictionary_AFINN)
  
  articles <- cbind(articles, "polarity"=polarity)
  articles <- cbind(articles, "valence"=valence)
  return(articles)
}

plot_sentiment <- function(df, y_axis){
  df_sent <- ggplot(df) +
    geom_line(aes(x = date, y = y_axis), color = "steelblue") +
    geom_smooth(aes(x = date, y = y_axis), method = "loess", se = FALSE, color = "red") +
    labs(x = "Date", y = "Sentiment") +
    theme_minimal() +
    geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red") +
    annotate("text", x = as.Date("2022-11-30"), y = 1,
             label = "Introduction Chat GPT", vjust = -0.5, hjust = 0, angle = 90)
  return(df_sent)
}

# Load NYT dfm
nyt_articles <- readRDS(file="data/clean_NYT_704.Rds", refhook = NULL) |>
  mutate(newspaper = "nyt",
         text = body)
nyt_dfm <- article_to_dfm(nyt_articles)

# Load FOX news news dfm

fox_articles <- read.csv("data/ai_fox_clean.csv") |>
  mutate(newspaper = "fox",
         date = as.Date(date))
fox_dfm <- article_to_dfm(fox_articles)

# Load guardian
guardian_articles <- read.csv("data/ai_guardian_clean.csv") |>
  mutate(newspaper = "guardian",
         date = as.Date(timestamp),
         text = body) #,
guardian_dfm <- article_to_dfm(guardian_articles)


# Combine NYT and FOX news
combined <- bind_rows(nyt_articles, fox_articles, guardian_articles)
combined_dfm <- article_to_dfm(combined)

# Compare keyness NYT vs. FOX news
textstat_keyness(dfm, target = 1:704) |> # docvars(dfm, "article_length") < 4000
  textplot_keyness()

# ---- sentiment analysis ----
nyt_articles <- add_sent_scores(nyt_articles, nyt_dfm)
guardian_articles <- add_sent_scores(guardian_articles, guardian_dfm)
fox_articles <- add_sent_scores(fox_articles, fox_dfm)
combined <- add_sent_scores(combined, combined_dfm)
combined %>% select(-body)

# ----- plot sentiment -----

combined_pol <- plot_sentiment(guardian_articles, guardian_articles$polarity.sentiment)
guardian_pol <- plot_sentiment(guardian_articles, guardian_articles$valence.sentiment)

print(combined_pol)
print(guardian_pol)
