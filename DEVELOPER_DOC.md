# Entwicklerdokumentation: CobolTestRepository

Diese Dokumentation bietet einen umfassenden Überblick über das `CobolTestRepository`. Sie beschreibt jedes Programm, jede Sektion, jeden Paragraphen und jedes Datenfeld im Detail. Das Repository ist ein modular aufgebautes COBOL-System, das Batch-Verarbeitung, Datenbank-Simulationen, Datei-I/O und Geschäftlogik kombiniert.

---

## 1. Gemeinsame Datenstrukturen (Copybooks)

Die folgenden Copybooks definieren die globalen Datenstrukturen, die von mehreren Programmen über `COPY`-Anweisungen eingebunden werden.

### `CONSTANTS.cpy` - Anwendungsübergreifende Konstanten
Dieses Copybook enthält zentrale Informationen zur Anwendung und Rückgabecodes.

| Feldname | Level | PIC | Beschreibung |
| :--- | :--- | :--- | :--- |
| **WS-APP-INFO** | 01 | - | Gruppierung der Anwendungsinformationen. |
| APP-NAME | 05 | X(20) | Name der Anwendung ('COBOL-DEMO-APP'). |
| VERSION | 05 | X(05) | Aktuelle Versionsnummer ('1.0.1'). |
| BUILD-DATE | 05 | X(10) | Datum des letzten Builds ('2026-06-13'). |
| **WS-RETURN-CODES** | 01 | - | Standardisierte Rückgabewerte. |
| SUCCESS-CODE | 05 | 9(01) | Erfolgreiche Ausführung (0). |
| ERROR-CODE | 05 | 9(01) | Allgemeiner Fehler (1). |
| FATAL-CODE | 05 | 9(01) | Kritischer Systemfehler (9). |
| **WS-FILE-STATUS-CONST** | 01 | - | Konstanten für Dateioperationen. |
| FS-OK | 05 | X(02) | Dateioperation erfolgreich ('00'). |
| FS-EOF | 05 | X(02) | Ende der Datei erreicht ('10'). |
| FS-NOT-FOUND | 05 | X(02) | Datei nicht gefunden ('23'). |

### `USER-DATA.cpy` - Benutzerdatenstruktur
Definiert die Struktur eines Benutzerdatensatzes.

| Feldname | Level | PIC | Beschreibung |
| :--- | :--- | :--- | :--- |
| **USER-RECORD** | 01 | - | Hauptstruktur für Benutzerdaten. |
| USER-ID | 05 | X(10) | Eindeutige Benutzerkennung. |
| USER-NAME | 05 | X(30) | Vollständiger Name des Benutzers. |
| USER-ROLE | 05 | X(15) | Rolle des Benutzers (z.B. ADMIN, USER). |
| USER-LAST-LOGIN | 05 | 9(08) | Datum des letzten Logins (YYYYMMDD). |
| USER-STATUS | 05 | X(01) | Status des Benutzers. |
| USER-ACTIVE | 88 | - | Wert 'A': Benutzer ist aktiv. |
| USER-INACTIVE | 88 | - | Wert 'I': Benutzer ist inaktiv. |
| USER-LOCKED | 88 | - | Wert 'L': Benutzer ist gesperrt. |

### `DB-RECORD.cpy` - Datenbank-Datensatz
Struktur für die Kommunikation mit dem Datenbank-Simulationsprogramm.

