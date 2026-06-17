table 123456752 T20_DimTime2_table
{
    Caption = 'T20 Dim Time 2';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Month; Code[20])
        {
            Caption = 'Month ID';
        }
        field(2; Year; Integer)
        {
            Caption = 'Year';
        }
        field(3; "Month Name"; Text[20])
        {
            Caption = 'Month Name';
        }
    }

    keys
    {
        key(PK; Month)
        {
            Clustered = true;
        }
    }
}