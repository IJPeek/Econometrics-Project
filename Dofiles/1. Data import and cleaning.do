/*
Author: Isabelle Peek
Date created: 14th Jan 2022

Description: This dofile imports, renames, labels and saves the Angrist Krueger 1991 dataset.

Last edited: 8th Feb 2022, WHW - I have just changed this woop wooop wooop (8/2/22, thanks so much for the snacks IJPeek)

Sections.
	1. Import and rename 
	2. Labeling Variables
	34.htrhtrh
*/



******************************************************************************
**						1. Import and rename								**
******************************************************************************



infile v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 using "$raw/QOB.raw", clear
save "$raw/QOB.dta"

// a larger dataset on their website use "$raw/NEW7080.dta", clear


foreach data in NEW7080 QOB{
use "$raw/`data'.dta", clear


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



//convention to work in lowercase in stata, lowercase variable names
rename _all, lower


save "$temp/`data'.dta", replace
}
**************************************************************************

