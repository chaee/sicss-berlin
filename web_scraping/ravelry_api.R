library(tidyverse)
library(httr)
# file.edit("~/.Renviron")
Sys.getenv("ravelry_personal")

if (FALSE) {
  GET("http://httpbin.org/basic-auth/user/passwd")
  GET(
    "http://httpbin.org/basic-auth/user/passwd",
    authenticate("user" = Sys.getenv("ravelry_personal_id"), 
                 "password" = Sys.getenv("ravelry_personal_key")
                 )
  )
}

my_favorites <- GET(
  "https://api.ravelry.com/people/fox-the-knitter/favorites/list.json",
)
favorites <- content(my_favorites, type='application/json')$favorites

