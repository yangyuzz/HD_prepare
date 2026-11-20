-- ============================================================================
-- PostgreSQL 8장 서브쿼리 | 수업 실습 | 교사용 정답·해설
-- 43문항 | UTF-8 | 독립형 서브쿼리 중심
-- ============================================================================
-- PostgreSQL / DBeaver 기준 · 데이터베이스: hd
-- 데이터: hd_sample_data.sql 적재 완료 기준 (employees 69명, departments 9개)
-- 안전: 모든 정상 실습/정답 쿼리는 SELECT만 사용하며 원본 데이터를 변경하지 않음
-- 실행: 원하는 SQL 한 문장에 커서를 두고 Ctrl+Enter로 실행
-- 안내: PostgreSQL의 출력 형식에 따라 숫자 표시 자릿수는 조금 달라질 수 있음
-- 주의: 학생용 ______ 빈칸은 완성해야 실행 가능; 오류 SQL은 주석이므로 실행하지 않음
-- 정렬: 기대 결과는 ORDER BY로 정렬된 초기 hd 샘플 데이터 기준
-- 제외: 상관 서브쿼리 및 외부 행 참조 사례는 문제·모범답안에 포함하지 않음

-- 진행: 수업 중 실행 중심 / 핵심 구문 빈칸 완성 11문항
-- 교안의 4개 소단원 순서로 실습 진행

-- ============================================================================
-- 01 서브쿼리 기초
-- ============================================================================

-- [실습 01] 원본 행 수와 평균 급여  |  교안 p.5~7
-- 문제: employees 전체 행 수와 평균 급여를 확인한다.
-- [풀이 핵심] 전체 직원 수 69명, 평균 급여 5,110,144.93원. 평균은 결과 1행·1열이므로 비교값으로 사용할 수 있다.
SELECT COUNT(*) AS employee_count,
       ROUND(AVG(salary), 2) AS avg_salary
FROM employees;

-- [정답 결과 · 초기 hd]
-- | employee_count | avg_salary |
-- | --- | --- |
-- | 69 | 5,110,144.93 |
-- (전체 1행)

-- [실습 02] 안쪽 결과 먼저 확인  |  교안 p.6~7
-- 문제: 안쪽 SELECT만 실행하여 평균 급여를 먼저 확인한다.
-- [풀이 핵심] 독립형 서브쿼리는 안쪽 SQL을 따로 실행하여 결과를 확인할 수 있다.
SELECT AVG(salary) AS company_avg
FROM employees;

-- [정답 결과 · 초기 hd]
-- | company_avg |
-- | --- |
-- | 5,110,144.93 |
-- (전체 1행)

-- [실습 03] 평균을 넘는 직원  |  교안 p.5~7,9
-- 문제: 평균 급여보다 급여가 높은 직원의 사번·이름·급여를 조회한다.
-- [풀이 핵심] 안쪽 평균 급여가 바깥 WHERE의 비교값으로 사용되며 28명이다.
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

-- [실습 04] 직접 입력 vs 서브쿼리  |  교안 p.6,9
-- 문제: 수동으로 고정한 평균값과 서브쿼리의 차이를 비교한다.
-- [풀이 핵심] 수업 현재 데이터에서 28명이며, 나중에 급여가 바뀌어도 평균이 자동으로 재계산된다.
SELECT COUNT(*) AS dynamic_result
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- [비교 실행 SQL]
SELECT COUNT(*) AS fixed_result
FROM employees WHERE salary > 5110144.927536231;

-- [정답 결과 · 초기 hd]
-- | dynamic_result |
-- | --- |
-- | 28 |
-- (전체 1행)
-- [두 번째 SQL 결과]
-- | fixed_result |
-- | --- |
-- | 28 |
-- (전체 1행)

-- [실습 05] 단계별 흐름: 안쪽→바깥  |  교안 p.7
-- 문제: 안쪽 급여 최대값 확인 후 바깥에서 최대 급여자를 찾는다.
-- [풀이 핵심] 안쪽 SELECT가 MAX를 1개 반환하고 바깥 조회에 적용한다.
SELECT employee_id, first_name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees)
ORDER BY employee_id;

