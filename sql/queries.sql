-- Insert Clienti
INSERT INTO clienti VALUES (1, 'Andrei', 'Popescu', 'andrei.pop@gmail.com', '0722111222', TO_DATE('2023-01-10', 'YYYY-MM-DD'));
INSERT INTO clienti VALUES (2, 'Maria', 'Ionescu', 'maria.io@yahoo.com', '0733444555', TO_DATE('2023-02-15', 'YYYY-MM-DD'));
INSERT INTO clienti VALUES (3, 'Vasile', 'Stan', 'vasile.stan@outlook.com', '0744777888', TO_DATE('2023-03-20', 'YYYY-MM-DD'));
INSERT INTO clienti VALUES (4, 'Elena', 'Georgescu', 'elena.g@gmail.com', '0755999000', TO_DATE('2023-05-05', 'YYYY-MM-DD'));
INSERT INTO clienti VALUES (5, 'Ion', 'Dumitru', 'ion.dumitru@test.ro', null, TO_DATE('2023-06-01', 'YYYY-MM-DD'));
INSERT INTO clienti (id_client, prenume, nume, email, telefon, data_inregistrare) 
VALUES (99, 'Sabrina', 'Pascu', 'pascumaria24@stud.ase.ro', '0751940322', SYSDATE);

-- Insert Tipuri Abonamente
INSERT INTO tipuri_abonamente VALUES (10, 'Basic Monthly', 1, 9.99, 'Acces standard');
INSERT INTO tipuri_abonamente VALUES (20, 'Pro Monthly', 1, 19.99, 'Acces HD + No Ads');
INSERT INTO tipuri_abonamente VALUES (30, 'Pro Yearly', 12, 199.99, 'Acces HD + No Ads 2 luni gratis');
INSERT INTO tipuri_abonamente VALUES (40, 'Enterprise', 24, 999.00, 'Utilizatori nelimitati');

-- Insert Abonamente
INSERT INTO abonamente VALUES (1001, 1, 20, TO_DATE('2023-11-01', 'YYYY-MM-DD'), TO_DATE('2023-12-01', 'YYYY-MM-DD'), 'ACTIV', 19.99);
INSERT INTO abonamente VALUES (1002, 2, 30, TO_DATE('2023-02-15', 'YYYY-MM-DD'), TO_DATE('2024-02-15', 'YYYY-MM-DD'), 'ACTIV', 180.00);
INSERT INTO abonamente VALUES (1003, 3, 10, TO_DATE('2023-03-20', 'YYYY-MM-DD'), TO_DATE('2023-04-20', 'YYYY-MM-DD'), 'EXPIRAT', 9.99);
INSERT INTO abonamente VALUES (1004, 4, 40, TO_DATE('2023-05-05', 'YYYY-MM-DD'), TO_DATE('2025-05-05', 'YYYY-MM-DD'), 'ACTIV', 999.00);
INSERT INTO abonamente VALUES (9999, 99, 40, SYSDATE, ADD_MONTHS(SYSDATE, 12), 'ACTIV', 0); 

-- Insert Plati
INSERT INTO plati VALUES (5001, 1001, TO_DATE('2023-11-01', 'YYYY-MM-DD'), 19.99, 'CARD');
INSERT INTO plati VALUES (5002, 1002, TO_DATE('2023-02-15', 'YYYY-MM-DD'), 180.00, 'TRANSFER');
INSERT INTO plati VALUES (5003, 1003, TO_DATE('2023-03-20', 'YYYY-MM-DD'), 9.99, 'PAYPAL');
INSERT INTO plati VALUES (5004, 1004, TO_DATE('2023-05-05', 'YYYY-MM-DD'), 999.00, 'CARD');

INSERT INTO clienti (id_client, prenume, nume, email, telefon, data_inregistrare)
VALUES (101, 'George', 'Frasin', 'geo.frs@gmail.com', '0799888777', SYSDATE);

INSERT INTO tipuri_abonamente (id_tip, denumire, durata_luni, pret_standard, beneficii)
VALUES (50, 'Family Pack', 12, 250.00, 'Acces pentru 4 membri, HD');

INSERT INTO abonamente (id_abonament, id_client, id_tip, data_start, data_sfarsit, status, pret_achizitie)
VALUES (1005, 101, 50, SYSDATE, ADD_MONTHS(SYSDATE, 12), 'PENDING', 250.00);

UPDATE tipuri_abonamente
SET pret_standard = 1200.00
WHERE id_tip = 40;

UPDATE abonamente
SET status = 'EXPIRAT'
WHERE data_sfarsit < SYSDATE AND status = 'ACTIV';

DELETE FROM abonamente WHERE id_client = 101;
DELETE FROM clienti WHERE id_client = 101;

MERGE INTO tipuri_abonamente t
USING (SELECT 60 as id, 'Student Pass' as num, 6 as luni, 49.99 as pret, 'Reducere studenti' as benef FROM dual) s
ON (t.id_tip = s.id)
WHEN MATCHED THEN
  UPDATE SET t.pret_standard = s.pret
WHEN NOT MATCHED THEN
  INSERT (id_tip, denumire, durata_luni, pret_standard, beneficii)
  VALUES (s.id, s.num, s.luni, s.pret, s.benef);

SELECT prenume, nume, email, data_inregistrare
FROM clienti
WHERE email LIKE '%@gmail.com'
  AND data_inregistrare BETWEEN TO_DATE('01-01-2023', 'DD-MM-YYYY') 
                            AND TO_DATE('31-12-2023', 'DD-MM-YYYY');

SELECT nume, 
       prenume, 
       email, 
       NVL(telefon, 'Fără număr') AS telefon_contact
FROM clienti;

SELECT id_client, 'Are Abonament Activ' AS situatie FROM abonamente WHERE status = 'ACTIV'
UNION
SELECT id_client, 'Abonament Expirat' AS situatie FROM abonamente WHERE status = 'EXPIRAT';

SELECT t.denumire, 
       COUNT(a.id_abonament) AS nr_abonamente,
       SUM(a.pret_achizitie) AS venit_total
FROM tipuri_abonamente t
JOIN abonamente a ON t.id_tip = a.id_tip
GROUP BY t.denumire
HAVING SUM(a.pret_achizitie) > 100;

SELECT SUBSTR(prenume, 1, 1) || '. ' || nume AS client_formatat,
       CASE 
           WHEN EXTRACT(YEAR FROM data_inregistrare) < 2024 THEN 'Client Vechi'
           ELSE 'Client Nou'
       END AS vechime
FROM clienti;

