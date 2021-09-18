data new;
	name = 'Gomez, Gabriela  ';
	fname1 = substr(name, 8) || '' || substr(name, 1, 5);
	fname2 = trim(substr(name, 8)) || '' || substr(name, 1, 5);
run;
proc print data=new noobs;
run;
