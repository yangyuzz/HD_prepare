PostgreSQL 2장 · hd 데이터베이스 수업 패키지
=======================================

[준비]
1. PostgreSQL / DBeaver 설치 및 hd DB 연결
2. 기존 hd_sample_data.sql 실행 (7개 테이블, 379건: 6 + 9 + 11 + 69 + 15 + 102 + 167)
3. DBeaver에서 SELECT current_database(); 실행하여 hd인지 확인

[교안]
PostgreSQL_2장_교안_hd_employees_SQL예제수정.pptx
- 원본 62장 유지 / 46~55장 SQL 예제 모두 hd의 employees/departments 중심으로 교체
- 56~60장 학습 확인/실무 연결 사례도 인사 데이터로 통일
- 47~51장: employees_practice (별도 연습 테이블만 재생성)
- 53~54장: employees의 123/124번 급여를 트랜잭션 중 변경하고 ROLLBACK

[실행용 SQL]
- hd_교안_46-55_SQL예제_실행용.sql : 교안 예제 전체 순서 실행
- hd_실습문제_모범답안_실행용.sql : 실습 01~12 정답 실행용
- hd_과제문제_모범답안_실행용.sql : 과제 01~12 정답 실행용

[문제지 / 정답지]
- 실습문제: 12문항 (SELECT / WHERE / NULL / JOIN / GROUP BY / DDL / DML / TCL)
- 복습문제: 12문항 (기본 개념 / PK·FK / CRUD / 분류 / SQL 오류 찾기)
- 과제문제: 12문항 (SELECT / JOIN / 집계 / HAVING / SELF JOIN / 트랜잭션 / 테이블 설계)
- 세 유형 모두 학생용, 교사용 정답해설 DOCX 별도 제공

[안전 주의]
- 초기 샘플 파일 hd_sample_data.sql은 7개 원본 테이블을 초기화합니다. 수업 전 1회만 실행하세요.
- 이 패키지의 CREATE/DROP은 employees_practice 및 training_feedback만 대상으로 합니다.
- 원본 employees의 급여 UPDATE는 BEGIN/ROLLBACK으로 변경사항이 남지 않도록 작성했습니다.
- SQL 스크립트는 파일 전체를 한 번에 실행하거나, DBeaver에서 문장 단위로 순차 실행합니다.
  트랜잭션 실습은 같은 연결/세션에서 BEGIN부터 ROLLBACK까지 실행해야 합니다.
- 복습문제 중 UPDATE 고쳐 쓰기는 작성 문제입니다. 정답지 SQL을 실습한다면 반드시 트랜잭션으로 보호합니다.
