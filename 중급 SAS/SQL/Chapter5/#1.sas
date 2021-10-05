title 'New York Employees';

proc sql;
	select substr(FirstName,1,1) || '. ' || LastName as Name,
			JobCode,
			int((today()-DateOfBirth)/365.25) as Age
		from airline.payrollmaster, airline.staffmaster
		where payrollmaster.EmpID = staffmaster.EmpID and State='NY'
		order by JobCode;
quit;

