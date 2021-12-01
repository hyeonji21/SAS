data orders;
	set orion.Order_fact_new;
	where year(Order_Date)=2007;
	Lag = Delivery_Date - Order_Date;
run;

proc means data=orders maxdec=2 min max mean;
	class Order_Type;
	var Lag;
	title "Report based on ORDERS data";
run;


/*macro 사용 */
data work.orders;
	set orion.Order_fact_new;
	where year(Order_Date)=%substr(&sysdate9, 6)
	Lag=Delivery_Date - Order_Date;
run;

proc means data=&syslast maxdec=2 min max mean;
	class Order_Type;
	var Lag;
	title "Report based on %scan(&syslast, 2, .) data";
run;

%put &syslast