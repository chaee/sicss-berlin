myvar <- c("hey", 'hi')
myvar[1]
load("path")
setwd("path")

# list = vector with diff data types
covid_tweets$tweet_text[3]
install.packages("tidyverse")

.libPaths("path_of_package")

library(tidyverse)

# ctrl + Enter -> run
# crl = char

# filter rows
brazil_data <- filter(apple_data, region=="Brazil")
# dataframe / tible
# = means calculation in r; == means exact matching

# filter columns
regions <- select(apple_data, region)
alpha_order <- arrange(apple_data, region)

long_apple_data <- gather(apple_data. key=day, value=mobility_data, `2020-01-13`:`2020-08-31`)

# load, import data
library(tidyverse)
read_csv("path_of_dataset")

# pipes: takes an onbject and pass it to the next line  
country_averages<- long_data %>%
                    filter(transportation_type=="walking") %>%
                    group_by(country) %>%
                    summarise(walking_average=mean(mobility_data, no.rm=TRUE)) %>%
                    filter(!is.na(country))
# no.rm=TRUE : ignore N/A

# the first pipe is identical to:
country_averages <- filter(long_data, transportation_type=="walking")

# visualization

# Bar plots
ggplot(country_averages, aes(y=reorder(country, walking_average), weigh=walking_average)) + 
    geom_bar(fill="blue") +
    xlab("Relative Rate of Walking Direction Requests")+
    ylab("Country")+
    theme_minimal() # different theme in ggplot
# ggplot works in terms of layers: build up layers using +
# aes = aesthetics : part of plots; what will be on x, y axes
# without y=country, by default x=country

# Line graphs, timeframe...
# using date stype object ( not only numeric or string objects)
# packate lubridate: transform character variable to date stype object

library(lubridate)
long_data$day<-as_date(long_data$day)

italy_spain_data <- long_data %>%
    filter(country ==c("Italy", "Spain"), transportation_type="walking") %>%
        group_by(country, day) %>%
            summarise(walking_average=mean(mobility_data, na.rm=TRUE))

ggplot(italy_spain_data, aes(x=day, y=walking_average, grou=country, colour=country)) + 
    geom_line()+
        facet_wrap(~country)+
            them_bw()+
                ylab("Relative Volumne of Walking Distance")

# facet : breaking a plot into multiple plots
# r convention ~: left explained by right

# Using twitter data
# making functions
install.packages('rtweet')

library(rtweet)
senators_dat$twitter_url[1]
test<-get_timeline("url")
twitter_url_remover <- function(x){
    handle<-gsub("https://twitter.com/", "", x)
    return(handle)
}

# help document
?get_timeline()

twtter_url_remover("https://twitter.com/SenDanSullivan")

for(i in 1:5){
    handle<-twitter_url_remover(senators_data$twitter_url[i])
    tweets<-get_timeline(handle)
    tweet_holder<-rbind(tweet_holder, tweets)
    print(i)
}

# rbind: row bind - bind two datasets together by rows

# data merging

senators_data$screen_name<- gsub("https://twitter.com/", "", senators_data$twitter_url)

tweet_holder$screen_name
merged_data <- left_join(tweet_holder, senators_data)

# left_join: take everything on the left object and merge it with the right object ; two dataframe has a varaible with the same name

# modeling
ggplot(opiod_data, aes(y=num_pills, x=republican_vote))+
    geom_point()+
        theme_minimal()+
            ggplot(opiod_data, aes(y=num_pills, x=republican_vote))+
                geom_point()+
                    geom_smooth(method="lm", formula=y~x)
                        theme_minimal())

# R convention - y: outcome variable, x: projector variable
# Multivariate Regression

summary(lm(num_pills~republican vote+
            population,
            data=opioid_data))

