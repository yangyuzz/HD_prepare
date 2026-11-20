-- CONNECTION: url=jdbc:postgresql://localhost:5432/hd
-- =========================================================
-- Chapter 05. 과제 정답
-- 내장 함수 기초
-- =========================================================

-- Q1. public.customers에서 customer_id, company_name과 함께
--     회사명을 대문자로 바꾼 값과 회사명의 길이를 출력하시오.
--     customer_id 순으로 5건만 조회하시오.

SELECT
    customer_id,
    company_name,
    UPPER(company_name)  AS 대문자회사명,
    LENGTH(company_name) AS 회사명길이
FROM public.customers
ORDER BY customer_id
LIMIT 5;

-- Q2. 문자열 '  M14860  '의 양쪽 공백을 제거하고,
--     제거 전/후 문자열 길이를 함께 출력하시오.

SELECT
    '  M14860  '               AS 원본,
    LENGTH('  M14860  ')       AS 제거전길이,
    TRIM('  M14860  ')         AS 공백제거,
    LENGTH(TRIM('  M14860  ')) AS 제거후길이;

-- Q3. mfg.tb_ai4i에서 product_id를 다음처럼 분리하시오.
--     - 품질유형코드: 첫 글자
--     - 일련번호: 두 번째 글자부터 끝까지
--     udi, product_id와 함께 10건만 조회하시오.
SELECT
    udi,
    product_id,
    LEFT(product_id, 1)      AS 품질유형코드,
    SUBSTRING(product_id, 2) AS 일련번호
FROM mfg.tb_ai4i
ORDER BY udi
LIMIT 10;

-- Q4. pdm.pdm_telemetry에서 설비 1번(machineid = 1)의 측정값을
--     일시(datetime) 순으로 5건 조회하시오.
--     volt와 rotate는 ROUND로 소수점 첫째 자리까지 표시하시오.
SELECT
    datetime,
    ROUND(volt, 1)   AS volt,
    ROUND(rotate, 1) AS rotate
FROM pdm.pdm_telemetry
WHERE machineid = 1
ORDER BY datetime
LIMIT 5;

-- 확인 포인트: 첫 행은 2015-01-01 06:00:00, volt 176.2, rotate 418.5다.
-- volt와 rotate는 NUMERIC 컬럼이라 ::NUMERIC 변환 없이 ROUND(값, 자릿수)를 쓸 수 있다.

-- Q5. mfg.tb_ai4i의 air_temperature_k와 process_temperature_k 중
--     더 높은 온도를 GREATEST로 구하시오.
--     udi와 두 온도, 더높은온도를 출력하고 10건만 조회하시오.
SELECT
    udi,
    air_temperature_k,
    process_temperature_k,
    GREATEST(air_temperature_k, process_temperature_k) AS 더높은온도
FROM mfg.tb_ai4i
ORDER BY udi
LIMIT 10;

-- Q6. product_type을 CASE로 다음과 같이 표시하시오.
--     H → High, M → Medium, L → Low
--     udi, product_type, 제품품질유형을 10건 조회하시오.
SELECT
    udi,
    product_type,
    CASE product_type
        WHEN 'H' THEN 'High'
        WHEN 'M' THEN 'Medium'
        WHEN 'L' THEN 'Low'
        ELSE '미분류'
    END AS 제품품질유형
FROM mfg.tb_ai4i
ORDER BY udi
LIMIT 10;

-- Q7. public.orders에서 배송 지역(ship_region)이 NULL이면 '미지정'으로 표시하시오.
--     order_id, ship_country, 원본 ship_region, 표시 ship_region을
--     order_id 순으로 10건 조회하시오.
SELECT
    order_id,
    ship_country,
    ship_region                    AS 원본배송지역,
    COALESCE(ship_region, '미지정') AS 표시배송지역
FROM public.orders
ORDER BY order_id
LIMIT 10;

-- Q8. 100을 분모 0으로 나눌 때 오류가 발생하지 않도록
--     NULLIF를 사용한 식을 작성하시오.

SELECT 100 / NULLIF(0, 0) AS 안전한나눗셈;

-- Q9. mfg.tb_ai4i에서 product_id가 M으로 시작하는 행을
--     사용자가 소문자 'm%'를 입력해도 찾을 수 있도록 조회하시오.
--     udi, product_id, product_type을 10건만 출력하시오.
SELECT
    udi,
    product_id,
    product_type
FROM mfg.tb_ai4i
WHERE product_id ILIKE 'm%'
ORDER BY udi
LIMIT 10;

-- Q10. pdm.pdm_failures에서 설비 1번의 고장 일시(datetime)와 고장 부품(failure),
--      그리고 고장 일시에서 7일 뒤의 일시를 함께 조회하시오.
--      고장 일시 순으로 정렬하시오.

SELECT
    datetime,
    failure,
    datetime + INTERVAL '7 days' AS 칠일후
FROM pdm.pdm_failures
WHERE machineid = 1
ORDER BY datetime;

-- 확인 포인트: 7건이 조회된다. 첫 행은 2015-01-05 06:00:00 → 2015-01-12 06:00:00이다.

-- Q11. pdm.pdm_failures에서 datetime을 월의 시작 시각으로 자르고,
--      원본 datetime과 함께 10건만 조회하시오.
--      datetime, machineid 순으로 정렬하시오.
--      힌트: DATE_TRUNC('month', datetime)

SELECT
    datetime,
    DATE_TRUNC('month', datetime) AS 월시작
FROM pdm.pdm_failures
ORDER BY datetime, machineid
LIMIT 10;

-- ※ 같은 일시에 고장 난 설비가 여러 대라 machineid를 함께 정렬해 결과를 고정한다.

-- Q12. 현재 날짜와 시간을 'YYYY년 MM월 DD일 HH24:MI:SS' 형식의
--      문자열로 표시하시오.
SELECT TO_CHAR(
    CURRENT_TIMESTAMP,
    'YYYY년 MM월 DD일 HH24:MI:SS'
) AS 현재일시;

-- Q13. 문자열 '15/03/2025'를 DATE 타입으로 변환하시오.
--      힌트: TO_DATE
SELECT TO_DATE('15/03/2025', 'DD/MM/YYYY') AS 날짜;

-- Q14. 숫자 1234567을 천 단위 구분자가 포함된 문자열로 표시하시오.
--      힌트: TO_CHAR
SELECT TO_CHAR(1234567, 'FM999,999,999') AS 천단위표시;
