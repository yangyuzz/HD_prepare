-- ============================================================================
-- PostgreSQL · hd · 7장 JOIN · 과제 · 교사용 정답·해설
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
-- 01 JOIN 기본·누락 탐색
-- =======================================================================

-- [과제 01] 신입 사원의 부서명 조회  |  관련 교안 p.9~16
-- 문제: 2026년 입사한 직원의 사번·이름·입사일·부서명을 출력하라. 부서가 없어도 남기며 사번 오름차순 상위 8행.
SELECT e.employee_id,e.first_name,e.hire_date,d.department_name
FROM employees e LEFT JOIN departments d ON e.department_id=d.department_id
WHERE e.hire_date >= '2026-01-01' AND e.hire_date < '2027-01-01'
ORDER BY e.employee_id LIMIT 8;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | hire_date  | department_name |
-- | ----------- | ---------- | ---------- | --------------- |
-- | 111         | 다은       | 2026-10-06 | 경영지원팀 |
-- | 120         | 재현       | 2026-03-15 | 재무팀 |
-- | 149         | 서아       | 2026-05-16 | 영업팀 |
-- | 152         | 시윤       | 2026-05-22 | 영업팀 |
-- | 155         | 다솜       | 2026-05-01 | 영업팀 |
-- ... 총 7행 중 앞 5행 표시
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [과제 02] 부서와 도시를 함께 출력  |  관련 교안 p.8,25~27
-- 문제: 모든 9개 부서의 부서ID, 부서명, 도시명을 조회하라. 부서번호 오름차순.
SELECT d.department_id,d.department_name,l.city
FROM departments d LEFT JOIN locations l ON d.location_id=l.location_id
ORDER BY d.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | department_id | department_name | city |
-- | ------------- | --------------- | ---- |
-- | 10            | 경영지원팀      | 서울 |
-- | 20            | 인사팀          | 서울 |
-- | 30            | 재무팀          | 서울 |
-- | 40            | 개발팀          | 판교 |
-- | 50            | 데이터분석팀    | 판교 |
-- ... 총 9행 중 앞 5행 표시
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [과제 03] 부서별 직원 수 (빈 부서 포함)  |  관련 교안 p.15~17,29
-- 문제: 부서ID·부서명·인원수를 조회하라. 90번 부서도 0명으로 표시하고 부서ID 오름차순.
SELECT d.department_id,d.department_name,COUNT(e.employee_id) AS 직원수
FROM departments d LEFT JOIN employees e ON d.department_id=e.department_id
GROUP BY d.department_id,d.department_name
ORDER BY d.department_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | department_id | department_name | 직원수 |
-- | ------------- | --------------- | ------ |
-- | 10            | 경영지원팀      | 6 |
-- | 20            | 인사팀          | 6 |
-- | 30            | 재무팀          | 6 |
-- | 40            | 개발팀          | 16 |
-- | 50            | 데이터분석팀    | 11 |
-- ... 총 9행 중 앞 5행 표시
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [과제 04] 부서 없는 직원의 상세 목록  |  관련 교안 p.16
-- 문제: 부서가 없는 직원의 사번·이름·직무ID를 직원번호 오름차순 조회하라.
SELECT e.employee_id,e.first_name,e.job_id
FROM employees e LEFT JOIN departments d ON e.department_id=d.department_id
WHERE d.department_id IS NULL
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | job_id |
-- | ----------- | ---------- | ------ |
-- | 167         | 소율       | INTERN |
-- | 168         | 보라       | INTERN |
-- (총 2행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [과제 05] 도시가 판교인 직원 목록  |  관련 교안 p.25~27
-- 문제: 직원·부서·지역을 JOIN해 판교 근무자 사번·이름·부서명을 사번 오름차순 상위 8행 조회하라.
SELECT e.employee_id,e.first_name,d.department_name
FROM employees e JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
WHERE l.city='판교'
ORDER BY e.employee_id LIMIT 8;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | department_name |
-- | ----------- | ---------- | --------------- |
-- | 104         | 현우       | 개발팀 |
-- | 105         | 지은       | 데이터분석팀 |
-- | 123         | 시우       | 개발팀 |
-- | 124         | 민지       | 개발팀 |
-- | 125         | 윤서       | 개발팀 |
-- ... 총 8행 중 앞 5행 표시
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- =======================================================================
-- 02 SELF·다중 JOIN · 1:N
-- =======================================================================

-- [과제 06] 상사가 없는 직원  |  관련 교안 p.23~24
-- 문제: SELF LEFT JOIN을 이용해 상사가 매칭되지 않는 직원의 사번·이름을 조회하라.
SELECT e.employee_id,e.first_name
FROM employees e LEFT JOIN employees m ON e.manager_id=m.employee_id
WHERE m.employee_id IS NULL
ORDER BY e.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name |
-- | ----------- | ---------- |
-- | 100         | 민수 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [과제 07] 특정 직원의 프로젝트 3건  |  관련 교안 p.25~29
-- 문제: 104번 직원의 사번·이름·프로젝트명·역할을 프로젝트ID 오름차순으로 조회하라.
SELECT e.employee_id,e.first_name,p.project_name,ep.project_role
FROM employees e JOIN employee_projects ep ON e.employee_id=ep.employee_id
JOIN projects p ON ep.project_id=p.project_id
WHERE e.employee_id=104
ORDER BY p.project_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | project_name       | project_role |
-- | ----------- | ---------- | ------------------ | ------------ |
-- | 104         | 현우       | 고객관리 CRM 개선  | PM |
-- | 104         | 현우       | 전자결재 고도화    | PM |
-- | 104         | 현우       | 모바일 서비스 개편 | PM |
-- (총 3행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [과제 08] 직원별 참여 프로젝트 TOP 5  |  관련 교안 p.25~29
-- 문제: 프로젝트에 1번 이상 참여한 직원 중 참여 건수가 많은 상위 5명(사번·이름·참여건수)을 출력하라. 동률이면 사번 오름차순.
SELECT e.employee_id,e.first_name,COUNT(*) AS 참여건수
FROM employees e JOIN employee_projects ep ON e.employee_id=ep.employee_id
GROUP BY e.employee_id,e.first_name
ORDER BY 참여건수 DESC,e.employee_id ASC LIMIT 5;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | 참여건수 |
-- | ----------- | ---------- | -------- |
-- | 123         | 시우       | 8 |
-- | 124         | 민지       | 5 |
-- | 138         | 주원       | 5 |
-- | 139         | 혜원       | 5 |
-- | 140         | 연우       | 5 |
-- (총 5행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [과제 09] 프로젝트별 배정 인원 조회  |  관련 교안 p.25~29
-- 문제: 프로젝트 1~5의 프로젝트 ID·이름·참여 인원 수를 출력하라. 프로젝트 ID 순.
SELECT p.project_id,p.project_name,COUNT(ep.employee_id) AS 참여자수
FROM projects p LEFT JOIN employee_projects ep ON p.project_id=ep.project_id
WHERE p.project_id BETWEEN 1 AND 5
GROUP BY p.project_id,p.project_name
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

-- [과제 10] 급여 이력 행 수 비교  |  관련 교안 p.44~47
-- 문제: employees와 salary_history JOIN 결과의 이력 행 수, 이력이 있는 고유 직원 수를 한 행으로 출력하라.
SELECT COUNT(*) AS 이력행수,COUNT(DISTINCT e.employee_id) AS 해당직원수
FROM employees e JOIN salary_history s ON e.employee_id=s.employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 이력행수 | 해당직원수 |
-- | -------- | ---------- |
-- | 167      | 62 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- =======================================================================
-- 03 ON/WHERE · 집합 · 오류 교정
-- =======================================================================

-- [과제 11] 2번 프로젝트 참여 여부 표시  |  관련 교안 p.31~35
-- 문제: 직원 69명을 유지하면서 프로젝트 2번의 참여자는 참여, 나머지는 미참여로 표시한다. 사번 오름차순 10행. 조건은 ON에 둔다.
SELECT e.employee_id,e.first_name,
       CASE WHEN ep.project_id IS NULL THEN '미참여' ELSE '참여' END AS 참여여부
FROM employees e LEFT JOIN employee_projects ep
 ON e.employee_id=ep.employee_id AND ep.project_id=2
ORDER BY e.employee_id LIMIT 10;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | 참여여부 |
-- | ----------- | ---------- | -------- |
-- | 100         | 민수       | 미참여 |
-- | 101         | 서연       | 미참여 |
-- | 102         | 지훈       | 참여 |
-- | 103         | 수빈       | 미참여 |
-- | 104         | 현우       | 미참여 |
-- ... 총 10행 중 앞 5행 표시
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [과제 12] 2번 프로젝트 미참여 직원 수  |  관련 교안 p.33~36
-- 문제: LEFT JOIN + IS NULL을 사용해 프로젝트 2번에 참여하지 않은 직원 수를 출력하라.
SELECT COUNT(*) AS 미참여직원수
FROM employees e LEFT JOIN employee_projects ep
 ON e.employee_id=ep.employee_id AND ep.project_id=2
WHERE ep.employee_id IS NULL;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | 미참여직원수 |
-- | ------------ |
-- | 61 |
-- (총 1행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [과제 13] 프로젝트 1과 2의 공통·차이  |  관련 교안 p.40~42
-- 문제: 공통 참여 사번(INTERSECT)과 2번에만 참여한 사번(EXCEPT)을 각각 출력하라. 오름차순.
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
SELECT employee_id FROM employee_projects WHERE project_id=2
EXCEPT
SELECT employee_id FROM employee_projects WHERE project_id=1
ORDER BY employee_id;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id |
-- | ----------- |
-- | 102 |
-- | 113 |
-- | 114 |
-- | 115 |
-- | 116 |
-- ... 총 7행 중 앞 5행 표시
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.

-- [과제 14] UNION과 UNION ALL의 중복 비교  |  관련 교안 p.38~43
-- 문제: 프로젝트 1·2번 참여 사번을 UNION과 UNION ALL로 각각 연결하라. 숫자 대신 사번 목록 자체를 정렬해 출력.
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

-- [과제 15] 잘못된 JOIN 키 수정 후 5행  |  관련 교안 p.45~50
-- 문제: 직원·프로젝트의 실제 참여 관계를 이용해 사번·이름·프로젝트ID를 상위 5행 출력하라. 직원 사번, 프로젝트ID 오름차순. 부서ID만으로 연결하면 틀린 결과임을 유의.
SELECT e.employee_id,e.first_name,p.project_id
FROM employees e JOIN employee_projects ep ON e.employee_id=ep.employee_id
JOIN projects p ON ep.project_id=p.project_id
ORDER BY e.employee_id,p.project_id LIMIT 5;
-- [실제 결과 예시 · 초기 hd 데이터]
-- | employee_id | first_name | project_id |
-- | ----------- | ---------- | ---------- |
-- | 101         | 서연       | 12 |
-- | 102         | 지훈       | 2 |
-- | 102         | 지훈       | 5 |
-- | 103         | 수빈       | 11 |
-- | 104         | 현우       | 1 |
-- (총 5행)
-- 설명: 연결 키의 의미와 JOIN 전후의 행 수를 비교해 쿼리 목적에 맞는지 검증한다.
