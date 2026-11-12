-- hd 데이터베이스 / PostgreSQL·DBeaver
-- 실행 전 연결 대상이 hd인지 확인합니다.
-- 실습문제 01~12 모범 SQL
-- 원본 employees를 수정하는 코드는 반드시 ROLLBACK으로 복구합니다.

DO $$ BEGIN IF current_database() <> 'hd' THEN RAISE EXCEPTION '현재 연결 DB는 hd가 아닙니다.'; END IF; END $$;

-- 실습 01 | 전체 직원 수 확인
-- employees 테이블에 저장된 직원이 몇 명인지 COUNT(*)로 조회하시오.
SELECT COUNT(*) AS employee_count
FROM employees;

-- 실습 02 | 직원 기본 정보 조회
-- 직원번호, 성, 이름, 부서번호, 급여를 직원번호 오름차순으로 정렬해 앞의 10명만 조회하시오.
SELECT employee_id, last_name, first_name, department_id, salary
FROM employees
ORDER BY employee_id ASC
LIMIT 10;

-- 실습 03 | 급여 조건 검색
-- 재직 중이며 급여가 600만 원 이상인 직원의 직원번호·성·이름·급여를 급여가 높은 순서로 조회하시오.
SELECT employee_id, last_name, first_name, salary
FROM employees
WHERE employment_status = '재직'
  AND salary >= 6000000
ORDER BY salary DESC, employee_id;

-- 실습 04 | 입사일 필터
-- 2024년 1월 1일 이상 2026년 1월 1일 미만 입사자의 직원번호·입사일을 입사일 순으로 조회하시오.
SELECT employee_id, hire_date
FROM employees
WHERE hire_date >= DATE '2024-01-01'
  AND hire_date < DATE '2026-01-01'
ORDER BY hire_date, employee_id;

-- 실습 05 | NULL 검색
-- 전화번호가 입력되지 않은 직원의 직원번호·성·이름·전화번호를 조회하시오.
SELECT employee_id, last_name, first_name, phone_number
FROM employees
WHERE phone_number IS NULL
ORDER BY employee_id;

-- 실습 06 | 개발팀 직원 검색
-- 개발팀의 부서번호는 40이다. 개발팀 소속이면서 직무 ID가 DEV인 직원의 성·이름·급여를 조회하시오.
SELECT last_name, first_name, salary
FROM employees
WHERE department_id = 40 AND job_id = 'DEV'
ORDER BY employee_id;

-- 실습 07 | 중복 없이 상태 조회
-- employees에 등록된 고용상태(employment_status)를 중복 없이 출력하시오.
SELECT DISTINCT employment_status
FROM employees
ORDER BY employment_status;

-- 실습 08 | 부서명 함께 조회
-- 직원번호·성·이름·부서명을 출력하시오. 소속 부서가 없는 직원도 표시하며 직원번호 오름차순으로 15명만 출력하시오.
SELECT e.employee_id, e.last_name, e.first_name, d.department_name
FROM employees AS e
LEFT JOIN departments AS d
  ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 15;

-- 실습 09 | 부서별 인원 계산
-- 모든 부서의 부서번호·부서명·직원 수를 출력하시오. 직원이 없는 부서도 0명으로 표시하시오.
SELECT d.department_id, d.department_name,
       COUNT(e.employee_id) AS employee_count
FROM departments AS d
LEFT JOIN employees AS e
  ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id;

-- 실습 10 | 연습 테이블 만들기
-- 교안 47~48페이지를 참고하여 employees_practice 테이블을 생성하시오. 사번 자동 생성 PK, 부서 FK, 급여 0 이상 CHECK를 포함하시오. 재실행 시 연습 테이블만 초기화하시오.
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

-- 실습 11 | 직원 2명 INSERT
-- employees_practice에 김민준(개발팀 40, 급여 450만 원, 2026-11-01 입사), 이서진(데이터분석팀 50, 급여 420만 원, 2026-11-02 입사)을 INSERT하고 확인하시오.
INSERT INTO employees_practice
    (first_name, last_name, department_id, salary, hire_date)
VALUES
    ('민준', '김', 40, 4500000, DATE '2026-11-01'),
    ('서진', '이', 50, 4200000, DATE '2026-11-02');
SELECT * FROM employees_practice ORDER BY employee_id;

-- 실습 12 | UPDATE·DELETE·ROLLBACK
-- BEGIN으로 트랜잭션을 시작하고 김민준의 급여를 470만 원으로 변경한 뒤 이서진을 삭제하시오. SELECT로 확인하고 ROLLBACK해 실습 11의 데이터를 보존하시오.
BEGIN;
UPDATE employees_practice
SET salary = 4700000
WHERE first_name = '민준' AND last_name = '김';
DELETE FROM employees_practice
WHERE first_name = '서진' AND last_name = '이';
SELECT * FROM employees_practice ORDER BY employee_id;
ROLLBACK;
SELECT * FROM employees_practice ORDER BY employee_id;
