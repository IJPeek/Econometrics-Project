**100

putexcel set $output/Monte_Carlos_Many100.xlsx, modify
putexcel C1 = "Strongest Instrument 100"
putexcel B2 = "LIML Mean"
putexcel B3 = "FULL Mean"
putexcel B4 = "LIML SD"
putexcel B5 = "FULL SD"
putexcel B6 = "LIML Median"
putexcel C1 = "Weaker Instrument 100"
 //Strong INSTRUMENT, gam=1, 100 INSTRUMENTs
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
 scalar gam`x'=1
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
  summarize b, d
  
// LIML output
putexcel C2 = `r(mean)'
putexcel C4 = `r(sd)'
putexcel C6 = `r(p50)'

 summarize bful

// FULL output
putexcel C3 = `r(mean)'
putexcel C5 = `r(sd)'
 
 
 

 histogram b, freq normal title("LIML-Strong Instrument, K2=100 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_Many_LIML-Strong_100.gph", replace

 histogram bful, freq normal title("FULL-Stronger Instrument, K2=100 ") yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_Many_FULLER1-Strong_100.gph", replace 


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
 scalar gam`x'=0.1
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
  summarize b, d

putexcel D1 = "Weak Instruments, 100"
putexcel D2 = `r(mean)'
putexcel D4 = `r(sd)'
putexcel D6 = `r(p50)'

 summarize bful
putexcel D3 = `r(mean)'
putexcel D5 = `r(sd)'

 
 
 

 histogram b, freq normal title("LIML-Weaker Instrument, K2=100 ")  yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_Many_LIML-Weaker_100.gph", replace

 histogram bful, freq  normal title("FULL-Weaker Instrument, K2=100 ") yscale(range(0 80))
 graph save "$output/Monte_Carlos/MC_Many_FULLER1-Weaker_100.gph", replace 
 
 
gr combine $output/Monte_Carlos/MC_Many_LIML-STRONG_100.gph $output/Monte_Carlos/MC_Many_FULLER1-STRONG_100.gph $output/Monte_Carlos/MC_Many_LIML-Weaker_100.gph $output/Monte_Carlos/MC_Many_FULLER1-Weaker_100.gph, col(2) title("LIML and FULL  Monte Carlos 100 instruments") saving(charts1, replace)
graph export "$output/MC 100 LIML vs FULL.pdf", replace
 