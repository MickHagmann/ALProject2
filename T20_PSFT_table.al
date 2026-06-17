table 123456753 T20_PSFT_table
{
    Caption = 'T20 PSFT';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Month ID"; Code[20])
        {
            Caption = 'Month ID';
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
        }
        field(3; "Sick Days in Month"; Integer)
        {
            Caption = 'Sick Days in Month';
        }
        field(4; "Holiday Days in Month"; Integer)
        {
            Caption = 'Holiday Days in Month';
        }
        field(5; "Total Absent Days"; Integer)
        {
            Caption = 'Total Absent Days';
        }
        field(6; "Possible Workdays"; Integer)
        {
            Caption = 'Possible Workdays';
        }
    }

    keys
    {
        key(PK; "Month ID", "Employee No.")
        {
            Clustered = true;
        }
    }
}