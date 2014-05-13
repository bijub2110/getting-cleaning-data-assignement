Getting and Cleaning Data Peer Assignement
==========================================

The following files are in scope of this assignement:
  - run_analysis.R
    Read datasets from the Internet and execute the tasks asked by the assgnement. 
    See below for a detailled description of the steps executed by run_analysis.R
  - Dataset.dat
    Resulting tidy dataset as per assignement.
  - CodeBook.md
    Description of Dataset.dat.
    
The following steps were performed to generate Dataset.set:
  - Download an unzip the zip file provided.
  - Generate the train and test dataset.
  - Merge with names read from activity_labels.
  - Merge train and test Datasets
  - Select the relevant variables (features means and variances)
  - Create the result Dataset

These steps are clearly documented in run_analysis.R
