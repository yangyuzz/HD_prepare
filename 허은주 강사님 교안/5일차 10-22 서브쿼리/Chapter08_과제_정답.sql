-- CONNECTION: url=jdbc:postgresql://localhost:5432/hd
-- =========================================================
-- Chapter 08. 과제 정답
-- SQL 서브쿼리(Subquery)
-- =========================================================
-- 실행 환경: DBeaver
-- 대상 데이터베이스: hd
-- 사용 데이터: Northwind(public), AI4I(mfg), PdM(pdm)
-- =========================================================


-- Q1. orders에서 가장 마지막 주문일(order_date)에 들어온 주문을 모두 조회하시오.
--     출력: order_id, customer_id, order_date
--     order_id 순으로 정렬하시오.
--     힌트: 마지막 주문일에 주문이 여러 건이면 모두 나와야 한다.

SELECT
    order_id,       -- 주문 번호
    customer_id,    -- 고객 코드
    order_date      -- 주문 일자
FROM orders
WHERE order_date = (
    SELECT MAX(order_date)
    FROM orders
)
ORDER BY order_id;

-- 확인 포인트: 4행 (모두 1998-05-06)
--   11074 SIMOB / 11075 RICSU / 11076 BONAP / 11077 RATTC
-- ※ ORDER BY order_date DESC LIMIT 1로 풀면 4건 중 1건만 나온다.
--   "마지막 주문일의 주문 전부"는 MAX 값과 비교하는 단일 행 서브쿼리로 구한다.


-- Q2. order_details 테이블에서
--     주문상세 행당 평균 수량보다 quantity가 큰
--     주문상세 행의 개수를 조회하시오.
--     평균 수량은 서브쿼리로 계산하시오.
SELECT COUNT(*) AS above_avg_count   -- 평균보다 수량이 큰 행 수
FROM order_details
WHERE quantity > (
    SELECT AVG(quantity)
    FROM order_details
);

-- 확인 포인트: 860행 (전체 2155행, 평균 수량 약 23.81)
-- ※ WHERE quantity > AVG(quantity) 처럼 WHERE에 집계 함수를 직접 쓰면 오류다.
--   ERROR: aggregate functions are not allowed in WHERE
--   (한국어 Windows: 오류: 집계 함수는 WHERE 절에서 사용할 수 없습니다.)


-- Q3. 공급업체 국가가 'Germany'인 공급업체의 제품을 IN 서브쿼리로 조회하시오.
--     출력: product_id, product_name, supplier_id
--     product_id 순으로 정렬하시오.

SELECT
    product_id,     -- 제품 번호
    product_name,   -- 제품명
    supplier_id     -- 공급업체 번호
FROM products
WHERE supplier_id IN (
    SELECT supplier_id
    FROM suppliers
    WHERE country = 'Germany'
)
ORDER BY product_id;

-- 확인 포인트: 9행 (product_id 25, 26, 27, 28, 29, 30, 64, 75, 77)
--   독일 공급업체는 11, 12, 13번 세 곳이다.
-- ※ 서브쿼리가 3개 값을 반환하므로 = 를 쓰면 오류가 나고 IN을 써야 한다.


-- Q4. 담당 직원이 한 명도 배정되지 않은 지역(territories)을 NOT EXISTS로 조회하시오.
--     출력: territory_id, territory_description
--     territory_id 순으로 정렬하시오.
--     연결 기준: territories.territory_id = employee_territories.territory_id

SELECT
    t.territory_id,            -- 지역 코드
    t.territory_description    -- 지역명
FROM territories t
WHERE NOT EXISTS (
    SELECT 1
    FROM employee_territories et
    WHERE et.territory_id = t.territory_id
)
ORDER BY t.territory_id;

-- 확인 포인트: 4행
--   29202 Columbia / 72716 Bentonville / 75234 Dallas / 78759 Austin


-- Q5. 고객 지역(customers.region)이 공급업체 지역(suppliers.region) 목록에 없는 고객 수를
--     NOT IN으로 세시오.
--     (1) 서브쿼리에 아무 조건도 붙이지 않고 실행하고 결과를 확인하시오.
--     (2) suppliers.region의 NULL 개수를 조회하시오.

-- (1)
SELECT COUNT(*) AS customer_count   -- 고객 수
FROM customers
WHERE region NOT IN (
    SELECT region
    FROM suppliers
);

-- 확인 포인트: 0

-- (2)
SELECT COUNT(*) AS null_region_count   -- 지역이 NULL인 공급업체 수
FROM suppliers
WHERE region IS NULL;

-- 확인 포인트: 20 (공급업체 29곳 중 20곳)

