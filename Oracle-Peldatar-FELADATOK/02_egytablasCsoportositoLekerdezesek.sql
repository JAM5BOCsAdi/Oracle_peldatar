-- ========================================================================
-- Egytáblás csoportosító lekérdezések
-- Leírás:  49. - 55.o.
-- Feladatgyűjtemény + megoldás: 321. - 335.o.
-- ========================================================================

-- 2.1. feladat:
-- Listázza ki munkakörönként az átlagfizetéseket két tizedesre kerekítve.
-- Rendezze átlagfizetések szerint csökkenően.
SELECT
    e.job AS munkakor,
    ROUND(AVG(e.sal), 2) AS atlag_fizetes
FROM a_emp e
GROUP BY e.job
ORDER BY atlag_fizetes DESC;

-- 2.2. feladat: [NEM EGYÉRTELMŰ]
-- Listázza ki csökkenően rendezve a főnökök átlagfizetését egész értékre kerekítve.
-- Főnök az a dolgozó, akinek azonosítója szerepel az mgr oszlopban.

-- 1. variáció:
-- Listázza ki azoknak a dolgozóknak az átlagfizetését, akik főnöknek számítanak (azaz szerepelnek az mgr oszlopban).
-- Minden főnök külön sorban jelenjen meg, a saját fizetésük átlagával.
-- „Vegyük a főnököket, és nézzük meg, mennyit keresnek ők maguk.”
SELECT
    e.empno,
    e.ename,
    ROUND(AVG(e.sal)) AS atlag_fizetes
FROM a_emp e
WHERE e.empno IN (
                    SELECT DISTINCT mgr
                    FROM a_emp
                    WHERE mgr IS NOT NULL
                 )
GROUP BY e.empno, e.ename
ORDER BY atlag_fizetes DESC;

-- 2. variáció:
-- Számolja ki főnökönként a hozzájuk tartozó beosztottak átlagfizetését.
-- A főnököt az mgr oszlop értéke azonosítja.
-- Rendezze az eredményt csökkenő sorrendben a beosztottak átlagfizetése alapján.
-- „Vegyük a főnököket, és nézzük meg, mennyit keresnek átlagosan az alattuk dolgozók.”
SELECT 
    e.mgr               AS fonok,
    ROUND(AVG(e.sal),2) AS fonok_atlag
FROM a_emp e
GROUP BY e.mgr
ORDER BY fonok_atlag DESC;

-- 2.3. feladat:
-- Listázza ki részlegenként a legnagyobb és legkisebb havi jövedelmeket.
-- JÖVEDELEM: Fizetés + jutalék => (e.sal + NVL(e.comm, 0))
SELECT
    e.deptno AS reszleg,
    MIN(e.sal + NVL(e.comm, 0)) AS min_jovedelem,
    MAX(e.sal + NVL(e.comm, 0)) AS max_jovedelem
FROM a_emp e
GROUP BY e.deptno;


-- 2.4. feladat:
-- Listázza ki a legalább egy dolgozójú részlegeket a dolgozószám szerint csökkenően rendezve.
SELECT 
    e.deptno AS reszleg,
    COUNT(*) AS dolg_szam
FROM a_emp e
GROUP BY e.deptno
HAVING COUNT(*) > 0
ORDER BY dolg_szam DESC;

-- 2.5. feladat: [Nem a leghelyesebb a megoldás a megoldóban]
-- Listázza ki a főnökök azonosítóit, valamint azt, hogy hány beosztottjuk van.
-- Rendezze a listát a beosztottak száma szerint csökkenően.
-- Ha valakinek nincs főnöke, ahhoz írjon valamilyen megjegyzést (tulajdonos vagy elnök vagy nics főnök, stb...)
SELECT 
    CASE 
        WHEN e.mgr IS NULL THEN 'elnök'
        ELSE TO_CHAR(e.empno)
    END AS fonokazonosito,
    COUNT(b.empno) AS beosztottak_szama
FROM a_emp e
INNER JOIN a_emp b
     ON e.empno = b.mgr
