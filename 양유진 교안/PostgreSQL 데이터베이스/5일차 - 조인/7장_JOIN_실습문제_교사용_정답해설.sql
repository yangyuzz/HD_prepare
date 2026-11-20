-- ============================================================================
-- PostgreSQL · hd · 7장 JOIN · 실습 · 교사용 정답·해설
-- 총 49문항 | UTF-8 | DBeaver 전용(SQL 표준 문법 + PostgreSQL NULLS LAST)
-- ============================================================================
-- [환경] PostgreSQL에서 hd 데이터베이스 연결; hd_sample_data.sql 초기 데이터 적재
-- [안전] 모두 SELECT 조회용. CREATE/UPDATE/DELETE/DROP/TRUNCATE 없음
-- [실행] SQL 에디터에서 원하는 문장에 커서를 두고 Ctrl+Enter로 개별 실행
-- [정렬] 결과표 예시는 ORDER BY 조건과 초기 데이터 기준
-- [주의] 학생용 ______ 구문은 채워야 실행되며, 오류 예시는 주석처리됨
-- [결과] 표의 NULL은 실제 SQL NULL; 앞 n행은 전체 결과의 일부만 의미
-- ============================================================================

-- =======================================================================
-- 01 JOIN 기초 · PK/FK · 문법 · 별칭
-- =======================================================================

-- [실습 01] 직원 원본의 행 수 확인  |  관련 교안 p.5~6
-- 문제: JOIN 전 데이터의 기준 행 수를 확인한다.
SELECT COUNT(*) AS 직원수 FROM employees;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 직원수 |
-- | ------ |
-- | 69 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 02] 부서 원본의 행 수 확인  |  관련 교안 p.5~6
-- 문제: 직원과 연결할 부서 테이블의 행 수를 확인한다.
SELECT COUNT(*) AS 부서수 FROM departments;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 부서수 |
-- | ------ |
-- | 9 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 03] INNER JOIN의 첫 실행  |  관련 교안 p.7~9,13
-- 문제: 직원 사번·이름·부서명을 연결하여 5명 출력한다.
SELECT e.employee_id, e.first_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 5;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | department_name |
-- | ----------- | ---------- | --------------- |
-- | 100         | 민수       | 경영지원팀 |
-- | 101         | 서연       | 경영지원팀 |
-- | 102         | 지훈       | 인사팀 |
-- | 103         | 수빈       | 재무팀 |
-- | 104         | 현우       | 개발팀 |
-- (총 5행)
-- 설명: 기본 JOIN은 매칭되는 직원만 출력한다. 직원 69명 중 부서가 연결되는 직원은 67명이다.

-- [실습 04] ON 연결 키 이해  |  관련 교안 p.7~9
-- 문제: 직원 테이블의 department_id와 부서 테이블의 department_id를 연결한다.
SELECT e.employee_id, e.department_id, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 5;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | department_id | department_name |
-- | ----------- | ------------- | --------------- |
-- | 100         | 10            | 경영지원팀 |
-- | 101         | 10            | 경영지원팀 |
-- | 102         | 20            | 인사팀 |
-- | 103         | 30            | 재무팀 |
-- | 104         | 40            | 개발팀 |
-- (총 5행)
-- 설명: 어떤 테이블의 행을 보존할지와 조건의 적용 시점을 먼저 판단한다.

-- [실습 05] 별칭이 없는 쿼리와 있는 쿼리  |  관련 교안 p.9~10
-- 문제: 같은 결과를 만드는 두 SQL을 차례대로 실행하고 비교한다.
-- [모범 답안 SQL 1]
SELECT employees.employee_id, departments.department_name
FROM employees JOIN departments
 ON employees.department_id = departments.department_id
ORDER BY employees.employee_id LIMIT 3;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | department_name |
-- | ----------- | --------------- |
-- | 100         | 경영지원팀 |
-- | 101         | 경영지원팀 |
-- | 102         | 인사팀 |
-- (총 3행)
-- [모범 답안 SQL 2]
SELECT e.employee_id, d.department_name
FROM employees e JOIN departments d
 ON e.department_id = d.department_id
