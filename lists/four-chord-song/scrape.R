
library(tidyverse)
library(rvest)
library(xml2)


url <- 'https://en.wikipedia.org/wiki/The_Axis_of_Awesome'

html_blob <- read_file(url)
nchar(html_blob)

html <- read_html(html_blob)

write_file(html_blob, file = 'lists/four-chord-song/p1.html')

content <- html %>% 
  html_element('body') %>% 
  html_element('div#content') %>% 
  html_element('div#bodyContent') %>% 
  html_element('div#mw-content-text') %>% 
  html_element('div.mw-parser-output') %>% 
  html_children()


text <- content[c(29, 31)] %>% 
  html_elements('li') %>% 
  html_text()


# Make sure there are only two quotes in each value
(nchar(text) - nchar(gsub('\\"', '', text))) %>% 
  table


pattern <- '^(.*)[ ]\226[ ]\\"(.*)\\".*$'

artist <- gsub(pattern, '\\1', text)
song <- gsub(pattern, '\\2', text)

df <- data.frame(artist, song)

write_csv(df, 'lists/four-chord-song/four-chord-song.csv')
