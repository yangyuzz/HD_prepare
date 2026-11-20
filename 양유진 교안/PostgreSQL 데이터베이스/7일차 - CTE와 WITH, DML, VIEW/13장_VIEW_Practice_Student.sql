-- 13장 VIEW 기초 | 수업 실습 | 학생용
-- PostgreSQL / DBeaver / hd 데이터베이스
-- 기존 hd 샘플 데이터가 적재되어 있어야 합니다.
-- 실행 전 hd에 연결되었는지 확인하세요. 학생별 DB를 사용하세요.
-- 각 문항의 SQL을 선택하여 순서대로 실행하세요. 원본 employees, departments는 수정하지 않습니다.
-- 재실행 시 이전에 만든 연습 VIEW만 삭제하고 시작하세요(아래 주석 참조).

SELECT current_database(); -- hd 확인
CREATE SCHEMA IF NOT EXISTS view_lab;
-- DROP VIEW IF EXISTS view_lab.vw_employee_info; -- 재실행할 때만 주석 해제

-- [실습 01] 직원·부서 정보를 연결한 VIEW 생성 (교안 6p)
-- JOIN을 매번 작성하지 않도록 SELECT 문에 이름을 붙입니다.
CREATE VIEW view_lab.vw_employee_info AS
SELECT e.employee_id, e.first_name,
       d.department_name, e.salary
FROM public.employees e
LEFT JOIN public.departments d
  ON e.department_id = d.department_id;

-- [실습 02] VIEW 조회하기 (교안 7p)
-- 직원번호 순으로 처음 4명의 직원 정보를 조회합니다.
SELECT employee_id, first_name, department_name, salary
FROM view_lab.vw_employee_info
ORDER BY employee_id
LIMIT 4;
-- 기대 결과 (4행)
-- employee_id | first_name | department_name | salary
-- 100         | 민수       | 경영지원팀      | 13300000
-- 101         | 서연       | 경영지원팀      |  8200000
-- 102         | 지훈       | 인사팀          |  8000000
-- 103         | 수빈       | 재무팀          |  7800000

-- [실습 03] VIEW를 재사용하여 개발팀 직원만 조회하기 (교안 7p)
-- 빈칸에 조건 검색 구문을 채운 뒤, 아래 SQL 4줄의 주석을 해제하여 실행하세요.
-- SELECT employee_id, first_name, salary
-- FROM view_lab.vw_employee_info
-- ____ department_name = '개발팀'
-- ORDER BY employee_id;
-- 기대 결과 (총 16행 중 처음 2행)
-- employee_id | first_name | salary
-- 104         | 현우       | 8000000
-- 123         | 시우       | 5900000

-- [실습 04] VIEW 삭제하기 (교안 8p)
-- 실습 01~03을 모두 완료한 뒤 실행합니다.
DROP VIEW view_lab.vw_employee_info;

-- 원본 테이블이 남아 있는지 확인
SELECT COUNT(*) AS employee_count FROM public.employees;
SELECT COUNT(*) AS department_count FROM public.departments;
-- 기대 결과: 직원 69명, 부서 9개. 원본 데이터는 그대로입니다.

-- 개념 확인 (교안 4~5, 9p)
-- VIEW는 SELECT 정의를 저장합니다. 일반 VIEW는 조회 결과를 별도 저장하지 않습니다.
-- CTE는 한 SQL 문 안에서만 사용하고, VIEW는 다른 SQL 문에서도 재사용합니다.
