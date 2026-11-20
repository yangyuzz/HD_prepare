-- 12장 DML | 과제문제 3문항 | 학생용
-- 공통 준비 SQL을 실행한 후 1~3번을 순서대로 풀어보세요.
-- 기존 employees는 수정하지 않습니다.

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


-- [과제 01] DEFAULT 활용 INSERT
-- employee_id=930, first_name='가온'인 직원을 추가하세요.
-- salary 값은 적지 않아 기본값(DEFAULT 0)이 들어가도록 하고,
-- RETURNING으로 전체 행을 확인하세요.
-- 예상: 930 | 가온 | 0


-- [과제 02] ROLLBACK 활용
-- BEGIN → 930번 직원의 salary를 3500000으로 UPDATE → RETURNING →
-- ROLLBACK → SELECT로 salary가 다시 0이 되었는지 확인하세요.
-- 예상: 변경 직후 3500000, ROLLBACK 뒤 0


-- [과제 03] DELETE 후 확인
-- 930번 직원만 삭제하고 RETURNING으로 삭제된 행을 확인하세요.
-- 삭제 후 930번을 SELECT했을 때 결과가 0행이어야 합니다.
-- 예상: 삭제된 행 930 | 가온 | 0

