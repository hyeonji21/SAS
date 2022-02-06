/* 1. */
proc sql;
	select *
		from orion.employee_payroll;
quit;

proc sql;
	select Employee_ID, Employee_Gender, Marital_Status, Salary
		from orion.employee_payroll;
quit;

/* 2. */
proc sql;
	select Employee_ID, Employee_Gender, Marital_Status, Salary, Salary/3 as Tax
		from orion.employee_payroll;
quit;

proc sql;
	describe table orion.employee_payroll;
quit;

/* 3. */

proc sql;
	create table work.bonus as
	select Employee_ID, Salary, Salary * 0.04 as Bonus
		from orion.employee_payroll;
		
	select * 
		from work.bonus;
quit;

/* 4. */
proc sql;
	select *
		from orion.staff;
quit;

proc sql;
	select Employee_ID, 
		   case when scan(Job_Title, -1, ' ')='Manager' then 'Manager'
		   		when scan(Job_Title, -1, ' ')='Director' then 'Director'
		   		when scan(Job_Title, -1, ' ')='Officer' or scan(Job_Title, -1, ' ')='President' then 'Executive'
		   		else 'N/A'
		   end as Level,
		   Salary,
		   case when calculated Level='Manager' and Salary < 52000 then 'Low'
		   		when calculated Level='Director' and Salary < 108000 then 'Low'
		   		when calculated Level='Executive' and Salary < 240000 then 'Low'
				when calculated Level='Manager' and 52000 <= Salary <= 72000 then 'Medium'
				when calculated Level='Director' and 108000 <= Salary <= 135000 then 'Medium'
				when calculated Level='Executive' and 240000 <= Salary <= 300000 then 'Medium'
				when calculated Level='Manager' and Salary > 72000 then 'High'
				when calculated Level='Director' and Salary > 135000 then 'High'
				when calculated Level='Executive' and Salary > 300000 then 'High'
			end as Salary_Range
		from orion.staff
		where calculated Level ne 'N/A'
		order by Level, Salary desc
	;
quit;














