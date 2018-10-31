library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {
  dataurl="http://www.statsci.org/data/oz/ctsibuni.txt"
  getData <- reactive({
    ctsib=read.table("http://www.statsci.org/data/oz/ctsibuni.txt",sep="\t",header=TRUE)
    if(input$Sex =="all"){
      newData <- ctsib %>% filter(Surface == input$Surface & Vision==input$Vision)
    }else{
      newData <- ctsib %>% filter(Surface == input$Surface & Vision==input$Vision & Sex == input$Sex)
    }
  })
  
  plotInput <- reactive({
    newData <- getData()
    
    #create plot
    g <- ggplot(newData, aes(x = CTSIB, y = Weight))
    if(input$conservation){
      g + geom_point(size = input$size, aes(col = Sex))
    } else {
      g + geom_point(size = input$size)
    }
  })
  
  #create plot
  output$ctsibPlot <- renderPlot({
    print(plotInput())
  })
  
  
  #create output of observations    
  output$table <- renderTable({
    getData()
    })
    
    output$downloadData <- downloadHandler(
      filename = function() {
        paste("CTSIB_",input$Vision, "_", input$Surface, ".csv", sep = "")
      },
      content = function(file) {
        write.csv(getData(), file, row.names = FALSE)
      }
    )
    
    output$downloadPlot <- downloadHandler(
      filename = function() { paste("CTSIB_",input$Vision, "_", input$Surface, '.png', sep='') },
      content = function(file) {
        ggsave(file,plotInput())
      }
    )
  
})
