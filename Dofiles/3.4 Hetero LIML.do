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



/*specification 3*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), cue robust 
outreg2 using $output/3.1LIML_output.doc, ci append title(D3: LIML & CUE) ctitle(Specification 3: CUE) excel

/*specification 4*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), cue robust partial(ageq ageqsq)
outreg2 using $output/3.1LIML_output.doc, ci append title(D3: LIML & CUE) ctitle(Specification 4: CUE) excel







