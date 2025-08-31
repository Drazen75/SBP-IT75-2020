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
-- *********************************************************************--
-- PROVERE POSTOJANJA TABELA
--------------------------------------------------------------------------
-- Provera za tabelu Zaposleni
if object_id('Zaposleni', 'U') is not null
	drop table Zaposleni;
go
--------------------------------------------------------------------------
-- *********************************************************************--
-- PROVERA POSTOJANANJA SEKVENCI
--------------------------------------------------------------------------
-- Provera za sekvencu za zaposlenog
if exists (select * from sys.sequences where name = 'seq_zap')
	drop sequence seq_zap;
go
--------------------------------------------------------------------------
-- *********************************************************************--
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

-- *********************************************************************--
--KREIRANJE TABELA
--------------------------------------------------------------------------
--Tabela Zaposleni
CREATE TABLE projekat.Zaposleni (
    id_zap numeric(8) not null,
	Ime NVARCHAR(50) NOT NULL,
	Prezime NVARCHAR(50) NOT NULL,
	JMBG VARCHAR(13) NOT NULL UNIQUE,
    MBR DECIMAL(18,2) NOT NULL UNIQUE,
	Telefon VARCHAR(50),
    Datum_pocetka DATE NOT NULL,
	Datum_kraja DATE,
    Popust DECIMAL(5,2) NULL,
	constraint PK_zaposleni primary key(id_zap)
);
--Kroz datum pocetka i datum kraja dobijamo trajanje ugovora

--Dodavanje sekvence primarnom kljucu
alter table projekat.Zaposleni
	add constraint seq_zap default(next value for seq_zap) for id_zap;
--------------------------------------------------------------------------
-- Tabela Radnik 
CREATE TABLE projekat.Radnik (
	id_zap numeric(8) not null,
	StepenSpreme VARCHAR(50),
	FOREIGN KEY (id_zap) REFERENCES projekat.Zaposleni(id_zap)
);
--------------------------------------------------------------------------
-- Tabela Magacioner
CREATE TABLE projekat.Magacioner (
	id_zap numeric(8) not null,
	FOREIGN KEY (id_zap) REFERENCES projekat.Zaposleni(id_zap)
);
--------------------------------------------------------------------------
-- Tabela Porduzbina
CREATE TABLE projekat.Porudzbina (
	id_por numeric(8) not null, --PorudzbinaID
	Cena numeric(10,2) not null,
	Datum_por date not null,
	Popust numeric(10,2) not null,
	constraint PK_porudzbina primary key(id_por)
);

--Dodavanje sekvence primarnom kljucu
alter table projekat.Porudzbina
	add constraint seq_por default(next value for seq_por) for id_por;
--------------------------------------------------------------------------