library(tidyverse)
library(xml2)
library(rvest)


url <- 'https://en.wikipedia.org/wiki/The_Pitchfork_500'

html_blob <- read_file(url)
nchar(html_blob)

html <- read_html(html_blob)

write_file(html_blob, file = 'lists/pitchfork-500/p1.html')

text <- html %>% 
  html_elements('div.div-col') %>% 
  html_elements('li') %>% 
  html_text

# table(nchar(text) - nchar(gsub('\\"', '', text)))
text[which(nchar(text) - nchar(gsub('[ ]\226[ ]', '', text)) != 3)]

text[text == "Minutemen \226 \"History Lesson – Part II\""] <- 
  "Minutemen \226 \"History Lesson - Part II\""

artist <- gsub('(.*)[ ]\226[ ]\\"(.*)\\"', '\\1', text)
song <- gsub('(.*)[ ]\226[ ]\\"(.*)\\"', '\\2', text)

df <- data.frame(artist, song)

write_csv(df, 'lists/pitchfork-500/pitchfork-500.csv')
