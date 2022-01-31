data work.ACT01 (drop=i);
	set sashelp.pricedata;

	array p[17] price1-price17;
	do i=1 to 17;
		p[i] = p[i] * 0.1;
	end;
run;

proc print data=work.ACT01;
run;


data _null_;
	set sashelp.cars (obs=1);
	call symputx('CarMaker', Make);
run;

%put &=CarMaker;
proc print data=sashelp.cars;
run;

proc sql;
	create table work.SQL01 as
	select Make, avg(MPG_CITY) as AvgCityMPG format=comma10.2
		from sashelp.cars
		group by Make;
quit;

proc sql;
	select * from work.sql01;
quit;




