GROUP BY 
    e.empno, 
    e.mgr
ORDER BY beosztottak_szama DESC;

-- 2.6. feladat:
-- Listázza ki az azonosítójuk hárommal való oszthatósága alapján a dolgozók
-- átlagjövedelmét, a dolgozók számát és legkisebb fizetését.
-- Ha a maradék 0, akkor osztható egyébként 3-mal.
SELECT
    ROUND(MOD(e.empno, 3)) AS maradek,
    CASE
        WHEN ROUND(MOD(e.empno, 3)) = 0 THEN 'Oszthato'
        ELSE 'Nem oszthato'
    END AS oszthato_e,
    ROUND(AVG(e.sal + NVL(e.comm, 0))) AS atlag_jovedelem,
    COUNT(*) AS letszam,
    MIN(e.sal) AS min_fizetes
FROM a_emp e
GROUP BY ROUND(MOD(e.empno, 3));

-- 2.7. feladat:
-- Listázza ki a 2000 USD-nál nagyobb átlagjövedelmeket egész értékre kerekítve a 
-- foglalkozás szerint csoportosítva.
-- A lista a foglalkozás szerint legyen rendezett.
SELECT
    e.job AS munkakor,
    ROUND(AVG(e.sal + NVL(e.comm, 0))) AS atlag_jovedelem
FROM a_emp e
GROUP BY e.job
HAVING ROUND(AVG(e.sal + NVL(e.comm, 0)))  > 2000
ORDER BY e.job ASC;

-- 2.8. feladat:
-- Listázza ki azokat a részlegeket, ahol a fizetésátlag nagyobb 1500 USD-nál.
-- Rendezze fizetésátlag szerint csökkenően.
SELECT
    e.deptno AS reszleg,
    ROUND(AVG(e.sal), 2) AS atlag_fizetes
FROM a_emp e
GROUP BY e.deptno
HAVING ROUND(AVG(e.sal), 2) > 1500
ORDER BY atlag_fizetes;

-- 2.9. feladat:
-- Listázza ki foglalkozásonként a legnagyobb jövedelmeket, jövedelem szerint rendezve.
SELECT
    e.job AS munkakor,
    MAX(e.sal + NVL(e.comm, 0)) AS max_jovedelem
FROM a_emp e
GROUP BY e.job
ORDER BY max_jovedelem ASC;

-- 2.10. feladat:
-- Listázza ki, hogy az egyes foglalkozási csoportokon belül hányan dolgoznak.
-- A lista a létszám szerint legyen rendezett.
SELECT
    e.job AS munkakor,
    COUNT(*) AS letszam
FROM a_emp e
GROUP BY e.job
ORDER BY letszam ASC;

-- 2.11. feladat:
-- Listázza ki a főnökök azonosítóit és a főnökökhöz tartozó beosztottak számát, ez utóbbi adat szerint rendezve.
SELECT 
    e.mgr AS fonok,
    COUNT(*) AS dolg_letszam
FROM a_emp e
WHERE mgr IS NOT NULL
GROUP BY e.mgr
ORDER BY dolg_letszam ASC;

-- 2.12. feladat:
-- Listázza ki azon foglalkozások átlagjövedelmát, amelyek nevében a "MAN" alsztring megtalálható.
-- A listát rendezze az átlagjövedelem szerint csökkenő sorrendben.
SELECT 
    e.job AS munkakor,
    ROUND(AVG(e.sal + NVL(e.comm, 0)), 2) AS atlagjovedelem
FROM a_emp e
WHERE UPPER(e.job) LIKE '%MAN%'
GROUP BY e.job
ORDER BY atlagjovedelem ASC;

-- 2.13. feladat:
-- Listázza ki rendezve azon foglalkozási csoportok átlagfizetését, ahol kettő vagy ennél több
-- alkalmazott dolgozik.
SELECT
    e.job AS munkakor,
    ROUND(AVG(e.sal), 2) AS atlag_fizetes,
    COUNT(*) AS letszam
