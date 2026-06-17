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
                    ToolTip = 'Specifies the first day of the employee''s absence registered on this line.';
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the last day of the employee''s absence registered on this line.';
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    ToolTip = 'Specifies a cause of absence code to define the type of absence.';
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
                Caption = 'Konflikte prüfen für den Testfall 2';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
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
        }
    }

    trigger OnOpenPage()
    begin
        MsgTxt := '(noch keine Prüfung durchgeführt)';
    end;

    var
        rec_absence: Record "Employee Absence";
        conflict_table: Record "Employee Absence";
        num_conflict: Integer;
        MsgTxt: Text[1000];
}