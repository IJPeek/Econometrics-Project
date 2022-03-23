/* 
Description: Monte Carlo Simulation for OLS, 2SLS, LIML and FULL
// Code largely based on : https://learneconometrics.com/pdf/MCstata/MCstata.pdf

Content


		One Instrument
1.1 2SLS- STRONG, gam=1, Instruments=1
1.2 2SLS- Weaker, gam=0.1, Instruments=1
1.3 2SLS- Weakesty, gam=0.01, Instruments=1
2.1 LIML- STRONG, gam=1, Instruments=1
2.2 LIML- Weaker, gam=0.1, Instruments=1
2.3 LIML- Weakest, gam=0.01, Instruments=1
3. GRAPHS COMBINED

*/

*******************************************************************************
******* 	1.1 2SLS- STRONG, gam=1, Instruments=1
*******************************************************************************
		/* IMPORTANT NOTE ON ALL THE FOLLOWING SUB SECTIONS FOR MONTE CARLOS
		 All the following sections have the same sturcture as this first section.
		 The memory of stata has to be cleared completely including the program of STATA generates an error message. Hence the simulatuion program is refined in each simulation.
		 
		 Only this first subsection is heavily annontated
		 
		 
		 Historgams have been made for n=1000 and n=10000 by runing these subsections with the relevant observation. The MSE is calculated in excel but the output of the mean, median and sd of the distribution is exported to excel using put excel.
*/
clear all
// Setting Macros. Set the number of observations and simualations
global nobs = 10000
global nmc = 1000

// Setting out seed for randomisation
set seed 10101
 set obs $nobs
 
// Setting our paramaters for the DGP

	 // Reduced form coeffivients are set
 scalar slope = 1 /* regression slope */
 scalar sigma = 1 /* error in y */
 scalar sige = 0.2 /* measurement error in e */
 
     // Instrumental Variables: 
 scalar gam = 1 /* instrument strength */
 scalar rho = 0.5 /* Including this rho creates our endogenity issue, it measures the strength of the error in the reduced form equation having an impact on x in the structural equation */
 scalar alpha=.05 /* test size */


// We generate our data here, Z exogenously set
gen z = 5*runiform()
gen y=.
gen x=.
gen u=.

// setting the program to simulate the estimates
cap  program drop regIV
program regIV, rclass 
tempname sim

//Postfile saves our estimation output in Stata's memory
postfile `sim' b biv se se_iv p_ls p_iv using results, replace
quietly {
forvalues i = 1/$nmc {
replace u = rnormal(0,sigma)
replace x = gam*z+rho*u+rnormal(0,sige) 
replace y=slope*x+u

//OLS
reg y x
scalar b = _b[x]
scalar se = _se[x]
scalar lb = b - se*invttail(e(df_r),alpha/2)
scalar ub = b + se*invttail(e(df_r),alpha/2)
scalar pv = slope<ub & slope>lb

//2SLS
	ivreg y (x=z)
		scalar biv = _b[x]
		scalar seiv = _se[x]
		scalar lb = biv - seiv*invttail(e(df_r),alpha/2)
		scalar ub = biv + seiv*invttail(e(df_r),alpha/2)
		scalar pvr = slope<ub & slope>lb
		post `sim' (b) (biv) (se) (seiv) (pv) (pvr)
		}
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize b
 
// The project uses Mean Squared Errors as one method of analysis, these are calculated in the output excel files by Bias^2 +Variance

 putexcel set $output/Monte_Carlos.xlsx, modify
putexcel C1 = "Strongest Instrument"
putexcel B2 = "OLS Mean"
putexcel B3 = "2SLS Mean"
putexcel B4 = "OLS SD"
putexcel B5 = "2SLS SD"

putexcel D1 = "Weaker Instument"

// OLS output for MSE
putexcel C2 = `r(mean)'
putexcel C4 = `r(sd)'

 summarize biv

// 2SLS output for MSE
putexcel C3 = `r(mean)'
putexcel C5 = `r(sd)'
 
 // Another method of analysis is looking at the Histgrams
 // Saving Histograms
 histogram biv, freq normal title("Strong Instrument ") yscale(range(0 80)) 
 graph save "$output/Monte_Carlos/MC_2SLS_Strong.gph", replace 
 
 histogram b, freq normal title("OLS Coefficients")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_OLS.gph", replace
 
 
