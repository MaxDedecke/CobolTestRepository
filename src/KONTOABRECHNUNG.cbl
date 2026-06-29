       IDENTIFICATION DIVISION.
       PROGRAM-ID. KONTOABRECHNUNG.
       AUTHOR. TESTSPARKASSE-IT.
      *
      * Monatliche Kontoabrechnung - verarbeitet alle aktiven Konten,
      * berechnet Zinsen, verbucht Abschlüsse und erstellt Kontoauszüge.
      * Wird im nächtlichen Batchlauf (VERFAHREN) gerufen.
      *
       DATE-WRITTEN. 2024-01-15.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-Z16.
       OBJECT-COMPUTER. IBM-Z16.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT KONTO-DATEI ASSIGN TO "KONTO.DAT"
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL
               FILE STATUS IS WS-KONTO-DATEISTATUS.

           SELECT AUSZUG-DATEI ASSIGN TO "AUSZUG.PRN"
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL
               FILE STATUS IS WS-AUSZUG-DATEISTATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  KONTO-DATEI.
           COPY "FILE-REC.cpy".

       FD  AUSZUG-DATEI.
       01  AUSZUG-DATENSATZ        PIC X(133).

       WORKING-STORAGE SECTION.
           COPY "CONSTANTS.cpy".
           COPY "LOG-DATA.cpy"    REPLACING LK-LOG-DATA BY WS-LOG-DATA.
           COPY "ERROR-CODES.cpy".

       01  WS-DATEISTEUERUNG.
           05  WS-KONTO-DATEISTATUS    PIC X(02).
           05  WS-AUSZUG-DATEISTATUS   PIC X(02).
           05  WS-DATEI-EOF            PIC X(01) VALUE "N".
               88  DATEI-ENDE              VALUE "Y".

       01  WS-LAUFKONTROLLE.
           05  WS-ABRECHNUNGSLAUF-ID   PIC 9(10).
           05  WS-ABRECHNUNGS-MONAT    PIC 9(06).
           05  WS-VERARBEITUNGS-DATUM  PIC 9(08).
           05  WS-KONTEN-GESAMT        PIC 9(06) VALUE 0.
           05  WS-KONTEN-VERARBEITET   PIC 9(06) VALUE 0.
           05  WS-KONTEN-FEHLER        VALUE 0   PIC 9(04).
           05  WS-KONTEN-ÜBERSPRUNGEN  PIC 9(04) VALUE 0.
           05  WS-HAUPTFEHLER-KODE     PIC 9(02) VALUE 0.

       01  WS-ZINSSUMMEN.
           05  WS-GESAMT-HABEN-ZINSEN  PIC S9(11)V99 COMP-3 VALUE 0.
           05  WS-GESAMT-SOLL-ZINSEN   PIC S9(11)V99 COMP-3 VALUE 0.
           05  WS-GESAMT-DISPO-ZINSEN  PIC S9(11)V99 COMP-3 VALUE 0.

       01  WS-AKTUELLES-KONTO          PIC X(10).

           COPY "KONTO-DATEN.cpy".
           COPY "BUCHUNGS-REC.cpy".

       PROCEDURE DIVISION.

       HAUPT-STEUERUNG SECTION.
       000-INITIALISIERUNG.
           MOVE "INFO " TO WS-LOG-LEVEL.
           MOVE "KONTOABR" TO WS-LOG-SENDER.
           MOVE "KONTOABRECHNUNG GESTARTET" TO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.

           PERFORM 010-SYSTEMDATEN-LADEN.
           PERFORM 020-DATEIEN-ÖFFNEN.

           IF WS-KONTO-DATEISTATUS NOT = FS-OK
               MOVE 91 TO WS-HAUPTFEHLER-KODE
               PERFORM 900-ABSCHLUSS-ROUTINE
               STOP RUN
           END-IF.

           PERFORM 100-KONTEN-EINLESEN
               UNTIL DATEI-ENDE.

           PERFORM 800-LAUF-PROTOKOLL-SCHREIBEN.
           PERFORM 900-ABSCHLUSS-ROUTINE.
           STOP RUN.

       010-SYSTEMDATEN-LADEN.
           EXEC SQL
               SELECT LAUF_ID, ABRECHNUNGS_MONAT, VERARBEITUNGS_DATUM
               INTO  :WS-ABRECHNUNGSLAUF-ID,
                     :WS-ABRECHNUNGS-MONAT,
                     :WS-VERARBEITUNGS-DATUM
               FROM  BATCH_LAUF_STEUERUNG
               WHERE LAUF_TYP = 'KONTOABR'
                 AND LAUF_STATUS = 'AKTIV'
           END-EXEC.

           IF SQLCODE NOT = 0
               MOVE "WARN " TO WS-LOG-LEVEL
               MOVE "KEIN AKTIVER LAUF IN STEUERUNG" TO WS-LOG-MSG
               CALL "LOGGER" USING WS-LOG-DATA
               MOVE 20260101 TO WS-VERARBEITUNGS-DATUM
           END-IF.

       020-DATEIEN-ÖFFNEN.
           OPEN INPUT  KONTO-DATEI.
           OPEN OUTPUT AUSZUG-DATEI.

       KONTEN-VERARBEITUNG SECTION.
       100-KONTEN-EINLESEN.
           READ KONTO-DATEI INTO WS-AKTUELLES-KONTO
               AT END MOVE "Y" TO WS-DATEI-EOF.

           IF DATEI-ENDE
               NEXT SENTENCE
           ELSE
               ADD 1 TO WS-KONTEN-GESAMT
               PERFORM 110-KONTO-STAMMDATEN-LESEN
               PERFORM 120-PRÜFE-ABRECHNUNGSFÄHIGKEIT
               IF WS-HAUPTFEHLER-KODE = 0
                   PERFORM 200-ZINSEN-BERECHNEN
                   PERFORM 300-BUCHUNGEN-VERARBEITEN
                   PERFORM 400-KONTOAUSZUG-DRUCKEN
                   PERFORM 500-KONTOSTAND-AKTUALISIEREN
                   ADD 1 TO WS-KONTEN-VERARBEITET
               END-IF
           END-IF.

       110-KONTO-STAMMDATEN-LESEN.
           MOVE 0 TO WS-HAUPTFEHLER-KODE.

           EXEC SQL
               SELECT K.KONTO_NR,
                      K.KONTO_BEZEICHNUNG,
                      K.KONTO_TYP,
                      K.INHABER_ID,
                      K.INHABER_NAME,
                      S.KONTO_SALDO,
                      S.VERFUEGBAR,
                      S.DISPOSITIONSKREDIT,
                      S.DISPOZINSSATZ,
                      S.HABENZINSSATZ,
                      S.SOLLZINSSATZ,
                      S.KONTO_STATUS
               INTO  :KONTO-NR,
                     :KONTO-BEZEICHNUNG,
                     :KONTO-TYP,
                     :KONTO-INHABER-ID,
                     :KONTO-INHABER-NAME,
                     :KONTO-SALDO,
                     :KONTO-VERFÜGBAR,
                     :KONTO-DISPOSKREDIT,
                     :KONTO-DISPOZINS,
                     :KONTO-HABENZINS,
                     :KONTO-SOLLZINS,
                     :KONTO-STATUS
               FROM  KONTO_STAMM K
               JOIN  KONTO_SALDEN S ON K.KONTO_NR = S.KONTO_NR
               WHERE K.KONTO_NR = :WS-AKTUELLES-KONTO
           END-EXEC.

           IF SQLCODE NOT = 0
               MOVE "ERROR" TO WS-LOG-LEVEL
               STRING "SQL-FEHLER KONTO-LESEN: "
                      SQLCODE INTO WS-LOG-MSG
               CALL "LOGGER" USING WS-LOG-DATA
               MOVE 10 TO WS-HAUPTFEHLER-KODE
               ADD 1 TO WS-KONTEN-FEHLER
           END-IF.

       120-PRÜFE-ABRECHNUNGSFÄHIGKEIT.
           IF KONTO-GESPERRT OR KONTO-AUFGELÖST
               MOVE "INFO " TO WS-LOG-LEVEL
               STRING "KONTO " KONTO-NR " ÜBERSPRUNGEN STATUS="
                      KONTO-STATUS INTO WS-LOG-MSG
               CALL "LOGGER" USING WS-LOG-DATA
               ADD 1 TO WS-KONTEN-ÜBERSPRUNGEN
               MOVE 99 TO WS-HAUPTFEHLER-KODE
           END-IF.

       ZINSBERECHNUNG SECTION.
       200-ZINSEN-BERECHNEN.
           MOVE "INFO " TO WS-LOG-LEVEL.
           STRING "ZINSEN BERECHNEN: " KONTO-NR INTO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.

           CALL "ZINSBERECHNUNG" USING KONTO-STAMM
                                       KONTO-SALDEN
                                       KONTO-ZINS-ERGEBNIS.

           IF ZINS-STATUS NOT = "00"
               MOVE "WARN " TO WS-LOG-LEVEL
               STRING "ZINSBERECHNUNG FEHLER: " ZINS-STATUS
                      " KONTO=" KONTO-NR INTO WS-LOG-MSG
               CALL "LOGGER" USING WS-LOG-DATA
           ELSE
               ADD ZINS-HABEN-BETRAG  TO WS-GESAMT-HABEN-ZINSEN
               ADD ZINS-SOLL-BETRAG   TO WS-GESAMT-SOLL-ZINSEN
               ADD ZINS-DISPO-BETRAG  TO WS-GESAMT-DISPO-ZINSEN
               PERFORM 210-HABENZINSEN-BUCHEN
               PERFORM 220-SOLLZINSEN-BUCHEN
               IF ZINS-DISPO-BETRAG > 0
                   PERFORM 230-DISPOZINSEN-BUCHEN
               END-IF
           END-IF.

       210-HABENZINSEN-BUCHEN.
           IF ZINS-HABEN-BETRAG > 0
               MOVE BUCH-ZINS-GUT TO BUCH-ART
               MOVE ZINS-HABEN-BETRAG TO BUCH-BETRAG
               MOVE "HABENZINS QUARTALSABSCHLUSS" TO BUCH-VERWENDUNGSZWECK
               MOVE WS-VERARBEITUNGS-DATUM TO BUCH-DATUM
               MOVE WS-VERARBEITUNGS-DATUM TO BUCH-VALUTA
               CALL "TRANSPROG" USING BUCHUNGS-REC
           END-IF.

       220-SOLLZINSEN-BUCHEN.
           IF ZINS-SOLL-BETRAG > 0
               MOVE BUCH-ZINS-LAST TO BUCH-ART
               MOVE ZINS-SOLL-BETRAG TO BUCH-BETRAG
               MOVE "SOLLZINS QUARTALSABSCHLUSS" TO BUCH-VERWENDUNGSZWECK
               MOVE WS-VERARBEITUNGS-DATUM TO BUCH-DATUM
               MOVE WS-VERARBEITUNGS-DATUM TO BUCH-VALUTA
               CALL "TRANSPROG" USING BUCHUNGS-REC
           END-IF.

       230-DISPOZINSEN-BUCHEN.
           MOVE BUCH-DISPO-ZINS TO BUCH-ART.
           MOVE ZINS-DISPO-BETRAG TO BUCH-BETRAG.
           MOVE "DISPOZINS " TO BUCH-VERWENDUNGSZWECK.
           STRING "DISPOZINS MNT=" WS-ABRECHNUNGS-MONAT
                  INTO BUCH-VERWENDUNGSZWECK.
           MOVE WS-VERARBEITUNGS-DATUM TO BUCH-DATUM.
           MOVE WS-VERARBEITUNGS-DATUM TO BUCH-VALUTA.
           CALL "TRANSPROG" USING BUCHUNGS-REC.

       BUCHUNGSVERARBEITUNG SECTION.
       300-BUCHUNGEN-VERARBEITEN.
           MOVE "INFO " TO WS-LOG-LEVEL.
           STRING "BUCHUNGEN VERARBEITEN: " KONTO-NR INTO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.

           EXEC SQL
               DECLARE BUCH_CURSOR CURSOR FOR
               SELECT AUFTRAG_NR, BUCHUNGS_DATUM, VALUTA,
                      BETRAG, BUCH_ART, VERWENDUNGSZWECK,
                      STATUS, GEGENKONTO
               FROM   BUCHUNGEN
               WHERE  KONTO_NR  = :WS-AKTUELLES-KONTO
                 AND  STATUS     = 'O'
               ORDER BY VALUTA ASC
           END-EXEC.

           EXEC SQL OPEN BUCH_CURSOR END-EXEC.

           PERFORM 310-NÄCHSTE-BUCHUNG-LESEN
               UNTIL SQLCODE = 100 OR WS-HAUPTFEHLER-KODE > 0.

           EXEC SQL CLOSE BUCH_CURSOR END-EXEC.

       310-NÄCHSTE-BUCHUNG-LESEN.
           EXEC SQL
               FETCH BUCH_CURSOR
               INTO  :BUCH-AUFTRAG-NR,
                     :BUCH-DATUM,
                     :BUCH-VALUTA,
                     :BUCH-BETRAG,
                     :BUCH-ART,
                     :BUCH-VERWENDUNGSZWECK,
                     :BUCH-STATUS,
                     :BUCH-GEGENKONTO
           END-EXEC.

           IF SQLCODE = 0
               PERFORM 320-PRÜFE-BUCHUNGS-LIMIT
               IF WS-HAUPTFEHLER-KODE = 0
                   PERFORM 330-BUCHUNG-ABSCHLIESSEN
               END-IF
           END-IF.

       320-PRÜFE-BUCHUNGS-LIMIT.
           IF BUCH-LASTSCHRIFT
               COMPUTE KONTO-VERFÜGBAR =
                   KONTO-SALDO + KONTO-DISPOSKREDIT + BUCH-BETRAG
               IF KONTO-VERFÜGBAR < 0
                   MOVE "WARN " TO WS-LOG-LEVEL
                   STRING "LIMIT ÜBERSCHRITTEN KONTO=" KONTO-NR
                          " AUFTRAG=" BUCH-AUFTRAG-NR
                          INTO WS-LOG-MSG
                   CALL "LOGGER" USING WS-LOG-DATA
               END-IF
           END-IF.

       330-BUCHUNG-ABSCHLIESSEN.
           EXEC SQL
               UPDATE BUCHUNGEN
               SET    STATUS = 'B',
                      GEBUCHTET_AM = CURRENT TIMESTAMP
               WHERE  AUFTRAG_NR = :BUCH-AUFTRAG-NR
           END-EXEC.

           IF SQLCODE NOT = 0
               MOVE "ERROR" TO WS-LOG-LEVEL
               STRING "UPDATE BUCHUNG FEHLER: " SQLCODE
                      " AUFTRAG=" BUCH-AUFTRAG-NR INTO WS-LOG-MSG
               CALL "LOGGER" USING WS-LOG-DATA
               ADD 1 TO WS-KONTEN-FEHLER
           END-IF.

       AUSGABE SECTION.
       400-KONTOAUSZUG-DRUCKEN.
           CALL "REPORTPROG" USING KONTO-STAMM
                                   KONTO-SALDEN
                                   KONTO-ZINS-ERGEBNIS
                                   WS-ABRECHNUNGS-MONAT.

       ABSCHLUSS SECTION.
       500-KONTOSTAND-AKTUALISIEREN.
           EXEC SQL
               UPDATE KONTO_SALDEN
               SET    KONTO_SALDO  = KONTO_SALDO
                                   + :ZINS-HABEN-BETRAG
                                   - :ZINS-SOLL-BETRAG
                                   - :ZINS-DISPO-BETRAG,
                      LETZTER_ABSCHLUSS = :WS-VERARBEITUNGS-DATUM
               WHERE  KONTO_NR = :WS-AKTUELLES-KONTO
           END-EXEC.

           IF SQLCODE NOT = 0
               MOVE "ERROR" TO WS-LOG-LEVEL
               STRING "SALDO-UPDATE FEHLER: " SQLCODE
                      " KONTO=" WS-AKTUELLES-KONTO INTO WS-LOG-MSG
               CALL "LOGGER" USING WS-LOG-DATA
               ADD 1 TO WS-KONTEN-FEHLER
           END-IF.

       800-LAUF-PROTOKOLL-SCHREIBEN.
           MOVE "INFO " TO WS-LOG-LEVEL.
           MOVE "KONTOABR" TO WS-LOG-SENDER.
           STRING "ABSCHLUSS: GESAMT="     WS-KONTEN-GESAMT
                  " OK=" WS-KONTEN-VERARBEITET
                  " FEHLER=" WS-KONTEN-FEHLER
                  " SKIP=" WS-KONTEN-ÜBERSPRUNGEN
                  INTO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.

           EXEC SQL
               UPDATE BATCH_LAUF_STEUERUNG
               SET    LAUF_STATUS       = 'ABGESCHLOSSEN',
                      KONTEN_GESAMT     = :WS-KONTEN-GESAMT,
                      KONTEN_VERARBEIT  = :WS-KONTEN-VERARBEITET,
                      KONTEN_FEHLER     = :WS-KONTEN-FEHLER,
                      LAUF_ENDE         = CURRENT TIMESTAMP
               WHERE  LAUF_ID = :WS-ABRECHNUNGSLAUF-ID
           END-EXEC.

       900-ABSCHLUSS-ROUTINE.
           CLOSE KONTO-DATEI.
           CLOSE AUSZUG-DATEI.
           MOVE "INFO " TO WS-LOG-LEVEL.
           MOVE "KONTOABRECHNUNG BEENDET" TO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.
