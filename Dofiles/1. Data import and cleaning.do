/*

Description: This dofile imports, renames, labels and saves the Angrist Krueger 1991 datasets.

Sections.
	1. Import and rename 
	2. Labeling Variables
	3. Creating Variables (AK DoFiles) and saving datasets
*/



******************************************************************************
**						1. Import and rename								**
******************************************************************************

// Imports raw data from https://economics.mit.edu/faculty/angrist/data1/data/angkru1991 
clear
infile v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 using "$raw/QOB.raw", clear

//These are from the AK website RENAMING THE FILE:
rename v1 AGE
rename v2 AGEQ
rename v4 EDUC
rename v5 ENOCENT
rename v6 ESOCENT
rename v9 LWKLYWGE
rename v10 MARRIED
rename v11 MIDATL
rename v12 MT
rename v13 NEWENG
rename v16 CENSUS
rename v18 QOB
rename v19 RACE
rename v20 SMSA
rename v21 SOATL
rename v24 WNOCENT
rename v25 WSOCENT
rename v27 YOB

//not from AK but our guess
rename v22 STATE
rename v15 PAC

drop v3 v7 v8 v14 v17 v23 v26




*******************************************************************************
**						2. Labeling variables								 **
******************************************************************************


// used descritptions of some labels from https://rdrr.io/github/kolesarm/ManyIV/man/ak80.html

label var AGE "Age, measured at quarterly precision"
label var EDUC "Years of education"
label var ENOCENT "=1 if respondent is from East North Central States"
label var ESOCENT "=1 if respondent is from East North Central States"
label var LWKLYWGE "Log of weekly wage"

label var MARRIED "=1 if respondent is married with his spouse present, Indicator for being married"
label var MIDATL "=1 if respondent is from Mid-Atlantic States"
label var MT "=1 if respondent is from Mountain States"
label var NEWENG "=1 if respondent is from New England States"
label var PAC "=1 if respondent is from Pacific or other"
label var CENSUS "Which census the respondent appears in - 1970 or 1980"
label var QOB "Quarter of birth"

codebook RACE
label var RACE "=1 if black, =0 otherwise, Indicator for being black"
label var SMSA "=1 if respondent works in a city centre i.e. SMSA (Standard Metropolitan Statistical Area). Geographical region with a relatively high population density"

label var YOB "Year of birth"
label var SOATL "=1 if respondent is from South Atlantic States"
label var STATE "An index for different states, there are 56"
label var WNOCENT "=1 if respondent is from West North Central States"
label var WSOCENT "=1 if respondent is from West South Central States"


label var CENSUS "Which census year the data was collected from, 1970 or 1980"
	// From using the command br, and looking at the data i think:
label var AGEQ "Age, including months eg age 40.24"


******************************************************************************
** 		 3. Creating Variables (AK DoFiles) and saving datasets				**
******************************************************************************

**This section makes the instruments: this is code taken from AK91s Online Dofiles for their Table V output

gen COHORT=20.29
replace COHORT=30.39 if YOB<=39 & YOB >=30
replace COHORT=40.49 if YOB<=49 & YOB >=40
replace AGEQ=AGEQ-1900 if CENSUS==80
gen AGEQSQ= AGEQ*AGEQ

** Generate YOB dummies **********
gen YR20=0  
replace YR20=1 if YOB==1920  
replace YR20=1 if YOB==30 
replace YR20=1 if YOB==40 
gen YR21=0  
replace YR21=1 if YOB==1921  
replace YR21=1 if YOB==31
replace YR21=1 if YOB==41 
gen YR22=0  
replace YR22=1 if YOB==1922  
replace YR22=1 if YOB==32 
replace YR22=1 if YOB==42 
gen YR23=0  
replace YR23=1 if YOB==1923 
replace YR23=1 if YOB==33 
replace YR23=1 if YOB==43 
gen YR24=0  
replace YR24=1 if YOB==1924  
replace YR24=1 if YOB==34 
replace YR24=1 if YOB==44 
gen YR25=0  
replace YR25=1 if YOB==1925  
replace YR25=1 if YOB==35 
replace YR25=1 if YOB==45 
gen YR26=0  
replace YR26=1 if YOB==1926  
replace YR26=1 if YOB==36 
replace YR26=1 if YOB==46 
gen YR27=0  
replace YR27=1 if YOB==1927  
replace YR27=1 if YOB==37 
replace YR27=1 if YOB==47 
gen YR28=0  
replace YR28=1 if YOB==1928  
replace YR28=1 if YOB==38 
replace YR28=1 if YOB==48 
gen YR29=0  
replace YR29=1 if YOB==1929  
replace YR29=1 if YOB==39 
replace YR29=1 if YOB==49 

** Generate QOB dummies ***********
gen QTR1=0
replace QTR1=1 if QOB==1
gen QTR2=0
replace QTR2=1 if QOB==2
gen QTR3=0
replace QTR3=1 if QOB==3
gen QTR4=0
replace QTR4=1 if QOB==4

** Generate YOB*QOB dummies ********
gen QTR120= QTR1*YR20
gen QTR121= QTR1*YR21
gen QTR122= QTR1*YR22
gen QTR123= QTR1*YR23
gen QTR124= QTR1*YR24
gen QTR125= QTR1*YR25
gen QTR126= QTR1*YR26
gen QTR127= QTR1*YR27
gen QTR128= QTR1*YR28
gen QTR129= QTR1*YR29

gen QTR220= QTR2*YR20
gen QTR221= QTR2*YR21
gen QTR222= QTR2*YR22
gen QTR223= QTR2*YR23
gen QTR224= QTR2*YR24
gen QTR225= QTR2*YR25
gen QTR226= QTR2*YR26
gen QTR227= QTR2*YR27
gen QTR228= QTR2*YR28
gen QTR229= QTR2*YR29

gen QTR320= QTR3*YR20
gen QTR321= QTR3*YR21
gen QTR322= QTR3*YR22
gen QTR323= QTR3*YR23
gen QTR324= QTR3*YR24
gen QTR325= QTR3*YR25
gen QTR326= QTR3*YR26
gen QTR327= QTR3*YR27
gen QTR328= QTR3*YR28
gen QTR329= QTR3*YR29
rename _all, lower


keep if cohort>30.00 & cohort<30.40 // This is the cohort we are considering in the paper, the 1930-1939 cohort. So keeping these observations.

//convention to work in lowercase in stata, lowercase variable names
rename _all, lower


save "$temp/QOB.dta", replace


