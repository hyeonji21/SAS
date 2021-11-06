data alpha;
input X $ A $;
cards;
1 x
1 y
3 z
4 v
5 w
;


data beta; 
input X $ B $;
cards;
1 x
2 y
3 z
3 v
5 w
;


proc sql;
select *
   from alpha 
except corr all
select *
   from beta;
quit;