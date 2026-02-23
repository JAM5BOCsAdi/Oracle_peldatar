-- ========================================================================
-- Többtáblás lekérdezések, allekérdezések
-- Leírás:  56. - 70.o.
-- Feladatgyűjtemény + megoldás: 336. - 372.o.
-- ========================================================================

-- 3.1. feladat:
-- Listázza ki azon dolgozók nevét és részlegük nevét, akiknek nevében az 'A' betű szerepel.
SELECT
    e.ename AS nev,
    d.dname AS reszlegnev
FROM 
    a_emp e
    LEFT JOIN a_dept d ON e.deptno = d.deptno
WHERE e.ename LIKE '%A%';

-- 3.2. feladat:
-- Listázza ki a DALLAS-i telephely minden dolgozójának nevét, munkakörét, fizetését és részlegének azonosítóját.
SELECT
    e.ename     AS nev,
    e.job       AS munkakor,
    e.sal       AS fizetes,
    e.deptno    AS reszleg
FROM 
    a_emp e
    INNER JOIN a_dept d ON e.deptno = d.deptno
WHERE UPPER(d.loc) = 'DALLAS'
ORDER BY fizetes ASC;

-- 3.3 feladat:
-- Listázza ki a CLERK munkakörű dolgozókat foglalkoztató részlegek azonosítóját, nevét és telephelyét.
-- A lista a részlegnév szerint legyen rendezve.
SELECT DISTINCT
    d.deptno AS reszleg,
    d.dname  AS reszlegnev,
    d.loc    AS telephely,
    e.job    AS munkakor
FROM 
    a_emp e
    INNER JOIN a_dept d ON e.deptno = d.deptno
WHERE UPPER(e.job) = 'CLERK'
ORDER BY reszlegnev ASC;

-- 3.4. feladat:
-- Listázza ki a DALLAS-ban és CHICAGO-ban dolgozók nevét, munkakörét és telephelyét.
-- A lista telephely szerint legyen rendezett.
SELECT
    e.ename AS nev,
    e.job   AS munkakor,
    d.loc   AS telephely
FROM 
    a_emp e
    INNER JOIN a_dept d ON e.deptno = d.deptno
WHERE UPPER(d.loc) IN ('DALLAS', 'CHICAGO')
ORDER BY telephely ASC;

-- 3.5. feladat:
-- Listázza ki az egyes részlegek nevét, telephelyük címét, dolgozóik átlagfizetését
-- a részlegnevek szerint rendezve.
SELECT 
    d.dname     AS reszlegnev,
    d.loc       AS telephely,
    ROUND(AVG(e.sal), 2)  AS atlagfizetes
FROM 
    a_emp e
    INNER JOIN a_dept d ON e.deptno = d.deptno
GROUP BY d.dname, d.loc
ORDER BY reszlegnev ASC;

-- 3.6. feladat:
-- Listázza ki a 20-as és a 30-as részleg legnagyobb fizetésű dolgozóinak azonosítóját,
-- nevét, foglalkozását, jutalékát és belépési dátumát.
SELECT 
    e1.empno AS azon, 
    e1.ename AS nev,
    e1.job AS munkakor,
    e1.comm AS jutalek,
    TO_CHAR(e1.hiredate, 'YYYY-MM-DD') AS belepes,
    sub.max_fiz AS max_fizetes
FROM 
    a_emp e1,
    (
        SELECT 
            MAX(e2.sal) AS max_fiz,
            e2.deptno
        FROM a_emp e2
        GROUP BY e2.deptno
        HAVING e2.deptno IN (20, 30)
    ) sub
WHERE e1.sal = sub.max_fiz;

-- Másik megoldás:
SELECT empno, ename, job, comm, hiredate, deptno, sal
FROM (
    SELECT e.*,
           RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS rnk
    FROM a_emp e
    WHERE deptno IN (20, 30)
)
WHERE rnk = 1
ORDER BY deptno;

-- 3.7. feladat:
-- Listázza ki minden részleg legkisebb jövedelmű dolgozójának azonosítóját, nevét,
-- foglalkozását, jutalékát és belépési dátumát.
SELECT 
    e1.empno AS azon, 
    e1.ename AS nev,
    e1.job AS munkakor,
    e1.comm AS jutalek,
    TO_CHAR(e1.hiredate, 'YYYY-MM-DD') AS belepes,
    sub.min_jov AS min_jovedelem
FROM 
    a_emp e1
    INNER JOIN
    (
        SELECT 
            MIN(e2.sal + NVL(e2.comm, 0)) AS min_jov,
            e2.deptno
        FROM a_emp e2
        GROUP BY e2.deptno
    ) sub
        ON e1.deptno = sub.deptno
WHERE e1.sal + NVL(e1.comm, 0) = sub.min_jov
ORDER BY min_jovedelem DESC;

