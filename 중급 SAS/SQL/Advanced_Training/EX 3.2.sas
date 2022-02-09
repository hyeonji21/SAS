/* 4. */
proc sql;
title 'Cities Where Employees Live';
	select city, count(*) as count
		from orion.employee_addresses
		group by city;
quit;
title;


/* 5.*/
proc sql;
title 'Age at Employement';
	select employee_id, birth_date format=MMDDYY10., employee_hire_date format=MMDDYY10., 
		   int((employee_hire_date - birth_date)/365.25) as age
		from orion.employee_payroll;
quit;
title;


/* 6. (다시풀기)*/
proc sql;
	select * from orion.customer;
quit;
proc sql;
	describe table orion.customer;
quit;


proc sql;
title 'Customer Demographics: Gender by Country';
	select country label='Customer Country', count(*) as Customers, 
		   sum(Gender='M') as Men,
		   sum(Gender='F') as Women,
		   calculated Men / calculated Customers as Percent_Male label='Percent Male' format=percent6.1
		from orion.customer
		group by country
		order by Percent_Male;
quit;
title;
		   
		   
/* 7. */		   
proc sql;
	select country, male_customers, female_customers
		from orion.customer;
quit;

proc sql;
title 'Countries with More Female than Male Customers';
	select country label='Country',
		   sum(Gender='M') as Men 'Male Customers',
		   sum(Gender='F') as Women 'Female Customers'
		from orion.customer
		group by country
		having Women > Men
		order by Women desc;
quit;
title;



/* 8. */
proc sql;
	select * from orion.employee_addresses;
quit;

proc sql;
title 'Countries and Cities Where Employees Live';
	select upcase(Country) 'Country', 
		   propcase(City) 'City', 
		   count(*) 'Employees'
		from orion.employee_addresses
		group by country, city
		order by country, city;
quit;
title;
		   
		   
		   
		   
		   
		   
		   
		   
		   
		   
		   
		   
		   