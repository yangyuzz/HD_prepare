-- CONNECTION: url=jdbc:postgresql://localhost:5432/hd
-- =========================================================
-- Chapter 04. 과제
-- SQL 기초 - 데이터 조회와 필터링
-- =========================================================
-- 실행 환경: DBeaver
-- 대상 데이터베이스: hd
-- 사용 데이터: Northwind (public), Microsoft PdM (pdm)
--
-- 작성 원칙
-- 1. 각 문제 아래에 SQL을 작성한다.
-- 2. 필요한 컬럼만 SELECT한다.
-- 3. 결과 순서가 문제에 포함되면 ORDER BY를 반드시 사용한다.
-- 4. LIMIT/OFFSET 문제는 예측 가능한 정렬 기준을 함께 사용한다.
-- 5. PdM 테이블은 스키마를 붙여 쓴다. (예: pdm.pdm_machines)
-- =========================================================


-- Q1. orders 테이블에서 주문번호(order_id), 고객코드(customer_id), 주문일자(order_date)를
--     각각 주문번호, 고객코드, 주문일자라는 별칭으로 조회하시오.
--     주문일자가 빠른 순, 같으면 주문번호 순으로 정렬하고 5건만 조회하시오.
select order_id as "주문번호", customer_id as "고객코드", order_date as "주문일자"
from orders 
order by order_date  ,order_id
limit 5;


-- Q2. pdm.pdm_machines 테이블에서 사용 연수(age)가 15 이상인 설비의
--     설비 번호(machineid), 모델(model), 사용 연수(age)를 조회하시오.
--     사용 연수가 많은 순, 같으면 설비 번호 순으로 정렬하시오.
select machineid , model , age 
from pdm.pdm_machines
where age >=15
order by age desc, machineid ;


-- Q3. pdm.pdm_failures 테이블에서 설비 1번(machineid = 1)의
--     고장 일시(datetime)와 고장 부품(failure)을 일시 순으로 조회하시오.
select datetime, failure
from pdm.pdm_failures 
where machineid = 1
order by datetime;


-- Q4. pdm.pdm_errors 테이블에서 에러 유형(errorid)이 error1 또는 error3인
--     에러 기록의 건수를 IN을 사용하여 조회하시오.
select * from pdm.pdm_errors limit3;
select count (*)
from pdm.pdm_errors 
where errorid in ('error1' , 'error3');

-- Q5. pdm.pdm_machines 테이블에서 설비 모델(model) 목록을
--     중복 없이 이름 순으로 조회하시오.
select distinct model
from pdm.pdm_machines 
order by model;


-- Q6. pdm.pdm_telemetry 테이블에서 설비 1번의 2015년 1월 측정값 건수를
--     아래 두 방식으로 각각 조회하시오.
--     (1) BETWEEN '2015-01-01' AND '2015-01-31'
--     (2) 시작일 이상(>= '2015-01-01'), 다음 달 시작일 미만(< '2015-02-01')
--     두 결과가 다른 이유를 SQL 주석으로 적으시오.

select * 
from pdm.pdm_telemetry 
where machineid = 1 
and datetime between '2015-01-01' and '2015-01-31';

select * 
from pdm.pdm_telemetry 
where machineid = 1 
and datetime >= '2015-01-01' and datetime < '2015-01-31';

--BETWEEN '2015-01-01' AND '2015-01-31' 처럼 쓰면 종료값이'2015-01-31 00:00:00'으로 해석된다.
--컬럼이 TIMESTAMP 타입이면 1월 31일 낮 시간대 데이터가 빠진다.

-- Q7. customers 테이블에서 담당자 직함(contact_title)이 'Sales'로 시작하는 고객의
--     회사명(company_name)과 직함(contact_title)을 조회하시오.
--     직함, 회사명 순으로 정렬하시오.
select company_name, contact_title
from customers
where contact_title like 'Sales%'
order by contact_title, company_name;


-- Q8. products 테이블에서 단가가 20 이하이면서
--     카테고리(category_id)가 1 또는 2인 제품의
--     제품 번호, 제품명, 카테고리, 단가를 조회하시오.
--     단가가 낮은 순, 같으면 product_id 순으로 정렬하시오.
select product_id, product_name, category_id, unit_price
from products
where unit_price <= 20 and (category_id = 1 or category_id = 2)
order by unit_price, product_id;

-- Q9. customers 테이블에서 팩스 번호(fax)가 없는(NULL) 고객 수를 조회하시오.
select count (*)
from customers
where fax is null;

-- Q10. orders 테이블에서 1998년 주문을 주문일자, 주문번호 순으로 정렬해
--      20건씩 볼 때 2페이지(21~40번째)를 조회하시오.
--      주문번호, 고객코드, 주문일자를 출력하시오.
--      기간 조건은 시작일 이상, 다음 해 시작일 미만 방식으로 작성하시오.

select order_id, customer_id, order_date
from orders
where order_date >= '1998-01-01' and order_date < '1999-01-01'
order by order_date, order_id limit 20 offset 20; 

-- Q11. customers 테이블에서 region이 NULL이면 '미지정'으로 표시하여
--      회사명, 원본 region, 표시용 region, 국가를 조회하시오.
--      국가, 회사명 순으로 정렬하고 20건만 조회하시오.
select * from customers limit 2; 
select company_name, region as "원본 region", coalesce( region, '미지정') as "표시용 region", country 
from customers
order by country, company_name 
limit 20;

-- Q12. products 테이블에서 재고금액(unit_price * units_in_stock)이
--      1000 이상인 제품을 조회하시오.
--      제품명, 단가, 재고수량, 재고금액을 출력하고
--      재고금액이 높은 순, product_id가 작은 순으로 정렬하시오.
select product_name, unit_price, units_in_stock, (unit_price * units_in_stock)
from products
where (unit_price*units_in_stock) >= 1000
order by (unit_price*units_in_stock) desc, product_id;