-- [비교 실행 SQL]
SELECT MAX(salary) AS max_salary FROM employees;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | salary |
-- | --- | --- | --- |
-- | 100 | 민수 | 13300000 |
-- (전체 1행)
-- [두 번째 SQL 결과]
-- | max_salary |
-- | --- |
-- | 13300000 |
-- (전체 1행)

-- [실습 06] WHERE 사용 위치  |  교안 p.8
-- 문제: 부서 40번의 직원 평균보다 급여가 높은 직원을 찾는다.
-- [풀이 핵심] WHERE 절에 서브쿼리의 단일 값을 조건으로 놓는다.
SELECT employee_id, first_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary) FROM employees WHERE department_id = 40
)
ORDER BY employee_id;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | salary |
-- | --- | --- | --- |
-- | 100 | 민수 | 13300000 |
-- | 101 | 서연 | 8200000 |
-- | 102 | 지훈 | 8000000 |
-- | 103 | 수빈 | 7800000 |
-- ... 전체 21행 중 앞 4행 표시

-- [실습 07] FROM 사용 위치 맛보기  |  교안 p.8
-- 문제: 부서별 직원 수를 안쪽에서 계산하고 바깥에서 10명 이상인 부서만 조회한다.
-- [풀이 핵심] FROM 절의 결과는 t라는 테이블처럼 다시 조회할 수 있다.
SELECT t.department_id, t.employee_count
FROM (
    SELECT department_id, COUNT(*) AS employee_count
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
) AS t
WHERE t.employee_count >= 10
ORDER BY t.department_id;

-- [정답 결과 · 초기 hd]
-- | department_id | employee_count |
-- | --- | --- |
-- | 40 | 16 |
-- | 50 | 11 |
-- (전체 2행)

-- [실습 08] SELECT 사용 위치 맛보기  |  교안 p.8
-- 문제: 직원 3명 옆에 전체 평균 급여를 같은 값으로 출력한다.
-- [풀이 핵심] 스칼라 서브쿼리는 결과 열 하나를 추가한다.
SELECT employee_id, first_name, salary,
       (SELECT ROUND(AVG(salary), 0) FROM employees) AS company_avg
FROM employees
ORDER BY employee_id
LIMIT 3;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | salary | company_avg |
-- | --- | --- | --- | --- |
-- | 100 | 민수 | 13300000 | 5,110,145 |
-- | 101 | 서연 | 8200000 | 5,110,145 |
-- | 102 | 지훈 | 8000000 | 5,110,145 |
-- (전체 3행)

-- [실습 09] HAVING 사용 위치 맛보기  |  교안 p.8
-- 문제: 부서별 평균이 전체 평균보다 높은 부서번호를 찾는다.
-- [풀이 핵심] HAVING은 GROUP BY로 묶인 결과를 필터링한다.
SELECT department_id, ROUND(AVG(salary), 0) AS department_avg
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees)
ORDER BY department_id;

-- [정답 결과 · 초기 hd]
-- | department_id | department_avg |
-- | --- | --- |
-- | 10 | 6,133,333 |
-- | 40 | 5,743,750 |
-- | 50 | 5,381,818 |
-- (전체 3행)

-- ============================================================================
-- 02 단일/다중 행
-- ============================================================================

-- [실습 10] 최고 급여자 = MAX  |  교안 p.11~12
-- 문제: 최고 급여를 받은 직원의 사번·이름·급여를 조회한다.
-- [풀이 핵심] 단일 값과 =로 비교한다. 100번 민수 한 명이 검색된다.
SELECT employee_id, first_name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | salary |
-- | --- | --- | --- |
-- | 100 | 민수 | 13300000 |
-- (전체 1행)

-- [실습 11] 최고 급여가 아닌 직원 <>  |  교안 p.11
-- 문제: 최고 급여가 아닌 직원 수를 조회한다.
-- [풀이 핵심] <>는 다름 비교이다. 최고 급여자 1명을 제외해 68명이다.
SELECT COUNT(*) AS not_max_salary_count
FROM employees
WHERE salary <> (SELECT MAX(salary) FROM employees);

