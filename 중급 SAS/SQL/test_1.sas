proc sql;
	select int((today() - DateOfHire) / 365.25) as age,
	   	substr(JobCode, 1, 2) as JobCategory
		from airline.payrollmaster, airline.staffmaster
		where state = 'NJ'
		group by calculated JobCategory
		having age = max(age);
quit;



proc sql;
	select *
		from airline.payrollmaster;
quit;
proc sql;
	select *
		from airline.staffmaster;
quit;





