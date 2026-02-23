-- ========================================================================
-- Egyszerű lekérdezések
-- Leírás:  19. - 48.o.
-- Feladatgyűjtemény + megoldás: 303. - 320.o.
-- ========================================================================

-- SET the DATE format for a SESSION to 'YYYY-MM-DD' for better readability
-- When you disconnect or shut down the client/PC the setting is lost.
-- SELECT * FROM nls_session_parameters WHERE parameter = 'NLS_DATE_FORMAT';
-- ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

-- ALTER SYSTEM SET NLS_DATE_FORMAT = 'YYYY-MM-DD' SCOPE=BOTH;
-- restart the database as SYSDBA:
-- SHUTDOWN IMMEDIATE;
-- STARTUP;

-- SELECT parameter, value FROM nls_database_parameters WHERE parameter='NLS_DATE_FORMAT';
-- SELECT parameter, value FROM nls_instance_parameters WHERE parameter='NLS_DATE_FORMAT';

-- 1.1. feladat:
-- Listázza ki a 20-as részleg dolgozóinak nevét, belépési idejét, foglalkozását a nevek szerint csökkenően rendezve.
SELECT e.ename, e.hiredate, e.job
FROM a_emp e
WHERE e.deptno = 20
ORDER BY e.ename DESC;

-- 1.2. feladat:
-- Készítsen két listát, melyek a dolgozók adatait tartalmazzák. Az egyiket a fizetés szerint
-- növekvően, a másikat a fizetés szerint csökkenően.
SELECT *
FROM a_emp e
ORDER BY e.sal ASC;

SELECT *
FROM a_emp e
ORDER BY e.sal DESC;

-- 1.3. feladat:
-- Listázza ki a dolgozók nevét, fizetését, jövedelmét a jövedelmük szerint csökkenően rendezve.
-- JÖVEDELEM: Fizetés + jutalék
SELECT
    e.ename                  AS nev, 
    e.sal                    AS fizetes,
    (e.sal + NVL(e.comm, 0)) AS jovedelem  
FROM a_emp e
ORDER BY jovedelem DESC;

-- 1.4. feladat:
-- Listázza ki a dolgozók nevét, részlegüket, jövedelmüket és az adójukat, az adójuk szerint csökkenően, a nevük szerint pedig növekvő módon rendezve.
-- ADÓ: JÖVEDELMÜK 20%-a
SELECT
    e.ename                         AS nev,
    e.deptno                        AS reszleg,
    (e.sal + NVL(e.comm, 0))        AS jovedelem,
    (e.sal + NVL(e.comm, 0)) * 0.20 AS ado
FROM a_emp e
ORDER BY
    ado DESC,
    nev ASC;

-- 1.5. feladat:
-- Írassa ki azon alkalmazottak nevét, munkakörét és fizetését, akiknek fizetése NINCS az 1500-2850 USD tartományban.
-- A lista fejléce legyen: NEV | MUNKAKOR | FIZETES
SELECT
    e.ename AS nev,
    e.job   AS munkakor,
    e.sal   AS fizetes
FROM a_emp e
WHERE e.sal NOT BETWEEN 1500 AND 2850;

-- 1.6. feladat:
-- Írassa ki azon dolgozók nevét, munkakörét, fizetését, jutalékát és részlegazonosítóját, akik 1000 USD-nál többet keresnek,
-- és 1981-03-01 és 1981-09-30 között léptek be a vállalathoz.
SELECT
    e.ename     AS nev,
    e.job       AS munkakor,
    e.sal       AS fizetes,
    e.comm      AS jutalek,
    e.deptno    AS reszleg,
    TO_CHAR(e.hiredate, 'YYYY-MM-DD') AS belep_datum
FROM a_emp e
WHERE 
    e.sal > 1000 AND 
    e.hiredate BETWEEN TO_DATE('1981-03-01', 'YYYY-MM-DD') AND TO_DATE('1981-09-30', 'YYYY-MM-DD');

-- 1.7. feladat:
-- Írassa ki a jutalékkal rendelkező alkalmazottak nevét, jutalékát, főnökének azonosítóját.
-- Legyen a lista rendezett a főnök azonosítója és az alkalmazottak neve szerint.
SELECT
    e.ename     AS nev,
    e.comm      AS jutalek,
    e.mgr       AS fonok
FROM a_emp e
WHERE e.comm IS NOT NULL
ORDER BY fonok ASC, nev ASC;

-- 1.8. feladat:
-- Írassa ki azon alkalmazottak azonosítóját, nevét, foglalkozását, fizetését és jutalékát, akiknek jutaléka meghaladja a fizetésük 50%-át.
SELECT
    e.empno     AS azon,
    e.ename     AS nev,
    e.job       AS munkakor,
    e.sal       AS fizetes,
    e.comm      AS jutalek,
    e.mgr       AS fonok,
    (0.5 * e.sal) AS fizetes_50
FROM a_emp e
WHERE e.comm > (0.5 * e.sal)
ORDER BY nev ASC;

