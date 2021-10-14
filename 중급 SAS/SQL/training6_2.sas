proc sql;
select *
	from airline.payrollchanges
	union corr
select *
	from airline.staffchanges;
quit;


proc sql;
select *
	from airline.payrollchanges;
quit;

proc sql;
select *
	from airline.staffchanges;
quit;









