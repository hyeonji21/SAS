/* supervisors 데이터가 들어오면 다시 돌려볼 것 */

proc sql;
	select LastName, FirstName, State
		from airline.staffmaster
		where 'NA' =
			(select JobCategory
				from airline.supervisors
				where staffmaster.EmpID=
						supervisors.EmpID);
quit;
