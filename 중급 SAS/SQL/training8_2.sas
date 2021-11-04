proc sql;
	create table work.tdelay as select * from airline.flightdelays where 
		date='01MAR2000'd;
quit;

proc sql;
	alter table work.tdelay modify flightnumber char(4);
quit;

proc sql;
	update work.tdelay
		set FlightNumber = cats('I', Flightnumber)
		where DestinationType = 'International';
quit;

title 'Delay Flight (Internatinal & Domestic)';
proc sql;
	select FlightNumber, Destination, DestinationType
		from work.tdelay;
quit;







