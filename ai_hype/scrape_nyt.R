# reference:  http://ccgilroy.com/nyt-api-httr-demo/nyt_api_httr_demo.html
library(tidyverse)
library(httr)
library(devtools)
library(readr)
library(ggplot2)
library(stringr)
library(jsonlite)
library(fstrings)
library(glue)
devtools::install_github("jimhester/fstrings", force=TRUE)
file.edit("~/.Renviron")
Sys.getenv("nyt_key")



nyt_articlesearch_url <- 
  "https://api.nytimes.com/svc/search/v2/articlesearch.json"


query_list <- 
  list(
    `api-key` = Sys.getenv("nyt_key"), 
    begin_date = "20220601",
    end_date="20230610",
    fq="Artificial Intelligence OR AI OR A.I."
    )

  
r <- GET(nyt_articlesearch_url, query = query_list)

status_code(r)
content(r)$response$meta
docs <- content(r)$response$docs

articles <- content(r, type='application/json')$response$docs

hits <- content(r)$response$meta$hits
hits
pages <- 0:(ceiling(hits/10) - 1)
x = pages
new_query_list <- c(query_list, page = x)
page_idx = 0
glue::glue("/Users/yunchaewon/sicss-berlin/ai_hype/nyt_{page_idx}")
path = glue::glue("/Users/yunchaewon/sicss-berlin/ai_hype/nyt_{page_idx}")
dir.create(path, showWarnings = TRUE, recursive = FALSE, mode = "0777")
requests <- 
  lapply(pages, function(x, query_list) {
    new_query_list <- c(query_list, page = x)
    ## wait to avoid being rate-limited
    Sys.sleep(12)
    r <- GET(nyt_articlesearch_url, query = new_query_list)
    sprintf('%s th call: %s', page_idx, status_code(r))
    dir.create(glue::glue("/Users/yunchaewon/sicss-berlin/ai_hype/nyt_{page_idx}"), showWarnings = TRUE, recursive = FALSE, mode = "0777")
    
    Map(function(r, x) {
      ## build file name
      file_name <- str_c("artificial_intelligence", str_pad(as.character(x), 2, pad = "0"), 
                         sep = "_") %>%
        str_c(".json") %>%
      file.path(glue::glue("/Users/yunchaewon/sicss-berlin/ai_hype/nyt_{page_idx}"), .)
      ## write to file as JSON
      if (status_code(r) == 200) {
        content(r) %>% toJSON() %>% prettify() %>% write_file(file_name)
      }
      page_idx = page_idx + 1
      
    }, r = requests, x = pages) %>% invisible()
  }, query_list = query_list)

x = pages
new_query_list <- c(query_list, page = x)
## wait to avoid being rate-limited
Sys.sleep(12)
r <- GET(nyt_articlesearch_url, query = new_query_list)

Map(function(r, x) {
  ## build file name
  file_name <- str_c("nyt_ai", str_pad(as.character(x), 2, pad = "0"), 
                     sep = "_") %>%
    str_c(".json") %>%
    file.path("/Users/yunchaewon/sicss-berlin/ai_hype/nyt{}", .)
  ## write to file as JSON
  if (status_code(r) == 200) {
    content(r) %>% toJSON() %>% prettify() %>% write_file(file_name)
  }
}, r = requests, x = pages) %>% invisible()


