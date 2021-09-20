proc sql;
	select *
		from airline.payrollmaster;
quit;

proc sql;
	describe table airline.payrollmaster;
quit;

proc sql;
	select EmpID, JobCode, Salary, Salary * .10 as Bonus  /* 4번째 column 새롭게 만들기 */
		from airline.payrollmaster;
quit;

proc sql;
	select EmpID, JobCode, int((today()-DateOfBirth) / 365.25) as Age
		from airline.payrollmaster;
quit;

proc sql;
	select JobCode, substr(JobCode, 3) as JobLevel, DateOfHire, Gender
		from airline.payrollmaster;
quit;

