library(shiny)
library(shinyjs)

# generic viewer
viewer <- function(id, ...) {
	return(div(
		id=id,
		class="viewer",
		...
	))
}

# plot viewer, which had more functionality
# but has since moved into the main function
plotViewer <- function(id) {
	return(fillPage(div(
		id=id,
		class="viewer",
		plotlyOutput(outputId = id, width = "100%", height = "100%")
	)))
}

# the function called from outside the controller
createMultipageServer <- function(controllerArgs, ...) {
	args <- list(...)
	
	controller <- do.call(viewer, c('Controller', controllerArgs))
	
	controlledInput <- reactiveValues()
	
	# server maps input to output
	server <- function(input, output, session) {
		# we will observe every input change
		observe({
			# for each option in out inputs
			for(opt in names(input)) {
				# we ignore non-viewers 
				if(opt != "viewer" && input$viewer == "Controller") {
					controlledInput[[opt]] = input[[opt]]
				}
			}
		})
		# binding the kwargs to an output render. Here is where you would
		# update the render method
		for(o in names(args)) {
			output[[o]] <- eval(parse(text = paste0("renderPlotly({
				args$", o, "(controlledInput)
			})")))
		}
	}

	# here we create containers for the plot viewers so we can hide or show them
	e <- "div(id = \"viewers\", class = \"container\", controller"
	for(i in 1:length(names(args))) {
		e <- paste0(e, ", plotViewer(names(args)[[", i, "]])")
	}
	e <- paste0(e, ")")
	viewers <- eval(parse(text=e))
	
	# ui is the page itself
	ui <- bootstrapPage(
		useShinyjs(),
		includeScript('www/multipage.js'),
		tags$head(
			tags$link(rel = "stylesheet", type = "text/css", href = "multipage.css")
		),
		selectInput(inputId = "viewer",
		label = "Viewer:",
		choices = c("-", "Controller", names(args)),
		selected = "-"),
		viewers
	)

	return(list(ui = ui, server = server))
}