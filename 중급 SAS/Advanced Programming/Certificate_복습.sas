proc sql feedback;
	select *
		from orion.employee_information;
quit;

proc sql;
	select employee_id, employee_gender, salary, salary*0.1 as bonus,
		   case when upcase(employee_gender)="M" then 100
		   		when upcase(employee_gender)="F" then 110
		   		else 50
		   end as bonus2
		from orion.employee_information
	;
quit;

proc sql;
	create table work.emp_bonus as
	select employee_id, employee_gender, salary, salary*0.1 as bonus,
		   case upcase(employee_gender)
		   		when "M" then salary*0.1
		   		when "F" then salary*0.2
		   		else salary*0.05
		   end as bonus2
		from orion.empoloyee_information
	;
quit;

proc sql feedback number;
	create table work.emp_bonus as
	select employee_id, employee_gender, salary, salary*0.1 as bonus,
		   case upcase(employee_gender)
		   		when "M" then salary*0.1
		   		when "F" then salary*0.2
		   		else salary*0.05
		   	end as bonus2
		from orion.employee_information
		where salary > 112000 and employee_term_date=.
	;
	
	select * from work.emp_bonus;
quit;


proc sql feedback number;
	create table work.emp_bonus as
	select employee_id, employee_gender, salary, salary*0.1 as bonus,
	 	   calculated bonus/2 as half,
	 	   case upcase(employee_gender)
	 	   		when "M" then salary*0.1
	 	   		when "F" then salary*0.2
	 	   		else salary*0.05
	 	   end as bonus2
	 	from orion.employee_information
	 	where calculated bonus <= 3000 and employee_term_date=.
	 ;
	 select * from work.emp_bonus;
quit;


proc sql;
	create table work.emp_info as
	select employee_id, employee_gender "성별", marital_status, 
		   salary format=comma10., 
		   birth_date label="생일" format=yymmdd10.,
		   salary * 1/3 as tax '급여의 30%' format=comma10.1,
		   case when salary >= 100000 then '10만 이상'
		   		when salary <= 100000 then '10만 미만'
		   end as grp_salary
		from orion.employee_payroll
		where upcase(marital_status)="S" and calculated tax >= 10000 and
			  employee_term_date=.
		order by employee_gender, 6 desc
	;
	
	select * from work.emp_info;
quit;

proc sql;
	describe table orion.order_fact;
quit;

proc sql;
	create table work.order2011 as 
	select order_id, customer_id, product_id,
		   order_date label="주문일자" format=yymmdd10.,
		   delivery_date label="배송일자" format=yymmdd10.,
		   total_retail_price label="판매금액" format=comma10.,
		   delivery_date - order_date as days,
		   case when total_retail_price < 100 then "P1"
		   		when 100 <= total_retail_price <= 200 then "P2"
		   		when total_retail_price > 200 then "P3"
		   end as g_price label="판매등급(3등급)"
		from orion.order_fact
		where order_type=3 and year(order_date)=2011
		order by order_date desc
	;
	
	select * from work.order2011;
quit;


proc sql number;
	select distinct department, job_title
		from orion.employee_information
		where employee_term_date is null
	;
quit;


proc sql;
	select sum(salary) as total,
		   avg(salary) as avg_salary,
		   count(*) as c1,
		   count(employee_term_date) as c2,
		   count(distinct manager_id) as mgr_cnt
		   
		from orion.employee_information
		/*where employee_term_date is null*/
	;
quit;

proc sql;
	select employee_gender,
		   sum(salary) as total,
		   avg(salary) as avg_salary,
		   count(*) as c1,
		   count(salary) as c2,
		   count(distinct manager_id) as mgr_cnt
		
		from orion.employee_information
		where employee_term_date is null
	;
quit;


proc sql;
	select department, job_title,
		   count(*) as cnt label="인원수",
		   avg(salary) as avg_salary format=comma10.1
		from orion.employee_information
		where employee_term_date=.
		group by department, job_title
		having cnt>=5
		order by cnt desc
		;
quit;


/* summary report 
   현재 재직중인 기준으로 부서내 직급별 인원수(cnt), 평균급여(avg_salary) */
  
