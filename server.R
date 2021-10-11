function(input, output) { 
  set.seed(122)
  histdata <- rnorm(500)
  
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
  output$variableBi1 <- renderUI({
    selectInput("variable1","Variable 1: ", colnames(data()))
  })
  output$variableBi2 <- renderUI({
    selectInput("variable2","Variable 2: ", colnames(data()))
  })
  
  output$plot1 <- renderPlot({
    print(class(data()[,input$variableUni]))
        plot(data()[, input$variableUni])
    
  })
  }