| Feldname | Level | PIC | Beschreibung |
| :--- | :--- | :--- | :--- |
| **DB-RECORD** | 01 | - | Struktur eines Datenbank-Eintrags. |
| DB-KEY | 05 | X(20) | Primärschlüssel für den Zugriff. |
| DB-DATA-FIELD-1 | 05 | X(50) | Erstes Datenfeld (Text). |
| DB-DATA-FIELD-2 | 05 | 9(10) | Zweites Datenfeld (Numerisch). |
| DB-TIMESTAMP | 05 | 9(14) | Zeitstempel der letzten Änderung. |
| DB-STATUS | 05 | X(02) | Rückgabestatus der Datenbankoperation. |
| DB-OK | 88 | - | Wert '00': Operation erfolgreich. |
| DB-NOT-FOUND | 88 | - | Wert '01': Datensatz nicht gefunden. |
| DB-LOCKED | 88 | - | Wert '02': Datensatz ist gesperrt. |
| DB-ERROR | 88 | - | Wert '99': Allgemeiner Datenbankfehler. |

### `LOG-DATA.cpy` - Logging-Datenstruktur
Wird für den Aufruf des zentralen Logging-Moduls verwendet.

| Feldname | Level | PIC | Beschreibung |
| :--- | :--- | :--- | :--- |
| **LK-LOG-DATA** | 01 | - | Parameterstruktur für den Logger. |
| LK-LOG-LEVEL | 05 | X(05) | Priorität des Logs. |
| LOG-INFO | 88 | - | Wert 'INFO ': Informative Meldung. |
| LOG-WARN | 88 | - | Wert 'WARN ': Warnung. |
| LOG-ERROR | 88 | - | Wert 'ERROR': Fehler. |
| LK-LOG-MSG | 05 | X(60) | Nachrichtentext. |
| LK-LOG-SENDER | 05 | X(10) | Name des sendenden Programms. |
| LK-LOG-TIMESTAMP | 05 | X(19) | (Optional) Zeitstempel. |

### `TRANS-REC.cpy` - Transaktionsdaten
Struktur für Finanztransaktionen.

| Feldname | Level | PIC | Beschreibung |
| :--- | :--- | :--- | :--- |
| **TRANS-REC** | 01 | - | Daten einer Transaktion. |
| TRANS-ID | 05 | X(10) | Eindeutige Transaktions-ID. |
| TRANS-DATE | 05 | 9(08) | Datum der Transaktion (YYYYMMDD). |
| TRANS-TYPE | 05 | X(01) | Typ der Transaktion. |
| TRANS-DEBIT | 88 | - | Wert 'D': Soll-Buchung. |
| TRANS-CREDIT | 88 | - | Wert 'C': Haben-Buchung. |
| TRANS-AMOUNT | 05 | 9(07)V99 | Betrag (mit zwei Dezimalstellen). |
| TRANS-USER-ID | 05 | X(06) | Benutzer-ID des Initiators. |
| TRANS-DESC | 05 | X(30) | Kurzbeschreibung. |
| TRANS-STATUS | 05 | X(01) | Verarbeitungsstatus. |
| TRANS-PENDING | 88 | - | Wert 'P': In Bearbeitung. |
| TRANS-POSTED | 88 | - | Wert 'S': Erfolgreich gebucht. |
| TRANS-FAILED | 88 | - | Wert 'F': Fehlgeschlagen. |

---

## 2. Programm-Dokumentation

### 2.1 VERFAHREN.cbl - Batch-Steuerung
Dieses Programm fungiert als High-Level-Controller, der eine komplexe Sequenz von Batch-Schritten orchestriert.

#### Identification Division
*   **Program-ID:** VERFAHREN
*   **Autor:** GEMINI-CLI

#### Data Division
**Working-Storage Section:**
*   `WS-JOB-CONTROL`: Enthält `WS-STEP-COUNT` (PIC 9(02)) zur Zählung der Schritte und `WS-CURRENT-STEP` (PIC X(20)) zur Benennung des aktuellen Schritts.
*   `WS-PARAMS`: Beinhaltet Parameter für Unterprogrammaufrufe (`WS-MSG`, `WS-RC`, `WS-DB-ACTION`).
*   Inkludierte Copybooks: `LOG-DATA.cpy` (umbenannt in `WS-LOG-DATA`), `DB-RECORD.cpy` (umbenannt in `WS-DB-REC`).

