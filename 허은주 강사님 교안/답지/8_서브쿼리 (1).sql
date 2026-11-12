-- CONNECTION: url=jdbc:postgresql://localhost:5432/hd
-- =========================================================
-- Chapter 08. SQL 서브쿼리(Subquery)
-- =========================================================
-- 사용 데이터: Northwind(public), AI4I(mfg.tb_ai4i)
-- =========================================================


-- =========================================================
-- [개념] 서브쿼리란?
-- =========================================================
-- SQL 문 안에 포함된 또 다른 SELECT 문이다.
--
-- 구조:
--   SELECT *                          ← 메인쿼리(외부쿼리)
--   FROM products
--   WHERE unit_price > (
--       SELECT AVG(unit_price)        ← 서브쿼리(내부쿼리)
--       FROM products
--   );
--
-- ※ 왜 필요한가?
--   "평균보다 비싼 제품"을 찾으려면 먼저 평균을 알아야 한다.
--   서브쿼리를 쓰면 두 단계를 한 번에 처리할 수 있다.
--
-- =========================================================


-- [실습 1]평균보다 비싼 제품-  서브쿼리 없이 두 단계로 처리
-- 문제: products 테이블에서 전체 제품의 평균 단가를 소수 둘째 자리까지
--       반올림하여 먼저 구하시오.
--       구한 평균값을 직접 WHERE 조건에 입력하여 평균보다 비싼 제품의
--       제품명과 단가를 조회하고, 단가 내림차순으로 정렬하시오.

-- 1단계: 평균 계산
SELECT ROUND(AVG(unit_price)::NUMERIC, 2) AS avg_unit_price   -- 평균 단가
FROM products;
-- 결과: 28.83

-- 2단계: 그 값을 조건으로 사용
SELECT product_name, unit_price
FROM products
WHERE unit_price > 28.83
ORDER BY unit_price DESC;

-- ※ 문제점
--   데이터가 바뀌면 평균값도 다시 계산해서 수정해야 한다.


-- [실습 2] 서브쿼리로 한 번에 처리
-- 문제: products 테이블에서 전체 제품의 평균 단가를 서브쿼리로 계산하여
--       평균보다 비싼 제품의 제품명과 단가를 조회하시오.
--       단가 내림차순으로 정렬하시오.

SELECT product_name, unit_price
FROM products
WHERE unit_price > (
	SELECT AVG(unit_price)
	FROM products
)
ORDER BY unit_price DESC;



-- [실습 3] 서브쿼리의 논리적 흐름 이해
-- 문제: 안쪽 서브쿼리를 따로 실행해서 어떤 값을 바깥 쿼리가 사용하는지 확인하시오.

-- 서브쿼리만 실행
SELECT AVG(unit_price) FROM products;

-- ※ 이 값이 메인쿼리의 조건 자리에 대입된다고 생각하면 된다.
--   WHERE unit_price > 28.8338...


-- =========================================================
-- [개념] 서브쿼리 사용 위치
-- =========================================================
-- 서브쿼리는 여러 위치에 쓸 수 있다.
--
-- 위치        명칭                용도
-- ----------  ------------------  ----------------------
-- WHERE       조건 서브쿼리        조건 비교
-- FROM        파생 테이블          임시 테이블처럼 사용
-- SELECT      스칼라 서브쿼리      컬럼처럼 값 하나 반환
-- HAVING      그룹 조건 서브쿼리   그룹 필터링
--
-- =========================================================


-- =========================================================
-- [개념] 단일 행 서브쿼리
-- =========================================================
-- 서브쿼리가 값을 하나만 반환하는 경우다.
-- 일반 비교 연산자(=, >, <, >=, <=, <>)를 쓸 수 있다.
--
-- 값이 하나만 나오는 경우:
--   MAX(), MIN(), AVG(), SUM(), COUNT() 등 집계 함수
--   LIMIT 1 을 쓴 조회
-- =========================================================


