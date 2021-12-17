%macro counts(rows);
	title 'Customer Counts by Gender';
	proc freq data=orion.customer_dim;
		tables 
		%if &rows ne %then &rows *;
			customer_gender;
	run;
%mend counts;

%counts()
%counts(customer_age_group)