-- =============================================================================
-- PostgreSQL 11장 | DDL 아주 쉬운 기초 학습
-- 데이터베이스: hd | 기존 public 인사 테이블은 읽기 전용
-- 연습에서 생성/수정/삭제하는 것은 ddl_lab 스키마의 ch11_* 테이블뿐입니다.
-- DBeaver의 실행 버튼으로 각 번호의 SQL을 순서대로 실행하세요.
-- =============================================================================

-- [교사용] 학생용과 동일한 실습 8개, 완성 SQL 및 설명.
-- 주의: 이 스크립트는 01~08 순서대로 한 블록씩 실행합니다.
-- 이미 있던 ddl_lab.ch11_* 연습 테이블만 초기화합니다.

-- [준비] 다른 데이터베이스에서 실행하지 않도록 확인 (제공 코드: 수정 불필요)
DO $hd_only$
BEGIN
    IF current_database() <> 'hd' THEN
        RAISE EXCEPTION '실습 중단: 현재 연결된 DB는 % 입니다. hd에 연결하세요.', current_database();
    END IF;
END;
$hd_only$;

CREATE SCHEMA IF NOT EXISTS ddl_lab;

-- 01. 기존 테이블 조회. employees 원본 데이터는 수정하지 않음.
SELECT employee_id, first_name, department_id
FROM public.employees
WHERE employee_id IN (123,124)
ORDER BY employee_id;
-- 해설: 123번과 124번 모두 개발팀(40) 소속.

-- 02. 연습 테이블 생성: ★ PRIMARY KEY를 직접 완성하도록 안내.
DROP TABLE IF EXISTS ddl_lab.ch11_employee_training;
CREATE TABLE ddl_lab.ch11_employee_training (
    training_id INTEGER PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES public.employees(employee_id),
    course_name VARCHAR(60) NOT NULL,
    score INTEGER CHECK (score BETWEEN 0 AND 100),
    training_status VARCHAR(10) NOT NULL DEFAULT '수강중',
    CONSTRAINT uq_ch11_employee_course UNIQUE (employee_id, course_name)
);
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema='ddl_lab' AND table_name='ch11_employee_training'
ORDER BY ordinal_position;
-- 해설: 각 열의 자료형, PRIMARY KEY / FK / CHECK 등을 비교.

-- 03. 직원 123, 124의 교육 이력 입력. DEFAULT 결과는 '수강중'.
INSERT INTO ddl_lab.ch11_employee_training
    (training_id, employee_id, course_name, score)
VALUES (1, 123, 'SQL 기초', 95),
       (2, 124, 'SQL 기초', 88);
SELECT * FROM ddl_lab.ch11_employee_training ORDER BY training_id;

-- 04. 제약조건은 설명용으로만: 에러 INSERT는 실행하지 않아도 됨.
-- PK: training_id 중복 불가, FK: 직원에 없는 99999 불가
-- NOT NULL: course_name 필수, CHECK: score 0~100, DEFAULT: 수강중
-- UNIQUE: (employee_id, course_name) 조합 중복 금지
-- 시연용 오류 예 (기본은 주석처리):
-- INSERT INTO ddl_lab.ch11_employee_training
--   (training_id, employee_id, course_name, score)
-- VALUES (3, 99999, 'SQL 기초', 80);

-- 05. ★ ALTER TABLE ... ADD COLUMN
ALTER TABLE ddl_lab.ch11_employee_training
    ADD COLUMN instructor_note VARCHAR(60);
SELECT column_name
FROM information_schema.columns
WHERE table_schema='ddl_lab' AND table_name='ch11_employee_training'
ORDER BY ordinal_position;
-- 해설: 기존 데이터(2행)는 유지; 새 열의 기존 값은 NULL.

-- 06. TRUNCATE: 테이블은 남고 행만 삭제됨.
SELECT COUNT(*) AS 삭제전_행수 FROM ddl_lab.ch11_employee_training; -- 2
TRUNCATE TABLE ddl_lab.ch11_employee_training;
SELECT COUNT(*) AS 삭제후_행수 FROM ddl_lab.ch11_employee_training; -- 0

-- 07. 트랜잭션: 아래 BEGIN~ROLLBACK은 함께 실행.
BEGIN;
CREATE TABLE ddl_lab.ch11_rollback_demo (
    demo_id INTEGER PRIMARY KEY
);
SELECT to_regclass('ddl_lab.ch11_rollback_demo') AS 만들었을때;
ROLLBACK;
SELECT to_regclass('ddl_lab.ch11_rollback_demo') AS 롤백후;
-- 해설: PostgreSQL에서 CREATE TABLE을 ROLLBACK하면 객체가 남지 않음.

-- 08. ★ DROP TABLE
DROP TABLE ddl_lab.ch11_employee_training;
SELECT to_regclass('ddl_lab.ch11_employee_training') AS 테이블존재확인;
-- 해설: 결과 NULL이면 구조까지 삭제됨. 기존 public 7개 테이블은 그대로.

-- 참고: 아래는 직접 실행하지 않는 고급 옵션
-- TRUNCATE ... RESTART IDENTITY / CASCADE, DROP ... CASCADE