-- [실습 4] 최대값 비교
-- 문제: 가장 비싼 제품을 조회하시오.
select max(unit_price ) from products;

select *
from products 
where unit_price = (
	select max(unit_price ) from products
)



-- [실습 6] 평균 초과 데이터 조회
-- 문제: mfg.tb_ai4i 테이블에서 전체 관측값의 평균 공구 마모 시간보다
--       공구 마모 시간이 큰 관측값을 조회하시오.
--       udi, product_type, tool_wear_min을 출력하고,
--       공구 마모 시간 내림차순, udi 오름차순으로 정렬하여 10건 조회하시오.
--

select AVG(tool_wear_min)
from mfg.tb_ai4i;


select  udi, product_type, tool_wear_min
from mfg.tb_ai4i
where tool_wear_min > (
	select AVG(tool_wear_min)
	from mfg.tb_ai4i
)
order by tool_wear_min desc, udi
limit 10;


-- =========================================================
-- [개념] 다중 행 서브쿼리
-- =========================================================
-- 서브쿼리가 여러 값을 반환하는 경우다.
--
-- ※ 중요: = 연산자를 쓸 수 없다
--   = 는 값 하나와만 비교할 수 있다.
--
-- 사용 가능한 연산자:
--   IN         목록에 포함됨
--   NOT IN     목록에 포함 안 됨
--   ANY/SOME   하나라도 만족
--   ALL        모두 만족
--   EXISTS     존재함
--   NOT EXISTS 존재하지 않음
-- =========================================================


-- [실습 7] 다중 행에 = 사용 오류
-- 문제: 아래 SQL이 왜 오류가 나는지 확인하시오.

-- 오류 발생 코드
-- SELECT *
-- FROM customers
-- WHERE customer_id = (
--     SELECT customer_id FROM orders
-- );

-- ※ 오류 메시지:
--   ERROR: more than one row returned by a subquery used as an expression
--   (한국어 Windows: 오류: 표현식에 사용된 서브쿼리 결과가 하나 이상의 행을 리턴했습니다)
-- ※ 이유: 서브쿼리가 830개 값을 반환하는데 = 는 하나만 비교 가능하다.


-- [실습 8] IN 사용
-- 문제: 주문 이력이 있는 고객을 조회하시오.

select *
from customers
where customer_id  in (
	select customer_id from orders
);


-- [실습 10] 해결 방법 1 - NULL 제외
-- 문제: 주문 이력이 없는 고객을 NOT IN으로 안전하게 조회하시오.

select *
from customers
where customer_id not in (
	select customer_id 
	from orders
	where customer_id is not null
);



-- =========================================================
-- [개념] EXISTS
-- =========================================================
-- EXISTS는 값을 비교하지 않는다.
-- 조건을 만족하는 행이 존재하는지만 확인한다.
--
-- 의미:
--   서브쿼리가 1행 이상을 반환하면 TRUE, 0행이면 FALSE다.
--   NOT EXISTS는 서브쿼리가 0행을 반환하면 TRUE다.
--   관련 행이 존재하지 않는 경우를 찾을 때 사용한다.
--   상관 EXISTS에서는 바깥 행의 값이 안쪽 조건에 전달된다.
--
-- ※ SELECT 1 을 쓰는 이유
--   일반적인 EXISTS에서는 SELECT 목록의 실제 값이 중요하지 않다.
--   SELECT 1은 "값이 아니라 존재 여부만 본다"는 의도를 드러내는 관례다.
---- =========================================================

-- 주문 이력이 없는 고객
-- [실습 11] 해결 방법 2 - NOT EXISTS (권장)
-- 문제: 같은 결과를 NOT EXISTS로 조회하시오.

select *
from customers c 
where not exists (
	select 1
	from orders o
	where o.customer_id  = c.customer_id 
);



-- [실습 12] 해결 방법 3 - LEFT JOIN
-- 문제: 같은 결과를 LEFT JOIN으로 조회하시오.

