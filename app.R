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
    sizex = 10,
    sizey = 1,
    opacity = 1
  )
)

floorImages = list(
  list(
    source = "floor.png",
    xref = "paper",
    yref = "paper",
    x = 0,
    y = 1,
    sizex = 1,
    sizey = 1,
    opacity = 1
  )
)

shinyAppPages = createMultipageServer(
  list(
    selectInput(inputId = "frames",
                label = "Make this appear in other view:",
                choices = c('one.png', 'two.jpg'),
                selected = 'one.png')
  ),
  Floor = function(input) {
    return(plot_ly() %>% layout(title=input$example,
    images = list(
                list(
                  source = input$frames,
                  xref = "paper",
                  yref = "paper",
                  x = 0,
                  y = 1,
                  sizex = 1,
                  sizey = 1,
                  opacity = 1
                )
    )))
  },
  Wall = function(input) {
    return(plot_ly() %>% layout(title=input$example, images=wallImages))
  }
)

shinyApp(ui = shinyAppPages$ui, server = shinyAppPages$server)
