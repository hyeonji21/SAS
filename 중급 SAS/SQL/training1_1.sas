data new;
	name = "Lee Hyeon Ji";
	birth = '10may2001'd;
	id = 2020380501;
run;

proc print data=new;
	format birth date9.;
run;


