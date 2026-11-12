-- =========================================================
-- Chapter 07. 과제 정답
-- SQL JOIN - 여러 테이블 연결하기
-- =========================================================
-- 사용 데이터: Northwind(public), PdM(pdm)
-- =========================================================


-- Q1. 
--     공급업체 국가가 'Japan'인 제품의 제품명, 공급업체명, 공급업체 국가를 조회하시오.
--     제품명 순으로 정렬하시오.
--     연결 기준: products.supplier_id = suppliers.supplier_id

SELECT
    p.product_name,                     -- 제품명
    s.company_name AS supplier_name,    -- 공급업체명
    s.country                           -- 공급업체 국가
FROM products p
INNER JOIN suppliers s
  ON p.supplier_id = s.supplier_id
WHERE s.country = 'Japan'
ORDER BY p.product_name;

-- 확인 포인트: 6행
--   Genen Shouyu, Ikura, Konbu, Longlife Tofu, Mishi Kobe Niku, Tofu
--   공급업체는 Mayumi's, Tokyo Traders 두 곳이다.


-- Q2. 
--     배송업체(shippers.company_name)별 주문 건수를 조회하시오.
--     주문 건수가 많은 순으로 정렬하시오.
--     연결 기준: orders.ship_via = shippers.shipper_id

SELECT
    sh.company_name AS shipper_name,  -- 배송업체명
    COUNT(*)        AS order_count    -- 주문 건수
FROM orders o
INNER JOIN shippers sh
  ON o.ship_via = sh.shipper_id
GROUP BY sh.shipper_id, sh.company_name
ORDER BY order_count DESC;

-- 확인 포인트: 3행
--   United Package 326 / Federal Shipping 255 / Speedy Express 249


-- Q3. Q2와 같은 집계를 LEFT JOIN으로 다시 작성하시오.
--     주문이 한 건도 없는 배송업체도 주문 건수 0으로 나와야 한다.
--     shipper_id 순으로 정렬하시오.
--     Q2와 결과 행 수가 왜 다른지 SQL 주석으로 적으시오.

SELECT
    sh.shipper_id,                        -- 배송업체 번호
    sh.company_name AS shipper_name,      -- 배송업체명
    COUNT(o.order_id) AS order_count      -- 주문 건수
FROM shippers sh
LEFT JOIN orders o
  ON sh.shipper_id = o.ship_via
GROUP BY sh.shipper_id, sh.company_name
ORDER BY sh.shipper_id;

-- 확인 포인트: 6행
--   1 Speedy Express 249 / 2 United Package 326 / 3 Federal Shipping 255
--   4 Alliance Shippers 0 / 5 UPS 0 / 6 DHL 0
-- ※ 행 수가 다른 이유:
--   INNER JOIN은 주문과 연결되는 배송업체만 남기므로 3행이다.
--   LEFT JOIN은 왼쪽 shippers 6곳을 모두 유지하므로 6행이다.
-- ※ COUNT(*)가 아니라 COUNT(o.order_id)를 쓴다.
--   COUNT(*)는 NULL로 채워진 행도 1로 세므로 주문이 없는 배송업체가 1로 나온다.


-- Q4. LEFT JOIN + IS NULL을 사용해 주문을 한 번도 배송하지 않은 배송업체를 조회하시오.

SELECT
    sh.shipper_id,      -- 배송업체 번호
    sh.company_name     -- 배송업체명
FROM shippers sh
LEFT JOIN orders o
  ON sh.shipper_id = o.ship_via
WHERE o.order_id IS NULL
ORDER BY sh.shipper_id;

-- 확인 포인트: 3행 (4 Alliance Shippers, 5 UPS, 6 DHL)


-- Q5. 모든 직원을 유지하면서 1998년 5월 주문만 연결하여
--     직원별 1998년 5월 주문 건수를 조회하시오. 주문이 없으면 0으로 나와야 한다.
--     날짜 조건을 WHERE가 아니라 ON에 작성하시오.
--     employee_id 순으로 정렬하시오.

SELECT
    e.employee_id,                      -- 직원 번호
    e.last_name,                        -- 직원 성
    COUNT(o.order_id) AS order_count    -- 1998년 5월 주문 건수
FROM employees e
LEFT JOIN orders o
  ON e.employee_id = o.employee_id
 AND o.order_date >= DATE '1998-05-01'
 AND o.order_date <  DATE '1998-06-01'
GROUP BY e.employee_id, e.last_name
ORDER BY e.employee_id;

-- 확인 포인트: 9행
--   1 Davolio 5 / 2 Fuller 2 / 3 Leverling 0 / 4 Peacock 2 / 5 Buchanan 0
--   6 Suyama 0 / 7 King 2 / 8 Callahan 3 / 9 Dodsworth 0
-- ※ 날짜 조건을 WHERE에 쓰면 주문이 없는 직원 4명(3, 5, 6, 9번)이 결과에서 사라진다.


-- Q6. employees를 SELF JOIN하여 같은 상사(reports_to)를 둔 직원 쌍을 조회하시오.
--     출력: 상사 번호, 직원 A 번호, 직원 B 번호
--     같은 쌍이 두 번 나오거나 자기 자신과 짝지어지지 않게 하시오.
--     상사 번호, 직원 A 번호, 직원 B 번호 순으로 정렬하시오.

