function(input, output, session) { 
  set.seed(122)
  histdata <- rnorm(500)
  
  isCategorical <- function(varName){
    type<- reactive({
      class(data()[, varName])
    })()
    
    if(type == "character"){
      return(TRUE)
    }else{
      return(FALSE)
    }
  }
  
  data <- reactive({
    #inFile <- input$file1
    #if (is.null(inFile)) return(NULL)
    #read.csv(inFile$datapath, header = TRUE)
    tmp <- read.csv("./dataset/Banking_churn_prediction.csv", header = TRUE)
    tmp[Reduce(`&`, lapply(tmp, function(x) !(is.na(x)|x==""))),]
  })
  
  output$variableUni <- renderUI({
    selectInput("variableUni","Variable: ", colnames(data()))
  })
  
  observeEvent(input$variableUni, {
    updateCheckboxInput(session, "uniCateg", value = isCategorical(input$variableUni))
  })
  
  observeEvent(input$uniCateg,{
    
    output$plot1 <- renderPlot({
      print(summary(data()[,input$variableUni]))
      if(isCategorical(input$variableUni) | input$uniCateg){
        categData <- as.data.frame(table(data()[, input$variableUni]))
        
        return(
          barplot(categData$Freq, names.arg=categData$Var1,col = "orange",
                  border = "brown",main=paste("Diagramme à barres:  ", input$variableUni))
        )
      }else{
        return(
          boxplot(data()[, input$variableUni],
                  ylab = input$variableUni,
                  col = "orange",
                  border = "brown",
                  horizontal = TRUE,
                  notch = TRUE,
                  main=paste("Boite à moustache: ", input$variableUni)) 
        )
      }
      
    })
    
    output$summary <- renderDT({
      print(summary(data()[,input$variableUni]))
      if(isCategorical(input$variableUni) | input$uniCateg){
        categData <- as.data.frame(table(data()[, input$variableUni]))
        colnames(categData) <- c("Modalités", "Effectif")
        return(
          categData
        )
      }else{
        result <- data.frame(unclass(summary(data()[, input$variableUni])), check.names = FALSE, stringsAsFactors = FALSE)
        colnames(result) <- c("Valeur")
        return(
          result
        )
      }
      
    })
    
  })
  
  
  output$variableBi1 <- renderUI({
    selectInput("variable1","Variable 1: ", colnames(data()))
  })
  output$variableBi2 <- renderUI({
    selectInput("variable2","Variable 2: ", colnames(data()))
  })
  
  
  output$table <- renderDT(
    data()
  )
  }