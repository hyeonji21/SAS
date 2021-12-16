%macro cust(place);
	%let place=%upcase(&place);
	data customers;
		set orion.customer;
		%if &place=US %then %do;
			where country='US';
			keep customer_name customer_address country;
		%end;
		%else %do;
			where country ne 'US';
			keep customer_name customer_address country location;
			if country="AU" then location='Australia';
			else if country="CA" then location='Canada';
			else if country="DE" then location='Germany';
			else if country="IL" then location='Israel';
			else if country="TR" then location='Turkey';
			else if country="ZA" then location='Africa';
		%end;
	run;
%mend cust;
%cust(us)
%cust(international)