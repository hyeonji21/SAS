proc sql outobs=3 double;
	select distinct sum(Total_Retail_Price) as total, customer_id into :gab separated by ', ', :NEW separated by ', '
		from orion.order_fact
		group by Customer_ID
		order by total descending;
quit;

proc print data=orion.customer_dim noobs;
	where Customer_ID in (&NEW);
	var Customer_ID Customer_Name Customer_Type;
	title 'Top 3 Customers';
run;