/* 주의 : 전체의 avg와 count를 계산하는 것이 아닌 그룹별로 구하는 것 */
proc sql;
	describe table orion.employee_information;
quit;

proc sql;
	select department, job_title,
		   count(*) as cnt, avg(salary) as avg_salary
		from orion.employee_information
		where employee_term_date is missing
		group by department, job_title
		having cnt >= 5
		order by cnt  desc
	;
quit;

proc sql;
	describe table orion.order_fact;
quit;

proc sql;
	create table work.order_cust as
	select customer_id,
		   count(*) as cust_cnt,
		   count(distinct product_id) as prd_cnt,
		   sum(total_retail_price) as sum_price,
		   avg(total_retail_price) as avg_price,
		   min(order_date) as init_date format=yymmdd10.,
		   max(order_date) as rec_date format=yymmdd10.
		from orion.order_fact
		where order_type=3
		group by customer_id
		having cust_cnt >= 3
		order by cust_cnt desc
	;
	
	select * from work.order_cust;
quit;



%put 고려대-이현지;
%put '고려대-이현지';

%put _automatic_;
%put &sysdate9 &systime;
%put &=sysdate9 &=systime;

proc sql;
	describe table orion.customer;
quit;

data work.cust_us;
	set orion.customer;
	where country='US' and year(birth_date)>=1980;
run;

title '국가 : US에 거주하는 출생년도 : 1980 이후 고객리스트';
title2 '작성자 : user, 작성날짜 : 24JAN2022';
proc print data=work.cust_us;
run;
title;


* 사용자 정의 매크로변수 생성;
%let m_country=AU;
%let m_year=1950;
%let m_lib=work;


*options symbolgen;
options nosymbolgen;
data &m_lib..cust_&m_country._Y&m_year;
	*data work.cust_AU_Y1950;
	set orion.customer;
	where country="&m_country" and year(birth_date)>=&m_year;
run;
title "국가 : &m_country 에 거주하는 출생년도 : &m_year 이후 고객리스트";
title2 "작성자 : &sysuserid, 작성날짜 : &sysdate9";
/* 큰따옴표로 해야지 macro trigger 인식 가능 (tokenize) */

proc print data=&m_lib..cust_&m_country._Y&m_year;
run;
title;

%put _user_;

%symdel m_country m_year;
%put _user_;


/* 2.5절 매크로 함수를 사용하여 추가작업 */
%let m_country = us;
%let m_year = %eval(%substr(&sysdate9, 6, 4) - 40);
%let m_lib=orion;

%put &=m_year;

%let m_country = %upcase(&m_country);

options nosymbolgen;
data &m_lib..cust_&m_country._Y&m_year;
	set orion.customer;
	where country="%upcase(&m_country)" and year(birth_date)>=&m_year;
run;
title "국가 : &m_country 에 거주하는 출생년도 : &m_year 이후 고객리스트";
title2 "작성자 : &sysuserid, 작성날짜 : %sysfunc(today(), yymmdd10.)";
title3 "작성기간 : %sysfunc(time(), time.)";
proc print data=&m_lib..cust_&m_country._Y&m_year;
run;
title;

%put 1+2;
%put 계산처리작업1 : %eval(1+2);
%put 계산처리작업2 : %eval(3/2);
%put 계산처리작업3 : %eval(1.5+1.5);
%put 논리연산작업 : %eval(3>2);


data test;
	time = time();
	format time time.;
	put time=;
run;


proc sql inobs=10;
	title '테이블 : sashelp.class';
	describe table sashelp.class;
	select * from sashelp.class;
quit;
title;

%let m_dsn = sashelp.class;
proc sql inobs=10;
	title "테이블 : %upcase(&m_dsn)";
	describe table &m_dsn;
	select * from &m_dsn;
quit;
title;

%let m_dsn=orion.customer;
%let m_info=
	%str(proc sql inobs=10;
		 title "테이블 : %upcase(&m_dsm)";
		 describe table &m_dsn;
		 select * from &m_dsn;
		 quit;
		 title;
		 );
&m_info

%put &=m_info;

%let m_dsn=sashelp.class;
&m_info

