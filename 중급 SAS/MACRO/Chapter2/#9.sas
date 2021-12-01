%let statement = title "Payroll Report";   /*세미콜론 포항하여 title을 출력하고 싶다 */
%put &statement;


/* title "Payroll report"; 대신에 */
&statement;
proc print data=orion.orders;
run;


%let statement = %str(title "Payroll Report");  /* statement variable에 세미콜론까지 저장되었음을 알 수 있다. */
%put &statement

%let P=aaa;

%let statement = %str(title "S&P ROO")