-- 1.9. feladat:
-- Írja ki azon dolgozók nevét, foglalkozását, fizetését és belépési dátumát, akik 1981-ben léptek be a vállalathoz.
-- A lista a belépési dátum szerint legyen rendezve.
SELECT 
    e.ename                             AS nev,
    e.job                               AS munkakor,
    e.sal                               AS fizetes,
    TO_CHAR(e.hiredate, 'YYYY-MM-DD')   AS belepes,
    EXTRACT(YEAR FROM e.hiredate)       AS ev
FROM a_emp e
WHERE EXTRACT(YEAR FROM e.hiredate) = 1981
ORDER BY e.hiredate ASC;

-- 1.10. feladat:
-- Listázza ki azon alkalmazottak nevét, foglalkozását és jövedelmét, akiknek a nevében két L betű szerepel,
-- továbbá vagy a 30-as részlegen dolgozik, vagy a főnökének azonosítója 7782.
-- JÖVEDELEM: Fizetés + jutalék => (e.sal + NVL(e.comm, 0))
SELECT
    e.ename                  AS nev,
    e.job                    AS munkakor,
    (e.sal + NVL(e.comm, 0)) AS jovedelem
FROM a_emp e
WHERE 
    UPPER(e.ename) LIKE '%L%L%' 
    AND 
    (e.deptno = 30 OR e.mgr = 7782);

-- 1.11. feladat:
-- Listázza ki részlegazonosító szerint rendezve a CLERK és a SALESMAN munkakörű dolgozók éves fizetését a részleg szerint rendezve.
-- ÉVES FIZETÉS: 12 * e.sal
SELECT
    e.ename      AS nev,
    e.job        AS munkakor,
    e.deptno     AS reszleg,
    (12 * e.sal) AS eves_fizetes
FROM a_emp e
WHERE UPPER(e.job) IN ('CLERK', 'SALESMAN')
ORDER BY reszleg;

-- 1.12. feladat:
-- Listázza ki az összes dolgozót oly módon, hogy azoknál, akik nem kapnak jutalékot, az a szöveg jelenjen meg, hogy "Nincs jutalék".
-- A lista fejléce legyen: AZON | BELEP | NEV | MUNKAKOR | JUTALEK
SELECT
    e.empno                              AS azon,
    e.hiredate                           AS belep,
    e.ename                              AS nev,
    e.job                                AS munkakor,
    NVL(TO_CHAR(e.comm), 'Nincs jutalek') AS jutalek
FROM a_emp e;

-- 1.13. feladat:
-- Listázza ki a 'MAN' karaktersorozatot tartalmazó munkakörben dolgozók nevét és munkakörét,
-- a munkakör és a név szerint rendezve.
SELECT
    e.ename AS nev,
    e.job   AS munkakor
FROM a_emp e
WHERE UPPER(e.job) LIKE '%MAN%'
ORDER BY
    nev ASC,
    munkakor ASC;
    
-- 1.14. feladat:
-- Listázza ki foglalkozás szerint csoportosítva azon dolgozók nevét, foglalkozását, 
-- jövedelmét és részlegét, akiknek jövedelme kisebb 2500 USD-nál, valamint 1981 és 1982 között léptek be.
-- A keletkezett lista elsődlegesen a foglalkozás, másodlagosan a dolgozó neve szerint legyen rendezve.
-- JÖVEDELEM: Fizetés + jutalék
SELECT
    e.ename                           AS nev,
    e.job                             AS munkakor,
    e.deptno                          AS reszleg,
    (e.sal + NVL(e.comm, 0))          AS jovedelem,
    TO_CHAR(e.hiredate, 'YYYY-MM-DD') AS hiredate
FROM a_emp e
WHERE 
    (e.sal + NVL(e.comm, 0)) < 2500
    AND
    EXTRACT(YEAR FROM e.hiredate) BETWEEN 1981 AND 1982
ORDER BY 
    munkakor ASC,
    nev ASC;
    
-- 1.15. feladat:
-- Listázza ki azoknak az alkalmazottaknak a nevét, éves fizetését és a munkában eltöltött hónapjainak számát,
-- akik 1981-07-01 előtt léptek be a vállalathoz.
-- A lista a hónapok száma szerint csökkenően legyen rendezve.
SELECT
    e.ename        AS nev,
    (12 * e.sal)   AS eves_fizetes,
    ROUND(MONTHS_BETWEEN(SYSDATE, e.hiredate)) AS munka_honapok,
    TO_CHAR(e.hiredate, 'YYYY-MM-DD') AS hiredate
FROM a_emp e
WHERE e.hiredate < TO_DATE('1981-07-01', 'YYYY-MM-DD')
ORDER BY munka_honapok DESC;

-- 1.16. feladat:
-- Listázza ki a C és M betűvel kezdődő foglalkozású alkalmazottak nevét (nevüket nagybetűvel kezdve és
-- kisbetűvel folytatva), valamint nevük hosszát.
-- Rendezze a listát a foglalkozás szerint.
SELECT
    INITCAP(e.ename) AS nev,
    LENGTH(e.ename) AS nev_hossz,
    INITCAP(e.job) AS munkakor
