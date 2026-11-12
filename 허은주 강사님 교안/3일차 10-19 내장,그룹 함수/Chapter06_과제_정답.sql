-- CONNECTION: name=postgres 2
-- =========================================================
-- Chapter 06. 과제 정답
-- SQL 집계 함수와 그룹 분석
-- =========================================================

-- 사용 데이터: Northwind(public), AI4I(mfg), Microsoft PdM(pdm)
-- =========================================================


-- Q1. pdm.pdm_machines 테이블에서 다음 값을 한 행으로 조회하시오.
--     전체 설비 수, 모델(model) 종류 수,
--     최소 사용 연수, 최대 사용 연수, 평균 사용 연수(소수점 첫째 자리)

SELECT
    COUNT(*)              AS machine_count,  -- 설비 수
    COUNT(DISTINCT model) AS model_count,    -- 모델 종류 수
    MIN(age)              AS min_age,        -- 최소 사용 연수
    MAX(age)              AS max_age,        -- 최대 사용 연수
    ROUND(AVG(age), 1)    AS avg_age         -- 평균 사용 연수
FROM pdm.pdm_machines;

-- 확인 포인트: 100 | 4 | 0 | 20 | 11.3
-- ※ age는 INTEGER이고 INTEGER의 AVG 결과는 NUMERIC이므로 ::NUMERIC 없이 ROUND(값, 1)을 쓸 수 있다.


-- Q2. pdm.pdm_machines 테이블에서 모델(model)별
--     설비 수와 평균 사용 연수(소수점 첫째 자리)를 조회하시오.
--     모델 이름 순으로 정렬하시오.

SELECT
    model,                                -- 모델
    COUNT(*)           AS machine_count,  -- 설비 수
    ROUND(AVG(age), 1) AS avg_age         -- 평균 사용 연수
FROM pdm.pdm_machines
GROUP BY model
ORDER BY model;

-- 확인 포인트:
--   model1 | 16 | 12.3
--   model2 | 17 | 12.8
--   model3 | 35 | 12.0
--   model4 | 32 |  9.3


-- Q3. pdm.pdm_errors 테이블에서 에러 유형(errorid)별 발생 건수를 조회하시오.
--     발생 건수가 많은 순, 같으면 errorid 순으로 정렬하시오.

SELECT
    errorid,                 -- 에러 유형
    COUNT(*) AS error_count  -- 발생 건수
FROM pdm.pdm_errors
GROUP BY errorid
ORDER BY error_count DESC, errorid;

-- 확인 포인트: error1 1010 / error2 988 / error3 838 / error4 727 / error5 356


-- Q4. pdm.pdm_failures 테이블에서 고장 부품(failure)별로
--     고장 건수와 그 부품이 고장 난 설비 수(중복 제외)를 조회하시오.
--     고장 부품 이름 순으로 정렬하시오.

SELECT
    failure,                                           -- 고장 부품
    COUNT(*)                  AS failure_count,        -- 고장 건수
    COUNT(DISTINCT machineid) AS failed_machine_count  -- 고장 난 설비 수
FROM pdm.pdm_failures
GROUP BY failure
ORDER BY failure;

-- 확인 포인트:
--   comp1 | 192 | 86
--   comp2 | 259 | 92
--   comp3 | 131 | 33
--   comp4 | 179 | 49
-- ※ 같은 설비에서 같은 부품이 여러 번 고장 날 수 있으므로 failure_count가 failed_machine_count보다 크다.


-- Q5. pdm.pdm_failures 테이블에서 설비(machineid)별 고장 건수를 구하고,
--     고장 건수가 13건 이상인 설비만 조회하시오.
--     고장 건수가 많은 순, 같으면 machineid 순으로 정렬하시오.

SELECT
    machineid,                  -- 설비 번호
    COUNT(*)  AS failure_count  -- 고장 건수
FROM pdm.pdm_failures
GROUP BY machineid
HAVING COUNT(*) >= 13
ORDER BY failure_count DESC, machineid;

-- 확인 포인트: 10대가 조회된다.
--   99(19), 98(16), 17(15), 22(15), 37(14), 83(14), 13(13), 16(13), 20(13), 71(13)
-- ※ 집계 결과(COUNT)에 거는 조건이므로 WHERE가 아니라 HAVING을 쓴다.


