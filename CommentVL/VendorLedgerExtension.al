tableextension 50113 GnlJnlLineExt extends "Gen. Journal Line"
{
    fields
    {
        field(50120; Attachment; Text[250])
        {
            Caption = 'Attachment';
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
    }
}

pageextension 50114 PurJnlExt extends "Purchase Journal"
{
    layout
    {
        addafter(Description)
        {
            field(Attachment; Attachment)
            {
                Visible = true;
                ApplicationArea = All;
            }

        }

    }
}
tableextension 50115 VLETableExt extends "Vendor Ledger Entry"
{
    fields
    {
        field(50121; Attachment; Text[250])
        {
            Caption = 'Attachment';
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
        // Add changes to table fields here
    }
    trigger OnAfterInsert()
    var
        genJnlLine: Record "Gen. Journal Line";
        Count: Integer;
    begin
        genJnlLine.SetRange("Document No.", Rec."Document No.");
        Count := 0;
        IF genJnlLine.FIND('-') THEN
            REPEAT
                Count := Count + 1;
            UNTIL genJnlLine.NEXT = 0;

        if genJnlLine.Find('=') Then
            repeat
                Rec.Attachment := genJnlLine.Attachment;
                rec.Modify();
            until genJnlLine.Next = 0;
    end;
}


pageextension 50116 VLEPageExt extends "Vendor Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field(Attachment; Attachment)
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
    }
}