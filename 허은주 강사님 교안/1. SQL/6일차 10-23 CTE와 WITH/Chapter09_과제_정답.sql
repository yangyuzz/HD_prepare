-- CONNECTION: url=jdbc:postgresql://localhost:5432/hd
-- =========================================================
-- Chapter 09. 과제 정답
-- CTE(Common Table Expression)와 WITH 문
-- =========================================================

-- 사용 데이터: Northwind(public), AI4I(mfg), PdM(pdm)
-- =========================================================


-- Q1. products에서 단가(unit_price)가 50 이상인 제품을 expensive_products CTE로 만들고,
--     제품명(product_name)과 단가를 조회하시오.
--     단가가 높은 순으로 정렬하시오.

WITH expensive_products AS (                 -- 단가 50 이상 제품
    SELECT
        product_name,                        -- 제품명
        unit_price                           -- 단가
    FROM products
    WHERE unit_price >= 50
)
SELECT *
FROM expensive_products
ORDER BY unit_price DESC;

-- 확인 포인트: 7행
-- ※ WITH 이름 AS ( SELECT ... ) 로 결과에 이름을 붙이고,
--   바깥 SELECT에서는 그 이름을 테이블처럼 FROM에 쓴다.


-- Q2. 아래 FROM 절 서브쿼리를 같은 결과가 나오는 CTE로 바꾸시오.
--     category_id 순으로 정렬하시오.
--
--     SELECT *
--     FROM (
--         SELECT category_id, COUNT(*) AS product_count
--         FROM products
--         GROUP BY category_id
--     ) AS t
--     WHERE product_count >= 10;

WITH category_products AS (                  -- 카테고리별 제품 수
    SELECT
        category_id,                         -- 카테고리 번호
        COUNT(*) AS product_count            -- 제품 수
    FROM products
    GROUP BY category_id
)
SELECT *
FROM category_products
WHERE product_count >= 10
ORDER BY category_id;

-- 확인 포인트: 5행
--   1 → 12 / 2 → 12 / 3 → 13 / 4 → 10 / 8 → 12
-- ※ FROM ( ... ) AS t 의 괄호 안 SELECT를 WITH 이름 AS ( ... ) 로 옮기고,
--   바깥 FROM에는 CTE 이름을 쓴다.


-- Q3. orders에서 배송 국가(ship_country)별 주문 건수를 CTE로 만들고,
--     주문 건수가 50건 이상인 국가만 조회하시오.
--     주문 건수가 많은 순으로 정렬하고, 같으면 국가 이름 순으로 정렬하시오.

WITH country_orders AS (                     -- 배송 국가별 주문 건수
    SELECT
        ship_country,                        -- 배송 국가
        COUNT(*) AS order_count              -- 주문 건수
    FROM orders
    GROUP BY ship_country
)
SELECT *
FROM country_orders
WHERE order_count >= 50
ORDER BY order_count DESC, ship_country;

-- 확인 포인트: 5행
-- ※ 집계는 CTE 안에서 하고, 집계 결과로 거르는 조건은 바깥 WHERE에 쓴다.
--   HAVING COUNT(*) >= 50 으로도 같은 결과를 낼 수 있다


-- Q4. orders에서 직원별 주문 건수를 CTE로 만든 뒤 employees와 JOIN하여
--     직원 번호, 이름(first_name), 성(last_name), 주문 건수를 조회하시오.
--     주문 건수가 많은 순으로 정렬하고, 같으면 직원 번호 순으로 정렬하시오.

WITH employee_orders AS (                    -- 직원별 주문 건수
    SELECT
        employee_id,                         -- 직원 번호
        COUNT(*) AS order_count              -- 주문 건수
    FROM orders
    GROUP BY employee_id
)
SELECT
    e.employee_id,                           -- 직원 번호
    e.first_name,                            -- 이름
    e.last_name,                             -- 성
    eo.order_count                           -- 주문 건수
FROM employees e
JOIN employee_orders eo
  ON e.employee_id = eo.employee_id
ORDER BY eo.order_count DESC, e.employee_id;

-- 확인 포인트: 9행
-- ※ 주문을 먼저 직원 단위로 집계한 뒤 JOIN하므로 직원 1명당 1행이 된다.


