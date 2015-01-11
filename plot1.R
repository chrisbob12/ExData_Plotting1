## this section downloads the data files from the web source
## unzips the data file and puts it in a subfolder called "NEI data"

## check to see if data folder has been created
if(!file.exists("NEI data")){
  dir.create("NEI data")
}

URL <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(URL, ".\\NEI data\\eleccons.zip")
unzip(".\\NEI data\\eleccons.zip",exdir=".\\NEI data")

## this line makes a data table from the donwload
electric1 <- read.table(".\\NEI data\\household_power_consumption.txt", sep=";", quote="\"",header=TRUE, stringsAsFactors=FALSE)

## dplyr() is used to do some of the data tidying
## if you have this package installed already, comment out the next line
install.packages("dplyr")

library(dplyr)

## reformat the dates
electric2 <- mutate(electric1,Date = as.Date(Date,"%d/%m/%Y"))
electric2 <- filter(electric2, Date == "2007-02-01" | Date == "2007-02-02")

## we can lose the full data set and speed up operations
rm(electric1)

electric3 <- mutate(electric2, Global_active_power = as.numeric(Global_active_power))
rm(electric2)

electric4 <- mutate(electric3, datetime=as.POSIXct(paste(Date,Time), format="%Y-%m-%d %H:%M:%S"))
electric4 <- mutate(electric4, Sub_metering_1=as.numeric(Sub_metering_1))
electric4 <- mutate(electric4, Sub_metering_2=as.numeric(Sub_metering_2))
electric4 <- mutate(electric4, Sub_metering_3=as.numeric(Sub_metering_3))

## Plot 1
png("plot1.png", width=480, height=480)
hist(electric3$Global_active_power, breaks = 12, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()
