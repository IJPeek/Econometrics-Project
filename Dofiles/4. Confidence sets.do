** 4 Confidence Sets - AR, LM & CLR

** Run 1.2 Creating Instrument 
run "$dofile/1.2 Creating Instrumental variables.do"

** select correct cohort 
keep if cohort>30.00 & cohort <30.40

** install ivreg2 
ssc install ivreg2
** install weakiv 
ssc install weakiv 
** install avar 
ssc install avar


** Note - remove yr20-yr28 from instruments due to duplication **
**Specification 1** 
weakiv ivreg2 lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)

** export output table to excel 
ereturn list 
** set where the excel file goes 
putexcel set $output/5.3_CLR_confidence_set.xlsx, modify 
putexcel A1 = "CLR Confidence Set Results", bold 
putexcel A4 = "Specification 1"
putexcel B3 = "Confidence Level"
putexcel B4 = (e(level))
putexcel C3 = "CLR Confidence Set"
putexcel C4 = (e(clr_cset))


**Specification 2**
weakiv ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)

ereturn list 
putexcel set $output/5.3_CLR_confidence_set.xlsx, modify 
putexcel A5 = "Specification 2"
putexcel B5 = (e(level))
putexcel C5 = (e(clr_cset))


**Specification 3**
weakiv ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), robust 
ereturn list 
putexcel set $output/5.3_CLR_confidence_set.xlsx, modify 
putexcel A6 = "Specification 3"
putexcel B6 = (e(level))
putexcel C6 = (e(clr_cset))


**Specification 4**
weakiv ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), robust 
 
ereturn list 
putexcel set $output/5.3_CLR_confidence_set.xlsx, modify 
putexcel A7 = "Specification 4"
putexcel B7 = (e(level))
putexcel C7 = (e(clr_cset))