-- [정답 결과 · 초기 hd]
-- | not_max_salary_count |
-- | --- |
-- | 68 |
-- (전체 1행)

-- [실습 12] 기준값보다 작은 급여 <  |  교안 p.11~12
-- 문제: 전체 직원 평균 급여보다 작은 직원 중 급여가 가장 낮은 5명을 조회한다.
-- [풀이 핵심] < 연산자에 단일 결과를 적용한 사례이다.
SELECT employee_id, first_name, salary
FROM employees
WHERE salary < (SELECT AVG(salary) FROM employees)
ORDER BY salary, employee_id
LIMIT 5;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | salary |
-- | --- | --- | --- |
-- | 167 | 소율 | 2200000 |
-- | 168 | 보라 | 2200000 |
-- | 137 | 수아 | 2300000 |
-- | 147 | 하은 | 2300000 |
-- ... 전체 5행 중 앞 4행 표시

-- [실습 13] 최소 기준 이상 >=  |  교안 p.11
-- 문제: 영업 담당자의 최저 급여 이상인 직원 수를 조회한다.
-- [풀이 핵심] 서브쿼리 MIN 결과는 단일 값이며 >= 연산자를 사용할 수 있다.
SELECT COUNT(*) AS at_least_sales_min
FROM employees
WHERE salary >= (
    SELECT MIN(salary) FROM employees WHERE job_id = 'SALES'
);

-- [정답 결과 · 초기 hd]
-- | at_least_sales_min |
-- | --- |
-- | 59 |
-- (전체 1행)

-- [실습 14] 다중 행 = 오류와 IN 해결  |  교안 p.13~14,35
-- 문제: 판교 소재 부서 목록이 2행인 것을 확인하고, =의 오류를 IN으로 해결한다.
-- [풀이 핵심] 다중 행 결과는 단일 값 비교(=) 대신 IN으로 비교한다.
SELECT employee_id, first_name, department_id
FROM employees
WHERE department_id IN (
    SELECT department_id FROM departments WHERE location_id = 2
)
ORDER BY employee_id;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | department_id |
-- | --- | --- | --- |
-- | 104 | 현우 | 40 |
-- | 105 | 지은 | 50 |
-- | 123 | 시우 | 40 |
-- | 124 | 민지 | 40 |
-- ... 전체 27행 중 앞 4행 표시

-- [실습 15] 안쪽 결과 행 개수 확인  |  교안 p.13~14
-- 문제: 판교 부서 목록 자체를 조회하여 어떤 값이 반환되는지 확인한다.
-- [풀이 핵심] 안쪽 결과가 40, 50 두 행이다.
SELECT department_id, department_name
FROM departments
WHERE location_id = 2
ORDER BY department_id;

-- [정답 결과 · 초기 hd]
-- | department_id | department_name |
-- | --- | --- |
-- | 40 | 개발팀 |
-- | 50 | 데이터분석팀 |
-- (전체 2행)

-- [실습 16] ANY: 하나라도  |  교안 p.15~16
-- 문제: 영업 담당자 급여 중 하나보다 높은 급여의 직원 수를 구한다.
-- [풀이 핵심] ANY는 하나의 값만 조건을 충족해도 TRUE다. 현재 영업 급여 최저 370만 원보다 높으면 된다.
SELECT COUNT(*) AS higher_than_any_sales
FROM employees
WHERE salary > ANY (
    SELECT salary FROM employees WHERE job_id = 'SALES'
);

-- [정답 결과 · 초기 hd]
-- | higher_than_any_sales |
-- | --- |
-- | 57 |
-- (전체 1행)
-- [검산용 동등 조건] 현재 목록이 비어 있지 않고 NULL이 없으므로 MIN/MAX로 검산 가능
-- SELECT COUNT(*) AS higher_than_any_sales FROM employees WHERE salary > (SELECT MIN(salary) FROM employees WHERE job_id='SALES');

