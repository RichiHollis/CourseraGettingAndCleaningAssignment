# CodeBook

---

## Introduction

This code book describes 

1. The raw data,
2. Transformations applied to the raw data,
3. Resultant tidy data.

---

## The Raw Data

The raw data can be found from the following link:

    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

See instructions in the README.md file for unzipping.

This data sample contains the results of a series of experiments which tracked the movements of
a cell phone during one of six activities:

1. Walking
2. Walking Upstairs
3. Walking Downstairs
4. Sitting
5. Standing
6. Laying

The data were collected using a Samsung Galaxy S II smartphone attached to the waist of
each participant (60 total).  Using its embedded accelerometer and gyroscope, 3-axial linear
acceleration and 3-axial angular velocity were captured at a constant rate of 50Hz.

Additional details can be found at:

    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
    
The dataset is divided into two samples: a training sample (70%) and a testing sample (30%).
For the purposes of this analysis, these are recombined.



---

## The Cleaning Process Script

### "Features" of the data

"Features" are the data types stored in this analysis.  Each "feature" is tagged with a number from
1:561, with names stored in a header file: "features.txt".

The first step in the cleaning process is to identify the needed features from the features.txt file.
These are those columns with summary information for the mean and standard deviation, tagged as
"-mean()-" and "-std()-" respectively.  Required row numbers are stored (see table at end of document) in the R-script as:

    summary_required_mean<-grep("mean\\(\\)",summary_names_df[,2]);
    summary_required_std<-grep("std\\(\\)",summary_names_df[,2]);
    summary_required<-c(summary_required_mean,summary_required_std);

Next, the names of the variables are renamed to be a little more human readable with the nicify function:

    summary_names<-lapply(summary_names_df[,2],nicify);

### Note on Nicify

The function nicify is specific to this dataset, using the raw data as a guide and 
rebuilding a human-readable name for each column.

The names use basic structure of: Human.ReadableFormat.LikeThis

---

## Loading and Tidying Raw Data 

The data are loaded into a data frame as "test" or "train".  There are three files which are merged to
form the dataframe:

1. Subject

    Person who was being measured labelled from 1:30

    e.g. subject_train.txt

2. Activity

    Activity being performed (1:6, described above)

    e.g. y_train.txt

3. Summary

    Results summary - features

    e.g. X_train.txt


There are 7352(2947) rows of data in the train(test) samples.  The function "build_data_frame" combines this information (cbind) and retains all required columns (from the features noted above).



## Final Summary

The tidy_data.txt file represents the final tidy data set, which is a summary of all the measurements in the data sample.  This is formed by aggregating information as a function of activity and subject.

In the tidy data frame both these are made to be factors.  The summaries are formed by:

    summary_by_activity<-aggregate(total_df[,3:ncol(total_df)],by=list(total_df$Activity.ID,total_df$Subject.ID),FUN=mean);
    colnames(summary_by_activity)[1]<-"Activity";
    colnames(summary_by_activity)[2]<-"Subject.ID";

Where the final two lines change the names into a human readable/understandable format.  Summarization/aggregation of the data occurs "by" Activity and Subject.ID in the data frame for each row in the column, excluding the header rows.  The summary in this case is for the function (FUN) mean.


## Table of all variables

"Original Name" is the name in the raw data, "Nicified Name" is the name in the tidy data output here,
The "Variable Used" column indicate which variables made it into the tidy data set.

Note: variables not needed in the data sample are not fully "nicified."

Used variables have the following meaning:

* "t" -> "Time" variables are captured at a constant rate.
* "f" -> "Freq" variables are fast-fourier transform signals

The accelerometer measurements were split into 2 components, using a low frequency filter:

* BodyAcc -> body linear acceleration (split into cartesian directions: x,y,z)
* GravityAcc -> gravitational acceleration (split into cartesian directions: x,y,z)
* BodyAccJerk - time derivative of body linear acceleration (split into cartesian directions: x,y,z)
* BodyAccMag -> body linear acceleration (magnitude)
* GravityAccMag -> gravitational acceleration (magnitude)
* BodyAccJerkMag -> time derivative of body linear acceleration (magnitude)

The gyroscope sensor measures the angular velocity components:

* BodyGyro -> body angular velocity (split into cartesian directions: x,y,z)
* BodyGyroJerk - time derivative of body angular velocity (split into cartesian directions: x,y,z)
* BodyGyroMag -> body angular velocity (magnitude)
* BodyGyroJerkMag - time derivative of body angular velocity (magnitude)

Summary types are labeled as:

* "-mean()-" -> "Mean" - the mean
* "-std()-" -> "StDev" - the standard deviation
* "X,Y,Z" denote the direction.


