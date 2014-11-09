## check to see if data folder has been created

if(!file.exists("power")){
  dir.create("power")
}

## if no folder then download source file to data folder & unzip
URL <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(URL, ".\\power\\power.zip")
unzip(".\\power\\power.zip",exdir=".\\power")

##
electric1 <- read.table(".\\power\\household_power_consumption.txt", sep=";", quote="\"",header=TRUE, stringsAsFactors=FALSE)

## this script uses dplyr() to do some of the data tidying,
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

## Plot 1 needs Global power as numeric
hist(electric3$Global_active_power, breaks = 12, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")

## Plot 2 needs date&time combining (into datetime in this case)
with(electric4, plot(datetime,Global_active_power,type = "l", ylab = "Global Active Power (kilowatts)"))

## Plot 3
png("plot3.png", width=480, height=480)
with(electric4, plot(datetime, Sub_metering_1, type ="l", xlab = "", ylab = "Energy sub metering"))
with(electric4,points(datetime,Sub_metering_2,type="l",col = "red"))
with(electric4,points(datetime,Sub_metering_3,type="l",col = "blue"))
legend("topright", lwd=1, col = c("black","red","blue"), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
dev.off()