SELECT
    a.reports_to,                       -- 상사 번호
    a.employee_id AS employee_a_id,     -- 직원 A 번호
    b.employee_id AS employee_b_id      -- 직원 B 번호
FROM employees a
JOIN employees b
  ON a.reports_to = b.reports_to
 AND a.employee_id < b.employee_id
ORDER BY a.reports_to, employee_a_id, employee_b_id;

-- 확인 포인트: 13쌍
--   상사 2번 아래 직원 5명(1, 3, 4, 5, 8번) → 10쌍
--   상사 5번 아래 직원 3명(6, 7, 9번)       → 3쌍
-- ※ a.employee_id < b.employee_id 가 없으면 자기 자신(A-A)과 역순 중복(A-B, B-A)이 생긴다.
-- ※ reports_to가 NULL인 2번 직원은 = 비교를 만족하지 않으므로 짝에 들어가지 않는다.


-- Q7. categories → products → order_details를 연결하여
--     카테고리별 할인 반영 금액 합계를 조회하시오. (소수점 둘째 자리)
--     할인 반영 금액 = unit_price * quantity * (1 - discount)  ← order_details의 컬럼 사용
--     금액이 큰 순으로 정렬하시오.

SELECT
    cat.category_name,                                                         -- 카테고리명
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::NUMERIC, 2)
                                                     AS discounted_amount      -- 할인 반영 금액
FROM categories cat
JOIN products p
  ON cat.category_id = p.category_id
JOIN order_details od
  ON p.product_id = od.product_id
GROUP BY cat.category_id, cat.category_name
ORDER BY discounted_amount DESC;

-- 확인 포인트: 8행
--   1위 Beverages 267868.18 / 2위 Dairy Products 234507.28 / ... / 8위 Grains/Cereals 95744.59
-- ※ products에도 unit_price가 있으므로 od.unit_price처럼 테이블 별칭을 꼭 붙인다.
--   p.unit_price는 현재 단가, od.unit_price는 주문 당시 단가다.


-- Q8. EXCEPT를 사용해 공급업체는 있지만 고객은 없는 국가를 조회하시오.
--     국가 이름 순으로 정렬하시오.

SELECT country FROM suppliers
EXCEPT
SELECT country FROM customers
ORDER BY country;

-- 확인 포인트: 4개국 (Australia, Japan, Netherlands, Singapore)


-- Q9. pdm.pdm_maint와 pdm.pdm_machines를 machineid로 JOIN하여
--     설비 모델(model)별 정비 건수를 조회하시오. 모델 이름 순으로 정렬하시오.

SELECT
    m.model,                        -- 모델
    COUNT(*) AS maint_count         -- 정비 건수
FROM pdm.pdm_maint mt
JOIN pdm.pdm_machines m
  ON mt.machineid = m.machineid
GROUP BY m.model
ORDER BY m.model;

-- 확인 포인트: model1 522 / model2 553 / model3 1172 / model4 1039 (합계 3286)
-- ※ pdm_machines는 설비당 1행이므로 JOIN 후에도 정비 건수 3286이 그대로 유지된다.


-- Q11. pdm.pdm_errors와 pdm.pdm_machines를 JOIN하여
--      사용 연수(age)가 15 이상인 설비의 에러 유형(errorid)별 건수를 조회하시오.
--      errorid 순으로 정렬하시오.

SELECT
    e.errorid,                       -- 에러 유형
    COUNT(*) AS error_count          -- 에러 건수
FROM pdm.pdm_errors e
JOIN pdm.pdm_machines m
  ON e.machineid = m.machineid
WHERE m.age >= 15
GROUP BY e.errorid
ORDER BY e.errorid;

-- 확인 포인트: error1 305 / error2 343 / error3 275 / error4 266 / error5 195


-- Q12. 다음 질문에 SQL 주석으로 답하시오.

-- (1) INNER JOIN과 LEFT JOIN의 핵심 차이는?
--     INNER JOIN은 양쪽에서 조건에 매칭되는 행만 남기고,
--     LEFT JOIN은 왼쪽 행을 모두 유지하며 오른쪽에 매칭이 없으면 NULL을 채운다.

-- (2) LEFT JOIN에서 오른쪽 테이블 조건을 WHERE에 쓰면 어떤 일이 생길 수 있는가?
--     NULL로 채워진 매칭되지 않은 행이 WHERE 조건을 만족하지 못해 제거되므로
--     의도와 달리 INNER JOIN처럼 동작할 수 있다.

-- (3) CROSS JOIN은 무엇인가?
--     왼쪽의 모든 행과 오른쪽의 모든 행을 조합하는 카테시안 곱이다.
--     결과 행 수는 두 테이블 행 수의 곱이다.

-- (4) 명시적 JOIN에서 ON을 빼면 자동으로 CROSS JOIN이 되는가?
--     아니다. PostgreSQL의 INNER/LEFT/RIGHT/FULL JOIN은
--     ON 같은 JOIN 조건이 필요하며 단순 누락은 문법 오류다.

-- (5) JOIN 전에 Grain을 확인해야 하는 이유는?
--     테이블마다 한 행의 의미가 다르기 때문이다.
--     Grain을 확인하지 않으면 정상적인 1:N 증가와 잘못된 다대다 행 증식을 구분하기 어렵다.
