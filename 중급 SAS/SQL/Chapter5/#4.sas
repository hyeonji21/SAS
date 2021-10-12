
title 'Airline.Marchflights';
proc sql;
	select date, flightnumber, destination
		from airline.marchflights
		order by date;
	Title 'Airline.FlightDelays';

	select date, flightnumber, destination, delay 
		from airline.flightdelays
		order by date;
quit;