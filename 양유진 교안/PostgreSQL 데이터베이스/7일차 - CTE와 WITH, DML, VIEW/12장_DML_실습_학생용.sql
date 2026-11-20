-- 12장 DML | 수업 실습 5문항 | 학생용
-- 실행 순서: 준비 SQL → 실습 1~5 순서대로. 한 문제씩 선택하여 실행하세요.
-- 빈칸(____)은 완성한 뒤 실행합니다. 연습용 TEMP 테이블만 변경됩니다.

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


-- ===========================================================
-- [실습 01] INSERT / RETURNING : 직원 999번 '다솔' 추가
-- 아래 INSERT의 빈칸에 급여 4,200,000을 채워 실행하세요.
-- 예상: employee_id 999, first_name 다솔, salary 4200000 (1행)
INSERT INTO pg_temp.ch12_employee_demo (employee_id, first_name, salary)
VALUES (999, '다솔', ____)
RETURNING employee_id, first_name, salary;

-- [실습 02] UPDATE / WHERE / RETURNING : 101번 급여 10만 원 인상
-- 수정 전 조회한 다음, 빈칸에 직원번호를 채우세요.
-- 예상 결과: 101 | 서연 | 8300000
SELECT employee_id, salary FROM pg_temp.ch12_employee_demo
WHERE employee_id = 101;

UPDATE pg_temp.ch12_employee_demo
SET salary = salary + 100000
WHERE employee_id = ____
RETURNING employee_id, first_name, salary;

-- [실습 03] DELETE / WHERE / RETURNING : 999번 직원만 삭제
-- 먼저 SELECT로 확인하고, 빈칸에 삭제 대상 직원번호를 입력하세요.
-- 예상: RETURNING 999 | 다솔 | 4200000, 삭제 후 총 3행
SELECT * FROM pg_temp.ch12_employee_demo WHERE employee_id = 999;

DELETE FROM pg_temp.ch12_employee_demo
WHERE employee_id = ____
RETURNING employee_id, first_name, salary;

-- [실습 04] BEGIN / ROLLBACK : 수정 후 취소해 보기
-- 아래 네 문장을 순서대로 실행하세요. (한 연결에서 실행)
-- 수정 직후 100번 급여 = 13400000 → ROLLBACK 후 = 13300000
BEGIN;
UPDATE pg_temp.ch12_employee_demo
SET salary = salary + 100000
WHERE employee_id = 100
RETURNING employee_id, salary;
ROLLBACK;
SELECT employee_id, salary FROM pg_temp.ch12_employee_demo
WHERE employee_id = 100;

-- [실습 05] BEGIN / COMMIT : 수정 확정해 보기
-- 수정 직후와 COMMIT 후 모두 102번 급여 = 8050000
BEGIN;
UPDATE pg_temp.ch12_employee_demo
SET salary = salary + 50000
WHERE employee_id = 102
RETURNING employee_id, salary;
COMMIT;
SELECT employee_id, salary FROM pg_temp.ch12_employee_demo
WHERE employee_id = 102;
