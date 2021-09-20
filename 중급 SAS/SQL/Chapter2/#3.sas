proc sql;
	select *
		from airline.internationalflights;
quit;

proc sql;
	select distinct FlightNumber, Destination
		from airline.internationalflights;
quit;

proc sql;
	select EmpID, JobCode, Salary 
		from airline.payrollmaster
		where Salary > 112000;
quit;


	