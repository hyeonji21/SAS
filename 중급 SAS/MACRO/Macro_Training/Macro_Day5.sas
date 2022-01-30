%let m_year = 2011;
%let m_type = 3;

options mcompilenote=all;
%macro mcr_crt;
%put 작업시작시간 %sysfunc(time(), time.);
data work.order_&m_year._&m_type;
	set orion.order_fact;
	where year(order_date)=&m_year and order_type=&m_type;
	tax = total_retail_price * 0.1;
run;
%mend;


%let m_year = 2011;
%let m_type = 3;
%mcr_crt

%let m_year = 2010;
%let m_type = 1;
options mprint;
%mcr_crt

%macro mcr_crt_p(m_year, m_type); *이름;
%put 작업시작시간 %sysfunc(time(), time.);
data work.order_&m_year._&m_type;
	set orion.order_fact;
	where year(order_date)=&m_year and order_type=&m_type;
	tax = total_retail_price * 0.1;
run;
%mend;

%mcr_crt_p(2011, 1)  *값;
%mcr_crt_p(2011, 2)
%mcr_crt_p(2, 2011) * no! -> 위치 맞춰서 parameter값 넣을 것;



%macro mcr_crt_k(m_year=2011, m_type=3); *이름=값(디폴트)  -> macro parameter는 매크로 안에서만 참조됨 (local symbol);
%put 작업시작시간 %sysfunc(time(), time.);
data work.order_&m_year._&m_type;
	set orion.order_fact;
	where year(order_date)=&m_year and order_type=&m_type;
	tax = total_retail_price * 0.1;
run;
%put _user_;
%mend;

%mcr_crt_k() /*디폴트 값으로 진행 */
%mcr_crt_k(m_type=2)
%mcr_crt_k(m_type=2, m_year=2010)


%put _user_;


/* 4장 : 데이터변수(칼럼)의 값을 매크로 변수로 생성 */

/* 1) Data Step을 통해 매크로 변수 생성 */
/* 2) SQL을 통해 매크로 변수 생성 */

*m104d01a;
* call symputx 외우기;

%let month=4;
%let year=2011;

data orders;
   keep order_date order_type quantity total_retail_price;
   set orion.order_fact end=final; /* final 변수 생성 */
   where year(order_date)=&year and month(order_date)=&month;
   if order_type=3 then Number+1;
   if final = 1 then do;
      put Number=;
      call symputx('m_cnt', number); /*변수도 매크로로 만들 수 있음. */
      if Number=0 then do;
         %*let foot=No Internet Orders;
         call symputx('foot', 'No Internet Orders');
      end;
      else do;
         %*let foot=Some Internet Orders;
         call symputx('foot', 'Some Internet Orders');
      end;
   end;
run;

%put &=m_cnt;

options nocenter ps=20;
proc print data=orders;
   title "Orders for &month-&year";
   title2 "&foot (&m_cnt)";
run;
title;



*m104d03a;

* 각 고객별로 작업 ;
%let m_id = 9;

data _null_; /* 데이터스텝을 실행한 뒤, 데이터 생성하지 않을 경우 (원하는 고객 id에 따른 이름, 나라 구하기) */
	set orion.customer;
	where customer_id = &m_id;
	call symputx('m_name', catx("/", Customer_Name, country));
run;

proc print data=orion.order_fact;
   where customer_ID=&m_id;
   var order_date order_type quantity total_retail_price;
   title1 "Customer Number: &m_id";
   title2 "Customer Name: &m_name";
run;
title;


* 전체고객의 이름을 매크로 변수로 생성 -> 참조;
data _null_; /* 데이터스텝을 실행한 뒤, 데이터 생성하지 않을 경우 (원하는 고객 id에 따른 이름, 나라 구하기) */
	set orion.customer;
	*call symputx('m_name', catx("/", Customer_Name, country));
	call symputx("m_name"||left(customer_id), catx("/", customer_name,country));
run;
%put _user_;

%let m_id = 9;
proc print data=orion.order_fact;
   where customer_ID=&m_id;
   var order_date order_type quantity total_retail_price;
   title1 "Customer Number: &m_id";
   title2 "Customer Name: &&m_name&m_id";  /* 간접참조 */
run;
title;



* sql의 실행 결과 매크로 변수;
%let m_year=2011;  

* 해당년도의 평균거래금액: query의 결과 into절 사용하여 매크로 변수로 생성;
proc sql noprint;  /*리포트로 볼 필요는 없음.*/
	select avg(total_retail_price) format=comma10.2, count(*) as cnt
		into :m_price, :m_cnt  /* 매크로 변수명 */
	from orion.order_fact
	where year(order_date) = &m_year;
quit;
%put _user_;


%*let m_price=157.49;  * -> 해당년도의 평균거래금액;
options symbolgen; /*macro변수가 어떠한 값으로 참조되어 진행되는지 */
proc sql;
	create table work.order_&m_year._sql as 
	select *
		from orion.order_fact
		where year(order_date)=&m_year and total_retail_price >= &m_price;
