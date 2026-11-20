-- =========================================================
-- Chapter 05. 과제
-- 내장 함수 기초
-- =========================================================
-- 대상 데이터베이스: hd
-- 사용 데이터: Northwind(public), AI4I(mfg), PdM(pdm)
--
-- 작성 원칙
-- 1. 각 문제 아래에 SQL을 작성한다.
-- 2. 5장에서 배운 함수와 표현식 중심으로 해결한다.

-- =========================================================


-- Q1. public.customers에서 customer_id, company_name과 함께
--     회사명을 대문자로 바꾼 값과 회사명의 길이를 출력하시오.
--     customer_id 순으로 5건만 조회하시오.
SELECT
     customer_id,
     upper(company_name) AS 회사명,
     length(company_name) AS 회사명길이
     FROM public.CUSTOMERS
     ORDER BY CUSTOMER_ID 
     LIMIT 5;

-- Q2. 문자열 '  M14860  '의 양쪽 공백을 제거하고,
--     제거 전/후 문자열 길이를 함께 출력하시오.
SELECT
    trim ('  M14860  '),
    length('  M14860  '),
    length(trim ('  M14860  '));


-- Q3. mfg.tb_ai4i에서 product_id를 다음처럼 분리하시오.
--     - 품질유형코드: 첫 글자
--     - 일련번호: 두 번째 글자부터 끝까지
--     udi, product_id와 함께 10건만 조회하시오.
SELECT
    product_id,
    udi,
    substring(product_id, 1, 1) AS "품질유형코드",
    substring(product_id, 2) AS "일련번호"
FROM mfg.TB_AI4I TAI
LIMIT 10;


-- Q4. pdm.pdm_telemetry에서 설비 1번(machineid = 1)의 측정값을
--     일시(datetime) 순으로 5건 조회하시오.
--     volt와 rotate는 ROUND로 소수점 첫째 자리까지 표시하시오.
SELECT
     datetime,
     machineid,
     round(volt, 1),
     round(rotate, 1)
FROM pdm.PDM_TELEMETRY PT
WHERE machineid = 1
ORDER BY PT.DATETIME
LIMIT 5;

-- Q5. mfg.tb_ai4i의 air_temperature_k와 process_temperature_k 중
--     더 높은 온도를 GREATEST로 구하시오.
--     udi와 두 온도, 더높은온도를 출력하고 10건만 조회하시오.
SELECT 
    udi,
    air_temperature_k,
    process_temperature_k,
    greatest(air_temperature_k, process_temperature_k) a
    FROM mfg.TB_AI4I TAI 
    LIMIT 10;


-- Q6. product_type을 CASE로 다음과 같이 표시하시오.
--     H → High, M → Medium, L → Low
--     udi, product_type, 제품품질유형을 10건 조회하시오.
SELECT 
     udi,
     product_type,
     CASE 
     WHEN product_type = 'H' THEN 'HIGH'
     WHEN product_type = 'M' THEN 'Medium'
     WHEN product_type = 'L' THEN 'Low'
     END
     FROM mfg.tb_ai4i
     LIMIT 10;
     

-- Q7. public.orders에서 배송 지역(ship_region)이 NULL이면 '미지정'으로 표시하시오.
--     order_id, ship_country, 원본 ship_region, 표시 ship_region을
--     order_id 순으로 10건 조회하시오.
SELECT
    ORDER_id,
    ship_country,
    ship_region,
    coalesce(ship_region, '미지정') AS "표시 region"
FROM public.orders
ORDER BY ORDER_ID
LIMIT 10;

-- Q8. 100을 분모 0으로 나눌 때 오류가 발생하지 않도록
--     NULLIF를 사용한 식을 작성하시오.
SELECT 
   100 / nullif(0, 0);


-- Q9. mfg.tb_ai4i에서 product_id가 M으로 시작하는 행을
--     사용자가 소문자 'm%'를 입력해도 찾을 수 있도록 조회하시오.
--     udi, product_id, product_type을 10건만 출력하시오.
SELECT 
    udi,
    product_id,
    product_type
FROM mfg.TB_AI4I TAI 
WHERE product_id ILIKE 'm%' 
LIMIT 10;

-- Q10. pdm.pdm_failures에서 설비 1번의 고장 일시(datetime)와 고장 부품(failure),
--      그리고 고장 일시에서 7일 뒤의 일시를 함께 조회하시오.
--      고장 일시 순으로 정렬하시오.
SELECT 
     datetime "고장 일시",
     failure "고장 부품",
     datetime + INTERVAL '7days' AS "고장 일시 7일 뒤"
FROM pdm.PDM_FAILURES PF 
WHERE machineid = 1
ORDER BY datetime;

-- Q11. pdm.pdm_failures에서 datetime을 월의 시작 시각으로 자르고,
--      원본 datetime과 함께 10건만 조회하시오.
--      datetime, machineid 순으로 정렬하시오.
--      힌트: DATE_TRUNC('month', datetime)
SELECT * FROM pdm.PDM_FAILURES PF;
SELECT 
    TO_char( date_trunc('month', datetime), 'YYYY-MM-DD') AS "월단위",
    TO_char( datetime, 'YYYY-MM-DD'),
    machineid
FROM pdm.PDM_FAILURES PF 
LIMIT 10;

-- Q12. 현재 날짜와 시간을 'YYYY년 MM월 DD일 HH24:MI:SS' 형식의
--      문자열로 표시하시오.
SELECT 
    to_char(now(), 'YYYY년 MM월 DD일 HH24:MI:SS');


-- Q13. 문자열 '15/03/2025'를 DATE 타입으로 변환하시오.
--      힌트: TO_DATE
SELECT
   to_date('15/03/2025', 'DD/MM/YYYY');


-- Q14. 숫자 1234567을 천 단위 구분자가 포함된 문자열로 표시하시오.
--      힌트: TO_CHAR
SELECT 
    TO_char(1234567, 'FM9,999,999');