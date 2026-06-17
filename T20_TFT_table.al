table 123456754 T20_TFT_table
{
    Caption = 'T20 TFT';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
        }
        field(2; Date; Date)
        {
            Caption = 'Date';
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(4; "Cause of Absence Code"; Code[10])
        {
            Caption = 'Cause of Absence Code';
        }
        field(5; Weekday; Text[20])
        {
            Caption = 'Weekday';
        }
        field(6; Workday; Boolean)
        {
            Caption = 'Workday';
        }
    }

    keys
    {
        key(PK; "Employee No.", Date)
        {
            Clustered = true;
        }
    }
}