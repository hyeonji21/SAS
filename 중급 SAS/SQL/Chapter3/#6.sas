/* 그룹핑 시켜서 그 이후에 평균을 찾음. */
proc sql;
	select JobCode, avg(Salary) as average format=dollar11.2
		from airline.payrollmaster
		group by JobCode
		having avg(Salary) > 56000;
quit;

/* Salary가 56000보다 큰 사람들을 구하고 그 이후에 그룹핑한다. */
proc sql;
	select JobCode, avg(Salary) as average format=dollar11.2
		from airline.payrollmaster
		where Salary > 56000 
		group by JobCode;
quit;


/* ==> 조건을 각각 걸어줄 것인가? or 그룹핑된 것에 조건을 걸어줄 것인가?의 차이 */