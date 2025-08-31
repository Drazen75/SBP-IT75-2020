-- ***************************** DDL ***********************************--
--------------------------------------------------------------------------
-- *********************************************************************--
-- KREIRANJE SEME
--------------------------------------------------------------------------
-- Provera
if exists (select * from sys.schemas where name = 'projekat')
	drop schema projekat;
go

-- Kreiranje 
create schema projekat;
go
--------------------------------------------------------------------------
-- *********************************************************************--
-- PROVERE POSTOJANJA TABELA
--------------------------------------------------------------------------
-- Provera za tabelu Zaposleni
if object_id('projekat.Zaposleni', 'U') is not null
	drop table projekat.Zaposleni;
go

-- Provera za tabelu Radnik
if object_id('projekat.Radnik', 'U') is not null
	drop table projekat.Radnik;
go

-- Provera za tabelu Magacioner
if object_id('projekat.Magacioner', 'U') is not null
	drop table projekat.Magacioner;
go

-- Provera za tabelu Porudzbina
if object_id('projekat.Porudzbina', 'U') is not null
	drop table projekat.Porudzbina;
go

-- Provera za tabelu Trebovanje
if object_id('projekat.Trebovanje', 'U') is not null
	drop table projekat.Trebovanje;
go

-- Provera za tabelu Materijal
if object_id('projekat.Materijal', 'U') is not null
	drop table projekat.Materijal;
go
--------------------------------------------------------------------------
-- *********************************************************************--
--------------------------------------------------------------------------
-- PROVERA POSTOJANANJA SEKVENCI
--------------------------------------------------------------------------
-- Provera za sekvencu za zaposlenog
if exists (select * from sys.sequences where name = 'seq_zap')
	drop sequence seq_zap;
go
--------------------------------------------------------------------------
-- Provera za sekvencu za porudzbinu
if exists (select * from sys.sequences where name = 'seq_por')
	drop sequence seq_por;
go
--------------------------------------------------------------------------
-- Provera za sekvencu za trebovanje
if exists (select * from sys.sequences where name = 'seq_trb')
	drop sequence seq_trb;
go
--------------------------------------------------------------------------
-- Provera za sekvencu za materijal
if exists (select * from sys.sequences where name = 'seq_mat')
	drop sequence seq_mat;
go
--------------------------------------------------------------------------
if exists (select * from sys.sequences where name = 'seq_dob')
	drop sequence seq_dob;
go
--------------------------------------------------------------------------
if exists (select * from sys.sequences where name = 'seq_skl')
	drop sequence seq_skl;
go
--------------------------------------------------------------------------
-- *********************************************************************--
--------------------------------------------------------------------------
-- KREIRANJE SEKVENCI

--Sekvenca za ID zaposlenog
create sequence seq_zap as int
start with 1
minvalue 1
increment by 1
no cycle;
--------------------------------------------------------------------------
--Sekvenca za ID porudzbine
create sequence seq_por as int
start with 1
minvalue 1
increment by 1
no cycle
--------------------------------------------------------------------------
--Sekvenca za ID trebovanja
create sequence seq_trb as int
start with 1
minvalue 1
increment by 1
no cycle
--------------------------------------------------------------------------
--Sekvenca za ID materijala
create sequence seq_mat as int
start with 1
minvalue 1
increment by 1
no cycle
--------------------------------------------------------------------------
--Sekvenca za ID dobavljaca
create sequence seq_mat as int
start with 1
minvalue 1
increment by 1
no cycle
--------------------------------------------------------------------------
--Sekvenca za ID dobavljaca
create sequence seq_skl as int
start with 1
minvalue 1
increment by 1
no cycle
--------------------------------------------------------------------------

-- *********************************************************************--
--KREIRANJE TABELA
--------------------------------------------------------------------------
--Tabela Zaposleni
CREATE TABLE projekat.Zaposleni (
    ZaposleniID integer not null,
	Ime NVARCHAR(50) NOT NULL,
	Prezime NVARCHAR(50) NOT NULL,
	JMBG VARCHAR(13) NOT NULL UNIQUE,
    MBR DECIMAL(18,2) NOT NULL UNIQUE,
	Telefon VARCHAR(50),
    Datum_pocetka DATE NOT NULL,
	Datum_kraja DATE,
    Popust DECIMAL(5,2) NULL,
	constraint PK_zaposleni primary key(ZaposleniID)
);
--Kroz datum pocetka i datum kraja dobijamo trajanje ugovora

--Dodavanje sekvence primarnom kljucu
alter table projekat.Zaposleni
	add constraint seq_zap default(next value for seq_zap) for ZaposleniID;
--------------------------------------------------------------------------
-- Tabela Radnik 
CREATE TABLE projekat.Radnik (
	ZaposleniID integer not null,
	StepenSpreme VARCHAR(50),
	FOREIGN KEY (ZaposleniID) REFERENCES projekat.Zaposleni(ZaposleniID)
);
--------------------------------------------------------------------------
-- Tabela Magacioner
CREATE TABLE projekat.Magacioner (
	ZaposleniID integer not null,
	FOREIGN KEY (ZaposleniID) REFERENCES projekat.Zaposleni(ZaposleniID)
);
--------------------------------------------------------------------------
-- Tabel Trebovanje
CREATE TABLE projekat.Trebovanje (
    TrebovanjeID integer not null,
    DatumTrebovanja DATE NOT NULL,
	constraint PK_trebovanje primary key(TrebovanjeID),
);

