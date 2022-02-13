/* 3 exam */

/* 4 */
proc sql;
select memname
	from dictionary.tables
	where libname='ORION';
quit;

/* 5 */
%put Today is &syslast;
%put Time is &systime;
%put Date is &sysdate9;

/* 6 */
%let date=01jan2017;
proc means data=orion.employees2 n;
	where Hire_date between "&date"d and "&sysdate9"d;
	var Employee_id;
run;



/* 4 exam */
/* 1 */
%macro weekly;
proc print data=orion.order_fact_new;
	var product_id order_type quantity total_retail_price;
	where order_date between "&sysdate9"d and "&sysdate9"d+6;
run;
%mend weekly;
%weekly;


/* 2 */ /*안됨*/


/* 3 */
%macro def(var, dataset, lib=airline); 
proc sql;
	select &var
	from &lib..&dataset;
quit;
%mend def;
%def(total_retail_price, order_fact_new, lib=orion);
%def(*, payrollmaster);
%def(%str(Jobcode,Salary), payrollmaster, lib); 


/* 4 */
%macro definition(j) / minoperator;
	proc sql noprint;
		select distinct jobcode into :list separated by ' '
			from airline.payrollmaster;
	quit;
	
	%if &j = %then %do;
	proc print data=airline.payrollmaster;
		var empid jobcode salary;
	run;
	%end;
	
	%else %if &j in &list %then %do;
	proc print data=airline.payrollmaster;
		var empid jobcode salary;
		where jobcode="&j";
	run;
	%end;

	%else %do;
		%put Sorry, no employees from &j..;
		%put Please enter valid jobcode one of &list..;
	%end;
%mend definition;
%definition(); 
%definition(ME1);
%definition(MA1); 
