-- (1) 정답 해설
-- suppliers.region 목록에 NULL이 포함되어 있다.
-- NOT IN은 일치하는 값이 없더라도 목록에 NULL이 있으면
-- 결과가 UNKNOWN이 될 수 있다.
-- WHERE는 TRUE인 행만 남기므로 조회 결과가 0건이다.

-- (2) 확인 결과
-- suppliers.region이 NULL인 행은 20건이다.
-- 이로써 (1)의 NOT IN 목록에 NULL이 포함되어 있음을 확인한다.


-- Q6. 상관 서브쿼리를 사용해 고객별 가장 최근 주문을 조회하시오.
--     출력: customer_id, order_id, order_date
--     customer_id, order_id 순으로 정렬하시오.
--     결과 행 수와 고객 수가 다른 이유를 SQL 주석으로 적으시오.

SELECT
    o.customer_id,   -- 고객 코드
    o.order_id,      -- 주문 번호
    o.order_date     -- 주문 일자
FROM orders o
WHERE o.order_date = (
    SELECT MAX(o2.order_date)
    FROM orders o2
    WHERE o2.customer_id = o.customer_id    -- 상관 조건: 같은 고객의 주문만
)
ORDER BY o.customer_id, o.order_id;

-- 확인 포인트: 90행, 고객 89명
--   ALFKI 11011 (1998-04-09) / ANATR 10926 (1998-03-04) / ...
-- ※ 이유: LACOR 고객은 같은 날(1998-03-24) 주문이 2건(10972, 10973)이므로
--   최근 주문일과 같은 행이 2개 나온다. 동점은 모두 결과에 남는다.


-- Q7. 파생 테이블(FROM 절 서브쿼리)을 사용해
--     주문별 품목 수(order_details 행 수)를 먼저 구한 뒤,
--     품목 수별 주문 건수를 조회하시오.
--     품목 수 순으로 정렬하시오.

SELECT
    t.item_count,                -- 주문 1건의 품목 수
    COUNT(*) AS order_count      -- 주문 건수
FROM (
    SELECT
        order_id,
        COUNT(*) AS item_count   -- 주문별 품목 수
    FROM order_details
    GROUP BY order_id
) AS t
GROUP BY t.item_count
ORDER BY t.item_count;

-- 확인 포인트: 7행
--   1개 137 / 2개 283 / 3개 248 / 4개 125 / 5개 33 / 6개 3 / 25개 1
--   주문 건수 합계는 830이다.
-- ※ 1단계(주문별 품목 수)를 집계한 결과를 다시 2단계(품목 수별 주문 건수)로 집계하므로
--   파생 테이블이 필요하다.


-- Q8. categories의 각 카테고리 옆에 소속 제품 수와 최고 단가를
--     스칼라 서브쿼리 2개로 표시하시오.
--     출력: category_id, category_name, 제품 수, 최고 단가
--     category_id 순으로 정렬하시오.

SELECT
    cat.category_id,     -- 카테고리 번호
    cat.category_name,   -- 카테고리명
    (
        SELECT COUNT(*)
        FROM products p
        WHERE p.category_id = cat.category_id
    ) AS product_count,  -- 제품 수
    (
        SELECT MAX(p.unit_price)
        FROM products p
        WHERE p.category_id = cat.category_id
    ) AS max_price       -- 최고 단가
FROM categories cat
ORDER BY cat.category_id;

-- 확인 포인트: 8행
--   1 Beverages 12 / 263.5      2 Condiments 12 / 43.9
--   3 Confections 13 / 81       4 Dairy Products 10 / 55
--   5 Grains/Cereals 7 / 38     6 Meat/Poultry 6 / 123.79
--   7 Produce 5 / 53            8 Seafood 12 / 62.5
-- ※ 스칼라 서브쿼리는 값 1개만 돌려주므로 제품 수와 최고 단가를 하나에 같이 담을 수 없다.
--   값마다 서브쿼리를 하나씩 쓴다.


-- Q12. 다음 질문에 SQL 주석으로 답하시오.

-- (1) IN과 EXISTS의 의미 차이는 무엇인가?
--     IN은 왼쪽 값이 서브쿼리 결과의 값 집합에 포함되는지를 비교하고,
--     EXISTS는 서브쿼리가 조건을 만족하는 행을 한 행이라도 반환하는지 확인한다.

-- (3) 상관 서브쿼리는 무엇인가?
--     안쪽 서브쿼리가 바깥 쿼리의 컬럼 값을 참조하는 서브쿼리다.
--     바깥 참조가 있으므로 서브쿼리만 따로 떼어 실행할 수 없다.

-- (4) 스칼라 서브쿼리가 0행이면 어떻게 되는가?
--     결과는 NULL이다. 2행 이상이면 오류가 난다.


