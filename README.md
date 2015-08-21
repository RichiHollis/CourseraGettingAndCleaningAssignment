# CourseraGettingAndCleaningAssignment
Coursera "Getting And Cleaning Data" Assignment

## Introduction
This README document describes the data cleaning steps for the coursera course:

**"Getting and Cleaning Data"**

held during August, 2015.  At that time, the raw data were available at the following link:

    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## The files contained in this repo are:
1. README.md 

    this file.
    
2. CodeBook.md

    Description of variables from the raw file and the output tidy data table.
    Descripton of the raw-to-tidy data transformation.

3. run\_analysis.R

    Analysis code (written in R).
    Transforms the linked raw data above into the tidy format (found in the tidy\_data.txt file).
    Transformation information is contained in the CodeBook.md file.

4. tidy\_data.txt

    Final tidy data, produced from run_analysis.R.

## Running the code

This code was authored on R code:

        R version 3.0.2 (2013-09-25) -- "Frisbee Sailing"

and executed on

        RStudio Version 0.99.467

under the operating system:

        Ubuntu 14.04 (64bit)

1. Place the data into a known working directory (e.g. cleaning_assignment)
2. Unzip the file, rename the directory to play nicely in Linux

        unzip getdata_projectfiles_UCI\ HAR\ Dataset.zip
        mv UCI\ HAR\ Dataset UCI_HAR_Dataset

3. Download the R script run_analysis.R to working directory

    Your directory should include:
    
        > ls
          run_analysis.R UCI_HAR_Dataset

4. Open rstudio in the working directory

5. Run the script (slight pause as the data is read in)

    Some information is printed to let you know about the data and the stage of the analysis

6. A tidy data frame is produced and saved as:

        tidy_data.txt

