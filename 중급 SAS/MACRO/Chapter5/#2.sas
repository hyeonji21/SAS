option mlogic mprint;  /* 내가 하는 구문 확인할 수 있음 / 항상 적어서 사용할 것 */

%macro count(type=,start=01jan2007,stop=31dec2007);
   proc freq data=orion.order_fact;
      where order_date between "&start"d and "&stop"d;
      table quantity;
      title1 "Orders from &start to &stop";
      %if &type=  %then %do;
         title2 "For All Order Types";
      %end;
      %else %do;
         title2 "For Order Type &type Only";
         where same and order_type=&type;
      %end;
   run;
%mend count;

%count()
%count(type=3)