/// FWL Partialing out Age
	
	// this has done the regression and FWL Theorem approach using stata. Now we shall use mata 
	
/*

clear mata
putmata y= lwklywge X1=(age ageq) X2=(educ race married smsa neweng midatl enocent wnocent soatl esocent wsocent mt qtr120-qtr129 qtr220-qtr229 qtr320-qtr327)
mata

// make sure all our vectors and matrices are correct

y

//(X1 are our neisance variables)
X1

X2

// Then we want to find the projection matrix and annihilation matrix of X1

P1=X1*invsym(X1'X1)*X1'

P1


//Annihiliation, we create the identity matrix first:
ident=I(329509)
M1=ident-P1

// Now we want the residuals of y and X1  X2

ytilda=M1*y
X2tilda=M1*X2
	
/*
// Now we do the regression with just y tilda and X2 tilda, we can use the Cholesky Decomposition method

XX=X2tilda'*X2tilda

Xy= X2tilda'*ytilda
	
b=cholsolve(XX,Xy)	
b

// or ytilda=alpha + beta[X2Tilda) we could have done 
// b = inverse(X2Tilda'X2Tilda)*(X2Tilda'*ytilda)

b2= invsym(X2tilda'*X2tilda)*X2tilda'*ytilda
b2
*/


end


ssc install hdfe

  hdfe lwklywge educ enocent esocent married midatl mt neweng pac census qob race smsa soatl state wnocent wsocent yob cohort yr20 yr22 yr21 yr23 yr24 yr25 yr26 yr27 yr28 yr29 qtr1 qtr2 qtr3 qtr4 qtr120 qtr121 qtr122 qtr123 qtr124 qtr125 qtr126 qtr127 qtr128 qtr129 qtr220 qtr221 qtr222 qtr223 qtr224 qtr225 qtr226 qtr227 qtr228 qtr229 qtr320 qtr321 qtr322 qtr323 qtr324 qtr325 qtr326 qtr327 qtr328 qtr329 , absorb(age ageqsq) clear 
  
save "$temp/partial_out.dta", replace

ivreg2 lwklywge yr20-yr28 (educ= qtr120-qtr129 qtr220-qtr229 qtr320-qtr329)
*/
