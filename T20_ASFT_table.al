table 123456748 T20_ASFT_table
{
    Caption = 'T20 ASFT';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Absence ID"; Integer)
        {
            Caption = 'Absence ID';
        }
        field(2; "Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
        }
        field(3; "Starting Date ID"; Date)
        {
            Caption = 'Starting Date ID';
        }
        field(4; "End Date ID"; Date)
        {
            Caption = 'End Date ID';
        }
        field(5; "Reason ID"; Code[10])
        {
            Caption = 'Reason ID';
        }
        field(6; Duration; Integer)
        {
            Caption = 'Duration';
        }
    }

    keys
    {
        key(PK; "Absence ID")
        {
            Clustered = true;
        }
    }
}