select *
from customers c 
left join orders o on c.customer_id  = o.customer_id 
where o.order_id  is null;



-- [실습 13] EXISTS 기본
-- 문제: 주문 이력이 있는 고객을 EXISTS로 조회하시오.

select *
from customers c 
where exists (
	select 1
	from orders o
	where o.customer_id  = c.customer_id 
);




-- [실습 14] SELECT 1 vs SELECT * 확인
-- 문제: 무엇을 SELECT하든 결과가 같은지 확인하시오.

SELECT COUNT(*) AS select_1        -- SELECT 1 사용
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

SELECT COUNT(*) AS select_star     -- SELECT * 사용
FROM customers c
WHERE EXISTS (SELECT * FROM orders o WHERE o.customer_id = c.customer_id);

SELECT COUNT(*) AS select_column   -- SELECT 컬럼 사용
FROM customers c
WHERE EXISTS (SELECT order_id FROM orders o WHERE o.customer_id = c.customer_id);

-- ※ 모두 89건으로 동일하다.


-- [실습 15] NOT EXISTS 활용
-- 문제: 한 번도 판매되지 않은 제품을 조회하시오.


select *
from products p 
where not exists (
	select *
	from order_details od 
	where od.product_id  = p.product_id 
);





-- =========================================================
-- [개념] IN vs EXISTS 비교
-- =========================================================

-- ※ 선택 기준
--   값 집합 포함 여부 → IN
--   관련 행 존재 여부 → EXISTS
--   관련 행 부재 여부 → NOT EXISTS를 고려

-- =========================================================


-- =========================================================
-- [개념] 상관 서브쿼리(Correlated Subquery)
-- =========================================================
-- 서브쿼리가 메인쿼리의 값을 참조하는 경우다.
--
-- 구분          비상관 서브쿼리           상관 서브쿼리
-- ------------  ------------------------  ------------------------------
-- 바깥 값 참조  없음                       있음
-- 단독 실행     가능                      바깥 참조 때문에 불가능
--
--   상관 서브쿼리는 바깥 행 값에 따라 결과가 달라진다는 의미다.
-- =========================================================


-- [실습 16] 상관 서브쿼리 기본
-- 문제: 같은 카테고리 평균 단가보다 비싼 제품을 조회하시오.

select *
from products p 
where p.unit_price >(
	select avg(p2.unit_price )
	from products p2
	where p2.category_id  = p.category_id 
)






-- =========================================================
-- [개념] FROM 절 서브쿼리 (파생 테이블)
-- =========================================================
-- FROM 절에 서브쿼리를 쓰면 임시 테이블처럼 동작한다.
-- 파생 테이블(Derived Table) 또는 인라인 뷰라고 부른다.
--
-- ※ 별칭 규칙 (버전에 따라 다르다)
--   SQL 표준                   : FROM의 sub-SELECT 별칭 요구
--   PostgreSQL 15 이하         : 별칭 필수
--   PostgreSQL 16 이상/18 포함 : 별칭 생략 가능
--
--   그래도 별칭 작성을 권장한다.
--   1. t.컬럼처럼 한정 참조할 수 있어 의미가 명확하다
--   2. 여러 FROM 항목을 구분하기 쉽다
--   3. SQL 표준 및 이식성을 고려하기 좋다
--
-- ※ 사용 상황
--   집계 결과를 다시 필터링하거나 계산할 때 쓴다.
-- =========================================================



-- [실습 19] 파생 테이블 기본
-- 문제: products 테이블에서 카테고리별 평균 단가를 소수 둘째 자리까지
--       반올림해 구하고, 이를 파생 테이블로 사용하시오.
--       반올림한 평균 단가가 30 이상인 카테고리의 번호와 평균 단가를
--       조회하고 평균 단가 내림차순으로 정렬하시오.


select category_id, round(avg(p.unit_price )::numeric,2)
from products p 
group by p.category_id ;



