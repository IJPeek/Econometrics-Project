/*
Author: Evan M. Bennett
Date created: 16th Feb. 2022

Description: This dofile performs a test of weak instruments on the AK Data set to be used throughout this project.

Last edited: 9th March 2022, E. M. Bennett 


Sections.
	1. Install Necessary Packages
	2. Olea/Pflueger test for Weak Instruments
*/



******************************************************************************
**						1. Install Necessary Packages  						**
******************************************************************************
/*
NOTES: SECTION 1 IS ONLY NEEDED THE FIRST TIME THE DOFILE IS RUN.
		White's Test for Heteroskedasticity must be conducted before Olea & Pflueger's Test for Weak Instruments is run.  See "2.1 White het test"

In the Author's own words:
"The Stata module WEAKIVTEST implements the weak instrument test of Montiel Olea and Pflueger (Journal of Business and Economic Statistics, 2013) that is robust to heteroskedasticity, serial correlation, and clustering." (Pflueger, 2015)
*/
ssc install weakivtest
ssc install avar
ssc install ivreg2
ssc install ranktest

******************************************************************************
**                 2. Olea/Pflueger test for Weak Instruments				**
**                    & Generating Descriptive Tables  		  	 		    **
******************************************************************************
run "$dofile/1.2 Creating Instrumental variables.do"

keep if cohort>30.00 & cohort<30.40
**Specification 1**
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
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
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
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
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
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
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
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
