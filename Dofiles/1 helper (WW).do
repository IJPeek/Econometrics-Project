/*
SGPE Econometrics Project 2022 - Group 1 (Will W edits)
Date of download: 04/01/2022

Description: Starts by cleaning the data provided by the A&K website

Date of last edits: 05/01/2022

*/

***** Setup and Globals *****
clear
clear matrix
capture log close
set more off
* version 17

* global

use "C:\Users\willi\OneDrive\___ POSTGRAD\MSc Econ\Metrics Project\NEW7080.dta"

***** Tidying the variables *****
// Variable renaming and labelling comes from online information, and also the original A&K 1991 paper. 
// Have amended variables which I am confident about, and removed some which are not immediately relevant. Further notes below

rename v1 AGE
rename v2 AGEQ

rename v4 educ
label variable educ "Years of schooling completed"

rename v9 lnwklywage
label variable lnwklywage "Weekly earnings, computed by dividing annual earnings by annual weeks worked"

rename v10 married
label variable married "=1 if respondent is married with his spouse present"

rename v16 census
label variable census "Which census the respondent appears in - 1970 or 1980"

rename v18 qob
label variable qob "Quarter of birth"

rename v19 race
label variable race "=1 if Black, =0 otherwise"

rename v20 smsa
label variable smsa "=1 if respondent works in an city centre i.e. SMSA (Standard Metropolitan Statistical Area)"

rename v27 YOB

// Looks like v22 and v23 represent State somehow
// There are 8 region of residence dummies, which are renamed as
	* v5 - ENOCENT - East North Central States
	* v6 - ESOCENT - East South-Central States
	* v11 - MIDATL - Mid-Atlantic States
	* v12 - MT - Mountain States
	* v13 - NEWENG - New England States
	* v21 - SOATL - South Atlantic States
	* v24 - WNOCENT - West North Central States
	* V25 - WSOCENT - West South Central States
// This regional division appears to be based on the Census regions and divisions. But according to Wiki there are 9 of these. The one that is potentially missing is Pacific (Alaska, California, Hawaii, Oregon and Washington). This system is widely used

gen region = 0
replace region = 1 if v5 == 1
replace region = 2 if v6 == 1
replace region = 3 if v11 == 1
replace region = 4 if v12 == 1
replace region = 5 if v13 == 1
replace region = 6 if v21 == 1
replace region = 7 if v24 == 1
replace region = 8 if v25 == 1
label define region 1 "East North Central States" 2  "East South Central States" 3 "Mid-Atlantic States" 4 "Mountain States" 5 "New England States" 6 "South Atlantic States" 7 "West North Central States" 8 "West South Central States"
label values region region
// Check what the populations of the regions actually are
tab region
	* Must be that the Pacific region does not have a dummy variable, and so whatever is coded as 0 in the new region variable represents observations from Pacific region

rename v5 ENOCENT
rename v6 ESOCENT
rename v11 MIDATL
rename v12 MT
rename v13 NEWENG
rename v21 SOATL
rename v24 WNOCENT
rename v25 WSOCENT
	
order v*, last

***** Descriptive Stats *****

hist educ, bin(20) title("Years of eduction completed")

hist lnwklywage, title("Weakly earnings")