#### Procedure Division

**MAIN-PROCESS SECTION**
*   **000-START**: Initialisiert den Logger, zeigt den Start der Batch-Sequenz an und ruft nacheinander die verschiedenen Verarbeitungsschritte auf (`PERFORM`). Beendet den Job mit `STOP RUN`.

**STEPS SECTION**
*   **100-STEP-INITIALIZE**: Erhöht den Schrittzähler, setzt den Schrittnamen auf "INITIALIZATION" und ruft `UTILPROG` für eine initiale Systemprüfung auf.
*   **150-STEP-DB-LOAD**: Lädt initiale Batch-Daten über einen Aufruf von `DBPROG` mit der Aktion "GET". Prüft den Status über `DB-OK`.
*   **200-STEP-MAIN-LOGIC**: Führt die Hauptlogik der Anwendung durch den Aufruf von `MAINPROG` aus.
*   **250-STEP-DB-UPDATE**: Speichert die Ergebnisse des Batch-Laufs durch einen Aufruf von `DBPROG` mit der Aktion "PUT".
*   **300-STEP-FILE-REPORT**: Generiert einen finalen Report über einen Aufruf von `FILEPROG` mit der Aktion "READ".

---

### 2.2 MAINPROG.cbl - Hauptprogramm
Das zentrale Anwendungsprogramm, das die verschiedenen Geschäftsfunktionen steuert.

#### Identification Division
*   **Program-ID:** MAINPROG
*   **Autor:** GEMINI-CLI

#### Data Division
**Working-Storage Section:**
*   `WS-INTERNAL-DATA`:
    *   `WS-COUNTER` (PIC 9(03)): Zähler für Verarbeitungsschritte.
    *   `WS-MSG` (PIC X(50)): Puffer für Nachrichten.
    *   `WS-UTIL-RC` (PIC 9(02)): Rückgabecode von `UTILPROG`.
    *   `WS-FILE-ACTION` (PIC X(05)): Aktion für `FILEPROG`.
    *   `WS-FILE-STATUS` (PIC 9(02)): Status von `FILEPROG`.
    *   `WS-VAL-TYPE`, `WS-VAL-VALUE`, `WS-VAL-RESULT`: Parameter für den `VALIDATOR`.
*   Inkludierte Copybooks: `USER-DATA.cpy`, `CONSTANTS.cpy`, `ERROR-CODES.cpy`, `SYS-CONFIG.cpy`, `TRANS-REC.cpy`, `LOG-DATA.cpy`.

#### Procedure Division

**MAIN-LOGIC SECTION**
*   **000-START**: Der Einstiegspunkt. Loggt den Programmstart, initialisiert Daten, führt die Verarbeitungsschritte aus (Utility, Transaktionen, Dateien) und beendet das Programm mit `GOBACK`.

**INITIALIZATION-SECTION SECTION**
*   **100-INITIALIZE**: Setzt initiale Testdaten (z.B. Benutzer-ID "USR001"). Validiert die Benutzer-ID über das Unterprogramm `VALIDATOR`.

**PROCESSING-SECTION SECTION**
*   **200-PROCESS**: Simuliert eine einfache Verarbeitung, indem ein Zähler (`WS-COUNTER`) erhöht und der Benutzername ausgegeben wird.

**TRANS-SECTION SECTION**
*   **400-TRANS-TEST**: Bereitet eine Test-Transaktion vor (Betrag 500.00, Typ DEBIT) und ruft das Programm `TRANSPROG` zu deren Verarbeitung auf.

**FINALIZATION-SECTION SECTION**
*   **300-FINALIZE**: Gibt eine Abschlussmeldung aus und setzt den Erfolgsstatus.

---

### 2.3 TRANSPROG.cbl - Transaktionsverarbeitung
Verantwortlich für die Validierung und finanzielle Berechnung einzelner Transaktionen.

