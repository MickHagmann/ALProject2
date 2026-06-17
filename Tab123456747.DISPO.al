table 123456747 DISPO
{
    Caption = 'DISPO';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Lfdnr; Integer)
        {
            Caption = 'Lfdnr';
        }
        field(2; Material; Code[10])
        {
            Caption = 'Material';
        }
        field(3; Dispoelement; Code[10])
        {
            Caption = 'Dispoelement';
        }
        field(4; Datum; Date)
        {
            Caption = 'Datum';
        }
        field(5; Zugang; Integer)
        {
            Caption = 'Zugang';
        }
    }
    keys
    {
        key(PK; "Lfdnr")
        {
            Clustered = true;
        }
    }
}
