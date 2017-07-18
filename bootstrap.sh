# Update base ubuntu packages
apt-get update
apt-get upgrade -y

# Install R and compilation tools
apt-get install -y build-essential r-base
# Install devtools ubuntu package dependencies
apt-get install -y libcurl4-gnutls-dev libxml2-dev libssl-dev
# Install devtools within R
Rscript -e "install.packages('devtools', repos='http://cran.us.r-project.org')"

# Clone the swotr repo
git clone https://github.com/nthomsn/swotr.git

# Go into the swotr directory and install deps
cd swotr
Rscript -e "library(devtools);install_deps()"