#### Identification Division
*   **Program-ID:** TRANSPROG

#### Data Division
**Working-Storage Section:**
*   `WS-INTERNAL-STATE`: Enthält `WS-TRANS-COUNT` und `WS-ERROR-FLAG` ('Y' oder 'N').
*   Inkludierte Copybooks: `LOG-DATA.cpy`, `FIN-DATA.cpy`.

**Linkage Section:**
*   Inkludiertes Copybook: `TRANS-REC.cpy`. Dies ist die Datenstruktur, die vom aufrufenden Programm übergeben wird.

#### Procedure Division

**MAIN-LOGIC SECTION**
*   **000-START**: Orchestriert die Validierung (`100-VALIDATE-TRANS`) und die finanzielle Berechnung (`200-CALCULATE-FINANCE`). Setzt den Status der Transaktion am Ende entweder auf "POSTED" oder "FAILED".

**100-VALIDATE-TRANS**: Prüft, ob der Betrag positiv ist und ein Datum vorhanden ist. Setzt das `WS-ERROR-FLAG` bei Fehlern.

**200-CALCULATE-FINANCE**: Ruft das Unterprogramm `FINPROG` auf, um Steuern und Rabatte zu berechnen. Das Ergebnis wird zurück in den Transaktionsbetrag geschrieben.

---

### 2.4 FINPROG.cbl - Finanzberechnungen
Ein spezialisiertes Modul für mathematische Operationen im Finanzkontext.

#### Data Division
**Linkage Section:**
*   Inkludiertes Copybook: `FIN-DATA.cpy`. Beinhaltet `FIN-AMOUNT`, `FIN-TAX-RATE` (standardmäßig 0.19), `FIN-DISCOUNT` (standardmäßig 0.05) und `FIN-TOTAL`.

#### Procedure Division
**000-START**: Prüft auf gültige Beträge (> 0). Berechnet den Gesamtbetrag inklusive Steuern und abzüglich Rabatt:
1. `FIN-TOTAL = FIN-AMOUNT + (FIN-AMOUNT * FIN-TAX-RATE)`
2. `FIN-TOTAL = FIN-TOTAL - (FIN-TOTAL * FIN-DISCOUNT)`

---

### 2.5 DBPROG.cbl - Datenbank-Simulation
Simuliert den Zugriff auf eine Datenbank (CRUD-Operationen).

#### Data Division
**Linkage Section:**
*   `LK-DB-ACTION` (PIC X(10)): Die gewünschte Operation ("GET", "PUT", "DELETE").
*   Inkludiertes Copybook: `DB-RECORD.cpy`.

#### Procedure Division
**000-START**: Wertet `LK-DB-ACTION` aus und verzweigt in die entsprechenden Paragraphen.
*   **100-DB-GET**: Simuliert das Lesen eines Datensatzes. Füllt `DB-DATA-FIELD-1` mit einem generischen Text und setzt den Status auf "00".
*   **200-DB-PUT**: Simuliert das Speichern. Gibt eine Bestätigung auf der Konsole aus.
*   **300-DB-DELETE**: Simuliert das Löschen.

---

### 2.6 FILEPROG.cbl - Dateiverarbeitung
Verarbeitet sequentielle Dateien.

#### Environment Division
*   **File-Control**: Verknüpft `USER-FILE` mit der physischen Datei `data/users.dat`. Nutzt `ORGANIZATION IS LINE SEQUENTIAL`.

#### Data Division
**File Section:**
*   Inkludiertes Copybook: `FILE-REC.cpy` (definiert `FD-USER-RECORD`).

**Working-Storage Section:**
*   `WS-EOF-SWITCH` (PIC X(01)): Flag für das Dateiende ('Y' wenn erreicht).

#### Procedure Division
**100-READ-FILE**: Öffnet die Datei zum Lesen. Liest in einer Schleife (`PERFORM UNTIL END-OF-FILE`) alle Datensätze und gibt den Benutzernamen aus `FD-USER-NAME` auf dem Display aus. Schließt die Datei am Ende.

