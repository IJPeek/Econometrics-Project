/* Comparing FULL and LIML


*/

********************* 10  Variables
*******************************************************************************
******* 		Data Generating Process Set up
*******************************************************************************


	// STRONG INSTRUMENT, 10 INSTUMENTS
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
// scalar gam1 = 1 /* instrument strength */
// scalar gam2 = 1
 
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
postfile `sim' b bfull using results, replace
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


ivreg2 y (x=z*), liml
 scalar b=e(b)[1,1]
		ivreg2 y (x=z*), fuller(1)
scalar bful=e(b)[1,1]
		post `sim' (b) (bful)
		}
		
	}
postclose `sim'
end

 regIV 
 use results, clear
 summarize
 
 
 histogram b, freq normal title("LIML-Strong Instrument, 10 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_Many_LIML-STRONG_10.gph", replace

 histogram bful, freq normal title("FULL-Strong Instrument, 10 ") yscale(range(0 80)) 
 graph save "$output/Monte_Carlos/MC_Many_FULLER1-STRONG_10.gph", replace 
 
 
 
		//WEAK INSTRUMENT, gam=0.1, 10 INSTRUMENTs
 **10 Instruments case**
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
postfile `sim' b bful using results, replace
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


ivreg2 y (x=z*), liml
 scalar b=e(b)[1,1]
		ivreg2 y (x=z*), fuller(1)
scalar bful=e(b)[1,1]
		post `sim' (b) (bful)
		}
		
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize
 

 histogram b, freq normal title("LIML-Weaker Instrument, 10 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_Many_LIML-Weaker_10.gph", replace

 histogram bful, freq normal title("FULL-Weaker Instrument, 10 ") yscale(range(0 80)) 
 graph save "$output/Monte_Carlos/MC_Many_FULLER1-Weaker_10.gph", replace 
 
 sum, d
 //LIML mean.   .62269 median 1.032
 //FULLER1 mean 1.16 median 1.23
  
 
 //WEAK INSTRUMENT, gam=0.1, 30 INSTRUMENTs
  **30 Instruments case**
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
postfile `sim' b bful using results, replace
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

replace y=slope*x+u


ivreg2 y (x=z*), liml
scalar b=e(b)[1,1]
		ivreg2 y (x=z*), fuller(1)
scalar bful=e(b)[1,1]
		post `sim' (b) (bful)
		}
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize, d
 
 // LIML mean  .1744597 median  1.061071   
 // FULL mean 1.752715 median  1.612516  
 // SD LIML  43.14402 FULL .616754

 histogram b, freq normal title("LIML-Weaker Instrument, K2=30 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_Many_LIML-Weaker_30.gph", replace

 histogram bful, freq normal title("FULL-Weaker Instrument, K2=30 ") yscale(range(0 80)) 
 graph save "$output/Monte_Carlos/MC_Many_FULLER1-Weaker_30.gph", replace 
 

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
 scalar gam`x'= .1
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
postfile `sim' b bful using results, replace
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


ivreg2 y (x=z*), liml
scalar b=e(b)[1,1]
		ivreg2 y (x=z*), fuller(1)
scalar bful=e(b)[1,1]
		post `sim' (b) (bful)
		}
		
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize, d
 
// LIML median  1.699635  mean 4.08146 sd  64.19494
// FULL median  2.236257  mean 2.487303 sd  .576075
 histogram b, freq normal title("LIML-Weaker Instrument, K2=100 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_Many_LIML-Weaker_100.gph", replace

 histogram bful, freq normal title("FULL-Weaker Instrument, K2=100 ") yscale(range(0 80)) 
 graph save "$output/Monte_Carlos/MC_Many_FULLER1-Weaker_100.gph", replace 
 

gr combine $output/Monte_Carlos/MC_Many_LIML-STRONG_10.gph $output/Monte_Carlos/MC_Many_LIML-Weaker_10.gph $output/Monte_Carlos/MC_Many_LIML-Weaker_30.gph $output/Monte_Carlos/MC_Many_LIML-Weaker_100.gph, col(2) title("LIML Monte Carlos increasing instruments") saving(charts1, replace)
graph export "$output/LIML Bias Many Instruments Graphs.pdf", replace




gr combine $output/Monte_Carlos/MC_Many_FULLER1-STRONG_10.gph $output/Monte_Carlos/MC_Many_FULLER1-Weaker_10.gph 
$output/Monte_Carlos/MC_Many_FULLER1-Weaker_30.gph $output/Monte_Carlos/MC_Many_FULLER1-Weaker_100.gph, col(2) title("FULL Monte Carlos increasing instruments") saving(charts1, replace)
graph export "$output/FULL Bias Many Instruments Graphs.pdf", replace
/* Comparing FULL and LIML


*/

********************* 10  Variables
*******************************************************************************
******* 		Data Generating Process Set up
*******************************************************************************


	// STRONG INSTRUMENT, 10 INSTUMENTS
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
// scalar gam1 = 1 /* instrument strength */
// scalar gam2 = 1
 
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
postfile `sim' b bfull using results, replace
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


ivreg2 y (x=z*), liml
 scalar b=e(b)[1,1]
		ivreg2 y (x=z*), fuller(1)
scalar bful=e(b)[1,1]
		post `sim' (b) (bful)
		}
		
	}
