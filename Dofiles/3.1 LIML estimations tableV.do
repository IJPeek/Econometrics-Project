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


//create all the instruments and loading data
run "$dofile/1.2 Creating Instrumental variables.do"



//select correct cohort//
keep if cohort>30.00 & cohort <30.40

//install ivreg2 and outreg2


**********************************************************************************
						********~LIML Estimator ********
**********************************************************************************

/*specification 1*/
ivreg2 lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), liml
outreg2 using $output/3.1LIML_output.doc, replace ctitle(Specification 1: LIML)



/*specification 2*/
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), liml partial(ageq ageqsq)
outreg2 using $output/3.1LIML_output.doc, append ctitle(Specification 2: LIML)



**********************************************************************************
						********~CUE Estimator ********
**********************************************************************************



/*specification 3*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), cue robust 
outreg2 using $output/3.1LIML_output.doc, append ctitle(Specification 3: CUE)

/*specification 4*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), cue robust partial(ageq ageqsq)
outreg2 using $output/3.1LIML_output.doc, append ctitle(Specification 4: CUE)





