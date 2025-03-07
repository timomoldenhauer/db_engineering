-- 1. VERANSTALTUNG
CREATE TABLE Veranstaltung (
    VeranstaltungNr SERIAL NOT NULL,
    Name VARCHAR(255) NOT NULL UNIQUE,
    Beschreibung TEXT,
    Ort VARCHAR(255) NOT NULL,
    CONSTRAINT PK_Veranstaltung PRIMARY KEY (VeranstaltungNr)
);

-- 2. VERANSTALTUNGSTERMIN
CREATE TABLE Veranstaltungstermin (
    VeranstaltungNr INTEGER NOT NULL,
    Datum DATE NOT NULL,
    Von TIME NOT NULL,
    Bis TIME NOT NULL,
    CONSTRAINT PK_Veranstaltungstermin PRIMARY KEY (VeranstaltungNr, Datum),
    CONSTRAINT FK_Veranstaltungstermin_Veranstaltung FOREIGN KEY (VeranstaltungNr) REFERENCES Veranstaltung(VeranstaltungNr) ON DELETE CASCADE
);

CREATE TABLE Rudelteilnahme (
    RudelNr INTEGER Not Null,
    VeranstaltungNr INTEGER NOT NULL,
    CONSTRAINT PK_Rudelteilnahme PRIMARY KEY (VeranstaltungNr, RudelNr)
);
-- 3. RUDEL
CREATE TABLE Rudel (
    RudelNr SERIAL NOT NULL,
    RudelName VARCHAR(255) NOT NULL,
    Anzahl INTEGER NOT NULL,
    CONSTRAINT PK_Rudel PRIMARY KEY (RudelNr)
);-- 6. BESITZER
CREATE TABLE Besitzer (
    BesitzerNr SERIAL NOT NULL,
    Vorname VARCHAR(255) NOT NULL,
    Nachname VARCHAR(255) NOT NULL,
    Mail VARCHAR(255) NOT NULL UNIQUE,
    PLZ VARCHAR(10) NOT NULL,
    Strasse VARCHAR(255) NOT NULL,
    HNr VARCHAR(10) NOT NULL,
    Ort VARCHAR(255) NOT NULL,
    CONSTRAINT PK_Besitzer PRIMARY KEY (BesitzerNr)
);
-- 7. HUND
CREATE TABLE Hund (
    HundNr SERIAL NOT NULL,
    BesitzerNr INTEGER NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Geburtsdatum DATE NOT NULL,
    Geschlecht VARCHAR(10) NOT NULL CHECK (Geschlecht IN ('Männlich', 'Weiblich')),
    CONSTRAINT PK_Hund PRIMARY KEY (HundNr),
    CONSTRAINT FK_Hund_Besitzer FOREIGN KEY (BesitzerNr) REFERENCES Besitzer(BesitzerNr) ON DELETE CASCADE
);



-- 5. RUDELPOS
CREATE TABLE Rudelpos (
    RudelNr INTEGER NOT NULL ,
    RudelPosNr SERIAL NOT NULL,
    HundNr INTEGER NOT NULL,
    Position VARCHAR(255) NOT NULL,
    CONSTRAINT PK_Rudelpos PRIMARY KEY (RudelPosNr),
    CONSTRAINT FK_Rudelpos_Rudel FOREIGN KEY (RudelNr) REFERENCES Rudel(RudelNr) ON DELETE CASCADE,
    CONSTRAINT FK_Rudelpos_Hund FOREIGN KEY (HundNr) REFERENCES Hund(HundNr) ON DELETE CASCADE
);

-- 4. RUDELLEISTUNG
CREATE TABLE Rudelleistung (
    RudelNr INTEGER NOT NULL,
    VeranstaltungNr INTEGER NOT NULL,
    Platzierung INTEGER NOT NULL,
    Zeit FLOAT NOT NULL,
    Einheit VARCHAR(20) NOT NULL CHECK (Einheit IN ('Minuten')),
    CONSTRAINT PK_Rudelleistung PRIMARY KEY (RudelNr, VeranstaltungNr),
    CONSTRAINT FK_Rudelleistung_Teilnahme FOREIGN KEY (RudelNr, VeranstaltungNr) REFERENCES Rudelteilnahme(RudelNr, VeranstaltungNr) ON DELETE CASCADE
);



