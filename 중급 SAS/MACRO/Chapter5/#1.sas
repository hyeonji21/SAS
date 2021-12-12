/* 일일.주간 프로그램 */

%macro reports;
	proc print data=orion.order_fact_new;
		where order_date="&sysdate9"d;
		var product_id total_retail_price;
		title "Daily Sales: &sysdate9";
	run;
%if &sysday=Friday %then %do;
	proc means data=orion.order_fact_new n sum mean;
		where order_date between "&sysdate9"d-6 and "&sysdate9"d;
		var quantity total_retail_price;
		title "Weekly Sales: &sysdate9";
	run;
%end;
%mend reports;
%reports


%macro daily;
proc print data=orion.order_fact_new;
	where order_date = "&sysdate9"d
	var product_id total_retail.price;
	title "Daily sales: &sysdate9";
run;
%mend daily;

%macro weekly;
proc print data=orion.order_fact_new;
	where order_date between "&sysdate9"d-6 and "&sysdate9"d;
	var quantity total_retail_price;
	title "Weekly sales: &sysdate9";
run;
%mend weekly;

%macro reports;
	%daily
	%if &sysday=Friday %then %weekly;
%mend reports;
%reports