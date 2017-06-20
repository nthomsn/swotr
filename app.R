# A small example that shows multipage shiny in action

library(plotly)
library(shiny)

source("./R/multipage_shiny_lib.R")

settings = createMultipageServer(
  list(
    selectInput(inputId = "example",
                label = "Make this appear in other view:",
                choices = c('Choice 1', 'Choice 2'),
                selected = 'Choice 1')
  ),
  wall = function(input) {
    return(plot_ly() %>% layout(title=input$example))
  }
)

shinyApp(ui = settings$ui, server = settings$server)
