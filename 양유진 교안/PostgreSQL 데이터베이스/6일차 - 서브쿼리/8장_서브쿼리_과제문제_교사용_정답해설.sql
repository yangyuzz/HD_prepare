-- ============================================================================
-- PostgreSQL 8장 서브쿼리 | 응용 과제 | 교사용 정답·해설
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
-- 응용 과제
-- ============================================================================

-- [과제 01] MANAGER 평균 초과  |  교안 p.6~7,11~12
-- 문제: MANAGER 직무의 평균 급여보다 급여가 높은 직원의 사번·이름·직무·급여를 조회하시오. 급여 높은 순으로 정렬하시오.
-- [풀이 핵심] 안쪽에서 MANAGER 평균 1개를 만든다.
SELECT employee_id, first_name, job_id, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees WHERE job_id='MANAGER')
ORDER BY salary DESC, employee_id;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | job_id | salary |
-- | --- | --- | --- | --- |
-- | 100 | 민수 | CEO | 13300000 |
-- | 101 | 서연 | MANAGER | 8200000 |
-- | 102 | 지훈 | MANAGER | 8000000 |
-- | 104 | 현우 | MANAGER | 8000000 |
-- (전체 4행)

-- [과제 02] 평균 미만 직원 수  |  교안 p.5~7
-- 문제: 전체 평균 급여보다 급여가 낮은 직원은 몇 명인지 서브쿼리로 조회하시오.
-- [풀이 핵심] 반대 비교 < 사용.
SELECT COUNT(*) AS below_avg
FROM employees WHERE salary < (SELECT AVG(salary) FROM employees);

-- [정답 결과 · 초기 hd]
-- | below_avg |
-- | --- |
-- | 41 |
-- (전체 1행)

-- [과제 03] 개발 직무 최고 급여  |  교안 p.11~12
-- 문제: DEV 직무에서 최고 급여와 같은 급여를 받는 직원의 사번·이름·급여를 조회하시오.
-- [풀이 핵심] 직무를 제한한 뒤 그 직무 최대 급여와 비교한다.
SELECT employee_id, first_name, salary
FROM employees
WHERE job_id='DEV' AND salary = (
  SELECT MAX(salary) FROM employees WHERE job_id='DEV'
)
ORDER BY employee_id;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | salary |
-- | --- | --- | --- |
-- | 124 | 민지 | 6800000 |
-- | 146 | 준혁 | 6800000 |
-- (전체 2행)

-- [과제 04] 서울 소재 부서 직원  |  교안 p.18~19
-- 문제: 도시(city)가 서울인 부서에 속한 직원 사번·이름·부서번호를 조회하시오. locations → departments를 안쪽에서 연결한 IN 서브쿼리를 사용하시오.
-- [풀이 핵심] 독립형 서브쿼리 안에도 JOIN을 사용할 수 있다.
SELECT employee_id, first_name, department_id
FROM employees
WHERE department_id IN (
    SELECT d.department_id FROM departments d
    JOIN locations l ON d.location_id=l.location_id
    WHERE l.city='서울'
)
ORDER BY employee_id;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | department_id |
-- | --- | --- | --- |
-- | 100 | 민수 | 10 |
-- | 101 | 서연 | 10 |
-- | 102 | 지훈 | 20 |
-- | 103 | 수빈 | 30 |
-- ... 전체 34행 중 앞 4행 표시

-- [과제 05] 재직 중인 프로젝트 참여자  |  교안 p.18~19
-- 문제: 프로젝트 참여 경험이 있는 재직 직원의 사번·이름을 IN으로 조회하시오.
-- [풀이 핵심] 상태 조건과 IN 목록 조건을 함께 사용한다.
SELECT employee_id, first_name
FROM employees WHERE employment_status='재직'
 AND employee_id IN (SELECT employee_id FROM employee_projects)
ORDER BY employee_id;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name |
-- | --- | --- |
-- | 101 | 서연 |
-- | 102 | 지훈 |
-- | 103 | 수빈 |
-- | 104 | 현우 |
-- ... 전체 55행 중 앞 4행 표시

