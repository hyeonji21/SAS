data three;
input x $ a $;
cards;
1 a1
1 a2
2 b1
2 b2
4 d
;

data four;
input x $ b $;
cards;
2 x1
2 x2
3 y
5 v
;

data new;
	merge three four;
	by x;
	*if x=2;
run;

proc print data=new;
run;

data new;
	merge three four;
	by x;
	if x=2;
run;

proc print data=new;
run;
