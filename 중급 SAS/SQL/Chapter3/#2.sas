proc sql;
	select EmpID label='Employee Identifier',
			JobCode label='Job Code',
			Salary label='Annual Salary'
					format=dollar12.2
		from airline.payrollmaster
		where JobCode contains 'NA'
		order by Salary desc;
quit;

proc sql;
title 'Current Bonus Information';
title2 'Navigators - All Levels';
	select EmpID
			label='Employee Identifier',
			'Bonus is:',
			Salary *.05 format=dollar12.2
		from airline.payrollmaster
		where JobCode contains 'NA'
		order by Salary desc;
quit;