--Dodavanje sekvence primarnom kljucu
alter table projekat.Trebovanje
	add constraint seq_trb default(next value for seq_trb) for TrebovanjeID;
--------------------------------------------------------------------------
-- Tabela Porduzbina
CREATE TABLE projekat.Porudzbina (
	PorudzbinaID integer not null, --PorudzbinaID
	Cena numeric(10,2) not null,
	Datum_por date not null,
	Popust numeric(10,2) not null,
	TrebovanjeID integer,
	constraint PK_porudzbina primary key(PorudzbinaID),
	FOREIGN KEY (TrebovanjeID) REFERENCES projekat.Trebovanje(TrebovanjeID)
);

--Dodavanje sekvence primarnom kljucu
alter table projekat.Porudzbina
	add constraint seq_por default(next value for seq_por) for PorudzbinaID;
--------------------------------------------------------------------------
-- Tabela Skladiste
CREATE TABLE projekat.Skladiste (
    SkladisteID integer not null,
    Lokacija VARCHAR(100),
	constraint PK_skladiste PRIMARY KEY (SkladisteID)
);

--Dodavanje sekvence primarnom kljucu
alter table projekat.Skladiste
	add constraint seq_skl default(next value for seq_skl) for SkladisteID;
--------------------------------------------------------------------------
-- Tabela Materijal
CREATE TABLE projekat.Materijal (
    MaterijalID integer not null,
    Stanje integer,
	constraint PK_materijal PRIMARY KEY (MaterijalID)
);

--Dodavanje sekvence primarnom kljucu
alter table projekat.Materijal
	add constraint seq_mat default(next value for seq_mat) for MaterijalID;
--------------------------------------------------------------------------
-- Tabela Dobavljac 
CREATE TABLE projekat.Dobavljac (
    DobavljacID integer,
    NazivKompanije VARCHAR(100) NOT NULL,
    EmailDob VARCHAR(100) NOT NULL,
    StatusUgovora VARCHAR(50),
	constraint PK_dobavljac PRIMARY KEY (DobavljacID)
);

--Dodavanje sekvence primarnom kljucu
alter table projekat.Dobavljac
	add constraint seq_dob default(next value for seq_dob) for DobavljacID;
--------------------------------------------------------------------------
-- Relacija: Trebovanje -> Materijal (Potrazuje)
-- (mozda bi bilo pravilnije je nazvati Potrazivani materijali, ali zbog preslikavanja ER modela 1/1 je ostavljeno ime u glagolskom obliku)

CREATE TABLE projekat.Potrazuje (
    TrebovanjeID integer,
    MaterijalID integer,
    KolicinaMat integer NOT NULL,
    Constraint PK_potrazuje PRIMARY KEY (TrebovanjeID, MaterijalID),
    FOREIGN KEY (TrebovanjeID) REFERENCES projekat.Trebovanje(TrebovanjeID),
    FOREIGN KEY (MaterijalID) REFERENCES projekat.Materijal(MaterijalID)
);
--------------------------------------------------------------------------
-- Relacija: Dobavljac -> Zaposleni (Odabira)
CREATE TABLE projekat.Odabira (
    DobavljacID integer,
    ZaposleniID integer,
    PRIMARY KEY (DobavljacID, ZaposleniID),
    FOREIGN KEY (DobavljacID) REFERENCES projekat.Dobavljac(DobavljacID),
    FOREIGN KEY (ZaposleniID) REFERENCES projekat.Zaposleni(ZaposleniID)
);
--------------------------------------------------------------------------
-- Relacija: Dobavljac -> Materijal (Nabavlja)
CREATE TABLE Nabavlja (
    DobavljacID integer,
    MaterijalID integer,
    KolicinaPorucenihMat integer NOT NULL,
    constraint PK_Nabavlja PRIMARY KEY (DobavljacID, MaterijalID),
    FOREIGN KEY (DobavljacID) REFERENCES projekat.Dobavljac(DobavljacID),
    FOREIGN KEY (MaterijalID) REFERENCES projekat.Materijal(MaterijalID)
);
--------------------------------------------------------------------------
-- Relacija: Magacioner - Materijal - Skladiste (se skladist)
-- Ternarni poveznik
CREATE TABLE Se_skladisti (
    MaterijalID integer NOT NULL,
    SkladisteID integer NOT NULL,
	--ZaposleniID integer NOT NULL,
    DatumSkladistenja DATE NOT NULL,
    Kolicina INT NOT NULL,
    PRIMARY KEY (MaterijalID, SkladisteID),
    FOREIGN KEY (MaterijalID) REFERENCES projekat.Materijal(MaterijalID),
    FOREIGN KEY (SkladisteID) REFERENCES projekat.Skladiste(SkladisteID),
    UNIQUE (MaterijalID) -- jer kardinalitet Trebovanja je (1,1)
);

