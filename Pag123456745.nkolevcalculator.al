page 123456745 nkolev_calculator
{
    ApplicationArea = All;
    Caption = 'nkolev_calculator';
    PageType = Card;

    layout
    {
        area(Content)
        {


            group(GroupName)
            {
                Caption = 'General';
                field(string1; string1)
                { 
                    Caption = 'Message:';
                }
            }
            group(General)
            {
                Caption = 'Numeric Calculations';
                field(num1; num1)
                {
                    Caption = 'Parameter 1';
                }

                field(num2; num2)
                {
                    Caption = 'Parameter 2';
                }

                field(num3; num3)
                {
                    Caption = 'Ergebnis';
                    Editable = false; //prohibits edits from user interface, grayed out text box
                }
            }

            group(TextOperations)
            {
                Caption = 'Operations on Text Strings';
                field(firsttextstring; firsttextstring)
                {
                    Caption = 'First text';
                }

                field(secondtextstring; secondtextstring)
                {
                    Caption = 'Second text';
                }

                field(resultstring; resultstring)
                {
                    Caption = 'Result';
                }
            }

            group(DateOperations)
            {

                Caption = 'Operations on Dates ';
                field(firstdate; firstdate)
                {
                    
                    Caption = 'First date of period';
                }
                field(seconddate; seconddate)
                {
                    Caption = 'Last date of period';
                }
            }
        }
    }

    actions
    {

        area(Navigation)
        {
            group(NumericOperations)
            {
                action(CalcAdd)
                {
                    trigger OnAction()
                    begin
                        num3 := num1 + num2;
                    end;
                }

                action(CalcSub)
                {
                    trigger OnAction()
                    begin
                        num3 := num1 - num2;
                    end;
                }

                action(CalcMultiply)
                {
                    trigger OnAction()
                    begin
                        num3 := num1 * num2;
                    end;
                }

                action(CalcDivide)
                {
                    trigger OnAction()
                    begin

                        //num3 := num1 / num2;

                        //check for zero divisibility condition
                        if (num2 = 0) then begin
                            errorstring := 'do not divide by zero'; // manually set in vars
                            num3 := 99999;  //must set unnatural value for error proofing, cannot be left empty 
                            error('do not divide by zero'); //al own excption handling method?
                        end else begin
                            num3 := num1 / num2;
                        end;
                    end;
                }
            }



            group(TextOperationsActions)
            {
                action(TxtConcat)
                {
                    trigger OnAction()
                    begin
                        resultstring := firsttextstring + secondtextstring;
                    end;
                }

                action(DelChars)
                {
                    trigger OnAction()
                    begin
                        resultstring := DelChr(firsttextstring, '=', secondtextstring);
                    end;
                }

                action(UpperCase)
                {
                    trigger OnAction()
                    begin
                        resultstring := UpperCase(firsttextstring + ' ' + secondtextstring);
                    end;
                }
            }

            group(DateOperationsAction)
            {
                action(CountDays)
                {
                    trigger OnAction()
                    begin
                                //string 1 is probably field holding value for message in general
                                //in al apparently operations between date values are automatically turned into integer, so we parse only integer to text witzh format()
                            string1:= Format(seconddate-firstdate); //0,0 in the assignment desc is just default string formatting values, can be omitted
                    end;
                }
            }
        }
    }
    var
        num1: Integer;
        num2: Integer;
        num3: Decimal;

        string1: Text[100];
        firsttextstring: Text[100];
        secondtextstring: Text[100];

        resultstring: Text[100];

        errorstring: Text[30];


        firstdate: Date;
        seconddate: Date;

        //setting  var for string holding date difference with type text, using it to store the result of the format(int,0,0) method that spews out a string
        //date_resultstring: Text; actually we already defined string 1 in the beginning and only set the caption, we can still use the var 
    //sample comment to try github issue 
}