-- [실습 17] ALL: 모두  |  교안 p.15~16
-- 문제: 영업 담당자 모두보다 급여가 높은 직원 수를 구한다.
-- [풀이 핵심] ALL은 모든 값보다 커야 한다. 현재 영업 급여 최댓값 520만 원을 초과해야 한다.
SELECT COUNT(*) AS higher_than_all_sales
FROM employees
WHERE salary > ALL (
    SELECT salary FROM employees WHERE job_id = 'SALES'
);

-- [정답 결과 · 초기 hd]
-- | higher_than_all_sales |
-- | --- |
-- | 25 |
-- (전체 1행)
-- [검산용 동등 조건] 현재 목록이 비어 있지 않고 NULL이 없으므로 MIN/MAX로 검산 가능
-- SELECT COUNT(*) AS higher_than_all_sales FROM employees WHERE salary > (SELECT MAX(salary) FROM employees WHERE job_id='SALES');

-- [실습 18] SOME과 ANY는 동의어  |  교안 p.15~16
-- 문제: SOME과 ANY가 같은 결과를 반환하는지 비교한다.
-- [풀이 핵심] SOME은 ANY와 같은 뜻이다.
SELECT COUNT(*) AS higher_than_some_sales
FROM employees
WHERE salary > SOME (
    SELECT salary FROM employees WHERE job_id = 'SALES'
);

-- [정답 결과 · 초기 hd]
-- | higher_than_some_sales |
-- | --- |
-- | 57 |
-- (전체 1행)
-- [검산용 동등 조건] 현재 목록이 비어 있지 않고 NULL이 없으므로 MIN/MAX로 검산 가능
-- SELECT COUNT(*) AS higher_than_some_sales FROM employees WHERE salary > (SELECT MIN(salary) FROM employees WHERE job_id='SALES');

-- ============================================================================
-- 03 IN/NOT IN/EXISTS
-- ============================================================================

-- [실습 19] IN: 판교 부서 목록  |  교안 p.18~19
-- 문제: 판교(위치 2) 부서에 소속된 직원의 사번·이름·부서번호를 조회한다.
-- [풀이 핵심] 목록 {40, 50}에 포함되는 직원 27명이다.
SELECT employee_id, first_name, department_id
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments WHERE location_id = 2
)
ORDER BY employee_id;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | department_id |
-- | --- | --- | --- |
-- | 104 | 현우 | 40 |
-- | 105 | 지은 | 50 |
-- | 123 | 시우 | 40 |
-- | 124 | 민지 | 40 |
-- ... 전체 27행 중 앞 4행 표시

-- [실습 20] IN: 목록 중복이 있어도 직원 중복 없음  |  교안 p.18~19
-- 문제: 프로젝트 참여 사번 목록에서 중복이 있어도 직원 원본은 한 번씩 조회되는지 확인한다.
-- [풀이 핵심] 프로젝트 참여기록은 102행이지만 IN 결과 직원은 59명이다.
SELECT employee_id, first_name
FROM employees
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

-- [실습 21] IN: 프로젝트 1 또는 2  |  교안 p.18~19
-- 문제: 1·2번 프로젝트 중 하나라도 참여한 직원을 조회한다.
-- [풀이 핵심] 집합 목록의 중복은 직원 결과에 영향을 주지 않으므로 14명이다.
SELECT employee_id, first_name
FROM employees
WHERE employee_id IN (
    SELECT employee_id FROM employee_projects
    WHERE project_id IN (1,2)
)
ORDER BY employee_id;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name |
-- | --- | --- |
-- | 102 | 지훈 |
-- | 104 | 현우 |
-- | 113 | 유진 |
-- | 114 | 지민 |
-- ... 전체 14행 중 앞 4행 표시

-- [실습 22] NOT IN 함정 관찰  |  교안 p.20~21
-- 문제: 직원 없는 부서를 찾으려는 NOT IN이 왜 0행인지 확인한다.
-- [풀이 핵심] 직원 중 department_id NULL이 2개 있어 빈 결과가 반환된다. 이는 직원 없는 부서가 없다는 뜻이 아니다.
SELECT department_id, department_name
FROM departments
WHERE department_id NOT IN (
    SELECT department_id FROM employees
)
ORDER BY department_id;

