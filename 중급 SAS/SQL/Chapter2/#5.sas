proc sql;
	select FlightNumber, Date, Destination, Boarded + Transferred + Nonrevenue as Total
	from airline.marchflights
	where calculated Total < 100;    /* where 문이 먼저 실행되기 때문에 calculated 사용. */
quit;

proc sql;
	select FlightNumber, Date, Destination, Boarded + Transferred + Nonrevenue as Total,
			calculated Total/2 as half   /* select가 동시에 실행되기 때문에 calculated 사용. */
		from airline.marchflights;
quit;


