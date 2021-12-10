options mprint;
%let type=Gold;
%macro customers;
proc print data=orion.customer_dim;
	var Customer_Name Customer_Gender Customer_Age;
	where Customer_Group contains "&type";
	title "&type Customers";
run;
%mend customers;
%customers;


%macro customers(type);
proc print data=orion.customer_dim;
	var Customer_Name Customer_Gender Customer_Age;
	where Customer_Group contains "&type";
	title "&type Customers";
run;
%mend customers;
%customers(Gold);


%macro customers(type);
proc print data=orion.customer_dim;
	var Customer_Name Customer_Gender Customer_Age;
	where Customer_Group contains "&type";
	title "&type Customers";
run;
%mend customers;
%customers(Catalog);


%macro customers(type=Gold);
proc print data=orion.customer_dim;
	var Customer_Name Customer_Gender Customer_Age;
	where Customer_Group contains "&type";
	title "&type Customers";
run;
%mend customers;
%customers(type=Internet);

