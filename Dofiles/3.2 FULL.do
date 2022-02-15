
run "$dofile/1.2 Creating Instrumental variables.do"

keep if cohort>30.00 & cohort<30.40

**********************************************************************************
********~ FULLER Estimator (also did het tests and errors are homoskedastic)~********
**********************************************************************************
ssc install ivreg2
ssc install ivhettest

**Specification 1**
ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), fuller(4)
ivhettest

**Specification 2**
ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), fuller(4)
ivhettest

**Specification 3**
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), fuller(4)
ivhettest

**Specification 4**
ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28), fuller(4)
ivhettest