*******************************************************************************
**		1.2	2SLS- Weaker, gam=0.1, Instruments=1
*******************************************************************************



clear all
// Setting Macros. Number of observations
global nobs = 10000
global nmc = 1000

// Setting out seed for randomisation
set seed 10101
 set obs $nobs
 
// Setting our paramaters for the DGP

	 // Reduced form
 scalar slope = 1 /* regression slope */
 scalar sigma = 1 /* error in y */
 scalar sige = 0.2 /* measurement error in e */
 
     // Instrumental Variables: 
 scalar gam = 0.1 /* instrument strength */
 scalar rho = 0.5 /* Including this rho creates our endogenity issue, it measures the strength of the error in the reduced form equation having an impact on x in the structural equation */
 scalar alpha=.05 /* test size */


// We generate our data here
gen z = 5*runiform()
gen y=.
gen x=.
gen u=.

cap  program drop regIV
program regIV, rclass 
tempname sim

//Postfile saves our estimation output in Stata's memory
postfile `sim' b biv se se_iv p_ls p_iv using results, replace
quietly {
forvalues i = 1/$nmc {
replace u = rnormal(0,sigma)
replace x = gam*z+rho*u+rnormal(0,sige) 
replace y=slope*x+u
reg y x
scalar b = _b[x]
scalar se = _se[x]
scalar lb = b - se*invttail(e(df_r),alpha/2)
scalar ub = b + se*invttail(e(df_r),alpha/2)
scalar pv = slope<ub & slope>lb

	ivreg y (x=z)
		scalar biv = _b[x]
		scalar seiv = _se[x]
		scalar lb = biv - seiv*invttail(e(df_r),alpha/2)
		scalar ub = biv + seiv*invttail(e(df_r),alpha/2)
		scalar pvr = slope<ub & slope>lb
		post `sim' (b) (biv) (se) (seiv) (pv) (pvr)
		}
		
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize biv

 
// 2SLS output
putexcel D3 = `r(mean)'
putexcel D5 = `r(sd)'

 histogram biv, freq normal title("Weaker Instrument ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_2SLS_Weak.gph", replace
 
*******************************************************************************
**		1.3 2SLS- Weakest, gam=0.01, Instruments=1							***
*******************************************************************************
** Weakest Instruments

clear all
// Setting Macros. Number of observations
global nobs = 10000
global nmc = 1000

// Setting out seed for randomisation
set seed 10101
 set obs $nobs
 
// Setting our paramaters for the DGP

	 // Reduced form
 scalar slope = 1 /* regression slope */
 scalar sigma = 1 /* error in y */
 scalar sige = 0.2 /* measurement error in e */
 
     // Instrumental Variables: 
 scalar gam = 0.01 /* instrument strength */
 scalar rho = 0.5 /* Including this rho creates our endogenity issue, it measures the strength of the error in the reduced form equation having an impact on x in the structural equation */
 scalar alpha=.05 /* test size */


// We generate our data here
gen z = 5*runiform()
gen y=.
gen x=.
gen u=.

cap  program drop regIV
program regIV, rclass 
tempname sim
//Postfile saves our estimation output in Stata's memory
postfile `sim' b biv se se_iv p_ls p_iv using results, replace
quietly {
forvalues i = 1/$nmc {
replace u = rnormal(0,sigma)
replace x = gam*z+rho*u+rnormal(0,sige) 
replace y=slope*x+u

reg y x
scalar b = _b[x]
scalar se = _se[x]
scalar lb = b - se*invttail(e(df_r),alpha/2)
scalar ub = b + se*invttail(e(df_r),alpha/2)
scalar pv = slope<ub & slope>lb

ivreg y (x=z)
		scalar biv = _b[x]
		scalar seiv = _se[x]
		scalar lb = biv - seiv*invttail(e(df_r),alpha/2)
		scalar ub = biv + seiv*invttail(e(df_r),alpha/2)
		scalar pvr = slope<ub & slope>lb
		post `sim' (b) (biv) (se) (seiv) (pv) (pvr)
		}
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize biv
 
