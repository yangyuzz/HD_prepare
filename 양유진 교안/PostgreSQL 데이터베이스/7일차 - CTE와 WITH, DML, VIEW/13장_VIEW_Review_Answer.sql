-- 13장 VIEW 기초 | 복습 | 교사용 정답·해설
-- PostgreSQL / DBeaver / hd 데이터베이스
-- 기존 hd 샘플 데이터가 적재되어 있어야 합니다.
-- 실행 전 hd에 연결되었는지 확인하세요. 학생별 DB를 사용하세요.
-- 각 문항의 SQL을 선택하여 순서대로 실행하세요. 원본 employees, departments는 수정하지 않습니다.
-- 재실행 시 이전에 만든 연습 VIEW만 삭제하고 시작하세요(아래 주석 참조).

SELECT current_database(); -- hd 확인
CREATE SCHEMA IF NOT EXISTS view_lab;
-- DROP VIEW IF EXISTS view_lab.vw_review_employee; -- 재실행할 때만 주석 해제

-- [복습 01] 직원 급여 정보 VIEW 생성
-- public.employees에서 employee_id, first_name, salary를 조회하는
-- view_lab.vw_review_employee VIEW를 생성하세요.
CREATE VIEW view_lab.vw_review_employee AS
SELECT employee_id, first_name, salary
FROM public.employees;
-- 해설: 자주 쓰는 SELECT 정의를 이름 붙여 저장합니다.


-- [복습 02] VIEW 활용
-- 01에서 만든 VIEW를 이용하여 급여가 높은 직원 5명을 조회하세요.
-- employee_id, first_name, salary 출력. 급여 내림차순, 동점은 직원번호 오름차순.
-- 기대 결과 (5행 중 처음 2행)
-- employee_id | first_name | salary
-- 100         | 민수       | 13300000
-- 101         | 서연       |  8200000
SELECT employee_id, first_name, salary
FROM view_lab.vw_review_employee
ORDER BY salary DESC, employee_id
LIMIT 5;
-- 기대 결과: 100 민수 / 101 서연 / 102 지훈 / 104 현우 / 106 도윤
-- 해설: VIEW에도 ORDER BY와 LIMIT을 적용할 수 있습니다.


-- [복습 03] VIEW 삭제 및 개념 확인
-- 01에서 생성한 VIEW만 삭제하세요. 원본 employees는 삭제하지 마세요.
-- 추가 질문: CTE(WITH)와 VIEW의 이름 사용 범위는 어떻게 다른가요?
DROP VIEW view_lab.vw_review_employee;
-- 해설: VIEW 객체만 삭제되며 원본은 유지됩니다.
-- CTE는 현재 SQL 문 안에서만, VIEW는 삭제하기 전까지 다른 SQL 문에서도 사용합니다.
