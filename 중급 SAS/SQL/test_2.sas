proc sql;
	select m.Date, m.FlightNumber label='Flight Number',
	         m.Destination, Delay,
	         boarded + transferred + nonrevenue as people_count,
	         calculated people_count * 100 as delay_money format=dollar.
	from airline.marchflights as m left join airline.flightdelays as f
	on m.Date=f.Date and m.FlightNumber=f.FlightNumber
	group by m.FlightNumber
	having f.delay >= 30;
quit;