FROM a_emp e
GROUP BY e.job
HAVING COUNT(*) >= 2
ORDER BY atlag_fizetes ASC;

-- 2.14. feladat:
-- Írjon utasítást azon részlegek azonosítójának, dolgozói számának és azok 
-- legnagyobb és legkisebb jövedelmének lekérdezésére, ahol a részlegszám páros.
-- A listát a részlegazonosító szerint rendezze.
SELECT
    e.deptno AS reszleg,
    COUNT(*) AS letszam,
    MIN(e.sal + NVL(e.comm, 0)) AS min_jovedelem,
    MAX(e.sal + NVL(e.comm, 0)) AS max_jovedelem,
    MOD(e.deptno, 2) AS maradek
FROM a_emp e
GROUP BY e.deptno
HAVING MOD(e.deptno, 2) = 0
ORDER BY e.deptno ASC;

-- 2.15. feladat:
-- Listázza ki azoknak az alkalmazottaknak a nevét, éves fizetését és a munkában eltöltött hónapjainak számát, akik
-- 1981-07-01 előtt léptek be a vállalathoz.
-- A lista a hónapok száma szerint csökkenően legyen rendezve.
SELECT
    e.ename AS nev,
    (12 * e.sal) AS eves_fizetes,
    ROUND(MONTHS_BETWEEN(SYSDATE, e.hiredate)) AS munka_honapok,
    ROUND((MONTHS_BETWEEN(SYSDATE, e.hiredate)) / 12, 2) AS munka_evek
FROM a_emp e
WHERE e.hiredate < TO_DATE('1981-07-01', 'YYYY-MM-DD')
ORDER BY munka_honapok DESC;

-- 2.16. fealdat:
-- Számítsa ki az átlagos jutalékot.
SELECT ROUND(AVG(e.comm)) AS atlagos_jutalek
FROM a_emp e
WHERE e.comm IS NOT NULL;

-- 2.17. feladat:
-- Készítsen listát a páros és páratlan azonosítójú dolgozók számáról.
-- maradek = 0 -> páros
-- maradek = 1 -> páratlan
SELECT
--    e.empno AS azon,
    MOD(e.empno, 2) AS maradek,
    COUNT(*) AS letszam
FROM a_emp e
GROUP BY MOD(e.empno, 2);

-- 2.18. feladat:
-- Listázza ki a dolgozók számát fizetéskategóriák szerint.
-- A fizetési kategóriákat vagy ön definiálja, vagy vegye a salgrade táblából.
SELECT
    s.grade AS kategoria,
    COUNT(*) AS letszam
FROM
    a_emp e,
    a_salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal
GROUP BY s.grade;


-- Kiírva a nevek is és kategóriák is.
SELECT
    s.grade AS kategoria,
    e.ename AS nev,
    e.sal AS fizetes,
    COUNT(*) OVER (PARTITION BY s.grade) AS letszam
FROM
    a_emp e,
    a_salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal
ORDER BY kategoria ASC;

-- 2.19. feladat:
-- Listázza ki főnökönként (mgr) a főnökhöz tartozó legkisebb dolgozói fizetéseket.
-- Hagyja ki azon dolgozók fizetését, akiknek nincs főnökük, valamint azokat a csoportokat,
-- ahol a legkisebb fizetés nagyobb 2000 USD-nál.
-- Rendezze a listát a legkisebb fizetések szerint növekvően.
SELECT
    e.mgr AS fonok,
    MIN(e.sal) AS min_fizetes
FROM a_emp e
GROUP BY e.mgr
HAVING MIN(e.sal) < 2000 AND e.mgr IS NOT NULL
ORDER BY min_fizetes ASC;

-- 2.20. fealdat:
-- Listázza ki főnökönként (mgr) a főnökhöz tartozó dolgozói átlagfizetéseket.
-- Hagyja ki azon dolgozók fizetését, akiknek nincs főnökük, valamint azokat a csoportokat,
-- ahol a átlagfizetés nagyobb 3000 USD-nál.
-- Rendezze a listát az átlagfizetések szerint csökkenően.
SELECT 
    e.mgr AS fonok,
    ROUND(AVG(e.sal), 2) AS atlagfizetes