select t.category_id , t.avg_price 
from (
	select category_id, round(avg(p.unit_price )::numeric,2) avg_price
	from products p 
	group by p.category_id 
)t
where t.avg_price >= 30
order by t.avg_price desc;

-- =========================================================
-- [개념] SELECT 절 서브쿼리 (스칼라 서브쿼리)
-- =========================================================
-- SELECT 절에 서브쿼리를 넣어 컬럼처럼 사용한다.
--
-- ※ 확인하기: 스칼라 서브쿼리 조건
--   1개 컬럼, 최대 1행을 반환해야 한다.
--   1행    → 그 값을 사용
--   0행    → NULL
--   2행 이상 → 오류
--

-- =========================================================


-- [실습 21] 스칼라 서브쿼리 - 전체 평균 표시
-- 문제: products 테이블에서 제품명, 단가, 전체 제품의 평균 단가,
--       각 제품 단가와 전체 평균의 차이(제품 단가 - 전체 평균)를 조회하시오.
--       SELECT 절에 스칼라 서브쿼리를 사용하고,
--       평균 단가와 차이는 소수 둘째 자리까지 반올림하시오.
--       단가 내림차순, 제품번호 오름차순으로 정렬하여 10건 조회하시오.


select p.product_name , p.unit_price ,
	  (select round(avg(unit_price)::numeric, 2)  from products ) avg_price,
	 round(( p.unit_price - (select avg(unit_price) from products ))::numeric ,2) diff
from products p 
order by p.unit_price desc, p.product_id 
limit 10;



-- [실습 22] 상관 스칼라 서브쿼리
-- 문제: customers 테이블에서 고객 코드, 회사명, 각 고객의 주문 건수를
--       SELECT 절의 상관 스칼라 서브쿼리로 조회하시오.
--       주문 건수 내림차순, 고객 코드 오름차순으로 정렬하여 10명만 조회하시오.

select 
	c.customer_id ,
	c.company_name ,
	(
		select count(*)
		from orders o
		where o.customer_id  = c.customer_id 
	) order_count
from customers c 
order by order_count desc, c.customer_id 
limit 10;





-- =========================================================
-- [개념] ANY와 ALL 
-- =========================================================
-- ANY(또는 SOME) : 서브쿼리 결과 중 하나라도 만족하면 참
-- ALL            : 서브쿼리 결과 모두를 만족해야 참
--
-- 직관적 대응 (서브쿼리에 NULL이 없고 결과가 비어 있지 않은 단순 예):
--   > ANY  →  최소값보다 크면 참
--   > ALL  →  최대값보다 커야 참
--   < ANY  →  최대값보다 작으면 참
--   < ALL  →  최소값보다 작아야 참
--   = ANY  →  IN과 같은 의미
--

-- =========================================================


-- [실습 24] ANY 사용
-- 문제: products 테이블에서 카테고리 1에 속한 제품 중
--       적어도 하나의 제품보다 단가가 높은 제품을 조회하시오.
--       제품명과 단가를 출력하고 단가 오름차순, 제품번호 오름차순으로
--       정렬하여 10건만 조회하시오. (> ANY 사용)

SELECT
    product_name,   -- 제품명
    unit_price      -- 단가
FROM products
WHERE unit_price > ANY (
    SELECT unit_price FROM products WHERE category_id = 1
)
ORDER BY unit_price, product_id   -- 단가가 같으면 제품 번호 순
LIMIT 10;



-- [실습 26] ALL 사용
-- 문제: 카테고리 1의 모든 제품보다 싼 제품을 조회하시오.

SELECT
    product_name,   -- 제품명
    unit_price      -- 단가
FROM products
WHERE unit_price < ALL (
    SELECT unit_price FROM products WHERE category_id = 1
)
ORDER BY unit_price DESC, product_id;



