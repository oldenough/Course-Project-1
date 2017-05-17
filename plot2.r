## Exploratory Data Analysis Course Project 1
## Plot 2
## 17 May, 2017

## 1. Check to make sure the necessary libraries are available and loaded.
## 2. Set the working directory from the clipboard.
## 3. Read data for Exploratory Data Analysis Course Project 1. 
## 4. Set the data up for the first plot, 
## 5. Create the plot and save it to a .png.

######################################################################
## Make sure that you have copied the path to the                   ##
## data files to the clipboard before starting the script!          ##
######################################################################

########################    PART 1    ################################

# Check to see if the R packages needed by the script are installed on
# the computer, if not, install them.
list.of.packages <- c("utils", "data.table", "lubridate")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()
    [,"Package"])]
if (length(new.packages)) {
    install.packages(new.packages)
}

# Load the libraries that the script will use.
library(lubridate)      # dmy_hms function
library(utils)          # readClipboard function
library(data.table)     # fread and other data.table functions

########################    PART 2    ################################

# Set up the working directory to be the directory with the unzipped
# date file.  Assumes that the path to the directory has already been
# copied to the clipboard.
setwd(readClipboard())

########################    PART 3    ################################

# Check to see what form the data exists in, and use the most effienct  
# method to get it into theworking space -- if it isn't already there.
# Uses fread function which won't unzip data, but fread is so much faster 
# than the alternatives it makes sense to have to use the unzip function
# to unzip the data from the zipped file the first time.
if (!exists("power.consumption") && file.exists("power.consumption.rda")) {
    load("power.consumption.rda")
}   else { 
    if (!file.exists("power.consumption.rda")) {
        if (!file.exists("household_power_consumption.txt")) {
            if (!file.exists("household power consumption.zip")) {
                download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                    destfile = "household power consumption.zip")
            }
            unzip("household power consumption.zip")
        }
        power.consumption <- fread("household_power_consumption.txt", header = TRUE, 
            sep = ";", na.strings = "?")
        save(power.consumption, file = "power.consumption.rda")
    }
}

########################    PART 4    ################################

# Subset the data we want, and get the dates and times set up so that
# we can use them.
setkey(power.consumption, Date)     # Setting key here greatly speeds up next statement
specific.days.power.consumption <- power.consumption[c("1/2/2007", "2/2/2007")]
setnames(specific.days.power.consumption, "Time", "DateTime")
specific.days.power.consumption[, DateTime := paste(Date, DateTime, sep = " ")]
specific.days.power.consumption[, DateTime := dmy_hms(specific.days.power.consumption$DateTime)]

# Setting the keys here results in a very slight performance improvemnt.
setkey(specific.days.power.consumption, Date, DateTime)

########################    PART 5    ################################

# Plot and save to working directory the plot for Global Active Power 
# by date and time
plot(specific.days.power.consumption$DateTime, specific.days.power.consumption$Global_active_power,
    type = "l", 
    xlab = "", 
    ylab = "Global Active Power (kilowatts)")
dev.copy(png, 
    file = "plot2.png", 
    height = 480, 
    width = 480)
dev.off()