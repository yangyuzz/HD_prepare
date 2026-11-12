-- ==============================================================================
-- hd | PostgreSQL 4장 | 실습문제 | 교사용 정답·해설
-- 총 43문항 · 소단원 4개 · PostgreSQL / DBeaver · UTF-8
-- 실행 데이터베이스: hd · 사전 준비: hd_sample_data.sql 최초 1회 적재
-- [주의] 4장 교안과 동일한 테이블/컬럼만 사용하며 원본 데이터를 변경하지 않습니다.
-- [실행 팁] 각 문제의 SQL만 선택하여 실행할 수 있습니다.
-- [개념형] 정답은 SQL 주석으로 기록했고 실습형은 실행 가능한 SELECT를 수록했습니다.
-- ==============================================================================

-- 연결된 DB 확인 (SELECT 쿼리이며 직원 데이터를 변경하지 않음)
SELECT current_database() AS current_db;


-- ==============================================================================
-- 소단원 01 | SQL 분류 · 논리적 처리 · 그룹화
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- [실습문제 01] SQL 명령어 분류
-- ------------------------------------------------------------------------------
-- 문제: SELECT, INSERT, CREATE, GRANT, ROLLBACK이 각각 속하는 SQL 분류(DQL/DML/DDL/DCL/TCL)와 역할을 주석으로 작성하시오.
-- 학습 요소: SQL 분류

-- [모범답안]
-- SELECT  : DQL, 데이터 조회
-- INSERT  : DML, 데이터 추가·변경
-- CREATE  : DDL, 데이터베이스 객체 구조 정의
-- GRANT   : DCL, 접근 권한 부여
-- ROLLBACK: TCL, 트랜잭션 변경 취소

-- 해설: 4장은 SELECT 조회가 중심이므로 다른 분류는 개념 확인으로 다룬다.

-- ------------------------------------------------------------------------------
-- [실습문제 02] 작성 순서와 논리적 처리 순서
-- ------------------------------------------------------------------------------
-- 문제: SELECT, FROM, WHERE, GROUP BY, HAVING, DISTINCT, ORDER BY, LIMIT/OFFSET을 SQL 작성 순서와 논리적 처리 순서로 각각 나열하시오. DISTINCT의 작성 위치도 표기하시오.
-- 학습 요소: 작성·처리 순서

-- [모범답안]
-- 작성: SELECT [DISTINCT] → FROM → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT/OFFSET
-- 처리: FROM → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT/OFFSET

-- 해설: 작성 순서는 SQL 문장을 적는 순서이고, 논리적 처리 순서는 조회 결과를 이해하는 단계 순서이다.

-- ------------------------------------------------------------------------------
-- [실습문제 03] SELECT *로 구조 탐색 후 필요한 열만 선택
-- ------------------------------------------------------------------------------
-- 문제: ① employees 전체 열에서 사번 순으로 앞의 3행을 조회하시오. ② 직원의 사번·이름·급여 열만 선택하여 사번 순으로 앞의 3행을 조회하시오.
-- 학습 요소: SELECT · FROM · * · LIMIT

-- [모범답안]
SELECT *
FROM employees
ORDER BY employee_id
LIMIT 3;

SELECT employee_id, first_name, salary
FROM employees
ORDER BY employee_id
LIMIT 3;

-- 해설: 탐색에는 SELECT *를 쓸 수 있지만 분석용 SQL은 필요한 컬럼만 적는 편이 좋다.

-- ------------------------------------------------------------------------------
-- [실습문제 04] SELECT 별칭 AS
-- ------------------------------------------------------------------------------
-- 문제: employees에서 employee_id·first_name·salary를 각각 사번·이름·급여라는 결과 열 이름으로 조회하고 사번 순으로 앞의 5명만 출력하시오.
-- 학습 요소: SELECT · AS

-- [모범답안]
SELECT employee_id AS 사번,
       first_name AS 이름,
       salary AS 급여
FROM employees
ORDER BY employee_id
LIMIT 5;

-- 해설: AS는 결과의 열 제목만 바꾸고 원본 컬럼명은 변경하지 않는다.

