-- =============================================================================
-- PostgreSQL 11장 | DDL 아주 쉬운 기초 학습
-- 데이터베이스: hd | 기존 public 인사 테이블은 읽기 전용
-- 연습에서 생성/수정/삭제하는 것은 ddl_lab 스키마의 ch11_* 테이블뿐입니다.
-- DBeaver의 실행 버튼으로 각 번호의 SQL을 순서대로 실행하세요.
-- =============================================================================

-- 과제 정답·해설 5개
-- 모든 변경은 ddl_lab.ch11_homework_notes에만 적용됩니다.

-- [준비] 다른 데이터베이스에서 실행하지 않도록 확인 (제공 코드: 수정 불필요)
DO $hd_only$
BEGIN
    IF current_database() <> 'hd' THEN
        RAISE EXCEPTION '실습 중단: 현재 연결된 DB는 % 입니다. hd에 연결하세요.', current_database();
    END IF;
END;
$hd_only$;

CREATE SCHEMA IF NOT EXISTS ddl_lab;

-- 1번. CREATE TABLE : 새로운 연습 테이블 생성.
DROP TABLE IF EXISTS ddl_lab.ch11_homework_notes;
CREATE TABLE ddl_lab.ch11_homework_notes (
    note_id INTEGER PRIMARY KEY,
    employee_id INTEGER,
    memo VARCHAR(50)
);
-- 해설: 타입/컬럼명을 지정해 새로운 구조를 만듭니다.

-- 2번. INSERT : 123번 직원 메모 1행 입력.
INSERT INTO ddl_lab.ch11_homework_notes
    (note_id, employee_id, memo)
VALUES (1, 123, 'SQL 공부');
-- 해설: INSERT는 DML이지만 생성한 테이블에 행을 넣어보기 위해 복습합니다.

-- 3번. SELECT : 입력한 데이터를 조회.
SELECT * FROM ddl_lab.ch11_homework_notes;
-- 예상: (1, 123, 'SQL 공부') 한 행.

-- 4번. ALTER TABLE : 새 DATE 타입 열 추가.
ALTER TABLE ddl_lab.ch11_homework_notes
    ADD COLUMN study_date DATE;
-- 해설: 기존의 한 행은 유지되고 study_date는 일단 NULL입니다.

-- 5번. DROP TABLE : 숙제 연습용 테이블 삭제.
DROP TABLE ddl_lab.ch11_homework_notes;
-- 해설: 테이블 객체 자체가 사라집니다.
SELECT to_regclass('ddl_lab.ch11_homework_notes') AS 삭제후; -- NULL
