// This dofile is a set up dofile

*** Setup ***
clear
clear matrix
capture log close
set more off
* version 17 -- not sure if we want to do this in case other people's are different

*** Globals ***
// Creating global macros that correspond to our folder structure

global file C:\Users\willi\OneDrive\Attachments\Documents\GitHub\Econometrics-Project
global dofile $file/Dofiles //where we store our dofiles
global raw $file/Data/Raw //where we store our raw data that we do NOT edit
global temp $file/Data/Temp //where we save any data we have altered from the raw data 
global logs $file/Logs
global output $file/Output