-- 3.8. feladat:
-- Listázza ki azon részlegek nevét és telephelyét, ahol a dolgozók átlagjövedelme kisebb, 
-- mint 2200 USD.
SELECT
    d.dname AS reszlegnev,
    d.loc AS telephely,
    ROUND(AVG(e.sal + NVL(e.comm, 0)), 2)  AS atlagjovedelem
FROM 
    a_dept d
    INNER JOIN a_emp e ON d.deptno = e.deptno
GROUP BY d.dname, d.loc
HAVING AVG(e.sal + NVL(e.comm, 0)) < 2200;

-- 3.9. feladat:
-- Írjon olyan lekérdezést, ami megadja az összes, jutalékkal rendelkező alkalmazott nevét,
-- részlegének nevét és helyét.
SELECT
    e.ename AS nev,
    d.dname AS reszlegnev,
    d.loc   AS telephely
FROM 
    a_emp e
    INNER JOIN a_dept d ON e.deptno = d.deptno
WHERE e.comm IS NOT NULL;

-- 3.10. feladat:
-- Listázza ki a dolgozók nevét és azonosítóját a főnökük (mgr) nevével és 
-- azonosítójával együtt úgy, hogy akinek nincs főnöke, annak a NULL érték helyére
-- a 'Legfobb' karaktersorozatot írja.
SELECT
    dolg.ename AS dolg_neve,
    dolg.empno AS dolg_azon,
    fonok.ename AS fonok_neve,
    NVL(TO_CHAR(fonok.empno), 'Legfobb') AS fonok_azon
FROM
    a_emp dolg LEFT JOIN a_emp fonok
        ON dolg.mgr = fonok.empno
ORDER BY fonok_neve;

-- 3.11. feladat:
-- Listázza ki a NEW YORK telephely minden dolgozójának nevét, azonosítóját,
-- jövedelmét és főnökének nevét, telephelyét.
SELECT
    dolg.ename                   AS dolg_neve,
    dolg.empno                   AS dolg_azon,
    dolg.sal + NVL(dolg.comm, 0) AS jovedelem,
    fonok.ename                  AS fonok_neve,
    d.loc                        AS telephely
FROM
    a_emp dolg 
    LEFT JOIN a_emp fonok
        ON dolg.mgr = fonok.empno
    INNER JOIN a_dept d
        ON dolg.deptno = d.deptno
WHERE UPPER(d.loc) = 'NEW YORK'
ORDER BY fonok_neve;

-- 3.12. feladat:
-- Listázza ki mindazon alkalmazott nevét, részlegének nevét és fizetését, akiknek
-- fizetése megegyezik valamelyik DALLAS-ban dolgozó alkalmazottéval.
-- Legyen a lista fejléce név, részleg neve, fizetés, és a lista legyen a fizetés és 
-- a részleg neve szerint rendezett.
SELECT
    e.ename AS dolg_neve,
    d.dname AS reszleg_neve,
    e.sal   AS dolg_fizetese
FROM a_emp e INNER JOIN a_dept d ON e.deptno = d.deptno
WHERE
    e.sal IN 
    (
        SELECT
            e.sal 
            -- d.loc
        FROM a_emp e INNER JOIN a_dept d ON e.deptno = d.deptno
        WHERE UPPER(d.loc) = 'DALLAS'
    )
ORDER BY
    dolg_fizetese ASC,
    reszleg_neve ASC;
    
-- 3.13. feladat:
-- Listázza ki azokat a dolgozókat, akiknek neve HASONLÍT (SOUNDEX) egy munkakör nevéhez.
-- Összes munkakört megnézi minden 
SELECT DISTINCT
    e1.ename      AS nev,
    sub.munkakor  AS hasonlo_munkakor
FROM a_emp e1,
     (
         SELECT e2.job AS munkakor
         FROM a_emp e2
     ) sub
WHERE SOUNDEX(UPPER(e1.ename)) = SOUNDEX(UPPER(sub.munkakor));

-- 3.14. feladat:
-- Listázza ki azoknak a főnököknek az azonosítóját, akik nem menedzser foglalkozásúak.
-- A lista a főnök azonosítója (mgr) szerint legyen rendezett.
SELECT e1.mgr
FROM a_emp e1
GROUP BY e1.mgr

INTERSECT

SELECT e2.empno
FROM a_emp e2
WHERE UPPER(e2.job) != 'MANAGER';

-- Másik megoldás:
SELECT
    fonok.mgr AS fonok_azon
    -- dolg.job  AS dolg_munkakor
FROM
    a_emp dolg
    INNER JOIN 
    (
        SELECT e2.mgr
        FROM a_emp e2
        GROUP BY e2.mgr
    ) fonok
        ON dolg.empno = fonok.mgr
