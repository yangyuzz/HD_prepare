-- =============================================================================
-- hd | PostgreSQL 2장 | 실습문제 | 정답해설 (12문항)
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
-- 실습 10~12는 employees_practice 연습용 테이블을 사용합니다.
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
-- [실습 01] 전체 직원 수 확인
-- -----------------------------------------------------------------------------
-- 문제: employees 테이블에 저장된 직원이 몇 명인지 COUNT(*)로 조회하시오.

-- [모범답안]
SELECT COUNT(*) AS employee_count
FROM employees;

-- 해설: 전체 69건. COUNT(*)는 조건에 맞는 행의 개수를 반환한다.

-- -----------------------------------------------------------------------------
-- [실습 02] 직원 기본 정보 조회
-- -----------------------------------------------------------------------------
-- 문제: 직원번호, 성, 이름, 부서번호, 급여를 직원번호 오름차순으로 정렬해 앞의 10명만 조회하시오.

-- [모범답안]
SELECT employee_id, last_name, first_name, department_id, salary
FROM employees
ORDER BY employee_id ASC
LIMIT 10;

-- 해설: ORDER BY + LIMIT으로 결과 행의 순서와 개수를 조절한다.

-- -----------------------------------------------------------------------------
-- [실습 03] 급여 조건 검색
-- -----------------------------------------------------------------------------
-- 문제: 재직 중이며 급여가 600만 원 이상인 직원의 직원번호·성·이름·급여를 급여가 높은 순서로 조회하시오.

-- [모범답안]
SELECT employee_id, last_name, first_name, salary
FROM employees
WHERE employment_status = '재직'
AND salary >= 6000000
ORDER BY salary DESC, employee_id;

-- 해설: AND로 두 조건을 동시에 충족하는 행만 필터링한다.

-- -----------------------------------------------------------------------------
-- [실습 04] 입사일 필터
-- -----------------------------------------------------------------------------
-- 문제: 2024년 1월 1일 이상 2026년 1월 1일 미만 입사자의 직원번호·입사일을 입사일 순으로 조회하시오.

-- [모범답안]
SELECT employee_id, hire_date
FROM employees
WHERE hire_date >= DATE '2024-01-01'
AND hire_date < DATE '2026-01-01'
ORDER BY hire_date, employee_id;

-- 해설: 날짜 비교에는 PostgreSQL DATE 리터럴을 사용한다.

-- -----------------------------------------------------------------------------
-- [실습 05] NULL 검색
-- -----------------------------------------------------------------------------
-- 문제: 전화번호가 입력되지 않은 직원의 직원번호·성·이름·전화번호를 조회하시오.

-- [모범답안]
SELECT employee_id, last_name, first_name, phone_number
FROM employees
WHERE phone_number IS NULL
ORDER BY employee_id;

-- 해설: NULL은 = NULL이 아니라 IS NULL로 비교해야 한다.

-- -----------------------------------------------------------------------------
-- [실습 06] 개발팀 직원 검색
-- -----------------------------------------------------------------------------
-- 문제: 개발팀의 부서번호는 40이다. 개발팀 소속이면서 직무 ID가 DEV인 직원의 성·이름·급여를 조회하시오.

-- [모범답안]
SELECT last_name, first_name, salary
FROM employees
WHERE department_id = 40 AND job_id = 'DEV'
ORDER BY employee_id;

-- 해설: 부서 ID와 직무 ID를 동시에 조건으로 사용한다.

-- -----------------------------------------------------------------------------
-- [실습 07] 중복 없이 상태 조회
-- -----------------------------------------------------------------------------
-- 문제: employees에 등록된 고용상태(employment_status)를 중복 없이 출력하시오.

-- [모범답안]
SELECT DISTINCT employment_status
FROM employees
ORDER BY employment_status;

-- 해설: DISTINCT는 중복 행을 제거한다.

