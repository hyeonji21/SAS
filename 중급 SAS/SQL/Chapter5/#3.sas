  /* Use a select statement to select statistics and group by Destination */
proc sql;
  select Destination, 
		avg(Delay) as average format=3.0 label='Average Delay',
		min(Delay) as min format=4.0 label= 'Minimum Delay',
		max(Delay) as max format=3.0 label='Maximum Delay'
	from airline.flightdelays 
	group by Destination;
quit;