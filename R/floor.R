
library(circlize);
library(RCircos);

png(filename = "floor.png",
    type = "cairo",
    units="in",
    width = 20,
    height = 20,
    pointsize = 1,
    res = 500)


# Import connection data from SWOT clock site
dat <- read.csv("Microcephaly_connection_data.csv", sep = ",", head = FALSE);
# Import heat connection data from SWOT clock site
heat <- read.csv("Microcephaly_heat_map_data.csv", sep = ",");
lab <- heat[,2]

tmp <- as.matrix(dat);
tmp = tmp +1
mat <- matrix(0,length(lab),length(lab))
mat[tmp] <- 1
rownames(mat) = lab
colnames(mat) = lab


cluster <- heat[,3]
name <- as.character(heat[,2])
par(bg = 'black')
colors = c("dodgerblue4", "firebrick1","darkorange1", "bisque1", "white", "darkolivegreen4")

grid.col = c()
length(grid.col) <- length(lab)
for (i in 1:length(lab)){
  grid.col[i] <- assign(name[i], colors[cluster[i]])
}

circos.par(gap.degree = 0, start.degree = 270, clock.wise = TRUE)

chordDiagram(t(mat),grid.col = grid.col, transparency = 0,
             self.link = 2, annotationTrack = "grid",
             preAllocateTracks = list(track.height = max(strwidth(unlist(dimnames(mat))))),
             link.lwd = .01, link.border = "black")

if (FALSE) {
circos.track(track.index = 1, panel.fun = function(x,y) {
  xlim = get.cell.meta.data("xlim")
  xplot = get.cell.meta.data("xplot")
  ylim = get.cell.meta.data("ylim")
  sector.name = get.cell.meta.data("sector.index")
  circos.text(mean(xlim), ylim[1], sector.name, facing = "clockwise",
              niceFacing = TRUE, adj = c(0,0.5), col = "black", cex = 0.3)
}, bg.border = NA)
}


dev.off()
circos.clear()
