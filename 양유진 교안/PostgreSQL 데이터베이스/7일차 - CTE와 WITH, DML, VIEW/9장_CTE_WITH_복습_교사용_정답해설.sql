-- ================================================================================
-- PostgreSQL 9장: CTE와 WITH 문 | 복습문제 | 교사용 정답·해설
-- 수업 DB: hd  /  사용 테이블: employees, departments, jobs, projects, employee_projects
-- 모든 문장은 조회(SELECT) 전용이며 데이터를 변경하지 않습니다.
-- 문항을 위에서 아래 순서대로 실행하세요. 두 개의 조회문은 각각 따로 실행합니다.
-- ★ 상관 서브쿼리, DML, VIEW 실습은 포함하지 않습니다.
-- ================================================================================
-- 교사용: 모범답안은 여러 형태가 가능합니다. 아래는 대표적인 한 가지 풀이입니다.


----------------------------------------------------------------------------------
-- 복습-01 | WITH 기본: 급여 600만 원 이상 직원
-- [교안 참고] 9~11페이지
-- WITH high_salary CTE에서 급여가 600만 원 이상인 직원의 사번, 이름, 급여를 추린다. 결과는 급여
-- 내림차순, 사번 오름차순으로 상위 5명 조회.

-- [정답 SQL]
WITH high_salary AS (
    SELECT employee_id, first_name, salary
    FROM employees
    WHERE salary >= 6000000
)
SELECT employee_id, first_name, salary
FROM high_salary
ORDER BY salary DESC, employee_id
LIMIT 5;

-- [실제 데이터 기반 예상 결과]
-- 전체 5행
-- employee_id | first_name | salary  
-- ------------+------------+---------
-- 100         | 민수         | 13300000
-- 101         | 서연         | 8200000 
-- 102         | 지훈         | 8000000 
-- 104         | 현우         | 8000000 
-- 106         | 도윤         | 7900000 

----------------------------------------------------------------------------------
-- 복습-02 | 집계 CTE: 직원 10명 이상인 부서
-- [교안 참고] 14,25페이지
-- employees를 부서별로 그룹화한 CTE를 만들고 직원 수가 10명 이상인 부서번호와 직원 수를 조회. 부서번호
-- 오름차순.

-- [정답 SQL]
WITH dept_counts AS (
    SELECT department_id, COUNT(*) AS staff_count
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
SELECT department_id, staff_count
FROM dept_counts
WHERE staff_count >= 10
ORDER BY department_id;

-- [실제 데이터 기반 예상 결과]
-- 전체 2행
-- department_id | staff_count
-- --------------+------------
-- 40            | 16         
-- 50            | 11         

----------------------------------------------------------------------------------
-- 복습-03 | CTE + JOIN: 부서명과 평균급여
-- [교안 참고] 10,21페이지
-- 부서별 평균급여 CTE를 작성한 후 departments와 JOIN해 평균급여 500만 원 이상인 부서의 이름과
-- 평균급여를 조회. 평균급여 내림차순.

-- [정답 SQL]
WITH dept_salary AS (
    SELECT department_id, ROUND(AVG(salary),0) AS avg_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
SELECT d.department_name, ds.avg_salary
FROM dept_salary ds
JOIN departments d ON ds.department_id = d.department_id
WHERE ds.avg_salary >= 5000000
ORDER BY ds.avg_salary DESC, d.department_id;

-- [실제 데이터 기반 예상 결과]
-- 전체 4행
-- department_name | avg_salary
-- ----------------+-----------
-- 경영지원팀           | 6133333   
-- 개발팀             | 5743750   
-- 데이터분석팀          | 5381818   
-- 마케팅팀            | 5100000   

----------------------------------------------------------------------------------
-- 복습-04 | 두 개의 CTE 연결: 부서 직원 수 평균과 비교
-- [교안 참고] 17~20페이지
-- 첫 번째 CTE로 부서별 직원 수를 계산하고, 두 번째 CTE로 그 직원 수들의 평균을 구한다. 평균보다 직원 수가
-- 많은 부서번호와 직원 수를 출력.

-- [정답 SQL]
WITH dept_counts AS (
    SELECT department_id, COUNT(*) AS staff_count
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
),
baseline AS (
    SELECT AVG(staff_count) AS avg_staff
    FROM dept_counts
)
SELECT department_id, staff_count
FROM dept_counts
WHERE staff_count > (SELECT avg_staff FROM baseline)
ORDER BY staff_count DESC, department_id;

-- [실제 데이터 기반 예상 결과]
-- 전체 3행
-- department_id | staff_count
-- --------------+------------
-- 40            | 16         
-- 50            | 11         
-- 60            | 9          

----------------------------------------------------------------------------------
-- 복습-05 | CTE 재사용: 부서별 평균급여의 최고·최저
-- [교안 참고] 22페이지
-- 부서별 평균급여를 계산하는 CTE 하나를 정의하고, 최고 평균급여와 최저 평균급여를 한 행에 출력한다. 소수점은
-- ROUND(...,0) 처리.

-- [정답 SQL]
WITH dept_stats AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
SELECT ROUND((SELECT MAX(avg_salary) FROM dept_stats),0) AS highest_avg,
       ROUND((SELECT MIN(avg_salary) FROM dept_stats),0) AS lowest_avg;

-- [실제 데이터 기반 예상 결과]
-- 전체 1행
-- highest_avg | lowest_avg
-- ------------+-----------
-- 6133333     | 4216667   

-- 파일 끝
