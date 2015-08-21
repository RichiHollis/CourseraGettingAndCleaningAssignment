##########################################
## 
## Function: run_analysis
## 
## Purpose: Sums training and testing samples
##   from smartphone data, extracts only the
##   relevant "mean" and "std" information
##   from the datastream.  Produces a final
##   "tidy" dataset for further analysis later.
## 
##########################################

run_analysis <- function(){
  ###################
  ## Set the directory to be used:
  ###################
  dir<-"UCI_HAR_Dataset/";
  
  ###################
  # Grab the column names and format them nicely
  ## 't' denotes Time domain
  ## 'f' denotes Frequency domain (via Fast Fourier Transform)
  ###################
  ## Read data from file
  summary_names_df<-read.table(file=paste(dir,"features.txt",sep=""),sep=" ");
  ## Mark the colums that we will want to use later
  summary_required_mean<-grep("mean\\(\\)",summary_names_df[,2]);
  summary_required_std<-grep("std\\(\\)",summary_names_df[,2]);
  summary_required<-c(summary_required_mean,summary_required_std);
  ## Make them nicer to read
  summary_names<-lapply(summary_names_df[,2],nicify);
  
  ## The below code prints out a table for the codebook.
  ##all_rows<-character(nrow(summary_names_df))
  ##for(i in summary_required){
  ##  all_rows[i]<-"YES"
  ##}
  ##temp<-summary_names_df;
  ##temp$Used<-all_rows;
  ##temp$NewName<-summary_names;
  ##print(temp);

  ############################
  # Grab the Activity labels and make them a little nicer
  ## 1-6 giving the type of activity
  ############################
  ## Read data from file
  activity_names_df<-read.table(file=paste(dir,"activity_labels.txt",sep=""),
                                sep=" ");
  ## Make the names a little easier to read
  activity_names<-lapply(activity_names_df[,2],nicify);
  subject_names<-"Subject.ID";
  
  
  ####################
  # Grab the "Test" sample
  ####################
  test_df<-get_df("test",subject_names,activity_names,summary_names,summary_required);
  #print(dim(test_df))
  
  ####################
  # Grab the "Train" sample
  ####################
  train_df<-get_df("train",subject_names,activity_names,summary_names,summary_required);
  #print(dim(train_df))
 
  ####################
  # Combine the test and training samples (row-wise)
  ####################
  total_df<-rbind(test_df,train_df);
  
  
  ####################
  # Change the activity type (current coded as 1:6) to real names
  ####################
  for(i in 1:6) {
    total_df$Activity.ID[total_df$Activity.ID==i]<-activity_names[[i]];
  }
  #Make these useful in R by setting them as factors:
  total_df$Activity.ID<-as.factor(total_df$Activity.ID);
  
  
  ####################
  # Make a summary by Activity
  ####################
  summary_by_activity<-aggregate(total_df[,3:ncol(total_df)],by=list(total_df$Activity.ID,total_df$Subject.ID),FUN=mean);
  colnames(summary_by_activity)[1]<-"Activity";
  colnames(summary_by_activity)[2]<-"Subject.ID";
  
  ###########
  # Save and view the summaries
  ###########
  write.table(summary_by_activity,"tidy_data.txt",row.name=F);
  View(summary_by_activity);
  
  ###########
  # Return the tidy data set (note not the summary one which was outputted to the text file).
  ###########
  return(total_df);
}

################
# Read data from test or trial directories and returns
# an assembled data frame
################
get_df <- function(type,subject_names,activity_names,summary_names,summary_required) {
  #For testing (quickness)
  accepted_rows<-(-200);#change to a positive number to make it run faster
  
  dir<-paste("UCI_HAR_Dataset/",type,"/",sep="");
  #Subject tag (1-30, for reference)
  subjects<-read.table(file=paste(dir,"subject_",type,".txt",sep=""),sep=" ",
                       nrows=accepted_rows);
  #Activity tag (1-6, labeled as activity_names)
  activity<-read.table(file=paste(dir,"y_",type,".txt",sep=""),sep=" ",
                       nrows=accepted_rows);
  #Summary Results (labels as summary_names)
  summary<-read.table(file=paste(dir,"X_",type,".txt",sep=""),
                      nrows=accepted_rows);

  df<-build_data_frame(type,
                       subjects,  subject_names,
                       activity,  "Activity.ID",#activity_names,
                       summary,   summary_names,
                       summary_required);
}

####################
# This function compiles all the necessary information
# into a data.frame type
# An error message is shown if the number of rows is 
# inconsistent between the inputs.
####################
build_data_frame <- function(type,
                             subjects, subject_names,
                             activity, activity_names,
                             summary,  summary_names,
                             summary_required){
  if(nrow(subjects) != nrow(activity) ||
     nrow(subjects) != nrow(summary)) {
    cat(paste("Error:",type,
              "Number of subjects rows:",  nrow(subjects),
                         "Number of activities rows:",nrow(activity),
                         "Number of summary rows",    nrow(summary),
                         "\n", sep=" "))
    return(NULL);
  }
  cat(paste("Building data frame:",type,
              "\n Number of subjects rows:",  nrow(subjects),
              "\n Number of activities rows:",nrow(activity),
              "\n Number of summary rows",    nrow(summary),
              "\n", sep=" ")); 
  colnames(summary)<-summary_names;
  summary<-summary[summary_required];
  
  ##return(summary);
  colnames(activity)<-activity_names;
  colnames(subjects)<-subject_names;
  
  df<-cbind(subjects,activity);
  df<-cbind(df,summary);
}

#########
#Capitalize the first letter of each word
#########
simpleCap <- function(x) {
  x<-tolower(x);
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}

#########
# Nicify the column Names to format ThisIsTheColName
# This is specific to this code, which replaces known
# non-nicities with nicities
#########
nicify <- function(x) {
  #Make a copy of the x variable
  new_x <- x;
  
  #Swap out -std()- with StDev
  new_x<-gsub("-std\\(\\)-",".StDev.",x);
  #Swap out -mean()- with Mean
  if(new_x == x) { new_x<-gsub("-mean\\(\\)-",".Mean.",x);}
  #Swap out -std()- with StDev
  if(new_x == x) { new_x<-gsub("-std\\(\\)",".StDev",x); }
  #Swap out -mean()- with Mean
  if(new_x == x) { new_x<-gsub("-mean\\(\\)",".Mean",x); }
  
  #Check if anything has happened, if so, we'll exit here:
  if(new_x != x) {
    #Change "t" to "Time."
    #Change "f" to "Freq."
    if(substr(new_x,1,1)=="t") {
      new_x<-paste("Time.",substring(new_x,2),sep=""); }
    if(substr(new_x,1,1)=="f") {
      new_x<-paste("Freq.",substring(new_x,2),sep=""); }
    
    return(new_x); }

  #Replace "_" with "."
  new_x<-gsub("_"," ",x);
  new_x<-simpleCap(new_x);
  new_x<-gsub(" ",".",new_x);
  
  new_x;
}
