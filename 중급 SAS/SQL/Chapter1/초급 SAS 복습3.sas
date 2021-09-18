data new;
	name = 'Gomez, Gabriela  ';
	first = scan(name, 2, ',');
	last = scan(name, 1, ',');
	fname = 'Ms.'||trim(first)||''||last;
run;
proc print data=new;
run;

/* fname 문자 길이 확인하고 싶을 때 */
proc contents; 
run;