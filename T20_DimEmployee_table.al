table 123456750 T20_DimEmployee_table
{
    Caption = 'T20 Dim Employee';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
        }
        field(2; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(3; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
        }
        field(4; Department; Code[10])
        {
            Caption = 'Department';
        }
        field(5; "Employment Date"; Date)
        {
            Caption = 'Employment Date';
        }
    }

    keys
    {
        key(PK; "Employee No.")
        {
            Clustered = true;
        }
    }
}