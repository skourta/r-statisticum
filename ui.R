library(shinydashboard)
library(DT)

dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Univariate Study", tabName = "univariate", icon = icon("dice-one")),
      menuItem("Bivariate Study", tabName = "bivariate", icon = icon("dice-two")),
      menuItem("Prediction", tabName = "prediction", icon = icon("dice-three")),
      menuItem("General Study", tabName = "general", icon = icon("dice-four"))
    )
  ),
  dashboardBody(
    tabItems(
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
                ),),
              fluidRow(
                column(width = 12,
                       tabsetPanel(type = "tabs",
                                   tabPanel("Information du model", column(
                                     
                                     width=12,
                                     
                                   )),
                                   tabPanel("Summary", column(
                                     width=12,
                                     
                                   )),
                                   tabPanel("Table", )
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
      )
    ),
    
  )
)