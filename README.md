# SWOTR
R based visualizations for RPI campfire

![Preview](http://i.imgur.com/dGzGth1.jpg)

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
