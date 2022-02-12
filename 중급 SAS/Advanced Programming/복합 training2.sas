/* 3 exam */
/* 5 */

%let date="01jan2016"d;
proc print data=orion.orders;
 format Order_date Delivery_date date9.;
 where Order_date between &date and "&sysdate9"d;
run; 

%let date="01jan2017"d;
proc print data=orion.orders;
 format Order_date Delivery_date date9.;
 where Order_date between &date and "&sysdate9"d;
run; 

/* 4 exam */
/* 1 */


/* 2 */
/* (1), (2) */
%macro two(j);
	proc sql;
		select employee_id, name, marital_status
		from orion.employees
		where job_title contains &j;
		title " &j Emplyees ";
	quit; 
%mend two;
%two("Secretary");


/* (3), (4) */
%macro two(j="Sales");
	proc sql;
		select employee_id, name, marital_status
		from orion.employees
		where job_title contains &j;
		title " &j Emplyees ";
	quit;
%mend two;
%two(j="Assistant");
/* (5) */
%two();


/* 3 */
%macro three(var) / minoperator;
	%if &var in Empid Gender Jobcode Salary DateofBirth DateofHire %then %do;
	proc sql; 
		select * from airline.payrollmaster
		order by empid, &var asc;
	quit;
	%end;
	%else%if &var is null %then %do;
	proc sql;
		select * from airline.payrollmaster;
	quit;
	%end;
	%else %do;
		%put Please choose another variable!;
	%end;
%mend three;

%three(); /* 못함 */
%three(Jobcode);
%three(aa);

/*4*/
/* (1) */
%macro year(year1, year2);
%do year=&year1 %to year=&year2;
proc means data=orion.order_fact mean maxdec=2;
	var Total_retail_price;
	where year(order_date) = year;
	title "Order year: &year1-&year2 ";
run;
%end;
%mend year;

%year(2007, 2011);



/* (2) */
%macro year2;
data _null_;
	set orion.order_fact end=last;
	if last then call symputx(endyear, year(order_date));
run;
%do year=2007 %to year=&endyear;
proc means data=orion.order_fact mean maxdec=2;
var Total_retail_price;
where year(order_date) = year;
title " Order year: &endyear";
run;
%end;
%mend year2;
%year2();







