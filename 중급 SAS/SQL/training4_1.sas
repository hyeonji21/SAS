title1 '2월 입사한 직원';

proc sql;
	select EmpID, FirstName, LastName
	from airline.staffmaster
	where EmpID in
		(select EmpID
		from airline.payrollmaster
		where month(DateOfHire)=2);
quit;

/* (같은 결과)
proc sql;
	select EmpID, FirstName, LastName
	from airline.staffmaster
	where EmpID in
		(select EmpID
		from airline.payrollmaster
		where month(DateOfHire)=2)
	order by LastName asc;
quit;
*/

proc sql;
	select *
	from airline.payrollmaster;
quit;
