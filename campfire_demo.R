# A small example that shows multipage shiny in action

library(plotly)
library(shiny)

source("./R/multipage_shiny_lib.R")

settings = createMultipageServer(
  list(
    selectInput(inputId = "wallselection",
                label = "Make this appear on the wall",
                choices = c('Choice 1', 'Choice 2'),
                selected = 'Choice 1'),
    selectInput(inputId = "floorselection",
                label = "Make this appear on the floor",
                choices = c('Choice 1', 'Choice 2'),
                selected = 'Choice 1')
  ),
  Floor = function(input) {
    return(plot_ly() %>% layout(title=input$floorselection))
  },
  Wall = function(input) {
    return(plot_ly() %>% layout(title=input$wallselection))
  }
)

shinyApp(ui = settings$ui, server = settings$server)
