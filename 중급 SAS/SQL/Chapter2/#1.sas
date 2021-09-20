proc sql;
	select EmpID, JobCode, Salary 
		from airline.payrollmaster
		where JobCode contains 'NA'
		order by Salary desc;
quit;

/* 순서)

SELECT
	FROM
	WHERE 
	GROUP BY
	HAVING
	ORDER BY
QUIT

*/

