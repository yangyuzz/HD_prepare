-- 12장 DML | 수업 실습 5문항 | 교사용 정답·해설
-- 아래 SQL은 순서대로 실행 가능합니다. 임시 테이블만 수정합니다.

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


-- [정답 01] INSERT: 999번 직원을 420만원 급여로 추가
INSERT INTO pg_temp.ch12_employee_demo (employee_id, first_name, salary)
VALUES (999, '다솔', 4200000)
RETURNING employee_id, first_name, salary;
-- 결과: 999 | 다솔 | 4200000
-- 해설: INSERT는 새 행을 만들고 RETURNING은 새로 입력된 행을 보여 준다.

-- [정답 02] UPDATE: 101번 급여 8200000 → 8300000
SELECT employee_id, salary FROM pg_temp.ch12_employee_demo WHERE employee_id = 101;
UPDATE pg_temp.ch12_employee_demo
SET salary = salary + 100000
WHERE employee_id = 101
RETURNING employee_id, first_name, salary;
-- 결과: 101 | 서연 | 8300000
-- 해설: WHERE가 없으면 의도하지 않은 여러 행이 함께 변경될 수 있다.

-- [정답 03] DELETE: 999번만 삭제
SELECT * FROM pg_temp.ch12_employee_demo WHERE employee_id = 999;
DELETE FROM pg_temp.ch12_employee_demo
WHERE employee_id = 999
RETURNING employee_id, first_name, salary;
-- 결과: 999 | 다솔 | 4200000 (삭제된 행), 남은 행 3개
-- 해설: RETURNING은 DELETE에서는 실제로 삭제된 행을 보여 준다.

-- [정답 04] ROLLBACK: 변경 취소
BEGIN;
UPDATE pg_temp.ch12_employee_demo
SET salary = salary + 100000
WHERE employee_id = 100
RETURNING employee_id, salary;
-- 변경 중 결과: 100 | 13400000
ROLLBACK;
SELECT employee_id, salary FROM pg_temp.ch12_employee_demo WHERE employee_id = 100;
-- 취소 후 결과: 100 | 13300000
-- 해설: COMMIT 이전에 ROLLBACK하면 트랜잭션 내 변경을 취소한다.

-- [정답 05] COMMIT: 변경 확정
BEGIN;
UPDATE pg_temp.ch12_employee_demo
SET salary = salary + 50000
WHERE employee_id = 102
RETURNING employee_id, salary;
COMMIT;
SELECT employee_id, salary FROM pg_temp.ch12_employee_demo WHERE employee_id = 102;
-- 결과: 102 | 8050000
-- 해설: COMMIT은 해당 트랜잭션의 변경을 확정한다. 기존 employees는 영향이 없다.
