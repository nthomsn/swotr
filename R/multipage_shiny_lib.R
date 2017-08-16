library(shiny)
library(shinyjs)

# Create viewer object that represents html and wraps other objects
viewer <- function(id, ...) {
	return(div(
		id=id,
		class="viewer",
		...
	))
}

# Create a plot object that represents html
plotViewer <- function(id) {
	return(fillPage(
	  div(
		  id=id,
		  class="viewer",
		  plotlyOutput(outputId = id)
	  )
	))
}

# Make a multi-window shiny app from one controllerView and any number of reactiveViews
createMultipageServer <- function(controllerView, ...) {

	# Parse some number of reactiveViews in the ... arg into a list
	reactiveViews <- list(...)
	controller <- viewer('Controller', controllerView)
	controllerInput <- reactiveValues()

	# server maps input to output
	server <- function(input, output) {
		# we will observe every input change
		observe({
			# for each option in out inputs
			for(opt in names(input)) {
				# we ignore non-viewers
				if(opt != "viewer" && input$viewer == "Controller") {
					controllerInput[[opt]] = input[[opt]]
				}
			}
		})
		# binding the kwargs to an output render. Here is where you would
		# update the render method
		for(o in names(reactiveViews)) {
			code = paste0("renderPlotly({reactiveViews[[\"", o, "\", exact=FALSE]](controllerInput)})")
			clojure <- eval(parse(text = code))
			output[[o]] <- clojure
		}
	}

	# here we create containers for the plot viewers so we can hide or show them
	# This programically creates a string to interpret as R code with eval(). Fun!
	e <- "div(id = \"viewers\", class = \"container\", controller"
	for(i in 1:length(names(reactiveViews))) {
		e <- paste0(e, ", plotViewer(names(reactiveViews)[[", i, "]])")
	}
	e <- paste0(e, ")")
	viewers <- eval(parse(text=e))

	# Create 'ui' that represents the actual interface on the webpage. This R
	# object becomes the html css and js in the browser.
	ui <- bootstrapPage(
		useShinyjs(),
		includeScript('www/multipage.js'),
		includeCSS('www/multipage.css'),
		selectInput(inputId = "viewer",
			label = "Viewer:",
			choices = c("-", "Controller", names(reactiveViews)),
			selected = "-"),
		viewers
	)

	return(list(ui = ui, server = server))
}
