/*

Description: This dofile generates the point estimates that we use to estimate the returns to schooling, which will be compared to the 2SLS estimates generated in dofile 2.

Sections:
	1. OLS
	2. LIML & CUE
	3. FULL & HFUL
*/

use "$temp/QOB.dta", clear

******************************************
********** 1. OLS estimates **********
******************************************

/*specification 1*/
reg lwklywge educ yr20-yr28
outreg2 using $output/reg_output.doc, ci replace ctitle(Specification 1) excel


/*specification 2*/
reg lwklywge educ yr20-yr28 ageq ageqsq
outreg2 using $output/reg_output.doc, ci append ctitle(Specification 2) excel


/*specification 3*/
reg lwklywge educ yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt, robust 
outreg2 using $output/reg_output.doc, ci append ctitle(Specification 3) excel


/*specification 4*/
reg lwklywge educ yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq, robust
outreg2 using $output/reg_output.doc, ci append ctitle(Specification 4) excel


**********************************************
*********	2. LIML & CUE	**********
**********************************************

************
*** LIML ***
************
/*specification 1*/
ivreg2 lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), liml
outreg2 using $output/3.1LIML_output.doc, replace ctitle(Specification 1: LIML)



/*specification 2*/
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), liml partial(ageq ageqsq)
outreg2 using $output/3.1LIML_output.doc, append ctitle(Specification 2: LIML)

***********
*** CUE ***
***********
/*specification 3*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), cue robust 
outreg2 using $output/3.1LIML_output.doc, append ctitle(Specification 3: CUE)

/*specification 4*/
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), cue robust partial(ageq ageqsq)
outreg2 using $output/3.1LIML_output.doc, append ctitle(Specification 4: CUE)



***************************************************
*****************	3. FULL & HFUL	***************
***************************************************

**************
*** FULLER ***
**************
// NOTE: Also did heteroskedasticity tests and the results were similar to 2SLS

**Specification 1**
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), fuller(1)
outreg2 using stata_FULL.doc, replace ctitle(Specification 1: FULLER(1))

ivhettest

**Specification 2**
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), fuller(1) partial(ageq ageqsq)
outreg2 using stata_FULL.doc, append ctitle(Specification 2: FULLER(1))

ivhettest

************
*** HFUL ***
************
// NOTE: heteroskedasticity-robust FULLER for specifications 3 and 4 where heteroskedasticity is present

help hful // click on the links to install hful

**Specification 3**
hful lwklywge yr20 yr21 yr22 yr23 yr24 yr25 yr26 yr27 yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120 qtr121 qtr122 qtr123 qtr124 qtr125 qtr126 qtr127 qtr128 qtr129 qtr220 qtr221 qtr222 qtr223 qtr224 qtr225 qtr226 qtr227 qtr228 qtr229 qtr320 qtr321 qtr322 qtr323 qtr324 qtr325 qtr326 qtr327)


**Specification 4**
hful lwklywge yr20 yr21 yr22 yr23 yr24 yr25 yr26 yr27 yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120 qtr121 qtr122 qtr123 qtr124 qtr125 qtr126 qtr127 qtr128 qtr129 qtr220 qtr221 qtr222 qtr223 qtr224 qtr225 qtr226 qtr227 qtr228 qtr229 qtr320 qtr321 qtr322 qtr323 qtr324 qtr325 qtr326 qtr327)


// NOTE: output from HFUL command transfered to word document mechanically due to no command being available to output these regression results


*
*
*** END OF DO FILE ***

