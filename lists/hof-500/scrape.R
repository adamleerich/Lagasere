
library(tidyverse)
library(rvest)
library(xml2)


url <- 'https://www.infoplease.com/culture-entertainment/music/500-songs-shaped-rock'

html_blob <- read_file(url)


write_file(html_blob, file = 'lists/hof-500/p1.html')


m <- regexpr('<!--BodyText-->', html_blob)
n <- regexpr('<!--/BodyText-->', html_blob)
  
body_text <- substr(html_blob, m + 15, n - 1)


lis <- body_text %>% 
  xml2::read_html(.) %>% 
  html_elements('li')


song <- lis %>% 
  html_elements('b') %>% 
  html_text()

song <- gsub('^\\?(.*)\\?$', '\\1', song)
song <- gsub('\\?', '"', song)
song <- gsub('&amp;', '&', song)


lis_text <- as.character(lis)

p <- regexpr('[,]*\\s*<b>', lis_text)
artist <- substring(lis_text, 1, p - 1)

all(grepl('^<li>', artist))

artist <- gsub('^<li>\\s*(.*)$', '\\1', artist)
artist <- gsub('\\?', '"', artist)
artist <- gsub('&amp;', '&', artist)

table(artist) %>% 
  sort(decreasing = TRUE) %>% 
  `[`(1:10)

df <- data.frame(
  artist,
  song
)

write_csv(df, 'lists/hof-500/hof-500.csv')