-- ------------------------------------------------------------------------------
-- [실습문제 05] FROM → WHERE → SELECT: 행과 열 고르기
-- ------------------------------------------------------------------------------
-- 문제: employee_id가 104인 직원의 first_name과 salary 두 열만 조회하시오. WHERE가 행을, SELECT가 열을 지정한다는 의미를 설명하시오.
-- 학습 요소: FROM · WHERE · SELECT

-- [모범답안]
SELECT first_name, salary
FROM employees
WHERE employee_id = 104;
-- 해설: WHERE는 104번 직원 행을 고르고, SELECT는 이름과 급여만 표시한다.

-- 해설: 샘플 데이터에서 104번 직원은 현우이고 급여는 8,000,000원이다.

-- ------------------------------------------------------------------------------
-- [실습문제 06] GROUP BY와 COUNT(*)
-- ------------------------------------------------------------------------------
-- 문제: 부서가 배정된 직원만 대상으로 department_id별 직원 수를 계산하고, 부서 ID 오름차순으로 표시하시오. 결과 열 별칭은 employee_count로 작성하시오.
-- 학습 요소: GROUP BY · COUNT(*)

-- [모범답안]
SELECT department_id, COUNT(*) AS employee_count
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY department_id;

-- 해설: GROUP BY는 같은 부서번호를 가진 직원들을 한 그룹으로 묶고 COUNT(*)는 각 그룹의 행 수를 센다.

-- ------------------------------------------------------------------------------
-- [실습문제 07] WHERE를 먼저 적용하는 그룹 집계
-- ------------------------------------------------------------------------------
-- 문제: 재직 중인 직원만 대상으로 부서별 직원 수를 계산하시오. NULL 부서는 제외하고 부서 ID 오름차순으로 표시하시오.
-- 학습 요소: WHERE · GROUP BY · COUNT

-- [모범답안]
SELECT department_id, COUNT(*) AS active_count
FROM employees
WHERE employment_status = '재직'
  AND department_id IS NOT NULL
GROUP BY department_id
ORDER BY department_id;

-- 해설: WHERE의 행 조건이 먼저 적용되므로 휴직·퇴사 직원은 부서별 집계에서 제외된다.

-- ------------------------------------------------------------------------------
-- [실습문제 08] HAVING으로 그룹 필터링
-- ------------------------------------------------------------------------------
-- 문제: 재직 직원이 5명 이상인 부서만 조회하시오. 부서별 재직 인원 수를 표시하고, 인원 내림차순·부서 ID 오름차순으로 정렬하시오.
-- 학습 요소: GROUP BY · HAVING

-- [모범답안]
SELECT department_id, COUNT(*) AS active_count
FROM employees
WHERE employment_status = '재직'
  AND department_id IS NOT NULL
GROUP BY department_id
HAVING COUNT(*) >= 5
ORDER BY active_count DESC, department_id ASC;

-- 해설: WHERE는 묶기 전 직원 행을, HAVING은 묶은 후 부서 그룹을 검사한다.

-- ------------------------------------------------------------------------------
-- [실습문제 09] 부서별 평균 급여 AVG
-- ------------------------------------------------------------------------------
-- 문제: 부서가 배정된 직원의 부서별 평균 급여를 구하고 평균 급여가 높은 순으로 정렬하시오. 결과 열 별칭은 avg_salary로 작성하시오.
-- 학습 요소: GROUP BY · AVG · ORDER BY

-- [모범답안]
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY avg_salary DESC, department_id ASC;

-- 해설: AVG(salary)는 각 부서 그룹의 평균 급여를 계산한다. ROUND 없이도 AVG 결과를 확인할 수 있다.

-- ------------------------------------------------------------------------------
-- [실습문제 10] ORDER BY + LIMIT의 처리 과정
-- ------------------------------------------------------------------------------
-- 문제: 직원 전체 중 급여가 가장 높은 2명의 사번·이름·급여를 조회하시오. 급여 동점이면 사번 오름차순으로 정렬하시오.
-- 학습 요소: ORDER BY · LIMIT

-- [모범답안]
SELECT employee_id, first_name, salary
FROM employees
ORDER BY salary DESC, employee_id ASC
LIMIT 2;

