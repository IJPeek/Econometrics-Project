
********************************************************************************
						//Reg ESTIMATOR for table V//
						//estimator is based on homoskedasticity//
********************************************************************************



run "$dofile/1.2 Creating Instrumental variables.do"

//select correct cohort//
keep if cohort>30.00 & cohort <30.40

ssc install outreg2
/*specification 1*/
reg lwklywge educ yr20-yr28
outreg2 using $output/reg_output.doc, ci replace ctitle(Specification 1) excel


/*specification 2*/
reg lwklywge educ yr20-yr28 ageq ageqsq
outreg2 using $output/reg_output.doc, ci append ctitle(Specification 2) excel


/*specification 3*/
reg lwklywge educ yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt 
outreg2 using $output/reg_output.doc, ci append ctitle(Specification 3) excel


/*specification 4*/
reg lwklywge educ yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq
outreg2 using $output/reg_output.doc, ci append ctitle(Specification 4) excel


///// CHECKING THE SPECS

ivreg2 lwklywge yr20-yr28 (educ = qtr1 qtr2 qtr3)

ivreg2 lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)
//0.89
//.105

