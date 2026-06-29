       IDENTIFICATION DIVISION.
       PROGRAM-ID. ZINSBERECHNUNG.
       AUTHOR. TESTSPARKASSE-IT.
      *
      * Zinsberechnungs-Subroutine für alle Kontotypen.
      * Berechnet Haben-, Soll- und Dispozinsen auf Basis
      * der Kontostammdaten und des aktuellen Abrechnungszeitraums.
      * Gerufen von: KONTOABRECHNUNG.
      *
       DATE-WRITTEN. 2024-01-15.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
           COPY "LOG-DATA.cpy" REPLACING LK-LOG-DATA BY WS-LOG-DATA.

       01  WS-ZINS-INTERNA.
           05  WS-TAGE-IM-MONAT        PIC 9(02) VALUE 30.
           05  WS-ZINSTAGE             PIC 9(03) VALUE 0.
           05  WS-TAGESZINS-FAKTOR     PIC V9(08) VALUE 0.
           05  WS-ZWISCHEN-ERGEBNIS    PIC S9(09)V99 COMP-3 VALUE 0.
           05  WS-NEGATIVER-SALDO      PIC S9(09)V99 COMP-3 VALUE 0.

       01  WS-ZINSSTAFFEL.
           05  WS-STAFFEL-GRENZE-1     PIC 9(07)V99 VALUE 5000.00.
           05  WS-STAFFEL-GRENZE-2     PIC 9(07)V99 VALUE 25000.00.
           05  WS-STAFFEL-ZINSSATZ-1   PIC V9(04)   VALUE .0050.
           05  WS-STAFFEL-ZINSSATZ-2   PIC V9(04)   VALUE .0075.
           05  WS-STAFFEL-ZINSSATZ-3   PIC V9(04)   VALUE .0100.

       LINKAGE SECTION.
           COPY "KONTO-DATEN.cpy".

       PROCEDURE DIVISION USING KONTO-STAMM
                                KONTO-SALDEN
                                KONTO-ZINS-ERGEBNIS.

       HAUPT-LOGIK SECTION.
       000-START.
           MOVE "INFO " TO WS-LOG-LEVEL.
           MOVE "ZINSBERCHN" TO WS-LOG-SENDER.
           STRING "ZINSBERECHNUNG START KONTO=" KONTO-NR
                  INTO WS-LOG-MSG.
           CALL "LOGGER" USING WS-LOG-DATA.

           INITIALIZE KONTO-ZINS-ERGEBNIS.
           MOVE "00" TO ZINS-STATUS.

           PERFORM 010-ZINSTAGE-ERMITTELN.

           EVALUATE TRUE
               WHEN KONTO-GIROKONTO
                   PERFORM 100-GIROKONTO-ZINSEN
               WHEN KONTO-SPARKONTO
                   PERFORM 200-SPARKONTO-ZINSEN
               WHEN KONTO-FESTGELD
                   PERFORM 300-FESTGELD-ZINSEN
               WHEN OTHER
                   MOVE "WARN " TO WS-LOG-LEVEL
                   STRING "UNBEKANNTER KONTOTYP=" KONTO-TYP
                          INTO WS-LOG-MSG
                   CALL "LOGGER" USING WS-LOG-DATA
                   MOVE "99" TO ZINS-STATUS
           END-EVALUATE.

           MOVE WS-ZINSTAGE TO ZINS-ABRECHNUNGS-TAGE.
           GOBACK.

       010-ZINSTAGE-ERMITTELN.
           COMPUTE WS-ZINSTAGE =
               (KONTO-ABRECHNUNGS-BIS - KONTO-ABRECHNUNGS-VON).
           IF WS-ZINSTAGE <= 0
               MOVE WS-TAGE-IM-MONAT TO WS-ZINSTAGE
           END-IF.
           COMPUTE WS-TAGESZINS-FAKTOR = WS-ZINSTAGE / 360.

       GIROKONTO SECTION.
       100-GIROKONTO-ZINSEN.
           IF KONTO-SALDO >= 0
               PERFORM 110-HABENZINS-GIROKONTO
           ELSE
               PERFORM 120-SOLLZINS-GIROKONTO
           END-IF.

           IF KONTO-SALDO < 0 AND
              KONTO-SALDO < (KONTO-DISPOSKREDIT * -1)
               PERFORM 130-DISPOZINS-BERECHNEN
           END-IF.

       110-HABENZINS-GIROKONTO.
           COMPUTE ZINS-HABEN-BETRAG =
               KONTO-SALDO * KONTO-HABENZINS * WS-TAGESZINS-FAKTOR.
           IF ZINS-HABEN-BETRAG < 0
               MOVE 0 TO ZINS-HABEN-BETRAG
           END-IF.
           MOVE "01" TO ZINS-STATUS.

       120-SOLLZINS-GIROKONTO.
           COMPUTE WS-NEGATIVER-SALDO = KONTO-SALDO * -1.
           IF WS-NEGATIVER-SALDO <= KONTO-DISPOSKREDIT
               COMPUTE ZINS-SOLL-BETRAG =
                   WS-NEGATIVER-SALDO * KONTO-SOLLZINS
                   * WS-TAGESZINS-FAKTOR
           ELSE
               COMPUTE ZINS-SOLL-BETRAG =
                   KONTO-DISPOSKREDIT * KONTO-SOLLZINS
                   * WS-TAGESZINS-FAKTOR
           END-IF.
           MOVE "02" TO ZINS-STATUS.

       130-DISPOZINS-BERECHNEN.
           COMPUTE WS-NEGATIVER-SALDO = KONTO-SALDO * -1.
           IF WS-NEGATIVER-SALDO > KONTO-DISPOSKREDIT
               COMPUTE ZINS-DISPO-BETRAG =
                   (WS-NEGATIVER-SALDO - KONTO-DISPOSKREDIT)
                   * KONTO-DISPOZINS * WS-TAGESZINS-FAKTOR
               MOVE "WARN " TO WS-LOG-LEVEL
               STRING "DISPO ÜBERZOGEN KONTO=" KONTO-NR
                      " BETRAG=" WS-NEGATIVER-SALDO
                      INTO WS-LOG-MSG
               CALL "LOGGER" USING WS-LOG-DATA
           END-IF.

       SPARKONTO SECTION.
       200-SPARKONTO-ZINSEN.
           PERFORM 210-HABENZINS-STAFFEL.
           PERFORM 220-KAPITALERTRAGSTEUER-PRÜFEN.

       210-HABENZINS-STAFFEL.
           EVALUATE TRUE
               WHEN KONTO-SALDO <= WS-STAFFEL-GRENZE-1
                   COMPUTE ZINS-HABEN-BETRAG =
                       KONTO-SALDO * WS-STAFFEL-ZINSSATZ-1
                       * WS-TAGESZINS-FAKTOR
               WHEN KONTO-SALDO <= WS-STAFFEL-GRENZE-2
                   COMPUTE ZINS-HABEN-BETRAG =
                       WS-STAFFEL-GRENZE-1 * WS-STAFFEL-ZINSSATZ-1
                       * WS-TAGESZINS-FAKTOR
                   COMPUTE WS-ZWISCHEN-ERGEBNIS =
                       (KONTO-SALDO - WS-STAFFEL-GRENZE-1)
                       * WS-STAFFEL-ZINSSATZ-2
                       * WS-TAGESZINS-FAKTOR
                   ADD WS-ZWISCHEN-ERGEBNIS TO ZINS-HABEN-BETRAG
               WHEN OTHER
                   COMPUTE ZINS-HABEN-BETRAG =
                       WS-STAFFEL-GRENZE-1 * WS-STAFFEL-ZINSSATZ-1
                       * WS-TAGESZINS-FAKTOR
                   COMPUTE WS-ZWISCHEN-ERGEBNIS =
                       (WS-STAFFEL-GRENZE-2 - WS-STAFFEL-GRENZE-1)
                       * WS-STAFFEL-ZINSSATZ-2
                       * WS-TAGESZINS-FAKTOR
                   ADD WS-ZWISCHEN-ERGEBNIS TO ZINS-HABEN-BETRAG
                   COMPUTE WS-ZWISCHEN-ERGEBNIS =
                       (KONTO-SALDO - WS-STAFFEL-GRENZE-2)
                       * WS-STAFFEL-ZINSSATZ-3
                       * WS-TAGESZINS-FAKTOR
                   ADD WS-ZWISCHEN-ERGEBNIS TO ZINS-HABEN-BETRAG
           END-EVALUATE.

       220-KAPITALERTRAGSTEUER-PRÜFEN.
           IF ZINS-HABEN-BETRAG > 0
               CALL "FINPROG" USING KONTO-ZINS-ERGEBNIS
               MOVE ZINS-HABEN-BETRAG TO ZINS-KAPITALERTRAG
           END-IF.

       FESTGELD SECTION.
       300-FESTGELD-ZINSEN.
           COMPUTE ZINS-HABEN-BETRAG =
               KONTO-SALDO * KONTO-HABENZINS * WS-TAGESZINS-FAKTOR.

           IF ZINS-HABEN-BETRAG < 0
               MOVE "ERROR" TO WS-LOG-LEVEL
               STRING "FESTGELD NEGATIVZINS KONTO=" KONTO-NR
                      INTO WS-LOG-MSG
               CALL "LOGGER" USING WS-LOG-DATA
               MOVE "99" TO ZINS-STATUS
               MOVE 0 TO ZINS-HABEN-BETRAG
           END-IF.
