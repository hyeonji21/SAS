* orion.employee_information, orion.employee_donations;


* inner join ;

proc sql;
	*describe table orion.employee_information, orion.employee_donations;
	*현재 재직중인 직원 id, 부서, 급여, 총기부금액;
	
	create table work.emp_donations_info as
	select i.employee_id, /* 3. 기준칼럼 */ i.department, i.salary format=comma10. label='급여', 
	       sum(d.qtr1, d.qtr2, d.qtr3, d.qtr4) as total_don '총기부금액' format=comma10.1
		from orion.employee_information as i, orion.employee_donations as d  /* 1. 조인타입 결정 */
		where i.employee_id = d.employee_id  /* 2. 조인조건 */
			  and i.employee_term_date is null
		;
quit;


/* 연습문제 */

proc sql;
	describe table orion.order_fact, orion.customer;
quit;

proc sql;
	create table work.order_cust as
	select order_id, order_date, product_id, total_retail_price, f.customer_id,/* 3. */ country, gender,
		   case when upcase(country)='US' then total_retail_price * 0.3
		   		when upcase(country)='AU' then total_retail_price * 0.2
		   		else total_retail_price * 0.1
		   end as tax label='국가별 세금'
		from orion.order_fact as f, orion.customer as c /* 1. inner join */
		where f.customer_id = c.customer_id /* 2. */
		      and year(order_date) = 2010 
	;
quit;


/* 또다른 문법으로 inner join */
proc sql;
	create table work.order_cust as
	select order_id, order_date, product_id, total_retail_price, f.customer_id,/* 3. */ country, gender,
		   case when upcase(country)='US' then total_retail_price * 0.3
		   		when upcase(country)='AU' then total_retail_price * 0.2
		   		else total_retail_price * 0.1
		   end as tax label='국가별 세금'
		from orion.order_fact as f inner join orion.customer as c /* 1. inner join */
			 on f.customer_id = c.customer_id /* 2. */
		where year(order_date)=2010;
	;
quit;


/* 연습문제2 */

*orion.employee_information, orion.employee_donations;
*현재 재직중인 직원을 기준으로 해당 직원 id, 부서, 급여, 총기부금액;
* outer join;

proc sql;
	create table work.emp_donations_info as
	select i.employee_id, /* 3. 기준칼럼 */ i.department, i.salary format=comma10. label='급여', 
	       sum(d.qtr1, d.qtr2, d.qtr3, d.qtr4) as total_don '총기부금액' format=comma10.1
		from orion.employee_information as i left join orion.employee_donations as d 
			 on i.employee_id = d.employee_id/* 1. 조인타입 결정 */
		where i.employee_term_date is null /* 2. 조인조건 */
		;
quit;


/* 4-33 page 연습문제3 */

proc sql;
	*describe table orion.order_fact, orion.product_dim;
	*product_dim (회사 판매제품) 테이블의 제품 중 한번도 판매가 안된 제품;
	select pd.*     /* 해당 테이블의 모든 칼럼을 보여주게됨 */
		from orion.product_dim as pd left join orion.order_fact as of
			 on pd.prodcut_id = of.product_id
		where of.product_id is null
	;
quit;


/* 연습문제4 */

proc sql;
	select employee_id, job_title, employee_hire_date, salary
		from orion.employee_information
		where Employee_Term_Date is missing and salary >= 35000 and upcase(employee_gender)='M'
	;
quit;

proc sql;
	select job_title, 
		   avg(salary) as avg_salary
		from orion.employee_information
		where Employee_Term_Date is missing
		group by job_title
		having avg_salary >= 35000
	;
quit;

* 위 문제에서 추가;
* ==> 현재 재직중인 직원의 평균연봉(40476.92)들을 가져오려면?;
proc sql;
	select avg(salary) as total_avg
		from orion.employee_information
		where employee_term_date is null;
quit;

* subquery 사용;
proc sql;
	select employee_id, job_title, employee_hire_date, salary
		from orion.employee_information
		where Employee_Term_Date is missing 
		      and salary >= (select avg(Salary) as total_avg
		      					from orion.employee_information
		      					where employee_term_date is null) 
		      and upcase(employee_gender)='M'
	;
quit;

* subquery 사용2;
proc sql;
	describe table orion.employee_payroll, orion.employee_addresses;
quit;

/* 이번달(1월) 태어난 직원 리스트 */
proc sql;
	select employee_id, birth_date format=yymmdd10.
		from orion.employee_payroll
		where employee_term_date is null
			  and month(birth_date) = 1
	;
