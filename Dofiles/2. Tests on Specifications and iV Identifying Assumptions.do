/*
Description: This do file runs the IV specifications and carries out the tests on the specification that we refer to in our paper

Sections:
	1. 2SLS Estimation and White Tests for Heteroskedasticity
	2. Tests for under and overidentifying restriction
	3. Test of weak instruments
*/

/*
*** These are the regressions specified by the authors (in lowercase)***
ivregress 2sls lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
ivregress 2sls lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
ivregress 2sls lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
ivregress 2sls lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)

	- We won't run these as the ivregress command does not include all the tests that we want to know about
	- We also note that when using ivreg2 there is no need to state the included instruments i.e. yr20-yr28 within the brackets, and so to improve computational efficiency we will remove these
*/


// Loading data
use "$temp/QOB.dta", clear

//Install Necessary programmes 
* NOTE: THIS PART IS ONLY NEEDED THE FIRST TIME THE DOFILE IS RUN.
ssc install ivreg2
ssc install ivhettest
ssc install outreg2
ssc install weakivtest
ssc install avar
ssc install ranktest

**********************************************************************************
******** 1. 2SLS Estimation and White Tests for Heteroskedasticity		**********
**********************************************************************************

**Specification 1**
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)
outreg2 using stata_outputs.doc, replace ctitle(Specification 1: 2SLS)

//Test for heteroskedasticity
ivhettest

**Specification 2**
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)
outreg2 using stata_outputs.doc, append ctitle(Specification 2: 2SLS)

//Test for heteroskedasticity
ivhettest

**Specification 3**
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)

//Test for heteroskedasticity
ivhettest

//We find heteroskedasticity so we report the robust version in our results
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), robust
outreg2 using stata_outputs.doc, append ctitle(Specification 3: 2SLS robust)


**Specification 4**
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)

//Test for heteroskedasticity
ivhettest

//We find heteroskedasticity so we report the robust version in our results. For spec 4 we use the partial out option to avoid collinearity problems. 
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), robust partial(ageq ageqsq)
outreg2 using stata_outputs.doc, append ctitle(Specification 4: 2SLS robust)


********************************************************************************
**				2. Tests for under and overidentifying restrictions			  **
********************************************************************************


*********************
*** Spec 1 - Base ***
*********************
* Assuming Homoskedasticty
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)
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
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), robust
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
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)  partial (ageq ageqsq)
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
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), robust partial(ageq ageqsq)
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
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)
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
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), robust
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
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)
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
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), robust partial(ageq ageqsq)
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



*** Conclusions ***
/*
Test for under-identifying assumptions
	- The test statistics for each of these specifications are large, so the probability that we observe the data we do under the Null of underidentification is very low (either 0% or 2.1%). This means that we reject the null hypothesis and say that
		* The rank condition is satisfied
		* The coefficients are identified (i.e. not =0)
		
Overidenfication test of all instruments
	- The test statistics for each of these specifications are relatively small, meaning that the p-values are large (64-82%). The probability that we observe the data we do under the model assumptions (e.g. orthogonality, parameter heterogeneity) are high, so we cannot reject the null hypothesis of all these assumptions, particular the exclusion restriction
	- This suggests that are model assumptions are good (yay)
*/		

**************************************************
**********	3. Test of weak instruments	**********
**************************************************

/*
White's Test for Heteroskedasticity must be conducted before Olea & Pflueger's Test for Weak Instruments is run.  See "2.1 White het test"

In the Author's own words:
"The Stata module WEAKIVTEST implements the weak instrument test of Montiel Olea and Pflueger (Journal of Business and Economic Statistics, 2013) that is robust to heteroskedasticity, serial correlation, and clustering." (Pflueger, 2015)
*/


**********************************************
**  Olea/Pflueger test for Weak Instruments	**
**      & Generating Descriptive Tables  	**
**********************************************

