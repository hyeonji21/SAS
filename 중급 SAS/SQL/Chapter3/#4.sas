proc sql;
	select avg(salary) as MeanSalary
		from airline.payrollmaster;
quit;

proc means data=airline.payrollmaster mean;
	var Salary;
run;
