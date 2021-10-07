/*
proc sql;
	select *
		from airline.staffmaster;
quit;

proc sql;
	select *
		from airline.supervisors;
quit;

proc contents data=airline.supervisors;
run;
*/

proc sql;
	select LastName, FirstName, JobCategory
		from airline.staffmaster as sf,
			 airline.supervisors as sp
		where sf.EmpID = sp.EmpID
		order by sf.LastName;
quit;








