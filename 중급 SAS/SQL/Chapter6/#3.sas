proc sql;
select FirstName, LastName
	from airline.staffchanges
		except all
select FirstName, LastName
	from airline.staffmaster;
quit;