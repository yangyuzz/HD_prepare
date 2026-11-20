-- ============================================================================
-- PostgreSQL · hd · 7장 JOIN · 복습 · 교사용 정답·해설
-- 총 15문항 | UTF-8 | DBeaver 전용(SQL 표준 문법 + PostgreSQL NULLS LAST)
-- ============================================================================
-- [환경] PostgreSQL에서 hd 데이터베이스 연결; hd_sample_data.sql 초기 데이터 적재
-- [안전] 모두 SELECT 조회용. CREATE/UPDATE/DELETE/DROP/TRUNCATE 없음
-- [실행] SQL 에디터에서 원하는 문장에 커서를 두고 Ctrl+Enter로 개별 실행
-- [정렬] 결과표 예시는 ORDER BY 조건과 초기 데이터 기준
-- [주의] 학생용 ______ 구문은 채워야 실행되며, 오류 예시는 주석처리됨
-- [결과] 표의 NULL은 실제 SQL NULL; 앞 n행은 전체 결과의 일부만 의미
-- ============================================================================

-- =======================================================================
-- 01 JOIN의 기초·종류
-- =======================================================================

-- [복습 01] 직원과 부서 INNER JOIN  |  관련 교안 p.7~15
-- 문제: 직원 사번, 이름, 부서명을 5행 조회하라. 직원 사번 오름차순.
SELECT e.employee_id, e.first_name, d.department_name
FROM employees e INNER JOIN departments d ON e.department_id=d.department_id
ORDER BY e.employee_id LIMIT 5;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | department_name |
-- | ----------- | ---------- | --------------- |
-- | 100         | 민수       | 경영지원팀 |
-- | 101         | 서연       | 경영지원팀 |
-- | 102         | 지훈       | 인사팀 |
-- | 103         | 수빈       | 재무팀 |
-- | 104         | 현우       | 개발팀 |
-- (총 5행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [복습 02] 직무명 연결  |  관련 교안 p.7~10
-- 문제: 직원 100~105번의 사번, 이름, 직무명을 조회하라.
SELECT e.employee_id, e.first_name, j.job_title
FROM employees e JOIN jobs j ON e.job_id=j.job_id
WHERE e.employee_id BETWEEN 100 AND 105
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | job_title |
-- | ----------- | ---------- | --------- |
-- | 100         | 민수       | 대표이사 |
-- | 101         | 서연       | 팀장 |
-- | 102         | 지훈       | 팀장 |
-- | 103         | 수빈       | 팀장 |
-- | 104         | 현우       | 팀장 |
-- ... 총 6행 중 앞 5행 표시
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [복습 03] LEFT JOIN으로 전 직원 출력  |  관련 교안 p.15
-- 문제: 사번, 이름, 부서명을 LEFT JOIN으로 조회하라. 사번 오름차순.
SELECT e.employee_id, e.first_name, d.department_name
FROM employees e LEFT JOIN departments d ON e.department_id=d.department_id
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | department_name |
-- | ----------- | ---------- | --------------- |
-- | 100         | 민수       | 경영지원팀 |
-- | 101         | 서연       | 경영지원팀 |
-- | 102         | 지훈       | 인사팀 |
-- | 103         | 수빈       | 재무팀 |
-- | 104         | 현우       | 개발팀 |
-- ... 총 69행 중 앞 5행 표시
-- 설명: 어떤 테이블의 행을 보존할지와 조건의 적용 시점을 먼저 판단한다.

-- [복습 04] 부서 미배정 직원 찾기  |  관련 교안 p.16~17
-- 문제: 직원에 매칭되는 부서가 없는 직원의 사번, 이름을 오름차순 조회하라.
SELECT e.employee_id, e.first_name
FROM employees e LEFT JOIN departments d ON e.department_id=d.department_id
WHERE d.department_id IS NULL
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name |
-- | ----------- | ---------- |
-- | 167         | 소율 |
-- | 168         | 보라 |
-- (총 2행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [복습 05] 직원 없는 부서 찾기  |  관련 교안 p.16~17
-- 문제: 직원이 한 명도 없는 부서 ID와 부서명을 조회하라.
SELECT d.department_id, d.department_name
FROM departments d LEFT JOIN employees e ON d.department_id=e.department_id
WHERE e.employee_id IS NULL
ORDER BY d.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | department_id | department_name |
-- | ------------- | --------------- |
-- | 90            | 신사업기획팀 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- =======================================================================
-- 02 SELF·다중 JOIN · 1:N
-- =======================================================================

-- [복습 06] RIGHT를 LEFT로 읽기 쉽게  |  관련 교안 p.18
-- 문제: 오른쪽 departments를 모두 보존하는 RIGHT JOIN과 동등한 LEFT JOIN을 작성하라. 결과의 행 수만 반환.
SELECT COUNT(*) AS 결과행수
FROM departments d LEFT JOIN employees e ON d.department_id=e.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 결과행수 |
-- | -------- |
-- | 68 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [복습 07] FULL JOIN 비매칭 3행 찾기  |  관련 교안 p.19
-- 문제: 부서나 직원 중 한쪽이 없는 레코드만 사번·부서번호로 출력하라.
SELECT e.employee_id, d.department_id
FROM employees e FULL OUTER JOIN departments d ON e.department_id=d.department_id
WHERE e.employee_id IS NULL OR d.department_id IS NULL
ORDER BY e.employee_id NULLS LAST,d.department_id NULLS LAST;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | department_id |
-- | ----------- | ------------- |
-- | 167         | NULL |
-- | 168         | NULL |
-- | NULL        | 90 |
-- (총 3행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [복습 08] SELF JOIN으로 직원·상사 이름  |  관련 교안 p.23~24
-- 문제: 100~105번 사번, 직원 이름, 상사 이름을 조회하라. 상사가 없어도 직원은 남긴다.
SELECT e.employee_id,e.first_name AS 직원,m.first_name AS 상사
FROM employees e LEFT JOIN employees m ON e.manager_id=m.employee_id
WHERE e.employee_id BETWEEN 100 AND 105
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | 직원 | 상사 |
-- | ----------- | ---- | ---- |
-- | 100         | 민수 | NULL |
-- | 101         | 서연 | 민수 |
-- | 102         | 지훈 | 민수 |
-- | 103         | 수빈 | 민수 |
-- | 104         | 현우 | 민수 |
-- ... 총 6행 중 앞 5행 표시
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [복습 09] 3개 테이블 JOIN  |  관련 교안 p.25~27
-- 문제: 직원 100~105번의 이름, 부서명, 근무 도시를 조회하라.
SELECT e.employee_id,e.first_name,d.department_name,l.city
FROM employees e JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
WHERE e.employee_id BETWEEN 100 AND 105
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | department_name | city |
-- | ----------- | ---------- | --------------- | ---- |
-- | 100         | 민수       | 경영지원팀      | 서울 |
-- | 101         | 서연       | 경영지원팀      | 서울 |
-- | 102         | 지훈       | 인사팀          | 서울 |
-- | 103         | 수빈       | 재무팀          | 서울 |
-- | 104         | 현우       | 개발팀          | 판교 |
-- ... 총 6행 중 앞 5행 표시
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [복습 10] 1:N JOIN 결과 비교  |  관련 교안 p.28~29
-- 문제: employee_projects와 employees 연결 후 참여 행 수와 고유 직원 수를 한 행으로 출력하라.
SELECT COUNT(*) AS 참여행수,COUNT(DISTINCT e.employee_id) AS 고유직원수
FROM employees e JOIN employee_projects ep ON e.employee_id=ep.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 참여행수 | 고유직원수 |
-- | -------- | ---------- |
-- | 102      | 59 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- =======================================================================
-- 03 ON/WHERE·집합 연산·검증
-- =======================================================================

-- [복습 11] LEFT JOIN의 ON 조건  |  관련 교안 p.31~35
-- 문제: 1번 프로젝트 매칭 조건을 ON에 두고 직원 수를 COUNT하라. 전체 직원 수가 유지되어야 한다.
SELECT COUNT(*) AS 직원행수
FROM employees e LEFT JOIN employee_projects ep
 ON e.employee_id=ep.employee_id AND ep.project_id=1;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 직원행수 |
-- | -------- |
-- | 69 |
-- (총 1행)
-- 설명: 어떤 테이블의 행을 보존할지와 조건의 적용 시점을 먼저 판단한다.

-- [복습 12] LEFT JOIN의 WHERE 조건  |  관련 교안 p.31~35
-- 문제: 위와 같은 프로젝트 조건을 WHERE에 두고 직원 수를 COUNT하라.
SELECT COUNT(*) AS 남은행수
FROM employees e LEFT JOIN employee_projects ep ON e.employee_id=ep.employee_id
WHERE ep.project_id=1;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 남은행수 |
-- | -------- |
-- | 7 |
-- (총 1행)
-- 설명: 어떤 테이블의 행을 보존할지와 조건의 적용 시점을 먼저 판단한다.

-- [복습 13] UNION vs UNION ALL  |  관련 교안 p.39~41
-- 문제: 프로젝트 1·2번 참여 사번을 합쳐 UNION과 UNION ALL 각각 조회하라. 사번 오름차순.
-- [모범 답안 SQL 1]
SELECT employee_id FROM employee_projects WHERE project_id=1
UNION
SELECT employee_id FROM employee_projects WHERE project_id=2
ORDER BY employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id |
-- | ----------- |
-- | 102 |
-- | 104 |
-- | 113 |
-- | 114 |
-- | 115 |
-- ... 총 14행 중 앞 5행 표시
-- [모범 답안 SQL 2]
SELECT employee_id FROM employee_projects WHERE project_id=1
UNION ALL
SELECT employee_id FROM employee_projects WHERE project_id=2
ORDER BY employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id |
-- | ----------- |
-- | 102 |
-- | 104 |
-- | 113 |
-- | 114 |
-- | 115 |
-- ... 총 15행 중 앞 5행 표시
-- 설명: 집합 연산은 같은 위치의 컬럼끼리 비교하며, 중복 처리 규칙이 연산마다 다르다.

-- [복습 14] INTERSECT와 EXCEPT  |  관련 교안 p.40~42
-- 문제: 프로젝트 1·2번 공통 참여 사번을 INTERSECT로, 1번만 참여한 사번을 EXCEPT로 각각 출력하라.
-- [모범 답안 SQL 1]
SELECT employee_id FROM employee_projects WHERE project_id=1
INTERSECT
SELECT employee_id FROM employee_projects WHERE project_id=2
ORDER BY employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id |
-- | ----------- |
-- | 123 |
-- (총 1행)
-- [모범 답안 SQL 2]
SELECT employee_id FROM employee_projects WHERE project_id=1
EXCEPT
SELECT employee_id FROM employee_projects WHERE project_id=2
ORDER BY employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id |
-- | ----------- |
-- | 104 |
-- | 130 |
-- | 132 |
-- | 134 |
-- | 137 |
-- ... 총 6행 중 앞 5행 표시
-- 설명: 집합 연산은 같은 위치의 컬럼끼리 비교하며, 중복 처리 규칙이 연산마다 다르다.

-- [복습 15] 정확한 참여 키 검증  |  관련 교안 p.44~50
-- 문제: 잘못된 부서 ID 연결(직원×프로젝트)과 실제 employee_projects 연결의 COUNT를 각각 작성하라.
-- [모범 답안 SQL 1]
SELECT COUNT(*) AS 잘못연결건수
FROM employees e JOIN projects p ON e.department_id=p.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 잘못연결건수 |
-- | ------------ |
-- | 136 |
-- (총 1행)
-- [모범 답안 SQL 2]
SELECT COUNT(*) AS 실제참여건수
FROM employees e JOIN employee_projects ep ON e.employee_id=ep.employee_id
JOIN projects p ON ep.project_id=p.project_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 실제참여건수 |
-- | ------------ |
-- | 102 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.
