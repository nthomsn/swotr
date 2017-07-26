library(circlize);
library(parallel);




makeCircosDiagram <- function(clusterVal) {
  library(circlize);
##########################################################################################

disease = "Atypical autism";
png(filename = paste0("Github/swotr/www/",paste0(disease ,paste0(clusterVal,"_floor.png"))),
    type = "cairo",
    units="in",
    width = 20,
    height = 20,
    pointsize = 1,
    res = 150)

# Import connection data from SWOT clock site
dat <- read.csv(paste0(paste0("GitHub/swotr/data/",disease), "_connection_data.csv"), sep = ",", head = FALSE);
# Import heat connection data from SWOT clock site
heat <- read.csv(paste0(paste0("Github/swotr/data/",disease), "_heat_map_data.csv"), sep = ",");
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
colors = c("dodgerblue4", "firebrick1","darkorange1", "red4", "salmon4", "darkolivegreen4")


# Design the transparency for this specific cluster
row.col= c();
length(row.col) <- length(dat[,1]);

# Find out how many connections we have
count <- length(dat[,1])
start <- c(); length(start) <-count;
end <- c(); length(end) <- count;
cols <- c(); length(cols) <- count;

for (i in 1:length(dat[,1])){
  if (clusterVal == cluster[dat[i,1]+1]){
    start[i] <- name[dat[i,2]+1];
    end[i] <- name[dat[i,1]+1];
    cols[i] <- colors[clusterVal]
  } else if (clusterVal == cluster[dat[i,2]+1]) {
    start[i] <- name[dat[i,2]+1];
    end[i] <- name[dat[i,1]+1];
    cols[i] <- colors[clusterVal]
  } else {
    start[i] <- name[dat[i,2]+1];
    end[i] <- name[dat[i,1]+1];
    cols[i] <- "#0000FF10"
  }
}

col_df = data.frame(start, end, cols)

# End design of transparency

grid.col = c()
length(grid.col) <- length(lab)
for (i in 1:length(lab)){
  grid.col[i] <- assign(name[i], colors[cluster[i]])
}

circos.par(gap.degree = 0, start.degree = 270, clock.wise = TRUE)

chordDiagram(t(mat),grid.col = grid.col, transparency = 0,
             self.link = 2, annotationTrack = "grid",
             preAllocateTracks = list(track.height = max(strwidth(unlist(dimnames(mat))))),
             link.lwd = 5.5/length(lab), link.border = "black", col = col_df)

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

##########################################################################################
}
#makeCircosDiagram(3)
# Parallelism magic
no_cores <- detectCores()-1;
cl <- makeCluster(no_cores);
parLapply(cl, 1:6, makeCircosDiagram)
stopCluster(cl)

