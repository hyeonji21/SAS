proc sql;
	select *
		from airline.payrollmaster;
quit;

proc sql;
	select EmpID label='Employee_ID', 
			DateOfHire label='Hire_Date' format=date9., 
			int((today()-DateOfHire)/365.25) as WorkofPeriod label='Working_Period'
				               /* 365.25 : 윤달 때문에 거의 이렇게 진행함 */
		from airline.payrollmaster;
quit;
