/*
    USE oracle_peldatar database for this.
*/
INSERT ALL
    INTO a_emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        VALUES (7839, 'KING', 'PRESIDENT', NULL, TO_DATE('1981-11-17', 'YYYY-MM-DD'), 5000, NULL, 10)
    INTO a_emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        VALUES (7698, 'BLAKE', 'MANAGER', 7839, TO_DATE('1981-05-01', 'YYYY-MM-DD'), 2850, NULL, 30)
    INTO a_emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        VALUES (7782, 'CLARK', 'MANAGER', 7839, TO_DATE('1981-06-09', 'YYYY-MM-DD'), 2450, NULL, 10)
    INTO a_emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        VALUES (7566, 'JONES', 'MANAGER', 7839, TO_DATE('1981-04-02', 'YYYY-MM-DD'), 2975, NULL, 20)
    INTO a_emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        VALUES (7654, 'MARTIN', 'SALESMAN', 7698, TO_DATE('1981-09-28', 'YYYY-MM-DD'), 1250, 1400, 30)
    INTO a_emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        VALUES (7499, 'ALLEN', 'SALESMAN', 7698, TO_DATE('1981-02-20', 'YYYY-MM-DD'), 1600, 300, 30)
    INTO a_emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        VALUES (7844, 'TURNER', 'SALESMAN', 7698, TO_DATE('1981-09-08', 'YYYY-MM-DD'), 1500, 0, 30)
    INTO a_emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        VALUES (7900, 'JAMES', 'CLERK', 7698, TO_DATE('1981-12-03', 'YYYY-MM-DD'), 950, NULL, 30)
    INTO a_emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        VALUES (7521, 'WARD', 'SALESMAN', 7698, TO_DATE('1981-02-22', 'YYYY-MM-DD'), 1250, 500, 30)
    INTO a_emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        VALUES (7902, 'FORD', 'ANALYST', 7566, TO_DATE('1981-12-03', 'YYYY-MM-DD'), 3000, NULL, 20)
    INTO a_emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        VALUES (7369, 'SMITH', 'CLERK', 7902, TO_DATE('1980-12-17', 'YYYY-MM-DD'), 800, NULL, 20)
    INTO a_emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        VALUES (7788, 'SCOTT', 'ANALYST', 7566, TO_DATE('1982-12-09', 'YYYY-MM-DD'), 3000, NULL, 20)
    INTO a_emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        VALUES (7876, 'ADAMS', 'CLERK', 7788, TO_DATE('1983-01-12', 'YYYY-MM-DD'), 1100, NULL, 20)
    INTO a_emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
        VALUES (7934, 'MILLER', 'CLERK', 7782, TO_DATE('1982-01-23', 'YYYY-MM-DD'), 1300, NULL, 10)
SELECT * FROM dual;

SELECT * FROM a_emp;
-- DELETE FROM a_emp;

INSERT ALL
    INTO a_dept (deptno, dname, loc) 
        VALUES (10, 'ACCOUNTING', 'NEW YORK')
    INTO a_dept (deptno, dname, loc) 
        VALUES (20, 'RESEARCH', 'DALLAS')
    INTO a_dept (deptno, dname, loc) 
        VALUES (30, 'SALES', 'CHICAGO')
    INTO a_dept (deptno, dname, loc) 
        VALUES (40, 'OPERATIONS', 'BOSTON')
SELECT * FROM dual;

SELECT * FROM a_dept;
-- DELETE FROM a_dept;

INSERT ALL
    INTO a_salgrade (grade, losal, hisal) 
        VALUES (1, 700, 1200)
    INTO a_salgrade (grade, losal, hisal) 
        VALUES (2, 1201, 1400)
    INTO a_salgrade (grade, losal, hisal) 
        VALUES (3, 1401, 2000)
    INTO a_salgrade (grade, losal, hisal) 
        VALUES (4, 2001, 3000)
    INTO a_salgrade (grade, losal, hisal) 
        VALUES (5, 3001, 9999)
SELECT * FROM dual;

SELECT * FROM a_salgrade;
-- DELETE FROM a_salgrade;