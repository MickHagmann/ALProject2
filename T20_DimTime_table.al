table 123456751 T20_DimTime_table
{
    Caption = 'T20 Dim Time';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Date; Date)
        {
            Caption = 'Date';
        }
        field(2; Year; Integer)
        {
            Caption = 'Year';
        }
        field(3; Month; Text[20])
        {
            Caption = 'Month';
        }
        field(4; Weekday; Text[20])
        {
            Caption = 'Weekday';
        }
        field(5; Workday; Boolean)
        {
            Caption = 'Workday';
        }
    }

    keys
    {
        key(PK; Date)
        {
            Clustered = true;
        }
    }
}