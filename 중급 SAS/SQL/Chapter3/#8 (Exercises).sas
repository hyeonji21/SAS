proc sql;
	select *
		from airline.staffmaster;
quit;


proc sql;
	select state, count(*) as count
		from airline.staffmaster
		group by state
		order by count desc;
quit;