| Variable Number | Original Name | Variable Used | Nicified Name |
|---|---|---|---|
|  1|                       tBodyAcc-mean()-X|     YES|                     Time.BodyAcc.Mean.X|   
|  2|                       tBodyAcc-mean()-Y|     YES|                     Time.BodyAcc.Mean.Y|   
|  3|                       tBodyAcc-mean()-Z|     YES|                     Time.BodyAcc.Mean.Z|   
|  4|                        tBodyAcc-std()-X|     YES|                    Time.BodyAcc.StDev.X|   
|  5|                        tBodyAcc-std()-Y|     YES|                    Time.BodyAcc.StDev.Y|   
|  6|                        tBodyAcc-std()-Z|     YES|                    Time.BodyAcc.StDev.Z|   
|  7|                        tBodyAcc-mad()-X|        |                        Tbodyacc-mad()-x|   
|  8|                        tBodyAcc-mad()-Y|        |                        Tbodyacc-mad()-y|   
|  9|                        tBodyAcc-mad()-Z|        |                        Tbodyacc-mad()-z|   
| 10|                        tBodyAcc-max()-X|        |                        Tbodyacc-max()-x|   
| 11|                        tBodyAcc-max()-Y|        |                        Tbodyacc-max()-y|   
| 12|                        tBodyAcc-max()-Z|        |                        Tbodyacc-max()-z|   
| 13|                        tBodyAcc-min()-X|        |                        Tbodyacc-min()-x|   
| 14|                        tBodyAcc-min()-Y|        |                        Tbodyacc-min()-y|   
| 15|                        tBodyAcc-min()-Z|        |                        Tbodyacc-min()-z|   
| 16|                          tBodyAcc-sma()|        |                          Tbodyacc-sma()|   
| 17|                     tBodyAcc-energy()-X|        |                     Tbodyacc-energy()-x|   
| 18|                     tBodyAcc-energy()-Y|        |                     Tbodyacc-energy()-y|   
| 19|                     tBodyAcc-energy()-Z|        |                     Tbodyacc-energy()-z|   
| 20|                        tBodyAcc-iqr()-X|        |                        Tbodyacc-iqr()-x|   
| 21|                        tBodyAcc-iqr()-Y|        |                        Tbodyacc-iqr()-y|   
| 22|                        tBodyAcc-iqr()-Z|        |                        Tbodyacc-iqr()-z|   
| 23|                    tBodyAcc-entropy()-X|        |                    Tbodyacc-entropy()-x|   
| 24|                    tBodyAcc-entropy()-Y|        |                    Tbodyacc-entropy()-y|   
| 25|                    tBodyAcc-entropy()-Z|        |                    Tbodyacc-entropy()-z|   
| 26|                  tBodyAcc-arCoeff()-X,1|        |                  Tbodyacc-arcoeff()-x,1|   
| 27|                  tBodyAcc-arCoeff()-X,2|        |                  Tbodyacc-arcoeff()-x,2|   
| 28|                  tBodyAcc-arCoeff()-X,3|        |                  Tbodyacc-arcoeff()-x,3|   
| 29|                  tBodyAcc-arCoeff()-X,4|        |                  Tbodyacc-arcoeff()-x,4|   
| 30|                  tBodyAcc-arCoeff()-Y,1|        |                  Tbodyacc-arcoeff()-y,1|   
| 31|                  tBodyAcc-arCoeff()-Y,2|        |                  Tbodyacc-arcoeff()-y,2|   
| 32|                  tBodyAcc-arCoeff()-Y,3|        |                  Tbodyacc-arcoeff()-y,3|   
| 33|                  tBodyAcc-arCoeff()-Y,4|        |                  Tbodyacc-arcoeff()-y,4|   
| 34|                  tBodyAcc-arCoeff()-Z,1|        |                  Tbodyacc-arcoeff()-z,1|   
| 35|                  tBodyAcc-arCoeff()-Z,2|        |                  Tbodyacc-arcoeff()-z,2|   
| 36|                  tBodyAcc-arCoeff()-Z,3|        |                  Tbodyacc-arcoeff()-z,3|   
| 37|                  tBodyAcc-arCoeff()-Z,4|        |                  Tbodyacc-arcoeff()-z,4|   
| 38|              tBodyAcc-correlation()-X,Y|        |              Tbodyacc-correlation()-x,y|   
| 39|              tBodyAcc-correlation()-X,Z|        |              Tbodyacc-correlation()-x,z|   
| 40|              tBodyAcc-correlation()-Y,Z|        |              Tbodyacc-correlation()-y,z|   
| 41|                    tGravityAcc-mean()-X|     YES|                  Time.GravityAcc.Mean.X|   
| 42|                    tGravityAcc-mean()-Y|     YES|                  Time.GravityAcc.Mean.Y|   
| 43|                    tGravityAcc-mean()-Z|     YES|                  Time.GravityAcc.Mean.Z|   
| 44|                     tGravityAcc-std()-X|     YES|                 Time.GravityAcc.StDev.X|   
| 45|                     tGravityAcc-std()-Y|     YES|                 Time.GravityAcc.StDev.Y|   
| 46|                     tGravityAcc-std()-Z|     YES|                 Time.GravityAcc.StDev.Z|   
| 47|                     tGravityAcc-mad()-X|        |                     Tgravityacc-mad()-x|   
| 48|                     tGravityAcc-mad()-Y|        |                     Tgravityacc-mad()-y|   
| 49|                     tGravityAcc-mad()-Z|        |                     Tgravityacc-mad()-z|   
| 50|                     tGravityAcc-max()-X|        |                     Tgravityacc-max()-x|   
| 51|                     tGravityAcc-max()-Y|        |                     Tgravityacc-max()-y|   
| 52|                     tGravityAcc-max()-Z|        |                     Tgravityacc-max()-z|   
| 53|                     tGravityAcc-min()-X|        |                     Tgravityacc-min()-x|   
| 54|                     tGravityAcc-min()-Y|        |                     Tgravityacc-min()-y|   
| 55|                     tGravityAcc-min()-Z|        |                     Tgravityacc-min()-z|   
| 56|                       tGravityAcc-sma()|        |                       Tgravityacc-sma()|   
| 57|                  tGravityAcc-energy()-X|        |                  Tgravityacc-energy()-x|   
| 58|                  tGravityAcc-energy()-Y|        |                  Tgravityacc-energy()-y|   
| 59|                  tGravityAcc-energy()-Z|        |                  Tgravityacc-energy()-z|   
| 60|                     tGravityAcc-iqr()-X|        |                     Tgravityacc-iqr()-x|   
| 61|                     tGravityAcc-iqr()-Y|        |                     Tgravityacc-iqr()-y|   
| 62|                     tGravityAcc-iqr()-Z|        |                     Tgravityacc-iqr()-z|   
| 63|                 tGravityAcc-entropy()-X|        |                 Tgravityacc-entropy()-x|   
| 64|                 tGravityAcc-entropy()-Y|        |                 Tgravityacc-entropy()-y|   
| 65|                 tGravityAcc-entropy()-Z|        |                 Tgravityacc-entropy()-z|   
| 66|               tGravityAcc-arCoeff()-X,1|        |               Tgravityacc-arcoeff()-x,1|   
| 67|               tGravityAcc-arCoeff()-X,2|        |               Tgravityacc-arcoeff()-x,2|   
| 68|               tGravityAcc-arCoeff()-X,3|        |               Tgravityacc-arcoeff()-x,3|   
| 69|               tGravityAcc-arCoeff()-X,4|        |               Tgravityacc-arcoeff()-x,4|   
| 70|               tGravityAcc-arCoeff()-Y,1|        |               Tgravityacc-arcoeff()-y,1|   
| 71|               tGravityAcc-arCoeff()-Y,2|        |               Tgravityacc-arcoeff()-y,2|   
| 72|               tGravityAcc-arCoeff()-Y,3|        |               Tgravityacc-arcoeff()-y,3|   
| 73|               tGravityAcc-arCoeff()-Y,4|        |               Tgravityacc-arcoeff()-y,4|   
| 74|               tGravityAcc-arCoeff()-Z,1|        |               Tgravityacc-arcoeff()-z,1|   
| 75|               tGravityAcc-arCoeff()-Z,2|        |               Tgravityacc-arcoeff()-z,2|   
| 76|               tGravityAcc-arCoeff()-Z,3|        |               Tgravityacc-arcoeff()-z,3|   
| 77|               tGravityAcc-arCoeff()-Z,4|        |               Tgravityacc-arcoeff()-z,4|   
| 78|           tGravityAcc-correlation()-X,Y|        |           Tgravityacc-correlation()-x,y|   
| 79|           tGravityAcc-correlation()-X,Z|        |           Tgravityacc-correlation()-x,z|   
| 80|           tGravityAcc-correlation()-Y,Z|        |           Tgravityacc-correlation()-y,z|   
| 81|                   tBodyAccJerk-mean()-X|     YES|                 Time.BodyAccJerk.Mean.X|   
| 82|                   tBodyAccJerk-mean()-Y|     YES|                 Time.BodyAccJerk.Mean.Y|   
| 83|                   tBodyAccJerk-mean()-Z|     YES|                 Time.BodyAccJerk.Mean.Z|   
| 84|                    tBodyAccJerk-std()-X|     YES|                Time.BodyAccJerk.StDev.X|   
| 85|                    tBodyAccJerk-std()-Y|     YES|                Time.BodyAccJerk.StDev.Y|   
| 86|                    tBodyAccJerk-std()-Z|     YES|                Time.BodyAccJerk.StDev.Z|   
| 87|                    tBodyAccJerk-mad()-X|        |                    Tbodyaccjerk-mad()-x|   
| 88|                    tBodyAccJerk-mad()-Y|        |                    Tbodyaccjerk-mad()-y|   
| 89|                    tBodyAccJerk-mad()-Z|        |                    Tbodyaccjerk-mad()-z|   
| 90|                    tBodyAccJerk-max()-X|        |                    Tbodyaccjerk-max()-x|   
| 91|                    tBodyAccJerk-max()-Y|        |                    Tbodyaccjerk-max()-y|   
| 92|                    tBodyAccJerk-max()-Z|        |                    Tbodyaccjerk-max()-z|   
| 93|                    tBodyAccJerk-min()-X|        |                    Tbodyaccjerk-min()-x|   
| 94|                    tBodyAccJerk-min()-Y|        |                    Tbodyaccjerk-min()-y|   
| 95|                    tBodyAccJerk-min()-Z|        |                    Tbodyaccjerk-min()-z|   
| 96|                      tBodyAccJerk-sma()|        |                      Tbodyaccjerk-sma()|   
| 97|                 tBodyAccJerk-energy()-X|        |                 Tbodyaccjerk-energy()-x|   
| 98|                 tBodyAccJerk-energy()-Y|        |                 Tbodyaccjerk-energy()-y|   
| 99|                 tBodyAccJerk-energy()-Z|        |                 Tbodyaccjerk-energy()-z|   
|100|                    tBodyAccJerk-iqr()-X|        |                    Tbodyaccjerk-iqr()-x|   
|101|                    tBodyAccJerk-iqr()-Y|        |                    Tbodyaccjerk-iqr()-y|   
|102|                    tBodyAccJerk-iqr()-Z|        |                    Tbodyaccjerk-iqr()-z|   
|103|                tBodyAccJerk-entropy()-X|        |                Tbodyaccjerk-entropy()-x|   
|104|                tBodyAccJerk-entropy()-Y|        |                Tbodyaccjerk-entropy()-y|   
|105|                tBodyAccJerk-entropy()-Z|        |                Tbodyaccjerk-entropy()-z|   
|106|              tBodyAccJerk-arCoeff()-X,1|        |              Tbodyaccjerk-arcoeff()-x,1|   
|107|              tBodyAccJerk-arCoeff()-X,2|        |              Tbodyaccjerk-arcoeff()-x,2|   
|108|              tBodyAccJerk-arCoeff()-X,3|        |              Tbodyaccjerk-arcoeff()-x,3|   
|109|              tBodyAccJerk-arCoeff()-X,4|        |              Tbodyaccjerk-arcoeff()-x,4|   
|110|              tBodyAccJerk-arCoeff()-Y,1|        |              Tbodyaccjerk-arcoeff()-y,1|   
|111|              tBodyAccJerk-arCoeff()-Y,2|        |              Tbodyaccjerk-arcoeff()-y,2|   
|112|              tBodyAccJerk-arCoeff()-Y,3|        |              Tbodyaccjerk-arcoeff()-y,3|   
|113|              tBodyAccJerk-arCoeff()-Y,4|        |              Tbodyaccjerk-arcoeff()-y,4|   
|114|              tBodyAccJerk-arCoeff()-Z,1|        |              Tbodyaccjerk-arcoeff()-z,1|   
|115|              tBodyAccJerk-arCoeff()-Z,2|        |              Tbodyaccjerk-arcoeff()-z,2|   
|116|              tBodyAccJerk-arCoeff()-Z,3|        |              Tbodyaccjerk-arcoeff()-z,3|   
|117|              tBodyAccJerk-arCoeff()-Z,4|        |              Tbodyaccjerk-arcoeff()-z,4|   
|118|          tBodyAccJerk-correlation()-X,Y|        |          Tbodyaccjerk-correlation()-x,y|   
|119|          tBodyAccJerk-correlation()-X,Z|        |          Tbodyaccjerk-correlation()-x,z|   
|120|          tBodyAccJerk-correlation()-Y,Z|        |          Tbodyaccjerk-correlation()-y,z|   
|121|                      tBodyGyro-mean()-X|     YES|                    Time.BodyGyro.Mean.X|   
|122|                      tBodyGyro-mean()-Y|     YES|                    Time.BodyGyro.Mean.Y|   
|123|                      tBodyGyro-mean()-Z|     YES|                    Time.BodyGyro.Mean.Z|   
|124|                       tBodyGyro-std()-X|     YES|                   Time.BodyGyro.StDev.X|   
|125|                       tBodyGyro-std()-Y|     YES|                   Time.BodyGyro.StDev.Y|   
|126|                       tBodyGyro-std()-Z|     YES|                   Time.BodyGyro.StDev.Z|   
|127|                       tBodyGyro-mad()-X|        |                       Tbodygyro-mad()-x|   
|128|                       tBodyGyro-mad()-Y|        |                       Tbodygyro-mad()-y|   
|129|                       tBodyGyro-mad()-Z|        |                       Tbodygyro-mad()-z|   
|130|                       tBodyGyro-max()-X|        |                       Tbodygyro-max()-x|   
|131|                       tBodyGyro-max()-Y|        |                       Tbodygyro-max()-y|   
|132|                       tBodyGyro-max()-Z|        |                       Tbodygyro-max()-z|   
|133|                       tBodyGyro-min()-X|        |                       Tbodygyro-min()-x|   
|134|                       tBodyGyro-min()-Y|        |                       Tbodygyro-min()-y|   
|135|                       tBodyGyro-min()-Z|        |                       Tbodygyro-min()-z|   
|136|                         tBodyGyro-sma()|        |                         Tbodygyro-sma()|   
|137|                    tBodyGyro-energy()-X|        |                    Tbodygyro-energy()-x|   
|138|                    tBodyGyro-energy()-Y|        |                    Tbodygyro-energy()-y|   
|139|                    tBodyGyro-energy()-Z|        |                    Tbodygyro-energy()-z|   
|140|                       tBodyGyro-iqr()-X|        |                       Tbodygyro-iqr()-x|   
|141|                       tBodyGyro-iqr()-Y|        |                       Tbodygyro-iqr()-y|   
|142|                       tBodyGyro-iqr()-Z|        |                       Tbodygyro-iqr()-z|   
|143|                   tBodyGyro-entropy()-X|        |                   Tbodygyro-entropy()-x|   
|144|                   tBodyGyro-entropy()-Y|        |                   Tbodygyro-entropy()-y|   
|145|                   tBodyGyro-entropy()-Z|        |                   Tbodygyro-entropy()-z|   
|146|                 tBodyGyro-arCoeff()-X,1|        |                 Tbodygyro-arcoeff()-x,1|   
|147|                 tBodyGyro-arCoeff()-X,2|        |                 Tbodygyro-arcoeff()-x,2|   
|148|                 tBodyGyro-arCoeff()-X,3|        |                 Tbodygyro-arcoeff()-x,3|   
|149|                 tBodyGyro-arCoeff()-X,4|        |                 Tbodygyro-arcoeff()-x,4|   
|150|                 tBodyGyro-arCoeff()-Y,1|        |                 Tbodygyro-arcoeff()-y,1|   
|151|                 tBodyGyro-arCoeff()-Y,2|        |                 Tbodygyro-arcoeff()-y,2|   
|152|                 tBodyGyro-arCoeff()-Y,3|        |                 Tbodygyro-arcoeff()-y,3|   
|153|                 tBodyGyro-arCoeff()-Y,4|        |                 Tbodygyro-arcoeff()-y,4|   
|154|                 tBodyGyro-arCoeff()-Z,1|        |                 Tbodygyro-arcoeff()-z,1|   
|155|                 tBodyGyro-arCoeff()-Z,2|        |                 Tbodygyro-arcoeff()-z,2|   
|156|                 tBodyGyro-arCoeff()-Z,3|        |                 Tbodygyro-arcoeff()-z,3|   
|157|                 tBodyGyro-arCoeff()-Z,4|        |                 Tbodygyro-arcoeff()-z,4|   
|158|             tBodyGyro-correlation()-X,Y|        |             Tbodygyro-correlation()-x,y|   
|159|             tBodyGyro-correlation()-X,Z|        |             Tbodygyro-correlation()-x,z|   
|160|             tBodyGyro-correlation()-Y,Z|        |             Tbodygyro-correlation()-y,z|   
|161|                  tBodyGyroJerk-mean()-X|     YES|                Time.BodyGyroJerk.Mean.X|   
|162|                  tBodyGyroJerk-mean()-Y|     YES|                Time.BodyGyroJerk.Mean.Y|   
|163|                  tBodyGyroJerk-mean()-Z|     YES|                Time.BodyGyroJerk.Mean.Z|   
|164|                   tBodyGyroJerk-std()-X|     YES|               Time.BodyGyroJerk.StDev.X|   
|165|                   tBodyGyroJerk-std()-Y|     YES|               Time.BodyGyroJerk.StDev.Y|   
|166|                   tBodyGyroJerk-std()-Z|     YES|               Time.BodyGyroJerk.StDev.Z|   
|167|                   tBodyGyroJerk-mad()-X|        |                   Tbodygyrojerk-mad()-x|   
|168|                   tBodyGyroJerk-mad()-Y|        |                   Tbodygyrojerk-mad()-y|   
|169|                   tBodyGyroJerk-mad()-Z|        |                   Tbodygyrojerk-mad()-z|   
|170|                   tBodyGyroJerk-max()-X|        |                   Tbodygyrojerk-max()-x|   
|171|                   tBodyGyroJerk-max()-Y|        |                   Tbodygyrojerk-max()-y|   
|172|                   tBodyGyroJerk-max()-Z|        |                   Tbodygyrojerk-max()-z|   
|173|                   tBodyGyroJerk-min()-X|        |                   Tbodygyrojerk-min()-x|   
|174|                   tBodyGyroJerk-min()-Y|        |                   Tbodygyrojerk-min()-y|   
|175|                   tBodyGyroJerk-min()-Z|        |                   Tbodygyrojerk-min()-z|   
|176|                     tBodyGyroJerk-sma()|        |                     Tbodygyrojerk-sma()|   
|177|                tBodyGyroJerk-energy()-X|        |                Tbodygyrojerk-energy()-x|   
|178|                tBodyGyroJerk-energy()-Y|        |                Tbodygyrojerk-energy()-y|   
|179|                tBodyGyroJerk-energy()-Z|        |                Tbodygyrojerk-energy()-z|   
|180|                   tBodyGyroJerk-iqr()-X|        |                   Tbodygyrojerk-iqr()-x|   
|181|                   tBodyGyroJerk-iqr()-Y|        |                   Tbodygyrojerk-iqr()-y|   
|182|                   tBodyGyroJerk-iqr()-Z|        |                   Tbodygyrojerk-iqr()-z|   
|183|               tBodyGyroJerk-entropy()-X|        |               Tbodygyrojerk-entropy()-x|   
|184|               tBodyGyroJerk-entropy()-Y|        |               Tbodygyrojerk-entropy()-y|   
|185|               tBodyGyroJerk-entropy()-Z|        |               Tbodygyrojerk-entropy()-z|   
|186|             tBodyGyroJerk-arCoeff()-X,1|        |             Tbodygyrojerk-arcoeff()-x,1|   
|187|             tBodyGyroJerk-arCoeff()-X,2|        |             Tbodygyrojerk-arcoeff()-x,2|   
|188|             tBodyGyroJerk-arCoeff()-X,3|        |             Tbodygyrojerk-arcoeff()-x,3|   
|189|             tBodyGyroJerk-arCoeff()-X,4|        |             Tbodygyrojerk-arcoeff()-x,4|   
|190|             tBodyGyroJerk-arCoeff()-Y,1|        |             Tbodygyrojerk-arcoeff()-y,1|   
|191|             tBodyGyroJerk-arCoeff()-Y,2|        |             Tbodygyrojerk-arcoeff()-y,2|   
|192|             tBodyGyroJerk-arCoeff()-Y,3|        |             Tbodygyrojerk-arcoeff()-y,3|   
|193|             tBodyGyroJerk-arCoeff()-Y,4|        |             Tbodygyrojerk-arcoeff()-y,4|   
|194|             tBodyGyroJerk-arCoeff()-Z,1|        |             Tbodygyrojerk-arcoeff()-z,1|   
|195|             tBodyGyroJerk-arCoeff()-Z,2|        |             Tbodygyrojerk-arcoeff()-z,2|   
|196|             tBodyGyroJerk-arCoeff()-Z,3|        |             Tbodygyrojerk-arcoeff()-z,3|   
|197|             tBodyGyroJerk-arCoeff()-Z,4|        |             Tbodygyrojerk-arcoeff()-z,4|   
|198|         tBodyGyroJerk-correlation()-X,Y|        |         Tbodygyrojerk-correlation()-x,y|   
|199|         tBodyGyroJerk-correlation()-X,Z|        |         Tbodygyrojerk-correlation()-x,z|   
|200|         tBodyGyroJerk-correlation()-Y,Z|        |         Tbodygyrojerk-correlation()-y,z|   
|201|                      tBodyAccMag-mean()|     YES|                    Time.BodyAccMag.Mean|   
|202|                       tBodyAccMag-std()|     YES|                   Time.BodyAccMag.StDev|   
|203|                       tBodyAccMag-mad()|        |                       Tbodyaccmag-mad()|   
|204|                       tBodyAccMag-max()|        |                       Tbodyaccmag-max()|   
|205|                       tBodyAccMag-min()|        |                       Tbodyaccmag-min()|   
|206|                       tBodyAccMag-sma()|        |                       Tbodyaccmag-sma()|   
|207|                    tBodyAccMag-energy()|        |                    Tbodyaccmag-energy()|   
|208|                       tBodyAccMag-iqr()|        |                       Tbodyaccmag-iqr()|   
|209|                   tBodyAccMag-entropy()|        |                   Tbodyaccmag-entropy()|   
|210|                  tBodyAccMag-arCoeff()1|        |                  Tbodyaccmag-arcoeff()1|   
|211|                  tBodyAccMag-arCoeff()2|        |                  Tbodyaccmag-arcoeff()2|   
|212|                  tBodyAccMag-arCoeff()3|        |                  Tbodyaccmag-arcoeff()3|   
|213|                  tBodyAccMag-arCoeff()4|        |                  Tbodyaccmag-arcoeff()4|   
|214|                   tGravityAccMag-mean()|     YES|                 Time.GravityAccMag.Mean|   
|215|                    tGravityAccMag-std()|     YES|                Time.GravityAccMag.StDev|   
|216|                    tGravityAccMag-mad()|        |                    Tgravityaccmag-mad()|   
|217|                    tGravityAccMag-max()|        |                    Tgravityaccmag-max()|   
|218|                    tGravityAccMag-min()|        |                    Tgravityaccmag-min()|   
|219|                    tGravityAccMag-sma()|        |                    Tgravityaccmag-sma()|   
|220|                 tGravityAccMag-energy()|        |                 Tgravityaccmag-energy()|   
|221|                    tGravityAccMag-iqr()|        |                    Tgravityaccmag-iqr()|   
|222|                tGravityAccMag-entropy()|        |                Tgravityaccmag-entropy()|   
|223|               tGravityAccMag-arCoeff()1|        |               Tgravityaccmag-arcoeff()1|   
|224|               tGravityAccMag-arCoeff()2|        |               Tgravityaccmag-arcoeff()2|   
|225|               tGravityAccMag-arCoeff()3|        |               Tgravityaccmag-arcoeff()3|   
|226|               tGravityAccMag-arCoeff()4|        |               Tgravityaccmag-arcoeff()4|   
|227|                  tBodyAccJerkMag-mean()|     YES|                Time.BodyAccJerkMag.Mean|   
|228|                   tBodyAccJerkMag-std()|     YES|               Time.BodyAccJerkMag.StDev|   
|229|                   tBodyAccJerkMag-mad()|        |                   Tbodyaccjerkmag-mad()|   
|230|                   tBodyAccJerkMag-max()|        |                   Tbodyaccjerkmag-max()|   
|231|                   tBodyAccJerkMag-min()|        |                   Tbodyaccjerkmag-min()|   
|232|                   tBodyAccJerkMag-sma()|        |                   Tbodyaccjerkmag-sma()|   
|233|                tBodyAccJerkMag-energy()|        |                Tbodyaccjerkmag-energy()|   
|234|                   tBodyAccJerkMag-iqr()|        |                   Tbodyaccjerkmag-iqr()|   
|235|               tBodyAccJerkMag-entropy()|        |               Tbodyaccjerkmag-entropy()|   
|236|              tBodyAccJerkMag-arCoeff()1|        |              Tbodyaccjerkmag-arcoeff()1|   
|237|              tBodyAccJerkMag-arCoeff()2|        |              Tbodyaccjerkmag-arcoeff()2|   
|238|              tBodyAccJerkMag-arCoeff()3|        |              Tbodyaccjerkmag-arcoeff()3|   
|239|              tBodyAccJerkMag-arCoeff()4|        |              Tbodyaccjerkmag-arcoeff()4|   
|240|                     tBodyGyroMag-mean()|     YES|                   Time.BodyGyroMag.Mean|   
|241|                      tBodyGyroMag-std()|     YES|                  Time.BodyGyroMag.StDev|   
|242|                      tBodyGyroMag-mad()|        |                      Tbodygyromag-mad()|   
|243|                      tBodyGyroMag-max()|        |                      Tbodygyromag-max()|   
|244|                      tBodyGyroMag-min()|        |                      Tbodygyromag-min()|   
|245|                      tBodyGyroMag-sma()|        |                      Tbodygyromag-sma()|   
|246|                   tBodyGyroMag-energy()|        |                   Tbodygyromag-energy()|   
|247|                      tBodyGyroMag-iqr()|        |                      Tbodygyromag-iqr()|   
|248|                  tBodyGyroMag-entropy()|        |                  Tbodygyromag-entropy()|   
|249|                 tBodyGyroMag-arCoeff()1|        |                 Tbodygyromag-arcoeff()1|   
|250|                 tBodyGyroMag-arCoeff()2|        |                 Tbodygyromag-arcoeff()2|   
|251|                 tBodyGyroMag-arCoeff()3|        |                 Tbodygyromag-arcoeff()3|   
|252|                 tBodyGyroMag-arCoeff()4|        |                 Tbodygyromag-arcoeff()4|   
|253|                 tBodyGyroJerkMag-mean()|     YES|               Time.BodyGyroJerkMag.Mean|   
|254|                  tBodyGyroJerkMag-std()|     YES|              Time.BodyGyroJerkMag.StDev|   
|255|                  tBodyGyroJerkMag-mad()|        |                  Tbodygyrojerkmag-mad()|   
|256|                  tBodyGyroJerkMag-max()|        |                  Tbodygyrojerkmag-max()|   
|257|                  tBodyGyroJerkMag-min()|        |                  Tbodygyrojerkmag-min()|   
|258|                  tBodyGyroJerkMag-sma()|        |                  Tbodygyrojerkmag-sma()|   
|259|               tBodyGyroJerkMag-energy()|        |               Tbodygyrojerkmag-energy()|   
|260|                  tBodyGyroJerkMag-iqr()|        |                  Tbodygyrojerkmag-iqr()|   
|261|              tBodyGyroJerkMag-entropy()|        |              Tbodygyrojerkmag-entropy()|   
|262|             tBodyGyroJerkMag-arCoeff()1|        |             Tbodygyrojerkmag-arcoeff()1|   
|263|             tBodyGyroJerkMag-arCoeff()2|        |             Tbodygyrojerkmag-arcoeff()2|   
|264|             tBodyGyroJerkMag-arCoeff()3|        |             Tbodygyrojerkmag-arcoeff()3|   
|265|             tBodyGyroJerkMag-arCoeff()4|        |             Tbodygyrojerkmag-arcoeff()4|   
|266|                       fBodyAcc-mean()-X|     YES|                     Freq.BodyAcc.Mean.X|   
|267|                       fBodyAcc-mean()-Y|     YES|                     Freq.BodyAcc.Mean.Y|   
|268|                       fBodyAcc-mean()-Z|     YES|                     Freq.BodyAcc.Mean.Z|   
|269|                        fBodyAcc-std()-X|     YES|                    Freq.BodyAcc.StDev.X|   
|270|                        fBodyAcc-std()-Y|     YES|                    Freq.BodyAcc.StDev.Y|   
|271|                        fBodyAcc-std()-Z|     YES|                    Freq.BodyAcc.StDev.Z|   
|272|                        fBodyAcc-mad()-X|        |                        Fbodyacc-mad()-x|   
|273|                        fBodyAcc-mad()-Y|        |                        Fbodyacc-mad()-y|   
|274|                        fBodyAcc-mad()-Z|        |                        Fbodyacc-mad()-z|   
|275|                        fBodyAcc-max()-X|        |                        Fbodyacc-max()-x|   
|276|                        fBodyAcc-max()-Y|        |                        Fbodyacc-max()-y|   
|277|                        fBodyAcc-max()-Z|        |                        Fbodyacc-max()-z|   
|278|                        fBodyAcc-min()-X|        |                        Fbodyacc-min()-x|   
|279|                        fBodyAcc-min()-Y|        |                        Fbodyacc-min()-y|   
|280|                        fBodyAcc-min()-Z|        |                        Fbodyacc-min()-z|   
|281|                          fBodyAcc-sma()|        |                          Fbodyacc-sma()|   
|282|                     fBodyAcc-energy()-X|        |                     Fbodyacc-energy()-x|   
|283|                     fBodyAcc-energy()-Y|        |                     Fbodyacc-energy()-y|   
|284|                     fBodyAcc-energy()-Z|        |                     Fbodyacc-energy()-z|   
|285|                        fBodyAcc-iqr()-X|        |                        Fbodyacc-iqr()-x|   
|286|                        fBodyAcc-iqr()-Y|        |                        Fbodyacc-iqr()-y|   
|287|                        fBodyAcc-iqr()-Z|        |                        Fbodyacc-iqr()-z|   
|288|                    fBodyAcc-entropy()-X|        |                    Fbodyacc-entropy()-x|   
|289|                    fBodyAcc-entropy()-Y|        |                    Fbodyacc-entropy()-y|   
|290|                    fBodyAcc-entropy()-Z|        |                    Fbodyacc-entropy()-z|   
|291|                      fBodyAcc-maxInds-X|        |                      Fbodyacc-maxinds-x|   
|292|                      fBodyAcc-maxInds-Y|        |                      Fbodyacc-maxinds-y|   
|293|                      fBodyAcc-maxInds-Z|        |                      Fbodyacc-maxinds-z|   
|294|                   fBodyAcc-meanFreq()-X|        |                   Fbodyacc-meanfreq()-x|   
|295|                   fBodyAcc-meanFreq()-Y|        |                   Fbodyacc-meanfreq()-y|   
|296|                   fBodyAcc-meanFreq()-Z|        |                   Fbodyacc-meanfreq()-z|   
|297|                   fBodyAcc-skewness()-X|        |                   Fbodyacc-skewness()-x|   
|298|                   fBodyAcc-kurtosis()-X|        |                   Fbodyacc-kurtosis()-x|   
|299|                   fBodyAcc-skewness()-Y|        |                   Fbodyacc-skewness()-y|   
|300|                   fBodyAcc-kurtosis()-Y|        |                   Fbodyacc-kurtosis()-y|   
|301|                   fBodyAcc-skewness()-Z|        |                   Fbodyacc-skewness()-z|   
|302|                   fBodyAcc-kurtosis()-Z|        |                   Fbodyacc-kurtosis()-z|   
|303|              fBodyAcc-bandsEnergy()-1,8|        |              Fbodyacc-bandsenergy()-1,8|   
|304|             fBodyAcc-bandsEnergy()-9,16|        |             Fbodyacc-bandsenergy()-9,16|   
|305|            fBodyAcc-bandsEnergy()-17,24|        |            Fbodyacc-bandsenergy()-17,24|   
|306|            fBodyAcc-bandsEnergy()-25,32|        |            Fbodyacc-bandsenergy()-25,32|   
|307|            fBodyAcc-bandsEnergy()-33,40|        |            Fbodyacc-bandsenergy()-33,40|   
|308|            fBodyAcc-bandsEnergy()-41,48|        |            Fbodyacc-bandsenergy()-41,48|   
|309|            fBodyAcc-bandsEnergy()-49,56|        |            Fbodyacc-bandsenergy()-49,56|   
|310|            fBodyAcc-bandsEnergy()-57,64|        |            Fbodyacc-bandsenergy()-57,64|   
|311|             fBodyAcc-bandsEnergy()-1,16|        |             Fbodyacc-bandsenergy()-1,16|   
|312|            fBodyAcc-bandsEnergy()-17,32|        |            Fbodyacc-bandsenergy()-17,32|   
|313|            fBodyAcc-bandsEnergy()-33,48|        |            Fbodyacc-bandsenergy()-33,48|   
|314|            fBodyAcc-bandsEnergy()-49,64|        |            Fbodyacc-bandsenergy()-49,64|   
|315|             fBodyAcc-bandsEnergy()-1,24|        |             Fbodyacc-bandsenergy()-1,24|   
|316|            fBodyAcc-bandsEnergy()-25,48|        |            Fbodyacc-bandsenergy()-25,48|   
|317|              fBodyAcc-bandsEnergy()-1,8|        |              Fbodyacc-bandsenergy()-1,8|   
|318|             fBodyAcc-bandsEnergy()-9,16|        |             Fbodyacc-bandsenergy()-9,16|   
|319|            fBodyAcc-bandsEnergy()-17,24|        |            Fbodyacc-bandsenergy()-17,24|   
|320|            fBodyAcc-bandsEnergy()-25,32|        |            Fbodyacc-bandsenergy()-25,32|   
|321|            fBodyAcc-bandsEnergy()-33,40|        |            Fbodyacc-bandsenergy()-33,40|   
|322|            fBodyAcc-bandsEnergy()-41,48|        |            Fbodyacc-bandsenergy()-41,48|   
|323|            fBodyAcc-bandsEnergy()-49,56|        |            Fbodyacc-bandsenergy()-49,56|   
|324|            fBodyAcc-bandsEnergy()-57,64|        |            Fbodyacc-bandsenergy()-57,64|   
|325|             fBodyAcc-bandsEnergy()-1,16|        |             Fbodyacc-bandsenergy()-1,16|   
|326|            fBodyAcc-bandsEnergy()-17,32|        |            Fbodyacc-bandsenergy()-17,32|   
|327|            fBodyAcc-bandsEnergy()-33,48|        |            Fbodyacc-bandsenergy()-33,48|   
|328|            fBodyAcc-bandsEnergy()-49,64|        |            Fbodyacc-bandsenergy()-49,64|   
|329|             fBodyAcc-bandsEnergy()-1,24|        |             Fbodyacc-bandsenergy()-1,24|   
|330|            fBodyAcc-bandsEnergy()-25,48|        |            Fbodyacc-bandsenergy()-25,48|   
|331|              fBodyAcc-bandsEnergy()-1,8|        |              Fbodyacc-bandsenergy()-1,8|   
|332|             fBodyAcc-bandsEnergy()-9,16|        |             Fbodyacc-bandsenergy()-9,16|   
|333|            fBodyAcc-bandsEnergy()-17,24|        |            Fbodyacc-bandsenergy()-17,24|   
|334|            fBodyAcc-bandsEnergy()-25,32|        |            Fbodyacc-bandsenergy()-25,32|   
|335|            fBodyAcc-bandsEnergy()-33,40|        |            Fbodyacc-bandsenergy()-33,40|   
|336|            fBodyAcc-bandsEnergy()-41,48|        |            Fbodyacc-bandsenergy()-41,48|   
|337|            fBodyAcc-bandsEnergy()-49,56|        |            Fbodyacc-bandsenergy()-49,56|   
|338|            fBodyAcc-bandsEnergy()-57,64|        |            Fbodyacc-bandsenergy()-57,64|   
|339|             fBodyAcc-bandsEnergy()-1,16|        |             Fbodyacc-bandsenergy()-1,16|   
|340|            fBodyAcc-bandsEnergy()-17,32|        |            Fbodyacc-bandsenergy()-17,32|   
|341|            fBodyAcc-bandsEnergy()-33,48|        |            Fbodyacc-bandsenergy()-33,48|   
|342|            fBodyAcc-bandsEnergy()-49,64|        |            Fbodyacc-bandsenergy()-49,64|   
|343|             fBodyAcc-bandsEnergy()-1,24|        |             Fbodyacc-bandsenergy()-1,24|   
|344|            fBodyAcc-bandsEnergy()-25,48|        |            Fbodyacc-bandsenergy()-25,48|   
|345|                   fBodyAccJerk-mean()-X|     YES|                 Freq.BodyAccJerk.Mean.X|   
|346|                   fBodyAccJerk-mean()-Y|     YES|                 Freq.BodyAccJerk.Mean.Y|   
|347|                   fBodyAccJerk-mean()-Z|     YES|                 Freq.BodyAccJerk.Mean.Z|   
|348|                    fBodyAccJerk-std()-X|     YES|                Freq.BodyAccJerk.StDev.X|   
|349|                    fBodyAccJerk-std()-Y|     YES|                Freq.BodyAccJerk.StDev.Y|   
|350|                    fBodyAccJerk-std()-Z|     YES|                Freq.BodyAccJerk.StDev.Z|   
|351|                    fBodyAccJerk-mad()-X|        |                    Fbodyaccjerk-mad()-x|   
|352|                    fBodyAccJerk-mad()-Y|        |                    Fbodyaccjerk-mad()-y|   
|353|                    fBodyAccJerk-mad()-Z|        |                    Fbodyaccjerk-mad()-z|   
|354|                    fBodyAccJerk-max()-X|        |                    Fbodyaccjerk-max()-x|   
|355|                    fBodyAccJerk-max()-Y|        |                    Fbodyaccjerk-max()-y|   
|356|                    fBodyAccJerk-max()-Z|        |                    Fbodyaccjerk-max()-z|   
|357|                    fBodyAccJerk-min()-X|        |                    Fbodyaccjerk-min()-x|   
|358|                    fBodyAccJerk-min()-Y|        |                    Fbodyaccjerk-min()-y|   
|359|                    fBodyAccJerk-min()-Z|        |                    Fbodyaccjerk-min()-z|   
|360|                      fBodyAccJerk-sma()|        |                      Fbodyaccjerk-sma()|   
|361|                 fBodyAccJerk-energy()-X|        |                 Fbodyaccjerk-energy()-x|   
|362|                 fBodyAccJerk-energy()-Y|        |                 Fbodyaccjerk-energy()-y|   
|363|                 fBodyAccJerk-energy()-Z|        |                 Fbodyaccjerk-energy()-z|   
|364|                    fBodyAccJerk-iqr()-X|        |                    Fbodyaccjerk-iqr()-x|   
|365|                    fBodyAccJerk-iqr()-Y|        |                    Fbodyaccjerk-iqr()-y|   
|366|                    fBodyAccJerk-iqr()-Z|        |                    Fbodyaccjerk-iqr()-z|   
|367|                fBodyAccJerk-entropy()-X|        |                Fbodyaccjerk-entropy()-x|   
|368|                fBodyAccJerk-entropy()-Y|        |                Fbodyaccjerk-entropy()-y|   
|369|                fBodyAccJerk-entropy()-Z|        |                Fbodyaccjerk-entropy()-z|   
|370|                  fBodyAccJerk-maxInds-X|        |                  Fbodyaccjerk-maxinds-x|   
|371|                  fBodyAccJerk-maxInds-Y|        |                  Fbodyaccjerk-maxinds-y|   
|372|                  fBodyAccJerk-maxInds-Z|        |                  Fbodyaccjerk-maxinds-z|   
|373|               fBodyAccJerk-meanFreq()-X|        |               Fbodyaccjerk-meanfreq()-x|   
|374|               fBodyAccJerk-meanFreq()-Y|        |               Fbodyaccjerk-meanfreq()-y|   
|375|               fBodyAccJerk-meanFreq()-Z|        |               Fbodyaccjerk-meanfreq()-z|   
|376|               fBodyAccJerk-skewness()-X|        |               Fbodyaccjerk-skewness()-x|   
|377|               fBodyAccJerk-kurtosis()-X|        |               Fbodyaccjerk-kurtosis()-x|   
|378|               fBodyAccJerk-skewness()-Y|        |               Fbodyaccjerk-skewness()-y|   
|379|               fBodyAccJerk-kurtosis()-Y|        |               Fbodyaccjerk-kurtosis()-y|   
|380|               fBodyAccJerk-skewness()-Z|        |               Fbodyaccjerk-skewness()-z|   
|381|               fBodyAccJerk-kurtosis()-Z|        |               Fbodyaccjerk-kurtosis()-z|   
|382|          fBodyAccJerk-bandsEnergy()-1,8|        |          Fbodyaccjerk-bandsenergy()-1,8|   
|383|         fBodyAccJerk-bandsEnergy()-9,16|        |         Fbodyaccjerk-bandsenergy()-9,16|   
|384|        fBodyAccJerk-bandsEnergy()-17,24|        |        Fbodyaccjerk-bandsenergy()-17,24|   
|385|        fBodyAccJerk-bandsEnergy()-25,32|        |        Fbodyaccjerk-bandsenergy()-25,32|   
|386|        fBodyAccJerk-bandsEnergy()-33,40|        |        Fbodyaccjerk-bandsenergy()-33,40|   
|387|        fBodyAccJerk-bandsEnergy()-41,48|        |        Fbodyaccjerk-bandsenergy()-41,48|   
|388|        fBodyAccJerk-bandsEnergy()-49,56|        |        Fbodyaccjerk-bandsenergy()-49,56|   
|389|        fBodyAccJerk-bandsEnergy()-57,64|        |        Fbodyaccjerk-bandsenergy()-57,64|   
|390|         fBodyAccJerk-bandsEnergy()-1,16|        |         Fbodyaccjerk-bandsenergy()-1,16|   
|391|        fBodyAccJerk-bandsEnergy()-17,32|        |        Fbodyaccjerk-bandsenergy()-17,32|   
|392|        fBodyAccJerk-bandsEnergy()-33,48|        |        Fbodyaccjerk-bandsenergy()-33,48|   
|393|        fBodyAccJerk-bandsEnergy()-49,64|        |        Fbodyaccjerk-bandsenergy()-49,64|   
|394|         fBodyAccJerk-bandsEnergy()-1,24|        |         Fbodyaccjerk-bandsenergy()-1,24|   
|395|        fBodyAccJerk-bandsEnergy()-25,48|        |        Fbodyaccjerk-bandsenergy()-25,48|   
|396|          fBodyAccJerk-bandsEnergy()-1,8|        |          Fbodyaccjerk-bandsenergy()-1,8|   
|397|         fBodyAccJerk-bandsEnergy()-9,16|        |         Fbodyaccjerk-bandsenergy()-9,16|   
|398|        fBodyAccJerk-bandsEnergy()-17,24|        |        Fbodyaccjerk-bandsenergy()-17,24|   
|399|        fBodyAccJerk-bandsEnergy()-25,32|        |        Fbodyaccjerk-bandsenergy()-25,32|   
|400|        fBodyAccJerk-bandsEnergy()-33,40|        |        Fbodyaccjerk-bandsenergy()-33,40|   
|401|        fBodyAccJerk-bandsEnergy()-41,48|        |        Fbodyaccjerk-bandsenergy()-41,48|   
|402|        fBodyAccJerk-bandsEnergy()-49,56|        |        Fbodyaccjerk-bandsenergy()-49,56|   
|403|        fBodyAccJerk-bandsEnergy()-57,64|        |        Fbodyaccjerk-bandsenergy()-57,64|   
|404|         fBodyAccJerk-bandsEnergy()-1,16|        |         Fbodyaccjerk-bandsenergy()-1,16|   
|405|        fBodyAccJerk-bandsEnergy()-17,32|        |        Fbodyaccjerk-bandsenergy()-17,32|   
|406|        fBodyAccJerk-bandsEnergy()-33,48|        |        Fbodyaccjerk-bandsenergy()-33,48|   
|407|        fBodyAccJerk-bandsEnergy()-49,64|        |        Fbodyaccjerk-bandsenergy()-49,64|   
|408|         fBodyAccJerk-bandsEnergy()-1,24|        |         Fbodyaccjerk-bandsenergy()-1,24|   
|409|        fBodyAccJerk-bandsEnergy()-25,48|        |        Fbodyaccjerk-bandsenergy()-25,48|   
|410|          fBodyAccJerk-bandsEnergy()-1,8|        |          Fbodyaccjerk-bandsenergy()-1,8|   
|411|         fBodyAccJerk-bandsEnergy()-9,16|        |         Fbodyaccjerk-bandsenergy()-9,16|   
|412|        fBodyAccJerk-bandsEnergy()-17,24|        |        Fbodyaccjerk-bandsenergy()-17,24|   
|413|        fBodyAccJerk-bandsEnergy()-25,32|        |        Fbodyaccjerk-bandsenergy()-25,32|   
|414|        fBodyAccJerk-bandsEnergy()-33,40|        |        Fbodyaccjerk-bandsenergy()-33,40|   
|415|        fBodyAccJerk-bandsEnergy()-41,48|        |        Fbodyaccjerk-bandsenergy()-41,48|   
|416|        fBodyAccJerk-bandsEnergy()-49,56|        |        Fbodyaccjerk-bandsenergy()-49,56|   
|417|        fBodyAccJerk-bandsEnergy()-57,64|        |        Fbodyaccjerk-bandsenergy()-57,64|   
|418|         fBodyAccJerk-bandsEnergy()-1,16|        |         Fbodyaccjerk-bandsenergy()-1,16|   
|419|        fBodyAccJerk-bandsEnergy()-17,32|        |        Fbodyaccjerk-bandsenergy()-17,32|   
|420|        fBodyAccJerk-bandsEnergy()-33,48|        |        Fbodyaccjerk-bandsenergy()-33,48|   
|421|        fBodyAccJerk-bandsEnergy()-49,64|        |        Fbodyaccjerk-bandsenergy()-49,64|   
|422|         fBodyAccJerk-bandsEnergy()-1,24|        |         Fbodyaccjerk-bandsenergy()-1,24|   
|423|        fBodyAccJerk-bandsEnergy()-25,48|        |        Fbodyaccjerk-bandsenergy()-25,48|   
|424|                      fBodyGyro-mean()-X|     YES|                    Freq.BodyGyro.Mean.X|   
|425|                      fBodyGyro-mean()-Y|     YES|                    Freq.BodyGyro.Mean.Y|   
|426|                      fBodyGyro-mean()-Z|     YES|                    Freq.BodyGyro.Mean.Z|   
|427|                       fBodyGyro-std()-X|     YES|                   Freq.BodyGyro.StDev.X|   
|428|                       fBodyGyro-std()-Y|     YES|                   Freq.BodyGyro.StDev.Y|   
|429|                       fBodyGyro-std()-Z|     YES|                   Freq.BodyGyro.StDev.Z|   
|430|                       fBodyGyro-mad()-X|        |                       Fbodygyro-mad()-x|   
|431|                       fBodyGyro-mad()-Y|        |                       Fbodygyro-mad()-y|   
|432|                       fBodyGyro-mad()-Z|        |                       Fbodygyro-mad()-z|   
|433|                       fBodyGyro-max()-X|        |                       Fbodygyro-max()-x|   
|434|                       fBodyGyro-max()-Y|        |                       Fbodygyro-max()-y|   
|435|                       fBodyGyro-max()-Z|        |                       Fbodygyro-max()-z|   
|436|                       fBodyGyro-min()-X|        |                       Fbodygyro-min()-x|   
|437|                       fBodyGyro-min()-Y|        |                       Fbodygyro-min()-y|   
|438|                       fBodyGyro-min()-Z|        |                       Fbodygyro-min()-z|   
|439|                         fBodyGyro-sma()|        |                         Fbodygyro-sma()|   
|440|                    fBodyGyro-energy()-X|        |                    Fbodygyro-energy()-x|   
|441|                    fBodyGyro-energy()-Y|        |                    Fbodygyro-energy()-y|   
|442|                    fBodyGyro-energy()-Z|        |                    Fbodygyro-energy()-z|   
|443|                       fBodyGyro-iqr()-X|        |                       Fbodygyro-iqr()-x|   
|444|                       fBodyGyro-iqr()-Y|        |                       Fbodygyro-iqr()-y|   
|445|                       fBodyGyro-iqr()-Z|        |                       Fbodygyro-iqr()-z|   
|446|                   fBodyGyro-entropy()-X|        |                   Fbodygyro-entropy()-x|   
|447|                   fBodyGyro-entropy()-Y|        |                   Fbodygyro-entropy()-y|   
|448|                   fBodyGyro-entropy()-Z|        |                   Fbodygyro-entropy()-z|   
|449|                     fBodyGyro-maxInds-X|        |                     Fbodygyro-maxinds-x|   
|450|                     fBodyGyro-maxInds-Y|        |                     Fbodygyro-maxinds-y|   
|451|                     fBodyGyro-maxInds-Z|        |                     Fbodygyro-maxinds-z|   
|452|                  fBodyGyro-meanFreq()-X|        |                  Fbodygyro-meanfreq()-x|   
|453|                  fBodyGyro-meanFreq()-Y|        |                  Fbodygyro-meanfreq()-y|   
|454|                  fBodyGyro-meanFreq()-Z|        |                  Fbodygyro-meanfreq()-z|   
|455|                  fBodyGyro-skewness()-X|        |                  Fbodygyro-skewness()-x|   
|456|                  fBodyGyro-kurtosis()-X|        |                  Fbodygyro-kurtosis()-x|   
|457|                  fBodyGyro-skewness()-Y|        |                  Fbodygyro-skewness()-y|   
|458|                  fBodyGyro-kurtosis()-Y|        |                  Fbodygyro-kurtosis()-y|   
|459|                  fBodyGyro-skewness()-Z|        |                  Fbodygyro-skewness()-z|   
|460|                  fBodyGyro-kurtosis()-Z|        |                  Fbodygyro-kurtosis()-z|   
|461|             fBodyGyro-bandsEnergy()-1,8|        |             Fbodygyro-bandsenergy()-1,8|   
|462|            fBodyGyro-bandsEnergy()-9,16|        |            Fbodygyro-bandsenergy()-9,16|   
|463|           fBodyGyro-bandsEnergy()-17,24|        |           Fbodygyro-bandsenergy()-17,24|   
|464|           fBodyGyro-bandsEnergy()-25,32|        |           Fbodygyro-bandsenergy()-25,32|   
|465|           fBodyGyro-bandsEnergy()-33,40|        |           Fbodygyro-bandsenergy()-33,40|   
|466|           fBodyGyro-bandsEnergy()-41,48|        |           Fbodygyro-bandsenergy()-41,48|   
|467|           fBodyGyro-bandsEnergy()-49,56|        |           Fbodygyro-bandsenergy()-49,56|   
|468|           fBodyGyro-bandsEnergy()-57,64|        |           Fbodygyro-bandsenergy()-57,64|   
|469|            fBodyGyro-bandsEnergy()-1,16|        |            Fbodygyro-bandsenergy()-1,16|   
|470|           fBodyGyro-bandsEnergy()-17,32|        |           Fbodygyro-bandsenergy()-17,32|   
|471|           fBodyGyro-bandsEnergy()-33,48|        |           Fbodygyro-bandsenergy()-33,48|   
|472|           fBodyGyro-bandsEnergy()-49,64|        |           Fbodygyro-bandsenergy()-49,64|   
|473|            fBodyGyro-bandsEnergy()-1,24|        |            Fbodygyro-bandsenergy()-1,24|   
|474|           fBodyGyro-bandsEnergy()-25,48|        |           Fbodygyro-bandsenergy()-25,48|   
|475|             fBodyGyro-bandsEnergy()-1,8|        |             Fbodygyro-bandsenergy()-1,8|   
|476|            fBodyGyro-bandsEnergy()-9,16|        |            Fbodygyro-bandsenergy()-9,16|   
|477|           fBodyGyro-bandsEnergy()-17,24|        |           Fbodygyro-bandsenergy()-17,24|   
|478|           fBodyGyro-bandsEnergy()-25,32|        |           Fbodygyro-bandsenergy()-25,32|   
|479|           fBodyGyro-bandsEnergy()-33,40|        |           Fbodygyro-bandsenergy()-33,40|   
|480|           fBodyGyro-bandsEnergy()-41,48|        |           Fbodygyro-bandsenergy()-41,48|   
|481|           fBodyGyro-bandsEnergy()-49,56|        |           Fbodygyro-bandsenergy()-49,56|   
|482|           fBodyGyro-bandsEnergy()-57,64|        |           Fbodygyro-bandsenergy()-57,64|   
|483|            fBodyGyro-bandsEnergy()-1,16|        |            Fbodygyro-bandsenergy()-1,16|   
|484|           fBodyGyro-bandsEnergy()-17,32|        |           Fbodygyro-bandsenergy()-17,32|   
|485|           fBodyGyro-bandsEnergy()-33,48|        |           Fbodygyro-bandsenergy()-33,48|   
|486|           fBodyGyro-bandsEnergy()-49,64|        |           Fbodygyro-bandsenergy()-49,64|   
|487|            fBodyGyro-bandsEnergy()-1,24|        |            Fbodygyro-bandsenergy()-1,24|   
|488|           fBodyGyro-bandsEnergy()-25,48|        |           Fbodygyro-bandsenergy()-25,48|   
|489|             fBodyGyro-bandsEnergy()-1,8|        |             Fbodygyro-bandsenergy()-1,8|   
|490|            fBodyGyro-bandsEnergy()-9,16|        |            Fbodygyro-bandsenergy()-9,16|   
|491|           fBodyGyro-bandsEnergy()-17,24|        |           Fbodygyro-bandsenergy()-17,24|   
|492|           fBodyGyro-bandsEnergy()-25,32|        |           Fbodygyro-bandsenergy()-25,32|   
|493|           fBodyGyro-bandsEnergy()-33,40|        |           Fbodygyro-bandsenergy()-33,40|   
|494|           fBodyGyro-bandsEnergy()-41,48|        |           Fbodygyro-bandsenergy()-41,48|   
|495|           fBodyGyro-bandsEnergy()-49,56|        |           Fbodygyro-bandsenergy()-49,56|   
|496|           fBodyGyro-bandsEnergy()-57,64|        |           Fbodygyro-bandsenergy()-57,64|   
|497|            fBodyGyro-bandsEnergy()-1,16|        |            Fbodygyro-bandsenergy()-1,16|   
|498|           fBodyGyro-bandsEnergy()-17,32|        |           Fbodygyro-bandsenergy()-17,32|   
|499|           fBodyGyro-bandsEnergy()-33,48|        |           Fbodygyro-bandsenergy()-33,48|   
|500|           fBodyGyro-bandsEnergy()-49,64|        |           Fbodygyro-bandsenergy()-49,64|   
|501|            fBodyGyro-bandsEnergy()-1,24|        |            Fbodygyro-bandsenergy()-1,24|   
|502|           fBodyGyro-bandsEnergy()-25,48|        |           Fbodygyro-bandsenergy()-25,48|   
|503|                      fBodyAccMag-mean()|     YES|                    Freq.BodyAccMag.Mean|   
|504|                       fBodyAccMag-std()|     YES|                   Freq.BodyAccMag.StDev|   
|505|                       fBodyAccMag-mad()|        |                       Fbodyaccmag-mad()|   
|506|                       fBodyAccMag-max()|        |                       Fbodyaccmag-max()|   
|507|                       fBodyAccMag-min()|        |                       Fbodyaccmag-min()|   
|508|                       fBodyAccMag-sma()|        |                       Fbodyaccmag-sma()|   
|509|                    fBodyAccMag-energy()|        |                    Fbodyaccmag-energy()|   
|510|                       fBodyAccMag-iqr()|        |                       Fbodyaccmag-iqr()|   
|511|                   fBodyAccMag-entropy()|        |                   Fbodyaccmag-entropy()|   
|512|                     fBodyAccMag-maxInds|        |                     Fbodyaccmag-maxinds|   
|513|                  fBodyAccMag-meanFreq()|        |                  Fbodyaccmag-meanfreq()|   
|514|                  fBodyAccMag-skewness()|        |                  Fbodyaccmag-skewness()|   
|515|                  fBodyAccMag-kurtosis()|        |                  Fbodyaccmag-kurtosis()|   
|516|              fBodyBodyAccJerkMag-mean()|     YES|            Freq.BodyBodyAccJerkMag.Mean|   
|517|               fBodyBodyAccJerkMag-std()|     YES|           Freq.BodyBodyAccJerkMag.StDev|   
|518|               fBodyBodyAccJerkMag-mad()|        |               Fbodybodyaccjerkmag-mad()|   
|519|               fBodyBodyAccJerkMag-max()|        |               Fbodybodyaccjerkmag-max()|   
|520|               fBodyBodyAccJerkMag-min()|        |               Fbodybodyaccjerkmag-min()|   
|521|               fBodyBodyAccJerkMag-sma()|        |               Fbodybodyaccjerkmag-sma()|   
|522|            fBodyBodyAccJerkMag-energy()|        |            Fbodybodyaccjerkmag-energy()|   
|523|               fBodyBodyAccJerkMag-iqr()|        |               Fbodybodyaccjerkmag-iqr()|   
|524|           fBodyBodyAccJerkMag-entropy()|        |           Fbodybodyaccjerkmag-entropy()|   
|525|             fBodyBodyAccJerkMag-maxInds|        |             Fbodybodyaccjerkmag-maxinds|   
|526|          fBodyBodyAccJerkMag-meanFreq()|        |          Fbodybodyaccjerkmag-meanfreq()|   
|527|          fBodyBodyAccJerkMag-skewness()|        |          Fbodybodyaccjerkmag-skewness()|   
|528|          fBodyBodyAccJerkMag-kurtosis()|        |          Fbodybodyaccjerkmag-kurtosis()|   
|529|                 fBodyBodyGyroMag-mean()|     YES|               Freq.BodyBodyGyroMag.Mean|   
|530|                  fBodyBodyGyroMag-std()|     YES|              Freq.BodyBodyGyroMag.StDev|   
|531|                  fBodyBodyGyroMag-mad()|        |                  Fbodybodygyromag-mad()|   
|532|                  fBodyBodyGyroMag-max()|        |                  Fbodybodygyromag-max()|   
|533|                  fBodyBodyGyroMag-min()|        |                  Fbodybodygyromag-min()|   
|534|                  fBodyBodyGyroMag-sma()|        |                  Fbodybodygyromag-sma()|   
|535|               fBodyBodyGyroMag-energy()|        |               Fbodybodygyromag-energy()|   
|536|                  fBodyBodyGyroMag-iqr()|        |                  Fbodybodygyromag-iqr()|   
|537|              fBodyBodyGyroMag-entropy()|        |              Fbodybodygyromag-entropy()|   
|538|                fBodyBodyGyroMag-maxInds|        |                Fbodybodygyromag-maxinds|   
|539|             fBodyBodyGyroMag-meanFreq()|        |             Fbodybodygyromag-meanfreq()|   
|540|             fBodyBodyGyroMag-skewness()|        |             Fbodybodygyromag-skewness()|   
|541|             fBodyBodyGyroMag-kurtosis()|        |             Fbodybodygyromag-kurtosis()|   
|542|             fBodyBodyGyroJerkMag-mean()|     YES|           Freq.BodyBodyGyroJerkMag.Mean|   
|543|              fBodyBodyGyroJerkMag-std()|     YES|          Freq.BodyBodyGyroJerkMag.StDev|   
|544|              fBodyBodyGyroJerkMag-mad()|        |              Fbodybodygyrojerkmag-mad()|   
|545|              fBodyBodyGyroJerkMag-max()|        |              Fbodybodygyrojerkmag-max()|   
|546|              fBodyBodyGyroJerkMag-min()|        |              Fbodybodygyrojerkmag-min()|   
|547|              fBodyBodyGyroJerkMag-sma()|        |              Fbodybodygyrojerkmag-sma()|   
|548|           fBodyBodyGyroJerkMag-energy()|        |           Fbodybodygyrojerkmag-energy()|   
|549|              fBodyBodyGyroJerkMag-iqr()|        |              Fbodybodygyrojerkmag-iqr()|   
|550|          fBodyBodyGyroJerkMag-entropy()|        |          Fbodybodygyrojerkmag-entropy()|   
|551|            fBodyBodyGyroJerkMag-maxInds|        |            Fbodybodygyrojerkmag-maxinds|   
|552|         fBodyBodyGyroJerkMag-meanFreq()|        |         Fbodybodygyrojerkmag-meanfreq()|   
|553|         fBodyBodyGyroJerkMag-skewness()|        |         Fbodybodygyrojerkmag-skewness()|   
|554|         fBodyBodyGyroJerkMag-kurtosis()|        |         Fbodybodygyrojerkmag-kurtosis()|   
|555|             angle(tBodyAccMean,gravity)|        |             Angle(tbodyaccmean,gravity)|   
|556|    angle(tBodyAccJerkMean),gravityMean)|        |    Angle(tbodyaccjerkmean),gravitymean)|   
|557|        angle(tBodyGyroMean,gravityMean)|        |        Angle(tbodygyromean,gravitymean)|   
|558|    angle(tBodyGyroJerkMean,gravityMean)|        |    Angle(tbodygyrojerkmean,gravitymean)|   
|559|                    angle(X,gravityMean)|        |                    Angle(x,gravitymean)|   
|560|                    angle(Y,gravityMean)|        |                    Angle(y,gravitymean)|   
|561|                    angle(Z,gravityMean)|        |                    Angle(z,gravitymean)|   

