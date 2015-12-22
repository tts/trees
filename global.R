############################################################################################
#
# 12.1.2014 Tuija Sonkkila
#
# Shiny web application for plotting rainforest tree species on a map
# with googleVis and rgbif::gbifmap
#
# Data by Rainforest Foundation Norway and Global Biodiversity Information Facility
# 
# http://www.regnskog.no/no/bevisst-forbruker/tropisk-t%C3%B8mmer/oversikt-tropiske-treslag
# http://www.gbif.org/
#
# Rainforest Foundation Norway data scraped by Scraper
#
# GBIF API query with the rgbif wrapper by rOpenSci
#
###########################################################################################

library(shiny)
library(ggplot2)
library(RColorBrewer)
library(rgbif)
library(googleVis)
library(RCurl)


# Scraped with Scraper from http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
# Old: https://docs.google.com/spreadsheet/pub?key=0AvfW9KgU1XzhdGRRMG9Ta0ZRM2Rnb3p4QjJBVkdyMkE&output=csv",
countrydata <- getURL("https://docs.google.com/spreadsheets/d/1GS1MrfozPCvQ1VLBZMBt_wlHtD1M7_paA1stDrr_rd4/pub?output=csv",
                      .encoding="UTF-8",
                      ssl.verifypeer = FALSE)
cdata <- read.csv(text = countrydata)

# Columns to continue with
cols <- c("name","longitude", "latitude", "country")

if(file.exists("Extinct.Rda")){
  load("Extinct.Rda")
  Extinct <- Extinct[ ,cols]
  Extinct <- merge(Extinct, cdata, by.x="country", by.y="Acronym")
}
if(file.exists("Critically_Endangered.Rda")){
  load("Critically_Endangered.Rda")
  Critically_Endangered <- Critically_Endangered[ ,cols]
  Critically_Endangered <- merge(Critically_Endangered, cdata, by.x="country", by.y="Acronym")
}
if(file.exists("Endangered.Rda")){
  load("Endangered.Rda")
  Endangered <- Endangered[ ,cols]
  Endangered <- merge(Endangered, cdata, by.x="country", by.y="Acronym")
}
if(file.exists("Vulnerable.Rda")){
  load("Vulnerable.Rda")
  Vulnerable <- Vulnerable[ ,cols]
  Vulnerable <- merge(Vulnerable, cdata, by.x="country", by.y="Acronym")
}
if(file.exists("Near_Threatened.Rda")){
  load("Near_Threatened.Rda")
  Near_Threatened <- Near_Threatened[ ,cols]
  Near_Threatened <- merge(Near_Threatened, cdata, by.x="country", by.y="Acronym")
}
if(file.exists("Other.Rda")){
  load("Other.Rda")
  Other <- Other[ ,cols]
  Other <- merge(Other, cdata, by.x="country", by.y="Acronym")
}


statuses <- character()
for(i in c("Extinct", "Critically_Endangered", "Endangered", "Vulnerable", "Near_Threatened", "Other")) {
  if(exists(i)) {
    statuses <- c(statuses, i)
  }
}
