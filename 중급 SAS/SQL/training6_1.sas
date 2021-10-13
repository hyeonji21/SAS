proc sql;
select FlightNumber, Destination
	from airline.marchflights
	except
select FlightNumber, Destination
	from airline.internationalflights;
quit;
