table 123456756 T20_ASFT_STAR_Joined_table
{
    Caption = 'T20 ASFT STAR Joined';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Absence ID"; Integer) { Caption = 'Absence ID'; }
        field(2; "Employee ID"; Code[20]) { Caption = 'Employee ID'; }
        field(3; "Starting Date ID"; Date) { Caption = 'Starting Date ID'; }
        field(4; "End Date ID"; Date) { Caption = 'End Date ID'; }
        field(5; "Reason ID"; Code[10]) { Caption = 'Reason ID'; }
        field(6; Duration; Integer) { Caption = 'Duration'; }
        field(7; Year; Integer) { Caption = 'Year'; }
        field(8; Month; Text[20]) { Caption = 'Month'; }
        field(9; Weekday; Text[20]) { Caption = 'Weekday'; }
        field(10; Workday; Boolean) { Caption = 'Workday'; }
        field(11; "First Name"; Text[30]) { Caption = 'First Name'; }
        field(12; "Last Name"; Text[30]) { Caption = 'Last Name'; }
        field(13; Department; Code[10]) { Caption = 'Department'; }
        field(14; "Employment Date"; Date) { Caption = 'Employment Date'; }
        field(15; Description; Text[100]) { Caption = 'Description'; }
        field(16; Category; Code[20]) { Caption = 'Category'; }
    }

    keys
    {
        key(PK; "Absence ID")
        {
            Clustered = true;
        }
    }
}