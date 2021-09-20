proc sql;
	select Date, FlightNumber, Boarded, Transferred, Nonrevenue,
			sum(Boarded, Transferred, Nonrevenue) as Total
			from airline.marchflights;
quit;


