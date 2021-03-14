#This script reads in a json file of nearby star data and then
#aggregates the data into the number of counts for each class
#of star in the data (ie. star spectral class counts)

#Set working directory and add libraries.
setwd("~/Documents/stardata")
library("rjson")
library("dplyr")

#Read in star data from json data file.
result <- fromJSON(file="stars.json")

#Read in the first star data object into a data frame.
asFrame <- as.data.frame(result[[1]])

#Go through all the other star data objects, replace json nulls
#with R 'NAs' so that they're easier to work with.  Also add
#each star object record to the data frame.
for (var in 2:length(result)){
  if (is.null(result[[var]]$`ABS MAG`)){
    result[[var]]$`ABS MAG` <- NA
  }
  
  row <- as.data.frame(result[[var]])  
  asFrame<-rbind(asFrame,row)
}

#Convert some columns to character vectors as needed.
asFrame$PROPER.NAME <- as.character(asFrame$PROPER.NAME)
asFrame$GREEK.LETTER.NAME <- as.character(asFrame$GREEK.LETTER.NAME)
asFrame$CLASS <- as.character(asFrame$CLASS)
asFrame$REMARKS <- as.character(asFrame$REMARKS)

#Star class character vector
star_class <- c("O","B","A","F","G","K","M","W")

#Create a blank data frame to contain the different star classes along with
#the number of times each star class occurred.
star_class_counts <- data.frame(StarClass=character(), StarClassCount=numeric())
i=1 #counter

#Convert star class and class count columns to character and numeric, respectively.
star_class_counts$StarClass <- as.character(star_class_counts$StarClass)
star_class_counts$StarClassCount <- as.numeric(star_class_counts$StarClassCount)

#Loop to find the number of instances of each star spectral class.
for (class in star_class){
  #Create a logical vector to indicate which star records are of a particular spectral class.
  class_found <- grepl(paste0("^",class,"."), asFrame$CLASS)  
  #Count the number of records that are of the current spectral class
  counts <- length(which(class_found==TRUE))
  
  #Add the star class and counts for that class to the table.
  star_class_counts[i,1] <- class
  star_class_counts[i,2] <- counts
  i <- i+1  #increment counter
}
