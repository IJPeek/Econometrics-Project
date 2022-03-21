
run "$dofile/1.2 Creating Instrumental variables.do"

keep if cohort>30.00 & cohort<30.40

************************************************************************************************************
********~ FULLER Estimator (also did heteroskedasticity tests and the results were similar to 2SLS)~********
************************************************************************************************************
ssc install ivreg2
ssc install ivhettest

**Specification 1**
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), fuller(1)
outreg2 using stata_FULL.doc, replace ctitle(Specification 1: FULLER(1))

ivhettest

**Specification 2**
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), fuller(1) partial(ageq ageqsq)
outreg2 using stata_FULL.doc, append ctitle(Specification 2: FULLER(1))

ivhettest


*************************************************************************************************************************************************************************
     ********************************~ HFUL (heteroskedasticity-robust FULLER for specifications 3 and 4 where heteroskedasticity is present)~***************************
*************************************************************************************************************************************************************************
help hful //install hful 

**Specification 3**
hful lwklywge yr20 yr21 yr22 yr23 yr24 yr25 yr26 yr27 yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120 qtr121 qtr122 qtr123 qtr124 qtr125 qtr126 qtr127 qtr128 qtr129 qtr220 qtr221 qtr222 qtr223 qtr224 qtr225 qtr226 qtr227 qtr228 qtr229 qtr320 qtr321 qtr322 qtr323 qtr324 qtr325 qtr326 qtr327)


**Specification 4**
hful lwklywge yr20 yr21 yr22 yr23 yr24 yr25 yr26 yr27 yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120 qtr121 qtr122 qtr123 qtr124 qtr125 qtr126 qtr127 qtr128 qtr129 qtr220 qtr221 qtr222 qtr223 qtr224 qtr225 qtr226 qtr227 qtr228 qtr229 qtr320 qtr321 qtr322 qtr323 qtr324 qtr325 qtr326 qtr327)

