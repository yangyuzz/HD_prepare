-- CONNECTION: name=postgres 2
-- =========================================================
-- Chapter 04. 과제 정답
-- SQL 기초 - 데이터 조회와 필터링
-- =========================================================
-- 사용 데이터: Northwind (public), Microsoft PdM (pdm)
-- =========================================================


-- Q1. orders 테이블에서 주문번호(order_id), 고객코드(customer_id), 주문일자(order_date)를
--     각각 주문번호, 고객코드, 주문일자라는 별칭으로 조회하시오.
--     주문일자가 빠른 순, 같으면 주문번호 순으로 정렬하고 5건만 조회하시오.

SELECT
    order_id    AS 주문번호,
    customer_id AS 고객코드,
    order_date  AS 주문일자
FROM orders
ORDER BY order_date, order_id
LIMIT 5;



-- Q2. pdm.pdm_machines 테이블에서 사용 연수(age)가 15 이상인 설비의
--     설비 번호(machineid), 모델(model), 사용 연수(age)를 조회하시오.
--     사용 연수가 많은 순(내림차순), 같으면 설비 번호 순으로 정렬하시오.


SELECT
    machineid,
    model,
    age
FROM pdm.pdm_machines
WHERE age >= 15
ORDER BY age DESC, machineid ASC;

-- 확인 포인트: 35대가 조회된다.



-- Q3. pdm.pdm_failures 테이블에서 설비 1번(machineid = 1)의
--     고장 일시(datetime)와 고장 부품(failure)을 일시 순으로 조회하시오.

SELECT
    datetime,
    failure
FROM pdm.pdm_failures
WHERE machineid = 1
ORDER BY datetime;

-- 확인 포인트: 7건이 조회된다.


-- Q4. pdm.pdm_errors 테이블에서 에러 유형(errorid)이 error1 또는 error3인
--     에러 기록의 건수를 IN을 사용하여 조회하시오.

SELECT COUNT(*) AS error_count
FROM pdm.pdm_errors
WHERE errorid IN ('error1', 'error3');


-- Q5. pdm.pdm_machines 테이블에서 설비 모델(model) 목록을
--     중복 없이 이름 순으로 조회하시오.
SELECT DISTINCT model
FROM pdm.pdm_machines
ORDER BY model;



-- Q6. pdm.pdm_telemetry 테이블에서 설비 1번의 2015년 1월 측정값 건수를
--     아래 두 방식으로 각각 조회하시오.
--     (1) BETWEEN '2015-01-01' AND '2015-01-31'
--     (2) 시작일 이상(>= '2015-01-01'), 다음 달 시작일 미만(< '2015-02-01')
--     두 결과가 다른 이유를 SQL 주석으로 적으시오.
-- (1) BETWEEN 방식
SELECT COUNT(*) AS between_count
FROM pdm.pdm_telemetry
WHERE machineid = 1
  AND datetime BETWEEN '2015-01-01' AND '2015-01-31';

-- (2) 시작일 이상, 다음 달 시작일 미만 방식
SELECT COUNT(*) AS range_count
FROM pdm.pdm_telemetry
WHERE machineid = 1
  AND datetime >= '2015-01-01'
  AND datetime <  '2015-02-01';

-- 확인 포인트: (1)은 715건, (2)는 738건이다.
-- 이유: datetime은 시간까지 있는 TIMESTAMP 컬럼이다.
--       BETWEEN의 끝값 '2015-01-31'은 '2015-01-31 00:00:00'으로 해석되므로
--       1월 31일 01시~23시 측정값 23건이 빠진다.
--       (2)처럼 다음 달 시작일 미만으로 쓰면 1월 31일 전체가 포함된다.


-- Q7. customers 테이블에서 담당자 직함(contact_title)이 'Sales'로 시작하는 고객의
--     회사명(company_name)과 직함(contact_title)을 조회하시오.
--     직함, 회사명 순으로 정렬하시오.
SELECT
    company_name,
    contact_title
FROM customers
WHERE contact_title LIKE 'Sales%'
ORDER BY contact_title, company_name;



-- Q8. products 테이블에서 단가가 20 이하이면서
--     카테고리(category_id)가 1 또는 2인 제품의
--     제품 번호, 제품명, 카테고리, 단가를 조회하시오.
--     단가가 낮은 순, 같으면 product_id 순으로 정렬하시오.
SELECT
    product_id,
    product_name,
    category_id,
    unit_price
FROM products
WHERE unit_price <= 20
  AND (category_id = 1 OR category_id = 2)
ORDER BY unit_price, product_id;

-- 확인 포인트: 15건이 조회된다.
-- 괄호를 빼면 (unit_price <= 20 AND category_id = 1) OR category_id = 2 로 계산되어
-- 단가가 20보다 비싼 카테고리 2 제품까지 포함된 22건이 나온다.


-- Q9. customers 테이블에서 팩스 번호(fax)가 없는(NULL) 고객 수를 조회하시오.

SELECT COUNT(*) AS null_fax_count
FROM customers
WHERE fax IS NULL;


-- Q10. orders 테이블에서 1998년 주문을 주문일자, 주문번호 순으로 정렬해
--      20건씩 볼 때 2페이지(21~40번째)를 조회하시오.
--      주문번호, 고객코드, 주문일자를 출력하시오.
--      기간 조건은 시작일 이상, 다음 해 시작일 미만 방식으로 작성하시오.

SELECT
    order_id,
    customer_id,
    order_date
FROM orders
WHERE order_date >= DATE '1998-01-01'
  AND order_date <  DATE '1999-01-01'
ORDER BY order_date, order_id
LIMIT 20 OFFSET 20;


-- Q11. customers 테이블에서 region이 NULL이면 '미지정'으로 표시하여
--      회사명, 원본 region, 표시용 region, 국가를 조회하시오.
--      국가, 회사명 순으로 정렬하고 20건만 조회하시오.
SELECT
    company_name,
    region AS original_region,
    COALESCE(region, '미지정') AS display_region,
    country
FROM customers
ORDER BY country, company_name
LIMIT 20;


-- Q12. products 테이블에서 재고금액(unit_price * units_in_stock)이
--      1000 이상인 제품을 조회하시오.
--      제품명, 단가, 재고수량, 재고금액을 출력하고
--      재고금액이 높은 순, product_id가 작은 순으로 정렬하시오.

SELECT
    product_name,
    unit_price,
    units_in_stock,
    unit_price * units_in_stock AS inventory_amount
FROM products
WHERE unit_price * units_in_stock >= 1000
ORDER BY inventory_amount DESC, product_id ASC;
