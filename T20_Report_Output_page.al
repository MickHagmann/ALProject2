page 123456748 T20_Report_Output_page
{
    ApplicationArea = All;
    Caption = 'Berichte i / ii / iii';
    PageType = List;
    SourceTable = T20_Report_Output_table;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ReportType; Rec.ReportType) { ApplicationArea = All; }
                field(Aufriss1; Rec.Aufriss1) { ApplicationArea = All; }
                field(Aufriss2; Rec.Aufriss2) { ApplicationArea = All; }
                field(Fakt1; Rec.Fakt1) { ApplicationArea = All; }
                field(Fakt2; Rec.Fakt2) { ApplicationArea = All; }
                field(Quote; Rec.Quote) { ApplicationArea = All; }
            }
        }
    }
}