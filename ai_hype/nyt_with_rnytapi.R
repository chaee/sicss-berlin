
## Install the current development version from GitHub

if(!require(devtools)) install.packages("devtools")

devtools::install_github("jaeyk/rnytapi", dependencies = TRUE)

library(rnytapi)
library(tidyverse)
library(httr)
file.edit("~/.Renviron")

total_urls_2 = list()
total_res = list()
api_lim = 250
offset = 0
page_num=1
Sys.getenv("nyt_key")
page_return <- get_content(term = "ai",
                           begin_date = "20220601",
                           end_date = "20230610",
                           page=page_num,
                           key = Sys.getenv("nyt_key"))

page_return$response.docs.web_url

repeat{
  page_return <- get_content(term = "ai",
                        begin_date = "20220601",
                        end_date = "20230610",
                        page=page_num,
                        key = Sys.getenv("nyt_key")
                        )
  
  urls <- page_return$response.docs.web_url
  # print(offset)
  # print(length(members))
  if (length(urls) == 0){
    break
  }
  total_urls_2 <- c(total_urls_2, urls)  
  total_res <- c(total_res, page_return)
  #offset = offset + api_lim
  page_num = page_num + 1
  # print(offset)
  Sys.sleep(7)
}