-- 해설: 먼저 ORDER BY로 정렬한 다음 LIMIT으로 앞 2행만 남긴다.

-- ------------------------------------------------------------------------------
-- [실습문제 11] 전체 SQL 논리적 흐름
-- ------------------------------------------------------------------------------
-- 문제: 부서가 배정된 재직 직원의 부서별 인원을 집계하고, 5명 이상인 그룹 중 인원 상위 3개 부서를 조회하시오. 인원 동점이면 부서 ID 오름차순.
-- 학습 요소: 논리적 처리 순서 · 종합

-- [모범답안]
SELECT department_id, COUNT(*) AS employee_count
FROM employees
WHERE employment_status = '재직'
  AND department_id IS NOT NULL
GROUP BY department_id
HAVING COUNT(*) >= 5
ORDER BY employee_count DESC, department_id ASC
LIMIT 3;

-- 해설: FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT 순으로 의미를 추적한다.


-- ==============================================================================
-- 소단원 02 | SELECT · WHERE · 조건 검색
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- [실습문제 12] 비교 연산자 = 와 <>
-- ------------------------------------------------------------------------------
-- 문제: ① 개발팀(부서 ID 40) 직원의 사번·부서번호를 조회하시오. ② 직무가 인턴(INTERN)이 아닌 직원의 사번·직무를 조회하시오. 각 결과는 사번순 앞의 10행만 표시하시오.
-- 학습 요소: = · <> · WHERE

-- [모범답안]
SELECT employee_id, department_id
FROM employees
WHERE department_id = 40
ORDER BY employee_id
LIMIT 10;

SELECT employee_id, job_id
FROM employees
WHERE job_id <> 'INTERN'
ORDER BY employee_id
LIMIT 10;

-- 해설: =는 같음, <>는 다름을 의미한다. PostgreSQL에서는 !=도 사용할 수 있다.

-- ------------------------------------------------------------------------------
-- [실습문제 13] 비교 연산자 > 와 <
-- ------------------------------------------------------------------------------
-- 문제: ① 급여가 700만 원 초과인 직원의 사번·급여를 조회하시오. ② 급여가 300만 원 미만인 직원의 사번·급여를 조회하시오. 각각 사번 순으로 표시하시오.
-- 학습 요소: > · <

-- [모범답안]
SELECT employee_id, salary
FROM employees
WHERE salary > 7000000
ORDER BY employee_id;

SELECT employee_id, salary
FROM employees
WHERE salary < 3000000
ORDER BY employee_id;

-- 해설: >와 <는 경계값 자체를 포함하지 않는다.

-- ------------------------------------------------------------------------------
-- [실습문제 14] 비교 연산자 >= 와 <=
-- ------------------------------------------------------------------------------
-- 문제: ① 급여가 500만 원 이상인 직원, ② 급여가 300만 원 이하인 직원의 사번·급여를 각각 사번 순으로 조회하시오.
-- 학습 요소: >= · <=

-- [모범답안]
SELECT employee_id, salary
FROM employees
WHERE salary >= 5000000
ORDER BY employee_id;

SELECT employee_id, salary
FROM employees
WHERE salary <= 3000000
ORDER BY employee_id;

-- 해설: >=와 <=는 경계값을 포함한다.

-- ------------------------------------------------------------------------------
-- [실습문제 15] AND 조건
-- ------------------------------------------------------------------------------
-- 문제: 재직 상태이며 급여가 600만 원 이상인 직원의 사번·이름·급여를 높은 급여 순으로 조회하시오. 동점이면 사번 오름차순.
-- 학습 요소: AND

-- [모범답안]
SELECT employee_id, first_name, salary
FROM employees
WHERE employment_status = '재직'
  AND salary >= 6000000
ORDER BY salary DESC, employee_id;

-- 해설: AND는 모든 조건을 만족한 행만 조회한다.

-- ------------------------------------------------------------------------------
-- [실습문제 16] OR 조건
-- ------------------------------------------------------------------------------
-- 문제: 부서 ID가 40 또는 50인 직원의 사번·부서를 사번 순으로 조회하시오.
-- 학습 요소: OR

-- [모범답안]
SELECT employee_id, department_id
FROM employees
WHERE department_id = 40
   OR department_id = 50