ORDER BY e.employee_id LIMIT 3;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | department_name |
-- | ----------- | --------------- |
-- | 100         | 경영지원팀 |
-- | 101         | 경영지원팀 |
-- | 102         | 인사팀 |
-- (총 3행)
-- 설명: 같은 이름의 컬럼이 두 테이블에 있으면 e.department_id처럼 출처를 적는다.

-- [실습 06] JOIN 후 WHERE 적용  |  관련 교안 p.9,31
-- 문제: 재직 직원만 대상으로 사번·이름·부서명 5행을 확인한다.
SELECT e.employee_id, e.first_name, d.department_name
FROM employees e JOIN departments d ON e.department_id=d.department_id
WHERE e.employment_status='재직'
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
-- 설명: 어떤 테이블의 행을 보존할지와 조건의 적용 시점을 먼저 판단한다.

-- [실습 07] 직무명 JOIN  |  관련 교안 p.7~10,14
-- 문제: 직원에게 지정된 직무 이름을 jobs에서 가져온다.
SELECT e.employee_id, e.first_name, j.job_title
FROM employees e JOIN jobs j ON e.job_id=j.job_id
ORDER BY e.employee_id LIMIT 6;
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

-- [실습 08] JOIN의 결과 행 수 비교  |  관련 교안 p.6,13
-- 문제: WHERE 없는 INNER JOIN 결과 행 수를 직접 센다.
SELECT COUNT(*) AS 매칭직원수
FROM employees e JOIN departments d
 ON e.department_id=d.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 매칭직원수 |
-- | ---------- |
-- | 67 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- =======================================================================
-- 02 JOIN 종류 · 누락 데이터 · 모든 조합
-- =======================================================================

-- [실습 09] JOIN과 INNER JOIN 비교  |  관련 교안 p.13~14
-- 문제: INNER 키워드를 생략해도 동일한 건수인지 확인한다.
-- [모범 답안 SQL 1]
SELECT COUNT(*) AS 일반_JOIN_건수
FROM employees e JOIN departments d ON e.department_id=d.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 일반_JOIN_건수 |
-- | -------------- |
-- | 67 |
-- (총 1행)
-- [모범 답안 SQL 2]
SELECT COUNT(*) AS INNER_JOIN_건수
FROM employees e INNER JOIN departments d ON e.department_id=d.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | INNER_JOIN_건수 |
-- | --------------- |
-- | 67 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 10] LEFT JOIN으로 직원 전체 보존  |  관련 교안 p.12,15
-- 문제: 부서가 없는 직원을 포함하여 69명 모두 조회되는지 확인한다.
SELECT e.employee_id, e.first_name, d.department_name
FROM employees e LEFT JOIN departments d
 ON e.department_id=d.department_id
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

-- [실습 11] LEFT JOIN으로 부서 미배정 직원 찾기  |  관련 교안 p.16~17
-- 문제: 오른쪽 부서 키가 NULL인 직원만 조회한다.
SELECT e.employee_id, e.first_name, e.department_id
FROM employees e LEFT JOIN departments d
 ON e.department_id=d.department_id
WHERE d.department_id IS NULL
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | department_id |
-- | ----------- | ---------- | ------------- |
-- | 167         | 소율       | NULL |
-- | 168         | 보라       | NULL |
-- (총 2행)
-- 설명: 어떤 테이블의 행을 보존할지와 조건의 적용 시점을 먼저 판단한다.

-- [실습 12] 직원이 없는 부서 찾기  |  관련 교안 p.16~17
-- 문제: 부서 전체를 기준으로 직원 없는 부서만 조회한다.
SELECT d.department_id, d.department_name
FROM departments d LEFT JOIN employees e
 ON d.department_id=e.department_id
WHERE e.employee_id IS NULL
ORDER BY d.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | department_id | department_name |
-- | ------------- | --------------- |
-- | 90            | 신사업기획팀 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 13] RIGHT JOIN으로 전체 부서 유지  |  관련 교안 p.18
-- 문제: 직원 정보가 없는 부서도 남는 RIGHT JOIN의 총 행 수를 센다.
SELECT COUNT(*) AS 결과행수
FROM employees e RIGHT JOIN departments d
 ON e.department_id=d.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 결과행수 |
