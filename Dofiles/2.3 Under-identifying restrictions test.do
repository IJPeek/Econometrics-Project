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


**********************************************************************
*************** Test for Under-identifying assumptions ***************
**********************************************************************


*** These are the regressions specified by the authors (in lowercase)***
ivregress 2sls lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
ivregress 2sls lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
ivregress 2sls lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
ivregress 2sls lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)

*** Reressions that we want to do using ivreg2 instead ***
* Spec 1
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
// Underidentification test LM stat = 147.164, p-value = 0.0000

// Sargan statistic (Overidentification) = 25.439, p-value = 0.6553

* Spec 2
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
// Underidentification test LM stat = 45.178, p-value = 0.0212

// Sargan statistic (Overidentification) = 22.853, p-value = 0.6412


* Spec 3
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
// Underidentification test LM stat = 142.381, p-value = 0.0000

// Sargan statistic (Overidentification) = 22.487, p-value = 0.7995

* Spec 4
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
// Underidentification test LM stat = 45.167, p-value = 0.0212

// Sargan statistic (Overidentification) = 19.299, p-value = 0.8236

/**** Conclusions ****
Underidentification Test
	- The test statistics for each of these specifications are large, so the probability that we observe the data we do under the Null of underidentification is very low (either 0% or 2.1%). This means that we reject the null hypothesis and say that
		* The rank condition is satisfied
		* The coefficients are identified (i.e. not =0)
		
Overidenfication test of all instruments
	- The test statistics for each of these specifications are relatively small, meaning that the p-values are large (64-82%). The probability that we observe the data we do under the model assumptions (e.g. orthogonality, parameter heterogeneity) are high, so we cannot reject the null hypothesis
	- This suggests that are model assumptions are good (yay)
*/		