WHERE UPPER(dolg.job) != 'MANAGER'
ORDER BY fonok_azon ASC;

-- 3.15. feladat:
-- Hány olyan főnök van, aki nem MANAGER foglalkozású?
SELECT COUNT(DISTINCT e1.empno) AS nem_manager_fonokok_szama
FROM a_emp e1
WHERE e1.empno IN (
                    SELECT e2.mgr 
                    FROM a_emp e2 
                    WHERE e2.mgr IS NOT NULL
                  )
  AND e1.job <> 'MANAGER';

-- 3.16. feladat:
-- Listázza ki a főnökeik szerint csoportosítva a legkisebb jövedelmű dolgozókat.
-- Hagyja ki azokat a dolgozókat, akiknek nincs főnökük, valamint azokat a csoportokat,
-- ahol a legkisebb jövedelem nagyobb 3000 USD-nál.
-- Rendezze a listát a legkisebb jövedelmek szerint növekvően.
SELECT
    e1.ename                AS dolg_neve,
    e1.mgr                  AS dolg_fonoke,
    kisj.min_dolg_jovedelme AS min_dolg_jov
FROM 
    a_emp e1
    INNER JOIN
    (
        SELECT 
            e2.mgr                        AS fonoke,
            MIN(e2.sal + NVL(e2.comm, 0)) AS min_dolg_jovedelme
        FROM a_emp e2
        where e2.mgr IS NOT NULL
        GROUP BY e2.mgr
        HAVING MIN(e2.sal + NVL(e2.comm, 0)) <= 3000       
    ) kisj 
        ON e1.mgr = kisj.fonoke
WHERE kisj.min_dolg_jovedelme = e1.sal + NVL(e1.comm, 0)
ORDER BY min_dolg_jov ASC;

-- 3.17. feladat:
-- Listázza ki minden olyan dolgozó azonosítóját és nevét, akik olyan részlegen dolgoznak, 
-- melyen található nevében T betűt tartalmazó dolgozó.
-- Legyen a lista fejléce azonosító, név, részleg helye, és a lista legyen a részleg helye
-- és a név szerint rendezett.

-- Tehát nem a T‑s nevű dolgozókat kell listázni, hanem mindenkit, aki olyan részlegen van, ahol valaki T‑s nevű.
SELECT
    e1.empno AS dolg_azon,
    e1.ename AS dolg_neve,
    d.loc    AS telephely,
    e1.deptno
FROM
    a_emp e1
    INNER JOIN a_dept d ON e1.deptno = d.deptno
WHERE e1.deptno IN (
        SELECT DISTINCT e2.deptno
        FROM a_emp e2
        WHERE UPPER(e2.ename) LIKE '%T%'
      )
ORDER BY 
    telephely ASC, 
    dolg_neve ASC;

-- 3.18. feladat:
-- Listázza ki a főnökeik (mgr) szerint csoportosítva azokat a dolgozókat, akiknek fizetése
-- e csoportosítás szerint a legkisebb, de nagyobb 1000 USD-nál. A lista a fizetés növekvő értéke
-- szerint legyen rendezett.
-- Legyen a lista fejléce: fonok_azon | dolg_nev | fizetes
SELECT
    sub.mgr AS fonok_azon,
    e1.ename AS dolg_neve,
    e1.sal AS dolg_fizetese
FROM 
    a_emp e1
    INNER JOIN 
    (
        SELECT
            e2.mgr,
            MIN(e2.sal) AS dolg_min_sal
        FROM a_emp e2
        GROUP BY e2.mgr
        HAVING MIN(e2.sal) > 1000
    ) sub
        ON e1.mgr = sub.mgr
WHERE e1.sal = sub.dolg_min_sal
ORDER BY dolg_fizetese ASC;


-- 3.19. feladat:
-- Listázza ki azon főnököknél (mgr) a legkisebb és legnagyobb fizetéseket, melyeknél
-- a legkisebb fizetések 3000 USD-nál alacsonyabbak.
-- A listát a legkisebb fizetés szerint rendezze, a fejléc pedig legyen:
-- fonok_azon | min_fiz | max_fiz
SELECT 
    e.mgr AS fonok_azon,
    MIN(e.sal) AS min_fiz,
    MAX(e.sal) AS max_fiz
FROM a_emp e
WHERE e.mgr IS NOT NULL
GROUP BY e.mgr
HAVING MIN(e.sal) < 3000
ORDER BY max_fiz ASC;

