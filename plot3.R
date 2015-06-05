
## The script is divided into three sections, 
    # section 1 downloads and unzips the file
    # section 2 reads the data into R and tidies the data
    # section 3 Creates the plot in the png device
## Sections 1 and 2 are the same in all four scripts and if the work directory 
## has not been changed  sections 1 and 2 need only be completed once

###########################################################################################################
    ## SECTION 1
## the following code checks if the required data is in the working directory and
## downloads and unzips the files if neccessary
## please note it works fine on my windows vista computer but may not work on other systems
## in which case the file will need to be downloaded and unzipped manualy 
## the url for the zip file is

https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip



## download and unzip file to working directory if not already there
if(!file.exists("exdata_data_household_power_consumption.zip")){
    download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                  "exdata_data_household_power_consumption.zip",mode="wb")
    unzip("exdata_data_household_power_consumption.zip",
          exdir = "exdata_data_household_power_consumption")
}

###########################################################################################################
    ## SECTION 2
## r packages "sqldf" and "lubridate" are used to read and tidy the data 
##  and will need to be installed if not already installed on your system

install.packages("sqldf")

install.packages("lubridate")

## read data into r (install sqldf package if neccessary) and create tidy data 


library(sqldf)

data <- read.csv.sql("exdata_data_household_power_consumption/household_power_consumption.txt",header=TRUE,sep=";", 
                     sql = "select * from file where Date in ('1/2/2007', '2/2/2007')")  

## add datetime variable converted to POSIXct format with lubridate (install lubridate package if neccessary)
library(lubridate)

data<-within(data, datetime <- paste(data[,1], data[,2], sep=' '))
data$datetime<-dmy_hms(data$datetime)
data<-data[,3:10]

#################################################################################################################
    ## SECTION 3
## create plot3

png("plot3.png",height=480,width=480)
par(mfcol=c(1,1))

plot(data$datetime,data$Sub_metering_1,type="s",xlab="", ylab="Energy Sub Metering",col="black")
points(data$datetime,data$Sub_metering_2,type="s",col="red")
points(data$datetime,data$Sub_metering_3,type="s",col="blue")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1,1), col=c("black","red","blue"), cex=0.8, y.intersp=0.8, xjust=1)

dev.off()