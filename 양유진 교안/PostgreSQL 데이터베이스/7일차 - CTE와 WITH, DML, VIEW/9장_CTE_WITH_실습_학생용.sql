-- ================================================================================
-- PostgreSQL 9장: CTE와 WITH 문 | 수업 실습 | 학생용
-- 수업 DB: hd  /  사용 테이블: employees, departments, jobs, projects, employee_projects
-- 모든 문장은 조회(SELECT) 전용이며 데이터를 변경하지 않습니다.
-- 문항을 위에서 아래 순서대로 실행하세요. 두 개의 조회문은 각각 따로 실행합니다.
-- ★ 상관 서브쿼리, DML, VIEW 실습은 포함하지 않습니다.
-- ================================================================================
-- 학생용: 수업 실습의 ____ 부분만 완성하면 됩니다. 복습·과제는 아래에 직접 작성하세요.


----------------------------------------------------------------------------------
-- 실습-01 | WITH 기본 구조: 부서별 평균급여
-- [교안 참고] 9~11페이지
-- WITH 절에서 부서별 인원과 평균급여를 계산한 뒤 평균급여가 높은 부서 4개를 조회한다. 첫 줄의 키워드를 완성한
-- 다음 실행한다.
-- [직접 입력] 아래 ____를 완성한 다음 실행하세요.
____ dept_salary AS (
    SELECT department_id,
           COUNT(*) AS staff_count,
           ROUND(AVG(salary), 0) AS avg_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
SELECT department_id, staff_count, avg_salary
FROM dept_salary
ORDER BY avg_salary DESC, department_id
LIMIT 4;
-- 힌트: 빈칸 1곳 · 이 SQL 문이 끝나면 dept_salary라는 이름을 다음 SQL에서 사용할 수 없다.

-- [기대 출력 예시: 일부 행]
-- 전체 4행
-- department_id | staff_count | avg_salary
-- --------------+-------------+-----------
-- 10            | 6           | 6133333   
-- 40            | 16          | 5743750   
-- ...

----------------------------------------------------------------------------------
-- 실습-02 | 파생 테이블과 CTE: 같은 결과 비교
-- [교안 참고] 5,12~14페이지
-- 아래 두 SELECT를 각각 실행한다. 둘 다 부서 평균급여 500만 원 이상인 부서만 조회하는지 확인한다.
-- [따라 실행] 아래 완성된 SQL을 실행하세요.
-- ① 파생 테이블 방식: 괄호 안 SELECT부터 읽는다.
SELECT t.department_id, t.avg_salary
FROM (
    SELECT department_id, ROUND(AVG(salary), 0) AS avg_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
) AS t
WHERE t.avg_salary >= 5000000
ORDER BY t.department_id;

-- ② WITH 방식: 위에서 이름을 정의하고 아래에서 사용한다.
WITH dept_salary AS (
    SELECT department_id, ROUND(AVG(salary), 0) AS avg_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
SELECT department_id, avg_salary
FROM dept_salary
WHERE avg_salary >= 5000000
ORDER BY department_id;

-- [기대 출력 예시: 일부 행]
-- 1번째 SELECT 결과
-- 전체 4행
-- department_id | avg_salary
-- --------------+-----------
-- 10            | 6133333   
-- 40            | 5743750   
-- ...
-- 2번째 SELECT 결과
-- 전체 4행
-- department_id | avg_salary
-- --------------+-----------
-- 10            | 6133333   
-- 40            | 5743750   
-- ...

----------------------------------------------------------------------------------
-- 실습-03 | 여러 CTE: 먼저 정의한 결과를 다음 단계에서 사용
-- [교안 참고] 17~19페이지
-- 부서별 평균급여를 만든 뒤, 부서 평균급여들의 전체 평균보다 높은 부서를 조회한다. 두 번째 CTE가 첫 번째
-- CTE를 참조할 부분을 완성한다.
-- [직접 입력] 아래 ____를 완성한 다음 실행하세요.
WITH dept_stats AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
),
baseline AS (
    SELECT AVG(avg_salary) AS avg_dept_salary
    FROM ____
)
SELECT department_id, ROUND(avg_salary, 0) AS avg_salary
FROM dept_stats
WHERE avg_salary > (SELECT avg_dept_salary FROM baseline)
ORDER BY department_id;
-- 힌트: 빈칸 1곳 · 두 번째 CTE의 FROM은 앞 단계 CTE 이름이다.

-- [기대 출력 예시: 일부 행]
-- 전체 4행
-- department_id | avg_salary
-- --------------+-----------
-- 10            | 6133333   
-- 40            | 5743750   
-- ...

----------------------------------------------------------------------------------
-- 실습-04 | CTE의 참조 방향과 존재 범위
-- [교안 참고] 6~7,17,20페이지
-- 올바른 순서의 두 CTE를 실행하고, 주석 속 잘못된 참조 방향을 관찰한다. 오류 SQL은 직접 실행하지 않는다.
-- [따라 실행] 아래 완성된 SQL을 실행하세요.
-- 가능: 먼저 정의한 dept_stats를 뒤의 higher_depts가 사용
WITH dept_stats AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
),
higher_depts AS (
    SELECT department_id, avg_salary
    FROM dept_stats
    WHERE avg_salary >= 5000000
)
SELECT department_id, ROUND(avg_salary, 0) AS avg_salary
FROM higher_depts
ORDER BY department_id;

