-- =============================================================================
-- PostgreSQL 11장 | DDL 아주 쉬운 기초 학습
-- 데이터베이스: hd | 기존 public 인사 테이블은 읽기 전용
-- 연습에서 생성/수정/삭제하는 것은 ddl_lab 스키마의 ch11_* 테이블뿐입니다.
-- DBeaver의 실행 버튼으로 각 번호의 SQL을 순서대로 실행하세요.
-- =============================================================================

-- 과제문제 5개 (아주 쉬움) | DBeaver에서 혼자 실행해 보세요.
-- 기존 employees는 수정하지 않고, ddl_lab의 숙제 전용 테이블만 사용합니다.
-- 1~5번을 순서대로 진행하세요. 작성할 자리는 -- 내 SQL: 표시 아래입니다.

-- [준비] 다른 데이터베이스에서 실행하지 않도록 확인 (제공 코드: 수정 불필요)
DO $hd_only$
BEGIN
    IF current_database() <> 'hd' THEN
        RAISE EXCEPTION '실습 중단: 현재 연결된 DB는 % 입니다. hd에 연결하세요.', current_database();
    END IF;
END;
$hd_only$;

CREATE SCHEMA IF NOT EXISTS ddl_lab;

-- 1번. 숙제용 표 만들기 (CREATE TABLE)
-- 이름: ddl_lab.ch11_homework_notes
-- 컬럼: note_id INTEGER PRIMARY KEY, employee_id INTEGER, memo VARCHAR(50)
-- 힌트: CREATE TABLE 이름 (컬럼명 자료형, ...);
-- 내 SQL:

-- 2번. 만든 테이블에 직원 123의 메모 1행 추가하기
-- 데이터: note_id=1, employee_id=123, memo='SQL 공부'
-- 힌트: INSERT INTO ... VALUES (...);
-- 내 SQL:

-- 3번. memo가 잘 저장되었는지 확인하기 (SELECT)
-- 내 SQL:

-- 4번. 새 컬럼 study_date DATE를 추가하기 (ALTER TABLE)
-- 힌트: ALTER TABLE 테이블명 ADD COLUMN 컬럼명 자료형;
-- 내 SQL:

-- 5번. 숙제용 표를 삭제하기 (DROP TABLE)
-- 힌트: DROP TABLE 테이블명;
-- 내 SQL:

-- 안전 확인: public.employees와 public.departments는 한 번도 수정하지 않았습니다.
