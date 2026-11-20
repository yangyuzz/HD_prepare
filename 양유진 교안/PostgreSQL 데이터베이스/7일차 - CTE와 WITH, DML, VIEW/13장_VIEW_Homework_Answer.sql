-- 13장 VIEW 기초 | 과제 | 교사용 정답·해설
-- PostgreSQL / DBeaver / hd 데이터베이스
-- 기존 hd 샘플 데이터가 적재되어 있어야 합니다.
-- 실행 전 hd에 연결되었는지 확인하세요. 학생별 DB를 사용하세요.
-- 각 문항의 SQL을 선택하여 순서대로 실행하세요. 원본 employees, departments는 수정하지 않습니다.
-- 재실행 시 이전에 만든 연습 VIEW만 삭제하고 시작하세요(아래 주석 참조).

SELECT current_database(); -- hd 확인
CREATE SCHEMA IF NOT EXISTS view_lab;
-- DROP VIEW IF EXISTS view_lab.vw_homework_dept; -- 재실행할 때만 주석 해제

-- [과제 01] 부서별 급여 요약 VIEW 생성
-- public.employees를 사용하여 부서별 직원 수와 평균 급여를 구하는
-- view_lab.vw_homework_dept VIEW를 생성하세요.
-- 출력 컬럼: department_id, staff_count, avg_salary (평균은 소수점 0자리 반올림)
-- 부서번호가 NULL인 직원은 제외하세요. GROUP BY를 사용하세요.
-- 기대 결과: 8행(부서 8개).
CREATE VIEW view_lab.vw_homework_dept AS
SELECT department_id, COUNT(*) AS staff_count,
       ROUND(AVG(salary), 0) AS avg_salary
FROM public.employees
WHERE department_id IS NOT NULL
GROUP BY department_id;
-- 해설: 한 번 정의하면 부서별 집계 SQL을 반복 작성하지 않아도 됩니다.


-- [과제 02] VIEW에서 조건 검색 및 정렬
-- 01에서 만든 VIEW에서 직원 수가 10명 이상인 부서만 조회하세요.
-- 직원 수 내림차순, 동점이면 부서번호 오름차순으로 정렬하세요.
-- 기대 결과 (2행)
-- department_id | staff_count | avg_salary
-- 40            | 16          | 5743750
-- 50            | 11          | 5381818
SELECT department_id, staff_count, avg_salary
FROM view_lab.vw_homework_dept
WHERE staff_count >= 10
ORDER BY staff_count DESC, department_id;
-- 해설: VIEW의 집계 결과를 일반 테이블처럼 조건 검색합니다.


-- [과제 03] VIEW 삭제
-- 01에서 생성한 VIEW만 삭제하고, 원본 직원 수를 확인하세요.
-- 기대 결과: 원본 직원 수 69명.
DROP VIEW view_lab.vw_homework_dept;
SELECT COUNT(*) AS employee_count FROM public.employees;
-- 해설: VIEW를 삭제해도 원본 직원 69명은 유지됩니다.
