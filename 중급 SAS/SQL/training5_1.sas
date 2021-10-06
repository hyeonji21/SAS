proc sql;
	select *
		from airline.staffmaster;
quit;

proc sql;	
	select *
		from airline.payrollmaster;
quit;

/*
proc sql;
	select staffmaster.EmpID,
		   substr(FirstName,1,1)||'. ' ||LastName as Name,
		   int(('01JAN2010'd - DateOfHire) / 365.25) as WorkingPeriod
		from airline.staffmaster, airline.payrollmaster
	 	where calculated WorkingPeriod >= 30
	 	order by WorkingPeriod desc;
quit;
*/

proc sql;
	select substr(FirstName,1,1)||'. ' ||LastName as Name,
		   int(('01JAN2010'd - DateOfHire) / 365.25) as WorkingPeriod
		from airline.staffmaster, airline.payrollmaster
	 	where calculated WorkingPeriod >= 30 and staffmaster.EmpID = payrollmaster.EmpID
	 	order by WorkingPeriod desc;
quit;


	 		