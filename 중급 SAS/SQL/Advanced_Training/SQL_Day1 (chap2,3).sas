/* libname orion "C:\educ\scap_94v4\scap_94"; */

/* 테이블 속성 확인 */
proc sql;
	describe table Orion.employee_information;
quit;

/* 테이블 값 확인 */

proc sql;
	select *
		from orion.employee_information;
quit;


proc sql feedback; /* 순서대로 콤마 기준으로 프로그래밍 실행이 보여짐 (log창에) -> 실제 sas가 실행한 쿼리를 보여줌. */
	select * 
		from orion.employee_information;
quit;


/* p2-18 칼럼선택 + 칼럼생성 (산술연산, 조건처리) */

proc sql;
  select employee_id, employee_gender, salary, salary*0.1 as bonus, 
  		 case
  		  when upcase(employee_gender)="M" then 100 
  		  when upcase(employee_gender)="F" then 110
  		  else 50
  		 end as bonus2
	from orion.employee_information
	;
quit;
  
proc sql;
  select employee_id, employee_gender, salary, salary*0.1 as bonus, 
  		 case
  		  when upcase(employee_gender)="M" then salary*0.1 
  		  when upcase(employee_gender)="F" then salary*0.2
  		  else salary*0.05
  		 end as bonus2
	from orion.employee_information
	;
quit;
/* -> report로 추출됨(쿼리로) */

/* p2-18 칼럼선택
   p2-20 + 칼럼생성 (산술연산, 조건처리) 
   p2-32 + 질의결과를 테이블로 생성*/
  
/* "case upcase(employee_gender)" 꼴은 =인 경우에만 가능 */
proc sql;
	create table work.emp_bonus as
	select employee_id, employee_gender, salary, salary*0.1 as bonus,
		case upcase(employee_gender)
			when "M" then salary*0.1
			when "F" then salary*0.2
			else salary*0.05
		end as bonus2
	from orion.employee_information
	;
quit;
/* table을 만들기 위해서는 create table 사용 */


/* row 선택 작업 */
proc sql feedback number; /* number : rows로 행 숫자 추가해줌 */
	create table work.emp_bonus as
	select employee_id, employee_gender, salary, salary*0.1 as bonus,
		case upcase(employee_gender)
			when "M" then salary*0.1
			when "F" then salary*0.2
			else salary*0.05
		end as bonus2
	from orion.employee_information /* 424 rows */
	where salary > 112000 and employee_term_date=.  /* salary > 112000이면서 현재 재직중인 사람들 */
	/* where salary > 112000 and employee_term_date is missing */
	; 
	
	select * from work.emp_bonus;
quit;



/* where이 select보다 먼저 실행되기 때문에 bonus 변수를 사용할 때 calculated 사용할 것 */
/* 새롭게 생성한 칼럼에 대해서 */

proc sql feedback number; /* number : rows로 행 숫자 추가해줌 */
	create table work.emp_bonus as
	select employee_id, employee_gender, salary, salary*0.1 as bonus, calculated bonus/2 as half,
		case upcase(employee_gender)
			when "M" then salary*0.1
			when "F" then salary*0.2
			else salary*0.05
		end as bonus2
	from orion.employee_information /* 424 rows */
	where calculated bonus <= 3000 and employee_term_date=.  /* salary > 112000이면서 현재 재직중인 사람들 */
	; 
	
	select * from work.emp_bonus;
quit;


/* 연습문제1 */
proc sql;
	describe table orion.employee_payroll;
quit;

proc sql;
	create table work.emp_info as
	select employee_id, employee_gender "성별", marital_status, salary format=comma10., 
	       birth_date label="생일" format=yymmdd10., 
		   salary * 1/3 as tax '급여의 30%' format=comma10.1, /* ''사용하여 라벨 달기 */ 
		   case when salary >= 100000 then '10만 이상'
		   		when salary <= 100000 then '10만 미만'
		   end as grp_salary
	from orion.employee_payroll
	where upcase(marital_status) = "S" and calculated tax >= 10000 and employee_term_date=. /* is missing*/
	order by employee_gender, 6 desc  /*쿼리 결과에 적용됨*/
	;
quit;


/* 연습문제2 */
proc sql;
	describe table orion.order_fact;
quit;

proc sql;
	create table work.order2011 as /* as 적는 것 주의 */
	select order_id, customer_id, product_id, 
		   order_date label="주문일자" format=yymmdd10., 
		   delivery_date label="배송일자" format=yymmdd10.,
		   total_retail_price label="판매금액" format=comma10.,
		   delivery_Date - order_date as days, 
		   case	when total_retail_price < 100 then "P1"   
		        /* total_retail_price값에 missing value가 들어오면 P1으로 설정됨 */
		        /* missing value는 어떠한 값보다 작은 값 (0보다 작음) */
		   		when 100 <= total_retail_price <= 200 then "P2"
		   		when total_retail_price > 200 then "P3"
		   end as g_price label="판매등급(3등급)"
	from orion.order_fact
	where order_type=3 and year(order_date)=2011
	order by order_date desc
	;
	
	select * from work.order2011;
quit;


/* orion.employee_information 직원 테이블
   현재 재직중인 직원의 부서, 직급 리포트 */
proc sql number;
	select distinct department, job_title  /* query => (정렬) => 중복제거 */
	from orion.employee_information  /* 404 rows */
	where employee_term_date is null  /* 308 rows */
	;
quit;


/* summary 함수 */
proc sql;
	select sum(salary) as total, 
		   avg(salary) as avg_salary,     /* item은 2개지만 row는 1개 */
		   count(*) as c1,
		   count(salary) as c2,
		   /*count(employee_term_date) as c2    /* 퇴직한 사람들을 뽑게 됨 */
		   count(distinct manager_id) as mgr_cnt   /* manager의 수에 대해 알 수 있음. */
		  
		from orion.employee_information /* 404 rows */
		where employee_term_date is null /* 308 rows */
	;
quit;


proc sql;
	select employee_gender,
		   sum(salary) as total, 
		   avg(salary) as avg_salary,     /* item은 2개지만 row는 1개 */
		   count(*) as c1,
		   count(salary) as c2,
		   /*count(employee_term_date) as c2    /* 퇴직한 사람들을 뽑게 됨 */
		   count(distinct manager_id) as mgr_cnt   /* manager의 수에 대해 알 수 있음. */
		  
		from orion.employee_information /* 404 rows */
		where employee_term_date is null /* 308 rows */
	;
quit;


/* summary report 
   현재 재직중인 기준으로 부서내 직급별 인원수(cnt), 평균급여(avg_salary) */
  
/* 주의 : 전체의 avg와 count를 계산하는 것이 아닌 그룹별로 구하는 것 */

proc sql;
	select department, job_title, 
	       count(*) as cnt label="인원수",  
		   avg(salary) as avg_salary format=comma10.1
		   from orion.employee_information
		   where employee_term_date=.
		   group by department, job_title  /* group by 1 2 */
		   having cnt >= 5   /* 요약된 결과에 대해 조건 줄 때 having 사용 -> 조건에 맞는 그룹만 가져올 것이다.*/
		   order by cnt desc 
		   ;
quit;

/* where : row 선택 -> 입력테이블 칼럼에 대한 조건*/
/* having : 그룹선택 -> 요약함수를 통해 생성한 값에 대한 조건 */


/* 연습문제3 */

proc sql;
	describe table orion.order_fact;
quit;

proc sql;
create table work.order_cust as
select customer_id ,
	   count(*) as cust_cnt ,
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
quit;




	



















































