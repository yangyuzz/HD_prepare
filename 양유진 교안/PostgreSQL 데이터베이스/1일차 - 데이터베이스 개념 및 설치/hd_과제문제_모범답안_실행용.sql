-- hd 데이터베이스 / PostgreSQL·DBeaver
-- 실행 전 연결 대상이 hd인지 확인합니다.
-- 과제문제 01~12 모범 SQL
-- 원본 employees를 수정하는 코드는 반드시 ROLLBACK으로 복구합니다.

DO $$ BEGIN IF current_database() <> 'hd' THEN RAISE EXCEPTION '현재 연결 DB는 hd가 아닙니다.'; END IF; END $$;

-- 과제 01 | 급여 조건과 정렬
-- 개발팀(40) 직원 중 급여가 600만 원 이상이고 재직 상태인 사람의 사번·성·이름·급여를 급여 내림차순으로 출력하시오.
SELECT employee_id, last_name, first_name, salary
FROM employees
WHERE department_id = 40
  AND salary >= 6000000
  AND employment_status = '재직'
ORDER BY salary DESC, employee_id;

-- 과제 02 | 2025년 이후 입사자
-- 2025년 1월 1일 이후 입사한 재직 직원의 사번·이름·입사일·직무ID를 최근 입사자부터 출력하시오.
SELECT employee_id, last_name, first_name, hire_date, job_id
FROM employees
WHERE hire_date >= DATE '2025-01-01'
  AND employment_status = '재직'
ORDER BY hire_date DESC, employee_id;

-- 과제 03 | 연락처 누락 점검
-- phone_number가 NULL인 직원의 사번·성·이름·부서번호를 출력하시오.
SELECT employee_id, last_name, first_name, department_id
FROM employees
WHERE phone_number IS NULL
ORDER BY employee_id;

-- 과제 04 | 직무별 재직 인원
-- job_id별 재직 직원 수를 계산하여 인원이 많은 순서로 출력하시오. 출력 열은 job_id, headcount로 설정하시오.
SELECT job_id, COUNT(*) AS headcount
FROM employees
WHERE employment_status = '재직'
GROUP BY job_id
ORDER BY headcount DESC, job_id;

-- 과제 05 | 개발팀 평균 급여
-- 개발팀(40)의 직원 수와 평균 급여를 계산하시오. 평균 급여는 원 단위로 반올림하시오.
SELECT COUNT(*) AS employee_count,
       ROUND(AVG(salary), 0) AS average_salary
FROM employees
WHERE department_id = 40;

-- 과제 06 | 부서와 근무 지역
-- departments와 locations를 JOIN하여 모든 부서의 부서명·도시(city)·연간 예산을 부서번호 순으로 출력하시오.
SELECT d.department_name, l.city, d.annual_budget
FROM departments AS d
JOIN locations AS l
  ON d.location_id = l.location_id
ORDER BY d.department_id;

-- 과제 07 | 직원이 없는 부서까지
-- 모든 부서의 부서번호·부서명·직원 수를 표시하시오. 직원이 없는 부서도 0으로 표시되어야 한다.
SELECT d.department_id, d.department_name,
       COUNT(e.employee_id) AS employee_count
FROM departments AS d
LEFT JOIN employees AS e
  ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id;

-- 과제 08 | HAVING 조건
-- 재직 직원이 5명 이상인 부서만 조회하시오. 출력은 부서번호·재직 인원으로 하고 인원 수가 많은 순으로 정렬하시오.
SELECT department_id, COUNT(*) AS active_count
FROM employees
WHERE employment_status = '재직'
  AND department_id IS NOT NULL
GROUP BY department_id
HAVING COUNT(*) >= 5
ORDER BY active_count DESC, department_id;

-- 과제 09 | 관리자 찾기 [도전]
-- 직원과 관리자의 이름을 한 행에 보여주시오. 직원번호·직원 성·이름·관리자 성·이름을 출력하고 관리자 지정이 있는 직원만 첫 15명 조회하시오.
SELECT e.employee_id, e.last_name AS employee_last_name,
       e.first_name AS employee_first_name,
       m.last_name AS manager_last_name,
       m.first_name AS manager_first_name
FROM employees AS e
JOIN employees AS m
  ON e.manager_id = m.employee_id
ORDER BY e.employee_id
LIMIT 15;

-- 과제 10 | 프로젝트 참여 인원 [도전]
-- 모든 프로젝트의 프로젝트번호·프로젝트명·참여 인원 수를 출력하시오. 참여자가 없는 프로젝트도 0으로 표시하시오.
SELECT p.project_id, p.project_name,
       COUNT(ep.employee_id) AS participant_count
FROM projects AS p
LEFT JOIN employee_projects AS ep
  ON p.project_id = ep.project_id
GROUP BY p.project_id, p.project_name
ORDER BY p.project_id;

-- 과제 11 | 안전한 급여 수정과 취소
-- 직원 123번과 124번의 급여를 각각 10만 원 인상하되, 결과를 조회한 뒤 ROLLBACK하여 원래 급여로 복구하는 SQL을 작성하시오.
BEGIN;
UPDATE employees
SET salary = salary + 100000
WHERE employee_id IN (123, 124);
SELECT employee_id, salary
FROM employees
WHERE employee_id IN (123, 124)
ORDER BY employee_id;
ROLLBACK;
SELECT employee_id, salary
FROM employees
WHERE employee_id IN (123, 124)
ORDER BY employee_id;

-- 과제 12 | 자체 테이블 설계 [도전]
-- training_feedback 테이블을 만들고 피드백 번호(PK 자동 생성), 직원번호(FK), 1~5점 점수(CHECK), 의견, 작성일을 저장하시오. 직원 123번에 5점 의견을 INSERT한 후 조회하시오.
DROP TABLE IF EXISTS training_feedback;
CREATE TABLE training_feedback (
    feedback_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES employees(employee_id),
    score INTEGER NOT NULL CHECK (score BETWEEN 1 AND 5),
    comments VARCHAR(200),
    created_at DATE NOT NULL DEFAULT CURRENT_DATE
);
INSERT INTO training_feedback (employee_id, score, comments)
VALUES (123, 5, 'SQL 학습 참여도 우수');
SELECT * FROM training_feedback ORDER BY feedback_id;
