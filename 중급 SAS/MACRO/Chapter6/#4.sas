proc sql;
	select count(*) label='No.  of Persons'
		from (select EmpID
				from airline.staffmaster
				except all
				select EmpID
					from airline.staffchanges);
quit;
