proc sql;
	select Name, FFID
	from airline.frequentflyers
	where Name like '%, N%';
quit;

proc sql;
	select EmpID, JobCode
	from airline.payrollmaster
	where jobcode like 'F__';
quit;

/* 예시) */
proc sql;
	select EmpID, JobCode
		from airline.payrollmaster
		where jobcode like 'FA/_2' ESCAPE '/';
quit;

