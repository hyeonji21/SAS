%macro count(opts, start, stop);
	proc freq data=orion.orders;
		where order_date between "&start"d and "&stop"d;
		table order_type / &opts;
		title1 "Orders from &start to &stop";
	run;
%mend count;

options mprint;

%count(nocum, 01jan2004, 31dec2004) /* 데이터는 2007년도부터의 데이터밖에 없음 (이 기간에 데이터가 없음.) */
%count(, 01jul2004, 31dec2004)      /* ==> 오류 x, 그냥 데이터가 없기 때문에 안나오는 것. */
	
	
/* 이렇게 수행하면 돌아감. */
%count(nocum,01jan2008,31dec2008)
%count(,01jul2007, 31dec2007)