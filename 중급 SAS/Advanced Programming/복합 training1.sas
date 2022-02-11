/* 1 */
%macro customers(type);
	proc print data=orion.customer_dim;
		var customer_name customer_gender customer_age;
		where customer_group contains "&type";
		title "&type customers";
	run;
%mend customers;
%customers(Gold);


%macro customers(type=Club);
	proc print data=orion.customer_dim;
		var customer_name customer_gender customer_age;
		where customer_group contains "&type";
		title "&type customers";
	run;
%mend customers;
%customers(type=Internet);
%customers();

/* 2 */
%macro orderstats(libs=orion, datas=order_fact, stats=mean, var=total_retail_price);
	proc means data=&libs..&datas. &stats;
		var &var;
		class order_type;
	run;
%mend orderstats;
%orderstats();
%orderstats(libs=orion, datas=order_fact, stats=mean, var=total_retail_price);
%orderstats(var=total_retail_price, datas=order_fact);

/* 3 */
%macro problem4(type);
	


/* 4 */
%macro split;
	data _null_;
		set orion.customer end=last;
		%local _n_;
		call symputx('site'||left(_n_), country);
		if last then call symputx('count',_n_);
	run;
%mend split;

%split;
%put &site;
%put &count;















