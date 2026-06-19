codeunit 123456758 CreateBericht1
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
        months: array[3] of Text[30];
        selected: array[3] of Boolean;
        m: Integer;
        weekdays: array[5] of Text[20];
        i: Integer;
        varTargetYear: Integer;
        sum_sick_days: Integer;
        emp_count: Integer;
        workday_occurrence_count: Integer;
        total_possible_workdays: Integer;
        krankenquote: Decimal;
    begin
        varTargetYear := 2026;

        months[1] := 'December';
        months[2] := 'January';
        months[3] := 'February';

        if not InputMonths(months, selected) then
            exit;

        weekdays[1] := 'Monday';
        weekdays[2] := 'Tuesday';
        weekdays[3] := 'Wednesday';
        weekdays[4] := 'Thursday';
        weekdays[5] := 'Friday';

        ReportOut.DeleteAll();
        emp_count := DimEmployee.Count();

        for m := 1 to 3 do begin
            if selected[m] then begin
                for i := 1 to 5 do begin
                    TFT_STAR_Joined.Reset();
                    TFT_STAR_Joined.SetRange(Month, months[m]);
                    TFT_STAR_Joined.SetRange(Year, varTargetYear);
                    TFT_STAR_Joined.SetRange(Weekday, weekdays[i]);
                    TFT_STAR_Joined.SetRange("Cause of Absence Code", 'KRANK');
                    sum_sick_days := TFT_STAR_Joined.Count();

                    DimTime.Reset();
                    DimTime.SetRange(Month, months[m]);
                    DimTime.SetRange(Year, varTargetYear);
                    DimTime.SetRange(Weekday, weekdays[i]);
                    DimTime.SetRange(Workday, true);
                    workday_occurrence_count := DimTime.Count();

                    total_possible_workdays := emp_count * workday_occurrence_count;

                    if total_possible_workdays > 0 then
                        krankenquote := sum_sick_days / total_possible_workdays
                    else
                        krankenquote := 0.0;

                    ReportOut.Init();
                    ReportOut."SelectedMonth" := months[m];
                    ReportOut.Weekday := weekdays[i];
                    ReportOut.SickDays := sum_sick_days;
                    ReportOut.PossibleWorkdays := total_possible_workdays;
                    ReportOut.Krankenquote := krankenquote;
                    ReportOut.Insert();
                end;
            end;
        end;

        Message('Report i berechnet für die gewählten Monate.');
    end;

    procedure InputMonths(months: array[3] of Text[30]; var selected: array[3] of Boolean): Boolean
    var
        m: Integer;
        anySelected: Boolean;
    begin
        anySelected := false;
        for m := 1 to 3 do begin
            selected[m] := Confirm('Monat %1 in den Bericht einbeziehen?', false, months[m]);
            if selected[m] then
                anySelected := true;
        end;
        exit(anySelected);
    end;
}