FROM a_emp e
WHERE e.mgr IS NOT NULL
GROUP BY e.mgr
HAVING AVG(e.sal) < 3000
ORDER BY atlagfizetes DESC;

-- 2.21. feladat:
-- Listázza ki főnökönként a főnökhöz tartozó dolgozók jövedelme közül a legnagyobbat.
-- Hagyja ki a listakészítésből azon dolgozókat, akiknek nincs jutalékuk, valamint 
-- azokat a (legnagyobb) jövedelmeket, melyek nagyobbak 3500 USD-nál.
-- Rendezze a listát a legnagyobb jövedelem szerint csökkenően.

-- JÖVEDELEM: Fizetés + jutalék => (e.sal + NVL(e.comm, 0))
SELECT
    e.mgr AS fonok,
    MAX(e.sal + e.comm) AS max_jovedelem
FROM a_emp e
WHERE e.comm IS NOT NULL
GROUP BY e.mgr
HAVING MAX(e.sal + e.comm) <= 3500
ORDER BY max_jovedelem DESC;

-- 2.22. feladat:
-- Listázza ki részlegenként az egy tizedesre kerekített átlagfizetéseket.
-- Hagyja ki az átlag meghatározásából az 1981-01-01-je előtt belépett dolgozókat,
-- valamint azon részlegek átlagfizetését, melyekben a legkisebb fizetés kisebb 1000 USD-nál.
-- Rendezze a listát az átlagfizetések szerint növekvően.
SELECT 
    e.deptno AS reszleg,
    ROUND(AVG(e.sal), 1) AS atlagfizetes
FROM a_emp e
WHERE e.hiredate > TO_DATE('1981-01-01', 'YYYY-MM-DD')
GROUP BY e.deptno
HAVING MIN(e.sal) >= 1000
ORDER BY atlagfizetes ASC;

-- 2.23. feladat:
-- Listázza ki munkakörönként a dolgozók számát és az egész értkre kerekített átlagfizetésüket
-- numerikusan és grafikusan is. Ez utóbbi csillag (*) karakterek sorozataként balra igazítva
-- jelenítse meg oly módon, hogy e sorozatban 200 US dolláronként egy csillag karakter álljon.
-- Rendezze a listát az átlagfizetések szerint csökkenően.
SELECT 
    job,
    COUNT(*) AS dolgozok_szama,
    ROUND(AVG(sal)) AS atlagfizetes,
    RPAD('*', ROUND(AVG(sal) / 200), '*') AS grafikus
FROM 
    a_emp
GROUP BY 
    job
ORDER BY 
    AVG(sal) ASC;

-- 2.24. feladat:
-- Listázza ki főnökönként a legrégebb óta munkaviszonyban álló dolgozóknak a mai 
-- napig munkában töltött éveinek számát numerikusan és grafikusan is.
-- Ez utóbbit kettőskereszt (#) karakterek sorozataként balra igazítva jelenítse meg oly módon,
-- hogy ebben a sorozatban 5 évenként egy kettőskereszt karakter álljon.
-- Rendezze a listát az évek száma szerint növekvően.
SELECT 
    mgr AS fonok,
    MIN(ename) KEEP (DENSE_RANK FIRST ORDER BY hiredate) AS legregebbi_dolgozo,
    FLOOR(MONTHS_BETWEEN(SYSDATE, MIN(hiredate)) / 12) AS evek_szama,
    RPAD('#', FLOOR(MONTHS_BETWEEN(SYSDATE, MIN(hiredate)) / 60), '#') AS grafikus
FROM 
    a_emp
WHERE 
    mgr IS NOT NULL
GROUP BY 
    mgr
ORDER BY 
    FLOOR(MONTHS_BETWEEN(SYSDATE, MIN(hiredate)) / 12);