ORDER BY employee_id;

-- 해설: OR는 두 조건 중 하나 이상 참이면 조회한다.

-- ------------------------------------------------------------------------------
-- [실습문제 17] NOT 조건
-- ------------------------------------------------------------------------------
-- 문제: 퇴사 상태가 아닌 직원의 사번·상태를 사번 순으로 조회하시오. 처음 10명만 출력하시오.
-- 학습 요소: NOT

-- [모범답안]
SELECT employee_id, employment_status
FROM employees
WHERE NOT employment_status = '퇴사'
ORDER BY employee_id
LIMIT 10;

-- 해설: NOT은 조건을 부정한다. 일반적으로 NULL이 가능하면 UNKNOWN 처리에도 주의한다.

-- ------------------------------------------------------------------------------
-- [실습문제 18] AND/OR 우선순위와 괄호 비교
-- ------------------------------------------------------------------------------
-- 문제: ① 괄호 없이 "재직이고 40번 부서이거나 50번 부서" 조건을 작성하시오. ② "재직이며 (40번 또는 50번 부서)" 조건을 작성하시오. 두 SQL의 직원 수를 COUNT(*)로 비교하시오.
-- 학습 요소: AND · OR · 우선순위

-- [모범답안]
SELECT COUNT(*) AS ungrouped_count
FROM employees
WHERE employment_status = '재직'
  AND department_id = 40
   OR department_id = 50;

SELECT COUNT(*) AS grouped_count
FROM employees
WHERE employment_status = '재직'
  AND (department_id = 40 OR department_id = 50);

-- 해설: AND가 OR보다 먼저 평가된다. 첫 쿼리에는 50번 부서의 휴직자도 포함될 수 있다.

-- ------------------------------------------------------------------------------
-- [실습문제 19] WHERE에서 SELECT 별칭 사용 불가
-- ------------------------------------------------------------------------------
-- 문제: 연봉(salary * 12)을 annual_salary로 표시하고 연봉이 6천만 원을 초과하는 직원을 조회하시오. WHERE에서 annual_salary 별칭을 쓰지 말고 올바른 식을 사용하시오.
-- 학습 요소: WHERE · 별칭

-- [모범답안]
SELECT employee_id, salary * 12 AS annual_salary
FROM employees
WHERE salary * 12 > 60000000
ORDER BY annual_salary DESC, employee_id;

-- 해설: WHERE는 SELECT 별칭이 만들어지기 전에 논리적으로 평가되므로 원래 표현식을 적는다. ORDER BY에서는 별칭 사용 가능.

-- ------------------------------------------------------------------------------
-- [실습문제 20] IN으로 여러 부서 선택
-- ------------------------------------------------------------------------------
-- 문제: 부서번호가 40·50·60 중 하나인 직원의 사번·부서를 조회하고 부서·사번 순으로 정렬하시오.
-- 학습 요소: IN

-- [모범답안]
SELECT employee_id, department_id
FROM employees
WHERE department_id IN (40, 50, 60)
ORDER BY department_id, employee_id;

-- 해설: IN은 같은 열에 대한 여러 OR 조건을 간결하게 표현한다.

-- ------------------------------------------------------------------------------
-- [실습문제 21] NOT IN과 목록 속 NULL
-- ------------------------------------------------------------------------------
-- 문제: ① 부서가 40·50번이 아닌 직원을 조회하되 NULL 부서는 따로 포함하시오. ② NOT IN (40, NULL)을 사용할 때 왜 정상적인 다른 부서가 제외되는지 주석으로 설명하시오.
-- 학습 요소: NOT IN · NULL

-- [모범답안]
SELECT employee_id, department_id
FROM employees
WHERE department_id NOT IN (40, 50)
   OR department_id IS NULL
ORDER BY employee_id;

-- NOT IN (40, NULL)은 NULL과의 비교가 UNKNOWN이 되어
-- 부서 40이 아닌 행도 WHERE를 통과하지 못할 수 있다.

-- 해설: NOT IN의 값 목록에 NULL을 넣는 것은 위험하다. NULL 포함 여부는 IS NULL로 별도 검사한다.

