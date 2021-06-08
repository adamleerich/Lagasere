library(tidyverse)
library(xml2)
library(rvest)

base_url <- 
  'https://www.loudersound.com/features/the-100-greatest-rock-songs-of-the-century-so-far/'


pages <- list()
for (i in 1:10) {
  url <- paste0(base_url, i)
  pages[[i]] <- read_file(url)
}

for (i in 1:10) {
  print(nchar(pages[[i]]))
  write_file(pages[[i]], file = paste0('lists/loudersound-2000s-100/p', i, '.html'))
}

xmls <- list()
for (i in 1:10) {
  xmls[[i]] <- xml2::read_html(pages[[i]])
}


xmls[[1]] %>% 
  html_element('div#article-body') %>% 
  html_elements('h2') %>% 
  html_text()


text <- character()
for (i in 1:10) {
  text <- c(text, (xmls[[i]] %>% 
    html_element('div#article-body') %>% 
    html_elements('h2') %>% 
    html_text()
  ))
}


text <- gsub('\\s+', ' ', text)

L <- grepl('^[0-9]+[.]', text)
text[!L]
text <- text[L]

all(gsub('^([0-9]+)[.].*$', '\\1', text) == 100:1)





# How many dashes?
dashes <- nchar(text) - nchar(gsub('-', '', text))
table(dashes)


pattern <- '^([0-9]+)[.]\\s*(.*?)\\s*-\\s*(.*?)\\s*$'


rank <- gsub(pattern, '\\1', text)
artist <- gsub(pattern, '\\2', text)
song <- gsub(pattern, '\\3', text)


df <- data.frame(artist, song)

write_csv(df[100:1, ], 'lists/loudersound-2000s-100/loudersound-2000s-100.csv')



