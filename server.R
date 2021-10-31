library(ggplot2)
library(hrbrthemes)
library(viridis)
library(ggcorrplot)


function(input, output, session) { 
  set.seed(122)
  histdata <- rnorm(500)
  
  mainColor <- "#69b3a2"
  
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
    selectInput("contentVar1","Variable 1: ", colnames(data()))
  })
  output$variableBi2 <- renderUI({
    selectInput("contentVar2","Variable 2: ", colnames(data()))
  })
  
  
  output$table <- renderDT(
    data()
  )
  
  
  
  variableTypes <- function(var1, var2){
    typeVar1 <- isCategorical(var1)
    typeVar2 <- isCategorical(var2)
    if (input$var1Bi){
      if (input$var2Bi){
        return("cc")
      }else{
        return("cq")
      }
    }else{
      if (input$var2Bi){
        return("qc")
      }else{
        return("qq")
      }
    }
  }
  
  
  
  
  
  #======================================
  # BIVARIATE
  
  observeEvent(input$contentVar1, {
    updateCheckboxInput(session, "var1Bi", value = isCategorical(input$contentVar1))
  })
  
  observeEvent(input$contentVar2, {
    updateCheckboxInput(session, "var2Bi", value = isCategorical(input$contentVar2))
  })
  
  observeEvent(input$var1Bi,{
    renderPlots()
  })
  
  observeEvent(input$var2Bi,{
    renderPlots()
  })
  
  renderPlots <- reactive({
    types <- variableTypes(input$contentVar1, input$contentVar2)
    
    output$plot1BiLog <- renderPlot({
      if(types == "qq"){
      xdata = log(data()[,input$contentVar1])
      ydata = log(data()[,input$contentVar2])
      ggplot(data(), aes(x=xdata, y=ydata), ) + ggtitle("Appliquons la fonction log pour eliminer l'effet des valeurs aberrantes") +
        labs(x = input$contentVar1, y= input$contentVar2) + geom_point(size=1, color=mainColor) + stat_smooth(method = lm)
      }else{
        return(NULL)
      }
      })
    
    output$plot1Bi <- renderPlot({
      if(types == "qq"){
        correlation = cor(data()[,input$contentVar1], data()[, input$contentVar2])
        if(abs(correlation) > 0.7){
          return(
            ggplot(data(), aes(x=data()[,input$contentVar1], y=data()[,input$contentVar2]), ) + 
              labs(x = input$contentVar1, y= input$contentVar2) + geom_point(size=1, color=mainColor) + stat_smooth(method = lm)
          )
        }else{
          return(
            ggplot(data(), aes(x=data()[,input$contentVar1], y=data()[,input$contentVar2]), ) + 
              labs(x = input$contentVar1, y= input$contentVar2) + geom_point(size=1, color=mainColor)
          )
        }
        
        
        
      }
      if(types == "qc" | types == "cq"){
        if(types == "qc"){
          locaVar1 = input$contentVar2
          locaVar2 = input$contentVar1
        }else{
          locaVar1 = input$contentVar1
          locaVar2 = input$contentVar2
        }
        return( 
          ggplot(data(), aes(x=data()[,locaVar1], y=data()[,locaVar2], fill=data()[,locaVar1])) +
            geom_boxplot() +
            scale_fill_viridis(discrete = TRUE, alpha=0.6) +
            geom_jitter(color="black", size=0.4, alpha=0.2) +
            theme(
              plot.title = element_text("size=11")
            ) +
            ggtitle(paste("Boite à moustache: ", locaVar1, "en fontion de ", locaVar2)) +
            labs(x=locaVar1, y=locaVar2, fill=locaVar1) 
        )
      }
      if(types == "cc"){
        return(
          ggplot(data(), aes(x = data()[,input$contentVar1], fill = data()[,input$contentVar2])) + geom_bar(position = "dodge")+
            labs(x=input$contentVar1, fill=input$contentVar2)
        )
      }
    })
    
    output$summaryBi <- renderTable({
      
      if(types == "qq"){
        # Définition des colonnes choisies 
        var.names <- c(input$contentVar1, input$contentVar2)
        # Initialisation de la table
        caract.df <- data.frame()
        # Pour chaque colonne, calcul de min, max, mean et ecart-type
        for(strCol in var.names){
          caract.vect <- c(min(data()[, strCol]), max(data()[,strCol]), 
                           mean(data()[,strCol]), sqrt(var(data()[,strCol])))
          caract.df <- rbind.data.frame(caract.df, caract.vect)
        }
        # Définition des row/colnames
        rownames(caract.df) <- var.names
        colnames(caract.df) <- c("Minimum", "Maximum", "Moyenne", "Ecart-type")
        # Renvoyer la table
        return(caract.df)
      }
      if(types == "qc" | types == "cq"){
        if(types == "qc"){
          locaVar1 = input$contentVar2
          locaVar2 = input$contentVar1
        }else{
          locaVar1 = input$contentVar1
          locaVar2 = input$contentVar2
        }
        # Initialisation de la table
        statsSummary <- data.frame()
        # Pour chaque modalité, calcul de mean et écart-type
        moyenne <- tapply(data()[,locaVar2] , data()[,locaVar1], mean)
        statsSummary <- rbind.data.frame(statsSummary, t(moyenne))
        standardDeriv = tapply(data()[,locaVar2] , data()[,locaVar1], sd)
        statsSummary <- rbind.data.frame(statsSummary, t(standardDeriv))
        rownames(statsSummary) <- c("Moyenne", "Ecart Type")
        # Renvoyer la table
        return(statsSummary) 
      }
    }, rownames = TRUE, digits = 2)
    
    output$correlation <- renderText({
      if(types == "qq"){
        paste("La correlation entre",input$contentVar1, "et", input$contentVar2,"est:", cor(data()[,input$contentVar1],data()[,input$contentVar2]), sep = " ")
      }
      
    })
  })
  
  
  output$tableBi <- renderDT(
    data()
  )
  
  
  
  output$corrType <- renderUI({
    selectInput("corrTypeValue","Type de correlation: ", c("Pearson", "Spearman"))
  })
  
  output$heatMap <- renderPlot({
    print(input$corrTypeValue)
    num_cols = unlist(lapply(data(), is.numeric))
    numerical_data = data()[,num_cols]
    if(input$corrTypeValue == "Pearson"){
      corr <- round(cor(numerical_data, method = "pearson"), 1)
      return(ggcorrplot(corr))
    }
    if(input$corrTypeValue == "Spearman"){
      corr <- round(cor(numerical_data, method = "spearman"), 1)
      return(ggcorrplot(corr))
    }
    print(input$corrTypeValue)
    
    
  })
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  #Prediction
  output$predictionVariablesUI <- renderUI({
    selectInput("predictionVariables","Les variables explicatives: ", multiple = T, colnames(data()))
  })
  
  output$targetVariableUI <- renderUI({
    selectInput("targetVariable","La variable cible: ", colnames(data()))
  })
  
  observeEvent(input$targetVariable, {
    updateCheckboxInput(session, "targetVar", value = isCategorical(input$targetVariable))
  })
  
  
}