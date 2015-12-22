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

shinyUI(pageWithSidebar(
  
  headerPanel("Red-listed rainforest tree species"),
  
  
  sidebarPanel(
    
    selectInput(inputId = "c", 
                label = "Choose status:",
                choices = statuses,
                selected = c("Endangered"))  
  ),
  
  
  mainPanel(
    tabsetPanel(
      tabPanel("Map", htmlOutput("gvis"),
               br(), br(),
               a(href = "http://www.regnskog.no/no/bevisst-forbruker/tropisk-t%C3%B8mmer/oversikt-tropiske-treslag", target = "_blank", "Species by Rainforest Foundation Norway"),
               br(),
               a(href = "http://www.gbif.org/", target = "_blank", "Location data by Global Biodiversity Information Facility (GBIF)"),
               br(), br(),
               a(href = "http://tuijasonkkila.fi/blog/2014/01/mapping-red-listed-rainforest-tree-species/", target = "_blank", "See blog post")),
      tabPanel("Static map", plotOutput("gbifmap", height = "700px", width = "auto")),
      tabPanel("Data", tableOutput("data"))
    )
  )
))