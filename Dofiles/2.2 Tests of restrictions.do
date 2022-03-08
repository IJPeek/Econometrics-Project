/*
Author: Will Whiteley
Date created: 15/02/2022

Description: Tests for both over and under-identifying assumptions of the 2SLS specifications 
				- Note use of partial option for specs 2 and 4 where there are concerns with colinnearity. ageq and ageqsq are the variables partialled out
				- Also note when interpreting results that there is heteroskedasticity in specifications 3 and 4 and so these results are preferred
				- Create output using putexcel commands, becasue 'asdoc' and 'outreg' do not work for this type of result 


Last edited: 08/03/2022

*/


********************************************************************
******************************* PREP *******************************
********************************************************************


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

*********************
*** Spec 1 - Base ***
*********************
* Assuming Homoskedasticty
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
// Underidentification test LM stat = 147.164, p-value = 0.0000
// Sargan statistic (Overidentification) = 25.439, p-value = 0.6553
ereturn list
putexcel set $output/2.2_tests.xlsx, modify sheet("Spec 1 - Base")
putexcel A1 = "Test of restrictions for Specification 1 - Base", bold
putexcel B3 = "Test for Underidentification (i.e. Rank Condition)"
putexcel C4 = "Underidentification test Anderson LM statistic"
putexcel D4 = (e(idstat))
putexcel C5 = "P-value"
putexcel D5 = (e(idp))
putexcel C6 = "dof"
putexcel D6 = (e(iddf))

putexcel B8 = "Test of Overidentifying restrictions"
putexcel C9 = "Sargan overidentification statistic"
putexcel D9 = (e(sargan))
putexcel C10 = "P-value"
putexcel D10 = (e(sarganp))
putexcel C11 = "dof"
putexcel D11 = (e(sargandf))

* Allowing for Heteroskedasticity
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), robust
// K-P LM test stat = 143.863, p-value = 0.0000
// Hansen J stat = 24.653, p-value = 0.6961
ereturn list
putexcel B14 = "Test for Underidentification (i.e. Rank Condition)"
putexcel C15 = "Underidentification test Kleibergen-Papp LM statistic"
putexcel D15 = (e(idstat))
putexcel C16 = "P-value"
putexcel D16 = (e(idp))
putexcel C17 = "dof"
putexcel D17 = (e(iddf))

putexcel B19 = "Test of Overidentifying restrictions"
putexcel C20 = "Hansen J-statistic"
putexcel D20 = (e(j))
putexcel C21 = "P-value"
putexcel D21 = (e(jp))
putexcel C22 = "dof"
putexcel D22 = (e(jdf))

*****************************
*** Spec 2 - Age controls ***
*****************************
* Assuming Homoskedasticty
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
// Underidentification test LM stat = 45.178, p-value = 0.0212
// Sargan statistic (Overidentification) = 22.853, p-value = 0.6412
ereturn list
putexcel set $output/2.2_tests.xlsx, modify sheet("Spec 2 - Age Controls")
putexcel A1 = "Test of restrictions for Specification 2 - Age Controls", bold
putexcel B3 = "Test for Underidentification (i.e. Rank Condition)"
putexcel C4 = "Underidentification test Anderson LM statistic"
putexcel D4 = (e(idstat))
putexcel C5 = "P-value"
putexcel D5 = (e(idp))
putexcel C6 = "dof"
putexcel D6 = (e(iddf))

putexcel B8 = "Test of Overidentifying restrictions"
putexcel C9 = "Sargan overidentification statistic"
putexcel D9 = (e(sargan))
putexcel C10 = "P-value"
putexcel D10 = (e(sarganp))
putexcel C11 = "dof"
putexcel D11 = (e(sargandf))

* Allowing for Heteroskedasticity
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), robust partial(ageq ageqsq)
* NOTE: partial option used to avoid errors with J-stat. By FWL Theorem this should have no effect on coefficients
// K-P LM test stat = 44.545, p-value = 0.0245
// Hansen J stat = 22.467, p-value = 0.7133
ereturn list
putexcel B14 = "Test for Underidentification (i.e. Rank Condition)"
putexcel C15 = "Underidentification test Kleibergen-Papp LM statistic"
putexcel D15 = (e(idstat))
putexcel C16 = "P-value"
putexcel D16 = (e(idp))
putexcel C17 = "dof"
putexcel D17 = (e(iddf))

putexcel B19 = "Test of Overidentifying restrictions"
putexcel C20 = "Hansen J-statistic"
putexcel D20 = (e(j))
putexcel C21 = "P-value"
putexcel D21 = (e(jp))
putexcel C22 = "dof"
putexcel D22 = (e(jdf))
putexcel B23 = "NOTE: Partial option used for ageq and agesq"

**************************************************
*** Spec 3 - Location and demographic controls ***
**************************************************

