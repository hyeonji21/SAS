proc sql;
	create unique index EmpID
	on airline.payrollmaster (EmpID);
quit;

proc print data=airline.payrollmaster;
run;

proc sql;
	create unique index daily
	on airline.marchflights(FlightNumber, Date);
quit;
