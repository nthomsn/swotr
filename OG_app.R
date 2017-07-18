library(igraph)
library(gtools)
library(ggplot2)
library(plotly)
library(shiny)
library(shinyjs)
library(readr)

source("./R/multipage_shiny_lib.R")

blankAxis <- axis <- list(title = "", showgrid = FALSE, showticklabels = FALSE, zeroline = FALSE)

# some example data
vgsales <- read_csv("./data/vgsales.csv")

getEdges <- function(vg, field) {
  # edges connect by field
  fields <- vg[[field]]
  ufields <- unique(fields)

  edges <- c()

  # for each unique field
  for(f in ufields) {
    # index of each instance of that field
    allf <- which(fields == f)
    # if there are more      then 2
    if(length(allf) > 2) {
      # permutate to get each edge
      # note that t is used so flattening goes by row, not column
      combos <- t(permutations(n=length(allf), r=2, v=allf, repeats.allowed = F))
      # add to edges
      edges <- append(edges, combos)
    }
    # if there 2, theres no need to permutate
    if(length(allf) == 2) {
      # add ony the one edge
      edges <- append(edges, allf)
    }
  }

  return(edges);
}

# turn an igraph object into a plotly graph
igraph_to_plotly <- function(G, L, hover = "text", edgeColor = "#030303") {
  print("Error incoming...")
  # get vetrex set and edge set
  vs <- V(G)
  es <- as.data.frame(get.edgelist(G))
  Nv <- length(vs)
  Ne <- length(es[1]$V1)

  # Margins
  m <- list(
    l = 50,
    r = 0,
    b = 0,
    t = 50,
    pad = 0
  )

  # get layout
  Xn <- L[,1]
  Yn <- L[,2]
  network <- plot_ly(x = ~Xn, y = ~Yn, mode = "markers", text = vs$label, hoverinfo = "text") %>%
  layout(autosize = F, width = 1130, height = 1130, margin = m)

  # draw lines between edges
  edge_shapes <- list()
  for(i in 1:Ne) {
    v0 <- es[i,]$V1
    v1 <- es[i,]$V2

    # edge is a line
    edge_shape = list(
      type = "line",
      line = list(color = "#fff", width = 1.2),
      x0 = Xn[v0],
      y0 = Yn[v0],
      x1 = Xn[v1],
      y1 = Yn[v1]
    )

    # save edge shape
    edge_shapes[[i]] <- edge_shape
  }

  print(edge_shapes)

  # no title, blank layout
  return(layout(
    network,
    title = '',
    shapes = edge_shapes,
    xaxis = blankAxis,
    yaxis = blankAxis,
    paper_bgcolor = "#000",
    plot_bgcolor = "#000",
    scene = list(
      autorange = F,
      aspectmode = 'manual',
      aspectratio = list(x = 1, y = 1)
    )
  ))
}

# server maps input to output
settings = createMultipageServer(
  list(
	# input which edges we want to draw
    selectInput(inputId = "edges",
      label = "Select graph:",
      choices = c('Genre', 'Platform'),
      selected = 'Genre'),
	# input the number of games we want to render
    sliderInput(inputId = "games",
      label = "Number of games:",
      min = 4,
      max = 100,
      value = 20)
  ),
  # function which returns the wall plot
  Wall = function(input) {
    vgsmall <- head(vgsales, input$games)

    return(plot_ly(
      x = 1:input$games,
      y = vgsmall[["Global_Sales"]],
      name=vgsmall[["Name"]],
      type='bar',
      yaxis = blankAxis,
      color = I("blue")
    ) %>% layout(paper_bgcolor="#000", plot_bgcolor="#000", title="Hi",
                 margin=c(l=0,r=0,t=0,b=0, pad=0, xaxis=c(color="#fff"))))
  },
  # function which returns floor plot
  Floor = function(input) {
    # make a graph using input
    vgsmall <- head(vgsales, input$games)

    g <- make_directed_graph(getEdges(vgsmall, input$edges), n=input$games)
    layout <- layout.circle(g)

    return(igraph_to_plotly(G=g, L=layout) %>% config(displayModeBar = F))
  }
)

shinyApp(ui = settings$ui, server = settings$server)
