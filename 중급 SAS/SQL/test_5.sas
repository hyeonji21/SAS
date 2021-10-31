proc sql;
	select distinct jobcode, max(Salary) as Max_Salary
		from airline.payrollmaster
		group by jobcode;
quit;

/* ----------------------------------------------------- */

proc sql;
	select empid, jobcode, max(Salary) as Max_Salary
		from airline.payrollmaster
		group by jobcode
		order by EmpID;
quit;