## Capital bikeshare data science project
dateTime <- commandArgs(trailingOnly = TRUE) # passed in as command line argument from operating system

lapply(.packages(all.available = TRUE), function(xx) library(xx,character.only = TRUE))

setwd("/home/ec2-user/r_scripts/data")

## Download XML data and transform to data table
fileUrl <- "http://www.capitalbikeshare.com/data/stations/bikeStations.xml"
library(XML)
parse <- xmlTreeParse(fileUrl,useInternal=T)
rootNode <- xmlRoot(parse)  
dataprep1 <- (rootNode)
dataprep2 <- xmlSApply(dataprep1,function(x) xmlSApply(x,xmlValue))
data <- data.frame(t(dataprep2),row.names=NULL)

## Convert Unix stamp to character, remove last three digits, convert to numeric and render to date
data[,15] <- as.character(data[,15])
class(data[,15])
     
for(i in data[,15]) {
  data$date <- substr(data[,15], 1, 10)
}

data[,16] <- as.numeric(data[,16])
class(data[,16])
  
data[,16] <- as.POSIXct(data[,16],origin="1970-01-01")

## Compute total of bikes/docks and percentage of each

data[,13] <- as.numeric(data[,13])
data[,14] <- as.numeric(data[,14])                                            
class(data[,14])

data$total <- data$nbBikes + data$nbEmptyDocks

data$percentBikes <- data$nbBikes / data$total

data$percentDocks <- data$nbEmptyDocks / data$total

## Put in weekdays and round times to half-hour
data$day <- weekdays(as.Date(data$date))

data$halfhour <- as.POSIXlt(round(as.double(data$date)/(30*60))*(30*60),origin="1970-01-01")

as.character(format(data$halfhour,"%H:%M"))

data$hour <- as.POSIXlt(round(as.double(data$date)/(60*60))*(60*60),origin="1970-01-01")

as.character(format(data$hour,"%H:%M"))


## Save files for later aggregation
## individual CSV for this data pull
write.csv(data,file=paste(dateTime, ".csv", sep=""))
## append to master CSV file
write.table(data, file="aggData/dataStarting7-21-2014.csv", sep=",", col.names=FALSE, append=TRUE)
