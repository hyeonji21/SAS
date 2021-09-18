proc sql;
	select FlightNumber, Date, Destination, sum(boarded, transferred, nonrevenue) as Total, PassengerCapacity
	from airline.marchflights
	where calculated total < passengercapacity * (1/3);
quit;


	