-- =========================================================
-- [개념] JOIN과 서브쿼리 비교
-- =========================================================
-- 항목        JOIN                         서브쿼리
-- ----------  ---------------------------  ---------------------------
-- 주 용도     테이블 행 관계 연결            조건 판단, 집계값 비교, 중간 결과
-- 결과 컬럼   연결한 FROM 항목 컬럼 활용 쉬움 위치에 따라 스칼라/FROM 결과 사용 가능
-- 가독성      관계 연결 중심일 때 좋음        단계적 조건/계산에 좋음
--
-- ※ 선택 기준
--   양쪽 컬럼이 다 필요 → JOIN
--   존재 여부만 확인    → EXISTS
--   집계값과 비교       → 서브쿼리
--   단계별 논리 전개    → FROM 절 서브쿼리(파생 테이블)
--

-- =========================================================


-- [실습 27] 같은 결과를 두 방법으로
-- 문제: orders에 주문 이력이 있는 고객의 고객 코드와 회사명을
--       1) IN 서브쿼리, 2) JOIN + DISTINCT 방식으로 각각 조회하시오.
--       고객 코드 오름차순으로 정렬하고 각 방식에서 5건만 출력하여 비교하시오.

-- 서브쿼리 방식
SELECT customer_id, company_name
FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders)
ORDER BY customer_id
LIMIT 5;

-- JOIN 방식
SELECT DISTINCT c.customer_id, c.company_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id
LIMIT 5;

-- ※ JOIN 방식은 DISTINCT가 필요하다.
--   서브쿼리 방식은 행이 늘어나지 않으므로 불필요하다.


-- =========================================================
-- [실습 28~33] 분석 예제
-- =========================================================

-- [실습 28] 평균 초과 주문
-- 문제: orders와 order_details를 JOIN하여 주문별 할인 전 금액을 합산하시오.
--       전체 주문의 평균 할인 전 금액을 서브쿼리로 계산하고,
--       평균보다 주문 금액이 큰 주문만 조회하시오.
--       주문번호, 주문일자, 할인 전 주문 금액(소수 둘째 자리 반올림)을
--       출력하고 금액 내림차순, 주문번호 오름차순으로 정렬하시오.


SELECT
    o.order_id,     -- 주문 번호
    o.order_date,   -- 주문 일자
    ROUND(SUM(od.unit_price * od.quantity)::NUMERIC, 2) AS order_amount   -- 할인 전 주문 금액
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id, o.order_date
HAVING SUM(od.unit_price * od.quantity) > (
    -- 전체 주문의 평균 금액
    SELECT AVG(t.order_amount)
    FROM (
        SELECT SUM(unit_price * quantity) AS order_amount   -- 할인 전 주문 금액
        FROM order_details
        GROUP BY order_id
    ) AS t
)
ORDER BY order_amount DESC, o.order_id;


-- [실습 29] 카테고리 최고가 제품
-- 문제: 각 카테고리에서 가장 비싼 제품을 조회하시오.

select p.category_id, p.product_name , p.unit_price 
from products p 
where p.unit_price =(
	select max(p2.unit_price)
	from products p2 
	where p2.category_id  = p.category_id 
)
order by category_id ;


-- [실습 32] PdM - 고장 이력이 있는 설비 찾기
-- 문제: 설비 마스터 중 고장 이력이 존재하는 설비를 EXISTS로 조회하시오.
select pm.machineid ,pm.model , pm.age 
from pdm.pdm_machines pm 
where exists (
	select 1
	from pdm.pdm_failures pf 
	where pf.machineid  = pm.machineid 
)


-- [실습 33] 서브쿼리 중첩 (가독성 문제 확인)
-- 문제: 고객 1인당 평균 주문 건수가 10건 이상인 나라는 몇 개인지 조회하시오.
--       아래 3단계를 SELECT 문 3개로 중첩하여 작성하고, 중첩 구조의 가독성을 확인하시오.
--       1단계: orders에서 고객별 주문 건수를 구한다.
--       2단계: 1단계 결과를 customers와 조인해 나라별 고객 1인당 평균 주문 건수를 구한다.
--       3단계: 2단계 결과에서 평균이 10건 이상인 나라의 개수를 센다.

