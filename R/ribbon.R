library(RCircos)
library(readr)

#' Create a dataframe that can be used to set up an RCircos chart
#' 
#' @param num.chromsomes The number of "chromosomes" that will be used on the 
#' chart, this will be the number of nodes on the edge of the circle. These
#' may or may not represent real chromosomes. A location on the circle is called
#' a chromosome in circos jargon.
dummy.chromosome.df <- function(num.chromosomes=10) {
  Chromosome <- paste("chr", seq(1, num.chromosomes), sep="")
  chromosomes.df <- data.frame(Chromosome)
  chromosomes.df$ChromStart <- rep(0, num.chromosomes)
  chromosomes.df$ChromEnd <- rep(100000000, num.chromosomes)
  chromosomes.df$Band <- rep("p36.33", num.chromosomes)
  chromosomes.df$Stain <- rep("gneg", num.chromosomes)
  return(chromosomes.df)
}

data(RCircos.Ribbon.Data)

# Setup RCircos with the dummy chromosomes
RCircos.Set.Core.Components(dummy.chromosome.df(10), NULL, 10, 0)

example_data <- read_csv("~/IDEA/rcircos/na.csv")
example_data$chromA <- factor(example_data$chromA)
example_data$chromB <- factor(example_data$chromB)

# Setup graphics environment
png(file = "myplot.png", bg = "white", width=1920, height=1080)
RCircos.Set.Plot.Area()

RCircos.Chromosome.Ideogram.Plot()

# Render example_data ribbons to track 1
track.num <- 1
RCircos.Ribbon.Plot(data.frame(example_data), track.num, FALSE)
dev.off()

