/* 
Author: Isabelle Peek
Description: Monte Carlo Simulation for IV 
// Source : https://learneconometrics.com/pdf/MCstata/MCstata.pdf

Content

1. Data Generating Process Set up
2. Writing Program to repeat estimation- IV2
*/

*******************************************************************************
******* 		Data Generating Process Set up
*******************************************************************************

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
 scalar sige = 0 /* measurement error in e */
 
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
 summarize
 histogram biv, freq normal title("Strong Instrument ") yscale(range(0 80)) 
 graph save "$output/Monte_Carlos/MC_2SLS_Strong.gph", replace 
 
 histogram b, freq normal title("OLS Coefficients")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_OLS.gph", replace
 
 
*******************************************************************************
******* 		Weaker Instruments
*******************************************************************************

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
 scalar sige = 0 /* measurement error in e */
 
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
 summarize
 histogram biv, freq normal title("Weaker Instrument ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_2SLS_Weak.gph", replace
 
 *******************************************************************************
******* 		Weakest Instruments
*******************************************************************************

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
 scalar sige = 0 /* measurement error in e */
 
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
 summarize
 histogram biv, freq normal title("Weakest Instrument")   yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_2SLS_Weakest.gph", replace
 
 
  
gr combine $output/Monte_Carlos/MC_OLS.gph $output/Monte_Carlos/MC_2SLS_Strong.gph $output/Monte_Carlos/MC_2SLS_Weak.gph $output/Monte_Carlos/MC_2SLS_Weakest.gph, col(2) title("2SLS Monte Carlos with weak instruments") saving(charts1, replace)
graph export "$output/Monte_Carlos/2SLS Bias Graphs.pdf", replace

********************************************************************************
**********							LIML						****************
********************************************************************************
		
		//Strongest
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
 scalar sige = 0 /* measurement error in e */
 
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
program regIV, rclass 
tempname sim

//Postfile saves our estimation output in Stata's memory
postfile `sim' b using results, replace
quietly {
forvalues i = 1/$nmc {
replace u = rnormal(0,sigma)
replace x = gam*z+rho*u+rnormal(0,sige) 
replace y=slope*x+u


ivreg2 y (x=z), liml
 scalar b=e(b)[1,1]
		post `sim' (b)
		}
		
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize
 histogram b, freq normal title("LIML- Strong, K2=1 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_LIML-Strong.gph", replace
 
************************************************************************
				//Weaker
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
 scalar sige = 0 /* measurement error in e */
 
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
postfile `sim' b using results, replace
quietly {
forvalues i = 1/$nmc {
replace u = rnormal(0,sigma)
replace x = gam*z+rho*u+rnormal(0,sige) 
replace y=slope*x+u


ivreg2 y (x=z), liml
 scalar b=e(b)[1,1]
		post `sim' (b)
		}
		
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize
 histogram b, freq normal title("LIML- Weaker, K2=1 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_LIML-Weaker.gph", replace
 
 ************************************************************************
				//Weakest
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
 scalar sige = 0 /* measurement error in e */
 
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
postfile `sim' b using results, replace
quietly {
forvalues i = 1/$nmc {
replace u = rnormal(0,sigma)
replace x = gam*z+rho*u+rnormal(0,sige) 
replace y=slope*x+u


ivreg2 y (x=z), liml
 scalar b=e(b)[1,1]
		post `sim' (b)
		}	
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize
 histogram b, freq normal title("LIML- Weakest, K2=1 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_LIML-Weakest.gph", replace
 
 
gr combine  $output/Monte_Carlos/MC_LIML-Strong.gph $output/Monte_Carlos/MC_LIML-Weaker.gph $output/Monte_Carlos/MC_LIML-Weakest.gph, col(2) title("LIML Monte Carlos with weak instruments") saving(charts1, replace)
graph export "$output/Monte_Carlos/LIML_Weak_Instruments_Graphs.pdf", replace
 
 
