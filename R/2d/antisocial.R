library(circlize)

png(filename = "Antisocial personality disease_2d.png",
    type = "cairo",
    units="in",
    width = 30,
    height = 30,
    pointsize = 1,
    res = 150)

# import connection data from csv
dat <- read.csv("Antisocial personality disease_connection_data.csv", sep = ",", head = FALSE);
# import heat connection data from csv
heat <- read.csv("Antisocial personality disease_heat_map_data.csv", sep = ",");

# heatmap data extraction & formatting
mat <- as.matrix(t(heat[,4:12]))
mat<- mat[nrow(mat):1,]
width <- 1000
height <- 100
heights <- rep(height/9,9)
widths <- rep(0,length(heat[,1]))

# chrodiagram data extraction & formatting
lab <- heat[,2]

tmp <- as.matrix(dat);
tmp = tmp +1
matt <- matrix(0,length(lab),length(lab))
matt[tmp] <- 1
rownames(matt) = lab
colnames(matt) = lab
cluster <- heat[,3]
name <- as.character(heat[,2])


# set background color of canvas
par(bg = 'black')

# heatmap ring
# generate dendrograms for all clusters
col_fun = colorRamp2(c(range(mat)[1],0,range(mat)[2]), c("black","mediumblue", "darkgoldenrod2"))
factors = rep(letters[1:5], times=c(6,2,5,2,5))
mat_list = list(a = mat[, factors == "a"],
                b = mat[, factors == "b"],
                c = mat[, factors == "c"],
                d = mat[, factors == "d"],
                e = mat[, factors == "e"])
dend_list = list(a = as.dendrogram(hclust(dist(t(mat_list[["a"]])))),
                 b = as.dendrogram(hclust(dist(t(mat_list[["b"]])))),
                 c = as.dendrogram(hclust(dist(t(mat_list[["c"]])))),
                 d = as.dendrogram(hclust(dist(t(mat_list[["d"]])))),
                 e = as.dendrogram(hclust(dist(t(mat_list[["e"]])))))

# setting circos parameter and generating heatmap
circos.par(cell.padding=c(0,0,0,0), gap.degree=0, start.degree=90, clock.wise=TRUE)
circos.initialize(factors, xlim = cbind(c(0, 0), table(factors)))
circos.track(ylim = c(0, 9), bg.border = NA, panel.fun = function(x, y) {
  sector.index = get.cell.meta.data("sector.index")
  m = mat_list[[sector.index]]
  dend = dend_list[[sector.index]]
  
  m2 = m[, order.dendrogram(dend)] 
  col_mat = col_fun(m2)
  nr = nrow(m2)
  nc = ncol(m2)
  for(i in 1:nr) {
    circos.rect(1:nc - 1, rep(nr - i, nc),
                1:nc, rep(nr - i + 1, nc),
                border = col_mat[i, ], col = col_mat[i, ])
  }
})

# clear circos because we are generating chrodiagram then combine both on a canvas
circos.clear()

# chordiagram
# setting color scheme for chordiagram
colors = c("dodgerblue4", "firebrick1","darkorange1", "bisque1", "white", "darkolivegreen4")
grid.col = c()
length(grid.col) <- length(lab)
for (i in 1:length(lab)){
  grid.col[i] <- assign(name[i], colors[cluster[i]])
}

# one line of magic that combines both visualizations
par(new=TRUE)

# setting new parameter
circos.par("canvas.xlim" = c(-1.25, 1.25), "canvas.ylim" = c(-1.25, 1.25), 
           gap.degree = 0, start.degree = 90, clock.wise = TRUE)

# generate chordiagram
chordDiagram(t(matt),grid.col = grid.col, transparency = 0,
             self.link = 2, annotationTrack = "grid",
             preAllocateTracks = list(track.height = max(strwidth(unlist(dimnames(matt))))),
             link.lwd = .01, link.border = "black")


dev.off()
circos.clear()