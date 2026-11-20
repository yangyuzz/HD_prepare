-- =============================================================================
-- PostgreSQL 11장 | DDL 아주 쉬운 기초 학습
-- 데이터베이스: hd | 기존 public 인사 테이블은 읽기 전용
-- 연습에서 생성/수정/삭제하는 것은 ddl_lab 스키마의 ch11_* 테이블뿐입니다.
-- DBeaver의 실행 버튼으로 각 번호의 SQL을 순서대로 실행하세요.
-- =============================================================================

-- [진행 안내] 예제 대부분은 미리 작성했습니다.
-- ★ 표시된 실습에서만 중요한 단어를 넣고, 앞의 주석(--)을 해제해 실행하세요.
-- SQL 블록을 한 번에 모두 실행하지 말고 번호별로 실행하세요.
-- 특히 BEGIN~ROLLBACK은 블록 전체를 스크립트 실행해야 확인할 수 있습니다.
-- 이미 실행했던 실습을 처음부터 다시 하려면 02번부터 진행하세요.

-- [준비] 다른 데이터베이스에서 실행하지 않도록 확인 (제공 코드: 수정 불필요)
DO $hd_only$
BEGIN
    IF current_database() <> 'hd' THEN
        RAISE EXCEPTION '실습 중단: 현재 연결된 DB는 % 입니다. hd에 연결하세요.', current_database();
    END IF;
END;
$hd_only$;

CREATE SCHEMA IF NOT EXISTS ddl_lab;

-- ==========================================================================
-- 실습 01. 기존 직원 데이터와 연결된 '부서'를 눈으로 확인하기 [완성형]
-- DDL 실습 전에 이미 존재하는 테이블을 조회합니다. 기존 데이터를 바꾸지 않습니다.
-- ==========================================================================
SELECT employee_id, first_name, department_id
FROM public.employees
WHERE employee_id IN (123, 124)
ORDER BY employee_id;

-- ==========================================================================
-- 실습 02. 연습 테이블 초기화 및 CREATE TABLE [대부분 완성형]
-- 기존 public 직원 데이터는 그대로 두고 별도 연습 테이블만 만듭니다.
-- ★ 직접 적기: PRIMARY KEY는 '행을 구별하는 기본키'입니다.
-- ==========================================================================
DROP TABLE IF EXISTS ddl_lab.ch11_employee_training;

-- ★ 아래 코드를 복사하여 [____]을 PRIMARY KEY로 바꾸고 주석을 해제하세요.
-- CREATE TABLE ddl_lab.ch11_employee_training (
--     training_id INTEGER [____],
--     employee_id INTEGER NOT NULL REFERENCES public.employees(employee_id),
--     course_name VARCHAR(60) NOT NULL,
--     score INTEGER CHECK (score BETWEEN 0 AND 100),
--     training_status VARCHAR(10) NOT NULL DEFAULT '수강중',
--     CONSTRAINT uq_ch11_employee_course UNIQUE (employee_id, course_name)
-- );

-- 확인: 실습 테이블을 생성한 뒤 실행하세요.
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'ddl_lab' AND table_name = 'ch11_employee_training'
ORDER BY ordinal_position;

-- ==========================================================================
-- 실습 03. 직원 두 명의 교육 기록 넣어 보기 [완성형]
-- PRIMARY KEY / FOREIGN KEY / NOT NULL / CHECK / DEFAULT / UNIQUE 개념 확인
-- ==========================================================================
INSERT INTO ddl_lab.ch11_employee_training
    (training_id, employee_id, course_name, score)
VALUES (1, 123, 'SQL 기초', 95),
       (2, 124, 'SQL 기초', 88);

SELECT * FROM ddl_lab.ch11_employee_training ORDER BY training_id;
-- training_status를 INSERT에서 생략했으므로 '수강중'으로 들어옵니다.

-- ==========================================================================
-- 실습 04. 제약조건 개념 이해 [읽고 비교하기: 실행하지 않음]
-- ==========================================================================
-- 1) PRIMARY KEY: training_id 값은 중복될 수 없음
-- 2) FOREIGN KEY: public.employees에 없는 employee_id(99999)는 등록 불가
-- 3) NOT NULL: course_name에 NULL 저장 불가
-- 4) CHECK: score는 0~100 사이만 허용 (150 입력은 거부)
-- 5) DEFAULT: training_status 생략 → '수강중'
-- 6) UNIQUE: 같은 employee_id와 course_name 조합은 중복 불가
-- 오류 시연은 강사가 화면에서 보여주고, 학생은 관찰해도 충분합니다.
-- (예: 아래 문장은 의도적으로 주석 처리해 두었습니다.)
-- INSERT INTO ddl_lab.ch11_employee_training
--   (training_id, employee_id, course_name, score)
-- VALUES (3, 99999, 'SQL 기초', 80);

-- ==========================================================================
-- 실습 05. ALTER TABLE: 열 하나 추가하기 [빈칸 완성]
-- ★ ADD COLUMN은 테이블에 새로운 열을 추가합니다.
-- ==========================================================================
-- ★ ____를 ADD COLUMN으로 바꾼 뒤 주석을 해제하여 실행하세요.
-- ALTER TABLE ddl_lab.ch11_employee_training
--     ____ instructor_note VARCHAR(60);

-- 열이 생겼는지 확인하세요.
SELECT column_name
FROM information_schema.columns
WHERE table_schema='ddl_lab' AND table_name='ch11_employee_training'
ORDER BY ordinal_position;

-- ==========================================================================
-- 실습 06. TRUNCATE: 테이블은 남기고 행만 비우기 [완성형]
-- 실습 데이터가 없어지는 것을 확인합니다. public 테이블은 대상이 아닙니다.
-- ==========================================================================
SELECT COUNT(*) AS 삭제전_행수 FROM ddl_lab.ch11_employee_training;
TRUNCATE TABLE ddl_lab.ch11_employee_training;
SELECT COUNT(*) AS 삭제후_행수 FROM ddl_lab.ch11_employee_training;

-- ==========================================================================
-- 실습 07. ROLLBACK: CREATE TABLE 되돌리기 [완성형]
-- 반드시 BEGIN ~ ROLLBACK 네 문장을 하나의 '스크립트'로 실행하세요.
-- ==========================================================================
BEGIN;
CREATE TABLE ddl_lab.ch11_rollback_demo (
    demo_id INTEGER PRIMARY KEY
);
SELECT to_regclass('ddl_lab.ch11_rollback_demo') AS 만들었을때;
ROLLBACK;
SELECT to_regclass('ddl_lab.ch11_rollback_demo') AS 롤백후; -- NULL: 테이블이 사라짐

-- ==========================================================================
-- 실습 08. DROP TABLE: 연습용 테이블 자체 삭제 [빈칸 완성]
-- ★ DROP TABLE을 실행하면 테이블 구조까지 삭제됩니다.
-- ==========================================================================
-- ★ ____를 DROP TABLE로 바꾼 뒤 주석을 해제하세요.
-- ____ ddl_lab.ch11_employee_training;

-- 테이블이 사라졌다면 아래 결과는 NULL입니다.
SELECT to_regclass('ddl_lab.ch11_employee_training') AS 테이블존재확인;

-- [개념만 확인] 수업에서 직접 실행하지 않는 옵션
-- TRUNCATE ... RESTART IDENTITY: 자동 증가 번호를 처음으로 되돌림
-- TRUNCATE ... CASCADE: 참조하는 자식 테이블까지 함께 비움
-- DROP TABLE ... CASCADE: 의존 객체/제약조건도 제거할 수 있음
-- 이런 옵션은 초보 실습에서 사용하지 않습니다.
