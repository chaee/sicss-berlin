library(rvest)
urls <- scan("/Users/yunchaewon/sicss-berlin/ai_hype/nyt_urls.txt", character(), quote = "")


# Run loop over these URLs
# With lapply
articles <- data.frame()
count <- 1
backup_articles <- articles

for(url in urls[1:50]){
    
    Sys.sleep(12)
    
    # message(url)
    print(paste(count, url))
    
    website <- read_html(url)
    
    article <- tibble(
      title = website %>%
        html_node(".e1h9rw200") %>%
        html_text() %>%
        {if(length(.) == 0) NA else .},    
      # replace length-0 elements with NA
      
      authors = website %>%
        html_elements(".epjyd6m1, .e1jsehar0, .e1jsehar1") %>%
        html_text() %>%
        paste(collapse = ";") %>%
        {if(length(.) == 0) NA else .},
      
      timestamp = website %>%
        html_elements(".e16638kd3, .e16638kd0") %>%
        html_text() %>%
        {if(length(.) == 0) NA else .},
      
      body = website %>%
        html_elements(".evys1bk0") %>%
        html_text() %>%
        paste(collapse = "") %>%
        {if(length(.) == 0) NA else .},
      
      url = url
    )
    print(paste(article$title, article$authors, article$timestamp))
    
    # body potential path .StoryBodyCompanionColumn
    # date potential path .e16638kd3
    # authors potential .e1jsehar0 .epjyd6m1 .e1jsehar1
    articles <- rbind(articles, article)
    # articles <- data.table::rbindlist(articles, fill = TRUE) 
    
    saveRDS(articles, file = "/Users/yunchaewon/sicss-berlin/ai_hype/NYT_ai_articles_100.Rds")

    count <- count + 1
}


scraped <- readRDS(file="/Users/yunchaewon/sicss-berlin/ai_hype/NYT_ai_articles_100.Rds", refhook = NULL)

#uscraped_2 <- readRDS(file="/Users/yunchaewon/sicss-berlin/ai_hype/NYT_ai_articles_1_10.Rds", refhook = NULL)


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