-- [정답 결과 · 초기 hd]
-- | department_id | department_name |
-- | --- | --- |
-- (전체 0행)

-- [실습 23] NULL 값 직접 확인  |  교안 p.20~21
-- 문제: NOT IN 안쪽 목록에 NULL이 몇 개인지 검사한다.
-- [풀이 핵심] 부서가 배정되지 않은 직원은 2명이다.
SELECT COUNT(*) AS null_department_count
FROM employees
WHERE department_id IS NULL;

-- [정답 결과 · 초기 hd]
-- | null_department_count |
-- | --- |
-- | 2 |
-- (전체 1행)

-- [실습 24] 안전한 NOT IN  |  교안 p.20~22
-- 문제: NULL을 제거한 뒤 직원이 한 명도 없는 부서를 찾는다.
-- [풀이 핵심] NULL을 걸러 90번 신사업기획팀 1행이 나타난다.
SELECT department_id, department_name
FROM departments
WHERE department_id NOT IN (
    SELECT department_id
    FROM employees
    WHERE department_id IS NOT NULL
)
ORDER BY department_id;

-- [정답 결과 · 초기 hd]
-- | department_id | department_name |
-- | --- | --- |
-- | 90 | 신사업기획팀 |
-- (전체 1행)

-- [실습 25] NOT IN: 값과 NULL 판정  |  교안 p.20~21
-- 문제: 직접 비교를 통해 NOT IN 목록에 NULL이 섞일 때와 없을 때를 비교한다.
-- [풀이 핵심] 왼쪽은 UNKNOWN(NULL), 오른쪽은 TRUE다.
SELECT 90 NOT IN (10, 20, NULL) AS null_in_list,
       90 NOT IN (10, 20) AS filtered_list;

-- [정답 결과 · 초기 hd]
-- | null_in_list | filtered_list |
-- | --- | --- |
-- | NULL | TRUE |
-- (전체 1행)

-- [실습 26] EXISTS: 결과 행이 존재  |  교안 p.23~24
-- 문제: 90번 부서가 존재하면 TRUE를 반환하도록 작성한다.
-- [풀이 핵심] 독립형 SELECT가 한 행을 반환하므로 TRUE다. 외부 행 참조는 없다.
SELECT EXISTS (
    SELECT 1 FROM departments WHERE department_id = 90
) AS exists_dept_90;

-- [정답 결과 · 초기 hd]
-- | exists_dept_90 |
-- | --- |
-- | TRUE |
-- (전체 1행)

-- [실습 27] NOT EXISTS: 결과 행이 없음  |  교안 p.23~24
-- 문제: 999번 부서가 없으면 TRUE를 반환하도록 작성한다.
-- [풀이 핵심] 내부 결과가 0행이라 TRUE다. 상관 서브쿼리가 아니다.
SELECT NOT EXISTS (
    SELECT 1 FROM departments WHERE department_id = 999
) AS not_exists_dept_999;

-- [정답 결과 · 초기 hd]
-- | not_exists_dept_999 |
-- | --- |
-- | TRUE |
-- (전체 1행)

-- [실습 28] EXISTS에서 SELECT 1 / *  |  교안 p.23~24
-- 문제: EXISTS의 SELECT 목록을 바꿔도 존재 여부는 같은지 비교한다.
-- [풀이 핵심] 실제 출력 열의 값보다 결과 행이 있는지가 중요하다.
SELECT EXISTS (SELECT 1 FROM departments WHERE location_id = 2)
       AS exists_with_one;

-- [비교 실행 SQL]
SELECT EXISTS (SELECT * FROM departments WHERE location_id = 2) AS exists_with_star;

-- [정답 결과 · 초기 hd]
-- | exists_with_one |
-- | --- |
-- | TRUE |
-- (전체 1행)
-- [두 번째 SQL 결과]
-- | exists_with_star |
-- | --- |
-- | TRUE |
-- (전체 1행)

