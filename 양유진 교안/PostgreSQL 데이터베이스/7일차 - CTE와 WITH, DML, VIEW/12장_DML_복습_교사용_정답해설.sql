-- 12장 DML | 복습문제 3문항 | 교사용 정답·해설

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


-- [정답 01] 새로운 직원 기록 입력
INSERT INTO pg_temp.ch12_employee_demo (employee_id, first_name, salary)
VALUES (901, '수아', 3900000)
RETURNING employee_id, first_name, salary;
-- 결과: 901 | 수아 | 3900000

-- [정답 02] 특정 직원 급여 인상
UPDATE pg_temp.ch12_employee_demo
SET salary = salary + 200000
WHERE employee_id = 101
RETURNING employee_id, salary;
-- 결과: 101 | 8400000
-- 해설: SET salary = salary + ... 은 기존 값 기준으로 계산한다.

-- [정답 03] 삭제 전 확인 후 정확히 1행 삭제
SELECT employee_id, first_name, salary
FROM pg_temp.ch12_employee_demo
WHERE employee_id = 901;
DELETE FROM pg_temp.ch12_employee_demo
WHERE employee_id = 901
RETURNING employee_id, first_name, salary;
-- 결과: 901 | 수아 | 3900000 (삭제된 행), 3행 남음
-- 해설: UPDATE/DELETE 전에 SELECT와 WHERE 조건을 먼저 확인한다.
