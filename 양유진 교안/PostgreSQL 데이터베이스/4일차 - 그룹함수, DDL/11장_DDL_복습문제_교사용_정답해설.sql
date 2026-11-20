-- =============================================================================
-- PostgreSQL 11장 | DDL 아주 쉬운 기초 학습
-- 데이터베이스: hd | 기존 public 인사 테이블은 읽기 전용
-- 연습에서 생성/수정/삭제하는 것은 ddl_lab 스키마의 ch11_* 테이블뿐입니다.
-- DBeaver의 실행 버튼으로 각 번호의 SQL을 순서대로 실행하세요.
-- =============================================================================

-- 복습 정답·해설 5개

-- [준비] 다른 데이터베이스에서 실행하지 않도록 확인 (제공 코드: 수정 불필요)
DO $hd_only$
BEGIN
    IF current_database() <> 'hd' THEN
        RAISE EXCEPTION '실습 중단: 현재 연결된 DB는 % 입니다. hd에 연결하세요.', current_database();
    END IF;
END;
$hd_only$;

CREATE SCHEMA IF NOT EXISTS ddl_lab;

-- 1번 정답: CREATE TABLE
-- 해설: CREATE는 새로운 DB 객체를 만들 때 사용하는 DDL 명령.

-- 2번 정답: 아니요
-- 해설: PRIMARY KEY는 중복과 NULL을 모두 허용하지 않습니다.

-- 3번 정답: NOT NULL
-- 해설: 필수 입력에 사용. CHECK만으로 NULL을 막을 수는 없습니다.

-- 4번 정답: ALTER TABLE ... ADD COLUMN
DROP TABLE IF EXISTS ddl_lab.ch11_review;
CREATE TABLE ddl_lab.ch11_review (
    review_id INTEGER PRIMARY KEY
);
ALTER TABLE ddl_lab.ch11_review
    ADD COLUMN memo VARCHAR(50);
SELECT column_name FROM information_schema.columns
WHERE table_schema='ddl_lab' AND table_name='ch11_review'
ORDER BY ordinal_position;
-- 해설: ALTER TABLE은 기존 테이블 구조를 수정합니다.

-- 5번 정답: TRUNCATE
-- 해설: TRUNCATE는 행만 비우고 구조는 남기며, DROP은 구조까지 제거.
DROP TABLE IF EXISTS ddl_lab.ch11_review;
