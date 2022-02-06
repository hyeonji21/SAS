/* 1. */
proc sql;
	select distinct City
		from orion.employee_addresses
	;
quit;


/* 2. */
proc sql;
	select *
		from orion.employee_donations
	;
quit;

proc sql;
	select distinct employee_id, recipients, sum(qtr1, qtr2, qtr3, qtr4) as Total
		from orion.employee_donations
		where calculated Total > 90
	;
quit;

/* 3. */
proc sql;
	select employee_id, recipients
		from orion.employee_donations
		where recipients like '%Inc. 90~%' ESCAPE '~';
quit;


















