/* macro 참조되지 않는 예제 */
proc freq data=macro.Customer;
	table Country / nocum;
	footnote1 'Created &systime &sysday, &sysdate9';
	footnote2 'By user &sysuserid on system &sysscpl';
run;

/* macro 참조되는 예제 */
proc freq data=macro.Customer;
	table Country / nocum;
	footnote1 "Created &systime &sysday, &sysdate9";
	footnote2 "By user &sysuserid on system &sysscpl";
run;
