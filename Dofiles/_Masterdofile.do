/*The is the Masterdofile
	// The project's output is run through this masterdofile. It remotely calls and runs the other dofiles to perform each task.
	
	// Please set your environment in the _setup.do dofile we have provided for you and the code should run for you by calling on macros throughout the rest of the dofiles.
	
*/
	
	
	//Please run the _setup.do file and then proceed. This is where to set your environment by setting where the folder is located on your computor.
	
	// 1. Import of the AK91 Dataset
		// This dofile imports, renames, labels and saves the Angrist Krueger 1991 datasets
clear

	 run "$dofile/1. Data import and cleaning.do"
	 
	// 2. Tests on Specifications and iV Identifying Assumptions
		//This dofile generates 2SLS estimates and perform the tests for: 	heteroskedasticity, test on restrictions: overidentifying and underidentifying restrictions and weak instruments
	
	// This dofile sometimes will not run remotely, it will run if you open it and run it directly
	run "$dofile/2. Tests on Specifications and IV Identifying Assumptions.do"
	
	// 3. Calculating our point estimates robust to weak instruments
	
	run "$dofile/3. Point Estimates.do"
	
	
	// 4. Confidence intervals robust to weak instruments
	
	run "$dofile/4. Confidence sets robust to weak instruments.do" 
	
	// 5. Monte Carlos
	
	// For one instrument
	run "$dofile/5.1  Monte Carlo Simulations.do"
	
	// For many instruments 
	run "$dofile/5.2 Monte Carlo Simulations- Many 2SLS.do"
	
	run "$dofile/5.3 Monte Carlos LIML FULL, Many Instruments.do"
		

		

