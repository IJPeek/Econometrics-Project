/*The is the Masterdofile
	// The project's output is run through this masterdofile. It remotely calls and runs the other dofiles to perform each task.
	
	// Please set your environment in the _setup.do dofile we have provided for you and the code should run for you by calling on macros throughout the rest of the dofiles.
	
*/
	
	
	//Please run your _setup.do file and then proceed.
	
	// 1. Import of the AK91 Dataset
		// This dofile imports, renames, labels and saves the Angrist Krueger 1991 datasets
		clear
	 run "$dofile/1. Data import and cleaning.do"
	 
	// 2. Tests on Specifications and iV Identifying Assumptions
		//This dofile generates 2SLS estimates and perform the tests for: heteroskedasticity, test on restrictions: overidentifying and underidentifying restrictions and weak instruments
	
	run "$dofile/2. Tests on Specifications and iV Identifying Assumptions.do"
	
	
	
	
	
	
	
	
	
		
		*/
		

