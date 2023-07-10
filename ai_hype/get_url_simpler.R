library(tidyverse)
library(httr)

nyt_articlesearch_url <- 
  "https://api.nytimes.com/svc/search/v2/articlesearch.json"

query_list <- 
  list(
    `api-key` = Sys.getenv("nyt_key"), 
    begin_date = "20220601",
    end_date="20230610",
    fq="Artificial Intelligence"
  )

r <- GET(nyt_articlesearch_url, query = query_list)
hits <- content(r)$response$meta$hits
hits
pages <- 0:(ceiling(hits/10) - 1)


file <- file("simple_urls.txt")
urls <- list()
res <- content(r)
res_url <- lapply(1:10, function(i){
  res_url <- res$response$docs[[i]]$web_url
  return(res_url)
  }
)