-- ------------------------------------------------------------------------------
-- [실습문제 22] BETWEEN 숫자 범위
-- ------------------------------------------------------------------------------
-- 문제: 급여가 400만 원부터 600만 원까지(양 끝값 포함)인 직원의 사번·급여를 조회하고 급여 오름차순으로 정렬하시오.
-- 학습 요소: BETWEEN · 비교 경계

-- [모범답안]
SELECT employee_id, salary
FROM employees
WHERE salary BETWEEN 4000000 AND 6000000
ORDER BY salary, employee_id;

-- 해설: BETWEEN a AND b는 >= a AND <= b와 같다.

-- ------------------------------------------------------------------------------
-- [실습문제 23] BETWEEN DATE 범위
-- ------------------------------------------------------------------------------
-- 문제: 입사일이 2024-01-01부터 2024-12-31까지인 직원의 사번·이름·입사일을 입사일·사번 순으로 조회하시오.
-- 학습 요소: BETWEEN · DATE

-- [모범답안]
SELECT employee_id, first_name, hire_date
FROM employees
WHERE hire_date BETWEEN DATE '2024-01-01' AND DATE '2024-12-31'
ORDER BY hire_date, employee_id;

-- 해설: hire_date는 DATE형이므로 종료일도 포함된다.

-- ------------------------------------------------------------------------------
-- [실습문제 24] TIMESTAMP 종료일 포함의 함정
-- ------------------------------------------------------------------------------
-- 문제: 2024-12-31 오후 2시 30분이 ① BETWEEN 2024-01-01과 2024-12-31 사이인지, ② 2025-01-01 미만 범위에 해당하는지 각각 SQL로 확인하시오. (독립적인 TIMESTAMP 리터럴 사용)
-- 학습 요소: DATE · TIMESTAMP · BETWEEN

-- [모범답안]
SELECT TIMESTAMP '2024-12-31 14:30:00'
       BETWEEN TIMESTAMP '2024-01-01 00:00:00'
           AND TIMESTAMP '2024-12-31 00:00:00' AS between_result;

SELECT TIMESTAMP '2024-12-31 14:30:00' >= TIMESTAMP '2024-01-01'
   AND TIMESTAMP '2024-12-31 14:30:00' < TIMESTAMP '2025-01-01' AS half_open_result;

-- 해설: 첫 결과 FALSE, 둘째 TRUE. 시간까지 포함된 열은 시작 이상·다음 날 미만 방식이 안전하다.

-- ------------------------------------------------------------------------------
-- [실습문제 25] LIKE %: 접두·접미·포함 검색
-- ------------------------------------------------------------------------------
-- 문제: ① 이름이 '지'로 시작하는 직원 ② 이름이 '연'으로 끝나는 직원 ③ 이메일에 'hd-example'이 들어 있는 직원의 사번·해당 열을 각각 조회하시오.
-- 학습 요소: LIKE · %

-- [모범답안]
SELECT employee_id, first_name
FROM employees
WHERE first_name LIKE '지%'
ORDER BY employee_id;

SELECT employee_id, first_name
FROM employees
WHERE first_name LIKE '%연'
ORDER BY employee_id;

SELECT employee_id, email
FROM employees
WHERE email LIKE '%hd-example%'
ORDER BY employee_id
LIMIT 10;

-- 해설: %는 문자가 0개 이상 올 수 있다는 뜻이다. 시작/끝/포함 검색을 비교한다.

-- ------------------------------------------------------------------------------
-- [실습문제 26] LIKE _: 정확히 한 문자
-- ------------------------------------------------------------------------------
-- 문제: first_name이 '지'로 시작하고 정확히 두 글자인 직원과, 두 번째 글자가 '연'인 직원을 각각 검색하시오. 사번·이름을 출력하시오.
-- 학습 요소: LIKE · _

-- [모범답안]
SELECT employee_id, first_name
FROM employees
WHERE first_name LIKE '지_'
ORDER BY employee_id;

SELECT employee_id, first_name
FROM employees
WHERE first_name LIKE '_연'
ORDER BY employee_id;

-- 해설: _는 정확히 문자 1개와 매칭한다. LIKE는 패턴의 글자 수를 제한할 수 있다.

