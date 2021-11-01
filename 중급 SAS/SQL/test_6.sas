
proc sql;
	select distinct Job_Title
		from midtest.staff;
quit;


proc sql;
select Employee_ID, job_title
	from midtest.staff
	where job_title contains 'Director';
quit;


proc sql;
select manager_id, count(*) as people_count
	from midtest.staff
	group by manager_id
	order by people_count asc;
quit;


proc sql;
select job_title, avg(Salary) as Avg_Salary
	from midtest.staff
	where job_title contains 'HR'
	group by job_title
	order by Avg_Salary desc;
quit;






