# A small example that shows multipage shiny in action and an embedded image

library(plotly)
library(shiny)

source("./R/multipage_shiny_lib.R")

wallImages = list(
  list(
    source = "wall.png",
    xref = "paper",
    yref = "paper",
    x= 0,
    y= 1,
    sizex = 1,
    sizey = 1,
    opacity = 1
  )
)

shinyAppPages = createMultipageServer(
  list(
    selectInput(inputId = "example",
                label = "Make this appear in other view:",
                choices = c('Choice 1', 'Choice 2'),
                selected = 'Choice 1')
  ),
  Floor = function(input) {
    return(plot_ly() %>% layout(title=input$example))
  },
  Wall = function(input) {
    return(plot_ly() %>% layout(title=input$example, images=wallImages))
  }
)

shinyApp(ui = shinyAppPages$ui, server = shinyAppPages$server)
