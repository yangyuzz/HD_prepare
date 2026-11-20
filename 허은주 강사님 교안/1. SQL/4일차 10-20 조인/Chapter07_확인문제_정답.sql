-- =========================================================
-- Chapter 07 확인 문제
-- =========================================================

-- Q1. customers와 orders를 JOIN하여
--     고객 회사명(company_name)과 주문번호(order_id)를 조회하시오.
--     주문번호 오름차순으로 정렬하고 10건만 출력하시오.
-- 정답:

SELECT c.company_name, o.order_id
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_id
LIMIT 10;



-- Q2. customers와 orders를 LEFT JOIN하여
--     주문 이력이 없는 고객만 조회하시오.
--     고객 코드(customer_id)와 회사명(company_name)을 출력하시오.
-- 정답:

SELECT c.customer_id, c.company_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;



-- Q3. products와 categories를 JOIN하여
--     제품명(product_name)과 카테고리명(category_name)을 조회하시오.
--     제품번호(product_id) 오름차순으로 정렬하고
--     10건만 출력하시오.
-- 정답:

SELECT p.product_name, c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
ORDER BY p.product_id
LIMIT 10;



-- Q4. customers와 orders를 JOIN하여
--     주문 이력이 있는 고객별 주문 건수를 조회하시오.
--     고객 회사명과 주문 건수를 출력하시오.
--     주문 건수가 많은 순으로 정렬하고,
--     동점이면 고객 코드 오름차순으로 정렬하시오.
--     상위 10명만 조회하시오.
-- 정답:

SELECT
    c.company_name,
    COUNT(o.order_id) AS order_count  -- 주문 건수
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.company_name
ORDER BY order_count DESC, c.customer_id
LIMIT 10;





-- Q5. employees 테이블을 SELF JOIN하여
--     직원 이름과 해당 직원의 상사 이름을 함께 조회하시오.
--     상사가 없는 직원도 결과에 포함하시오.
--     직원번호(employee_id) 오름차순으로 정렬하시오.
-- 정답:

SELECT
    e.first_name || ' ' || e.last_name AS employee_name,  -- 직원 이름
    m.first_name || ' ' || m.last_name AS manager_name    -- 상사 이름
FROM employees e
LEFT JOIN employees m ON e.reports_to = m.employee_id
ORDER BY e.employee_id;



-- Q6. products와 order_details를 JOIN하여
--     제품별 총 판매 수량을 계산하시오.
--     제품명과 총 판매 수량을 출력하시오.
--     총 판매 수량이 많은 순으로 정렬하고,
--     동점이면 제품번호 오름차순으로 정렬하시오.
--     상위 10개 제품만 조회하시오.
-- 정답:

SELECT
    p.product_name,
    SUM(od.quantity) AS total_quantity  -- 총 판매 수량
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity DESC, p.product_id
LIMIT 10;





-- Q7. customers와 orders를 LEFT JOIN하여
--     국가(country)별 전체 고객 수와 주문 건수를 조회하시오.
--     주문 이력이 없는 고객도 고객 수에 포함하시오.
--     고객 수는 중복 없이 계산하고,
--     주문 건수가 많은 순으로 정렬하시오.
-- 정답:

SELECT
    c.country,
    COUNT(DISTINCT c.customer_id) AS customer_count,  -- 고객 수
    COUNT(o.order_id)             AS order_count      -- 주문 건수
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY order_count DESC;



-- Q8. customers와 orders를 JOIN하여
--     1997년 1월 1일부터 12월 31일까지 발생한 주문의
--     고객 회사명과 주문일자(order_date)를 조회하시오.
--     주문일자 오름차순으로 정렬하고,
--     같은 날짜이면 주문번호 오름차순으로 정렬하시오.
-- 정답:

SELECT
    c.company_name,
    o.order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '1997-01-01'
  AND o.order_date <  '1998-01-01'
ORDER BY o.order_date, o.order_id;



-- Q9. customers, orders, order_details를 JOIN하여
--     고객별 할인 전 총 구매금액을 계산하시오.
--     고객 회사명과 할인 전 구매금액을 출력하시오.
--     구매금액은 소수 둘째 자리까지 반올림하시오.
--     구매금액이 많은 순으로 정렬하고
--     상위 5명만 조회하시오.
-- 정답:

SELECT
    c.company_name,
    ROUND(SUM(od.unit_price * od.quantity)::NUMERIC, 2) AS gross_amount  -- 할인 전 구매 금액
FROM customers c
JOIN orders o         ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.company_name
ORDER BY gross_amount DESC
LIMIT 5;



-- Q10. customers와 orders를 LEFT JOIN하여
--      1998년 1월 1일부터 발생한 주문을 대상으로
--      다음 두 가지 방법의 JOIN 결과 행 수를 비교하시오.
--
--      방법 1: ON 절에 주문일자 조건을 지정하시오.
--              모든 고객을 유지하면서
--              해당 날짜부터의 주문만 연결하시오.
--
--      방법 2: WHERE 절에 주문일자 조건을 지정하시오.
--              JOIN 결과 중 해당 날짜부터의
--              주문이 연결된 행만 조회하시오.
--
--      두 방법 모두 COUNT(*)로 결과 행 수를 구하고,
--      결과가 달라지는 이유를 설명하시오.
-- 정답:

-- 방법 1: ON에 조건 지정 (모든 고객 유지)
SELECT COUNT(*) AS on_condition_count  -- ON에 조건을 둔 결과 행 수
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
 AND o.order_date >= '1998-01-01';



-- 방법 2: WHERE에 조건 지정 (조건을 만족하는 주문 행만 유지)
SELECT COUNT(*) AS where_condition_count  -- WHERE에 조건을 둔 결과 행 수
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.order_date >= '1998-01-01';



-- ※ Q10 정답 해설
--
-- 방법 1 (ON):
--   모든 고객을 유지한다.
--   1998년 1월 1일부터의 주문만 연결하고,
--   해당 기간에 주문이 없는 고객도 NULL이 채워진 행으로 남는다.
--
-- 방법 2 (WHERE):
--   LEFT JOIN 후 주문일자 조건을 적용한다.
--   해당 기간의 주문이 연결되지 않은 행은 제외된다.
--
-- ※ COUNT(*)는 고객 수가 아니라 JOIN 결과 행 수를 센다.
--    한 고객에게 주문이 여러 건이면 여러 행이 생성될 수 있다.