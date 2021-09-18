proc sql;	
	select EmpID, Gender, JobCode, Salary, Salary/3 as Tax
		from airline.payrollmaster;
quit;

proc sql;
	select EmpID, Gender, JobCode, Salary, Salary/3 as Tax
	from airline.payrollmaster
	where Gender='M' and JobCode contains 'FA'
	order by Salary desc;
quit;


