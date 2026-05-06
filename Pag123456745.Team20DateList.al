page 123456746 Team20_DateList
{
    ApplicationArea = All;
    Caption = 'Team20_DateList';
    PageType = Card;
    SourceTable = "Date";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Period Type"; Rec."Period Type")
                {
                    ToolTip = 'Specifies the value of the Period Type field.', Comment = '%';
                }
                field("Period Start"; Rec."Period Start")
                {
                    ToolTip = 'Specifies the starting date of the period that you want to view.';
                }
                field("Period End"; Rec."Period End")
                {
                    ToolTip = 'Specifies the value of the Period End field.', Comment = '%';
                }
                field("Period Name"; Rec."Period Name")
                {
                    ToolTip = 'Specifies the name of the period shown in the line.';
                }
                field("Period No."; Rec."Period No.")
                {
                    ToolTip = 'Specifies the value of the Period No. field.', Comment = '%';
                }
            }
        }
    }
}