-- 9. RASSE
CREATE TABLE Rasse (
    RasseName VARCHAR(255) NOT NULL,
    Herkunft VARCHAR(255) NOT NULL,
    Farbe VARCHAR(255) NOT NULL,
    CONSTRAINT PK_Rasse PRIMARY KEY (RasseName)
);

-- 8. MISCHUNG
CREATE TABLE Mischung (
    RasseName VARCHAR(255) NOT NULL,
    HundNr INTEGER NOT NULL,
    Prozent DECIMAL(5,2) NOT NULL,
    CONSTRAINT PK_Mischung PRIMARY KEY (RasseName, HundNr),
    CONSTRAINT FK_Mischung_Rasse FOREIGN KEY (RasseName) REFERENCES Rasse(RasseName) ON DELETE CASCADE,
    CONSTRAINT FK_Mischung_Hund FOREIGN KEY (HundNr) REFERENCES Hund(HundNr) ON DELETE CASCADE
);



-- 10. KURS
CREATE TABLE Kurs (
    KursNr SERIAL NOT NULL,
    Name VARCHAR(255) NOT NULL UNIQUE,
    Beschreibung TEXT,
    CONSTRAINT PK_Kurs PRIMARY KEY (KursNr)
);

-- 11. KURSSTRUKTUR
CREATE TABLE Kursstruktur (
    BasisKursNr INTEGER NOT NULL,
    FolgeKursNr INTEGER NOT NULL,
    CONSTRAINT PK_Kursstruktur PRIMARY KEY (BasisKursNr, FolgeKursNr),
    CONSTRAINT FK_Kursstruktur_Basis FOREIGN KEY (BasisKursNr) REFERENCES Kurs(KursNr) ON DELETE CASCADE,
    CONSTRAINT FK_Kursstruktur_Folge FOREIGN KEY (FolgeKursNr) REFERENCES Kurs(KursNr) ON DELETE CASCADE
);
-- 15. MITARBEITER
CREATE TABLE Mitarbeiter (
    MitarbeiterNr SERIAL NOT NULL,
    Vorname VARCHAR(255) NOT NULL,
    Nachname VARCHAR(255) NOT NULL,
    Mail VARCHAR(255) NOT NULL UNIQUE,
    PLZ VARCHAR(10) NOT NULL,
    Strasse VARCHAR(255) NOT NULL,
    HNr VARCHAR(10) NOT NULL,
    Ort VARCHAR(255) NOT NULL,
    CONSTRAINT PK_Mitarbeiter PRIMARY KEY (MitarbeiterNr)
);

-- 12. UNTERRICHTET
CREATE TABLE Unterrichtet (
    KursNr INTEGER NOT NULL,
    MitarbeiterNr INTEGER NOT NULL,
    CONSTRAINT PK_Unterrichtet PRIMARY KEY (KursNr, MitarbeiterNr),
    CONSTRAINT FK_Unterrichtet_Kurs FOREIGN KEY (KursNr) REFERENCES Kurs(KursNr) ON DELETE CASCADE,
    CONSTRAINT FK_Unterrichtet_Mitarbeiter FOREIGN KEY (MitarbeiterNr) REFERENCES Mitarbeiter(MitarbeiterNr) ON DELETE CASCADE
);

-- 13. KURSREIHE
CREATE TABLE Kursreihe (
    KursreihenName VARCHAR(255) NOT NULL,
    KursNr INTEGER NOT NULL,
    MitarbeiterNr INTEGER NOT NULL,
    AnzahlTermine INTEGER NOT NULL,
    CONSTRAINT PK_Kursreihe PRIMARY KEY (KursreihenName, KursNr),
    CONSTRAINT FK_Kursreihe_Kurs FOREIGN KEY (KursNr) REFERENCES Kurs(KursNr) ON DELETE CASCADE,
    CONSTRAINT FK_Kursreihe_Mitarbeiter FOREIGN KEY (MitarbeiterNr) REFERENCES Mitarbeiter(MitarbeiterNr) ON DELETE CASCADE
);

