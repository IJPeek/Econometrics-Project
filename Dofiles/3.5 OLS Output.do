
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

////hful lwklywge yr20 yr21 yr22 yr23 yr24 yr25 yr26 yr27 yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr1 qtr2 qtr3)

hful lwklywge yr20 yr21 yr22 yr23 yr24 yr25 yr26 yr27 yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)


hful lwklywge yr20 yr21 yr22 yr23 yr24 yr25 yr26 yr27 yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120 qtr121 qtr122 qtr123 qtr124 qtr125 qtr126 qtr127 qtr128 qtr129 qtr220 qtr221 qtr222 qtr223 qtr224 qtr225 qtr226 qtr227 qtr228 qtr229 qtr320 qtr321 qtr322 qtr323 qtr324 qtr325 qtr326 qtr327 qtr328 qtr329 yr20 yr21 yr22 yr23 yr24 yr25 yr26 yr27 yr28)

//spec 3 - removing years and qtr328/ 329 
hful lwklywge yr20 yr21 yr22 yr23 yr24 yr25 yr26 yr27 yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120 qtr121 qtr122 qtr123 qtr124 qtr125 qtr126 qtr127 qtr128 qtr129 qtr220 qtr221 qtr222 qtr223 qtr224 qtr225 qtr226 qtr227 qtr228 qtr229 qtr320 qtr321 qtr322 qtr323 qtr324 qtr325 qtr326 qtr327)


