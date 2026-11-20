-- =============================================================================
-- PostgreSQL 11장 | DDL 아주 쉬운 기초 학습
-- 데이터베이스: hd | 기존 public 인사 테이블은 읽기 전용
-- 연습에서 생성/수정/삭제하는 것은 ddl_lab 스키마의 ch11_* 테이블뿐입니다.
-- DBeaver의 실행 버튼으로 각 번호의 SQL을 순서대로 실행하세요.
-- =============================================================================

-- 복습문제 5개 (아주 쉬움) | 스스로 생각해서 -- 내 답: 뒤에 적어 보세요.
-- SQL 작성 문제는 DBeaver에서 실행해도 됩니다.

-- [준비] 다른 데이터베이스에서 실행하지 않도록 확인 (제공 코드: 수정 불필요)
DO $hd_only$
BEGIN
    IF current_database() <> 'hd' THEN
        RAISE EXCEPTION '실습 중단: 현재 연결된 DB는 % 입니다. hd에 연결하세요.', current_database();
    END IF;
END;
$hd_only$;

CREATE SCHEMA IF NOT EXISTS ddl_lab;

-- 1번. 새로운 테이블을 만드는 DDL 명령어는 무엇일까요?
-- 내 답:

-- 2번. PRIMARY KEY는 중복을 허용할까요? (예/아니요)
-- 내 답:

-- 3번. 직원 교육 테이블에서 course_name을 반드시 입력하게 하려면
--      어떤 제약조건을 써야 할까요?
-- 내 답:

-- 4번. 이미 있는 테이블에 memo VARCHAR(50) 열을 추가하려 합니다.
--      아래 틀에 필요한 SQL을 완성하세요. (먼저 연습 테이블을 만듭니다.)
CREATE TABLE IF NOT EXISTS ddl_lab.ch11_review (
    review_id INTEGER PRIMARY KEY
);
-- 내 SQL:
-- ALTER TABLE ddl_lab.ch11_review
--     ... ;

-- 5번. TRUNCATE와 DROP 중 테이블 구조를 남기는 명령은 무엇일까요?
-- 내 답:

-- 선생님 확인 후, 필요하다면 연습 테이블만 삭제하세요.
-- DROP TABLE IF EXISTS ddl_lab.ch11_review;