-- 14. TEILNAHME
CREATE TABLE Teilnahme (
    HundNr INTEGER NOT NULL,
    KursNr INTEGER NOT NULL,
    MitarbeiterNr INTEGER NOT NULL,
    Kursreihenname VARCHAR(255) NOT NULL,
    Von text NOT NULL,
    CONSTRAINT PK_Teilnahme PRIMARY KEY (HundNr, KursNr, Von),
    CONSTRAINT FK_Teilnahme_Kurs FOREIGN KEY (KursNr) REFERENCES Kurs(KursNr) ON DELETE CASCADE,
    CONSTRAINT FK_Teilnahme_Hund FOREIGN KEY (HundNr) REFERENCES Hund(HundNr) ON DELETE CASCADE
);


-- 16. ZERTIFIKAT
CREATE TABLE Zertifikat (
    ZertifikatNr SERIAL NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Beschreibung TEXT,
    CONSTRAINT PK_Zertifikat PRIMARY KEY (ZertifikatNr)
);

-- 17. ORT
CREATE TABLE Ort (
    OrtName VARCHAR(255) NOT NULL,
    PLZ VARCHAR(10) NOT NULL,
    Stadt VARCHAR(255) NOT NULL,
    Strasse VARCHAR(255) NOT NULL,
    Hausnummer VARCHAR(10) NOT NULL,
    Beschreibung TEXT,
    CONSTRAINT PK_Ort PRIMARY KEY (OrtName)
);

-- 18. PLATZ
CREATE TABLE Platz (
    OrtName VARCHAR(255) NOT NULL,
    PlatzName VARCHAR(255) NOT NULL,
    Kapazitaet INT NOT NULL,
    Breite DECIMAL(5,2) NOT NULL,
    Laenge DECIMAL(5,2) NOT NULL,
    CONSTRAINT PK_Platz PRIMARY KEY (OrtName, PlatzName),
    CONSTRAINT FK_Platz_Ort FOREIGN KEY (OrtName) REFERENCES Ort(OrtName) ON DELETE CASCADE
);
-- 14. KURSANMELDUNG (Fehlte!)
CREATE TABLE Kursanmeldung (
    HundNr INTEGER NOT NULL,
    KursNr INTEGER NOT NULL,
    MitarbeiterNr INTEGER NOT NULL,
    Kursreihenname VARCHAR(255) NOT NULL,
    Datum DATE NOT NULL,
    CONSTRAINT PK_Kursanmeldung PRIMARY KEY (HundNr, KursNr, Datum),
    CONSTRAINT FK_Kursanmeldung_Kurs FOREIGN KEY (KursNr) REFERENCES Kurs(KursNr) ON DELETE CASCADE,
    CONSTRAINT FK_Kursanmeldung_Hund FOREIGN KEY (HundNr) REFERENCES Hund(HundNr) ON DELETE CASCADE
);

-- 16. TERMIN (Fehlte!)
CREATE TABLE Termin (
    KursNr INTEGER NOT NULL,
    KursreihenName VARCHAR(255) NOT NULL,
    Von DATE NOT NULL,
    Bis DATE NOT NULL,
    OrtName VARCHAR(255) NOT NULL,
    PlatzName VARCHAR(255) NOT NULL,
    CONSTRAINT PK_Termin PRIMARY KEY (KursNr, KursreihenName, Von),
    CONSTRAINT FK_Termin_Kurs FOREIGN KEY (KursNr) REFERENCES Kurs(KursNr) ON DELETE CASCADE,
    CONSTRAINT FK_Termin_Kursreihe FOREIGN KEY (KursNr, KursreihenName) REFERENCES Kursreihe(KursNr, KursreihenName) ON DELETE CASCADE,
    CONSTRAINT FK_Termin_Ort FOREIGN KEY (OrtName) REFERENCES Ort(OrtName) ON DELETE CASCADE,
    CONSTRAINT FK_Termin_Platz FOREIGN KEY (OrtName, PlatzName) REFERENCES Platz(OrtName, PlatzName) ON DELETE CASCADE
);

