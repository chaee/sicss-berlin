# SICSS Berlin - Day 3 - July 4, 2023
# List to Data Frame - Exercise

library(tidyverse)
library(Matrix)
library(data.table)
congress_members <- readRDS("sicss-berlin/data_cleaning/congress_members.Rds")

# data into data frame format


# Creating the large list
congress_members[-c("depection")]
df <- rbindlist(congress_members)

members_df <- congress_members %>%
    data.table::rbindlist(fill = TRUE) %>% # unequal length -> N/A
  select(-depiction) %>%
  distinct() %>% # keep only distinct rows
  unnest_longer(terms) %>%
  unnest_wider(terms)
  


# Mapping -> converting the list to 
# dataframe
list_data <- Map(as.data.frame, list_data)

# Converting the large list to dataframe
# using the rbindlist function
datarbind <- rbindlist(list_data)

# Print the dataframe
datarbind

# exclude nested list

# exclude redundant rows