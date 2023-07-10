library(purrr)
library(tidyverse)
library(jsonlite)

path <- "/Users/yunchaewon/sicss-berlin/ai_hype/nyt/nyt_0"
files <- dir(path, pattern = "*.json")

data <- files %>%
  map_df(~fromJSON(file.path(path, .), flatten = TRUE))