quit;
/* 위 해당 직원들의 주소 뽑아내기 */
proc sql;
	select employee_id, employee_name, country, city
		from orion.employee_addresses
		where employee_id in (select employee_id
									from orion.employee_payroll
									where employee_term_date is null and month(birth_date)=1)
	;
quit;


/* 연습문제5 */
/* 데이터 추가하여 다시 돌려볼 것 */
proc sql;
	describe table orion.employee_organization, orion.employee_payroll;
quit;

* step1 : 직급별 평균연봉테이블 생성 (inner join);
proc sql;
	create table work.job_salary as
	select job_title, avg(salary) as job_salary
		from orion.employee_organizaiton as org, orion.employee_payroll as p
		where org.employee_id = p.employee_id
		group by job_title
	;
quit;

* step2 동일직급 평균보다 더 많이 받는 직원의 세가지 테이블로부터 칼럼조회;
proc sql;
	select org.employee_id, org.department, org.job_title, p.salary, j.job_salary
		from orion.employee_organization as org, orion.employee_payroll as p, work.job_salary as j
		where org.employee_id = p.employee_id and org.job_title = j.job_title
			  and p.salary >= job_salary
	;
quit;

/* step1 + step2 */
proc sql;
	select org.employee_id, org.department, org.job_title, p.salary, j.job_salary
		from orion.employee_organization as org, orion.employee_payroll as p, 
			 (select job_title, avg(salary) as job_salary
			 	from orion.employee_organization as org, orion.employee_payroll as p
			 	where org.employee_id = p.employee_id
			 	group by job_title) as j
		where org.employee_id = p.employee_id and org.job_title = j.job_title
			  and p.salary >= j.job_salary
	;
quit;


/* chap6 */
/* 연습문제 */

* orion.qtr1, orion.qtr2;
proc sql;
	describe table orion.qtr1, orion.qtr2;
quit;

proc sql;
	select * from orion.qtr1 /* 칼럼 5개 */
	union 
	select * from orion.qtr2 /* 칼럼 6개 (순서다름) */
	;
quit;

proc sql;
	select * from orion.qtr1
	union corr all /* modifier () */
	select * from orion.qtr2
	;
quit;


proc sql;
	create table work.qtr12 as
	select * from orion.qtr1
	outer union corr /* 중복되는 것들끼리는 겹치게해줌 */
	select * from orion.qtr2
	;
quit;

 
/* all : 중복 로제거 */


/* 연습문제 2 */
/* 1. 상반기 거래의 거래형태(order_type)별 거래 건수 리포트
   2. 상반기 거래의 고객(customer_id)별 거래 건수 리포트
   
   step1) 상반기 테이블 생성 : work.qtr12 : outer union corr | union corr all
   step2) work.qtr12 테이블로부터 1,2번 리포트 생성 */
  
proc sql;
	create table work.qtr12 as
	select *
		from orion.qtr1
		outer union corr
	select *
		from orion.qtr2
	;
	
	select * from work.qtr12;
quit;

proc sql;
	select order_type, count(*) as count_order
		from work.qtr12
		group by order_type
	;
quit;
proc sql;
	select customer_id, count(*) as count_order
		from work.qtr12
		group by customer_id
	;
quit;


/* create view (가상의 테이블 사용) */
proc sql;
	create view orion.v_qtr12 as
	select * from orion.qtr1 
			 where order_type in (1, 2, 3)
		outer union corr
	select * from orion.qtr2
			 where order_type in (1, 2, 3)
			 
	using libname orion "/home/u58846815/Orion"  /* view의 파일과 다른 위치에 있는 파일을 쓸 때 경로 저장해놓으면 사용 가능 */
	;
quit;


proc sql;
	select order_type, count(*) as count_order
		from work.v_qtr12
		group by order_type
	;
quit;
proc sql;
	select customer_id, count(*) as count_order
		from work.qtr12
		group by customer_id
	;
quit;


/* orion,work 라이브러리에 employee_id가 포함된 테이블 리스트 */
proc sql;
	*describe table dictionary.columns;
	select libname, memname, memtype, name, type, varnum
		from dictionary.columns
		where UPCASE(libname) in ('ORION', 'WORK') and upcase(name)='EMPLOYEE_ID'
	;
quit;


/* orion,work 라이브러리에 테이블 정보 리포트
   테이블 : 라이브러리, 데이터 이름, 데이터 타입, 행의 수, 칼럼의 수 */
    
proc sql;
	*describe table dictionary.tables;
	select libname, memname, memtype, nlobs, nvar
		from dictionary.tables
		where upcase(libname) in ('ORION', 'WORK')
	;
quit;

















