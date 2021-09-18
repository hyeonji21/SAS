/* -매년 Salary 32% 인상 */
/* -매년 인상된 총 금액 / 5년뒤 최종 월급 */
/* -최종 월급과 최초 월급의 차 */


proc print data=airline.payrollmaster;
run;

data work.increase;
	set airline.payrollmaster;
	do year=1 to 5;
		Salary = Salary * 1.32;
		output;
	end;
run;

proc print data=work.increase;
run;











