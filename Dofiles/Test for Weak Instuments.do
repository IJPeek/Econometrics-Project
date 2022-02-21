/*
Author: Evan M. Bennett
Date created: 16th Feb. 2022

Description: This dofile performs a test of weak instruments on the AK Data set to be used throughout this project.

Last edited: 16th Feb 2022, E Bennett 

Sections.
	1. Install weakiv Package
	2. Olea/Pflueger test for Weak Instruments
*/



******************************************************************************
**						1. Install Necessary Packages  						**
******************************************************************************
/*
NOTE: SECTION 1 IS ONLY NEEDED THE FIRST TIME THE DOFILE IS RUN.
In the Author's own words:
"The Stata module WEAKIVTEST implements the weak instrument test of Montiel Olea and Pflueger (Journal of Business and Economic Statistics, 2013) that is robust to heteroskedasticity, serial correlation, and clustering." (Pflueger, 2015)
*/
ssc install weakivtest
ssc install avar
ssc install ivreg2
ssc install ranktest
******************************************************************************
**                 2. Olea/Pflueger test for Weak Instruments  	 		    **
******************************************************************************

**Specification 1**
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
weakivtest  

**Specification 2**
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
weakivtest

**Specification 3**
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
weakivtest

**Specification 4**
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
weakivtest