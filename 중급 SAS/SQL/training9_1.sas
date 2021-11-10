proc sql;
	describe table dictionary.columns;
quit;
proc sql;
	title 'Columns in the AIRLINE.PAYROLLMASTER Table';
	select name
		from dictionary.columns
		where libname='AIRLINE' AND MEMNAME='PAYROLLMASTER';
quit;



