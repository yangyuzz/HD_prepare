-- ============================================================================
-- PostgreSQL 8장 서브쿼리 | 핵심 복습 | 교사용 정답·해설
-- 15문항 | UTF-8 | 독립형 서브쿼리 중심
-- ============================================================================
-- PostgreSQL / DBeaver 기준 · 데이터베이스: hd
-- 데이터: hd_sample_data.sql 적재 완료 기준 (employees 69명, departments 9개)
-- 안전: 모든 정상 실습/정답 쿼리는 SELECT만 사용하며 원본 데이터를 변경하지 않음
-- 실행: 원하는 SQL 한 문장에 커서를 두고 Ctrl+Enter로 실행
-- 안내: PostgreSQL의 출력 형식에 따라 숫자 표시 자릿수는 조금 달라질 수 있음
-- 주의: 학생용 ______ 빈칸은 완성해야 실행 가능; 오류 SQL은 주석이므로 실행하지 않음
-- 정렬: 기대 결과는 ORDER BY로 정렬된 초기 hd 샘플 데이터 기준
-- 제외: 상관 서브쿼리 및 외부 행 참조 사례는 문제·모범답안에 포함하지 않음

-- 전 문항 학생 직접 작성 / 아래 SQL 정답은 학생용 파일에는 들어 있지 않음

-- ============================================================================
-- 핵심 복습
-- ============================================================================

-- [복습 01] 평균값 계산  |  교안 p.5~7
-- 문제: 회사 전체 직원의 평균 급여를 소수점 두 자리까지 조회하시오.
-- [풀이 핵심] 집계 결과는 단일 값이다.
SELECT ROUND(AVG(salary), 2) AS avg_salary FROM employees;

-- [정답 결과 · 초기 hd]
-- | avg_salary |
-- | --- |
-- | 5,110,144.93 |
-- (전체 1행)

-- [복습 02] 평균 초과 직원  |  교안 p.5~7,9
-- 문제: 전체 평균 급여보다 급여가 높은 직원을 사번 순으로 조회하시오. (사번·이름·급여)
-- [풀이 핵심] WHERE 서브쿼리와 단일 값을 비교한다.
SELECT employee_id, first_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY employee_id;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | salary |
-- | --- | --- | --- |
-- | 100 | 민수 | 13300000 |
-- | 101 | 서연 | 8200000 |
-- | 102 | 지훈 | 8000000 |
-- | 103 | 수빈 | 7800000 |
-- ... 전체 28행 중 앞 4행 표시

-- [복습 03] 최고 급여자  |  교안 p.11~12
-- 문제: 급여가 전체 직원 중 가장 높은 직원의 사번·이름·급여를 조회하시오.
-- [풀이 핵심] MAX는 단일 값, = 비교 가능.
SELECT employee_id, first_name, salary
FROM employees
WHERE salary=(SELECT MAX(salary) FROM employees);

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | salary |
-- | --- | --- | --- |
-- | 100 | 민수 | 13300000 |
-- (전체 1행)

-- [복습 04] 다중 행에 = 오류 수정  |  교안 p.13~15
-- 문제: 다음 요구를 오류 없이 수행하시오: 판교(location_id=2) 부서의 직원 사번·이름·부서번호 조회. 서브쿼리에 IN을 사용하시오.
-- [풀이 핵심] 판교의 부서 목록은 2행이므로 = 대신 IN을 사용한다.
SELECT employee_id, first_name, department_id FROM employees
WHERE department_id IN (SELECT department_id FROM departments WHERE location_id=2)
ORDER BY employee_id;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | department_id |
-- | --- | --- | --- |
-- | 104 | 현우 | 40 |
-- | 105 | 지은 | 50 |
-- | 123 | 시우 | 40 |
-- | 124 | 민지 | 40 |
-- ... 전체 27행 중 앞 4행 표시