-- | -------- |
-- | 68 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 14] RIGHT JOIN을 LEFT JOIN으로 바꾸기  |  관련 교안 p.18
-- 문제: 두 쿼리가 같은 결과를 만드는지 확인한다.
-- [모범 답안 SQL 1]
SELECT d.department_id, d.department_name, e.employee_id
FROM employees e RIGHT JOIN departments d
 ON e.department_id=d.department_id
ORDER BY d.department_id, e.employee_id NULLS LAST LIMIT 7;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | department_id | department_name | employee_id |
-- | ------------- | --------------- | ----------- |
-- | 10            | 경영지원팀      | 100 |
-- | 10            | 경영지원팀      | 101 |
-- | 10            | 경영지원팀      | 109 |
-- | 10            | 경영지원팀      | 110 |
-- | 10            | 경영지원팀      | 111 |
-- ... 총 7행 중 앞 5행 표시
-- [모범 답안 SQL 2]
SELECT d.department_id, d.department_name, e.employee_id
FROM departments d LEFT JOIN employees e
 ON d.department_id=e.department_id
ORDER BY d.department_id, e.employee_id NULLS LAST LIMIT 7;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | department_id | department_name | employee_id |
-- | ------------- | --------------- | ----------- |
-- | 10            | 경영지원팀      | 100 |
-- | 10            | 경영지원팀      | 101 |
-- | 10            | 경영지원팀      | 109 |
-- | 10            | 경영지원팀      | 110 |
-- | 10            | 경영지원팀      | 111 |
-- ... 총 7행 중 앞 5행 표시
-- 설명: 어떤 테이블의 행을 보존할지와 조건의 적용 시점을 먼저 판단한다.

-- [실습 15] FULL OUTER JOIN 전체 건수  |  관련 교안 p.19
-- 문제: 직원만 있는 경우와 부서만 있는 경우를 모두 보존한다.
SELECT COUNT(*) AS 결과행수
FROM employees e FULL OUTER JOIN departments d
 ON e.department_id=d.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 결과행수 |
-- | -------- |
-- | 70 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 16] FULL JOIN에서 매칭되지 않은 행 3개  |  관련 교안 p.19
-- 문제: 직원 또는 부서 한쪽에만 존재하는 행을 출력한다.
SELECT e.employee_id, e.first_name, d.department_id, d.department_name
FROM employees e FULL OUTER JOIN departments d
 ON e.department_id=d.department_id
WHERE e.employee_id IS NULL OR d.department_id IS NULL
ORDER BY e.employee_id NULLS LAST, d.department_id NULLS LAST;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | department_id | department_name |
-- | ----------- | ---------- | ------------- | --------------- |
-- | 167         | 소율       | NULL          | NULL |
-- | 168         | 보라       | NULL          | NULL |
-- | NULL        | NULL       | 90            | 신사업기획팀 |
-- (총 3행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 17] CROSS JOIN의 작은 예시  |  관련 교안 p.20
-- 문제: 사번 100,101 두 명과 부서 10,20,30 세 개의 모든 조합 6행을 확인한다.
SELECT e.employee_id, d.department_id
FROM employees e CROSS JOIN departments d
WHERE e.employee_id IN (100,101)
  AND d.department_id IN (10,20,30)
ORDER BY e.employee_id, d.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | department_id |
-- | ----------- | ------------- |
-- | 100         | 10 |
-- | 100         | 20 |
-- | 100         | 30 |
-- | 101         | 10 |
-- | 101         | 20 |
-- ... 총 6행 중 앞 5행 표시
-- 설명: CROSS JOIN은 ON이 없고, 곱의 결과 행이 많아질 수 있어 목적이 있을 때만 사용한다.

