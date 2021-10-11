
library(shiny)
library(DT)

options(shiny.maxRequestSize=100*1024^2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  # Bouton de recherche du fichier à charger
  fileInput(inputId = "file1", label = "Choose CSV File",
            accept = c("text/plain", ".csv")
  ),
  # Affichage des données
  tableOutput(outputId = "stats"),
  plotOutput(outputId = "FreqMonth"),
  DTOutput("contents"),
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  #====================================
  #Flight Phase Study
  plotOutput(outputId = "flightPhase"),
  
  
  #====================================
  # Top 10 Species causing accidents
  DTOutput("topSpecies"),
  
  
  #====================================
  # BIVAR
  
  #Cor Matrix
  plotOutput("corM"),
  
  #Species and Height
  plotOutput(outputId = "speciesHeightStats"),
  
))
