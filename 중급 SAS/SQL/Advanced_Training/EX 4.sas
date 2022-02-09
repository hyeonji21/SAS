/* 1. */
proc sql;
title1 'Employees With More Than 30 Years of Service';
title2 'As of February 1, 2013';
	select employee_name 'Name', int(('01FEB2013'd-employee_hire_date)/365.25) as YOS 'Years of Service'
		from orion.employee_addresses as a, orion.employee_payroll as p
		where a.employee_id = p.employee_id and calculated YOS > 30
		order by employee_name;
quit;
title;


/* 2. */
proc sql;
select * from orion.product_dim;
quit;
proc sql;
	describe table orion.order_fact;
quit;


proc sql;
title 'Total Quantities Sold by Product ID and Name';
	select pd.product_id, product_name, quantity 'Total Sold'
		from orion.product_dim as pd, orion.order_fact as of
		where pd.product_id = of.product_id and order_date >= '01012010'd
		group by pd.product_id, product_name
		order by product_id
	;
quit;