-- ================================================================================
-- PostgreSQL 9장: CTE와 WITH 문 | 수업 실습 | 교사용 정답·해설
-- 수업 DB: hd  /  사용 테이블: employees, departments, jobs, projects, employee_projects
-- 모든 문장은 조회(SELECT) 전용이며 데이터를 변경하지 않습니다.
-- 문항을 위에서 아래 순서대로 실행하세요. 두 개의 조회문은 각각 따로 실행합니다.
-- ★ 상관 서브쿼리, DML, VIEW 실습은 포함하지 않습니다.
-- ================================================================================
-- 교사용: 모범답안은 여러 형태가 가능합니다. 아래는 대표적인 한 가지 풀이입니다.


----------------------------------------------------------------------------------
-- 실습-01 | WITH 기본 구조: 부서별 평균급여
-- [교안 참고] 9~11페이지
-- WITH 절에서 부서별 인원과 평균급여를 계산한 뒤 평균급여가 높은 부서 4개를 조회한다. 첫 줄의 키워드를 완성한
-- 다음 실행한다.

-- [정답 SQL]
WITH dept_salary AS (
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
-- 해설: 정답: WITH. CTE는 CREATE TABLE과 달리 영구 테이블을 생성하지 않는다.

-- [실제 데이터 기반 예상 결과]
-- 전체 4행
-- department_id | staff_count | avg_salary
-- --------------+-------------+-----------
-- 10            | 6           | 6133333   
-- 40            | 16          | 5743750   
-- 50            | 11          | 5381818   
-- 70            | 7           | 5100000   

----------------------------------------------------------------------------------
-- 실습-02 | 파생 테이블과 CTE: 같은 결과 비교
-- [교안 참고] 5,12~14페이지
-- 아래 두 SELECT를 각각 실행한다. 둘 다 부서 평균급여 500만 원 이상인 부서만 조회하는지 확인한다.

-- [정답 SQL]
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
-- 해설: 두 SELECT는 동일한 4행을 반환한다. CTE의 장점은 가독성이지 무조건적인 성능 향상이 아니다.

-- [실제 데이터 기반 예상 결과]
-- 1번째 SELECT 결과
-- 전체 4행
-- department_id | avg_salary
-- --------------+-----------
-- 10            | 6133333   
-- 40            | 5743750   
-- 50            | 5381818   
-- 70            | 5100000   
-- 2번째 SELECT 결과
-- 전체 4행
-- department_id | avg_salary
-- --------------+-----------
-- 10            | 6133333   
-- 40            | 5743750   
-- 50            | 5381818   
-- 70            | 5100000   

----------------------------------------------------------------------------------
-- 실습-03 | 여러 CTE: 먼저 정의한 결과를 다음 단계에서 사용
-- [교안 참고] 17~19페이지
-- 부서별 평균급여를 만든 뒤, 부서 평균급여들의 전체 평균보다 높은 부서를 조회한다. 두 번째 CTE가 첫 번째
-- CTE를 참조할 부분을 완성한다.

-- [정답 SQL]
WITH dept_stats AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
),
baseline AS (
    SELECT AVG(avg_salary) AS avg_dept_salary
    FROM dept_stats
)
SELECT department_id, ROUND(avg_salary, 0) AS avg_salary
FROM dept_stats
WHERE avg_salary > (SELECT avg_dept_salary FROM baseline)
ORDER BY department_id;
-- 해설: 정답: dept_stats. baseline은 부서별 평균급여의 평균을 구하며, 단일 값 서브쿼리는 독립형이다.

-- [실제 데이터 기반 예상 결과]
-- 전체 4행
-- department_id | avg_salary
-- --------------+-----------
-- 10            | 6133333   
-- 40            | 5743750   
-- 50            | 5381818   
-- 70            | 5100000   

----------------------------------------------------------------------------------
-- 실습-04 | CTE의 참조 방향과 존재 범위
-- [교안 참고] 6~7,17,20페이지
-- 올바른 순서의 두 CTE를 실행하고, 주석 속 잘못된 참조 방향을 관찰한다. 오류 SQL은 직접 실행하지 않는다.

