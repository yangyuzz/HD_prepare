-- 12장 DML | 과제문제 3문항 | 교사용 정답·해설

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


-- [정답 01] 생략한 salary는 DEFAULT 0
INSERT INTO pg_temp.ch12_employee_demo (employee_id, first_name)
VALUES (930, '가온')
RETURNING *;
-- 결과: 930 | 가온 | 0
-- 해설: 컬럼을 지정하지 않으면 DEFAULT가 설정된 열은 기본값을 사용한다.

-- [정답 02] 변경한 후 취소
BEGIN;
UPDATE pg_temp.ch12_employee_demo
SET salary = 3500000
WHERE employee_id = 930
RETURNING employee_id, salary;
-- 임시 결과: 930 | 3500000
ROLLBACK;
SELECT employee_id, salary
FROM pg_temp.ch12_employee_demo
WHERE employee_id = 930;
-- 결과: 930 | 0
-- 해설: 트랜잭션 내에서 변경 후 COMMIT하지 않고 ROLLBACK했으므로 원래 값이다.

-- [정답 03] 930번 한 명 삭제
SELECT * FROM pg_temp.ch12_employee_demo WHERE employee_id = 930;
DELETE FROM pg_temp.ch12_employee_demo
WHERE employee_id = 930
RETURNING employee_id, first_name, salary;
-- 삭제된 행: 930 | 가온 | 0
SELECT * FROM pg_temp.ch12_employee_demo WHERE employee_id = 930;
-- 결과: 0행
