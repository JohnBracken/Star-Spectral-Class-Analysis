The following code is an analysis of star data from the HYG star database
archive.  This data was found at http://www.astronexus.com/hyg.

In the analysis a bar plot of the number of counts of each star spectral class
letter is generated from a subset of starts that actually have proper names.
From this subset of data, the stars closest to and farthest from our sun are
determined.  The stars with the largest and weakest luminosity are also named.
A linear correlation model is also performed to see if there is a relationship
between absolute and apparent star magnitude (brightness).  There was no evidence
of a strong relationship between these two variables.

A random forests prediction model was also generated to predict the spectral class
of stars based on a few predictors.  The initial predictors chosen were 
radial velocity, absolute magnitude, color index and luminosity.  The model summary
and variable importance analysis showed that only color index was a fairly reliable 
predictor of spectral class, so the model was redone with only this predictor, 
which actually improved the accuracy slightly (around 73%).  The prediction model 
was then used to predict spectral class on some test data and delivered a result with
around this accuracy.  None of the other potentially relevant predictor variables 
seemed to really help out here in a prediction.  

