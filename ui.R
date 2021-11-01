library(shinydashboard)
library(DT)

dashboardPage(
  skin = 'green',
  dashboardHeader(title = "R-Statisticum"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Choisir les données", tabName = "choose_data", icon = icon("database")),
      menuItem("Etude Univarié", tabName = "univariate", icon = icon("dice-one")),
      menuItem("Etude Bivarié", tabName = "bivariate", icon = icon("dice-two")),
      menuItem("Prédiction", tabName = "prediction", icon = icon("dice-three")),
      menuItem("Etude Générale", tabName = "general", icon = icon("dice-four")),
      menuItem("A propos", tabName = "about", icon = icon("address-card"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "choose_data",
            box(
              width = 12,
              fileInput("getFile", "Choisir le fichier CSV",
                        accept = c(
                          "text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv")
              ),
              tags$hr(),
              checkboxInput("header", "Entete", TRUE)
            ),
      ),
      tabItem(
        tabName = "univariate",
              fluidRow(
                box(
                  width=12,
                  title = "Univariate",
                  uiOutput("variableUni"),
                  checkboxInput("uniCateg", "Variable qualitative")
                ),
              ),
              fluidRow(
                column(width = 12,
                       tabsetPanel(type = "tabs",
                                   tabPanel("Plots", plotOutput("plot1")),
                                   tabPanel("Summary", DTOutput("summary")),
                                   tabPanel("Table", DTOutput("table"))
                       ))
                )
      ),
      tabItem(tabName = "bivariate",
              fluidRow(
                box(
                  width=12,
                  title = "Bivariate",
                  uiOutput("variableBi1"),
                  checkboxInput("var1Bi", "Variable 1 qualitative"),
                  uiOutput("variableBi2"),
                  checkboxInput("var2Bi", "Variable 2 qualitative"),
                ),),
              fluidRow(
                column(width = 12,
                       tabsetPanel(type = "tabs",
                                   tabPanel("Plots", column(
                                     width=12,
                                     plotOutput("plot1Bi"),
                                     plotOutput("plot1BiLog"),
                                   )),
                                   tabPanel("Summary", column(
                                     width=12,
                                     tableOutput("summaryBi"),
                                     textOutput("correlation")
                                   )),
                                   tabPanel("Table", DTOutput("tableBi"))
                       ))
              )
              
      ),
      
      tabItem(tabName = "prediction",
              fluidRow(
                box(
                  width=12,
                  title = "Prediction",
                  uiOutput("predictionVariablesUI"),
                  uiOutput("targetVariableUI"),
                  checkboxInput("targetVar", "La variable cible est qualitative"),
                  actionButton("learningButton", "Lancer l'entraînement"),
                ),),
              fluidRow(
                column(width = 12,
                       tabsetPanel(type = "tabs",
                                   
                                   tabPanel("Arbre", column(
                                     width=12,
                                     plotOutput("treePlot"),
                                     h3("Prédire des individus"),
                                     h5("Selectionner les individus et cliquer sur le bouton pour faire la prédiction:"),
                                     DTOutput("treePredictTable"),
                                     actionButton("treePredictButton", "Faire la prédiction"),
                                     verbatimTextOutput("treePredictResult"),
                                     h3("Résume du modèle"),
                                     verbatimTextOutput("treeText"),
                                     
                                   )),
                                   tabPanel("Regression", column(
                                     width=12,
                                     h3("Résume du modèle"),
                                     verbatimTextOutput("regText"),
                                     h3("Prédire des individus"),
                                     h5("Selectionner les individus et cliquer sur le bouton pour faire la prédiction:"),
                                     DTOutput("regPredictTable"),
                                     actionButton("regPredictButton", "Faire la prédiction"),
                                     verbatimTextOutput("regPredictResult"),
                                   )),
                       ))
              )
              
      ),
      tabItem(
        tabName = "general",
        fluidRow(
          box(
            width=12,
            title = "General Study",
          ),
        ),
        fluidRow(
          column(width = 12,
                 tabsetPanel(type = "tabs",
                             tabPanel("Correlation Heat Map", 
                                      uiOutput("corrType"),
                                      plotOutput("heatMap")),
                 ))
        )
      ),
      tabItem(
        tabName = 'about',
        box(
          width = 12,
          h3("R-Statisticum: Outils d'exploration des données."),
          p("Cette application a été développé dans le cadre de projet du module 'Accompagnement', master AMSD de l'université de Paris."),
          strong("- BENABED Youcef"),
          br(),
          strong("- KOURTA Smail"),
          br(),
          strong("- MOUACI Youcef"),br(),
          br(),
          a("Lien vers Github", href="https://github.com/skourta/r-statisticum")
        )
      )
    ),
    
  )
)