-- [정답 SQL]
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
-- 해설: 참조 방향은 앞에서 뒤로. CTE 이름은 같은 SQL 문 내부에서만 유효하다.

-- [실제 데이터 기반 예상 결과]
-- 전체 4행
-- department_id | avg_salary
-- --------------+-----------
-- 10            | 6133333   
-- 40            | 5743750   
-- 50            | 5381818   
-- 70            | 5100000   

----------------------------------------------------------------------------------
-- 실습-05 | CTE + JOIN: 프로젝트 참여 많은 직원
-- [교안 참고] 21페이지
-- 직원별 프로젝트 참여 건수를 CTE로 계산하고, 직원 이름을 JOIN해 참여 3건 이상인 직원만 조회한다. 연결할
-- 테이블과 키를 완성한다.

-- [정답 SQL]
WITH participation AS (
    SELECT employee_id, COUNT(*) AS project_count
    FROM employee_projects
    GROUP BY employee_id
)
SELECT e.employee_id, e.first_name, p.project_count
FROM participation p
JOIN employees e ON p.employee_id = e.employee_id
WHERE p.project_count >= 3
ORDER BY p.project_count DESC, e.employee_id;
-- 해설: 정답: employees, employee_id. CTE가 만든 집계 결과에도 JOIN을 적용할 수 있다.

-- [실제 데이터 기반 예상 결과]
-- 전체 8행
-- employee_id | first_name | project_count
-- ------------+------------+--------------
-- 123         | 시우         | 8            
-- 124         | 민지         | 5            
-- 138         | 주원         | 5            
-- 139         | 혜원         | 5            
-- 140         | 연우         | 5            
-- 104         | 현우         | 3            
-- ...

----------------------------------------------------------------------------------
-- 실습-06 | 하나의 CTE를 두 번 참조하기
-- [교안 참고] 22페이지
-- 같은 부서별 평균급여 CTE를 최대값 계산과 최소값 계산에 각각 재사용한다.

-- [정답 SQL]
WITH dept_stats AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
SELECT ROUND((SELECT MAX(avg_salary) FROM dept_stats), 0) AS max_avg_salary,
       ROUND((SELECT MIN(avg_salary) FROM dept_stats), 0) AS min_avg_salary;
-- 해설: 하나의 SELECT 문 안에서 같은 CTE를 두 번 참조할 수 있다.

-- [실제 데이터 기반 예상 결과]
-- 전체 1행
-- max_avg_salary | min_avg_salary
-- ---------------+---------------
-- 6133333        | 4216667       

----------------------------------------------------------------------------------
-- 실습-07 | 단계별 디버깅: 중간 결과 확인
-- [교안 참고] 24~25페이지
-- 1단계에서 부서별 직원 수 전체를 확인하고, 2단계에서 직원 10명 이상인 부서만 조회한다. 두 쿼리를 순서대로
-- 실행한다.

-- [정답 SQL]
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
-- 해설: 2단계의 40, 50 부서만 남는지 확인. 각 SQL 문마다 CTE를 새로 선언한다.

-- [실제 데이터 기반 예상 결과]
-- 1번째 SELECT 결과
-- 전체 8행
-- department_id | staff_count
-- --------------+------------
-- 10            | 6          
-- 20            | 6          
-- 30            | 6          
-- 40            | 16         
-- 50            | 11         
-- 60            | 9          
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

-- [정답 SQL]
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
-- 해설: 프로젝트 참여 테이블의 행 단위를 이해하면서 CTE 계산을 JOIN에 재사용하는 마무리 실습.

-- [실제 데이터 기반 예상 결과]
-- 전체 5행
-- project_id | project_name | participant_count
-- -----------+--------------+------------------
-- 3          | 생산 데이터 대시보드  | 9                
-- 2          | 통합 인사정보 시스템  | 8                
-- 6          | 해외 영업시장 조사   | 8                
-- 7          | 고객 문의 자동 분류  | 8                
-- 10         | 모바일 서비스 개편   | 8                

-- 파일 끝
