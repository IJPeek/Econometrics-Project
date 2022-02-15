********************************************************************************
						//LIML ESTIMATOR for table V//
						//estimator is based on homoskedasticity//
********************************************************************************





//select correct cohort//
keep if cohort>30.00 & cohort <30.40




/*specification 1*/
ivreg2 lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), liml
est store spec1

/*specification 2*/
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), liml
est store spec2

/*specification 3*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), liml
est store spec3

/*specification 4*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), liml
est store spec4

/*collecting results together*/
est table spec1 spec2 spec3 spec4 
