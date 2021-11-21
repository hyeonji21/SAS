proc sort data=orion.continent
			out=work.continent;
	by continent_name;
run;


proc print data=&syslast;
title "Table name is &syslast";
run;


data new;
	set orion.continent;
run;
proc print data=&syslast;
title "Table name is &syslast";
run;


proc print data=orion.continent;
run;
proc print data=&syslast;
title "Table name is &syslast";
run;

