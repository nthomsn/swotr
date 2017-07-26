# A small example that shows multipage shiny in action and an embedded image

library(plotly)
library(shiny)

source("./R/multipage_shiny_lib.R")

disease <- "Atypical autism"

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

floors = c(); length(floors) = 6
for (i in 1:6)  {
  assign(paste0("floorImage", i), 
         list(
           list(
             source = paste0(disease, paste0(toString(i),"_floor.png" )),
             xref = "paper",
             yref = "paper",
             x = 0,
             y = 1,
             sizex = 1,
             sizey = 1,
             opacity = 1
           )
         ), envir = .GlobalEnv);
  floors[i] <- eval(parse(text = paste0("floorImage", i)))
}

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
                label = "Select Stage of Development:",
                choices = c('Pluripotency', 'Neuroectoderm',
                            'Neural Differentiation', 'Cortical Specification',
                            'Deep Layers', 'Upper Layers'),
                selected = 'Pluripotency')
  ),
  Floor = function(input) {
    stages = c('Pluripotency', 'Neuroectoderm',
                'Neural Differentiation', 'Cortical Specification',
                'Deep Layers', 'Upper Layers')
    index = 1
    for (i in 1:6)  {
      print(i)
      if (input == stages[i]) {
        index <- i; print(i)
        break;
      }
    }
    return(plot_ly() %>% layout(title=input$example,
                                images = floors[index]))
  },
  Wall = function(input) {
    return(plot_ly() %>% layout(title=input$example, images=wallImages))
  }
)

shinyApp(ui = shinyAppPages$ui, server = shinyAppPages$server)