-- [실습 29] IN과 EXISTS는 다른 질문  |  교안 p.23~24
-- 문제: IN은 40번 부서 소속 여부를, EXISTS는 40번 부서가 존재하는지 확인한다.
-- [풀이 핵심] IN은 각 직원의 부서번호를 검사한다.
SELECT COUNT(*) AS employees_in_dept_40
FROM employees
WHERE department_id IN (
    SELECT department_id FROM departments WHERE department_id=40
);

-- [비교 실행 SQL]
SELECT EXISTS (SELECT 1 FROM departments WHERE department_id=40) AS dept_40_exists;

-- [정답 결과 · 초기 hd]
-- | employees_in_dept_40 |
-- | --- |
-- | 16 |
-- (전체 1행)
-- [두 번째 SQL 결과]
-- | dept_40_exists |
-- | --- |
-- | TRUE |
-- (전체 1행)

-- [실습 30] NOT EXISTS: 독립 조건이 FALSE일 때  |  교안 p.23~24
-- 문제: 반대로 존재하는 부서를 NOT EXISTS로 검사하면 FALSE인지 확인한다.
-- [풀이 핵심] 90번 부서가 있으므로 NOT EXISTS는 FALSE다.
SELECT NOT EXISTS (
    SELECT 1 FROM departments WHERE department_id = 90
) AS not_exists_90;

-- [정답 결과 · 초기 hd]
-- | not_exists_90 |
-- | --- |
-- | FALSE |
-- (전체 1행)

-- ============================================================================
-- 04 FROM/SELECT/HAVING
-- ============================================================================

