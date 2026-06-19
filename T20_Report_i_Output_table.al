table 123456758 T20_Report_i_Output_table
{
    Caption = 'T20 Report i Output';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Weekday; Text[20]) { Caption = 'Weekday'; }
        field(2; SickDays; Integer) { Caption = 'Sick Days'; }
        field(3; PossibleWorkdays; Integer) { Caption = 'Possible Workdays'; }
        field(4; Krankenquote; Decimal) { Caption = 'Krankenquote'; }
    }

    keys
    {
        key(PK; Weekday)
        {
            Clustered = true;
        }
    }
}