-- [과제 06] 프로젝트 미참여 직원  |  교안 p.20~22
-- 문제: 프로젝트에 한 번도 참여하지 않은 직원의 사번·이름을 NOT IN으로 조회하시오.
-- [풀이 핵심] 참여 테이블의 employee_id는 NOT NULL PK로 NULL이 없다.
SELECT employee_id, first_name
FROM employees
WHERE employee_id NOT IN (
    SELECT employee_id FROM employee_projects
)
ORDER BY employee_id;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name |
-- | --- | --- |
-- | 100 | 민수 |
-- | 126 | 은우 |
-- | 128 | 정우 |
-- | 129 | 채원 |
-- ... 전체 10행 중 앞 4행 표시

-- [과제 07] 직원 없는 부서  |  교안 p.20~22
-- 문제: 직원이 없는 부서의 부서번호와 부서명을 NOT IN으로 조회하시오. NULL을 안전하게 처리하시오.
-- [풀이 핵심] NOT IN의 내부 NULL 제거가 필수다.
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

-- [과제 08] ALL과 직무 필터  |  교안 p.15~16
-- 문제: 영업직 전체 급여보다 높은 급여를 받는 직원 중 영업직이 아닌 직원 수를 ALL로 구하시오.
-- [풀이 핵심] 영업직 급여 모두를 넘겨야 하고 바깥에서 영업직 제외.
SELECT COUNT(*) AS non_sales_above_all_sales
FROM employees
WHERE job_id <> 'SALES'
  AND salary > ALL (SELECT salary FROM employees WHERE job_id='SALES');

-- [정답 결과 · 초기 hd]
-- | non_sales_above_all_sales |
-- | --- |
-- | 25 |
-- (전체 1행)
-- [검산용 동등 조건] 현재 목록이 비어 있지 않고 NULL이 없으므로 MIN/MAX로 검산 가능
-- SELECT COUNT(*) AS non_sales_above_all_sales FROM employees WHERE job_id <> 'SALES' AND salary > (SELECT MAX(salary) FROM employees WHERE job_id='SALES');

-- [과제 09] ANY로 급여 범위 비교  |  교안 p.15~16
-- 문제: DATA 직무 급여 중 하나보다 급여가 높은 직원 수를 ANY로 구하시오.
-- [풀이 핵심] DATA 최저급여보다 큰 직원들이 포함된다.
SELECT COUNT(*) AS higher_than_any_data FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE job_id='DATA');

-- [정답 결과 · 초기 hd]
-- | higher_than_any_data |
-- | --- |
-- | 41 |
-- (전체 1행)
-- [검산용 동등 조건] 현재 목록이 비어 있지 않고 NULL이 없으므로 MIN/MAX로 검산 가능
-- SELECT COUNT(*) AS higher_than_any_data FROM employees WHERE salary > (SELECT MIN(salary) FROM employees WHERE job_id='DATA');

-- [과제 10] 독립 EXISTS 진위값  |  교안 p.23~24
-- 문제: 판교(location_id=2)에 부서가 하나라도 있는지 EXISTS로 TRUE/FALSE를 확인하시오.
-- [풀이 핵심] 안쪽 결과에 행이 하나라도 있는가를 확인한다.
SELECT EXISTS(SELECT 1 FROM departments WHERE location_id=2) AS has_pangyo_department;

-- [정답 결과 · 초기 hd]
-- | has_pangyo_department |
-- | --- |
-- | TRUE |
-- (전체 1행)

-- [과제 11] 부서 직원 수 파생 테이블  |  교안 p.26~28
-- 문제: 부서별 직원 수를 FROM 서브쿼리로 계산하고 인원 10명 이상인 부서번호·직원 수를 조회하시오.
-- [풀이 핵심] 집계 후 WHERE에서 계산된 headcount를 필터한다.
SELECT t.department_id, t.headcount
FROM (
    SELECT department_id, COUNT(*) AS headcount
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
) AS t
WHERE t.headcount >= 10
ORDER BY t.headcount DESC, t.department_id;

-- [정답 결과 · 초기 hd]
-- | department_id | headcount |
-- | --- | --- |
-- | 40 | 16 |
-- | 50 | 11 |
-- (전체 2행)

