/*
    USE oracle_peldatar database for this.
    21c -> IF NOT EXISTS not working
    26ai -> IF NOT EXISTS  working
*/
--DROP TABLE emp;
CREATE TABLE a_emp (
    empno    NUMBER(4) NOT NULL, -- Dolgozó azonosítója
    ename    VARCHAR2(10),       -- Dolgozó neve
    job      VARCHAR2(9),        -- Dolgozó foglalkozása/munkaköre
    mgr      NUMBER(4),          -- Dolgozó vezetőjének/főnökének azonosítója
    hiredate DATE,               -- Dolgozó belépési ideje/dátuma
    sal      NUMBER(7, 2),       -- Dolgozó havi fizetése
    com      NUMBER(7, 2),       -- Dolgozó havi jutaléka
    deptno   NUMBER(2)           -- Dolgozó részlegének azonosítója
);

--ALTER TABLE a_emp
--    RENAME COLUMN com TO comm;

--DROP TABLE dept;
CREATE TABLE a_dept (
    deptno  NUMBER(2) NOT NULL,  -- Részleg azonosítója
    dname   VARCHAR2(14),        -- Részleg neve
    loc     VARCHAR2(13)         -- Részleg telephelye
);

--DROP TABLE salgrade;
CREATE TABLE a_salgrade (
    grade NUMBER(1),             -- Fizetési kategória sorszáma
    losal NUMBER(4),             -- Fizetési kategória alsó határa
    hisal NUMBER(4)              -- Fizetési kategória felső határa  
);