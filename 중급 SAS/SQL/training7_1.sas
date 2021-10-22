proc sql;
	create table airline.awards
		(PTSREQD num label='Points Required',
		 RANK num format=3.,
		 AWARD char(25));
	insert into airline.awards
	values(2000, 1, 'free night in hotel')
	values(10000, 2, '50% discount on flight')
	values(20000, 3, 'free domestic flight')
	values(40000, 4, 'free international flight');
quit;

proc sql;
	select *
		from airline.awards;
quit;