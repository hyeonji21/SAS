%macro calc;
	proc means data=orion.order_item &stats;
		var &vars;
	run;
%mend calc;

%let stats=min max;
%let vars=quantity;
%calc;

option mprint; /* 어떤 macro 코드가 작동되는지 로그에 보여주는 것 */
option mprint symbolgen; /* 참조된 내용을 보여주는 것 */

%let stats=n mean;
%let vars=discount;
%calc
