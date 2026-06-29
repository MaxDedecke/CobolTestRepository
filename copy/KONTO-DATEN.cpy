      *****************************************************************
      * COPYBOOK: KONTO-DATEN
      * Kontobasisdaten und Saldeninformationen für Kontoabrechnung
      *****************************************************************

      *****************************************************************
      * SECTION: KONTOBASISDATEN
      *****************************************************************
       01  KONTO-STAMM.
           05  KONTO-NR            PIC X(10).
           05  KONTO-BEZEICHNUNG   PIC X(30).
           05  KONTO-TYP           PIC X(02).
               88  KONTO-GIROKONTO     VALUE "GK".
               88  KONTO-SPARKONTO     VALUE "SP".
               88  KONTO-DARLEHEN      VALUE "DA".
               88  KONTO-FESTGELD      VALUE "FG".
           05  KONTO-INHABER-ID    PIC X(10).
           05  KONTO-INHABER-NAME  PIC X(40).
           05  KONTO-ERÖFFNUNG     PIC 9(08).

      *****************************************************************
      * SECTION: KONTOSALDEN
      *****************************************************************
       01  KONTO-SALDEN.
           05  KONTO-SALDO         PIC S9(09)V99 COMP-3.
           05  KONTO-VERFÜGBAR     PIC S9(09)V99 COMP-3.
           05  KONTO-DISPOSKREDIT  PIC 9(07)V99.
           05  KONTO-DISPOZINS     PIC V9(04).
           05  KONTO-HABENZINS     PIC V9(04).
           05  KONTO-SOLLZINS      PIC V9(04).
           05  KONTO-ABRECHNUNGS-DATUM PIC 9(08).
           05  KONTO-ABRECHNUNGS-VON   PIC 9(08).
           05  KONTO-ABRECHNUNGS-BIS   PIC 9(08).
           05  KONTO-STATUS        PIC X(01).
               88  KONTO-AKTIV         VALUE "A".
               88  KONTO-GESPERRT      VALUE "G".
               88  KONTO-AUFGELÖST     VALUE "X".

      *****************************************************************
      * SECTION: ZINSABRECHNUNGSERGEBNIS
      *****************************************************************
       01  KONTO-ZINS-ERGEBNIS.
           05  ZINS-HABEN-BETRAG   PIC S9(07)V99 COMP-3.
           05  ZINS-SOLL-BETRAG    PIC S9(07)V99 COMP-3.
           05  ZINS-DISPO-BETRAG   PIC S9(07)V99 COMP-3.
           05  ZINS-KAPITALERTRAG  PIC S9(07)V99 COMP-3.
           05  ZINS-ABRECHNUNGS-TAGE PIC 9(03).
           05  ZINS-STATUS         PIC X(02).
               88  ZINS-OK             VALUE "00".
               88  ZINS-KEIN-HABEN     VALUE "01".
               88  ZINS-ÜBERZOGEN      VALUE "02".
               88  ZINS-FEHLER         VALUE "99".
