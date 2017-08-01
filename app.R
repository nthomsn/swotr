# A small example that shows multipage shiny in action and an embedded image

library(plotly)
library(shiny)

source("./R/multipage_shiny_lib.R")

disease <- "Microcephaly"

wallImages = list(
  list(
    source = paste0(disease, "_wall.png"),
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
for (i in 1:7)  {
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


shinyAppPages = createMultipageServer(
  list(
    selectInput(inputId = "frames",
                label = "Select Stage of Development:",
                choices = c('Pluripotency', 'Neuroectoderm',
                            'Neural Differentiation', 'Cortical Specification',
                            'Deep Layers', 'Upper Layers','Original'),
                selected = 'Original'),
    selectInput(inputId = "dis",
                label = "Select disease:",
                choices = c("Antisocial personality disease",
                            "Atypical autism","Microcephaly"
                            ),
                selected = "Microcephaly")
  ),
  Floor = function(input) {
    stages = c('Pluripotency', 'Neuroectoderm',
                'Neural Differentiation', 'Cortical Specification',
                'Deep Layers', 'Upper Layers','Original')
    index = 1
    for (i in 1:7)  {
      if (input$frames == stages[i]) {
        index <- i;
        break;
      }
    }
    disease <- input$dis
    return(plot_ly() %>% layout(title=input$example,
                                images = list(
                                  list(
                                    source = paste0(disease, paste0(toString(index),"_floor.png" )),
                                    xref = "paper",
                                    yref = "paper",
                                    x = 0,
                                    y = 1,
                                    sizex = 1,
                                    sizey = 1,
                                    opacity = 1
                                  )
                                ),
                                paper_bgcolor = 'black', plot_bgcolor = 'black'))
  },
  Wall = function(input) {
    disease <- input$dis
    return(plot_ly() %>% layout(title=input$example, 
                                images= list(
                                  list(
                                    source = paste0(disease, "_wall.png"),
                                    xref = "paper",
                                    yref = "paper",
                                    x= 0,
                                    y= 1,
                                    sizex = 10,
                                    sizey = 1,
                                    opacity = 1
                                  )
                                ), paper_bgcolor = 'black', plot_bgcolor = 'black'))
  }
)

shinyApp(ui = shinyAppPages$ui, server = shinyAppPages$server)
