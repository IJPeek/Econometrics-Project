************************************
*************** PREP ***************
************************************


*** Run setup do file ***
	* Edit this out as needed and depending on user
run "C:\Users\willi\OneDrive\Attachments\Documents\GitHub\Econometrics-Project\Dofiles\_setup_WW.do"

*** Get cleaned and named dataset ***
use "$temp/QOB.dta", clear 

*** Run the file to create instrumental variables ***
run "$dofile/1.2 Creating Instrumental variables.do"

* Restricting the observations just to the cohort that we want to consider for Table V analysis
keep if COHORT>30.00 & COHORT <30.40


**********************************************************************
*************** Test for Under-identifying assumptions ***************
**********************************************************************


*** These are the regressions specified by the authors (in lowercase)***
ivregress 2sls lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
ivregress 2sls lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
ivregress 2sls lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
ivregress 2sls lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)