---

### 2.7 LOGGER.cbl - Zentraler Logger
Bietet eine einheitliche Schnittstelle für die Protokollierung von Systemereignissen.

#### Data Division
**Working-Storage Section:**
*   `WS-CURRENT-DATE-DATA`: Enthält `WS-DATE` und `WS-TIME` zur Speicherung der aktuellen Systemzeit.

**Linkage Section:**
*   Inkludiertes Copybook: `LOG-DATA.cpy`.

#### Procedure Division
**000-LOG**: Akzeptiert die aktuelle Zeit vom System (`ACCEPT FROM DATE/TIME`) und gibt eine formatierte Nachricht auf der Standardausgabe aus:
Format: `YYYYMMDD HHMMSS [LEVEL] SENDER: MESSAGE`

---

### 2.8 DATEPROG.cbl - Datumswerkzeuge
Hilfsprogramm zur Formatierung und Abfrage von Datumsangaben.

#### Data Division
**Linkage Section:**
*   `LK-DATE-REQUEST`:
    *   `LK-ACTION`: "GETDATE" (holt aktuelles Datum) oder "FORMAT" (formatiert vorhandenes Datum).
    *   `LK-DATE-ISO` (PIC X(10)): Rückgabefeld im Format YYYY-MM-DD.
    *   `LK-DATE-NUM` (PIC 9(08)): Numerisches Datum YYYYMMDD.

#### Procedure Division
**000-START**: Führt eine String-Manipulation durch, um aus dem numerischen Format (YYYYMMDD) das ISO-Format (YYYY-MM-DD) zu erzeugen, indem Trennstriche eingefügt werden.

---

### 2.9 REPORTPROG.cbl - Berichtswesen
Erstellt formatierte Berichte für die Anzeige.

#### Data Division
**Working-Storage Section:**
*   `WS-REPORT-HEADER`: Definiert das Layout des Kopfbereichs (Report-ID, Datum).
*   `WS-REPORT-LINE`: Definiert das Layout einer Tabellenzeile (ID | Name | Rolle).

#### Procedure Division
**000-START**: Gibt die Trennlinien und den Header aus. Setzt manuell Testdaten für zwei Benutzer ("MAX MUSTERMANN", "ERIKA MUSTERMANN") und ruft `100-PRINT-LINE` für jeden auf.
**100-PRINT-LINE**: Überträgt die Rohdaten in die Report-Struktur `WS-REPORT-LINE` und gibt diese aus.

---

### 2.10 VALIDATOR.cbl - Datenvalidierung
Generischer Prüfbaustein für Eingabewerte.

#### Data Division
**Linkage Section:**
*   `LK-TYPE` (PIC X(10)): Art der Prüfung ("NUMERIC" oder "NOT-EMPTY").
*   `LK-VALUE` (PIC X(30)): Der zu prüfende Wert.
*   `LK-RESULT` (PIC 9(01)): 0 für gültig, 1 für ungültig.

#### Procedure Division
**000-START**: Prüft den Wert basierend auf dem Typ. Nutzt COBOL-Funktionen wie `IF ... IS NUMERIC`.

---

### 2.11 UTILPROG.cbl - Hilfsprogramm
Einfaches Utility für allgemeine Aufgaben.

#### Procedure Division
**000-PROCESS-UTILS**: Prüft lediglich, ob die übergebenen Eingabedaten (`LK-INPUT-DATA`) leer sind. Falls ja, wird ein Fehlercode 02 zurückgegeben, ansonsten 00.

---

Diese Dokumentation dient als Referenz für die Wartung und Erweiterung des Systems. Alle Programme sind so konzipiert, dass sie über standardisierte Linkage-Bereiche und Copybooks modular miteinander kommunizieren.
