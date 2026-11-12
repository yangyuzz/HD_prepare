-- =========================================================
-- Chapter 06 확인 문제
-- =========================================================

-- Q1. products 테이블에서 전체 제품 수와 판매 중단(discontinued = 1) 제품 수를
--     FILTER를 사용해 한 행으로 조회하시오.
-- 정답:
SELECT 
    count(*) "전체 제품 수",
    count(*) FILTER (WHERE discontinued = 1) "판매 중단 제품 수"
    FROM products;

-- Q2. orders 테이블에서 배송 국가(ship_country)의 고유 개수를 조회하시오.
-- 정답:
SELECT count (DISTINCT ship_country)
FROM orders;

-- Q3. orders 테이블에서 전체 주문 수, ship_region 값이 있는 주문 수,
--     ship_region이 NULL인 주문 수를 한 번에 조회하시오.
-- 정답:
SELECT 
     count (*),
     count (ship_region) AS "값이 있는 주문 수",
     count (CASE WHEN ship_region IS NULL THEN 1 end) AS "null인 주문 수"
FROM orders;

-- Q4. order_details 테이블에서 전체 판매 수량 합계와 평균 수량(소수점 첫째 자리)을 조회하시오.
-- 정답:
SELECT 
    sum (quantity) "전체 판매 수량",
    round (avg(quantity)::numeric, 1) AS "평균 수량"
    FROM order_details;

-- Q5. products 테이블에서 카테고리별 재고 수량 합계를 조회하시오.
--     재고 합계가 많은 순으로 정렬하시오.
-- 정답:
SELECT 
    category_id,
    sum (units_in_stock) AS "재고 수량 합계"
FROM PRODUCTS P 
GROUP BY CATEGORY_ID 
ORDER BY sum(units_in_stock) DESC;


-- Q6. orders 테이블에서 직원(employee_id)별 주문 수를 구하고
--     주문이 100건 이상인 직원만 조회하시오. 주문 수가 많은 순으로 정렬하시오.
-- 정답:
SELECT * FROM orders;
SELECT 
    employee_id "직원 아이디",
    count (*) AS "주문 수"
    FROM ORDERS O 
    GROUP BY (O.EMPLOYEE_ID )
    HAVING (count (*) >= 100)
    ORDER BY count (*) DESC;


-- Q7. mfg.tb_ai4i에서 제품 품질 유형별 최소 토크와 최대 토크를 조회하시오.
-- 정답:
SELECT 
     product_type AS "제품 품질 유형",
     min (torque_nm),
     max (torque_nm)
FROM mfg.TB_AI4I TAI
GROUP BY product_type;

     
-- Q8. mfg.tb_ai4i에서 tool_wear_min이 200 이상인 행만 대상으로
--     제품 품질 유형별 관측 건수와 고장 관측 건수를 조회하시오.
-- 정답:
SELECT 
    product_type,
    count (TAI.PRODUCT_TYPE) AS "관측 건수",
    count (*) FILTER (WHERE machine_failure = 1) AS "고장 관측 건수"
FROM mfg.TB_AI4I TAI
WHERE (tool_wear_min >= 200)
GROUP BY product_type;


-- Q9. mfg.tb_ai4i에서 고장 행과 정상 행의 평균 회전 속도(rpm)를
--     FILTER를 사용해 한 행으로 비교하시오. 소수점 없이 반올림하시오.
-- 정답:
SELECT  
    round(avg(rotational_speed_rpm) FILTER (WHERE machine_failure = 0)::NUMERIC, 0) AS "정상 행 평균 회전 속도",
    round(avg(rotational_speed_rpm) FILTER (WHERE machine_failure = 1)::NUMERIC, 0) AS "고장 행 평균 회전 속도"
FROM mfg.TB_AI4I TAI;


-- Q10. mfg.tb_ai4i에서 tool_wear_min이 300보다 큰 행을 대상으로
--      COUNT(*)와 SUM(machine_failure)를 조회하고,
--      SUM 결과를 COALESCE로 0으로 표시하는 컬럼도 추가하시오.
-- 정답:
select * FROM mfg.tb_ai4i;
SELECT  
    count(*),
    sum(machine_failure),
    COALESCE (sum(machine_failure),0)
    FROM mfg.TB_AI4I TAI 