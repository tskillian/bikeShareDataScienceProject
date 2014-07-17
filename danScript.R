## Capital bikeshare data science project

lapply(.packages(all.available = TRUE), function(xx) library(xx,character.only = TRUE))

setwd("C:/Users/Dan/Dropbox/personal/Coursera/data science certificate/data science project")

## Download XML data and transform to data table

fileUrl <- "http://www.capitalbikeshare.com/data/stations/bikeStations.xml"
parse <- xmlTreeParse(fileUrl,useInternal=T)
rootNode <- xmlRoot(parse)  
dataprep1 <- (rootNode)
dataprep2 <- xmlSApply(dataprep1,function(x) xmlSApply(x,xmlValue))
systemdata8June7.30pm <- data.frame(t(dataprep2),row.names=NULL)

## Convert Unix stamp to character, remove last three digits, convert to numeric and render to date
systemdata8June7.30pm[,15] <- as.character(systemdata8June7.30pm[,15])
class(systemdata8June7.30pm[,15])
     
for(i in systemdata8June7.30pm[,15]) {
  systemdata8June7.30pm$date <- substr(systemdata8June7.30pm[,15], 1, 10)
}

systemdata8June7.30pm[,16] <- as.numeric(systemdata8June7.30pm[,16])
class(systemdata8June7.30pm[,16])
  
systemdata8June7.30pm[,16] <- as.POSIXct(systemdata8June7.30pm[,16],origin="1970-01-01")

## Compute total of bikes/docks and percentage of each

systemdata8June7.30pm[,13] <- as.numeric(systemdata8June7.30pm[,13])
systemdata8June7.30pm[,14] <- as.numeric(systemdata8June7.30pm[,14])                                            
class(systemdata8June7.30pm[,14])

systemdata8June7.30pm$total <- systemdata8June7.30pm$nbBikes + systemdata8June7.30pm$nbEmptyDocks

systemdata8June7.30pm$percentBikes <- systemdata8June7.30pm$nbBikes / systemdata8June7.30pm$total

systemdata8June7.30pm$percentDocks <- systemdata8June7.30pm$nbEmptyDocks / systemdata8June7.30pm$total

## Save file for later aggregation
write.csv(systemdata8June7.30pm,file="systemdata 8 June 2014 7.30pm.csv")