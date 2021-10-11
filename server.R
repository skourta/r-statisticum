#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer <- function(input, output){
  
  
  # Initialement, class(input$file1) = NULL
  # Après chargement, class(input$file1) = data.frame
  # avec les colonnes 'size', 'type', and 'datapath' columns. 
  data <- reactive({
    inFile <- input$file1
    if (is.null(inFile)) return(NULL)
    read.csv(inFile$datapath, header = TRUE)
  })
  
  tabStats <- reactive({
    table.tmp <- as.data.frame(table(data()$Incident.Month))
    colnames(table.tmp) <- c("Mois", "Frequence")
    table.tmp
  })
  
  output$stats <- renderTable({ tabStats() })
  output$FreqMonth <- renderPlot({
    barplot(tabStats()$Frequence,names.arg=tabStats()$Mois,xlab="Mois", ylab="Frequence")
  })
  output$contents <- renderDT(
    data(), options = list(lengthChange = FALSE))
  
  
  
  
  
  
  
  
  
  
  
  #====================================
  # Flight Phase Study
  flightPhase <- reactive({
    table.tmp <- as.data.frame(table(data()$Flight.Phase))[-1,]
    colnames(table.tmp) <- c("FlightPhase", "Frequence")
    table.tmp
  })
  output$flightPhase <- renderPlot({
    barplot(flightPhase()$Frequence,names.arg=flightPhase()$FlightPhase,xlab="FlightPhase", ylab="Frequence")
  })
  
  #====================================
  # Top 10 Species causing accidents
  topSpecies <- reactive({
    tmp <- as.data.frame(table(data()$Species.Name))[-1,]
    colnames(tmp) <- c("Nom", "Frequence")
    print(tmp)
    tmp[order(tmp$Frequence, decreasing = TRUE),][c(1,2,3,4,5,6,7,8,9,10),]
  })
  output$topSpecies <- renderDT(
    topSpecies(), options = list(lengthChange = FALSE))
}