-- [복습 05] ANY 적용  |  교안 p.15~16
-- 문제: 영업 담당자의 급여 중 하나보다 큰 급여를 받는 직원이 몇 명인지 ANY로 구하시오.
-- [풀이 핵심] 하나라도 큰 관계가 성립하면 된다.
SELECT COUNT(*) AS employee_count FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE job_id='SALES');

-- [정답 결과 · 초기 hd]
-- | employee_count |
-- | --- |
-- | 57 |
-- (전체 1행)
-- [검산용 동등 조건] 현재 목록이 비어 있지 않고 NULL이 없으므로 MIN/MAX로 검산 가능
-- SELECT COUNT(*) AS employee_count FROM employees WHERE salary > (SELECT MIN(salary) FROM employees WHERE job_id='SALES');

-- [복습 06] ALL 적용  |  교안 p.15~16
-- 문제: 영업 담당자 모두보다 급여가 높은 직원 수를 ALL로 구하시오.
-- [풀이 핵심] 모든 영업 급여를 초과해야 한다.
SELECT COUNT(*) AS employee_count FROM employees
WHERE salary > ALL (SELECT salary FROM employees WHERE job_id='SALES');

-- [정답 결과 · 초기 hd]
-- | employee_count |
-- | --- |
-- | 25 |
-- (전체 1행)
-- [검산용 동등 조건] 현재 목록이 비어 있지 않고 NULL이 없으므로 MIN/MAX로 검산 가능
-- SELECT COUNT(*) AS employee_count FROM employees WHERE salary > (SELECT MAX(salary) FROM employees WHERE job_id='SALES');

-- [복습 07] IN 포함 검사  |  교안 p.18~19
-- 문제: 프로젝트에 한 번이라도 참여한 직원의 사번·이름을 IN으로 조회하시오.
-- [풀이 핵심] 참여기록의 사번 목록을 활용한다.
SELECT employee_id, first_name FROM employees
WHERE employee_id IN (SELECT employee_id FROM employee_projects)
ORDER BY employee_id;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name |
-- | --- | --- |
-- | 101 | 서연 |
-- | 102 | 지훈 |
-- | 103 | 수빈 |
-- | 104 | 현우 |
-- ... 전체 59행 중 앞 4행 표시

-- [복습 08] NOT IN과 NULL  |  교안 p.20~22
-- 문제: 직원이 없는 부서를 NOT IN으로 찾으시오. NULL 때문에 결과가 사라지지 않게 작성하시오.
-- [풀이 핵심] 내부 목록에서 NULL을 제외한다.
SELECT department_id, department_name FROM departments
WHERE department_id NOT IN (
    SELECT department_id FROM employees WHERE department_id IS NOT NULL
)
ORDER BY department_id;

-- [정답 결과 · 초기 hd]
-- | department_id | department_name |
-- | --- | --- |
-- | 90 | 신사업기획팀 |
-- (전체 1행)

-- [복습 09] EXISTS 독립 존재 검사  |  교안 p.23~24
-- 문제: 90번 부서가 데이터베이스에 존재하는지 EXISTS로 TRUE/FALSE를 조회하시오.
-- [풀이 핵심] 안쪽 쿼리는 독립적으로 실행 가능하다.
SELECT EXISTS (SELECT 1 FROM departments WHERE department_id=90) AS exists_dept;

-- [정답 결과 · 초기 hd]
-- | exists_dept |
-- | --- |
-- | TRUE |
-- (전체 1행)

-- [복습 10] NOT EXISTS 독립 존재 검사  |  교안 p.23~24
-- 문제: 999번 부서가 없는지를 NOT EXISTS로 TRUE/FALSE를 조회하시오.
-- [풀이 핵심] 안쪽이 0행이면 NOT EXISTS는 TRUE다.
SELECT NOT EXISTS (SELECT 1 FROM departments WHERE department_id=999) AS missing_dept;