-- Q6. pdm.pdm_telemetry 테이블에서 설비 1번(machineid = 1)의 측정값을 요약하시오.
--     측정 건수, 평균 전압(volt), 최소 회전 속도(rotate), 최대 진동(vibration)을
--     한 행으로 조회하고, 소수가 나오는 값은 소수점 둘째 자리까지 표시하시오.

SELECT
    COUNT(*)                 AS reading_count,  -- 측정 건수
    ROUND(AVG(volt), 2)      AS avg_volt,       -- 평균 전압
    ROUND(MIN(rotate), 2)    AS min_rotate,     -- 최소 회전 속도
    ROUND(MAX(vibration), 2) AS max_vibration   -- 최대 진동
FROM pdm.pdm_telemetry
WHERE machineid = 1;

-- 확인 포인트: 8761 | 170.83 | 215.62 | 67.63


-- Q7. pdm.pdm_telemetry 테이블에서 설비 1번의 2015년 측정값을 월별로 집계하시오.
--     DATE_TRUNC로 월의 시작 시각을 만들고,
--     월별 측정 건수와 평균 압력(pressure, 소수점 둘째 자리)을 조회하시오.
--     월 순서로 정렬하시오.
--     조건: datetime >= '2015-01-01' AND datetime < '2016-01-01'

SELECT
    DATE_TRUNC('month', datetime) AS month,          -- 월
    COUNT(*)                      AS reading_count,  -- 측정 건수
    ROUND(AVG(pressure), 2)       AS avg_pressure    -- 평균 압력
FROM pdm.pdm_telemetry
WHERE machineid = 1
  AND datetime >= '2015-01-01'
  AND datetime <  '2016-01-01'
GROUP BY DATE_TRUNC('month', datetime)
ORDER BY month;

-- 확인 포인트: 12행이 조회된다.
--   2015-01-01 00:00:00 | 738 | 99.68
--   2015-02-01 00:00:00 | 672 | 100.31
--   ...
--   2015-12-01 00:00:00 | 744 | 101.51
-- ※ 1월은 측정이 1월 1일 06시부터 시작하므로 744건이 아니라 738건이다.
-- ※ GROUP BY month 처럼 별칭으로 써도 PostgreSQL에서는 같은 결과가 나온다.


-- Q8. pdm.pdm_errors 테이블에서 설비 1~5번(machineid <= 5)만 대상으로
--     설비별 전체 에러 건수와 error1~error5 유형별 건수를
--     FILTER를 사용해 한 행에 나란히 조회하시오.
--     machineid 순으로 정렬하시오.

SELECT
    machineid,                                                  -- 설비 번호
    COUNT(*)                                   AS error_count,  -- 전체 에러 건수
    COUNT(*) FILTER (WHERE errorid = 'error1') AS error1,       -- error1 건수
    COUNT(*) FILTER (WHERE errorid = 'error2') AS error2,       -- error2 건수
    COUNT(*) FILTER (WHERE errorid = 'error3') AS error3,       -- error3 건수
    COUNT(*) FILTER (WHERE errorid = 'error4') AS error4,       -- error4 건수
    COUNT(*) FILTER (WHERE errorid = 'error5') AS error5        -- error5 건수
FROM pdm.pdm_errors
WHERE machineid <= 5
GROUP BY machineid
ORDER BY machineid;

-- 확인 포인트:
--   1 | 35 | 11 |  6 | 9 | 5 | 4
--   2 | 28 |  5 | 10 | 5 | 5 | 3
--   3 | 39 | 11 | 10 | 8 | 8 | 2
--   4 | 31 | 10 | 11 | 8 | 2 | 0
--   5 | 38 | 14 |  8 | 7 | 6 | 3
-- ※ 설비 4번은 error5가 없지만 행이 사라지지 않고 COUNT가 0으로 나온다.


-- Q9. public.orders 테이블에서 배송 국가(ship_country)별로
--     전체 주문 건수, 미배송 주문 건수(shipped_date가 NULL),
--     미배송 비율(%)을 조회하시오.
--     미배송 주문이 1건 이상인 국가만 남기고,
--     미배송 비율이 높은 순, 같으면 국가 이름 순으로 정렬하시오.
--     비율은 NULLIF를 사용하고 소수점 둘째 자리까지 표시하시오.