-- [과제 12] 직무 평균급여 파생 테이블  |  교안 p.26~28
-- 문제: 직무별 평균 급여를 계산한 파생 테이블에서 평균이 550만 원 이상인 직무와 평균 급여를 구하시오. 평균 높은 순 정렬.
-- [풀이 핵심] 집계표를 파생 테이블로 만든 뒤 한 번 더 필터.
SELECT t.job_id, t.avg_salary
FROM (
    SELECT job_id, ROUND(AVG(salary),0) AS avg_salary
    FROM employees GROUP BY job_id
) AS t
WHERE t.avg_salary >= 5500000
ORDER BY t.avg_salary DESC, t.job_id;

-- [정답 결과 · 초기 hd]
-- | job_id | avg_salary |
-- | --- | --- |
-- | CEO | 13,300,000 |
-- | MANAGER | 7,900,000 |
-- | DEV | 5,892,857 |
-- (전체 3행)

-- [과제 13] 급여와 전체 평균 차이  |  교안 p.29~30
-- 문제: 급여 높은 직원 5명을 뽑아 사번·이름·급여·전체 평균·평균과의 차이를 표시하시오. SELECT 스칼라 서브쿼리를 사용하시오.
-- [풀이 핵심] 전체 평균 단일 값을 출력 컬럼과 계산식에서 활용한다.
SELECT employee_id, first_name, salary,
 (SELECT ROUND(AVG(salary),0) FROM employees) AS company_avg,
 ROUND(salary-(SELECT AVG(salary) FROM employees),0) AS diff_from_avg
FROM employees ORDER BY salary DESC, employee_id LIMIT 5;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | salary | company_avg | diff_from_avg |
-- | --- | --- | --- | --- | --- |
-- | 100 | 민수 | 13300000 | 5,110,145 | 8,189,855 |
-- | 101 | 서연 | 8200000 | 5,110,145 | 3,089,855 |
-- | 102 | 지훈 | 8000000 | 5,110,145 | 2,889,855 |
-- | 104 | 현우 | 8000000 | 5,110,145 | 2,889,855 |
-- ... 전체 5행 중 앞 4행 표시

-- [과제 14] HAVING으로 부서 평균 비교  |  교안 p.8,32
-- 문제: 직원이 속한 부서 중 회사 전체 평균보다 평균 급여가 높은 부서를 조회하시오. 평균 높은 순으로 정렬하시오.
-- [풀이 핵심] 안쪽 회사 평균을 HAVING에 넣는다.
SELECT department_id, ROUND(AVG(salary),0) AS avg_salary
FROM employees WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees)
ORDER BY avg_salary DESC, department_id;

-- [정답 결과 · 초기 hd]
-- | department_id | avg_salary |
-- | --- | --- |
-- | 10 | 6,133,333 |
-- | 40 | 5,743,750 |
-- | 50 | 5,381,818 |
-- (전체 3행)

-- [과제 15] 중첩 파생 테이블  |  교안 p.26~28,35~36
-- 문제: 부서별 평균을 먼저 구하고 500만 원을 초과하는 부서만 남긴 뒤 평균 급여 높은 순으로 정렬하시오. FROM 서브쿼리 두 겹(t1,t2)을 사용하시오.
-- [풀이 핵심] 안쪽 집계 t1 → 중간 필터 t2 → 바깥 정렬의 순서로 이해한다.
SELECT t2.department_id, t2.avg_salary
FROM (
    SELECT t1.department_id, t1.avg_salary
    FROM (
        SELECT department_id, ROUND(AVG(salary),0) AS avg_salary
        FROM employees
        WHERE department_id IS NOT NULL
        GROUP BY department_id
    ) AS t1
    WHERE t1.avg_salary > 5000000
) AS t2
ORDER BY t2.avg_salary DESC, t2.department_id;

-- [정답 결과 · 초기 hd]
-- | department_id | avg_salary |
-- | --- | --- |
-- | 10 | 6,133,333 |
-- | 40 | 5,743,750 |
-- | 50 | 5,381,818 |
-- | 70 | 5,100,000 |
-- (전체 4행)

