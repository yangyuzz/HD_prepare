
-- =========================================================
-- Chapter 04 확인 문제
-- =========================================================

-- Q1. products 테이블에서 제품명과 단가만 조회하시오. (10건)
-- 정답:
select product_name, unit_price from products;


-- Q2. 독일(Germany) 고객을 조회하시오.
-- 정답:
select * from customers where country = 'Germany';


-- Q3. 단가가 100 이상인 제품을 조회하시오.
-- 정답:
select * from products where unit_price >= 100;

-- Q4. 도시가 London, Paris, Madrid 중 하나인 고객을 조회하시오.
-- 정답:
select * from customers where city in ('London', 'Paris', 'Madrid');

-- Q5. 회사명에 'Market'이 포함된 고객을 대소문자 구분 없이 조회하시오.
-- 정답:
select * from customers where company_name like '%Market%';

-- Q6. 지역(region)이 NULL인 고객 수를 조회하시오.
-- 정답:
select count(*) from customers where region is null;


-- Q7. 고객들이 있는 국가 목록을 중복 없이 조회하시오.
-- 정답:
select distinct country from customers;

-- Q8. 1997년에 주문된 건수를 조회하시오.
-- 정답:
select * from orders limit 5;
select * from orders where order_date between '1997-01-01' and '1997-12-31';

-- Q9. 제품을 단가 낮은 순으로 정렬해서 3페이지(페이지당 10건)를 조회하시오.
-- 정답:
select product_id, unit_price from products order by unit_price limit 10 offset 0;
select product_id, unit_price from products order by unit_price limit 10 offset 10;
select product_id, unit_price from products order by unit_price limit 10 offset 20;

-- ※ 단가가 같은 제품이 있으므로 product_id를 함께 정렬해 페이지 결과를 고정한다.


-- Q10. 단가가 30 이상이면서 재고가 20 이상인 제품을 조회하시오.
-- 정답:
select * from products where unit_price > 30 and units_in_stock >20;