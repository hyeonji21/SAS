/* 2. */
title 'Australian Clothing Products';
proc sql;
	select Supplier_Name format=$18. label='Supplier', Product_Group format=$12.label='Group', 
		   Product_Name format=$30. label='Product'
		from orion.product_dim
		where Product_Category='Clothes' and upcase(Supplier_Country)='AU'
		order by product_name;
quit;



/* 3. */
proc sql;
select * from orion.customer;
quit;

proc sql;
	title 'US Customers >50 Years Old as of 02FEB2013';
	select Customer_ID format=z7. label='Customer ID', 
		   catx(', ', Customer_LastName, Customer_FirstName) as Name format=$20. label='Last Name, First Name',
		   gender label='Gender', 
		   int(('02FEB2013'd-Birth_Date)/365.25) as age format=comma2. label='Age'
		from orion.customer
		where calculated age > 50 and upcase(country)='US'
		order by age desc, Name;
quit;
title;






