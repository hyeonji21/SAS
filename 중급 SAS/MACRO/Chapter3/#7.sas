%macro count(opts=, start=01jan08, stop=31dec08);
proc freq data=orion.orders;
	where order_date between "&start"d and "&stop"d;
	table order_type / &opts;
	title1 "Orders from &start to &stop";
run;
%mend count;
options mprint;
%count(opts=nocum);
%count(stop=01jul07, opts=nocum nopercent);
%count();
%count(opts=nocum nopercent, stop=30jul07);