%let m_dsn=orion.customer;

%macro m_dsn;
	orion.customer
%mend;

options mcompilenote=all mprint;
%macro mcr_info;
	%put 작업시작시간 : %sysfunc(time(), time.);
	proc sql inobs=10;
		title "테이블 : %upcase(&m_dsn)";
		describe table &m_dsn;
		select * from &m_dsn;
		quit;
		title;
%mend;
%put &=m_dsn;
%mcr_info;

%let m_dsn=sashelp.class;
%mcr_info
;

options mcompilenote=all mprint;
%macro mcr_info_p(m_dsn, m_obs);
	%put 작업시작시간 : %sysfunc(time(), time.);
	proc sql inobs=&m_obs;
		title "테이블 : %upcase(&m_dsn)";
		describe table &m_dsn;
		select * from &m_dsn;
		quit;
		title;
%mend;

%mcr_info_p(orion.order_fact, 5)
%mcr_info_p(sashelp.class, 20)
%mcr_info_p(sashelp.class)
%mcr_info_p()
%mcr_info_p


%macro mcr_info_k(m_dsn=sashelp.class, m_obs=10);
	%put 작업시작시간 : %sysfunc(time(), time.);
	proc sql inobs=&m_obs;
		title "테이블 : %upcase(&m_dsn)";
		describe table &m_dsn;
		select * from &m_dsn;
		quit;
		title;
%mend;

%mcr_info_k()
%mcr_info_k(m_dsn=sashelp.air, m_obs=20)
%mcr_info_k(m_obs=5)
%mcr_info_k(m_dsn=orion.customer, m_obs=20)
;

data work.test;
	set pg3.Stocks_abc;
	open_1 = lag(open);
	open_2 = lag2(open);
	mean3_open = mean(open, open_1, open_2);
run;
proc print data=work.test;
run;


proc sql;
	select *, lag(open) as open_1
	from pq3.stocks_abc;
quit;

	
data work.health_high(drop=i);
	set pg3.health_stats;
	
	array health[5] weight blpres pulse chol glucose;
	
	highcount = 0;
	
	do i=1 to 5;
		if health[i]="High" then highcount+1;
	end;
run;
proc print data=health_high;
run;


data work.test_answers(drop=i);
	set pg3.test_answers;
	
	array q[*] _character_;
	do i=1 to dim(q);
		if q[i] = "" then q[i] = "Z";
	end;
	
	array n[*] _numeric_;
	do i=1 to dim(n);
		if n[i] = . then n[i] = 0;
	end;
run;
proc print data=work.test_answers;
run;

data work.dublin_f_c (drop=i);
	set pg3.weather_dublinmadrid_monthly2017 (keep=city temp1-temp3);
	
	array temp[3] temp1-temp3;
	array tempc[3] tempc1-tempc3;
	
	do i=1 to 3;
		tempc[i] = (temp[i] - 32)*5/9;
	end;
run;

data work.dublin_f_c (drop=i);
	set pg3.weather_dublinmadrid_monthly2017 (keep=city temp4-temp6);
	
	array temp[4:6] temp4-temp6;
	array tempc[4:6] tempc4-tempc6;
	array avgm[4:6] _temporary_ (50, 40, 60);
	
	do i=4 to 6;
		tempc[i] = avgm[i] - temp[i];
	end;
run;
proc print data=work.dublin_f_c;
run;


data work.class_tests_info;

	length name $ 10 gender $ 5 age 8;
	if _n_=1 then do;
	
		declare hash t(dataset:'pg3.class_birthdate');
		t.definekey('name');
		t.definedata('gender', 'age');
		t.definedone();
		call missing(name, gender, age);
	end;
	
	set pg3.class_tests;
	rc = t.find(key:name);
	
	if rc=0;
run;
proc print data=class_tests_info;
run;

/* hash object 연습문제 */
proc sql;
	describe table pg3.order_fact, pg3.customer;
quit;

