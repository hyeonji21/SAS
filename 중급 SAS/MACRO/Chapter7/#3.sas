proc sql;
      select LastName,FirstName, Gender,
			 int((today()-DateOfBirth)/365.25)as Age,
             substr(JobCode,3,1) as Level,Salary
		from airline.payrollmaster, airline.staffmaster
         where JobCode contains 'FA' and
               staffmaster.EmpID=payrollmaster.EmpID;
quit;

proc sql;
   create view airline.faview as
      select LastName,FirstName, Gender,
			 int((today()-DateOfBirth)/365.25)as Age,
             substr(JobCode,3,1) as Level,Salary
		from airline.payrollmaster, airline.staffmaster
         where JobCode contains 'FA' and
               staffmaster.EmpID=payrollmaster.EmpID;

	  select *
      	from airline.faview ;
quit;