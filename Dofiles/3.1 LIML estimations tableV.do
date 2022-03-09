/*
Author: Marianne Gregory
Date created: 15/02/22

Description: homoskedastic LIML estimations for Table V cohort 

Last edited: 

*/
********************************************************************************
						//LIML ESTIMATOR for table V//
						//estimator is based on homoskedasticity//
********************************************************************************





//select correct cohort//
keep if cohort>30.00 & cohort <30.40




/*specification 1*/
ivreg2 lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), liml
outreg2 using 3.1LIML_output.doc, ci replace ctitle(Specification 1: LIML) excel


/*specification 2*/
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), liml
outreg2 using 3.1LIML_output.doc, ci append ctitle(Specification 2: LIML) excel


/*specification 3*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), liml
outreg2 using 3.1LIML_output.doc, ci append ctitle(Specification 3: LIML) excel


/*specification 4*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), liml
outreg2 using 3.1LIML_output.doc, ci append ctitle(Specification 4: LIML) excel


