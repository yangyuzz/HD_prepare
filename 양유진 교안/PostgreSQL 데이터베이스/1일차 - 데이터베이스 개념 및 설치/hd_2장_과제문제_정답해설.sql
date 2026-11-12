-- =============================================================================
-- hd | PostgreSQL 2장 | 과제문제 | 정답해설 (12문항)
-- =============================================================================
-- 실행 환경: PostgreSQL / DBeaver
-- 대상 데이터베이스: hd (먼저 hd_sample_data.sql 적재)
-- 인코딩: UTF-8
--
-- [사용법]
-- 교사용: 문제, 모범답안, 해설을 함께 수록했습니다.
-- DBeaver에서 전체 실행하거나 개별 쿼리를 선택하여 실행할 수 있습니다.
-- [주의] 2장 실습/과제는 CREATE/INSERT/UPDATE/DELETE를 포함합니다.
-- 실습은 번호 순서대로 진행하고, 급여 등 원본 수정 예시는 ROLLBACK으로 되돌립니다.
-- 과제 12는 training_feedback 연습용 테이블을 생성합니다.
-- =============================================================================

-- 실행 중인 데이터베이스가 hd인지 확인 (다른 DB에서는 실행 중단).
DO $hd_database_check$
BEGIN
    IF current_database() <> 'hd' THEN
        RAISE EXCEPTION '이 파일은 hd 데이터베이스에서만 실행하세요. 현재: %', current_database();
    END IF;
END;
$hd_database_check$;

-- -----------------------------------------------------------------------------
-- [과제 01] 급여 조건과 정렬
-- -----------------------------------------------------------------------------
-- 문제: 개발팀(40) 직원 중 급여가 600만 원 이상이고 재직 상태인 사람의 사번·성·이름·급여를 급여 내림차순으로 출력하시오.

-- [모범답안]
SELECT employee_id, last_name, first_name, salary
FROM employees
WHERE department_id = 40
AND salary >= 6000000
AND employment_status = '재직'
ORDER BY salary DESC, employee_id;

-- 해설: WHERE의 다중 조건과 ORDER BY를 종합한다.

-- -----------------------------------------------------------------------------
-- [과제 02] 2025년 이후 입사자
-- -----------------------------------------------------------------------------
-- 문제: 2025년 1월 1일 이후 입사한 재직 직원의 사번·이름·입사일·직무ID를 최근 입사자부터 출력하시오.

-- [모범답안]
SELECT employee_id, last_name, first_name, hire_date, job_id
FROM employees
WHERE hire_date >= DATE '2025-01-01'
AND employment_status = '재직'
ORDER BY hire_date DESC, employee_id;

-- 해설: DATE 리터럴과 정렬을 활용한다.

-- -----------------------------------------------------------------------------
-- [과제 03] 연락처 누락 점검
-- -----------------------------------------------------------------------------
-- 문제: phone_number가 NULL인 직원의 사번·성·이름·부서번호를 출력하시오.

-- [모범답안]
SELECT employee_id, last_name, first_name, department_id
FROM employees
WHERE phone_number IS NULL
ORDER BY employee_id;

-- 해설: 누락된 정보 탐색은 데이터 품질 점검에 활용된다.

-- -----------------------------------------------------------------------------
-- [과제 04] 직무별 재직 인원
-- -----------------------------------------------------------------------------
-- 문제: job_id별 재직 직원 수를 계산하여 인원이 많은 순서로 출력하시오. 출력 열은 job_id, headcount로 설정하시오.

-- [모범답안]
SELECT job_id, COUNT(*) AS headcount
FROM employees
WHERE employment_status = '재직'
GROUP BY job_id
ORDER BY headcount DESC, job_id;

-- 해설: 집계 함수 COUNT와 GROUP BY.

-- -----------------------------------------------------------------------------
-- [과제 05] 개발팀 평균 급여
-- -----------------------------------------------------------------------------
-- 문제: 개발팀(40)의 직원 수와 평균 급여를 계산하시오. 평균 급여는 원 단위로 반올림하시오.

-- [모범답안]
SELECT COUNT(*) AS employee_count,
ROUND(AVG(salary), 0) AS average_salary
FROM employees
WHERE department_id = 40;

-- 해설: AVG는 숫자 평균, ROUND는 반올림에 사용한다.

