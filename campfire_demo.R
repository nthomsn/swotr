source("campfire_lib.R")

campfireApp(
  
  controller = div(
    h1("Controller"),
    selectInput(inputId = "fruitSelection",
      label = "Pick a fruit",
      choices = c("Apple", "Banana", "Pear"))
  ),
  
  wall = div(
    h1("Wall"),
    textOutput("wallText")
  ),
  
  floor = div(
    h1("Floor"),
    textOutput("floorText")
  ),
  
  serverFunct = function(serverValues, output) {
    output$wallText <- renderText({ serverValues$fruitSelection })
    output$floorText <- renderText({ serverValues$fruitSelection })
  }
  
)