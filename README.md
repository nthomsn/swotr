# SWOTR
R based visualizations for RPI campfire

![Preview](http://i.imgur.com/As0DrmN.jpg)

## Getting started
* Follow the ubuntu installation guide or clone the repo and install all the R packages listed under `Imports:` in the `DESCRIPTION` file
* Run `graph_demo.R` in Rstudio or `$ Rscript graph_demo.R` on the command line
* Open `localhost:5480` in multiple browser windows and select different views from the dropdown

## Ubuntu installation
Install R and build-essential for compilation of R packages
```
$ sudo apt-get install -y r-base build-essential
```

Install ubuntu package dependencies for the R package devtools
```
$ sudo apt-get install -y libcurl4-gnutls-dev libxml2-dev libssl-dev
```

Install devtools
```
$ Rscript -e "install.packages('devtools', repos='http://cran.us.r-project.org')"
```

Clone the repository
```
$ git clone https://github.com/nthomsn/swotr.git
```

Go into the root directory
```
$ cd swotr
```

Install the dependencies for swotr
```
$ Rscript -e "library(devtools); install_deps()"
```
