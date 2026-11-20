-- ================================================================================
-- PostgreSQL 9장: CTE와 WITH 문 | 과제문제 | 교사용 정답·해설
-- 수업 DB: hd  /  사용 테이블: employees, departments, jobs, projects, employee_projects
-- 모든 문장은 조회(SELECT) 전용이며 데이터를 변경하지 않습니다.
-- 문항을 위에서 아래 순서대로 실행하세요. 두 개의 조회문은 각각 따로 실행합니다.
-- ★ 상관 서브쿼리, DML, VIEW 실습은 포함하지 않습니다.
-- ================================================================================
-- 교사용: 모범답안은 여러 형태가 가능합니다. 아래는 대표적인 한 가지 풀이입니다.


----------------------------------------------------------------------------------
-- 과제-01 | 재직 직원 고액 급여 목록
-- [교안 참고] 9~11페이지
-- employment_status가 재직인 직원만 추리는 CTE를 만들고, 그 중 급여 700만 원 이상인 직원의
-- 사번·이름·급여를 급여 내림차순으로 출력.

-- [정답 SQL]
WITH active_employees AS (
    SELECT employee_id, first_name, salary
    FROM employees
    WHERE employment_status = '재직'
)
SELECT employee_id, first_name, salary
FROM active_employees
WHERE salary >= 7000000
ORDER BY salary DESC, employee_id;

-- [실제 데이터 기반 예상 결과]
-- 전체 9행
-- employee_id | first_name | salary  
-- ------------+------------+---------
-- 100         | 민수         | 13300000
-- 101         | 서연         | 8200000 
-- 102         | 지훈         | 8000000 
-- 104         | 현우         | 8000000 
-- 106         | 도윤         | 7900000 
-- 108         | 준호         | 7900000 
-- ...

----------------------------------------------------------------------------------
-- 과제-02 | 직무별 평균급여와 직무 이름
-- [교안 참고] 10,21페이지
-- 직무별 평균급여를 구하는 CTE를 만들고 jobs와 JOIN해 직무명, 평균급여를 조회. 평균급여 500만 원 이상만
-- 출력하고 높은 급여순으로 정렬.

-- [정답 SQL]
WITH job_salary AS (
    SELECT job_id, ROUND(AVG(salary),0) AS avg_salary
    FROM employees
    GROUP BY job_id
)
SELECT j.job_title, js.avg_salary
FROM job_salary js
JOIN jobs j ON j.job_id = js.job_id
WHERE js.avg_salary >= 5000000
ORDER BY js.avg_salary DESC, j.job_id;

-- [실제 데이터 기반 예상 결과]
-- 전체 4행
-- job_title | avg_salary
-- ----------+-----------
-- 대표이사      | 13300000  
-- 팀장        | 7900000   
-- 소프트웨어 개발자 | 5892857   
-- 데이터 분석가   | 5355556   

----------------------------------------------------------------------------------
-- 과제-03 | 두 CTE: 평균보다 직원이 많은 부서 이름
-- [교안 참고] 17~21페이지
-- 첫 CTE에서 부서별 직원 수, 둘째 CTE에서 부서 직원 수의 평균을 계산한다. 평균보다 많은 부서의 이름과 직원
-- 수를 부서번호 오름차순으로 출력.

-- [정답 SQL]
WITH dept_counts AS (
    SELECT department_id, COUNT(*) AS staff_count
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
),
base AS (
    SELECT AVG(staff_count) AS avg_staff
    FROM dept_counts
)
SELECT d.department_name, dc.staff_count
FROM dept_counts dc
JOIN departments d ON dc.department_id = d.department_id
WHERE dc.staff_count > (SELECT avg_staff FROM base)
ORDER BY d.department_id;

-- [실제 데이터 기반 예상 결과]
-- 전체 3행
-- department_name | staff_count
-- ----------------+------------
-- 개발팀             | 16         
-- 데이터분석팀          | 11         
-- 영업팀             | 9          

----------------------------------------------------------------------------------
-- 과제-04 | 프로젝트 4건 이상 참여 직원
-- [교안 참고] 21페이지
-- employee_projects에서 직원별 프로젝트 수를 CTE로 계산한다. 4건 이상 참여한 직원 이름과 건수를
-- 조회하고 건수 내림차순·사번 오름차순으로 정렬.

-- [정답 SQL]
WITH participation AS (
    SELECT employee_id, COUNT(*) AS project_count
    FROM employee_projects
    GROUP BY employee_id
)
SELECT e.employee_id, e.first_name, p.project_count
FROM participation p
JOIN employees e ON p.employee_id = e.employee_id
WHERE p.project_count >= 4
ORDER BY p.project_count DESC, e.employee_id;

-- [실제 데이터 기반 예상 결과]
-- 전체 5행
-- employee_id | first_name | project_count
-- ------------+------------+--------------
-- 123         | 시우         | 8            
-- 124         | 민지         | 5            
-- 138         | 주원         | 5            
-- 139         | 혜원         | 5            
-- 140         | 연우         | 5            

----------------------------------------------------------------------------------
-- 과제-05 | 단계별 조회: 부서별 직원 수로 필터링
-- [교안 참고] 24~26페이지
-- 첫 SQL에서는 부서별 직원 수 CTE의 전체 8개 부서를 확인한다. 두 번째 SQL에서는 같은 CTE를 다시
-- 작성하고 직원 수 7명 이상인 부서만 출력한다. 부서번호 오름차순.

-- [정답 SQL]
-- ① 중간 집계 검증
WITH dept_counts AS (
    SELECT department_id, COUNT(*) AS staff_count
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
SELECT department_id, staff_count
FROM dept_counts
ORDER BY department_id;

-- ② 필터 적용 (CTE를 새 SQL에서 다시 작성)
WITH dept_counts AS (
    SELECT department_id, COUNT(*) AS staff_count
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
SELECT department_id, staff_count
FROM dept_counts
WHERE staff_count >= 7
ORDER BY department_id;

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
-- 전체 4행
-- department_id | staff_count
-- --------------+------------
-- 40            | 16         
-- 50            | 11         
-- 60            | 9          
-- 70            | 7          

-- 파일 끝