* Assuming Homoskedasticty
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
// Underidentification test LM stat = 142.381, p-value = 0.0000
// Sargan statistic (Overidentification) = 22.487, p-value = 0.7995
ereturn list
putexcel set $output/2.2_tests.xlsx, modify sheet("Spec 3 - Location Controls")
putexcel A1 = "Test of restrictions for Specification 3 - Location and demographic controls", bold
putexcel B3 = "Test for Underidentification (i.e. Rank Condition)"
putexcel C4 = "Underidentification test Anderson LM statistic"
putexcel D4 = (e(idstat))
putexcel C5 = "P-value"
putexcel D5 = (e(idp))
putexcel C6 = "dof"
putexcel D6 = (e(iddf))

putexcel B8 = "Test of Overidentifying restrictions"
putexcel C9 = "Sargan overidentification statistic"
putexcel D9 = (e(sargan))
putexcel C10 = "P-value"
putexcel D10 = (e(sarganp))
putexcel C11 = "dof"
putexcel D11 = (e(sargandf))

* Allowing for Heteroskedasticity
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), robust
// K-P LM test stat = 138.565, p-value = 0.0000
// Hansen J stat = 21.979, p-value = 0.8211
ereturn list
putexcel B14 = "Test for Underidentification (i.e. Rank Condition)"
putexcel C15 = "Underidentification test Kleibergen-Papp LM statistic"
putexcel D15 = (e(idstat))
putexcel C16 = "P-value"
putexcel D16 = (e(idp))
putexcel C17 = "dof"
putexcel D17 = (e(iddf))

putexcel B19 = "Test of Overidentifying restrictions"
putexcel C20 = "Hansen J-statistic"
putexcel D20 = (e(j))
putexcel C21 = "P-value"
putexcel D21 = (e(jp))
putexcel C22 = "dof"
putexcel D22 = (e(jdf))

*****************************
*** Spec 4 - All controls ***
*****************************
* Assuming Homoskedasticty
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
// Underidentification test LM stat = 45.167, p-value = 0.0212
// Sargan statistic (Overidentification) = 19.299, p-value = 0.8236
ereturn list
putexcel set $output/2.2_tests.xlsx, modify sheet("Spec 4 - ALL Controls")
putexcel A1 = "Test of restrictions for Specification 4 - All Controls", bold
putexcel B3 = "Test for Underidentification (i.e. Rank Condition)"
putexcel C4 = "Underidentification test Anderson LM statistic"
putexcel D4 = (e(idstat))
putexcel C5 = "P-value"
putexcel D5 = (e(idp))
putexcel C6 = "dof"
putexcel D6 = (e(iddf))

putexcel B8 = "Test of Overidentifying restrictions"
putexcel C9 = "Sargan overidentification statistic"
putexcel D9 = (e(sargan))
putexcel C10 = "P-value"
putexcel D10 = (e(sarganp))
putexcel C11 = "dof"
putexcel D11 = (e(sargandf))

* Allowing for Heteroskedasticity
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), robust partial(ageq ageqsq)
* NOTE: partial option used to avoid errors with J-stat. By FWL Theorem this should have no effect on coefficients
// K-P LM test stat = 44.193, p-value = 0.0266
// Hansen J stat = 19.184, p-value = 0.8632
ereturn list
putexcel B14 = "Test for Underidentification (i.e. Rank Condition)"
putexcel C15 = "Underidentification test Kleibergen-Papp LM statistic"
putexcel D15 = (e(idstat))
putexcel C16 = "P-value"
putexcel D16 = (e(idp))
putexcel C17 = "dof"
putexcel D17 = (e(iddf))

putexcel B19 = "Test of Overidentifying restrictions"
putexcel C20 = "Hansen J-statistic"
putexcel D20 = (e(j))
putexcel C21 = "P-value"
putexcel D21 = (e(jp))
putexcel C22 = "dof"
putexcel D22 = (e(jdf))
putexcel B23 = "NOTE: Partial option used for ageq and agesq"


**********************************************************************
**************************** Conclusions *****************************
**********************************************************************
/*
Test for under-identifying assumptions
	- The test statistics for each of these specifications are large, so the probability that we observe the data we do under the Null of underidentification is very low (either 0% or 2.1%). This means that we reject the null hypothesis and say that
		* The rank condition is satisfied
		* The coefficients are identified (i.e. not =0)
		
Overidenfication test of all instruments
	- The test statistics for each of these specifications are relatively small, meaning that the p-values are large (64-82%). The probability that we observe the data we do under the model assumptions (e.g. orthogonality, parameter heterogeneity) are high, so we cannot reject the null hypothesis of all these assumptions, particular the exclusion restriction
	- This suggests that are model assumptions are good (yay)
*/		