-- [실행하지 않는 오류 예시]
-- WITH later_cte AS (SELECT * FROM first_cte),
--      first_cte AS (SELECT department_id FROM departments)
-- SELECT * FROM later_cte;
-- 일반적인 비재귀 WITH는 뒤에 정의한 first_cte를 앞에서 참조할 수 없다.
-- 위 SQL 문을 끝낸 뒤 SELECT * FROM dept_stats; 만 실행해도 CTE는 존재하지 않는다.

-- [기대 출력 예시: 일부 행]
-- 전체 4행
-- department_id | avg_salary
-- --------------+-----------
-- 10            | 6133333   
-- 40            | 5743750   
-- ...

----------------------------------------------------------------------------------
-- 실습-05 | CTE + JOIN: 프로젝트 참여 많은 직원
-- [교안 참고] 21페이지
-- 직원별 프로젝트 참여 건수를 CTE로 계산하고, 직원 이름을 JOIN해 참여 3건 이상인 직원만 조회한다. 연결할
-- 테이블과 키를 완성한다.
-- [직접 입력] 아래 ____를 완성한 다음 실행하세요.
WITH participation AS (
    SELECT employee_id, COUNT(*) AS project_count
    FROM employee_projects
    GROUP BY employee_id
)
SELECT e.employee_id, e.first_name, p.project_count
FROM participation p
JOIN ____ e ON p.employee_id = e.____
WHERE p.project_count >= 3
ORDER BY p.project_count DESC, e.employee_id;
-- 힌트: 빈칸 2곳 · 직원 테이블 employees와 직원 번호 employee_id로 연결한다.

-- [기대 출력 예시: 일부 행]
-- 전체 8행
-- employee_id | first_name | project_count
-- ------------+------------+--------------
-- 123         | 시우         | 8            
-- 124         | 민지         | 5            
-- ...

----------------------------------------------------------------------------------
-- 실습-06 | 하나의 CTE를 두 번 참조하기
-- [교안 참고] 22페이지
-- 같은 부서별 평균급여 CTE를 최대값 계산과 최소값 계산에 각각 재사용한다.
-- [따라 실행] 아래 완성된 SQL을 실행하세요.
WITH dept_stats AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
SELECT ROUND((SELECT MAX(avg_salary) FROM dept_stats), 0) AS max_avg_salary,
       ROUND((SELECT MIN(avg_salary) FROM dept_stats), 0) AS min_avg_salary;

-- [기대 출력 예시: 일부 행]
-- 전체 1행
-- max_avg_salary | min_avg_salary
-- ---------------+---------------
-- 6133333        | 4216667       

----------------------------------------------------------------------------------
-- 실습-07 | 단계별 디버깅: 중간 결과 확인
-- [교안 참고] 24~25페이지
-- 1단계에서 부서별 직원 수 전체를 확인하고, 2단계에서 직원 10명 이상인 부서만 조회한다. 두 쿼리를 순서대로
-- 실행한다.
-- [따라 실행] 아래 완성된 SQL을 실행하세요.
-- ① 중간 결과 8개 부서 확인
WITH dept_stats AS (
    SELECT department_id, COUNT(*) AS staff_count
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
SELECT * FROM dept_stats ORDER BY department_id;

-- ② 조건을 추가해 최종 결과 확인
WITH dept_stats AS (
    SELECT department_id, COUNT(*) AS staff_count
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
SELECT * FROM dept_stats
WHERE staff_count >= 10
ORDER BY department_id;

-- [기대 출력 예시: 일부 행]
-- 1번째 SELECT 결과
-- 전체 8행
-- department_id | staff_count
-- --------------+------------
-- 10            | 6          
-- 20            | 6          
-- ...
-- 2번째 SELECT 결과
-- 전체 2행
-- department_id | staff_count
-- --------------+------------
-- 40            | 16         
-- 50            | 11         

----------------------------------------------------------------------------------
-- 실습-08 | CTE + JOIN 활용: 프로젝트 참여 인원
-- [교안 참고] 21,24~26페이지
-- 프로젝트별 참여 인원을 CTE로 세고 프로젝트명을 JOIN한 뒤, 참여 인원이 많은 상위 5개 프로젝트를 조회한다.
-- [따라 실행] 아래 완성된 SQL을 실행하세요.
WITH project_counts AS (
    SELECT project_id, COUNT(*) AS participant_count
    FROM employee_projects
    GROUP BY project_id
)
SELECT p.project_id, p.project_name, pc.participant_count
FROM project_counts pc
JOIN projects p ON pc.project_id = p.project_id
ORDER BY pc.participant_count DESC, p.project_id
LIMIT 5;

-- [기대 출력 예시: 일부 행]
-- 전체 5행
-- project_id | project_name | participant_count
-- -----------+--------------+------------------
-- 3          | 생산 데이터 대시보드  | 9                
-- 2          | 통합 인사정보 시스템  | 8                
-- ...

-- 파일 끝