// 2SLS output
putexcel E1="Weakest Instrument"
putexcel E3 = `r(mean)'
putexcel E5 = `r(sd)'

 histogram biv, freq normal title("Weakest Instrument") 
 graph save "$output/Monte_Carlos/MC_2SLS_Weakest.gph", replace
 
//xscale(range(5000 10000)) xlabel(5000[1000]10000)
  
gr combine $output/Monte_Carlos/MC_OLS.gph $output/Monte_Carlos/MC_2SLS_Strong.gph $output/Monte_Carlos/MC_2SLS_Weak.gph $output/Monte_Carlos/MC_2SLS_Weakest.gph, col(2) title("Figure E1: 2SLS with One Weak Instrument") saving(charts1, replace)
graph export "$output/Monte_Carlos/2SLS Bias Graphs.pdf", replace


********************************************************************************
**********				2		LIML and FULL					****************
********************************************************************************


********************************************************************************
********** 		2.1 LIML- STRONG, gam=1, Instruments=1
//Strongest

clear all
// Setting Macros. Number of observations
global nobs = 10000
global nmc = 1000

// Setting out seed for randomisation
set seed 10101
 set obs $nobs
 
// Setting our paramaters for the DGP

	 // Reduced form
 scalar slope = 1 /* regression slope */
 scalar sigma = 1 /* error in y */
 scalar sige = 0.2 /* measurement error in e */
 
     // Instrumental Variables: 
 scalar gam = 1 /* instrument strength */
 scalar rho = 0.5 /* Including this rho creates our endogenity issue, it measures the strength of the error in the reduced form equation having an impact on x in the structural equation */
 scalar alpha=.05 /* test size */


// We generate our data here
gen z = 5*runiform()
gen y=.
gen x=.
gen u=.

cap  program drop regIV
program regIV, eclass 
tempname sim

//Postfile saves our estimation output in Stata's memory
postfile `sim' b bful using results, replace
quietly {
forvalues i = 1/$nmc {
replace u = rnormal(0,sigma)
replace x = gam*z+rho*u+rnormal(0,sige) 
replace y=slope*x+u


ivreg2 y (x=z), liml
	scalar b=e(b)[1,1]
		
ivreg2 y (x=z), fuller(1)
	scalar bful=e(b)[1,1]
	post `sim' (b) (bful)
		}
		
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize b, d
 
// LIML output
putexcel B6="LIML mean"
putexcel B7="FULL mean"
putexcel B8="LIML sd"
putexcel B9="FULL sd"
putexcel B10= "LIML median"
putexcel B11 = "FULL median"


putexcel C6 = `r(mean)'
putexcel C8 = `r(sd)'
putexcel C10 = `r(p50)'

 summarize bful, d
// FULL output
putexcel C7 = `r(mean)'
putexcel C9 = `r(sd)'
putexcel C11 = `r(p50)'


 histogram b, freq normal title("LIML- Strong, K2=1 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_LIML-Strong.gph", replace
 
 histogram bful, freq normal title("FULL- Strong, K2=1 ")  yscale(range(0 80))
  graph save "$output/Monte_Carlos/MC_FULLER1-Strong.gph", replace
 
************************************************************************
**			2.2 LIML- Weaker, gam=0.1, Instruments=1
************************************************************************



clear all
// Setting Macros. Number of observations
global nobs = 1000
global nmc = 1000

// Setting out seed for randomisation
set seed 10101
 set obs $nobs
 
// Setting our paramaters for the DGP

	 // Reduced form
 scalar slope = 1 /* regression slope */
 scalar sigma = 1 /* error in y */
 scalar sige = 0.2 /* measurement error in e */
 
     // Instrumental Variables: 
 scalar gam = 0.1 /* instrument strength */
 scalar rho = 0.5 /* Including this rho creates our endogenity issue, it measures the strength of the error in the reduced form equation having an impact on x in the structural equation */
 scalar alpha=.05 /* test size */


// We generate our data here
gen z = 5*runiform()
gen y=.
gen x=.
gen u=.



cap  program drop regIV
program regIV, eclass 
tempname sim

//Postfile saves our estimation output in Stata's memory
postfile `sim' b bful using results, replace
quietly {
forvalues i = 1/$nmc {
replace u = rnormal(0,sigma)
replace x = gam*z+rho*u+rnormal(0,sige) 
replace y=slope*x+u


ivreg2 y (x=z), liml
 scalar b=e(b)[1,1]
	ivreg2 y (x=z), fuller(1)
scalar bful=e(b)[1,1]
		post `sim' (b) (bful)
		}
		
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize b, d

