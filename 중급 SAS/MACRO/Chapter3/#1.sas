/* macro compilation */
/* 직접 만든 MACRO */

options mcompilenote=all;
%macro time;
	%put The current time is %sysfunc(time(), timeampm.).;
%mend time; /*적어도 되고 안적어도 되는 부분 */

%time