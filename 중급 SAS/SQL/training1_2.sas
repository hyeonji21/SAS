proc sql;
	select *
		from airline.payrollmaster;
quit;

proc sql;
	select empID, gender, jobcode, salary
		from airline.payrollmaster;
quit;

proc sql;
	select empID, gender, jobcode, salary * 1 as salary, salary / 3 as Tax
		from airline.payrollmaster;
quit;
