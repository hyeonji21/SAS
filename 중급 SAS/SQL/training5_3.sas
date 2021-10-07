/*
proc sql;
	select FlightNumber, Date, LastName, FirstName
		from airline.staffmaster as as,
			(select *
				from airline.flightschedule as af,
				 	airline.marchflights as am
				where
				  	af.date = am.date) as two
		where as.EmpID = two.EmpID and as.Destination = two.Destination;
		
quit;


    
proc sql;
	select *
		from airline.staffmaster;
quit;

proc sql;
	select *
		from airline.flightschedule;
quit;


proc sql;
	select *
		from airline.marchflights;
quit;

proc contents data=airline.flightschedule;
run;
*/

proc sql;
	select FlightNumber, Date, LastName, FirstName
		from airline.staffmaster,
			(select *
				from airline.flightschedule,
					 airline.marchflights
				where marchflights.flightnumber=
						flightschedule.flightnumber 
				and marchflights.date = flightschedule.date) as ssf
		where staffmaster.EmpID = ssf.EmpID
		order by FlightNumber, Date, LastName, FirstName;
quit;

/*
proc sql;
	select FlightNumber, Date, LastName, FirstName
		from airline.staffmaster as sm,
			 airline.flightschedule as fs
		where sm.EmpID=fs.EmpID and fs.Destination in
			(select Destination
				from airline.marchflights as mf
				where fs.FlightNumber = mf.FlightNumber)
		order by FlightNumber, Date, LastName, FirstName;
quit;
*/

/*
proc sql;
	select FlightNumber, Date, LastName, FirstName
		from airline.staffmaster as sm,
			(select *
				from airline.flightschedule as fs,
				 	airline.marchflights as mf
				where fs.destination = mf.destination and
				  	fs.date = mf.date) as two
		where sm.EmpID = two.EmpID
		order by FlightNumber, Date, LastName, FirstName;
quit;
*/