**Specification 1**
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)
weakivtest  
putexcel set $output/MPSpec1.xlsx, replace
putexcel B1 = "Montiel-Pflueger Robust Weak Instrument Test For Specification 1"
putexcel B2 = "Effective F Statistic:"
putexcel B3 = (r(F_eff))
putexcel B4 = "Confidence level alpha"
putexcel C4 = (r(level))
putexcel B5 = "Critical Values"
putexcel E5 = "TSLS"
putexcel G5 = "LIML"
putexcel B6 = "% of Worst-Case Bias"
putexcel B7 = "tau=5%"
putexcel E7 = (r(c_TSLS_5))
putexcel G7 = (r(c_LIML_5))
putexcel B8 = "tau=10%"
putexcel E8 = (r(c_TSLS_10))
putexcel G8 = (r(c_LIML_10))
putexcel B9 = "tau=20%"
putexcel E9 = (r(c_TSLS_20))
putexcel G9 = (r(c_LIML_20))
putexcel B10 = "tau=30%"
putexcel E10 = (r(c_TSLS_30))
putexcel G10 = (r(c_LIML_30))

**Specification 2**
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)
weakivtest
putexcel set $output/MPSpec2.xlsx, replace
putexcel B1 = "Montiel-Pflueger Robust Weak Instrument Test For Specification 2"
putexcel B2 = "Effective F Statistic:"
putexcel B3 = (r(F_eff))
putexcel B4 = "Confidence level alpha"
putexcel C4 = (r(level))
putexcel B5 = "Critical Values"
putexcel E5 = "TSLS"
putexcel G5 = "LIML"
putexcel B6 = "% of Worst-Case Bias"
putexcel B7 = "tau=5%"
putexcel E7 = (r(c_TSLS_5))
putexcel G7 = (r(c_LIML_5))
putexcel B8 = "tau=10%"
putexcel E8 = (r(c_TSLS_10))
putexcel G8 = (r(c_LIML_10))
putexcel B9 = "tau=20%"
putexcel E9 = (r(c_TSLS_20))
putexcel G9 = (r(c_LIML_20))
putexcel B10 = "tau=30%"
putexcel E10 = (r(c_TSLS_30))
putexcel G10 = (r(c_LIML_30))

**Specification 3**
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)
weakivtest
putexcel set $output/MPSpec3.xlsx, replace
putexcel B1 = "Montiel-Pflueger Robust Weak Instrument Test For Specification 3"
putexcel B2 = "Effective F Statistic:"
putexcel B3 = (r(F_eff))
putexcel B4 = "Confidence level alpha"
putexcel C4 = (r(level))
putexcel B5 = "Critical Values"
putexcel E5 = "TSLS"
putexcel G5 = "LIML"
putexcel B6 = "% of Worst-Case Bias"
putexcel B7 = "tau=5%"
putexcel E7 = (r(c_TSLS_5))
putexcel G7 = (r(c_LIML_5))
putexcel B8 = "tau=10%"
putexcel E8 = (r(c_TSLS_10))
putexcel G8 = (r(c_LIML_10))
putexcel B9 = "tau=20%"
putexcel E9 = (r(c_TSLS_20))
putexcel G9 = (r(c_LIML_20))
putexcel B10 = "tau=30%"
putexcel E10 = (r(c_TSLS_30))
putexcel G10 = (r(c_LIML_30))

**Specification 4**
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)
weakivtest
putexcel set $output/MPSpec4.xlsx, replace
putexcel B1 = "Montiel-Pflueger Robust Weak Instrument Test For Specification 4"
putexcel B2 = "Effective F Statistic:"
putexcel B3 = (r(F_eff))
putexcel B4 = "Confidence level alpha"
putexcel C4 = (r(level))
putexcel B5 = "Critical Values"
putexcel E5 = "TSLS"
putexcel G5 = "LIML"
putexcel B6 = "% of Worst-Case Bias"
putexcel B7 = "tau=5%"
putexcel E7 = (r(c_TSLS_5))
putexcel G7 = (r(c_LIML_5))
putexcel B8 = "tau=10%"
putexcel E8 = (r(c_TSLS_10))
putexcel G8 = (r(c_LIML_10))
putexcel B9 = "tau=20%"
putexcel E9 = (r(c_TSLS_20))
putexcel G9 = (r(c_LIML_20))
putexcel B10 = "tau=30%"
putexcel E10 = (r(c_TSLS_30))
putexcel G10 = (r(c_LIML_30))

*
*
*** END OF DO FILE ***