-- [실습 18] CROSS JOIN 전체 행 수  |  관련 교안 p.12,20
-- 문제: hd 직원 69명 × 부서 9개를 계산한다.
SELECT COUNT(*) AS 모든조합수
FROM employees CROSS JOIN departments;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 모든조합수 |
-- | ---------- |
-- | 621 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 19] JOIN 종류별 행 수 나란히 비교  |  관련 교안 p.12,21
-- 문제: INNER·LEFT·RIGHT·FULL 결과 행 수를 각각 확인한다.
-- [모범 답안 SQL 1]
SELECT COUNT(*) AS inner_rows FROM employees e INNER JOIN departments d ON e.department_id=d.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | inner_rows |
-- | ---------- |
-- | 67 |
-- (총 1행)
-- [모범 답안 SQL 2]
SELECT COUNT(*) AS left_rows FROM employees e LEFT JOIN departments d ON e.department_id=d.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | left_rows |
-- | --------- |
-- | 69 |
-- (총 1행)
-- [모범 답안 SQL 3]
SELECT COUNT(*) AS right_rows FROM employees e RIGHT JOIN departments d ON e.department_id=d.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | right_rows |
-- | ---------- |
-- | 68 |
-- (총 1행)
-- [모범 답안 SQL 4]
SELECT COUNT(*) AS full_rows FROM employees e FULL JOIN departments d ON e.department_id=d.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | full_rows |
-- | --------- |
-- | 70 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- =======================================================================
-- 03 SELF JOIN · 다중 JOIN · 1:N 행 증가
-- =======================================================================

-- [실습 20] SELF JOIN으로 직원과 상사 연결  |  관련 교안 p.23~24
-- 문제: 직원과 상사에 같은 employees를 각각 e, m으로 사용한다.
SELECT e.employee_id, e.first_name AS 직원, m.first_name AS 상사
FROM employees e LEFT JOIN employees m
 ON e.manager_id=m.employee_id
ORDER BY e.employee_id LIMIT 6;
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

-- [실습 21] 상사가 없는 직원도 LEFT에 유지  |  관련 교안 p.23~24
-- 문제: manager_id가 NULL인 직원과 상사 컬럼이 NULL로 나오는 결과를 조회한다.
SELECT e.employee_id, e.first_name, m.first_name AS 상사이름
FROM employees e LEFT JOIN employees m
 ON e.manager_id=m.employee_id
WHERE e.manager_id IS NULL
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | 상사이름 |
-- | ----------- | ---------- | -------- |
-- | 100         | 민수       | NULL |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 22] 직원·부서·도시 3개 테이블 연결  |  관련 교안 p.25~27
-- 문제: employees → departments → locations 순서로 연결해 도시명까지 가져온다.
SELECT e.employee_id, e.first_name, d.department_name, l.city
FROM employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
ORDER BY e.employee_id LIMIT 7;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | department_name | city |
-- | ----------- | ---------- | --------------- | ---- |
-- | 100         | 민수       | 경영지원팀      | 서울 |
-- | 101         | 서연       | 경영지원팀      | 서울 |
-- | 102         | 지훈       | 인사팀          | 서울 |
-- | 103         | 수빈       | 재무팀          | 서울 |
-- | 104         | 현우       | 개발팀          | 판교 |
-- ... 총 7행 중 앞 5행 표시
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 23] 직원·부서·참여·프로젝트 4개 JOIN  |  관련 교안 p.25~27
-- 문제: 프로젝트명이 포함된 실제 참여 기록을 8행 조회한다.
SELECT e.employee_id, e.first_name, d.department_name,
       p.project_name, ep.project_role
FROM employees e
JOIN departments d ON e.department_id=d.department_id
JOIN employee_projects ep ON e.employee_id=ep.employee_id
JOIN projects p ON ep.project_id=p.project_id
ORDER BY e.employee_id, p.project_id LIMIT 8;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | department_name | project_name         | project_role |
-- | ----------- | ---------- | --------------- | -------------------- | ------------ |
-- | 101         | 서연       | 경영지원팀      | 정보보안 점검 체계   | PM |
-- | 102         | 지훈       | 인사팀          | 통합 인사정보 시스템 | PM |
-- | 102         | 지훈       | 인사팀          | 온라인 채용 플랫폼   | PM |
-- | 103         | 수빈       | 재무팀          | 비용 관리 자동화     | PM |
-- | 104         | 현우       | 개발팀          | 고객관리 CRM 개선    | PM |
-- ... 총 8행 중 앞 5행 표시
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 24] 직원 104번의 1:N 결과  |  관련 교안 p.28
-- 문제: 직원 한 행이 3개 프로젝트 참여 행으로 확장되는 과정 확인.
SELECT e.employee_id, e.first_name, ep.project_id
FROM employees e JOIN employee_projects ep
 ON e.employee_id=ep.employee_id
