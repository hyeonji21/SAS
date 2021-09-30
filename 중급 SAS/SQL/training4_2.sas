proc sql;
	select *
		from airline.internationalflights;
quit;

proc sql;
	select *
		from airline.marchflights;
quit;


proc sql;
	select FlightNumber, Date, Boarded
		from airline.marchflights
		where not exists
			(select *
				from airline.internationalflights
				where marchflights.flightnumber=
						internationalflights.flightnumber 
				and marchflights.date=
						internationalflights.date);
quit;
