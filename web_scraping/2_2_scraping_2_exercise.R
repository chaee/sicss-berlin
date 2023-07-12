# SICSS Berlin - Day 2 - July 4, 2023
# Web scraping - Exercise

library(tidyverse)
install.packages("rvest")
library(rvest)

# 0. Get selctor gadget: https://selectorgadget.com/
# 1. Scrape the title, author, date and body of one of the articles provided in the
#     URL file!
# 2. Build a loop to scrape all articles in the provided URL document!

# NOTE: The result should be a dataframe with five columns (title, author, date, body, url). 
# NOTE: Tomorrow we will learn how to clean the text data.
# NOTE: Don't forget to include a time delay between each request to the server! 

html <- read_html("https://edition.cnn.com/2023/05/10/us/florida-social-studies-textbooks-education-department/index.html")
html %>% 
  html_elements("h1")
# Task 1 ------------------------------------------------------------------
# Test scraping one of the articles

# Find css selectors with SelectorGadget
Title <- html %>% 
  html_node("#maincontent")  %>% 
    html_text()
# Authors: 
Authors <- html %>% 
  html_node(".byline__names") %>% 
  html_text()
# Date: 

Date <- html %>% 
  html_node(".timestamp") %>% 
  html_text()
# Text: 
Text <- html %>% 
  html_node(".article__content") %>% 
  html_text()

# scrape one article



# Task 2 -----------------------------------------------------------------
# Build a loop to scrape all of the URLs provided in the textfile


urls <- scan("/Users/yunchaewon/sicss-berlin/web_scraping/data/processed/practice_CNN_URLs.md", character(), quote = "")
print(length(urls))
Title = list()
Authors = list()
Date = list()
Text = list()
for(i in 1:length(urls)){ 
  #you can loop through vectors for 1 in urls
  html <- read_html(urls[i])
  html %>% 
    html_elements("h1")
  # Task 1 ------------------------------------------------------------------
  # Test scraping one of the articles
  
  # Find css selectors with SelectorGadget
  Title[i] <- html %>% 
    html_node("#maincontent")  %>% 
    html_text()
  # Authors: 
  Authors[i] <- html %>% 
    html_node(".byline__names") %>% 
    html_text()
  # Date: 
  
  Date[i] <- html %>% 
    html_node(".timestamp") %>% 
    html_text()
  # Text: 
  Text[i] <- html %>% 
    html_node(".article__content") %>% 
    html_text()
  print(paste0("Current url index: ", i))
  print(Title[i])
}

scraped_cnn <-
  tibble(
    Titles = Title,
    Bylines = Authors,
    Dates = Date,
    Texts = Text
  )

print(as_tibble(scraped_cnn), n = 1)