-- 17. HAT URKUNDE (Fehlte!)
CREATE TABLE Hat_Urkunde (
    HundNr INTEGER NOT NULL,
    KursNr INTEGER NOT NULL,
    Datum DATE NOT NULL,
    Note VARCHAR(50),
    CONSTRAINT PK_Hat_Urkunde PRIMARY KEY (HundNr, KursNr, Datum),
    CONSTRAINT FK_Hat_Urkunde_Kurs FOREIGN KEY (KursNr) REFERENCES Kurs(KursNr) ON DELETE CASCADE,
    CONSTRAINT FK_Hat_Urkunde_Hund FOREIGN KEY (HundNr) REFERENCES Hund(HundNr) ON DELETE CASCADE
);
-- QUALIFIKATION
CREATE TABLE Qualifikation (
    QName VARCHAR(255) NOT NULL,
    Beschreibung TEXT,
    CONSTRAINT PK_Qualifikation PRIMARY KEY (QName)
);
-- 19. NOTWENDIGE QUALIFIKATION (Fehlte!)
CREATE TABLE Notwendige_Qualifikation (
    KursNr INTEGER NOT NULL,
    QName VARCHAR(255) NOT NULL,
    CONSTRAINT PK_NotwendigeQualifikation PRIMARY KEY (KursNr, QName),
    CONSTRAINT FK_NQ_Kurs FOREIGN KEY (KursNr) REFERENCES Kurs(KursNr) ON DELETE CASCADE,
    CONSTRAINT FK_NQ_Qualifikation FOREIGN KEY (QName) REFERENCES Qualifikation(QName) ON DELETE CASCADE
);

-- 20. MITARBEITERQUALIFIKATION (Fehlte!)
CREATE TABLE Mitarbeiterqualifikation (
    QName VARCHAR(255) NOT NULL,
    MitarbeiterNr INTEGER NOT NULL,
    CONSTRAINT PK_Mitarbeiterqualifikation PRIMARY KEY (QName, MitarbeiterNr),
    CONSTRAINT FK_MQ_Qualifikation FOREIGN KEY (QName) REFERENCES Qualifikation(QName) ON DELETE CASCADE,
    CONSTRAINT FK_MQ_Mitarbeiter FOREIGN KEY (MitarbeiterNr) REFERENCES Mitarbeiter(MitarbeiterNr) ON DELETE CASCADE
);

-- 22. BRAUCHT URKUNDE (Fehlte!)
CREATE TABLE BrauchtUrkunde (
    KursNr INTEGER NOT NULL,
    ZertifikatNr INTEGER NOT NULL,
    CONSTRAINT PK_BrauchtUrkunde PRIMARY KEY (KursNr, ZertifikatNr),
    CONSTRAINT FK_BrauchtUrkunde_Kurs FOREIGN KEY (KursNr) REFERENCES Kurs(KursNr) ON DELETE CASCADE,
    CONSTRAINT FK_BrauchtUrkunde_Zertifikat FOREIGN KEY (ZertifikatNr) REFERENCES Zertifikat(ZertifikatNr) ON DELETE CASCADE
);

-- 26. BESITZT ZERTIFIKAT (Fehlte!)
CREATE TABLE Besitztzertifikat (
    HundNr INTEGER NOT NULL,
    ZertifikatNr INTEGER NOT NULL,
    Datum DATE NOT NULL,
    CONSTRAINT PK_Besitztzertifikat PRIMARY KEY (HundNr, ZertifikatNr, Datum),
    CONSTRAINT FK_Besitztzertifikat_Hund FOREIGN KEY (HundNr) REFERENCES Hund(HundNr) ON DELETE CASCADE,
    CONSTRAINT FK_Besitztzertifikat_Zertifikat FOREIGN KEY (ZertifikatNr) REFERENCES Zertifikat(ZertifikatNr) ON DELETE CASCADE
);
