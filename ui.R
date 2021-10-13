library(shinydashboard)
library(DT)

dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Univariate Study", tabName = "univariate", icon = icon("dice-one")),
      menuItem("Bivariate Study", tabName = "bivariate", icon = icon("dice-two"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "univariate",
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
                  uiOutput("variableBi2")
                ),),
              fluidRow(
                column(width = 12,
                       tabsetPanel(type = "tabs",
                                   tabPanel("Plots", plotOutput("plotBi")),
                                   tabPanel("Summary", DTOutput("summaryBi")),
                                   tabPanel("Table", DTOutput("tableBi"))
                       ))
              )
              
      )
    ),
    
  )
)