-- -----------------------------------------------------------------------------
-- [실습 08] 부서명 함께 조회
-- -----------------------------------------------------------------------------
-- 문제: 직원번호·성·이름·부서명을 출력하시오. 소속 부서가 없는 직원도 표시하며 직원번호 오름차순으로 15명만 출력하시오.

-- [모범답안]
SELECT e.employee_id, e.last_name, e.first_name, d.department_name
FROM employees AS e
LEFT JOIN departments AS d
ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 15;

-- 해설: LEFT JOIN은 부서가 NULL인 직원도 누락하지 않는다.

-- -----------------------------------------------------------------------------
-- [실습 09] 부서별 인원 계산
-- -----------------------------------------------------------------------------
-- 문제: 모든 부서의 부서번호·부서명·직원 수를 출력하시오. 직원이 없는 부서도 0명으로 표시하시오.

-- [모범답안]
SELECT d.department_id, d.department_name,
COUNT(e.employee_id) AS employee_count
FROM departments AS d
LEFT JOIN employees AS e
ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id;

-- 해설: COUNT(e.employee_id)는 LEFT JOIN에서 실제 직원이 없는 부서의 0을 정확히 계산한다.

-- -----------------------------------------------------------------------------
-- [실습 10] 연습 테이블 만들기
-- -----------------------------------------------------------------------------
-- 문제: 교안 47~48페이지를 참고하여 employees_practice 테이블을 생성하시오. 사번 자동 생성 PK, 부서 FK, 급여 0 이상 CHECK를 포함하시오. 재실행 시 연습 테이블만 초기화하시오.

-- [모범답안]
DROP TABLE IF EXISTS employees_practice;
CREATE TABLE employees_practice (
employee_id INTEGER GENERATED ALWAYS AS IDENTITY,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(20) NOT NULL,
department_id INTEGER REFERENCES departments(department_id),
salary INTEGER NOT NULL,
hire_date DATE NOT NULL,
CONSTRAINT pk_emp_practice PRIMARY KEY (employee_id),
CONSTRAINT ck_emp_practice_salary CHECK (salary >= 0)
);

-- 해설: 기존 employees는 삭제하지 않는다. DROP 대상은 실습 전용 테이블뿐이다.

-- -----------------------------------------------------------------------------
-- [실습 11] 직원 2명 INSERT
-- -----------------------------------------------------------------------------
-- 문제: employees_practice에 김민준(개발팀 40, 급여 450만 원, 2026-11-01 입사), 이서진(데이터분석팀 50, 급여 420만 원, 2026-11-02 입사)을 INSERT하고 확인하시오.

-- [모범답안]
INSERT INTO employees_practice
(first_name, last_name, department_id, salary, hire_date)
VALUES
('민준', '김', 40, 4500000, DATE '2026-11-01'),
('서진', '이', 50, 4200000, DATE '2026-11-02');
SELECT * FROM employees_practice ORDER BY employee_id;

-- 해설: 자동 생성 사번은 INSERT 문에 명시하지 않는다.

-- -----------------------------------------------------------------------------
-- [실습 12] UPDATE·DELETE·ROLLBACK
-- -----------------------------------------------------------------------------
-- 문제: BEGIN으로 트랜잭션을 시작하고 김민준의 급여를 470만 원으로 변경한 뒤 이서진을 삭제하시오. SELECT로 확인하고 ROLLBACK해 실습 11의 데이터를 보존하시오.

-- [모범답안]
BEGIN;
UPDATE employees_practice
SET salary = 4700000
WHERE first_name = '민준' AND last_name = '김';
DELETE FROM employees_practice
WHERE first_name = '서진' AND last_name = '이';
SELECT * FROM employees_practice ORDER BY employee_id;
ROLLBACK;
SELECT * FROM employees_practice ORDER BY employee_id;

-- 해설: ROLLBACK 전후 결과를 비교한다. 최종적으로 처음 INSERT한 두 행이 유지된다.

-- [추가 주의] 실습 10의 DROP TABLE은 employees_practice에만 적용됩니다.
-- 원본 employees, departments 등 샘플 테이블에는 적용되지 않습니다.
-- 문서 끝
