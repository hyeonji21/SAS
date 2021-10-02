/* Noncorrelated Subqueries */

proc sql;
	select JobCode, avg(Salary) as MeanSalary
		from airline.payrollmaster
		group by JobCode
		having avg(Salary) > 
			(select avg(Salary)
				from airline.payrollmaster);
quit;

proc sql;
	select LastName, FirstName, City, State
		from airline.staffmaster
		where EmpID in
			(select EmpID
				from airline.payrollmaster
				where month(DateofBirth)=2);
quit;
