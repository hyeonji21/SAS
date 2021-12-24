/* work.fa 데이터 만드는 과정 (추후 배울 예정) */
proc sql;
	create table work.fa as
	select LastName, FirstName, 
			staffmaster.EmpID, jobcode
		from airline.staffmaster,
			airline.payrollmaster
		where staffmaster.empid = payrollmaster.empid
		and jobcode contains 'FA';
quit;

proc sql;
	select LastName, FirstName
		from work.fa
		where not exists
			(select *
				from airline.flightschedule
				where fa.EmpID=flightschedule.EmpID);
quit;