WHERE e.employee_id=104
ORDER BY ep.project_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | project_id |
-- | ----------- | ---------- | ---------- |
-- | 104         | 현우       | 1 |
-- | 104         | 현우       | 4 |
-- | 104         | 현우       | 10 |
-- (총 3행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 25] 행 수와 고유 직원 수 비교  |  관련 교안 p.29
-- 문제: JOIN 결과 102행과 고유 참여 직원 59명이 서로 다른지 확인.
SELECT COUNT(*) AS 참여행수,
       COUNT(DISTINCT e.employee_id) AS 고유직원수
FROM employees e JOIN employee_projects ep
 ON e.employee_id=ep.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 참여행수 | 고유직원수 |
-- | -------- | ---------- |
-- | 102      | 59 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 26] 프로젝트별 참여자 수 집계  |  관련 교안 p.25~29
-- 문제: 프로젝트 ID 1~5의 참가 직원 수를 GROUP BY로 집계한다.
SELECT p.project_id, p.project_name,
       COUNT(ep.employee_id) AS 참여자수
FROM projects p LEFT JOIN employee_projects ep
 ON p.project_id=ep.project_id
WHERE p.project_id BETWEEN 1 AND 5
GROUP BY p.project_id, p.project_name
ORDER BY p.project_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | project_id | project_name         | 참여자수 |
-- | ---------- | -------------------- | -------- |
-- | 1          | 고객관리 CRM 개선    | 7 |
-- | 2          | 통합 인사정보 시스템 | 8 |
-- | 3          | 생산 데이터 대시보드 | 9 |
-- | 4          | 전자결재 고도화      | 6 |
-- | 5          | 온라인 채용 플랫폼   | 7 |
-- (총 5행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 27] 급여 이력과 JOIN하면 행이 증가  |  관련 교안 p.44~46
-- 문제: 한 직원에 급여 이력이 여러 건 매칭되는 1:N을 확인한다.
SELECT e.employee_id, e.first_name, s.change_date, s.new_salary
FROM employees e JOIN salary_history s
 ON e.employee_id=s.employee_id
WHERE e.employee_id=104
ORDER BY s.change_date;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | change_date | new_salary |
-- | ----------- | ---------- | ----------- | ---------- |
-- | 104         | 현우       | 2024-01-01  | 7440000 |
-- | 104         | 현우       | 2025-01-01  | 7720000 |
-- | 104         | 현우       | 2026-01-01  | 8000000 |
-- (총 3행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 28] 복합 키의 중복 여부  |  관련 교안 p.25,46
-- 문제: employee_projects의 (직원ID, 프로젝트ID) 조합이 중복되는지 검사한다.
SELECT employee_id, project_id, COUNT(*) AS 중복건수
FROM employee_projects
GROUP BY employee_id, project_id
HAVING COUNT(*)>1
ORDER BY employee_id, project_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | project_id | 중복건수 |
-- | ----------- | ---------- | -------- |
-- (결과 0행)
-- 설명: 결과 0행이 정상이다. 복합 기본키 때문에 동일 직원·프로젝트 조합이 중복되지 않는다.

-- =======================================================================
-- 04 ON과 WHERE 조건 위치
-- =======================================================================

-- [실습 29] INNER JOIN: ON에 프로젝트 조건  |  관련 교안 p.31~32
-- 문제: 프로젝트 1의 참여자만 매칭, 7행을 확인한다.
SELECT e.employee_id, ep.project_id
FROM employees e INNER JOIN employee_projects ep
 ON e.employee_id=ep.employee_id AND ep.project_id=1
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | project_id |
-- | ----------- | ---------- |
-- | 104         | 1 |
-- | 123         | 1 |
-- | 130         | 1 |
-- | 132         | 1 |
-- | 134         | 1 |
-- ... 총 7행 중 앞 5행 표시
-- 설명: 어떤 테이블의 행을 보존할지와 조건의 적용 시점을 먼저 판단한다.

-- [실습 30] INNER JOIN: WHERE에 프로젝트 조건  |  관련 교안 p.31~32
-- 문제: 위 쿼리와 결과가 같은지 비교한다.
SELECT e.employee_id, ep.project_id
FROM employees e INNER JOIN employee_projects ep
 ON e.employee_id=ep.employee_id
