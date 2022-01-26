libname pg3 "C:\prog3_m6\data";


* data step => table 생성;
/* LAG 함수 : 건 별로 처리해줘야하기 때문에 조건을 기준으로 (MEAN함수) 같이 사용하면 안될 것 */
data work.test;
	set pg3.Stocks_abc;
	open_1 = lag(open);
	open_2 = lag2(open);
	mean3_open = mean(open, open_1, open_2);
	
	/* 쓰면 안됨 : if _n_>=3 then mean3_open2 = mean(open, lag(open), lag2(open)); */
	/*
	if _n_>=3 then do;
		chk1 = mean(open, lag(open), lag2(open));
		chk2 = mean(open, open_1, open_2);
	end;
run;
*/


proc print data=work.test;
run;

proc sql;
	select *, lag(open) as open_1
	from pq3.stocks_abc;
quit;



/* ARRAY -> 항상 do-loop와 함께 사용 */
data work.health_high(drop=i);
	set pg3.health_stats;
	
	array health[5] weight blpres pulse chol glucose; /* complie */ 
	
	highcount = 0;
	
	do i=1 to 5;
		if health[i]="High" then highcount+1;
	end;
	
	/*
	if weight='High' then highcount+1;
	if blpres='High' then highcount+1;
	if pulse='High' then highcount+1;
	if chol='High' then highcount + 1;
	if glucose='High' then highcount+1;
	*/
	
run;

proc print data=health_high;
run;



/* 3.1 One-Dimensional Array 연습문제 */
/* 1) 모든 문자변수의 미싱값(blank)을 'Z'로 변경 */
/* 2) 모든 숫자변수의 미싱값(.)을 0으로 변경 */

/* 혼자 작성할 수 있어야함 (연습할 것) */
data work.test_answers (drop=i);
	set pg3.test_answers;
	
	
	array q[*] _character_;  /* array q[10] q1-q10; */
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



* 화씨 (F) -> 섭씨 (C);
* 1월~3월달 : 1사분기;
data work.dublin_f_c (drop=i);
	set pg3.weather_dublinmadrid_monthly2017 (keep=city temp1-temp3);
	
	array temp[3] temp1-temp3; * 기존 입력데이터의 변수 : 해당 변수 사용;
	array tempc[3] tempc1-tempc3;      * 입력데이터에 없는 변수 : 해당 변수 생성;
	
	
	do i=1 to 3;
		tempc[i] = (temp[i] - 32)*5 / 9;
	end;
	
run;


* 4월~6월 : 2사분기;
data work.dublin_f_c (drop=i);
	set pg3.weather_dublinmadrid_monthly2017 (keep=city temp4-temp6);
	
	array temp[4:6] temp4-temp6; * 기존 입력데이터의 변수 : 해당 변수 사용;
	array tempc[4:6] tempc4-tempc6; * 입력데이터에 없는 변수 : 해당 변수 생성;
	array avgm[4:6] _temporary_ (50, 40, 60); *새로운 변수에 초기값 할당 - 모든 row에 대해 적용 (차이값 계산하기 위해 만듬);
	
	do i=4 to 6;
		*tempc[i] = (temp[i] - 32)*5 / 9;
		tempc[i] = avgm[i] - temp[i];
	end;
	
run;

proc print data=work.dublin_f_c;
run;


/* hash object */
/* 꼭 외워야 함 */
* 4.2 hash object 학생 점수 데이터에 학생의 성별, 나이 정보 추가;

data work.class_tests_info;

	length name $ 10 gender $ 5 age 8;
	if _n_=1 then do;
	  * lookup : hash object;
	  declare hash t(dataset:'pg3.class_birthdate');
	  t.definekey('name');
	  t.definedata('gender', 'age');
	  t.definedone();
	  call missing(name, gender, age);  /* missing -> 값이 초기에 할당되지않았다고 하더라도 경고메시지 안나오게끔하기 */
	end;
	
	set pg3.class_tests;
	rc = t.find(key:name); /* hash object : 해당 키칼럼의 값을 기준으로 데이터값 찾기 */
	
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
	
	set pg3.order_fact;  /* 여기에 고객의 정보를 추가하여 보고싶은 것 : (country, birth_date) */
	 
	rc = T.find(key:customer_id);  /* key component가 같아야 함  (rc=t.find();로 해도 가능)*/
	
	if rc=0; /* 거래한 건만 */
	format birth_date yymmdd
run;

proc print data=work.order_fact_custadd;
run;


/* 5.2 사용자 정의 함수 */
proc fcmp outlib=work.func.test;
	function usermean(col1, col2) ;
		if col1=. then col1=0;  /* 결측값일때 빼고 계산하는 것이 아닌 0으로 값 설정 */
		if col2=. then col2=0;
		col3 = (col1+col2)/2;
		return(col3);
	endsub;
run;

proc print data=work.func;  /* 패키지는 안에 들어가는 정보이므로 table만 본다. */
run;

* 만든 함수 사용;
options cmplib=work.func; /* compile된 공간을 알려줘야함 (function 찾기) */
data test;
	a=10;
	b=.;
	
	c=usermean(a,b);
	d=mean(a,b);
	
	putlog c= d=;  /*log 창에 찍기*/
run;


/* 5.2 연습문제 */
proc fcmp outlib=work.func.weather;
	function INtoCM(in) ;
		cm = in * 2.54;
		return(cm);
	endsub;
run;

options cmplib=work.func;
data work.test_in_cm;
	set pg3.weather_ny_daily2017;
	PrecipCM = INtoCM(Precip); *in=>cm 변경;
run;

proc print data=work.test_in_cm (obs=10);
run;




