FROM a_emp e
WHERE
    UPPER(e.job) LIKE 'C%' OR
    UPPER(e.job) LIKE 'M%'
ORDER BY munkakor ASC;

-- 1.17. feladat:
-- A belépési dátum napjai szerint csoportosítva listázza ki azon dolgozók azonosítóját, nevét jövedelmét,
-- munkába állás napját, részlegét, akiknek jövedelme 1300 és 5500 USD közötti érték.
-- A keletkezett lista elsődlegesen a napok sorszáma szerint, másodlagosan a dolgozók neve szerint legyen
-- rendezve. A hét első napja legyen a vasárnap.
SELECT
    e.empno AS azonosito,
    e.ename AS nev,
    (e.sal + NVL(e.comm, 0)) AS jovedelem,
    TO_CHAR(e.hiredate, 'DAY') AS munkaba_allas,
    e.deptno AS reszleg
FROM a_emp e
WHERE (e.sal + NVL(e.comm, 0)) BETWEEN 1300 AND 5500
ORDER BY
    TO_CHAR(e.hiredate + 1, 'D'),
    e.ename;

-- 1.18. feladat:
-- A vállalatnál hűségjutalmat adnak, és ehhez szükséges azon dolgozók azonosítója, neve, fizetése
-- és munkában eltöltött éve, akik legalább 15 éve álltak munkába.
-- Rendezze a listát a munkában eltöltött évek szerint csökkenően, valamint az azonosító szerint növekvően.

-- Fel van extrázva CASE kifejezéssel, hogy aki 44 évnél többet töltött el, az sok.
SELECT
    e.empno AS azonosito,
    e.ename AS nev,
    e.sal   AS fizetes,
    FLOOR(MONTHS_BETWEEN(SYSDATE, e.hiredate) / 12) AS munkaban_toltot_evek,
    CASE 
        WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, e.hiredate) / 12) > 44 
            THEN 'Sok ev' 
        ELSE 'Ok' 
    END AS ellenorzes
FROM a_emp e
WHERE MONTHS_BETWEEN(SYSDATE, e.hiredate) / 12 >= 15
ORDER BY
    munkaban_toltot_evek DESC,
    e.empno ASC;

-- 1.19. feladat:
-- Listázza ki a dolgozók nevét, munkakörét, fizetését és a fizetési kategóriáját, mely
-- 100 USD alatt 1, 2000 USD alatt 2, stb...
-- Ez utóbb iszerint csökkenően rendezve.
-- A fizetéstartomány 1..6000 USD.
SELECT
    e.ename AS nev,
    e.job   AS munkakor,
    e.sal   AS fizetes,
    CASE
        WHEN e.sal < 0 THEN -1
        WHEN e.sal > 0 AND e.sal < 1000 THEN 1
        WHEN e.sal >= 1000 AND e.sal < 2000 THEN 2
        WHEN e.sal >= 2000 AND e.sal < 3000 THEN 3
        WHEN e.sal >= 3000 AND e.sal < 4000 THEN 4
        WHEN e.sal >= 4000 AND e.sal < 5000 THEN 5
        WHEN e.sal >= 5000 AND e.sal < 6000 THEN 6
        ELSE 7
    END AS fizetes_kategoria
FROM a_emp e
ORDER BY fizetes_kategoria DESC;

-- 1.20. feladat:
-- Listázza ki a dolgozók nevét, azonosítóját és beosztását a név szerint rendezve.
-- Egy dolgozó beosztása "fonok", ha van beosztottja, egyébként NULL érték.
SELECT
    e.ename AS nev,
    e.empno AS azonosito,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM a_emp b
            WHERE b.mgr = e.empno
        )
        THEN 'fonok'
        ELSE NULL
    END AS beosztas
FROM a_emp e
ORDER BY nev ASC;





-- Példa, lefutási idő kiírására:

SET SERVEROUTPUT ON;


DECLARE
    v_start_time  TIMESTAMP := SYSTIMESTAMP;
    v_end_time    TIMESTAMP;
    v_diff        INTERVAL DAY TO SECOND;
    v_ms          NUMBER;
BEGIN
    -- Random művelet (1.2 másodperc)
    DBMS_LOCK.SLEEP(1.2);

    v_end_time := SYSTIMESTAMP;
    v_diff := v_end_time - v_start_time;

    -- Milliszekundum kiszámítása
    v_ms :=
          EXTRACT(DAY    FROM v_diff) * 24 * 60 * 60 * 1000
        + EXTRACT(HOUR   FROM v_diff) * 60 * 60 * 1000
        + EXTRACT(MINUTE FROM v_diff) * 60 * 1000
        + EXTRACT(SECOND FROM v_diff) * 1000;

    DBMS_OUTPUT.PUT_LINE('>> Load Duration: ' || v_ms || ' millisecond(s)');
    DBMS_OUTPUT.PUT_LINE('______________');
END;