-- ------------------------------------------------------------------------------
-- [실습문제 27] ILIKE: 대소문자 무시
-- ------------------------------------------------------------------------------
-- 문제: 이메일에 employee12가 포함된 직원의 사번·이메일을 대문자 검색 패턴 EMPLOYEE12로 조회하시오. LIKE와 ILIKE의 차이를 주석으로 설명하시오.
-- 학습 요소: LIKE · ILIKE

-- [모범답안]
SELECT employee_id, email
FROM employees
WHERE email ILIKE '%EMPLOYEE12%'
ORDER BY employee_id;
-- ILIKE는 대소문자를 구분하지 않는 PostgreSQL 확장이다.
-- 같은 대문자 패턴을 LIKE에 넣으면 소문자 이메일을 찾지 못할 수 있다.

-- 해설: PostgreSQL의 ILIKE는 대소문자를 구분하지 않는다.


-- ==============================================================================
-- 소단원 03 | NULL과 대체 함수
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- [실습문제 28] NULL·0·빈 문자열의 차이
-- ------------------------------------------------------------------------------
-- 문제: SQL로 NULL, 숫자 0, 빈 문자열('')이 각각 NULL인지 IS NULL을 이용해 확인하시오. 세 결과 열의 별칭을 null_check, zero_check, empty_check로 하시오.
-- 학습 요소: NULL · 0 · 빈 문자열

-- [모범답안]
SELECT NULL IS NULL AS null_check,
       0 IS NULL AS zero_check,
       '' IS NULL AS empty_check;

-- 해설: PostgreSQL에서 NULL은 값 부재/미정, 0과 빈 문자열은 실제로 존재하는 값이다.

-- ------------------------------------------------------------------------------
-- [실습문제 29] IS NULL로 연락처 미등록자 조회
-- ------------------------------------------------------------------------------
-- 문제: 전화번호가 NULL인 직원의 사번·이름·전화번호를 사번 순으로 조회하시오.
-- 학습 요소: IS NULL

-- [모범답안]
SELECT employee_id, first_name, phone_number
FROM employees
WHERE phone_number IS NULL
ORDER BY employee_id;

-- 해설: = NULL 대신 IS NULL을 쓴다.

-- ------------------------------------------------------------------------------
-- [실습문제 30] IS NOT NULL로 연락처 등록자 조회
-- ------------------------------------------------------------------------------
-- 문제: 전화번호가 있는 직원의 수를 등록인원이라는 별칭으로 조회하시오.
-- 학습 요소: IS NOT NULL

-- [모범답안]
SELECT COUNT(*) AS 등록인원
FROM employees
WHERE phone_number IS NOT NULL;

-- 해설: IS NOT NULL은 NULL이 아닌 데이터만 검사한다.

-- ------------------------------------------------------------------------------
-- [실습문제 31] = NULL의 UNKNOWN 확인
-- ------------------------------------------------------------------------------
-- 문제: ① WHERE phone_number = NULL로 직원 수를 세어 보고 ② WHERE phone_number IS NULL로 다시 세어 보시오. 두 결과가 다른 이유를 주석으로 설명하시오.
-- 학습 요소: NULL · 3값 논리

-- [모범답안]
SELECT COUNT(*) AS equal_null_count
FROM employees
WHERE phone_number = NULL;

SELECT COUNT(*) AS is_null_count
FROM employees
WHERE phone_number IS NULL;

-- = NULL의 비교 결과는 UNKNOWN이다. WHERE는 TRUE인 행만 남긴다.

-- 해설: = NULL은 비교 결과가 UNKNOWN이라 원하는 NULL 행을 찾지 못한다.

-- ------------------------------------------------------------------------------
-- [실습문제 32] COALESCE로 미등록 연락처 표시
-- ------------------------------------------------------------------------------
-- 문제: 직원의 사번·이름·전화번호를 조회하되 번호가 NULL이면 '미등록'으로 표시하시오. 10명만 출력하시오.
-- 학습 요소: COALESCE

-- [모범답안]
SELECT employee_id, first_name,
       COALESCE(phone_number, '미등록') AS 연락처
FROM employees
ORDER BY employee_id
LIMIT 10;