-- 3.20. feladat: [Hibás a megoldása]
-- Listázza ki fizetés szerint csökkenő sorba rendezve az eladók (SALESMAN) és a 
-- hivatalnokok (CLERK) főnökeinek nevét és fizetését, az egyes dolgozók saját nevét,
-- munkakörét, fizetését, valamint az egyes dolgozük saját fizetése / főnök fizetése arányát.
-- Elsődlegesen a főnök neve szerint, másodlagosan a fizetés aránya szerint rendezve.
SELECT
    m.ename AS fonok_neve,
    m.sal   AS fonok_fizetese,
    e.ename AS dolg_neve,
    e.job   AS dolg_munkakore,
    e.sal   AS dolg_fizetese,
    ROUND(e.sal / m.sal, 3) AS fizetesi_arany
FROM a_emp e
     INNER JOIN a_emp m ON e.mgr = m.empno
WHERE e.job IN ('SALESMAN', 'CLERK')
ORDER BY 
    m.ename,
    fizetesi_arany;

-- ------------------------------------------------------------------------
-- Összetett feladatok és megoldások
-- Leírás:  56. - 70.o.
-- Feladatgyűjtemény + megoldás: 353. - 372.o.
-- ------------------------------------------------------------------------

-- 3.21. feladat:
-- Listázza ki a CHICAGO-i telephelyű főnök nevét, azonosítóját, munkakörét, fizetését,
-- beosztottjainak átlagfizetését és annak szórását és varianciáját.
SELECT
    fonok.ename AS fonok_neve,
    fonok.empno AS fonok_azon,
    fonok.job   AS fonok_munkakor,
    fonok.sal   AS fonok_fiz,
    ROUND(dolgozo.atlagfiz, 2)  AS dolgozoi_atlagfiz,
    ROUND(dolgozo.szoras, 2)    AS dolgozoi_fiz_szoras,
    ROUND(dolgozo.variancia, 2) AS dolgozoi_fiz_variancia,
    d.loc
FROM 
    a_emp fonok
    INNER JOIN a_dept d ON fonok.deptno = d.deptno
    INNER JOIN
    (
        SELECT 
            e2.mgr,
            AVG(e2.sal)       AS atlagfiz,
            STDDEV(e2.sal)    AS szoras,
            VARIANCE(e2.sal)  AS variancia
        FROM a_emp e2
        GROUP BY e2.mgr                
    ) dolgozo
        ON fonok.empno = dolgozo.mgr
WHERE UPPER(d.loc) = 'CHICAGO'
;

-- 3.22. feladat:
-- Listázza ki a 2000 USD és 4000 USD közötti fizetésű főnökök nevét, fizetését, telephelyét
-- és beosztottjainak átlagfizetését a főnök neve szerint rendezve.
SELECT
    fonok.ename AS fonok_neve,
    fonok.sal   AS fonok_fiz,
    -- fonok.job   AS fonok_munkakor,
    d.loc       AS telephely,
    ROUND(dolgozo.atlagfiz, 2)  AS dolgozoi_atlagfiz
FROM 
    a_emp fonok
    INNER JOIN a_dept d ON fonok.deptno = d.deptno
    INNER JOIN
    (
        SELECT 
            e2.mgr,
            AVG(e2.sal) AS atlagfiz
        FROM a_emp e2
        GROUP BY e2.mgr                
    ) dolgozo
        ON fonok.empno = dolgozo.mgr
WHERE fonok.sal BETWEEN 2000 AND 4000
ORDER BY fonok_neve ASC
;

-- 3.23. feladat:
-- Listázza ki minden részleg legkisebb jövedelmű dolgozójának azonosítóját, nevét,
-- foglalkozását, részlegének azonosítóját, telephelyét és munkában eltöltött éveinek számát.
-- Legyen a lista a munkában töltött évek szerint rendezve.
SELECT
    e1.empno  AS dolg_azon,
    e1.ename  AS dolg_neve,
    e1.job    AS dolg_munkakore,
    e1.deptno AS dolg_reszlege,
    ROUND(MONTHS_BETWEEN(SYSDATE, e1.hiredate) / 12, 2) AS evek,
    sub.min_jov AS dolg_min_jovedelme,
    d.loc     AS dolg_telephelye
FROM 
    a_emp e1
    INNER JOIN a_dept d 
        ON e1.deptno = d.deptno
    INNER JOIN
    (
        SELECT
            e2.deptno,
            MIN(e2.sal + NVL(e2.comm, 0)) AS min_jov
        FROM a_emp e2
        GROUP BY e2.deptno    
    ) sub
        ON e1.deptno = sub.deptno 
WHERE (e1.sal + NVL(e1.comm, 0)) = sub.min_jov
ORDER BY evek ASC
;

-- 3.24. feladat:
-- Listázza ki az egyes részlegek telephelyének nevét, a részleg dolgozóinak egész értékre
-- kerekített átlagjövedelmét, valamint az itt dolgozók főnökeinek nevét, fizetését és telephelyét
-- az átlagjövedelem szerint rendezve, és a részlegadatokat ismétlésmentesen megjelenítve.
