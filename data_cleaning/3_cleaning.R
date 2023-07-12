# SICSS Berlin - Day 3 - July 5, 2023
# Cleaning text data - Exercise Solution

library(tidyverse)
library(stringr)
library(lubridate)
library (plyr)


cnn_data <- readRDS("sicss-berlin/data_cleaning/CNN_complete.Rds")
typeof(cnn_data)


# If you laptop has trouble with these operations, reduce the number of articles with
#cnn_data <- sample_n(cnn_data, 400) # or any other amount


# 1. authors --------------------------------------------------------------
#   a. Separate authors into individual variables
authors <- cnn_data$authors
print(authors)
sep_names = list()
clean_authors = list()

for(i in authors){
  splits = str_split(i, ';')
  print(splits)
  sep_names <- append(sep_names, splits)
}

cnn_clean <- cnn_data %>%
  mutate(author = str_replace(authors, ";", simplify = FALSE)) %>%
  unnest_wider(author, names_sep=";")

cnn_clean <- cnn_data %>%
  mutate(author = str_split(authors, ";", simplify = FALSE)) %>%
  unnest_wider(author, names_sep=";")

print(cnn_clean)
#   b. Change author names to be last name first, i.e., "Last, First" (relatively difficult)
# First Last
# W. Kamau Bell
# Zachary B. Wolf
long_names = list()
names = list()
two_names = list()
short_names = list()

for(names in sep_names){
  for(name in names){
    if(str_count(name, ' ') < 1){
      short_names <- append(short_names, name)
    }
    else if (str_count(name, ' ') == 1){
      two_names <- append(two_names, name)
    }
    else if(str_count(name, ' ') > 1){
      long_names <- append(long_names, name)
    }
  }
}

df_long_names <- ldply (long_names, data.frame)
is.data.frame(df_long_names)
df_long_names <- distinct(df_long_names)

df_short_names <- ldply (short_names, data.frame)
df_short_names <- distinct(df_short_names)

clean_names = list()

# clean mess
# 1. replace 'with', '|' with ';'
# 2. ignore one word names

# identify first and last name
for(name in sep_names){
  # replace asdf II, asdf III into asdf_II or asdf_III
  
  if(str_detect(name, '.')){
    toks = str_split(name, ' ')
    last = toks[length(toks)]
    first = toks[1:length(toks)-1]
  }
  else{
    if (str_count(name, ' ') == 1){
      last = toks[2]
      first = toks[1]
    }
    
    else{
      
    }
  }
}

# CNN | Jacqui Palumbo
# Exclusive: By Ena Bilobrk
# Story: Scottie Andrew
# EXCLUSIVE: By Clarissa Ward

# Stephen Collinson with Caitlin Hu
# Illustration by Alberto Mier
# Shaun Leonardo | Introduction by Ananda Pellerin
# William J. Barber II
# Fernando Alfonso III


# 2. timestamp, create one variable... ----------------------------------
cnn_data <- readRDS("sicss-berlin/data_cleaning/CNN_complete.Rds")

# timestamps_df<- ldply (cnn_data$timestamp, data.frame)

#   a. ...that includes the information whether the article was updated or 
#         published on this date

cnn_clean <- cnn_data %>%
  mutate(clean_timestamps = str_squish(timestamps))
 
cnn_clean <- cnn_clean %>%
   mutate(status = str_split(clean_timestamps, " ", simplify = FALSE))

str_split(cnn_clean$clean_timestamps, " ", simplify = FALSE)[[2]]

#   b. ...that holds the weekday
#   c. ...that holds the date (in date format!)
#   d. ...discard the rest of the information



# 3. title and body -------------------------------------------------------
#   a. remove non-language characters (e.g., \n and excessive white spaces) and remove capitalization


# 4. body -----------------------------------------------------------------
#   a. how many characters and how many words does each article consist of?
#   b. how many characters and how many words does the overall corpus consist of?
#   c. count how often "Black Lives Matter" or "BLM" are mentioned in individual
#      articles and titles and think about the implications of the results
#   d. count the number of articles by month
#   e. count the numbers of articles that contain words related to 
#      'peaceful protest' and then words related to 'violent protest'


