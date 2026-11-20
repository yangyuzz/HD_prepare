-- 12장 DML | 복습문제 3문항 | 학생용
-- SQL을 직접 작성합니다. 아래 공통 준비 SQL을 먼저 실행하세요.
-- 세 문항은 순서대로 풉니다. 학생용에는 답 SQL을 적지 않았습니다.

-- [공통 준비] hd 데이터베이스에 연결한 뒤 실행하세요.
-- 기존 employees는 조회만 합니다. INSERT/UPDATE/DELETE는 TEMP 테이블에서만 실행합니다.
-- 같은 DB 세션에서 실행해야 임시 테이블이 유지됩니다.
CREATE TEMP TABLE IF NOT EXISTS ch12_employee_demo (
    employee_id INTEGER PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    salary INTEGER NOT NULL DEFAULT 0
);

-- 파일을 다시 실행해도 연습 데이터가 초기 상태로 돌아가도록 설정
TRUNCATE TABLE pg_temp.ch12_employee_demo;
INSERT INTO pg_temp.ch12_employee_demo (employee_id, first_name, salary)
SELECT employee_id, first_name, salary
FROM employees
WHERE employee_id IN (100, 101, 102);

SELECT employee_id, first_name, salary
FROM pg_temp.ch12_employee_demo
ORDER BY employee_id;
-- [준비 결과]
-- employee_id | first_name | salary
--          100 | 민수       | 13300000
--          101 | 서연       |  8200000
--          102 | 지훈       |  8000000


-- [복습 01] INSERT
-- employee_id=901, first_name='수아', salary=3900000을 추가하고
-- RETURNING으로 입력된 행을 확인하세요.
-- 예상: 901 | 수아 | 3900000


-- [복습 02] UPDATE
-- 직원 101번의 급여를 기존보다 200000원 올리고 변경된 직원번호와 급여를 출력하세요.
-- 예상: 101 | 8400000


-- [복습 03] DELETE
-- 901번 직원이 존재하는지 먼저 SELECT로 확인한 후,
-- 그 직원만 DELETE하고 RETURNING으로 삭제된 행을 확인하세요.
-- 예상: 901 | 수아 | 3900000 (삭제), 남은 행 3개

