library(tidyverse)
library(xml2)
library(rvest)

p1 <- read_file('https://web.archive.org/web/20080622112029/http://www.rollingstone.com/news/coverstory/500songs/page/1')
p2 <- read_file('https://web.archive.org/web/20080622112029/http://www.rollingstone.com/news/coverstory/500songs/page/2')
p3 <- read_file('https://web.archive.org/web/20080622112029/http://www.rollingstone.com/news/coverstory/500songs/page/3')
p4 <- read_file('https://web.archive.org/web/20080622112029/http://www.rollingstone.com/news/coverstory/500songs/page/4')
p5 <- read_file('https://web.archive.org/web/20080622112029/http://www.rollingstone.com/news/coverstory/500songs/page/5')

blobs <- list()
blobs[[1]] <- p1
blobs[[2]] <- p2
blobs[[3]] <- p3
blobs[[4]] <- p4
blobs[[5]] <- p5

xmls <- list()
for (i in 1:5) {
  xmls[[i]] <- xml2::read_html(blobs[[i]])
}

text <- character()
for (i in 1:5) {
  text <- c(text, (xmls[[i]] %>% 
    html_element('body') %>% 
    html_element('div#container') %>% 
    html_element('div#content') %>% 
    html_element('div.text') %>% 
    html_children() %>% 
    html_text()
  ))
}


text <- gsub('\\s+', ' ', text)

text[text == ' Like a Rolling Stone']          <- "1. Like a Rolling Stone, Bob Dylan"
text[text == " Voodoo Child (Slight Return)"]  <- "101. Voodoo Child (Slight Return), Jimi Hendrix"
text[text == " Bizarre Love Triangle"]         <- "201. Bizarre Love Triangle, New Order"
text[text == " Do Ya Think I'm Sexy?"]         <- "301. Do Ya Think I'm Sexy?, Rod Stewart"
text[text == " Tonight's the Night"]           <- "401. Tonight's the Night, The Shirelles"

L <- grepl('^[0-9]+[.]', text)
text[!L]
text <- text[L]

all(gsub('^([0-9]+)[.].*$', '\\1', text) == 1:500)





# How many commas?
commas <- nchar(text) - nchar(gsub(',', '', text))
table(commas)
text[commas > 1]



# Get artist first
artist <- gsub('^.*[,]\\s*([^,]+)$', '\\1', text)

artist[text == "329. That's the Way of the World, Earth, Wind and Fire"]  <- "Earth, Wind and Fire"
artist[text == "385. Ohio, Crosby, Stills, Nash and Young"]               <- "Crosby, Stills, Nash and Young"
artist[text == "418. Suite: Judy Blue Eyes, Crosby, Stills and Nash"]     <- "Crosby, Stills and Nash"

# ns = no song
text_ns <- substr(text, 1, nchar(text) - nchar(artist))

song <- gsub('^([0-9]+[.]\\s*)(.*)([,]\\s*)$', '\\2', text_ns)




df <- data.frame(artist, song)

write_csv(df, 'lists/rolling-stone-500-songs-2004/rolling-stone-500-songs-2004.csv')



