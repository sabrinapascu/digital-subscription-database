DROP TABLE plati CASCADE CONSTRAINTS;
DROP TABLE abonamente CASCADE CONSTRAINTS;
DROP TABLE tipuri_abonamente CASCADE CONSTRAINTS;
DROP TABLE clienti CASCADE CONSTRAINTS;

CREATE TABLE clienti (
    id_client NUMBER(5) PRIMARY KEY,
    prenume VARCHAR2(50) NOT NULL,
    nume VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    telefon VARCHAR2(15),
    data_inregistrare DATE DEFAULT SYSDATE,
    CONSTRAINT uq_client_email UNIQUE (email),
    CONSTRAINT ck_email_valid CHECK (email LIKE '%@%')
);

CREATE TABLE tipuri_abonamente (
    id_tip NUMBER(3) PRIMARY KEY,
    denumire VARCHAR2(50) NOT NULL,
    durata_luni NUMBER(2) NOT NULL,
    pret_standard NUMBER(10, 2) NOT NULL,
    beneficii VARCHAR2(200),
    CONSTRAINT ck_pret_pozitiv CHECK (pret_standard > 0),
    CONSTRAINT ck_durata_valida CHECK (durata_luni > 0) 
);

CREATE TABLE abonamente (
    id_abonament NUMBER(10) PRIMARY KEY,
    id_client NUMBER(5) NOT NULL,
    id_tip NUMBER(3) NOT NULL,
    data_start DATE DEFAULT SYSDATE,
    data_sfarsit DATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'ACTIV',
    pret_achizitie NUMBER(10, 2) NOT NULL,
    CONSTRAINT fk_ab_client FOREIGN KEY (id_client) REFERENCES clienti(id_client),
    CONSTRAINT fk_ab_tip FOREIGN KEY (id_tip) REFERENCES tipuri_abonamente(id_tip),
    CONSTRAINT ck_status CHECK (status IN ('ACTIV', 'EXPIRAT', 'ANULAT', 'PENDING')),
    CONSTRAINT ck_date_logice CHECK (data_sfarsit > data_start)
);

CREATE TABLE plati (
    id_plata NUMBER(10) PRIMARY KEY,
    id_abonament NUMBER(10) NOT NULL,
    data_plata DATE DEFAULT SYSDATE,
    suma NUMBER(10, 2) NOT NULL,
    metoda_plata VARCHAR2(20),
    CONSTRAINT fk_plata_ab FOREIGN KEY (id_abonament) REFERENCES abonamente(id_abonament),
    CONSTRAINT ck_suma_pozitiva CHECK (suma > 0),
    CONSTRAINT ck_metoda CHECK (metoda_plata IN ('CARD', 'TRANSFER', 'PAYPAL'))
);

ALTER TABLE clienti MODIFY telefon VARCHAR2(25);
ALTER TABLE plati ADD CONSTRAINT ck_suma_max CHECK (suma <= 10000);

CREATE OR REPLACE VIEW view_ne AS
SELECT nume, prenume, email FROM clienti;

CREATE SEQUENCE seq_oferte START WITH 100 INCREMENT BY 1;

CREATE INDEX idx_data_sub ON abonamente(data_start);