data work.order_fact_custadd;
	
	length customer_id 8 country $ 5 birth_date 8;
	if _n_=1 then do;
		declare hash t(dataset:'pg3.customer');
		t.definekey('customer_id');
		t.definedata('country', 'birth_date');
		t.definedone();
		call missing(customer_id, country, birth_date);
	end;
	
	set pg3.order_fact;
	
	rc=T.find(key:customer_id);
	
	if rc=0;
	format birth_date yymmdd.;
run;
proc print data=work.order_fact_custadd;
run;

proc fcmp outlib=work.func.test;
	function usermean(col1, col2);
		if col1=. then col1=0;
		if col2=. then col2=0;
		col3 = (col1+col2)/2;
		return (col3);
	endsub;
run;

proc print data=work.func;
run;

options cmplib=work.func;
data test;
	a=10;
	b=.;
	
	c=usermean(a,b);
	d=mean(a,b);
	
	putlog c= d=;
run;

proc fcmp outlib=work.func.weather;
	function INtoCM(in);
		cm = in * 2.54;
		return(cm);
	endsub;
run;

options cmplib=work.func;
data work.test_in_cm;
	set pg3.weather_ny_daily2017;
	PrecipCM = INtoCM(Precip);
run;

proc print data=work.test_in_cm;
run;

proc fcmp outlib=work.funcs.weather;
	function INtoCM(IN);
		CM = IN * 2.54;
		return(CM);
	endsub;
run;

options cmplib=work.func;
data work.test_in_cm;
	set pg3.weather_ny_daily2017;
	PrecipCM = INtoCM(Precip);
run;
proc print data=work.test_in_cm (obs=10);
run;


proc fcmp outlib=work.funcs.weather;
	function weather(F);
		C = round((F-32)*5/9, 0.01);
		return(C);
	endsub;
run;

options cmplib=work.funcs;
data newyork;
	set pg3.weather_ny_daily2017;
	TavgC = weather(Tavg);
run;


proc fcmp outlib=work.funcs.weather;
	function INtoCM(IN);
		CM = IN * 2.54;
		return(CM);
	endsub;
run;

options cmplib=work.funcs;
data new;
	set pg3.weather_ny_daily2017;
	PrecipCM = INtoCM(Precip);
run;
proc print data=new;
run;

data work.order_fact_custadd;
	
	length customer_id 8 country $ 8 birth_date 8;
	
	if _n_=1 then do;
		declare hash T(dataset: 'pg3.customer');
		T.definekey('customer_id');
		T.definedata('country', 'birth_date');
		T.definedone();
		call missing(customer_id, country, birth_date);
	end;
	
	set pg3.order_fact;
	
	rc = T.find(key:customer_id);
	
	format birth_date yymmdd.;
run;

proc print data=work.order_fact_custadd;
run;


proc fcmp outlib=work.funcs.weather;
	function INtoCM(in);
		cm = in * 2.54;
		return(cm);
	endsub;
run;

options cmplib=work.funcs;
data work.new;
	set pg3.weather_ny_daily2017;
	precipcm = INtoCM(Precip);
run;
proc print data=work.new;
run;


data work.order_fact_custadd;
	
	length customer_id 5 country $ 8 birth_date 8;
	
	if _n_=1 then do;
		declare hash t(dataset:'pg3.customer');
		t.definekey('customer_id');
		t.definedata('country', 'birth_date');
		t.definedone();
		
		call missing(customer_id, country, birth_date);
	end;
	
	set pg3.order_fact;
	
	rc = t.find(key:customer_id);
	
run;

proc print data=work.order_fact_custadd;
run;


proc sql;
	describe table orion.employee_information, orion.employee_donations;
quit;

proc sql;
	create table work.emp_donations_info as
	select i.employee_id, department, salary format=comma10. '급여',
		   sum(qtr1, qtr2, qtr3, qtr4) as total_don format=comma10.1 '총기부금액'
		from orion.employee_information as i, orion.employee_donations as d
		where i.employee_id = d.employee_id and
			  i.employee_term_date is null;
quit;


proc sql;
	create table work.order_cust as
	select order_id, order_date, product_id, total_retail_price,
			f.customer_id, country, gender, 
			case when upcase(country)='US' then total_retail_price * 0.3
				 when upcase(country)='AU' then total_retail_price * 0.2
				 else total_retail_price * 0.1
			end as tax '국가별 세금'
		from orion.order_fact as f, orion.customer as c
		where f.customer_id = c.customer_id and year(order_date)=2010;