SELECT
    ship_country,                                                         -- 배송 국가
    COUNT(*)                                       AS order_count,        -- 주문 건수
    COUNT(*) FILTER (WHERE shipped_date IS NULL)   AS unshipped_count,    -- 미배송 건수
    ROUND(
        COUNT(*) FILTER (WHERE shipped_date IS NULL)::NUMERIC
        / NULLIF(COUNT(*), 0) * 100,
        2
    )                                              AS unshipped_rate_pct  -- 미배송 비율(%)
FROM public.orders
GROUP BY ship_country
HAVING COUNT(*) FILTER (WHERE shipped_date IS NULL) >= 1
ORDER BY unshipped_rate_pct DESC, ship_country;

-- 확인 포인트: 12개 국가가 조회된다.
--   Argentina   | 16 | 2 | 12.50
--   Venezuela   | 46 | 3 |  6.52
--   Denmark     | 18 | 1 |  5.56
--   Switzerland | 18 | 1 |  5.56
--   ...
--   Germany     | 122 | 2 | 1.64
-- ※ COUNT(shipped_date)는 NULL을 세지 않으므로
--   COUNT(*) - COUNT(shipped_date)로 미배송 건수를 구해도 같다.


-- Q10. public.order_details 테이블에서 할인 여부별로 집계하시오.
--      discount가 0보다 크면 '할인', 아니면 '할인없음'으로 CASE로 구분하고
--      구분별 주문 상세 행 수, 총 수량, 할인 반영 금액 합계(소수점 둘째 자리)를 조회하시오.
--      할인 반영 금액 = unit_price * quantity * (1 - discount)

SELECT
    CASE
        WHEN discount > 0 THEN '할인'
        ELSE '할인없음'
    END             AS discount_status,    -- 할인 여부
    COUNT(*)        AS row_count,          -- 행 수
    SUM(quantity)   AS total_quantity,     -- 총 수량
    ROUND(
        SUM(unit_price * quantity * (1 - discount))::NUMERIC, 2
    )               AS discounted_amount   -- 할인 반영 금액
FROM public.order_details
GROUP BY discount_status
ORDER BY discount_status;

-- 확인 포인트:
--   할인     |  838 | 22718 | 515094.43
--   할인없음 | 1317 | 28599 | 750698.61
-- ※ 실수형 계산 결과를 ROUND(값, 2)로 반올림하려면
--    ::NUMERIC으로 변환한다.
-- ※ GROUP BY에 CASE 식을 그대로 반복해 써도 된다.



-- Q12. 다음 질문에 SQL 주석으로 답하시오.

-- (1) COUNT(*)와 COUNT(컬럼)의 차이는 무엇인가?
--     COUNT(*)는 행 자체를 모두 세고, COUNT(컬럼)은 그 컬럼이 NULL이 아닌 행만 센다.

-- (2) WHERE와 HAVING의 차이는 무엇인가?
--     WHERE는 그룹화 전에 개별 행을 거르고,
--     HAVING은 GROUP BY로 만들어진 그룹 결과를 거른다.
--     그래서 집계 함수 조건은 HAVING에 쓴다.

-- (3) GROUP BY에 일반 컬럼을 쓰는 기본 규칙은 무엇인가?
--     SELECT의 일반 컬럼은 GROUP BY에 포함하고, 나머지는 집계 함수로 계산한다.
--     PostgreSQL은 기본키 기반 기능적 종속 예외가 있지만 초급 실습에서는 명시적으로 작성한다.

-- (4) FILTER는 어떤 행을 제한하는가?
--     FILTER가 붙은 그 집계 함수에 입력되는 행만 조건으로 제한한다.

-- (5) AI4I에서 유형별 고장 플래그 건수를 단순 합산하면 안 되는 이유는 무엇인가?
--     TWF/HDF/PWF/OSF/RNF는 한 관측 행에서 여러 플래그가 동시에 1일 수 있으므로
--     유형별 건수를 합하면 같은 행이 여러 번 포함될 수 있다.

-- (6) 조건에 맞는 행이 하나도 없을 때 COUNT(*)와 SUM(컬럼)은 각각 무엇을 반환하는가?
--     COUNT(*)는 0을 반환하고 SUM(컬럼)은 NULL을 반환한다.
--     0으로 표시하려면 COALESCE(SUM(컬럼), 0)으로 감싼다.
