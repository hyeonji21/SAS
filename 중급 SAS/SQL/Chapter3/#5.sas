proc sql;
	select count(*) as count
		from airline.payrollmaster;
quit;


proc sql;
	select substr(JobCode, 1, 2)
			label='Job Category',
			count(*) as count
		from airline.payrollmaster
		group by 1;
quit;


proc sql;
	select EmpID, Salary, (Salary/sum(Salary)) as percent format=percent8.2
		from airline.payrollmaster
		where JobCode contains 'NA';
quit;
