proc sql;
   create table discount
      (Destination char(3),
		BeginDate date label='BEGINS',
		EndDate date label='ENDS',
		Discount num); 
quit;