WHERE ep.project_id=1
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | project_id |
-- | ----------- | ---------- |
-- | 104         | 1 |
-- | 123         | 1 |
-- | 130         | 1 |
-- | 132         | 1 |
-- | 134         | 1 |
-- ... 총 7행 중 앞 5행 표시
-- 설명: 어떤 테이블의 행을 보존할지와 조건의 적용 시점을 먼저 판단한다.

-- [실습 31] LEFT JOIN: ON 조건은 직원 전원 유지  |  관련 교안 p.33~35
-- 문제: 프로젝트 1번을 ON에 놓아 전체 직원 69명을 유지한다.
SELECT e.employee_id, ep.project_id
FROM employees e LEFT JOIN employee_projects ep
 ON e.employee_id=ep.employee_id AND ep.project_id=1
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | project_id |
-- | ----------- | ---------- |
-- | 100         | NULL |
-- | 101         | NULL |
-- | 102         | NULL |
-- | 103         | NULL |
-- | 104         | 1 |
-- ... 총 69행 중 앞 5행 표시
-- 설명: 어떤 테이블의 행을 보존할지와 조건의 적용 시점을 먼저 판단한다.

-- [실습 32] LEFT JOIN: WHERE 조건은 일부 직원 제거  |  관련 교안 p.33~35
-- 문제: 프로젝트 1번을 WHERE에 놓아 참여자 7명만 남긴다.
SELECT e.employee_id, ep.project_id
FROM employees e LEFT JOIN employee_projects ep
 ON e.employee_id=ep.employee_id
WHERE ep.project_id=1
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | project_id |
-- | ----------- | ---------- |
-- | 104         | 1 |
-- | 123         | 1 |
-- | 130         | 1 |
-- | 132         | 1 |
-- | 134         | 1 |
-- ... 총 7행 중 앞 5행 표시
-- 설명: 어떤 테이블의 행을 보존할지와 조건의 적용 시점을 먼저 판단한다.

-- [실습 33] LEFT JOIN으로 1번 프로젝트 미참여자  |  관련 교안 p.34~36
-- 문제: ON으로 1번 프로젝트만 매칭하고 오른쪽이 NULL인 직원만 골라낸다.
SELECT e.employee_id, e.first_name
FROM employees e LEFT JOIN employee_projects ep
 ON e.employee_id=ep.employee_id AND ep.project_id=1
WHERE ep.employee_id IS NULL
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name |
-- | ----------- | ---------- |
-- | 100         | 민수 |
-- | 101         | 서연 |
-- | 102         | 지훈 |
-- | 103         | 수빈 |
-- | 105         | 지은 |
-- ... 총 62행 중 앞 5행 표시
-- 설명: 어떤 테이블의 행을 보존할지와 조건의 적용 시점을 먼저 판단한다.

-- [실습 34] ON vs WHERE 결과 건수 확인  |  관련 교안 p.33~36
-- 문제: ON 조건과 WHERE 조건 두 SQL의 COUNT를 비교한다.
-- [모범 답안 SQL 1]
SELECT COUNT(*) AS ON조건_행수
FROM employees e LEFT JOIN employee_projects ep
 ON e.employee_id=ep.employee_id AND ep.project_id=1;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | ON조건_행수 |
-- | ----------- |
-- | 69 |
-- (총 1행)
-- [모범 답안 SQL 2]
SELECT COUNT(*) AS WHERE조건_행수
FROM employees e LEFT JOIN employee_projects ep
 ON e.employee_id=ep.employee_id
WHERE ep.project_id=1;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | WHERE조건_행수 |
-- | -------------- |
-- | 7 |
-- (총 1행)
-- 설명: 어떤 테이블의 행을 보존할지와 조건의 적용 시점을 먼저 판단한다.

-- =======================================================================
-- 05 집합 연산 · 행 결합 · 규칙
-- =======================================================================

-- [실습 35] JOIN: 행과 열의 결과 변화  |  관련 교안 p.37~38
-- 문제: 직원과 부서가 연결되면서 department_name 열이 늘어나는 예시를 확인한다.
SELECT e.employee_id, e.first_name, e.department_id, d.department_name
FROM employees e JOIN departments d
 ON e.department_id=d.department_id
