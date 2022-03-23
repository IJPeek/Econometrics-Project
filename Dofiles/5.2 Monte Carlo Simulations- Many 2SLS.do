/*
Description: Monte Carlo Simulation for 2SLS with many instruments
// Source : https://learneconometrics.com/pdf/MCstata/MCstata.pdf

Content
 1. 10 Variables
	// strong
	// weaker
 2. 30 Variables
	//weaker
 3. 100 Variables
	// weaker
	
 3. Graph Combine
*/

********************************************************************************
**						1. 10  Variables
********************************************************************************

********************************************************************************
// STRONG INSTRUMENT

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

 
 forvalues x=1/10{
 scalar gam`x'= 1
 }
 
 scalar rho = 0.5 /* Including this rho creates our endogenity issue, it measures the strength of the error in the reduced form equation having an impact on x in the structural equation */
 scalar alpha=.05 /* test size */


// We generate our data here
 forvalues x=1/10{
 gen z`x'= 5*runiform()
 }

//gen z1 = 5*runiform()
//gen z2 = 5*runiform()
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

replace x= rho*u + rnormal(0,sige)

forvalues h=1/10{
gen x1=(x+ gam`h'*z`h')
replace x=x1
drop x1
}


replace y=slope*x+u
reg y x
scalar b = _b[x]
scalar se = _se[x]
scalar lb = b - se*invttail(e(df_r),alpha/2)
scalar ub = b + se*invttail(e(df_r),alpha/2)
scalar pv = slope<ub & slope>lb

	ivreg y (x=z*)
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
 histogram biv, freq normal title("Strong Instrument, 10 ") yscale(range(0 80)) 
 graph save "$output/MC_2SLS_Strong_10.gph", replace 
 
 histogram b, freq normal title("OLS Coefficients")  yscale(range(0 80))
 graph save "$output/Many_MC_OLS.gph", replace

 
********************************************************************************
// WEAK INSTRUMENT, gam=0.1

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
 scalar sigma = 10 /* error in y */
 scalar sige = 0.2 /* measurement error in e */
 
     // Instrumental Variables: 
 forvalues x=1/10{
 scalar gam`x'= 0.1
 }
 //scalar gam = 0.1 /* instrument strength */
 scalar rho = 0.5 /* Including this rho creates our endogenity issue, it measures the strength of the error in the reduced form equation having an impact on x in the structural equation */
 scalar alpha=.05 /* test size */


// We generate our data here
 forvalues x=1/10{
 gen z`x'= 5*runiform()
 }

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
replace x= rho*u+rnormal(0,sige)

forvalues h=1/10{
gen x1=(x+ gam`h'*z`h')
replace x=x1
drop x1
}

replace y=slope*x+u
reg y x
scalar b = _b[x]
scalar se = _se[x]
scalar lb = b - se*invttail(e(df_r),alpha/2)
scalar ub = b + se*invttail(e(df_r),alpha/2)
scalar pv = slope<ub & slope>lb

	ivreg y (x=z*)
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
 histogram biv, freq normal title("Weaker Instrument- K2=10")  yscale(range(0 80))
 graph save "$output/MC_MI_2SLS_Weak_TEN_INSTR.gph", replace
 

 
 
 
********************************************************************************
**						2. 30  Variables
********************************************************************************
 //Weaker INSTRUMENT, gam=0.1, 30 INSTRUMENTs
 
 
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
 scalar sigma = 30 /* error in y */
 scalar sige = 0.2 /* measurement error in e */
 
     // Instrumental Variables: 
 forvalues x=1/30{
 scalar gam`x'= 0.1
 }
 //scalar gam = 0.1 /* instrument strength */
 scalar rho = 0.5 /* Including this rho creates our endogenity issue, it measures the strength of the error in the reduced form equation having an impact on x in the structural equation */
 scalar alpha=.05 /* test size */


// We generate our data here
 forvalues x=1/30{
 gen z`x'= 5*runiform()
 }

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
replace x= rho*u+rnormal(0,sige)

forvalues h=1/30{
gen x1=(x+ gam`h'*z`h')
replace x=x1
drop x1
}

replace y=slope*x+u
reg y x
scalar b = _b[x]
scalar se = _se[x]
scalar lb = b - se*invttail(e(df_r),alpha/2)
scalar ub = b + se*invttail(e(df_r),alpha/2)
scalar pv = slope<ub & slope>lb

	ivreg y (x=z*)
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
 histogram biv, freq normal title("Weaker Instrument- K2=30")  yscale(range(0 80))
 graph save "$output/MC_MI_2SLS_Weak_30_INSTR.gph", replace

 
********************************************************************************
**						3. 100  Variables
********************************************************************************
 
 //WEAK INSTRUMENT, gam=0.1, 100 INSTRUMENTs
 
 
  **100 Instruments case**
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
 scalar sigma = 100 /* error in y */
 scalar sige = 0.2 /* measurement error in e */
 
     // Instrumental Variables: 
 forvalues x=1/100{
 scalar gam`x'= 0.1
 }
 //scalar gam = 0.1 /* instrument strength */
 scalar rho = 0.5 /* Including this rho creates our endogenity issue, it measures the strength of the error in the reduced form equation having an impact on x in the structural equation */
 scalar alpha=.05 /* test size */


// We generate our data here
 forvalues x=1/100{
 gen z`x'= 5*runiform()
 }

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
replace x= rho*u+rnormal(0,sige)

forvalues h=1/100{
gen x1=(x+ gam`h'*z`h')
replace x=x1
drop x1
}

replace y=slope*x+u
reg y x
scalar b = _b[x]
scalar se = _se[x]
scalar lb = b - se*invttail(e(df_r),alpha/2)
scalar ub = b + se*invttail(e(df_r),alpha/2)
scalar pv = slope<ub & slope>lb

	ivreg y (x=z*)
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
 histogram biv, freq normal title("Weaker Instrument- K2=100")  yscale(range(0 80))
 graph save "$output/MC_MI_2SLS_Weak_100_INSTR.gph", replace
 
 
********************************************************************************
***************** 			3. Graph Combine 					  **************
 
gr combine $output/MC_OLS.gph $output/MC_MI_2SLS_Weak_TEN_INSTR.gph $output/MC_MI_2SLS_Weak_30_INSTR.gph $output/MC_MI_2SLS_Weak_100_INSTR.gph, col(2) title("2SLS Monte Carlos with weak instruments") saving(charts1, replace)

  

graph export "$output/2SLS Bias Many Instruments Graphs.pdf", replace
