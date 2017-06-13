library(readr)
library(circlize)

fake_na_migration <- read_csv("./data/fake_na_migration.csv")
chordDiagram(fake_na_migration)
