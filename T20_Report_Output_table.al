table 123456759 T20_Report_Output_table
{
    Caption = 'T20 Report Output';
    DataClassification = CustomerContent;

    fields
    {
        field(1; ReportType; Code[10]) { Caption = 'Bericht'; }
        field(2; Aufriss1; Text[30]) { Caption = 'Aufriss 1'; }
        field(3; Aufriss2; Text[30]) { Caption = 'Aufriss 2'; }
        field(4; Fakt1; Integer) { Caption = 'Krankheitstage'; }
        field(5; Fakt2; Integer) { Caption = 'Bezugsgröße'; }
        field(6; Quote; Decimal) { Caption = 'Quote'; }
    }

    keys
    {
        key(PK; ReportType, Aufriss1, Aufriss2)
        {
            Clustered = true;
        }
    }
}