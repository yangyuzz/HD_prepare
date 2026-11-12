-- hd 데이터베이스 만들기 (PostgreSQL)
-- 1) DBeaver에서 postgres 등 기존 관리 데이터베이스에 연결하세요.
-- 2) 아래 명령은 hd가 아직 없을 때 한 번만 실행하세요.
-- 3) hd로 새 연결한 후 hd_sample_data.sql을 실행하세요.
-- 주의: CREATE DATABASE는 트랜잭션 블록 안에서 실행할 수 없습니다.

CREATE DATABASE hd WITH ENCODING 'UTF8' TEMPLATE template0;
