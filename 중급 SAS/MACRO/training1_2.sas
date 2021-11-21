options SYMBOLGEN;
%let new1=Gold;
proc print data=orion.customer_dim;
	var Customer_Name Customer_Gender Customer_Age;
	where Customer_Group contains "&new1";
	title "&new1 Customers";
run;

options SYMBOLGEN;
%let new1=Internet;
proc print data=orion.customer_dim;
	var Customer_Name Customer_Gender Customer_Age;
	where Customer_Group contains "&new1";
	title "&new1 Customers";
run;
