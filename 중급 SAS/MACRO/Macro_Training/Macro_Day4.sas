%put 고려대 - 이현지;
%put '고려대 - 이현지';

%put _automatic_;
%put &sysdate9 &systime;  /*매크로 trigger를 잘못쓰더라도 에러가 나지는 않음.*/
%put &=sysdate9 &=systime; /* 이름 설정 */


* 고객 데이터로 부터 미국에 거주하는 1980년 이후 출생한 고객 -> work.cust_us;
/* 기본 sas 코드 */
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
title;  /* 위에서 쓴 title 지우기 */


/* 매크로 변수 사용하여 코드 수정 */

* 사용자 정의 매크로변수 생성;
* 컴퓨터가 꺼지면 없어지게 됨.;
%let m_country = AU;
%let m_year = 1950;
%let m_lib=work;

*options symbolgen;  /*매크로변수 어떻게 쓰이는지 log창에서 확인 (debug 용)*/
options nosymbolgen;
data &m_lib..cust_&m_country._Y&m_year;  **data work.cust_AU_Y1950  ==> macro와 text 구분 delimiter(.);
	set orion.customer;
	where country="&m_country" and year(birth_date)>=&m_year;
run;
title "국가 : &m_country 에 거주하는 출생년도 : &m_year 이후 고객리스트";
title2 "작성자 : &sysuserid, 작성날짜 : &sysdate9";  /* 큰따옴표로 해야지 macro trigger 인식 가능 (tokenize) */
proc print data=&m_lib..cust_&m_country._Y&m_year;
run;
title;

/* 1-28 Exercises 4 */
%put Can you display a semicolon ; in your %PUT statement?;


* 사용자 정의 매크로 변수 리스트;
%put _user_;

%symdel m_country m_year;
%put _user_;


/* 2.5절 매크로 함수를 사용하여 추가작업 */
%let m_country = us;
%let m_year = %eval(%substr(&sysdate9, 6, 4) - 40); **올해년도-40;
%let m_lib=orion;

%put &=m_year;


%let m_country = %upcase(&m_country);  /* 매크로변수의 값을 대문자로 치환 (2번째 방법)

*options symbolgen;  /*매크로변수 어떻게 쓰이는지 log창에서 확인 (debug 용)*/
options nosymbolgen;
data &m_lib..cust_&m_country._Y&m_year;  **data work.cust_AU_Y1950  ==> macro와 text 구분 delimiter(.);
	set orion.customer;
	where country="%upcase(&m_country)" and year(birth_date)>=&m_year;  /* %upcase() 사용하여 대문자로 바꾸기 (1번째 방법)*/
run;
title "국가 : &m_country 에 거주하는 출생년도 : &m_year 이후 고객리스트";
title2 "작성자 : &sysuserid, 작성날짜 : %sysfunc(today(), yymmdd10.)";  /* 큰따옴표로 해야지 macro trigger 인식 가능 (tokenize) */
title3 "작성시간 : %sysfunc(time(), time.)"; 
proc print data=&m_lib..cust_&m_country._Y&m_year;
run;
title;


* 연산;
%put 1+2;
%put 계산처리작업1 : %eval(1+2);
%put 계산처리작업2 : %eval(3/2);     /* 정수값만 출력 (소수점 반올림) */
%put 게산처리작업3 : %eval(1.5+1.5); /* 숫자 피연산자 사용해야함 -> error */
%put 논리연산작업 : %eval(3>2);  /* true : 1/ false : 0

/* 리턴되는 값 : text  (계산만 해줄 뿐) */


* 현재시간;
data test;
	time = time();
	format time time.;
	put time=;
run;


/* 연습문제 1 */
/* 1) sashelp.class 데이터의 속성 및 값 확인 프로그램 작성
   2) m_dsn 매크로 변수에 sashelp.class 텍스트 저장
   3) 1)번의 프로그램을 m_dsn 매크로 변수 참조하여 변경
*/
 
proc sql inobs=10;
	title '테이블 : sashelp.class';
	describe table sashelp.class;
	select * from sashelp.class;
quit;
title;

* data를 macro로;
%let m_dsn=orion.customer;
proc sql inobs=10;
	title "테이블 : %upcase(&m_dsn)";
	describe table &m_dsn;
	select * from &m_dsn;
quit;
title;


* 문장 자체를 macro로 (%str 사용);
%let m_dsn=orion.customer;
%let m_info=
	%str(proc sql inobs=10;
		title "테이블 : %upcase(&m_dsn)";
		describe table &m_dsn;
		select * from &m_dsn;
		quit;
		title;
		);        /* ==> macro 먼저 실행되고 m_info가 되기 때문에 orion.customer가 계속적으로 포함되어 나옴 */

&m_info	

%put &=m_info;

%let m_dsn=sashelp.class;
&m_info  /* 새로운 data인 sashelp.class를 사용하여 m_info가 돌아가기를 원함. */


/* 3장 */
/* 매크로 (매크로 정의) */
%let m_dsn=orion.customer;

/* (이것도 가능)
%macro m_dsn;
 orion.customer
%mend;
*/

** 매크로나 어떠한 text도 모두 담을 수 있다.;
options mcompilenote=all mprint;  /* 1) 매크로 정의할 때 compile이 잘되는지 확인하기 위해 사용하는 option : mcomilenote=all */
								  /* 2) 매크로에 생성된 코드들을 보고 싶을 때 (실행된 코드) 사용하는 option : mprint */
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
%mcr_info


%let m_dsn=sashelp.class;
%mcr_info   /* data 바뀌어도 잘 작동되는 것을 확인할 수 있음. */
;




/* macro parameter 사용 */

/* positional parameter */
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

/* 호출할 때 값 지정 */
%mcr_info_p(orion.order_fact, 5)
%mcr_info_p(sashelp.class, 20)
%mcr_info_p(sashelp.class)  /* obs -> null 값 */
%mcr_info_p() /* null 값 -> error */
%mcr_info_p   /* 괄호필요 */


/* keyword parameter */
%macro mcr_info_k(m_dsn=sashelp.class, m_obs=10); 
	%put 작업시작시간 : %sysfunc(time(), time.);
	proc sql inobs=&m_obs;
		title "테이블 : %upcase(&m_dsn)";
		describe table &m_dsn;
		select * from &m_dsn;
		quit;
		title;
%mend;

%mcr_info_k /* ==> X */
%mcr_info_k() /* default 값으로 호출 */
%mcr_info_k(m_dsn=sashelp.air, m_obs=20)  /* keyword parameter 이므로 keyword를 작성해줘야함. */
%mcr_info_k(m_obs=5)
%mcr_info_k(m_dsn=orion.customer, m_obs=20)










