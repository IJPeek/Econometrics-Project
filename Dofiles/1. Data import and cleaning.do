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

// a larger dataset on their website use "$raw/NEW7080.dta", clear

use "$raw/NEW7080.dta", clear

//infile v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 using "$raw/QOB.raw", clear

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


*******************************************************************************
**						2. Labeling variables								 **
******************************************************************************


// used descritptions of some labels from https://rdrr.io/github/kolesarm/ManyIV/man/ak80.html

label var AGE "Age, measured at quarterly precision"
label var EDUC "Years of education"
label var LWKLYWGE "Log of weekly wage"
label var MARRIED "Indicator for being married"
label var QOB "Quarter of birth"

// dont know what race is
codebook RACE
	// codebook summarises data
	// Here we can see it takes on the values of 0 and 1 
	// The majority of obvs are 0, given this is the US we can conclude 0-w 1-b
label var RACE "Indicator for being black"
label var SMSA "SMSA indicator: a geographical region with a relatively high population density"
// https://en.wikipedia.org/wiki/Metropolitan_statistical_area
label var YOB "Year of birth"

codebook CENSUS
// Two values 70 and 80


	// From using the command br, and looking at the data i think:
label var AGEQ "Age, including months eg age 40.24"
// Note AGE actually rounds down the AGEQ, we should work out the effect of this and make sure it doesnt skew their results if they use AGE.. the authors do things like age 49.75 and then would round that down to 49 (but then again that is how age works)

codebook v17
// 99 values
codebook v17 if CENSUS==80
codebook v17 if CENSUS==70

/*
sob
State of birth
division
Census division
*/


//convention to work in lowercase in stata, lowercase variable names
rename _all, lower