-- [실습 31] FROM: 부서별 평균급여 파생 테이블  |  교안 p.26~28
-- 문제: 부서별 평균을 먼저 구한 뒤 평균 600만 원 초과 부서를 다시 조회한다.
-- [풀이 핵심] 파생 테이블에 AS t 별칭을 사용한다. 조건을 통과하는 부서는 10번이다.
SELECT t.department_id, t.avg_salary
FROM (
    SELECT department_id, ROUND(AVG(salary), 0) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS t
WHERE t.avg_salary > 6000000
ORDER BY t.department_id;

-- [정답 결과 · 초기 hd]
-- | department_id | avg_salary |
-- | --- | --- |
-- | 10 | 6,133,333 |
-- (전체 1행)

-- [실습 32] 파생 테이블 집계 과정만 실행  |  교안 p.26~28
-- 문제: 파생 테이블 내부 GROUP BY만 따로 실행하여 부서별 평균을 본다.
-- [풀이 핵심] 부서번호 NULL 그룹까지 총 9그룹이다.
SELECT department_id, ROUND(AVG(salary), 0) AS avg_salary,
       COUNT(*) AS headcount
FROM employees
GROUP BY department_id
ORDER BY department_id NULLS LAST;

-- [정답 결과 · 초기 hd]
-- | department_id | avg_salary | headcount |
-- | --- | --- | --- |
-- | 10 | 6,133,333 | 6 |
-- | 20 | 4,350,000 | 6 |
-- | 30 | 4,866,667 | 6 |
-- | 40 | 5,743,750 | 16 |
-- ... 전체 9행 중 앞 4행 표시

-- [실습 33] FROM: 직무별 집계 재조회  |  교안 p.26~28
-- 문제: 직무별 직원 수를 먼저 계산한 뒤 5명 이상인 직무만 선택한다.
-- [풀이 핵심] 집계가 끝난 결과를 바깥 WHERE가 필터링한다.
SELECT t.job_id, t.headcount
FROM (
    SELECT job_id, COUNT(*) AS headcount
    FROM employees
    GROUP BY job_id
) AS t
WHERE t.headcount >= 5
ORDER BY t.headcount DESC, t.job_id;

-- [정답 결과 · 초기 hd]
-- | job_id | headcount |
-- | --- | --- |
-- | DEV | 14 |
-- | DATA | 9 |
-- | MANAGER | 8 |
-- | SALES | 8 |
-- ... 전체 8행 중 앞 4행 표시

-- [실습 34] SELECT: 스칼라 평균 급여 열  |  교안 p.29~30
-- 문제: 각 직원 급여 옆에 회사 전체 평균 급여를 출력한다.
-- [풀이 핵심] 스칼라 결과값 5,110,145원이 각 행에 반복된다.
SELECT employee_id, first_name, salary,
       (SELECT ROUND(AVG(salary),0) FROM employees) AS overall_avg
FROM employees
ORDER BY salary DESC, employee_id
LIMIT 5;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | salary | overall_avg |
-- | --- | --- | --- | --- |
-- | 100 | 민수 | 13300000 | 5,110,145 |
-- | 101 | 서연 | 8200000 | 5,110,145 |
-- | 102 | 지훈 | 8000000 | 5,110,145 |
-- | 104 | 현우 | 8000000 | 5,110,145 |
-- ... 전체 5행 중 앞 4행 표시

-- [실습 35] SELECT: 평균과 급여의 차이  |  교안 p.29~30
-- 문제: 상위 5명 급여에서 회사 평균을 뺀 차이를 표시한다.
-- [풀이 핵심] 전체 평균값 1개를 계산한 다음 직원별 급여에서 차감한다.
SELECT employee_id, first_name, salary,
       ROUND(salary - (SELECT AVG(salary) FROM employees),0) AS diff_from_avg
FROM employees
ORDER BY salary DESC, employee_id
LIMIT 5;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name | salary | diff_from_avg |
-- | --- | --- | --- | --- |
-- | 100 | 민수 | 13300000 | 8,189,855 |
-- | 101 | 서연 | 8200000 | 3,089,855 |
-- | 102 | 지훈 | 8000000 | 2,889,855 |
-- | 104 | 현우 | 8000000 | 2,889,855 |
-- ... 전체 5행 중 앞 4행 표시

-- [실습 36] 스칼라 결과가 0행일 때  |  교안 p.29,31
-- 문제: 없는 부서를 스칼라 서브쿼리로 조회하면 NULL이 반환되는지 확인한다.
-- [풀이 핵심] 스칼라 위치에서 0행은 NULL이다.
SELECT (
    SELECT department_name
    FROM departments WHERE department_id=999
) AS missing_department;

-- [정답 결과 · 초기 hd]
-- | missing_department |
-- | --- |
-- | NULL |
-- (전체 1행)

-- [실습 37] 스칼라 다중 행 오류 안전하게 보기  |  교안 p.29,31,35
-- 문제: 두 행을 반환하는 스칼라 서브쿼리 오류를 이해하고 COUNT로 단일 값화한다.
-- [풀이 핵심] 오류 예시: SELECT (SELECT department_name FROM departments WHERE location_id=2); → 두 행 반환. COUNT(*)로 1행 반환하도록 해결.
SELECT (
    SELECT COUNT(*)
    FROM departments WHERE location_id=2
) AS pangyo_department_count;

-- [정답 결과 · 초기 hd]
-- | pangyo_department_count |
-- | --- |
-- | 2 |
-- (전체 1행)

-- [실습 38] HAVING 안에 전체 평균 비교  |  교안 p.8,32
-- 문제: 부서별 평균 급여가 회사 전체 평균보다 높은 부서를 찾는다.
-- [풀이 핵심] HAVING은 그룹별 계산값을 외부의 독립 집계값과 비교한다.
SELECT department_id, ROUND(AVG(salary), 0) AS avg_salary
FROM employees
WHERE department_id IS NOT NULL
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

-- [실습 39] JOIN 결과와 IN 결과 비교  |  교안 p.33~34
-- 문제: 참여 기록 기준 JOIN은 102행, IN은 고유 직원 59행임을 확인한다.
-- [풀이 핵심] JOIN은 1:N 관계에서 직원이 반복된다.
SELECT COUNT(*) AS joined_rows,
       COUNT(DISTINCT e.employee_id) AS distinct_employees
FROM employees e
JOIN employee_projects ep ON e.employee_id=ep.employee_id;

-- [비교 실행 SQL]
SELECT COUNT(*) AS in_employees
FROM employees
WHERE employee_id IN (SELECT employee_id FROM employee_projects);

-- [정답 결과 · 초기 hd]
-- | joined_rows | distinct_employees |
-- | --- | --- |
-- | 102 | 59 |
-- (전체 1행)
-- [두 번째 SQL 결과]
-- | in_employees |
-- | --- |
-- | 59 |
-- (전체 1행)

-- [실습 40] JOIN + DISTINCT와 IN 비교  |  교안 p.33~34
-- 문제: 직원별 참여 목록을 두 방식으로 출력해 같은지 확인한다.
-- [풀이 핵심] JOIN + DISTINCT와 IN은 둘 다 고유 참여 직원 59명의 목록이다.
SELECT DISTINCT e.employee_id, e.first_name
FROM employees e
JOIN employee_projects ep ON e.employee_id=ep.employee_id
ORDER BY e.employee_id
LIMIT 5;

-- [비교 실행 SQL]
SELECT employee_id, first_name
FROM employees
WHERE employee_id IN (SELECT employee_id FROM employee_projects)
ORDER BY employee_id LIMIT 5;

-- [정답 결과 · 초기 hd]
-- | employee_id | first_name |
-- | --- | --- |
-- | 101 | 서연 |
-- | 102 | 지훈 |
-- | 103 | 수빈 |
-- | 104 | 현우 |
-- ... 전체 5행 중 앞 4행 표시
-- [두 번째 SQL 결과]
-- | employee_id | first_name |
-- | --- | --- |
-- | 101 | 서연 |
-- | 102 | 지훈 |
-- | 103 | 수빈 |
-- ... 전체 5행 중 앞 3행 표시

-- [실습 41] 중첩 서브쿼리: 안에서 밖으로  |  교안 p.35~36
-- 문제: 안쪽에서 부서별 평균을 구하고, 500만 원 초과로 다시 필터링한 뒤 정렬한다.
-- [풀이 핵심] t1 집계 → t2 필터 → 바깥 정렬의 세 단계 순서로 해석한다.
SELECT department_id, avg_salary
FROM (
    SELECT department_id, avg_salary
    FROM (
        SELECT department_id, AVG(salary) AS avg_salary
        FROM employees GROUP BY department_id
    ) AS t1
    WHERE avg_salary > 5000000
) AS t2
ORDER BY avg_salary DESC, department_id NULLS LAST;

-- [정답 결과 · 초기 hd]
-- | department_id | avg_salary |
-- | --- | --- |
-- | 10 | 6,133,333.33 |
-- | 40 | 5,743,750 |
-- | 50 | 5,381,818.18 |
-- | 70 | 5,100,000 |
-- (전체 4행)

-- ============================================================================
-- 05 마무리 확인
-- ============================================================================

-- [실습 42] <= 비교 연산자  |  교안 p.11
-- 문제: 영업 담당자 최고 급여 이하인 직원 수를 <= 서브쿼리로 조회한다.
-- [풀이 핵심] 단일 값 MAX의 결과와 <= 연산자를 함께 사용할 수 있다.
SELECT COUNT(*) AS sales_max_or_lower
FROM employees
WHERE salary <= (SELECT MAX(salary) FROM employees WHERE job_id='SALES');

-- [정답 결과 · 초기 hd]
-- | sales_max_or_lower |
-- | --- |
-- | 44 |
-- (전체 1행)

-- [실습 43] 스칼라 2열 오류를 1열로 수정  |  교안 p.29,31,35
-- 문제: 스칼라 서브쿼리가 2개 열을 반환하면 오류라는 점을 확인하고, 부서명을 1개 열로 조회한다.
-- [풀이 핵심] 스칼라 위치는 1열·최대 1행이어야 한다. 아래의 2열 예제는 실행하면 오류가 발생하므로 주석으로만 제시한다.
SELECT (
    SELECT department_name FROM departments WHERE department_id=90
) AS department_name;

-- [정답 결과 · 초기 hd]
-- | department_name |
-- | --- |
-- | 신사업기획팀 |
-- (전체 1행)

