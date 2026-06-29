      *****************************************************************
      * COPYBOOK: BUCHUNGS-REC
      * Buchungsdatensatz für Kontoabrechnungsverarbeitung
      *****************************************************************

      *****************************************************************
      * SECTION: BUCHUNGSKOPF
      *****************************************************************
       01  BUCHUNGS-REC.
           05  BUCH-AUFTRAG-NR     PIC 9(12).
           05  BUCH-DATUM          PIC 9(08).
           05  BUCH-VALUTA         PIC 9(08).
           05  BUCH-BETRAG         PIC S9(09)V99 COMP-3.
           05  BUCH-WÄHRUNG        PIC X(03) VALUE "EUR".

      *****************************************************************
      * SECTION: BUCHUNGSKLASSIFIKATION
      *****************************************************************
           05  BUCH-ART            PIC X(02).
               88  BUCH-GUTSCHRIFT     VALUE "GS".
               88  BUCH-LASTSCHRIFT    VALUE "LS".
               88  BUCH-ZINS-GUT       VALUE "ZG".
               88  BUCH-ZINS-LAST      VALUE "ZL".
               88  BUCH-GEBÜHR         VALUE "GB".
               88  BUCH-DISPO-ZINS     VALUE "DZ".
           05  BUCH-KATEGORIE      PIC X(04).
           05  BUCH-VERWENDUNGSZWECK PIC X(35).

      *****************************************************************
      * SECTION: BUCHUNGSSTATUS
      *****************************************************************
           05  BUCH-STATUS         PIC X(01).
               88  BUCH-OFFEN          VALUE "O".
               88  BUCH-GEBUCHT        VALUE "B".
               88  BUCH-STORNIERT      VALUE "S".
               88  BUCH-GESPERRT       VALUE "G".
           05  BUCH-GEGENKONTO     PIC X(22).
           05  BUCH-REFERENZ-NR    PIC X(20).
           05  BUCH-ERFASST-VON    PIC X(08).
           05  BUCH-ERFASST-AM     PIC 9(14).