-- Q5. products의 단가를 아래 기준으로 나누는 CTE를 만들고,
--     구간별 제품 수를 조회하시오. 구간 순으로 정렬하시오.
--     20 미만        → '1_저가'
--     20 이상 50 미만 → '2_중가'
--     50 이상        → '3_고가'

WITH price_band AS (                         -- 제품별 단가 구간
    SELECT
        product_name,                        -- 제품명
        CASE
            WHEN unit_price < 20 THEN '1_저가'
            WHEN unit_price < 50 THEN '2_중가'
            ELSE                      '3_고가'
        END AS band                          -- 단가 구간
    FROM products
)
SELECT
    band,                                    -- 단가 구간
    COUNT(*) AS product_count                -- 제품 수
FROM price_band
GROUP BY band
ORDER BY band;

-- 확인 포인트: 3행 (합계 77개)



-- Q6. products의 평균 단가를 avg_price CTE로 구한 뒤,
--     평균 단가보다 비싼 제품의 제품명과 단가를 조회하시오.
--     단가가 높은 순으로 정렬하시오.

WITH avg_price AS (                          -- 전체 평균 단가 (1행)
    SELECT AVG(unit_price) AS avg_unit_price -- 평균 단가
    FROM products
)
SELECT
    product_name,                            -- 제품명
    unit_price                               -- 단가
FROM products
WHERE unit_price > (SELECT avg_unit_price FROM avg_price)
ORDER BY unit_price DESC;

-- 확인 포인트: 25행 (평균 단가 약 28.83)
--   1위 Côte de Blaye 263.5 ... 25위 Uncle Bob's Organic Dried Pears 30
-- ※ avg_price는 1행 1열이므로 (SELECT avg_unit_price FROM avg_price)를
--   값 하나처럼 비교에 쓸 수 있다.


-- Q7. 아래 두 CTE를 차례로 만든 뒤, products와 JOIN하여
--     1000개 이상 팔린 제품의 제품명과 총 판매 수량을 조회하시오.
--     총 판매 수량이 많은 순으로 정렬하시오.
--     product_qty  : order_details에서 제품별 총 판매 수량(quantity 합계)
--     best_sellers : product_qty에서 총 판매 수량이 1000 이상인 제품

WITH product_qty AS (                        -- 제품별 총 판매 수량
    SELECT
        product_id,                          -- 제품 번호
        SUM(quantity) AS total_qty           -- 총 판매 수량
    FROM order_details
    GROUP BY product_id
),
best_sellers AS (                            -- 1000개 이상 팔린 제품
    SELECT
        product_id,                          -- 제품 번호
        total_qty                            -- 총 판매 수량
    FROM product_qty
    WHERE total_qty >= 1000
)
SELECT
    p.product_name,                          -- 제품명
    b.total_qty                              -- 총 판매 수량
FROM best_sellers b
JOIN products p
  ON b.product_id = p.product_id
ORDER BY b.total_qty DESC, p.product_name;

-- 확인 포인트: 12행





-- Q9. pdm.pdm_failures에서 설비별 고장 건수를 CTE로 만들고, pdm.pdm_machines와 JOIN하여
--     고장이 15건 이상인 설비의 설비 번호(machineid), 모델(model), 사용 연수(age), 고장 건수를 조회하시오.
--     고장 건수가 많은 순으로 정렬하고, 같으면 설비 번호 순으로 정렬하시오.

WITH machine_failures AS (                   -- 설비별 고장 건수
    SELECT
        machineid,                           -- 설비 번호
        COUNT(*) AS failure_count            -- 고장 건수
    FROM pdm.pdm_failures
    GROUP BY machineid
)
SELECT
    m.machineid,                             -- 설비 번호
    m.model,                                 -- 모델
    m.age,                                   -- 사용 연수
    f.failure_count                          -- 고장 건수
FROM pdm.pdm_machines m
JOIN machine_failures f
  ON m.machineid = f.machineid
WHERE f.failure_count >= 15
ORDER BY f.failure_count DESC, m.machineid;

-- 확인 포인트: 4행
-- ※ 고장 기록을 설비 단위로 먼저 집계한 뒤 JOIN하므로 설비 1대당 1행이 된다.
