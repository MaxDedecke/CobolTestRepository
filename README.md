# COBOL Test Repository — Testsparkasse Kernbankensystem

Dieses Repository enthält das fiktive COBOL-Batch-System der **Testsparkasse AG** (Kernbanken-Modul: Kontoabrechnung). Es dient als realitätsnahes Testprojekt für COBOL-Analysetools.

---

## Fachlicher Kontext

Das System verarbeitet monatliche Kontoabrechnungen für Giro-, Spar- und Festgeldkonten. Der nächtliche Batchlauf (`VERFAHREN`) orchestriert die Programme in der folgenden Reihenfolge:

```
VERFAHREN
  └─► MAINPROG          (Systemsteuerung + Benutzerverwaltung)
  └─► KONTOABRECHNUNG   (Monatlicher Kontoabschluss — Herzstück)
        ├─► ZINSBERECHNUNG  (Haben-/Soll-/Dispozinsen, Staffelzins)
        ├─► TRANSPROG       (Buchungsverarbeitung)
        ├─► FINPROG         (Kapitalertragsteuer, Steuerabzug)
        └─► REPORTPROG      (Kontoauszugsdruck)
  └─► DBPROG            (Datenbankoperationen)
  └─► LOGGER            (Zentrales Protokollierungssystem)
```

---

## Repository-Struktur

```
src/
  KONTOABRECHNUNG.cbl   Monatliche Kontoabrechnung — liest Konten, berechnet
                        Zinsen, verbucht Abschlüsse, druckt Kontoauszüge.
                        Enthält EXEC SQL (DB2) für Kontostand-Updates.
  ZINSBERECHNUNG.cbl    Zinsberechnung für alle Kontotypen: Habenzins-Staffel
                        (Sparkonto), Sollzins/Dispozins (Girokonto), Festzins.
  VERFAHREN.cbl         Batch-Ablaufsteuerung — orchestriert alle Schritte.
  MAINPROG.cbl          Systemsteuerung, Benutzerverwaltung.
  TRANSPROG.cbl         Buchungsverarbeitung und -validierung.
  FINPROG.cbl           Finanzberechnungen (Steuern, Abzüge).
  REPORTPROG.cbl        Kontoauszugs- und Protokollausgabe.
  FILEPROG.cbl          Sequentielle Datei-I/O (Kontenfile).
  DBPROG.cbl            Datenbankzugriff (DB2-Simulation).
  DATEPROG.cbl          Datums- und Periodenberechnungen.
  VALIDATOR.cbl         Eingabevalidierung (IBAN, Beträge, Datumsfelder).
  UTILPROG.cbl          Hilfsfunktionen.
  LOGGER.cbl            Zentrales Logging mit Level-Steuerung.
  DIALECTS.cbl          Dialekt-Kompatibilitätsschicht (OSVS/MF).

copy/
  KONTO-DATEN.cpy       Kontostruktur: Stamm, Salden, Zinsabrechnungsergebnis.
  BUCHUNGS-REC.cpy      Buchungsdatensatz inkl. Buchungsart-88-Level.
  TRANS-REC.cpy         Transaktionsdatensatz (ID, Datum, Betrag, Status).
  FIN-DATA.cpy          Finanzdaten (Betrag, Steuersatz, Abzug, Ergebnis).
  USER-DATA.cpy         Benutzerdaten (ID, Name, Rolle, Status).
  DB-RECORD.cpy         Datenbankdatensatz (Schlüssel, Felder, Status).
  LOG-DATA.cpy          Logging-Struktur (Level, Sender, Nachricht).
  CONSTANTS.cpy         Anwendungskonstanten (Version, Returncodes, FS-Werte).
  ERROR-CODES.cpy       Standardisierte Fehlercodes.
  FILE-REC.cpy          Dateideskriptor für Kontenfile.
  SYS-CONFIG.cpy        Systemkonfiguration.
  SYSTEM-INFO.cpy       Systeminformationen (Name, Umgebung).

data/
  users.dat             Testdaten: Benutzerdatei im Fixformat.

scripts/
  compile.sh            GnuCOBOL-Kompilierung aller Programme.
  run.sh                Testlauf-Script.
```

---

## Technische Merkmale

- **EXEC SQL / DB2**: `KONTOABRECHNUNG.cbl` enthält eingebettetes SQL (SELECT, UPDATE, Cursor) für den Datenbankzugriff — typisch für Mainframe-COBOL-Systeme.
- **Copybooks**: Alle Datenstrukturen sind in `copy/` ausgelagert und werden per `COPY`-Statement mit optionalem `REPLACING` eingebunden.
- **COMP-3 (Packed Decimal)**: Geldbeträge und Salden werden als `PIC S9(09)V99 COMP-3` gespeichert (IBM-Mainframe-Standard).
- **88-Level Condition Names**: Statusfelder (Kontostatus, Buchungsart, Zinsstatus) verwenden `88`-Level für lesbaren Code.
- **Interprogram-Communication**: Programme rufen sich gegenseitig via `CALL ... USING` auf und übergeben Datenstrukturen aus den Copybooks.
- **Zinsstaffel**: `ZINSBERECHNUNG.cbl` implementiert eine dreistufige Zinsstaffel für Sparkonten (bis 5.000 €, bis 25.000 €, darüber).