quit;


data work.order_&m_year._data;
	set orion.order_fact;
	where year(order_date)=&m_year and total_retail_price >= &m_price;
	number + 1;
	total + total_retail_price;
run;


* 2) 문제;
* 호주(AU)에 거주하는 고객 ==> 의 거래이력데이터 생성;
proc sql noprint;
	select customer_id, country
		into :m_cust separated by ", "
	from orion.customer
	where country='AU';
quit;
%put &=m_cust;

data order_au;
	set orion.order_fact;
	where customer_id in (&m_cust);
	
	n+1;
	total_au + total_retail_price;
run;


/** 5장 **/
* sas코드에 대해 조건처리 코드생성작업, 반복 코드 생성 작업;

* 거래데이터로부터 인터넷 거래 데이터 생성;

%let m_dsn = orion.order_fact;


%macro mcr_crt(m_chk, m_dsn, m_type);
%if &m_chk=Y %then %do;
proc sql inobs=5;
	describe table &m_dsn;
	select * from &m_dsn;
quit;
%end;
%else %put 데이터만 생성하겠습니다!!!;
data order_&m_type;
	set &m_dsn;
	where order_type=&m_type;
run;
%mend;

options mlogic;  /*macro processor의 작업을 보여줌.*/
%mcr_crt(Y,orion.order_fact, 3) 
%mcr_crt(,orion.orders, 1)
;



/* m_type 매크로변수의 값이 1, 2, 3인 경우는 데이터 스탭 실행
   아닌 경우: 로그창에 [m_type값 확인!!!]; */
/* %if, %then은 반드시 macro정의 안에서만 사용 가능 */

%let m_dsn=orion.order_fact;
%let m_type=3;

%macro mcr_order(m_type, m_dsn);
%if &m_type=1 or &m_type=2 or &m_type=3 %then %do;  
data order_&m_type;
	set &m_dsn;
	where order_type=&m_type;
run;
%end;
%else %put m_type값 확인!!! (사용할 수 있는 값은 - 1, 2, 3);
%mend
;

%mcr_order(1, orion.orders)
%mcr_order(11, orion.orders)



%macro mcr_order(m_type, m_dsn) / minoperator;  /* in을 연산자로 쓴다는 것을 알려줘야함 : minoperator */
%if &m_type in 1 2 3 %then %do;
data order_&m_type;
	set &m_dsn;
	where order_type=&m_type;
run;
%end;
%else %put m_type값 확인!!! (사용할 수 있는 값은 - 1, 2, 3);
%mend
;


** 반복 코드 생성 작업;

data order_2011;
	set orion.order_fact;
	where year(order_date)=2011;
run;


%let m_year=2012;
data order_&m_year;
	set orion.order_fact;
	where year(order_date)=&m_year;
run;


%macro mcr_data(m_year);
data order_&m_year;
	set orion.order_fact;
	where year(order_date)=&m_year;
run;
%mend;

%mcr_data(2010)
%mcr_data(2011)
%mcr_data(2012)
/* ...; */
%mcr_data(2020)

/* 반복 */
%macro mcr_order;
%do i=2010 %to 2012;
	%mcr_data(&i)
%end;
%mend;

%mcr_order;


%macro mcr_data_m;
%do m_year=2010 %to 2020;
data order_&m_year;
	set orion.order_fact;
	where year(order_date)=&m_year;
run;
%end;
%mend;

options nomlogic;
%mcr_data_m 
;

* work.order_2010~~~ work.order_2012;
%macro mcr_data_do;
data work.order_all;
	set 
		%do m_year=2010 %to 2012;
			work.order_&m_year
		%end;
	;
run;
%mend;

%mcr_data_do
;


/* global */
%let m_v=1;
%global m_v m_v2 m_v3;
%put _user_;


/* Gloval vs Local symbol */

%let m_var1 = 이현지;  *global;

proc sql noprint;
	select avg(age) into :m_avg  /* global */
	from sashelp.class;
quit;


/* macro 선언 안에서 만든 macro variable은 모두 local */
%macro mcr_test;
	%global ml_var;
	%let ml_var = 이현지; /* local */
	%local m_avg; /* 이미 있는 global m_avg에 업데이트 시키고싶지 않으면 미리 local로 만들어놓기 */
	data _null_;
		call symputx("ml_avg", 100);  /* local */  /* call symputx("m_avg", 100); 으로 하면 global에 값을 새로 업데이트시킴. */
	run;
	%put _user_;
	
	%put &=ml_var &=m_var1 &=m_avg;
%mend;

%mcr_test
;


proc print data=sashelp.class;
	where weight >= &ml_avg;  /* 참조 불가능 : local은 매크로 실행이 끝나면 local symbol table도 사라지기 때문에 */
run;























