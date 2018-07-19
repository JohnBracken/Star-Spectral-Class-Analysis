#Analysis of stars near the sun from the HYG star database archive.
#This data was found at http://www.astronexus.com/hyg

#Set working directory.
directory <- "C:/Users/310084562/My Documents/Star analysis"
setwd(directory)


#Load the necessary libraries
library(dplyr)
library(ggplot2)
library(ggfortify)
library(extrafont)
loadfonts(device = "win")
library(caret)
library(e1071)

#Read in the star data.
star_data <- read.csv("hygdata_v3.csv", header = TRUE,na.strings=c(""," ","NA"))

#Convert star ID labels to characters from factors.
star_data$gl <- as.character(star_data$gl)
star_data$bf <- as.character(star_data$bf)
star_data$proper <- as.character(star_data$proper)
star_data$bayer <- as.character(star_data$bayer)
star_data$flam <- as.character(star_data$flam)
star_data$base <- as.character(star_data$base)
star_data$var <- as.character(star_data$var)

#Values equal to 100000 mean that the distance of the star
#from the sun is uncertain.  Convert these to NAs.
star_data$dist <- na_if(star_data$dist,100000)

#Convert distance values from parsecs to light years.
star_data$dist <- star_data$dist*3.26

#Find indices of any given column that contain NAs.  This
#is not needed as part of the main script, but just used
#as a check for each column.  Therefore, it's commented out
#here.
#which(is.na(star_data$dist))

#List of numeric or integer columns with NAs
#  1.  hip
#  2.  hd
#  3.  hr
#  4.  dist
#  5.  ci
#  6.  var_min
#  7.  var_max


#Add a column to the data that only shows the first
#Letter of the spectral class for each star.  Make sure all class
#letters are upper case and that the column is a factor variable.
star_data <- star_data %>% mutate(spect_short = substr(star_data$spect,1,1))
star_data$spect_short <- toupper(star_data$spect_short)
star_data$spect_short[which(star_data$spect_short=="(")] <- "G"
star_data$spect_short <- as.factor(star_data$spect_short)


#Create a smaller data frame of only stars that have proper names.
named_stars <- star_data %>% filter(star_data$proper!= "")

#Reorder the named stars in order of decreasing luminosity.
named_stars <- arrange(named_stars, desc(lum))


#Get the number of rows in the data frame of stars with proper names.
nrow_named_stars <- nrow(named_stars)

#Drop unused factor levels in factor columns of the named_stars data frame.
named_stars$con <- droplevels(named_stars$con)
named_stars$spect <- droplevels(named_stars$spect)
named_stars$spect_short <- droplevels(named_stars$spect_short)

#Print out the stars that have the largest and smallest luminosities.
cat("The star with the largest luminosity in the HYG data is: ", 
    named_stars$proper[1],"\n")
cat("This star has a luminosity",named_stars$lum[1], 
    "times stronger than our sun according to HYG data.\n\n")

cat("The star with the smallest luminosity in the HYG data is: ", 
    named_stars$proper[nrow_named_stars],"\n")
cat("This star has a luminosity of",named_stars$lum[nrow_named_stars], 
    "times that of our sun according to the HYG data.\n\n")

#Reorder the named stars in order of increasing distance from the sun.
named_stars <- arrange(named_stars, dist)

#Get the distance of the star furthest from the sun in the named stars,
#along with the row index of this star.
max_dist <- max(named_stars$dist, na.rm=T)
max_index <- which(named_stars$dist == max_dist)

#Get the distance of the star closest to the sun in the named stars,
#along with the row index of this star.
min_dist <- min(named_stars$dist[named_stars$dist > 0], na.rm=T)
min_index <- which(named_stars$dist == min_dist)

#Print out the stars closest to and farthest from the sun.
cat("The star closest to the sun is: ", named_stars$proper[min_index],"\n")
cat("This star is",named_stars$dist[min_index],
    "light years from our sun according to the HYG data.\n\n")

#Print out the stars closest to and farthest from the sun.
cat("The star farthest from our sun is: ",
    named_stars$proper[max_index],"\n")
cat("This star is",named_stars$dist[max_index],
    "light years from our sun within the proper-named stars in the HYG data.\n\n")

#Summarize the number of counts of each star class in a data frame.
spect_summary <- as.data.frame(table(named_stars$spect_short))
spect_summary <- arrange(spect_summary,desc(Freq))
colnames(spect_summary) <- c("Spectral_Class","Counts")

