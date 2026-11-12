-- =============================================================================
-- 2장 교안 46~55쪽 SQL 예제 / PostgreSQL + DBeaver / hd
-- =============================================================================
-- 사전 준비: hd_sample_data.sql로 샘플 데이터(7개 테이블) 적재
-- 안전: employees 원본은 SELECT하거나, 트랜잭션 중 수정 후 ROLLBACK합니다.
-- 주의: 이 파일은 순서대로 실행하는 교육용 파일입니다.
DO $$ BEGIN IF current_database() <> 'hd' THEN RAISE EXCEPTION '현재 연결 DB는 hd가 아닙니다.'; END IF; END $$;

-- 46 | SELECT : 개발팀 직원 조회
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE department_id = 40;

-- 47~48 | DDL : employees_practice 생성 (연습용 테이블만 초기화)
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

-- 49 | INSERT : 직원 2명 추가
INSERT INTO employees_practice
    (first_name, last_name, department_id, salary, hire_date)
VALUES
    ('민준', '김', 40, 4500000, DATE '2026-11-01'),
    ('서진', '이', 50, 4200000, DATE '2026-11-02');
SELECT * FROM employees_practice ORDER BY employee_id;

-- 50 | UPDATE : 김민준 직원의 급여만 변경
UPDATE employees_practice
SET salary = 4700000
WHERE first_name = '민준' AND last_name = '김';
SELECT * FROM employees_practice ORDER BY employee_id;

-- 51 | DELETE : 이서진 직원만 삭제
DELETE FROM employees_practice
WHERE first_name = '서진' AND last_name = '이';
SELECT * FROM employees_practice ORDER BY employee_id;

-- 53~54 | TCL : 직원 123·124번 급여 인상 후 ROLLBACK
-- 슬라이드에서는 두 페이지에 나누어 표시되어 있으나 하나의 트랜잭션입니다.
SELECT employee_id, salary FROM employees
WHERE employee_id IN (123,124) ORDER BY employee_id;
BEGIN;
UPDATE employees SET salary = salary + 100000 WHERE employee_id = 123;
UPDATE employees SET salary = salary + 100000 WHERE employee_id = 124;
SELECT employee_id, salary FROM employees
WHERE employee_id IN (123,124) ORDER BY employee_id;
ROLLBACK;
SELECT employee_id, salary FROM employees
WHERE employee_id IN (123,124) ORDER BY employee_id;

-- 55 | SQL 기본 원칙
SELECT * FROM employees LIMIT 5;
SELECT employee_id, hire_date FROM employees
WHERE hire_date >= DATE '2025-01-01'
ORDER BY hire_date;
