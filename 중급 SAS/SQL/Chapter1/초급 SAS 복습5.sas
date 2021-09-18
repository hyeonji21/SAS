/* EmpID 기준으로 첫 10개 뽑기 -> 새로운 DATA SET 만들기 */

proc sort data=airline.payrollmaster
	out=work.new;
	by EmpID;
run;
proc print data=work.new;
run;


data work.new2;	
	set work.new(obs=10);
	by EmpID;
run;
proc print data=work.new2;
run;


/* 평균 나이, 평균 Salary */

data work.new2;
	set work.new;
	date = today();
	bmonth = month(DateOfBirth);
	fullage = (date - DateOfBirth) / 365.25;
	age = int(fullage);
	
run;

proc print data=work.new2;
	format date birth date9.;
run;

proc means data=work.new2 mean maxdec=0;
	var age salary;
run;
