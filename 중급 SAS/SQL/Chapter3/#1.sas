proc sql;
	select EmpID, JobCode, Salary
		from airline.payrollmaster
		where JobCode contains 'NA'
		order by Salary desc;
quit;

proc sql;
	select FlightNumber, Date, Origin, Destination,
			Boarded+Transferred+Nonrevenue
		from airline.marchflights
		where Destination='LHR'
		order by Date, 5 desc;
quit;

