********************************************************************************
//Marianne

						//trying to create intext output table for educ point estimates
						//not sure how to get confidence intervals etc. in there
						//probably im doing it wrong
********************************************************************************


run "$dofile/1.2 Creating Instrumental variables.do"

//select correct cohort//
keep if cohort>30.00 & cohort <30.40

********************************************************************************
						//altogether using putexcel
********************************************************************************


putexcel set point_estimates_output_tableV, replace
putexcel B1 = "Point Estimates (Table V)"
putexcel B2 = "Estimator:"
putexcel C2 = "OLS"
putexcel D2 = "2SLS"
putexcel E2 = "LIML"
putexcel F2 = "FULL"
putexcel G2 = "HLIML"
putexcel H2 = "HFUL"

//spec1
putexcel B3 = "Spec 1: educ"
reg lwklywge educ yr20-yr28
putexcel C3 = _b[educ]
//confidence interval?
ivreg2 lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
putexcel D3 = _b[educ]
//confidence interval?
ivreg2 lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), liml
putexcel E3 = _b[educ]
//confidence interval?
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), fuller(1)
putexcel F3 = _b[educ]
//confidence interval?

//spec2
putexcel B5 = "Spec 2: educ"
reg lwklywge educ yr20-yr28 ageq ageqsq
putexcel C5 = _b[educ]
//confidence interval?
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
putexcel D5 = _b[educ]
//confidence interval?
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), liml
putexcel E5 = _b[educ]
//confidence interval?
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), fuller(1)
putexcel F5 = _b[educ]
//confidence interval?

//spec3
putexcel B7 = "Spec 3: educ"
reg lwklywge educ yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt, robust 
putexcel C7 = _b[educ]
//confidence interval?
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), robust
putexcel D7 = _b[educ]
//confidence interval?
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), cue robust 
putexcel G7 = _b[educ]
//confidence interval?
hful lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr327)
putexcel H7 = _b[educ]
//confidence interval?

//spec4
putexcel B9 = "Spec 4: educ"
reg lwklywge educ yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq, robust
putexcel C9 = _b[educ]
//confidence interval?
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), robust
putexcel D7 = _b[educ]
//confidence interval?
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), cue robust 
//no output from this 
hful lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr327)
//no output from this 




********************************************************************************
						//outreg2 doesnt seem to be able to add more rows for other specs just for variables
						//spec 1
********************************************************************************
//OLS 
reg lwklywge educ yr20-yr28
outreg2 using $output/point_estimates_output_tableV.doc, replace keep(educ) nocons ci title(Point Estimates (Table V)) ctitle(2SLS) excel

//IV 
ivreg2 lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
outreg2 using $output/point_estimates_output_tableV.doc, append keep(educ) nocons ci title(Point Estimates (Table V)) ctitle(2SLS) excel

//LIML 
ivreg2 lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), liml
outreg2 using $output/point_estimates_output_tableV.doc, append keep(educ) nocons ci title(Point Estimates (Table V)) ctitle(LIML) excel

//FULL 
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), fuller(1)
outreg2 using $output/point_estimates_output_tableV.doc, append keep(educ) nocons ci title(Point Estimates (Table V)) ctitle(FULL) excel


********************************************************************************
						//spec 2
********************************************************************************
//OLS
reg lwklywge educ yr20-yr28 ageq ageqsq
outreg2 using $output/point_estimates_output_tableV.doc, append keep(educ) nocons ci title(Point Estimates (Table V)) ctitle(OLS) excel
