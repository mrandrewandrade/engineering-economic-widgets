library(shiny)

shinyUI(fluidPage(
  titlePanel("Interest and Annuity Factors Calculator for Discrete Compounding, Discrete Cash Flows"),
  
  # Sidebar with inputs for the interest rate and number of periods
  sidebarLayout(
    sidebarPanel(  
      
      numericInput("interest_rate",
                   label = h4("Effective interest rate i% ="),
                   value = 10),
      numericInput("number_periods",
                   label = h4("Number of Periods  N ="),
                   value = 12),
      numericInput("given_value",
                   label = h4("Given Value for P, F, A or G"),
                   value = 1)  
    ),
    
    # Show a table of the computed values.
    mainPanel(
      tableOutput("values"),
      tableOutput("equivilent")
    )
  )
))