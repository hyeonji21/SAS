/* macro parameter */

%macro calc(stats, vars);
	proc means data=orion.order_item &stats;
		var &vars;
	run;
%mend calc;

%calc(min max, quantity)

%calc(mean std median, discount) /* discount에 대해서 stats 값 */

%calc(mean std median min max, discount quantity)
/*marco 미리 만들어놓고 어디서든지 사용하기 */
