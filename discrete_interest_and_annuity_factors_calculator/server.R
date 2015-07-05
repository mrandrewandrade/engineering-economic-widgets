library(shiny)
library(FinCal)

shinyServer(function(input, output) {
  
  factor_calculation <- function(interest_rate, number_periods) {
    
    factors <-data.frame(
      name = c("Single Payment Compound Amount Factor", 
               "Single Payment Present Worth Factor",
               "Uniform Series Compound Amount Factor",
               "Uniform Series Sinking Fund Factor",
               "Uniform Series Present Worth Factor",
               "Uniform Series Capital Recovery Factor",
               "Gradient Series Present Worth    [P/G,i%, N]=",
               "Gradient Future Worth    [F/G, i%, N]=",
               "Gradient Uniform Series Factor    [A/G, i%, N]="),

      notation = c("[F/P,i%,N]=",
                 "[P/F,i%,N]=",
                 "[F/A, i%, N]=",
                 "[A/F, i%, N]=",
                 "[P/A, i%, N]=",
                 "[A/P, i%, N]=",
                 "[P/G,i%, N]=",
                 "[F/G, i%, N]=",
                 "[A/G, i%, N]="),  
      factor_value = c(fv(input$interest_rate/100,input$number_periods,-1,0,0),
                pv(input$interest_rate/100,input$number_periods,-1,0,0),
                fv(input$interest_rate/100,input$number_periods,0,-1,0),
                pmt(input$interest_rate/100,input$number_periods,0,-1,0),
                pv(input$interest_rate/100,input$number_periods,0,-1,0),
                pmt(input$interest_rate/100,input$number_periods,-1,0,0),
                NA,
                NA,
                NA)
    )
    #gradient factors are easier to calculate using previous calculated values 
    factors$factor_value[8] <- 100*(factors$factor_value[3]-number_periods)/interest_rate
    factors$factor_value[7] <- factors$factor_value[8]*factors$factor_value[2]
    factors$factor_value[9] <- factors$factor_value[4]*factors$factor_value[8]
    return(factors)
  }
  equivilent_calculation <- function(given_value) {
    
    equivilents <-data.frame(
      
      given = c("P",
                "F",
                "A",
                "F",
                "A",
                "P",
                "G",
                "G",
                "G"),
      looking_for = c("F=",
                      "P=",
                      "F=",
                      "A=",
                      "P=",
                      "A=",
                      "P=",
                      "F=",
                      "A="),  
      equivalent_value= c(NA,
                          NA,
                          NA,
                          NA,
                          NA,
                          NA,
                          NA,
                          NA,
                          NA)
      
    )
    
    #calculate the equivilant value at different time
    
    factors<-factor_calculation(input$interest_rate,input$number_periods)
    equivilents$equivalent_value <- factors$factor_value*given_value
    
    return(equivilents)
  }
  
  reactive_factor_calculation <- reactive({
    
    factor_calculation(input$interest_rate,input$number_periods)
    
  })
  reactive_equivilent_calculation <- reactive({
    equivilent_calculation(input$given_value)
  })
  
  output$values <- renderTable(
    reactive_factor_calculation(),
    digits=8
  )
  
  output$equivilent <- renderTable(
    reactive_equivilent_calculation(),
    digits=2
  )
  

})