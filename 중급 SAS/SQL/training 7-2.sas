proc sql;
title 'February employees';
	select EmpID, FirstName, LastName
		from airline.staffmaster
		where staffmaster.EmpID in (select EmpID
										from airline.payrollmaster
										where month(DateOfHire)=2)
		order by LastName;
quit;