
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
  html_element('div.mw-parser-output')


content %>% 
  as.list()



  `[`(5) %>% 
  html_children() %>% 
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
