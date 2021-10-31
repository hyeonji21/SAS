proc sql;
	select LastName, FirstName, 
	   	int((today() - DateOfHire) / 365.25) as WorkingPeriod
		from airline.payrollmaster, airline.staffmaster;
quit;

/* ------------------------------------------------------------------ */

proc sql;
	select LastName, FirstName, 
	   	int((today() - DateOfHire) / 365.25) as WorkingPeriod
		from airline.payrollmaster, airline.staffmaster
		having WorkingPeriod=max(WorkingPeriod);
quit;