quit;

proc sql;
	create table work.order_cust as
	select order_id, order_date, product_id, total_retail_price, 
		   f.customer_id, country, gender, 
		   case when upcase(country)='US' then total_retail_price * 0.3
		   	 	when upcase(country)='AU' then total_retail_price * 0.2
		   	 	else total_retail_price * 0.1
		   end as tax '국가별 세금'
		from orion.order_fact as f inner join orion.customer as c
			on f.customer_id = c.customer_id
		where year(order_date)=2010;
quit;


proc sql;
	create table work.emp_donations_info as
	select i.employee_id, i.department, i.salary format=comma10. '급여',
		   sum(qtr1, qtr2, qtr3, qtr4) as total_don format=comma10. '총기부금액'
		from orion.employee_information as i, orion.employee_donations as d
		where i.employee_id = d.employee_id and i.employee_term_date is null;
quit;


proc sql;
	select employee_id, job_title, employee_hire_date, salary
		from orion.employee_information
		where Employee_term_date is missing and
			salary >= (select avg(Salary) as total_avg
							from orion.employee_information
							where employee_term_date is null)
			and upcase(employee_gender)="M";
quit;


proc sql;
	select employee_id, birth_date format=yymmdd10.
		from orion.employee_payroll
		where employee_term_date is null and month(birth_date) = 1;
quit;

proc sql;
	select employee_id, employee_name, country, city
		from orion.employee_addresses
		where employee_id in (select employee_id
								from orion.employee_payroll
								where employee_term_date is null and 
								 month(birth_date)=1);
quit;


proc sql;
	create table work.job_salary as
	select job_title, avg(salary) as job_salary
		from orion.employee_organization as org, orion.employee_payroll as p
		where org.employee_id = p.employee_id
		group by job_title;
quit;


proc sql;
	select org.employee_id, org.department, org.job_title, p.salary,
			j.job_salary
		from orion.employee_organization as org, orion.employee_payroll as p,
			work.job_salary as j
		where org.employee_id = p.employee_id and 
				org.job_title = j.job_title and p.salary >= job_salary
	;
quit;


proc sql;
	select org.employee_id, org.department, org.job_title, p.salary, j.job_salary
		from orion.employee_organization as org, orion.employee_payroll as p,
			(select job_title, avg(salary) as job_salary
				from orion.employee_organization as org,
					 orion.employee_payroll as p
				where org.employee_id = p.employee_id
				group by job_title) as j
		where org.employee_id = p.employee_id and	
				org.job_title = j.job_title and p.salary >= j.job_salary;
quit;

proc sql;
	select * from orion.qtr1
	union
	select * from orion.qtr2;
quit;

proc sql;
	select * from orion.qtr1
	union corr all
	select * from orion.qtr2;
quit;

proc sql;
	create table work.qtr12 as
	select * from orion.qtr1
	outer union corr
	select * from orion.qtr2;
quit;

proc sql;
	create table work.qtr12 as 
	select * from orion.qtr1
	outer union corr
	select * from orion.qtr2;
quit;

proc sql;
	select order_type, count(*) as count_order
		from work.qtr12
		group by order_type;
quit;


proc sql;
	create view orion.v_qtr12 as 
	select * from orion.qtr1 
		where order_type in (1, 2, 3)
	outer union corr
	select * from orion.qtr2
		where order_type in (1, 2, 3)
	;
quit;

proc sql;
	select order_type, count(*) as count_order
		from work.v_qtr12
		group by order_type;
quit;

proc sql;
	select customer_id, count(*) as count_order
		from work.qtr12
		group by customer_id;
quit;

proc sql;
	select libname, memname, memtype, name, type, varnum
		from dictionary.columns
		where UPCASE(libname) in ('ORION', 'WORK') and upcase(name)='EMPLOYEE_ID';
quit;

proc sql;
	select libname, memname, memtype, nlobs, nvar
		from dictionary.tables
		where upcase(libname) in ('ORION', 'WORK');
quit;
























