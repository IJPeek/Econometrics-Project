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
** install outreg2 and asdoc
ssc install outreg2 
ssc install asdoc 

** NOTE - REMOVE YR20-YR28 **
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

ssc install regsave

ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)
regsave, ci 
list 
ereturn list 

**Specification 2**
weakiv ivreg2 lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)
** note get infinite conf set for K-LM, we're not going to interpret this so shouldn't be an issue 
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
weakiv ivreg2 lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), robust graph(clr) 
** problem here that the conf set covers the entire grid - need to figure out how to interpret this 
** p values are also very high 
** could indicate an issue with identification? 
** option usegrid doesn't change this, neither does changing the number of gridpoints to 25 
** when you drop robust, you get confidence sets for CLR and K-LM 
ereturn list 
putexcel set $output/5.3_CLR_confidence_set.xlsx, modify 
putexcel A7 = "Specification 4"
putexcel B7 = (e(level))
putexcel C7 = (e(clr_cset))


** try twostepweakiv 
ssc install moremata
twostepweakiv 2sls lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329 yr20-yr28)
** works but doesn't have CLR confidence set 


**DON'T RUN - CONDIVREG - ISSUES WITH MULTICOLLINEARITY**
** download condivreg by typing in STATA:
net sj 6-3 st0033_2
net install st0033_2, replace

** test with simple model and 1 instrument (for 2SLS) 
condivreg lwklywge age (educ = qtr1), ar lm  

** need to run with full specifications and instruments 
** run for both 2SLS and LIML 

** 2SLS **
** Remove yr20-yr28 from instruments because of multicollinearity problems 

**Specification 1**
condivreg lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), ar lm   

**Specification 2**
condivreg lwklywge yr20-yr28 ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), ar lm 
** issue with multicollinearity - instruments are included also as controls so we have multicollinearity issues 
** can you remove ageq and ageqsq from the controls without affecting the specification? 


**Specification 3**
condivreg lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), ar lm

**Specification 4**
condivreg lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), ar lm
** multicollinearity issues with ageq as in spec 2 

** checks for collinearity ** 
_rmdcoll lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq, forcedrop      
//checks for collinearity between endogenous vars and included exogenous//




//MARIANNE NOTES ON THE ISSUES AS WELL
//these are how we would run it but we get multicollinearity problems
//ivreg2 does suggest where multicollinearity lies but... e.g. see spec2
/*specification 1*/
condivreg lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), ar lm interval
est store basespec
//this one ivreg2 doesnt even think there is multicollinearity but condivreg does

/*specification 2*/
condivreg lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), ar lm interval
est store agespec
//ivreg2 suggests multicollinearity and drops qtr328 qtr329 from original spec but if we run these having dropped those we still have multicollinearity problems
condivreg lwklywge yr20-yr28 ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr327), ar lm interval
//it does give an output when you drop ageq and ageqsq 
condivreg lwklywge yr20-yr28 (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr327), ar lm interval

/*specification 3*/
condivreg lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), ar lm interval
est store locationspec

/*specification 4*/
condivreg lwklywge yr20-yr28 race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt ageq ageqsq (educ = qtr120-qtr129 qtr220-qtr229 qtr320-qtr329), ar lm interval
est store all