-- -----------------------------------------------------------------------------
-- [과제 06] 부서와 근무 지역
-- -----------------------------------------------------------------------------
-- 문제: departments와 locations를 JOIN하여 모든 부서의 부서명·도시(city)·연간 예산을 부서번호 순으로 출력하시오.

-- [모범답안]
SELECT d.department_name, l.city, d.annual_budget
FROM departments AS d
JOIN locations AS l
ON d.location_id = l.location_id
ORDER BY d.department_id;

-- 해설: department_id가 아닌 location_id로 두 테이블을 연결한다.

-- -----------------------------------------------------------------------------
-- [과제 07] 직원이 없는 부서까지
-- -----------------------------------------------------------------------------
-- 문제: 모든 부서의 부서번호·부서명·직원 수를 표시하시오. 직원이 없는 부서도 0으로 표시되어야 한다.

-- [모범답안]
SELECT d.department_id, d.department_name,
COUNT(e.employee_id) AS employee_count
FROM departments AS d
LEFT JOIN employees AS e
ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id;

-- 해설: 신사업기획팀(90)은 0명으로 표시되는 것이 정상이다.

-- -----------------------------------------------------------------------------
-- [과제 08] HAVING 조건
-- -----------------------------------------------------------------------------
-- 문제: 재직 직원이 5명 이상인 부서만 조회하시오. 출력은 부서번호·재직 인원으로 하고 인원 수가 많은 순으로 정렬하시오.

-- [모범답안]
SELECT department_id, COUNT(*) AS active_count
FROM employees
WHERE employment_status = '재직'
AND department_id IS NOT NULL
GROUP BY department_id
HAVING COUNT(*) >= 5
ORDER BY active_count DESC, department_id;

-- 해설: WHERE는 그룹화 전 필터, HAVING은 그룹화 후 필터이다.

-- -----------------------------------------------------------------------------
-- [과제 09] 관리자 찾기 [도전]
-- -----------------------------------------------------------------------------
-- 문제: 직원과 관리자의 이름을 한 행에 보여주시오. 직원번호·직원 성·이름·관리자 성·이름을 출력하고 관리자 지정이 있는 직원만 첫 15명 조회하시오.

-- [모범답안]
SELECT e.employee_id, e.last_name AS employee_last_name,
e.first_name AS employee_first_name,
m.last_name AS manager_last_name,
m.first_name AS manager_first_name
FROM employees AS e
JOIN employees AS m
ON e.manager_id = m.employee_id
ORDER BY e.employee_id
LIMIT 15;

-- 해설: employees가 자신을 참조하는 manager_id를 이용한 SELF JOIN이다.

-- -----------------------------------------------------------------------------
-- [과제 10] 프로젝트 참여 인원 [도전]
-- -----------------------------------------------------------------------------
-- 문제: 모든 프로젝트의 프로젝트번호·프로젝트명·참여 인원 수를 출력하시오. 참여자가 없는 프로젝트도 0으로 표시하시오.

-- [모범답안]
SELECT p.project_id, p.project_name,
COUNT(ep.employee_id) AS participant_count
FROM projects AS p
LEFT JOIN employee_projects AS ep
ON p.project_id = ep.project_id
GROUP BY p.project_id, p.project_name
ORDER BY p.project_id;

-- 해설: 프로젝트와 참여 테이블은 project_id로 연결된다.

-- -----------------------------------------------------------------------------
-- [과제 11] 안전한 급여 수정과 취소
-- -----------------------------------------------------------------------------
-- 문제: 직원 123번과 124번의 급여를 각각 10만 원 인상하되, 결과를 조회한 뒤 ROLLBACK하여 원래 급여로 복구하는 SQL을 작성하시오.

-- [모범답안]
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

-- 해설: 원본 직원 데이터에 변경 사항이 남지 않는지 확인한다.

-- -----------------------------------------------------------------------------
-- [과제 12] 자체 테이블 설계 [도전]
-- -----------------------------------------------------------------------------
-- 문제: training_feedback 테이블을 만들고 피드백 번호(PK 자동 생성), 직원번호(FK), 1~5점 점수(CHECK), 의견, 작성일을 저장하시오. 직원 123번에 5점 의견을 INSERT한 후 조회하시오.

-- [모범답안]
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

-- 해설: 본 과제에서 새로 만든 연습용 테이블만 DROP해 재실행 가능하도록 한다.

-- 문서 끝
