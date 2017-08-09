# Nick's implementation of multiwindow shiny for campfire
# Three windows: The controller, wall, and floor are hard
# coded, and any shiny objects are supported inside each
# window. This gives more flexibility than the other
# multiwindow shiny which can only display plotly objects

library(shiny)

campfireApp = function(controller = NA, wall = NA, floor = NA, serverFunct = NA) {
	ui <- campfireUI(controller, wall, floor)

	serverValues = reactiveValues()
	campfire_server <- shinyServer(function(input, output) {

		observe({
			for (inputId in names(input)) {
				serverValues[[inputId]] <- input[[inputId]]
			}
		})
		serverFunct(serverValues, output)

	})

	options(shiny.port = 5480)
	shinyApp(ui, server = campfire_server)
}

campfireUI = function(controller, wall, floor) {
	ui <- shinyUI(bootstrapPage(
		HTML('<script type="text/javascript">
			$(function() {
				$("div.Window").hide(); 
				var tokens = window.location.href.split("?");
				if (tokens.length > 1) {
					var shown_window = tokens[1];
					$("div."+shown_window).show();
				} else {
					$("div.WindowSelector").show();
				}
			});
		     </script>'),
		div(class="WindowSelector Window",
		    HTML('<a href="?Controller">Controller</a></br>'),
		    HTML('<a href="?Wall">Wall</a></br>'),
		    HTML('<a href="?Floor">Floor</a></br>')
		),
		div(class="Controller Window",
		    controller
		),
		div(class="Wall Window",
		    wall 
		),
		div(class="Floor Window",
		    floor
		)
	))

	return(ui)
}


campfireApp(
	controller = div(
		h1("Super Awesome Controller"),
		selectInput(inputId = "fruitSelection",
			label = "Pick a fruit",
			choices = c("Apple", "Banana", "Pear"))
	),
	wall = div(
		h1("Super Awesome Wall"),
		textOutput("wallText")
	),
	floor = div(
		h1("Super Awesome Floor"),
		textOutput("floorText")
	),
	serverFunct = function(serverValues, output) {
		output$wallText <- renderText({ serverValues$fruitSelection })
		output$floorText <- renderText({ serverValues$fruitSelection })
	}
)
