
proc sql;
	create table work.reward
	 (PTSCORE num(8) label='Point Score',
	  GRADE num(1) label='Customer Grade',
	  REWARD char(30)
	  );
quit;

proc sql;
	insert into work.reward (PTSCORE, GRADE, REWARD)
		values(1000, 1, 'free lunch coupon')
		values(15000, 2, 'free lunch and hotel voucher')
		values(25000, 3, '50% discount of domestic')
		values(30000, 4, '50% discount of international');
quit;