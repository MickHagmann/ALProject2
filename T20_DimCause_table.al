table 123456749 T20_DimCause_table
{
    Caption = 'T20 Dim Cause';
    DataClassification = CustomerContent;
    //hello
    fields
    {
        field(1; "Cause Code"; Code[10])
        {
            Caption = 'Cause Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; Category; Code[20])
        {
            Caption = 'Category';
        }
    }

    keys
    {
        key(PK; "Cause Code")
        {
            Clustered = true;
        }
    }
}