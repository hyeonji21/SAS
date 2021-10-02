/* Any , All 사용 */

proc sql;
	select FFID, Name, Milestraveled
		from airline.frequentflyers
		where membertype='GOLD'
		and milestraveled < any
		 (select milestraveled
		 	from airline.frequentflyers
		 	where membertype in ('BROMZE', 'SILVER'));
quit;

proc sql;
	select *
		from airline.frequentflyers;
quit;


proc sql;
select FFID, Name, Milestraveled
	from airline.frequentflyers
	where membertype='GOLD'
	and milestraveled < all	
		(select milestraveled
			from airline.frequentflyers
			where membertype in ('BRONZE', 'SILVER'));
quit;












