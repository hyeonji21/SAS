proc sql;
select memname
	from dictionary.tables
	where libname='ORION';
quit;


proc sql;
select memname
	from dictionary.columns
	where libname='ORION' and UPCASE('CUSTOMER_ID');
quit;


proc sql;
	describe table dictionary.columns;
quit;
proc sql;
	select name 
		from dictionary.columns
		where libname='ORION' AND MEMNAME='EMPLOYEES';
quit;






