/*
Author: Will Whiteley
Date created: 15/02/2022

Description: Tests for both over and under-identifying assumptions of the 2SLS specifications 

Last edited: 28/02/2022

*/


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
keep if cohort>30.00 & cohort <30.40

* Installing the packages that are required
*** NOTE: This will only be necessary the first time the code is run on any system
ssc install ivreg2
ssc install outreg2

**********************************************************************
*************************** IV regressions ***************************
**********************************************************************

/*
*** These are the regressions specified by the authors (in lowercase)***
ivregress 2sls lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
ivregress 2sls lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
ivregress 2sls lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
ivregress 2sls lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)

	- We won't run these as the command does not include all the tests that we want to know about
*/

********** Reressions that we want to do using ivreg2 instead **********
*** Spec 1 - Base
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
// Underidentification test LM stat = 147.164, p-value = 0.0000
// Sargan statistic (Overidentification) = 25.439, p-value = 0.6553
* Creating output (asdoc and outreg do not work for this type of result)
ereturn list
putexcel set $output/2.2_tests.xlsx, replace sheet("Spec 1 - Base", replace)
putexcel A1 = "Test of restrictions for Specification 1 - Base", bold
putexcel B3 = "Test for Under-identifying assumptions"
putexcel C4 = "Underidentification test LM statistic"
putexcel D4 = (e(idstat))
putexcel C5 = "P-value"
putexcel D5 = (e(idp))
putexcel C6 = "dof"
putexcel D6 = (e(iddf))

putexcel B8 = "Test of Overidentifying restrictions"
putexcel C9 = "Sargan J statistic"
putexcel D9 = (e(sargan))
putexcel C10 = "P-value"
putexcel D10 = (e(sarganp))
putexcel C11 = "dof"
putexcel D11 = (e(sargandf))

*** Spec 2 - Age controls
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
// Underidentification test LM stat = 45.178, p-value = 0.0212
// Sargan statistic (Overidentification) = 22.853, p-value = 0.6412
ereturn list
putexcel set $output/2.2_tests.xlsx, modify sheet("Spec 2 - Age Controls", replace)
putexcel A1 = "Test of restrictions for Specification 2 - Age Controls", bold
putexcel B3 = "Test for Under-identifying assumptions"
putexcel C4 = "Underidentification test LM statistic"
putexcel D4 = (e(idstat))
putexcel C5 = "P-value"
putexcel D5 = (e(idp))
putexcel C6 = "dof"
putexcel D6 = (e(iddf))

putexcel B8 = "Test of Overidentifying restrictions"
putexcel C9 = "Sargan J statistic"
putexcel D9 = (e(sargan))
putexcel C10 = "P-value"
putexcel D10 = (e(sarganp))
putexcel C11 = "dof"
putexcel D11 = (e(sargandf))


* Spec 3 - Location and demographic controls
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
// Underidentification test LM stat = 142.381, p-value = 0.0000

// Sargan statistic (Overidentification) = 22.487, p-value = 0.7995

* Spec 4 - All controls
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
// Underidentification test LM stat = 45.167, p-value = 0.0212

// Sargan statistic (Overidentification) = 19.299, p-value = 0.8236


**********************************************************************
**************************** Conclusions *****************************
**********************************************************************
/*
Test for under-identifying assumptions
	- The test statistics for each of these specifications are large, so the probability that we observe the data we do under the Null of underidentification is very low (either 0% or 2.1%). This means that we reject the null hypothesis and say that
		* The rank condition is satisfied
		* The coefficients are identified (i.e. not =0)
		
Overidenfication test of all instruments
	- The test statistics for each of these specifications are relatively small, meaning that the p-values are large (64-82%). The probability that we observe the data we do under the model assumptions (e.g. orthogonality, parameter heterogeneity) are high, so we cannot reject the null hypothesis
	- This suggests that are model assumptions are good (yay)
*/		