putexcel D6 = `r(mean)'
putexcel D8 = `r(sd)'
putexcel D10 = `r(p50)'

 summarize bful, d
// FULL output
putexcel D7 = `r(mean)'
putexcel D9 = `r(sd)'
putexcel D11 = `r(p50)'
 
 
 
 histogram b, freq normal title("LIML- Weaker, K2=1 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_LIML-Weaker.gph", replace
 
 histogram bful, freq normal title("FULL- Weaker, K2=1 ")  yscale(range(0 80))
  graph save "$output/Monte_Carlos/MC_FULLER1-Weaker.gph", replace
 
************************************************************************
**			2.3 LIML- Weakest, gam=0.01, Instruments=1
************************************************************************


clear all
// Setting Macros. Number of observations
global nobs = 10000
global nmc = 1000

// Setting out seed for randomisation
set seed 10101
 set obs $nobs
 
// Setting our paramaters for the DGP

	 // Reduced form
 scalar slope = 1 /* regression slope */
 scalar sigma = 1 /* error in y */
 scalar sige = 0.2 /* measurement error in e */
 
     // Instrumental Variables: 
 scalar gam = 0.01 /* instrument strength */
 scalar rho = 0.5 /* Including this rho creates our endogenity issue, it measures the strength of the error in the reduced form equation having an impact on x in the structural equation */
 scalar alpha=.05 /* test size */


// We generate our data here
gen z = 5*runiform()
gen y=.
gen x=.
gen u=.

cap  program drop regIV
program regIV, eclass 
tempname sim

//Postfile saves our estimation output in Stata's memory
postfile `sim' b bful using results, replace
quietly {
forvalues i = 1/$nmc {
replace u = rnormal(0,sigma)
replace x = gam*z+rho*u+rnormal(0,sige) 
replace y=slope*x+u


ivreg2 y (x=z), liml
 scalar b=e(b)[1,1]
		ivreg2 y (x=z), fuller(1)
scalar bful=e(b)[1,1]
		post `sim' (b) (bful)
		}	
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize
  summarize b, d

putexcel E6 = `r(mean)'
putexcel E8 = `r(sd)'
putexcel E10 = `r(p50)'

 summarize bful, d
// FULL output
putexcel E7 = `r(mean)'
putexcel E9 = `r(sd)'
putexcel E11 = `r(p50)'
 histogram b, freq normal title("LIML- Weakest, K2=1 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_LIML-Weakest.gph", replace
 
  histogram bful, freq normal title("FULL- Weakest, K2=1 ")  yscale(range(0 80))
  graph save "$output/Monte_Carlos/MC_FULLER1-Weakest.gph", replace
 
 
 
 // 3. GRAPHS COMBINED
gr combine  $output/Monte_Carlos/MC_LIML-Strong.gph $output/Monte_Carlos/MC_LIML-Weaker.gph $output/Monte_Carlos/MC_LIML-Weakest.gph, col(2) title("LIML Monte Carlos with weak instruments") saving(charts1, replace)
graph export "$output/Monte_Carlos/LIML_Weak_Instruments_Graphs.pdf", replace
 
 
gr combine  $output/Monte_Carlos/MC_FULLER1-Strong.gph $output/Monte_Carlos/MC_FULLER1-Weaker.gph $output/Monte_Carlos/MC_FULLER1-Weakest.gph, col(2) title("FULL Monte Carlos with weak instruments") saving(charts1, replace)
graph export "$output/Monte_Carlos/FULL_Weak_Instruments_Graphs.pdf", replace




gr combine  $output/Monte_Carlos/MC_LIML-Weaker.gph $output/Monte_Carlos/MC_LIML-Weakest.gph $output/Monte_Carlos/MC_FULLER1-Weaker.gph $output/Monte_Carlos/MC_FULLER1-Weakest.gph, col(2) title("LIML vs FULL Monte Carlos with weak instruments") saving(charts1, replace)
graph export "$output/Monte_Carlos/LIMLvsFULL_Weak_Instruments_Graphs.pdf", replace
