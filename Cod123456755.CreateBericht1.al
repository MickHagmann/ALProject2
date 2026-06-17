codeunit 123456755 CreateBericht1
{
    trigger OnRun()
    begin
        CalculateAndInsertKrankenquote();
    end;

    procedure CalculateAndInsertKrankenquote()
    var

        DimEmployee: Record "T20_DimEmployee_table";
        DimTime: Record "T20_DimTime_table";
        TFT_Model: Record "T20_TFT_table";

        TFT_STAR_Joined: Record "TFT_STAR_Joined";

        varTargetMonth: Text[30];
        varTargetYear: Integer;
        varTargetWeekday: Text[30];
        sum_sick_days: Integer;
        emp_count: Integer;
        workday_occurance_count: Integer;
        total_possible_workdays: Integer;
        krankenquote: Decimal;

    begin
        //Parameter Setzen
        varTargetMonth := 'Januar';
        varTargetYear := 2026;
        varTargetWeekday := 'Montag';

        //Ausgefallene Krankheitstage zählen
        TFT_STAR_Joined.Reset();
        TFT_STAR_Joined.SetRange(Month, varTargetMonth);
        TFT_STAR_Joined.SetRange(Year, varTargetYear);
        TFT_STAR_Joined.SetRange(Weekday, varTargetWeekday);
        TFT_STAR_Joined.SetRange(CauseCode, 'SICK');

        // Regel 1 & 2: Datensätze zählen statt zeilenweise durchlaufen
        sum_sick_days := TFT_STAR_Joined.Count();


        // --- 3. THEORETISCHE ARBEITSTAGE ERMITTELN ---
        // Anzahl aller Mitarbeiter aus eurer Tabelle holen
        DimEmployee.Reset();
        emp_count := DimEmployee.Count();

        // Kalendertage (Arbeitstage) für den Ziel-Wochentag im Monat zählen
        DimTime.Reset();
        DimTime.SetRange(Month, varTargetMonth);
        DimTime.SetRange(Year, varTargetYear);
        DimTime.SetRange(Weekday, varTargetWeekday);
        DimTime.SetRange(IsWorkday, true);
        
        workday_occurrence_count := DimTime.Count();

        // Gesamtmengen-Multiplikation
        total_possible_workdays := emp_count * workday_occurrence_count;


        // --- 4. BERECHNUNG DER QUOTE ---
        if total_possible_workdays > 0 then
            krankenquote := sum_sick_days / total_possible_workdays
        else
            krankenquote := 0.0;


        // --- 5. IN ERGEBNISSTRUKTUR (T20_TFT_table) SCHREIBEN ---
        // Optionale Bereinigung, um Primärschlüssel-Konflikte (Duplikate) zu vermeiden
        TFT_Model.Reset();
        TFT_Model.SetRange(Weekday, varTargetWeekday); // Angenommen, das Feld existiert als Key
        if not TFT_Model.IsEmpty() then
            TFT_Model.DeleteAll();

        // Datensatz initialisieren und befüllen
        TFT_Model.Init();
        
        
        TFT_Model.Weekday := varTargetWeekday; 
        TFT_Model.SickDays := sum_sick_days;
        TFT_Model.PossibleWorkdays := total_possible_workdays;
        TFT_Model.Krankenquote := krankenquote;
        
        
        TFT_Model.Insert(true); 
    end;
}

