/*
Author: Marianne Gregory
Date created: 15/02/22

Description: heteroskedastic LIML estimations for Table V cohort 

Last edited: 

*/

********************************************************************************
						//   ROBUST LIML ESTIMATOR for table V//
						//estimator robust to heteroskedasticity//
						//using mivreg//
********************************************************************************



//select correct cohort//
keep if cohort>30.00 & cohort <30.40

/*specification 1*/
mivreg lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), het
outreg2 using 3.4HLIML_output.doc, ci replace ctitle(Specification 1: HLIML) excel

/*specification 2*/
mivreg lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), het
outreg2 using 3.4HLIML_output.doc, ci append ctitle(Specification 2: HLIML) excel

/*specification 3*/
mivreg lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), het
outreg2 using 3.4HLIML_output.doc, ci append ctitle(Specification 2: HLIML) excel

/*specification 4*/
mivreg lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), het
outreg2 using 3.4HLIML_output.doc, ci append ctitle(Specification 2: HLIML) excel









//old one using ivreg2

/*specification 1*/
ivreg2 lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), cue robust bw
est store basespec

/*specification 2*/
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), cue robust bw
est store agespec

/*specification 3*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), cue robust bw
est store locationspec

/*specification 4*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), cue robust bw
est store all

/*collecting results together*/
est table basespec agespec locationspec all, b(%7.4f) star
