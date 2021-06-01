
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


songs <- lis %>% 
  html_elements('b') %>% 
  html_text()

songs <- gsub('^\\?(.*)\\?$', '\\1', songs)
songs <- gsub('\\?', '"', songs)
songs <- gsub('&amp;', '&', songs)


lis_text <- as.character(lis)

p <- regexpr('[,]*\\s*<b>', lis_text)
artists <- substring(lis_text, 1, p - 1)

all(grepl('^<li>', artists))

artists <- gsub('^<li>\\s*(.*)$', '\\1', artists)
artists <- gsub('\\?', '"', artists)
artists <- gsub('&amp;', '&', artists)

table(artists) %>% 
  sort(decreasing = TRUE) %>% 
  `[`(1:10)

df <- data.frame(
  artists,
  songs
)

write_csv(df, 'lists/hof-500/hof-500.csv')