WHERE e.employee_id IN (104,105,123)
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | department_id | department_name |
-- | ----------- | ---------- | ------------- | --------------- |
-- | 104         | 현우       | 40            | 개발팀 |
-- | 105         | 지은       | 50            | 데이터분석팀 |
-- | 123         | 시우       | 40            | 개발팀 |
-- (총 3행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 36] UNION: 프로젝트 1·2 참여 사번 합집합  |  관련 교안 p.39~41
-- 문제: 두 프로젝트 참여자 명단을 합쳐 중복 제거 후 조회한다.
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
-- 설명: 집합 연산은 같은 위치의 컬럼끼리 비교하며, 중복 처리 규칙이 연산마다 다르다.

-- [실습 37] UNION ALL: 중복까지 유지  |  관련 교안 p.38~41
-- 문제: 동일 명단을 UNION ALL로 결합하여 123번이 두 번 나오는지 확인한다.
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

-- [실습 38] INTERSECT: 두 프로젝트 공통 직원  |  관련 교안 p.39~42
-- 문제: 프로젝트 1과 2에 모두 참여한 사번만 출력한다.
SELECT employee_id FROM employee_projects WHERE project_id=1
INTERSECT
SELECT employee_id FROM employee_projects WHERE project_id=2
ORDER BY employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id |
-- | ----------- |
-- | 123 |
-- (총 1행)
-- 설명: 집합 연산은 같은 위치의 컬럼끼리 비교하며, 중복 처리 규칙이 연산마다 다르다.

-- [실습 39] EXCEPT: 1번에만 참여한 직원  |  관련 교안 p.39~42
-- 문제: 프로젝트 1에서 2번 프로젝트 참여 사번을 뺀다.
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

-- [실습 40] EXCEPT로 직원 없는 부서 번호 찾기  |  관련 교안 p.39~42
-- 문제: 부서 목록에서 직원이 배정된 부서 번호를 뺀다.
SELECT department_id FROM departments
EXCEPT
SELECT department_id FROM employees WHERE department_id IS NOT NULL
ORDER BY department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | department_id |
-- | ------------- |
-- | 90 |
-- (총 1행)
-- 설명: 집합 연산은 같은 위치의 컬럼끼리 비교하며, 중복 처리 규칙이 연산마다 다르다.

-- [실습 41] 집합 연산의 컬럼 수 오류 관찰  |  관련 교안 p.43
-- 문제: 잘못된 SQL은 주석으로 두고, 올바른 SQL만 실행한다.
-- 실행하지 말 것: UNION 양쪽의 컬럼 개수가 다름
-- SELECT employee_id, first_name FROM employees
-- UNION
-- SELECT employee_id FROM employee_projects;

SELECT employee_id FROM employees
UNION
SELECT employee_id FROM employee_projects
ORDER BY employee_id LIMIT 6;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id |
-- | ----------- |
-- | 100 |
-- | 101 |
-- | 102 |
-- | 103 |
-- | 104 |
-- ... 총 6행 중 앞 5행 표시
-- 설명: UNION/INTERSECT/EXCEPT의 각 SELECT는 동일한 컬럼 수와 호환 가능한 자료형이어야 한다.

-- =======================================================================
-- 06 행 단위(Grain) · 연결 키 · 오류 검증
-- =======================================================================

-- [실습 42] 직원·프로젝트의 행 단위 정의  |  관련 교안 p.44~47
-- 문제: employee_projects 한 행이 특정 직원의 특정 프로젝트 참여라는 점을 살펴본다.
SELECT employee_id, project_id, project_role
FROM employee_projects
WHERE employee_id=104
ORDER BY project_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | project_id | project_role |
-- | ----------- | ---------- | ------------ |
-- | 104         | 1          | PM |
-- | 104         | 4          | PM |
-- | 104         | 10         | PM |
-- (총 3행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 43] 잘못된 연결: 부서만으로 연결  |  관련 교안 p.45~46
-- 문제: 직원과 프로젝트를 부서 ID만으로 연결해 잘못 부풀어 오른 건수를 본다.
SELECT COUNT(*) AS 잘못된_부서연결_행수
FROM employees e JOIN projects p
 ON e.department_id=p.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 잘못된_부서연결_행수 |
-- | -------------------- |
-- | 136 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 44] 올바른 연결: 실제 참여 관계 이용  |  관련 교안 p.25~29,45~46
-- 문제: employee_projects를 거치면 실제 참여 기록 건수를 얻는다.
SELECT COUNT(*) AS 실제_프로젝트참여_행수
FROM employees e JOIN employee_projects ep
 ON e.employee_id=ep.employee_id