SELECT
    COUNT(*) AS country_count                      -- 나라 수
FROM (
    SELECT
        c.country,                                 -- 국가
        ROUND(AVG(t1.order_count), 1) AS avg_orders -- 고객 1인당 평균 주문 건수
    FROM (
        SELECT
            customer_id,                           -- 고객 코드
            COUNT(*) AS order_count                -- 고객별 주문 건수
        FROM orders
        GROUP BY customer_id
    ) AS t1
    JOIN customers AS c
      ON c.customer_id = t1.customer_id            -- 고객 코드로 연결
    GROUP BY c.country
) AS t2
WHERE avg_orders >= 10;

--
-- ※ 확인 방법
--   가장 안쪽 SELECT부터 하나씩 따로 실행해 단계별 결과를 확인한다.




-- =========================================================
-- [개념] 서브쿼리 주의사항 정리
-- =========================================================
-- 1. 다중 행에 = 사용 금지
--    → IN, ANY, ALL을 쓴다
--
-- 2. NOT IN의 NULL 확인
--    → NOT EXISTS 또는 LEFT JOIN + IS NULL 권장
--
-- 3. 상관 서브쿼리 성능
--    → 바깥 행 값에 의존하므로 비용이 커질 수 있고 실행계획 확인
--
-- 4. FROM 절 서브쿼리 별칭
--    → PostgreSQL 16부터 생략 가능하지만 작성을 권장
--
-- 5. 스칼라 서브쿼리
--    → 1개 컬럼, 최대 1행
--    → 0행이면 NULL, 2행 이상이면 오류
--
-- 6. 중첩을 깊게 만들지 않는다
--    → 3단계 이상이면 가독성이 크게 나빠진다
-- =========================================================

-- =========================================================
-- Chapter 08 확인 문제
-- =========================================================

-- Q1. products 테이블에서 전체 제품의 평균 단가보다 단가가 높은
--     제품의 제품명과 단가를 서브쿼리로 조회하시오.
--     단가 내림차순으로 정렬하고 동점이면 제품번호 오름차순으로 정렬하시오.
-- 정답:


-- Q2. 가장 비싼 제품을 조회하시오.
-- 정답:


-- Q3. 주문 이력이 있는 고객을 IN으로 조회하시오.
-- 정답:


-- Q4. 주문 이력이 없는 고객을 NOT EXISTS로 조회하시오.
-- 정답:



-- Q6. 같은 카테고리 평균보다 비싼 제품을 조회하시오. (상관 서브쿼리)
-- 정답:


-- Q7. products 테이블에서 카테고리별 평균 단가를 소수 둘째 자리까지
--     반올림하고, 그 결과를 파생 테이블로 사용하시오.
--     반올림한 평균 단가가 30 이상인 카테고리 번호와 평균 단가를
--     조회하고 평균 단가 내림차순으로 정렬하시오.
-- 정답:



-- Q8. customers 테이블에서 고객 회사명과 각 고객의 주문 건수를
--     SELECT 절의 상관 스칼라 서브쿼리로 조회하시오.
--     주문 건수 내림차순, 고객 코드 오름차순으로 정렬하고
--     상위 10명만 조회하시오.
-- 정답:


-- Q9. 한 번도 판매되지 않은 제품을 조회하시오.
-- 정답:



-- Q10. mfg.tb_ai4i 테이블에서 전체 관측값의 평균 공구 마모 시간보다
--      공구 마모 시간이 큰 관측값을 서브쿼리로 조회하시오.
--      udi, product_type, tool_wear_min을 출력하고,
--      공구 마모 시간 내림차순, udi 오름차순으로 정렬하여 10건만 조회하시오.
-- 정답:
