table 123456755 T20_TFT_STAR_Joined_table
{
    Caption = 'T20 TFT STAR Joined';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20]) { Caption = 'Employee No.'; }
        field(2; Date; Date) { Caption = 'Date'; }
        field(3; "Entry No."; Integer) { Caption = 'Entry No.'; }
        field(4; "Cause of Absence Code"; Code[10]) { Caption = 'Cause of Absence Code'; }
        field(5; Weekday; Text[20]) { Caption = 'Weekday'; }
        field(6; Workday; Boolean) { Caption = 'Workday'; }
        field(7; Year; Integer) { Caption = 'Year'; }
        field(8; Month; Text[20]) { Caption = 'Month'; }
        field(9; "First Name"; Text[30]) { Caption = 'First Name'; }
        field(10; "Last Name"; Text[30]) { Caption = 'Last Name'; }
        field(11; Department; Code[10]) { Caption = 'Department'; }
        field(12; "Employment Date"; Date) { Caption = 'Employment Date'; }
        field(13; Description; Text[100]) { Caption = 'Description'; }
        field(14; Category; Code[20]) { Caption = 'Category'; }
    }

    keys
    {
        key(PK; "Employee No.", Date)
        {
            Clustered = true;
        }
    }
}