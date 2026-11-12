-- =========================================================
-- Chapter 5 확인 문제
-- =========================================================

-- Q1. 'postgresql' 문자열을 대문자로 변환하고,
--     원본 문자열의 길이를 조회하시오.
-- 정답:
SELECT
    'postgresql'  AS 원본,
    upper ('postgresql')  AS 대문자,
    length ('postgresql') AS 길이;

-- Q2. mfg.tb_ai4i 테이블에서 product_id의
--     첫 번째 글자를 추출하시오. (10건만 조회)
-- 정답:
SELECT
    substring(product_id, 1, 1)
FROM mfg.TB_AI4I TAI
LIMIT 10;

-- Q3. || 연산자를 사용하여 '제품-' 문자열과
--     product_id를 연결하시오. (10건만 조회)
-- 정답:
SELECT
   concat('제품-', product_id)
FROM mfg.TB_AI4I TAI 
LIMIT 10;

-- Q4. mfg.tb_ai4i 테이블의 공기 온도(air_temperature_k)를
--     켈빈(K)에서 섭씨(°C)로 변환하시오.
--     결과는 소수 첫째 자리까지 반올림하시오.
--     (10건만 조회)
-- 정답:
SELECT
   round(air_temperature_k - 273.15, 1)
   FROM mfg.TB_AI4I TAI 
   LIMIT 10;

-- Q5. CURRENT_DATE를 사용하여
--     오늘 날짜에서 30일 후를 조회하시오.
-- 정답:
SELECT
    (CURRENT_date + INTERVAL '1month')::date;

-- Q6. public.orders 테이블의 order_date를
--     월 단위로 자른 후 날짜(DATE) 형식으로 조회하시오.
--     (주문번호순으로 10건만 조회)
-- 정답:
SELECT
    date_trunc('month', order_date),
    order_id
FROM public.ORDERS
ORDER BY order_id
LIMIT 10;

-- Q7. CASE를 사용하여 tool_wear_min(공구 마모 시간)을
--     다음 기준에 따라 분류하시오.
--
--     60 미만       → '정상'
--     60 이상 150 미만  → '주의'
--     150 이상 220 미만 → '경고'
--     220 이상      → '교체필요'
--
--     mfg.tb_ai4i 테이블에서 15건만 조회하시오.
--     ※ 교육용 분류 기준이다.
-- 정답:
SELECT
     udi,
     tool_wear_min AS "공구 마모 시간",
     CASE 
     WHEN tool_wear_min < 60 THEN '정상'
     WHEN tool_wear_min >= 60 and tool_wear_min <150 THEN '주의'
     WHEN tool_wear_min >=150 and tool_wear_min <220 THEN '경고'
     ELSE '교체필요'
     END AS "마모 상태"
     FROM mfg.tb_ai4i
     LIMIT 15;
     

-- Q8. public.customers 테이블에서
--     region이 NULL이면 '미지정'으로 대체하여
--     회사명과 지역을 조회하시오. (15건만 조회)
-- 정답:
SELECT 
     company_name,
     city,
    coalesce(region, '미지정') AS region
FROM public.customers
LIMIT 15;


-- Q10. NOW()와 TO_CHAR()를 사용하여
--      현재 날짜를 'YYYY년 MM월' 형식의
--      문자열로 변환하여 조회하시오.
-- 정답:
SELECT
now() AS 현시각,
to_char(now(), 'YYYY년 MM월') AS 형식;