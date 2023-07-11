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
# pages <- 0:(ceiling(hits/10) - 1)
max <- ceiling(hits/10)

file <- file("nyt_siimple_urls.txt")
urls <- character()
for(page_idx in seq(0, max)){
  
  new_query_list <- c(query_list, page = page_idx)
  Sys.sleep(12)
  r<- GET(nyt_articlesearch_url, query = new_query_list)
  
  print(status_code(r))
  print(page_idx)
  
  res <- content(r)
  for (list_pos in 1:10) {
    res_url <- res$response$docs[[list_pos]]$web_url
    print(res_url)
    urls <- c(urls, unlist(res_url))
  }  
  writeLines(urls, file)
}

close(file)