JOIN projects p ON ep.project_id=p.project_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 실제_프로젝트참여_행수 |
-- | ---------------------- |
-- | 102 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 45] ON 누락 문법 오류 확인  |  관련 교안 p.48
-- 문제: 실행 오류 예시는 주석으로 두고 올바른 ON 구문을 실행한다.
-- 실행 금지: 일반 JOIN에 조건이 빠져 있음
-- SELECT * FROM employees e JOIN departments d;

SELECT e.employee_id, d.department_name
FROM employees e JOIN departments d
 ON e.department_id=d.department_id
ORDER BY e.employee_id LIMIT 3;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | department_name |
-- | ----------- | --------------- |
-- | 100         | 경영지원팀 |
-- | 101         | 경영지원팀 |
-- | 102         | 인사팀 |
-- (총 3행)
-- 설명: 어떤 테이블의 행을 보존할지와 조건의 적용 시점을 먼저 판단한다.

-- [실습 46] 컬럼 이름 모호성 오류 확인  |  관련 교안 p.49
-- 문제: 두 테이블에 모두 employee_id가 있어 별칭이 필요함을 확인한다.
-- 실행 금지: employee_id는 두 테이블에 있어 모호함
-- SELECT employee_id FROM employees e JOIN employee_projects ep
--   ON e.employee_id=ep.employee_id;

SELECT e.employee_id, ep.project_id
FROM employees e JOIN employee_projects ep
 ON e.employee_id=ep.employee_id
ORDER BY e.employee_id, ep.project_id LIMIT 5;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | project_id |
-- | ----------- | ---------- |
-- | 101         | 12 |
-- | 102         | 2 |
-- | 102         | 5 |
-- | 103         | 11 |
-- | 104         | 1 |
-- (총 5행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 47] 오류: 서로 다른 의미의 키 연결  |  관련 교안 p.46,50
-- 문제: 직원 사번과 프로젝트 ID는 서로 다른 의미라 JOIN 키가 될 수 없음을 확인한다.
-- [모범 답안 SQL 1]
SELECT COUNT(*) AS 잘못된키_결과건수
FROM employees e JOIN employee_projects ep
 ON e.employee_id=ep.project_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 잘못된키_결과건수 |
-- | ----------------- |
-- | 0 |
-- (총 1행)
-- [모범 답안 SQL 2]
SELECT COUNT(*) AS 올바른키_결과건수
FROM employees e JOIN employee_projects ep
 ON e.employee_id=ep.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 올바른키_결과건수 |
-- | ----------------- |
-- | 102 |
-- (총 1행)
-- 설명: 숫자가 같더라도 사번과 프로젝트 번호는 같은 대상이 아니다.

-- [실습 48] 급여 이력 JOIN의 행 수와 고유 직원 수  |  관련 교안 p.44~47
-- 문제: 1:N 조인 결과는 이력건수, DISTINCT 직원 수는 별도 지표임을 확인한다.
SELECT COUNT(*) AS 급여이력행수, COUNT(DISTINCT e.employee_id) AS 대상직원수
FROM employees e JOIN salary_history sh
 ON e.employee_id=sh.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 급여이력행수 | 대상직원수 |
-- | ------------ | ---------- |
-- | 167          | 62 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [실습 49] JOIN 5단계 검증 마무리  |  관련 교안 p.46~50
-- 문제: 조회 목표·키·행 단위를 점검하고 COUNT 3가지를 비교한다.
-- [모범 답안 SQL 1]
SELECT COUNT(*) AS 원본직원수 FROM employees;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 원본직원수 |
-- | ---------- |
-- | 69 |
-- (총 1행)
-- [모범 답안 SQL 2]
SELECT COUNT(*) AS JOIN참여행수, COUNT(DISTINCT e.employee_id) AS 참여직원수
FROM employees e JOIN employee_projects ep
 ON e.employee_id=ep.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | JOIN참여행수 | 참여직원수 |
-- | ------------ | ---------- |
-- | 102          | 59 |
-- (총 1행)
-- 설명: 검증 5단계: 질문의 단위 → 각 테이블의 한 행 → 연결 키 → 행 수 비교 → 정상 1:N 여부.
