/*
Author: Marianne Gregory
Date created: 15/02/22

Description: heteroskedastic LIML estimations for Table V cohort 

Last edited: 

*/

********************************************************************************
						//   ROBUST LIML ESTIMATOR for table V//
						//estimator robust to heteroskedasticity//
						//using ivreg2//
********************************************************************************

//create all the instruments and loading data
run "$dofile/1.2 Creating Instrumental variables.do"


//select correct cohort//
keep if cohort>30.00 & cohort <30.40

/*specification 1*/
ivreg2 lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), cue robust
outreg2 using 3.4HLIML_output.doc, ci replace ctitle(Specification 1: HLIML) excel

/*specification 2*/
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), cue robust 
outreg2 using 3.4HLIML_output.doc, ci append ctitle(Specification 2: HLIML) excel

/*specification 3*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), cue robust 
outreg2 using 3.4HLIML_output.doc, ci replace ctitle(Specification 3: HLIML) excel

/*specification 4*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), cue robust 
outreg2 using 3.4HLIML_output.doc, ci append ctitle(Specification 4: HLIML) excel








//old one using mivreg

/*specification 1*/
mivreg lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), het
outreg2 using 3.4mivHLIML_output.doc, ci replace ctitle(Specification 1: miv) excel

/*specification 2*/
mivreg lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), het
outreg2 using 3.4mivHLIML_output.doc, ci append ctitle(Specification 2: mivHLIML) excel

/*specification 3*/
mivreg lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), het
outreg2 using 3.4mivHLIML_output.doc, ci append ctitle(Specification 2: mivHLIML) excel

/*specification 4*/
mivreg lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), het
outreg2 using 3.4mivHLIML_output.doc, ci append ctitle(Specification 2: mivHLIML) excel