-- [정답 결과 · 초기 hd]
-- | missing_dept |
-- | --- |
-- | 1 |
-- (전체 1행)

-- [복습 11] FROM 파생 테이블  |  교안 p.26~28
-- 문제: 부서별 평균 급여를 구한 뒤, 평균이 600만 원 초과인 부서번호와 평균 급여를 조회하시오. FROM 서브쿼리를 사용하시오.
-- [풀이 핵심] 안쪽에서 집계를 끝낸 결과를 t로 참조한다.
SELECT t.department_id, t.avg_salary
FROM (SELECT department_id, ROUND(AVG(salary),0) AS avg_salary
      FROM employees GROUP BY department_id) AS t
WHERE t.avg_salary > 6000000 ORDER BY t.department_id;

-- [정답 결과 · 초기 hd]
-- | department_id | avg_salary |
-- | --- | --- |
-- | 10 | 6,133,333 |
-- (전체 1행)

-- [복습 12] SELECT 스칼라  |  교안 p.29~30
-- 문제: 사번 100~102 직원의 급여 옆에 전체 평균 급여를 하나의 열로 추가하시오.
-- [풀이 핵심] 스칼라 결과가 각 행에 같은 값으로 표시된다.
SELECT employee_id, first_name, salary,
 (SELECT ROUND(AVG(salary),0) FROM employees) AS company_avg
FROM employees WHERE employee_id BETWEEN 100 AND 102
ORDER BY employee_id;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | salary | company_avg |
-- | --- | --- | --- | --- |
-- | 100 | 민수 | 13300000 | 5,110,145 |
-- | 101 | 서연 | 8200000 | 5,110,145 |
-- | 102 | 지훈 | 8000000 | 5,110,145 |
-- (전체 3행)

-- [복습 13] 스칼라 0행  |  교안 p.29,31
-- 문제: SELECT 절 안에 부서번호 999번의 부서명을 찾는 스칼라 서브쿼리를 넣고 결과를 확인하시오.
-- [풀이 핵심] 0행을 반환하므로 NULL이다.
SELECT (SELECT department_name FROM departments WHERE department_id=999) AS missing_dept_name;

-- [정답 결과 · 초기 hd]
-- | missing_dept_name |
-- | --- |
-- | NULL |
-- (전체 1행)

-- [복습 14] HAVING 집계 서브쿼리  |  교안 p.8,32
-- 문제: 부서별 평균 급여가 전체 직원 평균보다 높은 부서번호·평균 급여를 조회하시오. HAVING에 서브쿼리를 사용하시오.
-- [풀이 핵심] 집계된 부서 결과를 단일 회사 평균과 비교한다.
SELECT department_id, ROUND(AVG(salary),0) AS avg_salary
FROM employees WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees)
ORDER BY department_id;

-- [정답 결과 · 초기 hd]
-- | department_id | avg_salary |
-- | --- | --- |
-- | 10 | 6,133,333 |
-- | 40 | 5,743,750 |
-- | 50 | 5,381,818 |
-- (전체 3행)

-- [복습 15] JOIN과 IN의 행 수  |  교안 p.33~34
-- 문제: JOIN 후 직원-프로젝트 참여 기록 수와 IN으로 조회한 고유 참여 직원 수를 각각 조회하시오.
-- [풀이 핵심] JOIN 결과에는 같은 직원이 여러 번 나타날 수 있다.
SELECT COUNT(*) AS join_rows FROM employees e
JOIN employee_projects ep ON e.employee_id=ep.employee_id;

-- [비교 실행 SQL]
SELECT COUNT(*) AS in_count FROM employees
WHERE employee_id IN (SELECT employee_id FROM employee_projects);

-- [정답 결과 · 초기 hd]
-- | join_rows |
-- | --- |
-- | 102 |
-- (전체 1행)
-- [두 번째 SQL 결과]
-- | in_count |
-- | --- |
-- | 59 |
-- (전체 1행)

