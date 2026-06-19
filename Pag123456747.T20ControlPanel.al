page 123456747 T20_ControlPanel
{
    ApplicationArea = All;
    Caption = 'T20_ControlPanel';
    PageType = List;
    SourceTable = "Employee Absence";

    layout
    {
        area(Content)
        {
            group(Status)
            {
                Caption = 'Statusmeldung';
                field(MsgTxt; MsgTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Konflikt-Warnung:';
                    Editable = false;
                }
            }
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies a number for the employee.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the first day of the employee absence.';
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the last day of the employee absence.';
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    ToolTip = 'Specifies a cause of absence code.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CheckConflicts)
            {
                ApplicationArea = All;
                Caption = 'Konflikte prüfen (Testfall 2)';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    rec_absence: Record "Employee Absence";
                    conflict_table: Record "Employee Absence";
                    num_conflict: Integer;
                    AllConflicts: Text[10000];
                begin
                    AllConflicts := '';
                    rec_absence.SetFilter("Employee No.", 'T20*');
                    if rec_absence.FindSet() then begin
                        repeat
                            if rec_absence."To Date" <> 0D then begin
                                conflict_table.Reset();
                                conflict_table.SetRange("Employee No.", rec_absence."Employee No.");
                                conflict_table.SetFilter("Entry No.", '<>%1', rec_absence."Entry No.");
                                conflict_table.SetFilter("To Date", '<>%1', 0D);
                                conflict_table.SetFilter("From Date", '<=%1', rec_absence."To Date");
                                conflict_table.SetFilter("To Date", '>=%1', rec_absence."From Date");
                                num_conflict := conflict_table.Count();
                                if num_conflict > 0 then
                                    AllConflicts := AllConflicts +
                                        'MA ' + Format(rec_absence."Employee No.") +
                                        ' Eintrag ' + Format(rec_absence."Entry No.") +
                                        ' vom ' + Format(rec_absence."From Date") +
                                        ' bis ' + Format(rec_absence."To Date") + '\';
                            end;
                        until rec_absence.Next() = 0;
                    end;
                    if AllConflicts = '' then
                        Message('Prüfung beendet: Keine Konflikte gefunden.')
                    else
                        Message('Folgende Konflikte wurden gefunden:\%1', AllConflicts);
                    MsgTxt := 'Prüfung abgeschlossen.';
                    CurrPage.Update(false);
                end;
            }

            action(FillDimEmployee)
            {
                ApplicationArea = All;
                Caption = 'DimEmployee befüllen';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    emp_source: Record Employee;
                    dim_emp: Record T20_DimEmployee_table;
                    counter: Integer;
                begin
                    counter := 0;
                    dim_emp.DeleteAll();
                    emp_source.SetFilter("No.", 'T20*');
                    if emp_source.FindSet() then begin
                        repeat
                            dim_emp.Init();
                            dim_emp."Employee No." := emp_source."No.";
                            dim_emp."First Name" := emp_source."First Name";
                            dim_emp."Last Name" := emp_source."Last Name";
                            dim_emp.Department := emp_source."Global Dimension 1 Code";
                            dim_emp."Employment Date" := emp_source."Employment Date";
                            dim_emp.Insert();
                            counter += 1;
                        until emp_source.Next() = 0;
                    end;
                    MsgTxt := 'DimEmployee befüllt.';
                    Message('DimEmployee befüllt: %1 Datensätze.', counter);
                    CurrPage.Update(false);
                end;
            }

            action(FillDimCause)
            {
                ApplicationArea = All;
                Caption = 'DimCause befüllen';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    cause_source: Record "Cause of Absence";
                    dim_cause: Record T20_DimCause_table;
                    counter: Integer;
                begin
                    counter := 0;
                    dim_cause.DeleteAll();
                    if cause_source.FindSet() then begin
                        repeat
                            dim_cause.Init();
                            dim_cause."Cause Code" := cause_source.Code;
                            dim_cause.Description := cause_source.Description;
                            case cause_source.Code of
                                'KRANK':
                                    dim_cause.Category := 'Unplanned';
                                'URLAUB':
                                    dim_cause.Category := 'Planned';
                                else
                                    dim_cause.Category := 'Sonstige';
                            end;
                            dim_cause.Insert();
                            counter += 1;
                        until cause_source.Next() = 0;
                    end;
                    MsgTxt := 'DimCause befüllt.';
                    Message('DimCause befüllt: %1 Datensätze.', counter);
                    CurrPage.Update(false);
                end;
            }

            action(FillDimTime)
            {
                ApplicationArea = All;
                Caption = 'DimTime befüllen';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    date_rec: Record Date;
                    dim_time: Record T20_DimTime_table;
                    counter: Integer;
                begin
                    counter := 0;
                    dim_time.DeleteAll();
                    date_rec.SetRange("Period Type", date_rec."Period Type"::Date);
                    date_rec.SetRange("Period Start", 20251201D, 20261231D);
                    if date_rec.FindSet() then begin
                        repeat
                            dim_time.Init();
                            dim_time.Date := date_rec."Period Start";
                            dim_time.Weekday := Format(date_rec."Period Start", 0, '<Weekday Text>');
                            dim_time.Year := Date2DMY(date_rec."Period Start", 3);
                            dim_time.Month := Format(date_rec."Period Start", 0, '<Month Text>');
                            dim_time.Workday := (Date2DWY(date_rec."Period Start", 1) <= 5);
                            dim_time.Insert();
                            counter += 1;
                        until date_rec.Next() = 0;
                    end;
                    MsgTxt := 'DimTime befüllt.';
                    Message('DimTime befüllt: %1 Datensätze.', counter);
                    CurrPage.Update(false);
                end;
            }

            action(FillDimTime2)
            {
                ApplicationArea = All;
                Caption = 'DimTime(2) befüllen';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    date_rec: Record Date;
                    dim_time2: Record T20_DimTime2_table;
                    last_month: Code[20];
                    current_month: Code[20];
                    counter: Integer;
                begin
                    counter := 0;
                    dim_time2.DeleteAll();
                    last_month := '';
                    date_rec.SetRange("Period Type", date_rec."Period Type"::Date);
                    date_rec.SetRange("Period Start", 20251201D, 20261231D);
                    if date_rec.FindSet() then begin
                        repeat
                            current_month := Format(Date2DMY(date_rec."Period Start", 3)) + '-' +
                                             Format(Date2DMY(date_rec."Period Start", 2), 2);
                            if current_month <> last_month then begin
                                dim_time2.Init();
                                dim_time2.Month := current_month;
                                dim_time2.Year := Date2DMY(date_rec."Period Start", 3);
                                dim_time2."Month Name" := Format(date_rec."Period Start", 0, '<Month Text>');
                                dim_time2.Insert();
                                counter += 1;
                                last_month := current_month;
                            end;
                        until date_rec.Next() = 0;
                    end;
                    MsgTxt := 'DimTime(2) befüllt.';
                    Message('DimTime(2) befüllt: %1 Monate.', counter);
                    CurrPage.Update(false);
                end;
            }

            action(FillTFT)
            {
                ApplicationArea = All;
                Caption = 'TFT + STAR Joined befüllen';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    abs_rec: Record "Employee Absence";
                    dim_time: Record T20_DimTime_table;
                    dim_emp: Record T20_DimEmployee_table;
                    dim_cause: Record T20_DimCause_table;
                    tft_rec: Record T20_TFT_table;
                    joined: Record T20_TFT_STAR_Joined_table;
                    current_day: Date;
                    counter: Integer;
                begin
                    counter := 0;
                    tft_rec.DeleteAll();
                    joined.DeleteAll();
                    abs_rec.SetFilter("Employee No.", 'T20*');
                    if abs_rec.FindSet() then begin
                        repeat
                            if (abs_rec."To Date" <> 0D) and
                               (abs_rec."To Date" >= abs_rec."From Date") then begin
                                current_day := abs_rec."From Date";
                                while current_day <= abs_rec."To Date" do begin
                                    if dim_time.Get(current_day) then begin
                                        if dim_time.Workday then begin
                                            if not tft_rec.Get(abs_rec."Employee No.", current_day) then begin
                                                tft_rec.Init();
                                                tft_rec."Employee No." := abs_rec."Employee No.";
                                                tft_rec.Date := current_day;
                                                tft_rec."Entry No." := abs_rec."Entry No.";
                                                tft_rec."Cause of Absence Code" := abs_rec."Cause of Absence Code";
                                                tft_rec.Weekday := dim_time.Weekday;
                                                tft_rec.Workday := true;
                                                tft_rec.Insert();

                                                joined.Init();
                                                joined."Employee No." := abs_rec."Employee No.";
                                                joined.Date := current_day;
                                                joined."Entry No." := abs_rec."Entry No.";
                                                joined."Cause of Absence Code" := abs_rec."Cause of Absence Code";
                                                joined.Weekday := dim_time.Weekday;
                                                joined.Workday := true;
                                                joined.Year := dim_time.Year;
                                                joined.Month := dim_time.Month;
                                                if dim_emp.Get(abs_rec."Employee No.") then begin
                                                    joined."First Name" := dim_emp."First Name";
                                                    joined."Last Name" := dim_emp."Last Name";
                                                    joined.Department := dim_emp.Department;
                                                    joined."Employment Date" := dim_emp."Employment Date";
                                                end;
                                                if dim_cause.Get(abs_rec."Cause of Absence Code") then begin
                                                    joined.Description := dim_cause.Description;
                                                    joined.Category := dim_cause.Category;
                                                end;
                                                joined.Insert();
                                                counter += 1;
                                            end;
                                        end;
                                    end;
                                    current_day := current_day + 1;
                                end;
                            end;
                        until abs_rec.Next() = 0;
                    end;
                    MsgTxt := 'TFT + STAR Joined befüllt.';
                    Message('TFT + STAR Joined befüllt: %1 Tagesdatensätze.', counter);
                    CurrPage.Update(false);
                end;
            }

            action(FillASFT)
            {
                ApplicationArea = All;
                Caption = 'ASFT + STAR Joined befüllen';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    abs_rec: Record "Employee Absence";
                    dim_time: Record T20_DimTime_table;
                    dim_emp: Record T20_DimEmployee_table;
                    dim_cause: Record T20_DimCause_table;
                    asft_rec: Record T20_ASFT_table;
                    joined: Record T20_ASFT_STAR_Joined_table;
                    current_day: Date;
                    workday_count: Integer;
                    counter: Integer;
                begin
                    counter := 0;
                    asft_rec.DeleteAll();
                    joined.DeleteAll();
                    abs_rec.SetFilter("Employee No.", 'T20*');
                    if abs_rec.FindSet() then begin
                        repeat
                            if (abs_rec."To Date" <> 0D) and
                               (abs_rec."To Date" >= abs_rec."From Date") then begin
                                workday_count := 0;
                                current_day := abs_rec."From Date";
                                while current_day <= abs_rec."To Date" do begin
                                    if dim_time.Get(current_day) then
                                        if dim_time.Workday then
                                            workday_count += 1;
                                    current_day := current_day + 1;
                                end;
                                if workday_count > 0 then begin
                                    asft_rec.Init();
                                    asft_rec."Absence ID" := abs_rec."Entry No.";
                                    asft_rec."Employee ID" := abs_rec."Employee No.";
                                    asft_rec."Starting Date ID" := abs_rec."From Date";
                                    asft_rec."End Date ID" := abs_rec."To Date";
                                    asft_rec."Reason ID" := abs_rec."Cause of Absence Code";
                                    asft_rec.Duration := workday_count;
                                    asft_rec.Insert();
                                    joined.Init();
                                    joined."Absence ID" := abs_rec."Entry No.";
                                    joined."Employee ID" := abs_rec."Employee No.";
                                    joined."Starting Date ID" := abs_rec."From Date";
                                    joined."End Date ID" := abs_rec."To Date";
                                    joined."Reason ID" := abs_rec."Cause of Absence Code";
                                    joined.Duration := workday_count;
                                    if dim_time.Get(abs_rec."From Date") then begin
                                        joined.Year := dim_time.Year;
                                        joined.Month := dim_time.Month;
                                        joined.Weekday := dim_time.Weekday;
                                        joined.Workday := dim_time.Workday;
                                    end;
                                    if dim_emp.Get(abs_rec."Employee No.") then begin
                                        joined."First Name" := dim_emp."First Name";
                                        joined."Last Name" := dim_emp."Last Name";
                                        joined.Department := dim_emp.Department;
                                        joined."Employment Date" := dim_emp."Employment Date";
                                    end;
                                    if dim_cause.Get(abs_rec."Cause of Absence Code") then begin
                                        joined.Description := dim_cause.Description;
                                        joined.Category := dim_cause.Category;
                                    end;
                                    joined.Insert();
                                    counter += 1;
                                end;
                            end;
                        until abs_rec.Next() = 0;
                    end;
                    MsgTxt := 'ASFT + STAR Joined befüllt.';
                    Message('ASFT + STAR Joined befüllt: %1 Datensätze.', counter);
                    CurrPage.Update(false);
                end;
            }

            action(FillPSFT)
            {
                ApplicationArea = All;
                Caption = 'PSFT + STAR Joined befüllen';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    emp_rec: Record T20_DimEmployee_table;
                    month_rec: Record T20_DimTime2_table;
                    tft_filter: Record T20_TFT_table;
                    dim_time_filter: Record T20_DimTime_table;
                    psft_rec: Record T20_PSFT_table;
                    joined: Record T20_PSFT_STAR_Joined_table;
                    sick_days: Integer;
                    holiday_days: Integer;
                    workday_count: Integer;
                    counter: Integer;
                    month_start: Date;
                    month_end: Date;
                    month_num: Integer;
                begin
                    counter := 0;
                    psft_rec.DeleteAll();
                    joined.DeleteAll();
                    if emp_rec.FindSet() then begin
                        repeat
                            if month_rec.FindSet() then begin
                                repeat
                                    month_num := month_rec.Year mod 12;
                                    if month_num = 0 then
                                        month_num := 12;
                                    month_start := DMY2Date(1, month_num, month_rec.Year);
                                    month_end := CalcDate('<CM>', month_start);
                                    tft_filter.Reset();
                                    tft_filter.SetRange("Employee No.", emp_rec."Employee No.");
                                    tft_filter.SetRange("Cause of Absence Code", 'KRANK');
                                    tft_filter.SetRange(Date, month_start, month_end);
                                    sick_days := tft_filter.Count();
                                    tft_filter.Reset();
                                    tft_filter.SetRange("Employee No.", emp_rec."Employee No.");
                                    tft_filter.SetRange("Cause of Absence Code", 'URLAUB');
                                    tft_filter.SetRange(Date, month_start, month_end);
                                    holiday_days := tft_filter.Count();
                                    dim_time_filter.Reset();
                                    dim_time_filter.SetRange(Date, month_start, month_end);
                                    dim_time_filter.SetRange(Workday, true);
                                    workday_count := dim_time_filter.Count() - 2;
                                    if workday_count < 0 then
                                        workday_count := 0;
                                    psft_rec.Init();
                                    psft_rec."Month ID" := month_rec.Month;
                                    psft_rec."Employee No." := emp_rec."Employee No.";
                                    psft_rec."Sick Days in Month" := sick_days;
                                    psft_rec."Holiday Days in Month" := holiday_days;
                                    psft_rec."Total Absent Days" := sick_days + holiday_days;
                                    psft_rec."Possible Workdays" := workday_count;
                                    psft_rec.Insert();
                                    joined.Init();
                                    joined."Month ID" := month_rec.Month;
                                    joined."Employee No." := emp_rec."Employee No.";
                                    joined."Sick Days in Month" := sick_days;
                                    joined."Holiday Days in Month" := holiday_days;
                                    joined."Total Absent Days" := sick_days + holiday_days;
                                    joined."Possible Workdays" := workday_count;
                                    joined.Year := month_rec.Year;
                                    joined."Month Name" := month_rec."Month Name";
                                    joined."First Name" := emp_rec."First Name";
                                    joined."Last Name" := emp_rec."Last Name";
                                    joined.Department := emp_rec.Department;
                                    joined."Employment Date" := emp_rec."Employment Date";
                                    joined.Insert();
                                    counter += 1;
                                until month_rec.Next() = 0;
                            end;
                        until emp_rec.Next() = 0;
                    end;
                    MsgTxt := 'PSFT + STAR Joined befüllt.';
                    Message('PSFT + STAR Joined befüllt: %1 Datensätze.', counter);
                    CurrPage.Update(false);
                end;
            }

            action(GenerateBericht1)
            {
                ApplicationArea = All;
                Caption = 'Bericht i generieren (Krankenquote nach Wochentag)';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    DimEmployee: Record T20_DimEmployee_table;
                    DimTime: Record T20_DimTime_table;
                    TFT_Joined: Record T20_TFT_STAR_Joined_table;
                    report_out: Record T20_Report_Output_table;
                    months: array[3] of Text[30];
                    selected: array[3] of Boolean;
                    m: Integer;
                    weekdays: array[5] of Text[20];
                    i: Integer;
                    varTargetYear: Integer;
                    sum_sick: Integer;
                    emp_count: Integer;
                    workday_occ: Integer;
                    total_possible: Integer;
                    quote: Decimal;
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

                    report_out.SetRange(ReportType, 'i');
                    report_out.DeleteAll();

                    emp_count := DimEmployee.Count();

                    for m := 1 to 3 do begin
                        if selected[m] then begin
                            for i := 1 to 5 do begin
                                TFT_Joined.Reset();
                                TFT_Joined.SetRange(Month, months[m]);
                                TFT_Joined.SetRange(Year, varTargetYear);
                                TFT_Joined.SetRange(Weekday, weekdays[i]);
                                TFT_Joined.SetRange("Cause of Absence Code", 'KRANK');
                                sum_sick := TFT_Joined.Count();

                                DimTime.Reset();
                                DimTime.SetRange(Month, months[m]);
                                DimTime.SetRange(Year, varTargetYear);
                                DimTime.SetRange(Weekday, weekdays[i]);
                                DimTime.SetRange(Workday, true);
                                workday_occ := DimTime.Count();

                                total_possible := emp_count * workday_occ;

                                if total_possible > 0 then
                                    quote := sum_sick / total_possible
                                else
                                    quote := 0.0;

                                report_out.Init();
                                report_out.ReportType := 'i';
                                report_out.Aufriss1 := weekdays[i];
                                report_out.Aufriss2 := months[m];
                                report_out.Fakt1 := sum_sick;
                                report_out.Fakt2 := total_possible;
                                report_out.Quote := quote;
                                report_out.Insert();
                            end;
                        end;
                    end;

                    Message('Bericht i berechnet.');
                end;
            }

            action(GenerateBericht2)
            {
                ApplicationArea = All;
                Caption = 'Bericht ii generieren (Montags-Anteil nach Abteilung)';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    DimEmployee: Record T20_DimEmployee_table;
                    ASFT_Joined: Record T20_ASFT_STAR_Joined_table;
                    report_out: Record T20_Report_Output_table;
                    varTargetYear: Integer;
                    count_all: Integer;
                    count_monday: Integer;
                    quote: Decimal;
                begin
                    varTargetYear := 2026;

                    report_out.SetRange(ReportType, 'ii');
                    report_out.DeleteAll();

                    DimEmployee.Reset();
                    DimEmployee.SetCurrentKey(Department);
                    if DimEmployee.FindSet() then begin
                        repeat
                            report_out.Reset();
                            if not report_out.Get('ii', DimEmployee.Department, '') then begin
                                ASFT_Joined.Reset();
                                ASFT_Joined.SetRange(Department, DimEmployee.Department);
                                ASFT_Joined.SetRange(Year, varTargetYear);
                                ASFT_Joined.SetRange(Duration, 1);
                                ASFT_Joined.SetRange(Category, 'Unplanned');
                                count_all := ASFT_Joined.Count();

                                ASFT_Joined.SetRange(Weekday, 'Monday');
                                count_monday := ASFT_Joined.Count();

                                if count_all > 0 then
                                    quote := count_monday / count_all
                                else
                                    quote := 0.0;

                                report_out.Init();
                                report_out.ReportType := 'ii';
                                report_out.Aufriss1 := DimEmployee.Department;
                                report_out.Aufriss2 := '';
                                report_out.Fakt1 := count_monday;
                                report_out.Fakt2 := count_all;
                                report_out.Quote := quote;
                                report_out.Insert();
                            end;
                        until DimEmployee.Next() = 0;
                    end;

                    Message('Bericht ii berechnet für %1.', varTargetYear);
                end;
            }

            action(GenerateBericht3)
            {
                ApplicationArea = All;
                Caption = 'Bericht iii generieren (Krankenstand nach Jahr)';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    dim_time2: Record T20_DimTime2_table;
                    psft_joined: Record T20_PSFT_STAR_Joined_table;
                    report_out: Record T20_Report_Output_table;
                    processedYear: array[10] of Integer;
                    yearCount: Integer;
                    y: Integer;
                    alreadyDone: Boolean;
                    sum_sick: Integer;
                    sum_netto: Integer;
                    quote: Decimal;
                begin
                    report_out.SetRange(ReportType, 'iii');
                    report_out.DeleteAll();

                    yearCount := 0;

                    dim_time2.Reset();
                    if dim_time2.FindSet() then begin
                        repeat
                            alreadyDone := false;
                            for y := 1 to yearCount do
                                if processedYear[y] = dim_time2.Year then
                                    alreadyDone := true;

                            if not alreadyDone then begin
                                yearCount += 1;
                                processedYear[yearCount] := dim_time2.Year;

                                psft_joined.Reset();
                                psft_joined.SetRange(Year, dim_time2.Year);
                                sum_sick := 0;
                                sum_netto := 0;
                                if psft_joined.FindSet() then
                                    repeat
                                        sum_sick += psft_joined."Sick Days in Month";
                                        sum_netto += psft_joined."Possible Workdays";
                                    until psft_joined.Next() = 0;

                                if sum_netto > 0 then
                                    quote := sum_sick / sum_netto
                                else
                                    quote := 0.0;

                                report_out.Init();
                                report_out.ReportType := 'iii';
                                report_out.Aufriss1 := Format(dim_time2.Year);
                                report_out.Aufriss2 := '';
                                report_out.Fakt1 := sum_sick;
                                report_out.Fakt2 := sum_netto;
                                report_out.Quote := quote;
                                report_out.Insert();
                            end;
                        until dim_time2.Next() = 0;
                    end;

                    Message('Bericht iii berechnet.');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        MsgTxt := '(noch keine Aktion ausgeführt)';
    end;

    procedure InputMonths(months: array[3] of Text[30]; var selected: array[3] of Boolean): Boolean
    var
        m: Integer;
        anySelected: Boolean;
    begin
        anySelected := false;
        for m := 1 to 3 do begin
            selected[m] := Confirm('Monat %1 einbeziehen?', false, months[m]);
            if selected[m] then
                anySelected := true;
        end;
        exit(anySelected);
    end;

    var
        MsgTxt: Text[1000];
}