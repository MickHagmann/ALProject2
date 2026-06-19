table 123456757 T20_PSFT_STAR_Joined_table
{
    Caption = 'T20 PSFT STAR Joined';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Month ID"; Code[20]) { Caption = 'Month ID'; }
        field(2; "Employee No."; Code[20]) { Caption = 'Employee No.'; }
        field(3; "Sick Days in Month"; Integer) { Caption = 'Sick Days in Month'; }
        field(4; "Holiday Days in Month"; Integer) { Caption = 'Holiday Days in Month'; }
        field(5; "Total Absent Days"; Integer) { Caption = 'Total Absent Days'; }
        field(6; "Possible Workdays"; Integer) { Caption = 'Possible Workdays'; }
        field(7; Year; Integer) { Caption = 'Year'; }
        field(8; "Month Name"; Text[20]) { Caption = 'Month Name'; }
        field(9; "First Name"; Text[30]) { Caption = 'First Name'; }
        field(10; "Last Name"; Text[30]) { Caption = 'Last Name'; }
        field(11; Department; Code[10]) { Caption = 'Department'; }
        field(12; "Employment Date"; Date) { Caption = 'Employment Date'; }
    }

    keys
    {
        key(PK; "Month ID", "Employee No.")
        {
            Clustered = true;
        }
    }
}