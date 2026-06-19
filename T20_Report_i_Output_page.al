page 123456759 T20_Report_i_Output_page
{
    ApplicationArea = All;
    Caption = 'Bericht i - Krankenquote nach Wochentag';
    PageType = List;
    SourceTable = T20_Report_i_Output_table;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Weekday; Rec.Weekday)
                {
                    ApplicationArea = All;
                }
                field(SickDays; Rec.SickDays)
                {
                    ApplicationArea = All;
                }
                field(PossibleWorkdays; Rec.PossibleWorkdays)
                {
                    ApplicationArea = All;
                }
                field(Krankenquote; Rec.Krankenquote)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}