-- 해설: COALESCE는 인수 중 첫 번째 NULL이 아닌 값을 반환한다.

-- ------------------------------------------------------------------------------
-- [실습문제 33] NULLIF: 값이 같으면 NULL
-- ------------------------------------------------------------------------------
-- 문제: NULLIF(0,0), NULLIF(2,0)의 결과를 확인하고, 10을 0으로 나누는 오류를 방지하는 표현식을 작성하시오.
-- 학습 요소: NULLIF

-- [모범답안]
SELECT NULLIF(0, 0) AS same_value,
       NULLIF(2, 0) AS different_value;

SELECT 10 / NULLIF(0, 0) AS safe_division;

-- 해설: NULLIF(a,b)는 a=b이면 NULL, 그렇지 않으면 a를 반환한다. 10/NULL은 오류 대신 NULL을 반환한다.

-- ------------------------------------------------------------------------------
-- [실습문제 34] NULL이 포함된 계산과 비교 결과
-- ------------------------------------------------------------------------------
-- 문제: NULL + 100, NULL || '문자', NULL = NULL의 결과를 각각 확인하시오.
-- 학습 요소: NULL · 연산

-- [모범답안]
SELECT NULL + 100 AS null_add,
       NULL || '문자' AS null_concat,
       NULL = NULL AS null_compare;

-- 해설: 일반적인 산술·연결·비교에서 NULL이 들어가면 결과가 NULL(UNKNOWN)이 된다. AND·OR는 3값 논리 예외가 있다.


-- ==============================================================================
-- 소단원 04 | 중복 제거 · 정렬 · 페이징
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- [실습문제 35] DISTINCT: 한 열 중복 제거
-- ------------------------------------------------------------------------------
-- 문제: employees에 존재하는 department_id를 중복 없이 조회하시오. NULL 부서는 제외하고 ID 오름차순으로 정렬하시오.
-- 학습 요소: DISTINCT

-- [모범답안]
SELECT DISTINCT department_id
FROM employees
WHERE department_id IS NOT NULL
ORDER BY department_id;

-- 해설: DISTINCT는 출력 결과에서 같은 부서 ID를 하나만 남긴다. 테이블의 원본 행은 삭제되지 않는다.

-- ------------------------------------------------------------------------------
-- [실습문제 36] DISTINCT: 두 열의 조합
-- ------------------------------------------------------------------------------
-- 문제: department_id와 job_id의 중복 없는 조합을 조회하시오. NULL 부서는 제외하고 부서·직무 순으로 정렬하시오.
-- 학습 요소: DISTINCT · 복수 열

-- [모범답안]
SELECT DISTINCT department_id, job_id
FROM employees
WHERE department_id IS NOT NULL
ORDER BY department_id, job_id;

-- 해설: DISTINCT는 두 열을 함께 판단해 중복된 조합만 제거한다.

-- ------------------------------------------------------------------------------
-- [실습문제 37] ORDER BY ASC·DESC
-- ------------------------------------------------------------------------------
-- 문제: ① 사번 오름차순 앞 5명 ② 급여 내림차순 앞 5명을 각각 출력하시오. 각각 사번·이름·급여를 표시하시오.
-- 학습 요소: ORDER BY · ASC · DESC

-- [모범답안]
SELECT employee_id, first_name, salary
FROM employees
ORDER BY employee_id ASC
LIMIT 5;

SELECT employee_id, first_name, salary
FROM employees
ORDER BY salary DESC, employee_id ASC
LIMIT 5;

-- 해설: ASC는 오름차순(기본), DESC는 내림차순이다. 동점을 위해 PK 보조 정렬이 유용하다.

-- ------------------------------------------------------------------------------
-- [실습문제 38] 여러 열로 정렬하기
-- ------------------------------------------------------------------------------
-- 문제: 부서가 배정된 직원의 사번·부서·급여를 조회하시오. 부서 오름차순, 같은 부서에서는 급여 내림차순, 동점은 사번 오름차순.
-- 학습 요소: ORDER BY 다중 정렬

-- [모범답안]
SELECT employee_id, department_id, salary
FROM employees
WHERE department_id IS NOT NULL
ORDER BY department_id ASC, salary DESC, employee_id ASC;