#Create and print a bar plot of the number of counts of each spectral class
#letter in the star data with proper names.
spect_plot <- ggplot(data=spect_summary, aes(reorder(Spectral_Class,-Counts),
Counts), na.rm=T) + geom_bar(stat="identity", col="orangered1", size=1.5, fill = 'gold') +
labs(title = "Star Spectral Class Counts",x = "Spectral Class",
y= "Counts") + theme(text = element_text(size=18)) +
theme(panel.background = element_rect(fill = "dodgerblue4",
                                    colour = "dodgerblue4",
                                    size = 1, linetype = "solid"),
    panel.grid.major = element_line(size = 1, linetype = 'solid',
                                    colour = "khaki3"), 
    panel.grid.minor = element_line(size = 1, linetype = 'solid',
                                    colour = "khaki3")
  )
print(spect_plot)


#Regression analysis for different variables.
#First, compare absolute and apparent magnitude, to see if there
#is a relationship between them.  

#Take out the sun for this analysis, since it is by far the brighest
#star in the sky from the perspective of earth and could distort the
#brightness comparisons of other stars.
named_stars_nosun <-named_stars[-1,]

#Do a linear regression model to examine the relationship
#between absolute and apparent star magnitude.
mag_fit <- lm(absmag ~ mag , data=named_stars_nosun)
print(summary(mag_fit))

#From the fit summary, the correlation is weak and tenuous at best.  I
#don't see any strong relationship between abslolute and apparent 
#magnitude. Anyway, here is a plot of fit and also the corresponding
#diagnostic plots.  These plots show a poor fit.
mag_fit_plot <- ggplot(named_stars_nosun, aes(x=mag, y=absmag),na.rm=T)+
  geom_point()+
  labs(title="Correlation Plot of Absolute vs Apparent Star Magnitude",
       x = "Apparent Magnitude", y="Absolute Magnitude") +
  theme(panel.background = element_rect(fill = "darkolivegreen1",
                                        colour = "hotpink",
                                        size = 1, linetype = "solid"),
        panel.grid.major = element_line(size = 1, linetype = 'solid',
                                        colour = "midnightblue"), 
        panel.grid.minor = element_line(size = 1, linetype = 'solid',
                                        colour = "midnightblue")
  )+
  theme(text = element_text(size=18))+
  geom_smooth(method=lm, se=TRUE, size=2, color = "firebrick1")
print(mag_fit_plot)


#Residuals plot.
diagnostic_plot <- autoplot(mag_fit, label.size = 3, colour='purple4',
                            smooth.colour = 'black',na.rm=T)+
  theme(text = element_text(size=14,family="serif")) +
  theme(panel.background = element_rect(fill = "lightskyblue2",
                                        colour = "lightskyblue2"))
print(diagnostic_plot)


#Instead, let's see if spectral class depends on other variables.  Let's develop
#a prediction model for spectral class to determine which variables are most important,
#based on random forests.
#Since the variable we're trying to predict is a categorical variable with multiple 
#categories, let's try doing a random forest model.

#Create training and test data sets from the star data.
#To simplify the model, I have removed extremely rare star classes.
star_model_data <- star_data[which(star_data$spect_short !='P'),]
star_model_data <- star_model_data[which(star_model_data$spect_short !='D'),]
star_model_data <- star_model_data[which(star_model_data$spect_short !='N'),]
star_model_data <- star_model_data[which(star_model_data$spect_short !='W'),]
star_model_data <- star_model_data[which(star_model_data$spect_short !='C'),]
star_model_data <- star_model_data[which(star_model_data$spect_short !='R'),]
star_model_data <- star_model_data[which(star_model_data$spect_short !='S'),]


#Remove unsured factor levels and any NAs that are present for the variables of 
#interest.
star_model_data$spect_short <- droplevels(star_model_data$spect_short)
star_model_data <- star_model_data[!is.na(star_model_data$ci),]

#Create the training and test datasets (70/30 split)
inTrain <- createDataPartition(y=star_model_data$spect_short, p=0.7, list=FALSE)
star_train<- star_model_data[inTrain,]
star_test <- star_model_data[-inTrain,]


#Use cross validation to remove bias.  
train_control <- trainControl(method="cv", number =5)

#Train a gradient boosting model on the star data. I orginally attempted to do this
#with four predictors: radial velocity, absolute magnitude, color index and luminosity.
#It turns out that, based on variable importance rankings, color index is actually the
#only useful predictor of spectral class. 
model_gbm <- train(spect_short~rv+absmag+ci+lum,
                  data=star_train, trControl = train_control,
                  method = "gbm")

#Print the model summary
print(model_gbm)
print(model_gbm$finalModel)

#Generate and plot variable importance rankings.  This code was only used when I had
#more than one predictor variable.
plot_var <- summary(model_gbm)
print(plot_var)

#Use the model to predict the spectral class on the test data.
prediction_gbm <- predict(model_gbm, star_test)

#Confusion matrix comparing the predictions with the actual spectral classes in the
#test data.
confusionMatrix(star_test$spect_short, prediction_gbm)
