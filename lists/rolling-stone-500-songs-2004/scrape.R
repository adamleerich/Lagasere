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

paras <- list()
for (i in 1:5) {
  paras[[i]] <- xmls[[i]] %>% 
    html_element('body') %>% 
    html_element('div#container') %>% 
    html_element('div#content') %>% 
    html_element('div.text')
}