-- 해설: ORDER BY는 왼쪽부터 차례대로 정렬 기준을 적용한다.

-- ------------------------------------------------------------------------------
-- [실습문제 39] NULLS FIRST와 NULLS LAST
-- ------------------------------------------------------------------------------
-- 문제: commission_pct를 내림차순으로 정렬하여 ① NULL을 앞에 ② NULL을 뒤에 두는 SQL을 각각 작성하시오. 사번·수수료율을 10행씩 조회하시오.
-- 학습 요소: NULLS FIRST · NULLS LAST

-- [모범답안]
SELECT employee_id, commission_pct
FROM employees
ORDER BY commission_pct DESC NULLS FIRST, employee_id
LIMIT 10;

SELECT employee_id, commission_pct
FROM employees
ORDER BY commission_pct DESC NULLS LAST, employee_id
LIMIT 10;

-- 해설: PostgreSQL의 DESC 기본 NULL 위치는 FIRST이다. 필요하면 명시적으로 정한다.

-- ------------------------------------------------------------------------------
-- [실습문제 40] LIMIT으로 상위 N명 조회
-- ------------------------------------------------------------------------------
-- 문제: 급여가 높은 직원 10명을 사번·이름·급여로 출력하시오. 급여 동점은 사번 오름차순.
-- 학습 요소: LIMIT

-- [모범답안]
SELECT employee_id, first_name, salary
FROM employees
ORDER BY salary DESC, employee_id ASC
LIMIT 10;

-- 해설: ORDER BY가 없으면 상위 N명의 의미가 일정하지 않다.

-- ------------------------------------------------------------------------------
-- [실습문제 41] OFFSET: 1·2·3페이지 조회
-- ------------------------------------------------------------------------------
-- 문제: 직원을 사번 오름차순으로 정렬하여 한 페이지에 10명씩 1·2·3페이지를 각각 조회하시오. 사번·이름을 표시하시오.
-- 학습 요소: LIMIT · OFFSET

-- [모범답안]
SELECT employee_id, first_name FROM employees
ORDER BY employee_id LIMIT 10 OFFSET 0;

SELECT employee_id, first_name FROM employees
ORDER BY employee_id LIMIT 10 OFFSET 10;

SELECT employee_id, first_name FROM employees
ORDER BY employee_id LIMIT 10 OFFSET 20;

-- 해설: OFFSET = (페이지 번호 - 1) × 페이지당 행 수이다. ORDER BY로 순서를 고정한다.

-- ------------------------------------------------------------------------------
-- [실습문제 42] 정렬·중복·페이징 종합
-- ------------------------------------------------------------------------------
-- 문제: 재직 직원의 직무(job_id) 목록을 중복 없이 구하고 직무 코드 오름차순으로 정렬하여 앞의 5개만 조회하시오.
-- 학습 요소: DISTINCT · WHERE · ORDER BY · LIMIT

-- [모범답안]
SELECT DISTINCT job_id
FROM employees
WHERE employment_status = '재직'
ORDER BY job_id
LIMIT 5;

-- 해설: WHERE로 대상 행을 걸러낸 뒤 DISTINCT로 중복 제거하고 정렬·개수를 제한한다.

-- ------------------------------------------------------------------------------
-- [실습문제 43] SQL 가독성: 여러 절의 줄바꿈
-- ------------------------------------------------------------------------------
-- 문제: 재직 중이고 부서가 40 또는 50이며 급여가 500만 원 이상인 직원의 사번·부서·급여를 조회하시오. SQL 키워드·조건 괄호·들여쓰기를 사용하고 급여 내림차순 앞 5명을 표시하시오.
-- 학습 요소: SQL 가독성 · 종합

-- [모범답안]
SELECT employee_id, department_id, salary
FROM employees
WHERE employment_status = '재직'
  AND department_id IN (40, 50)
  AND salary >= 5000000
ORDER BY salary DESC, employee_id ASC
LIMIT 5;

-- 해설: 예약어 대문자, 선택 열 명시, 조건의 줄바꿈, 정렬 기준, LIMIT을 체계적으로 작성한다.

-- 문서 끝
