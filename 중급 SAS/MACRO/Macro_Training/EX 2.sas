/* 1. */
%put _automatic_;
%put &syslast;
%put &sysuserid;
%put &systime;
%put &sysdate9;

/* 2. */
proc sort data=orion.continent
			out=work.continent;
		by Continent_name;
run;

title "&syslast";
proc print data=&syslast;
run;

/* 3. */
data new;
	set &syslast;
run;

proc print data=&syslast;
run;

/* 11. */
%let fullname=Anthony Miller;
%let new=%substr(&fullname, 1, 1). %scan(&fullname, 2, ' ');

%put &new;


/* 12. */
%put %sysfunc(today(), mmddyyp10.);
%put %sysfunc(time(), timeampm.);


/* 14. */
%let birth_date=10MAY2001;
%put %sysfunc(putn("&birth_date"d, downame.));















