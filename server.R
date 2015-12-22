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


shinyServer(function(input, output) {
  
  
  rdata <- reactive({
    
    if (is.null(input$c))
      return(NULL)
    if (exists(input$c))
      get(input$c)
  })
  
  output$gvis <- renderGvis({
    
    myData <- rdata()
    
    # gVis needs a lat:lon column
    myData$Loc <- paste(myData$latitude, myData$longitude, sep=":")
    # A number showing how many occurrences there are of this species on this location
    # Used in deciding the size of the markers
    # http://stackoverflow.com/questions/7450600/how-do-i-count-aggregate-values-from-a-data-frame-and-reincorporate-them-into-th
    myData$Count <- ave(myData$Loc, myData[ ,"Loc"], FUN=length)
    # Pasting country name to tooltip
    myData$Text <- paste(myData$name, " (", myData$Name, ")", sep = "")
    gvisGeoChart(myData,
                 locationvar="Loc", 
                 sizevar="Count",
                 hovervar="Text",
                 options=list(displayMode="Markers", 
                              colorAxis="{colors: ['#e7711c', '#4374e0']}",
                              markerOpacity=0.6,
                              height=600)
    )
    
    
  })
  
  
  output$gbifmap <- renderPlot({
    
    if (is.null(rdata()))
      return(NULL)
    
    library(RColorBrewer)
    
    # http://novyden.blogspot.fi/2013/09/how-to-expand-color-palette-with-ggplot.html
    colourCount = length(unique(rdata()$name))
    getPalette = colorRampPalette(brewer.pal(9, "Set1"))
    
    source("mygbifmap.R")
    
    p <- mygbifmap(rdata(), 
                   alpha = 0.8,
                   customize = list(scale_colour_manual(values = getPalette(colourCount)),
                                    guides(col = guide_legend(ncol=4)))) 
    
    print(p)
    
  })
  
  
  output$data <- renderTable({
    
    if (is.null(rdata()))
      return(NULL)
    rdata()
    
  }, include.rownames = FALSE)
  
})