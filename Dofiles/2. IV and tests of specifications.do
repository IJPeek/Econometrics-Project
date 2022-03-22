/*
Author: Group 14
Date created: 15/02/22

Description: Running the IV 

Last edited: 22/03/2022

*/
********************************************************************************
						//IV ESTIMATOR for table V//
						//estimator is based on homoskedasticity//
						//contains all the tests in its output//
********************************************************************************


//create all the instruments and loading data
run "$dofile/1.2 Creating Instrumental variables.do"


//install ivreg2 

//select correct cohort//
keep if cohort>30.00 & cohort <30.40




/*specification 1*/
ivreg2 lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
est store basespec

/*specification 2*/
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), partial(ageq ageqsq)
est store agespec

/*specification 3*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), robust 
est store locationspec

/*specification 4*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), partial(ageq ageqsq) robust 
est store all

/*collecting results together*/
est table basespec agespec locationspec all, b(%7.4f) star




