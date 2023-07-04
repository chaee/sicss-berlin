# install.packages("RSelenium")
# install.packages("wdman")
# install.packages("netstat")

library(RSelenium)
library(wdman)
library(netstat)

selenium()

selenium_object <- selenium(retcommand = T, check = F)

# delete ...license file in each version folder in the path of selenium_object
# '/Users/yunchaewon/Library/Application Support/binman_chromedriver/mac64/114.0.5735.90/chromedriver'

binman::list_versions("chromedriver")
remote_driver <- rsDriver(browser = "chrome",
                        chromever = "114.0.5735.90",
                         verbose = F,
                         port = free_port(random=TRUE)) 

#  using netstat; instead of port number put random=TRUE

remDr <- remote_driver$client
remDr$navigate("https://edition.cnn.com/")

remDr$navigate("https://google.com/")


