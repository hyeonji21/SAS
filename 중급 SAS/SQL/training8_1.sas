proc sql;
	create table work.payrollmaster as
		select *
			from airline.payrollmaster;
quit;

proc sql;
	create index JobCode
		on work.payrollmaster(JobCode);
quit;

proc contents data=work.payrollmaster;
quit;