postclose `sim'
end

 regIV 
 use results, clear
 summarize
 
 
 histogram b, freq normal title("LIML-Strong Instrument, 10 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_Many_LIML-STRONG_10.gph", replace

 histogram bful, freq normal title("FULL-Strong Instrument, 10 ") yscale(range(0 80)) 
 graph save "$output/Monte_Carlos/MC_Many_FULLER1-STRONG_10.gph", replace 
 
 
 
		//WEAK INSTRUMENT, gam=0.1, 10 INSTRUMENTs
 **10 Instruments case**
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
postfile `sim' b bful using results, replace
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


ivreg2 y (x=z*), liml
 scalar b=e(b)[1,1]
		ivreg2 y (x=z*), fuller(1)
scalar bful=e(b)[1,1]
		post `sim' (b) (bful)
		}
		
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize
 

 histogram b, freq normal title("LIML-Weaker Instrument, 10 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_Many_LIML-Weaker_10.gph", replace

 histogram bful, freq normal title("FULL-Weaker Instrument, 10 ") yscale(range(0 80)) 
 graph save "$output/Monte_Carlos/MC_Many_FULLER1-Weaker_10.gph", replace 
 
 sum, d
 //LIML mean.62269 median 1.032
 //FULLER1 mean .1.16 median 1.23
  
 
 //WEAK INSTRUMENT, gam=0.1, 30 INSTRUMENTs
  **30 Instruments case**
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
postfile `sim' b bful using results, replace
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

replace y=slope*x+u


ivreg2 y (x=z*), liml
scalar b=e(b)[1,1]
		ivreg2 y (x=z*), fuller(1)
scalar bful=e(b)[1,1]
		post `sim' (b) (bful)
		}
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize, d
 
 // LIML mean  .1744597 median  1.061071   
 // FULL mean 1.752715 median  1.612516  
 // SD LIML  43.14402 FULL .616754

 histogram b, freq normal title("LIML-Weaker Instrument, K2=30 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_Many_LIML-Weaker_30.gph", replace

 histogram bful, freq normal title("FULL-Weaker Instrument, K2=30 ") yscale(range(0 80)) 
 graph save "$output/Monte_Carlos/MC_Many_FULLER1-Weaker_30.gph", replace 
 

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
 scalar gam`x'= .1
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
postfile `sim' b bful using results, replace
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


ivreg2 y (x=z*), liml
scalar b=e(b)[1,1]
		ivreg2 y (x=z*), fuller(1)
scalar bful=e(b)[1,1]
		post `sim' (b) (bful)
		}
		
	}
postclose `sim'
end

 regIV
 use results, clear
 summarize, d
 
 
 

 histogram b, freq normal title("LIML-Weaker Instrument, K2=100 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_Many_LIML-Weaker_100.gph", replace

 histogram bful, freq title("FULL-Weaker Instrument, K2=100 ") yscale(range(0 80)) xscale(range(0 4))
 graph save "$output/Monte_Carlos/MC_Many_FULLER1-Weaker_100.gph", replace 
 

gr combine $output/Monte_Carlos/MC_Many_LIML-STRONG_10.gph $output/Monte_Carlos/MC_Many_LIML-Weaker_10.gph $output/Monte_Carlos/MC_Many_LIML-Weaker_30.gph $output/Monte_Carlos/MC_Many_LIML-Weaker_100.gph, col(2) title("LIML Monte Carlos increasing instruments") saving(charts1, replace)
graph export "$output/LIML Bias Many Instruments Graphs.pdf", replace




gr combine $output/Monte_Carlos/MC_Many_FULLER1-STRONG_10.gph $output/Monte_Carlos/MC_Many_FULLER1-Weaker_10.gph $output/Monte_Carlos/MC_Many_FULLER1-Weaker_30.gph $output/Monte_Carlos/MC_Many_FULLER1-Weaker_100.gph, col(2) title("FULL Monte Carlos increasing instruments") saving(charts1, replace)
graph export "$output/FULL Bias Many Instruments Graphs.pdf", replace
