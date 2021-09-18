data new;
	date = today();
	birth = '01jun1970'd;
	bmonth = month(birth);
	fullage = (date-birth)/365.25;
	age = int(fullage);
run;

proc print data=new noobs;
	format date birth date9.;
run;
