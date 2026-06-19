codeunit 123456759 CreateBericht1
{
    trigger OnRun()
    begin
        CalculateAndInsertKrankenquote();
    end;

    procedure CalculateAndInsertKrankenquote()
    var
        DimEmployee: Record T20_DimEmployee_table;
        DimTime: Record T20_DimTime_table;
        TFT_STAR_Joined: Record T20_TFT_STAR_Joined_table;
        ReportOut: Record T20_Report_i_Output_table;
        varTargetMonth: Text[30];
        varTargetYear: Integer;
        varTargetWeekday: Text[30];
        sum_sick_days: Integer;
        emp_count: Integer;
        workday_occurrence_count: Integer;
        total_possible_workdays: Integer;
        krankenquote: Decimal;
    begin
        // 1. Parameter setzen
        varTargetMonth := 'Januar';
        varTargetYear := 2026;
        varTargetWeekday := 'Monday';   // muss zum Wert in DimTime passen

        // 2. Krankheitstage aus STAR Joined zählen
        TFT_STAR_Joined.Reset();
        TFT_STAR_Joined.SetRange(Month, varTargetMonth);
        TFT_STAR_Joined.SetRange(Year, varTargetYear);
        TFT_STAR_Joined.SetRange(Weekday, varTargetWeekday);
        TFT_STAR_Joined.SetRange("Cause of Absence Code", 'KRANK');
        sum_sick_days := TFT_STAR_Joined.Count();

        // 3. Theoretische Arbeitstage ermitteln
        DimEmployee.Reset();
        emp_count := DimEmployee.Count();

        DimTime.Reset();
        DimTime.SetRange(Month, varTargetMonth);
        DimTime.SetRange(Year, varTargetYear);
        DimTime.SetRange(Weekday, varTargetWeekday);
        DimTime.SetRange(Workday, true);
        workday_occurrence_count := DimTime.Count();

        total_possible_workdays := emp_count * workday_occurrence_count;

        // 4. Quote berechnen
        if total_possible_workdays > 0 then
            krankenquote := sum_sick_days / total_possible_workdays
        else
            krankenquote := 0.0;

        // 5. Ergebnis in Output-Tabelle schreiben
        if ReportOut.Get(varTargetWeekday) then
            ReportOut.Delete();
        ReportOut.Init();
        ReportOut.Weekday := varTargetWeekday;
        ReportOut.SickDays := sum_sick_days;
        ReportOut.PossibleWorkdays := total_possible_workdays;
        ReportOut.Krankenquote := krankenquote;
        ReportOut.Insert();

        Message('Bericht i berechnet für %1: Krankenquote = %2', varTargetWeekday, krankenquote);
    end;
}

