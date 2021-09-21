proc sql;
select Delay, (Delay > 0) as Late
	from airline.flightdelays;
quit;

proc sql;
	select sum(Delay > 0) as Late,
			sum(Delay <= 0) as Early,
			calculated Late/(calculated Late + calculated Early) as Probability
		from airline.flightdelays;
quit;
