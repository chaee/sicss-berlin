# SICSS Berlin - Day 3 - July 5, 2023
# String Operations - Exercise

library(tidyverse)
library(stringr)

text <- "   I hope you will have a great time during the 9 days of SICSS-Berlin.  Orange  \nIf you have any suggestions for impovemend, feel free to tell us in person or via sicss.2023@wzb.eu.    Orange "

### Use stringr functions, to solve the following tasks.

# Is there a line break present? Show using a function
str_detect(text, '\\n')
# Remove the line break
print(text)
text <- str_replace(text, '\\n', '')
print(text)

# Remove the two "Orange"
print(text)
text <- str_replace_all(text, 'Orange', '')
print(text)

# Remove the unnecessary white spaces
# text <- str_trim(text, side=c("both"))
text <- str_squish(text)

print(text)

# How long is this string? Count characters and words.
print(str_length(text))
print(text)

# Extract the email address
see <- function(rx) str_view_all(text, rx)

addr <- str_match(text, "[:lower:]+.[:digit:]+@[:alnum:]+.[:alnum:]+")
print(addr)
# Change the text to all lower-case
str_to_lower(text, locale="en")
# Correct the misspelled word

text <- str_replace(text, 'impovemend', 'improvement')
print(text)
