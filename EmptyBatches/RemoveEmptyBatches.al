// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

query 50149 LineCountAPI1
{
    QueryType = Normal;

    elements
    {
        dataitem(Gen__Journal_Batch; "Gen. Journal Batch")
        {
            column(Name; Name)
            {

            }
            column(Journal_Template_Name; "Journal Template Name") { }
            column(Description; Description) { }

            dataitem(GenJournalLine; "Gen. Journal Line")
            {
                DataItemLink = "Journal Batch Name" = Gen__Journal_Batch.Name;
                SqlJoinType = LeftOuterJoin;
                DataItemTableFilter = "Account No." = filter(= '');

                column(Counts)
                {
                    Method = Count;
                }

                /*column(JournalBatchName; "Journal Batch Name")
                {
                }
*/
                //column(Document_No_; "Document No.") { }
                /*column(DocumentNo; "Document No.")
                {

                }*/
                /*column(Account_No_; "Account No.")
                {
                    ColumnFilter = Account_No_ = filter(= '');
                }*/

            }
        }
    }
}

table 50148 JournalLineEmpty
{
    fields
    {
        field(1; id; Integer)
        {
        }
        field(2; "Name"; Text[250])
        {
        }
        field(3; "Journal Template Name"; Text[100])
        {

        }
        field(4; "Count"; Integer)
        {

        }
        field(5; Description; Text[250])
        {

        }
    }

    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }
    }
}
page 50147 EmptyBatches
{
    PageType = List;
    Caption = 'Remove Empty Batches';
    ApplicationArea = basic;
    UsageCategory = Lists;
    SourceTable = JournalLineEmpty;
    //    SourceTableTemporary = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Name; rec.Name)
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    begin
                    end;
                }
                field(Description; rec.Description) { ApplicationArea = all; }
                field("Journal Type"; rec."Journal Template Name")
                {
                    Caption = 'Journal Type';
                    ApplicationArea = all;
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Delete")
            {
                Caption = 'Delete';
                Image = Delete;
                ApplicationArea = all;
                trigger OnAction()
                var
                    GenJnlBatch: Record "Gen. Journal Batch";
                    JnlEmptyBatch: Record JournalLineEmpty;
                    oldJnlEmptyBatch: Record JournalLineEmpty;
                begin
                    JnlEmptyBatch.Init();
                    CurrPage.SetSelectionFilter(JnlEmptyBatch);
                    if JnlEmptyBatch.Findset() then
                        repeat
                            GenJnlBatch.Init();
                            oldJnlEmptyBatch.Init();
                            GenJnlBatch.Name := JnlEmptyBatch.Name;
                            GenJnlBatch."Journal Template Name" := JnlEmptyBatch."Journal Template Name";
                            GenJnlBatch.Delete();
                            oldJnlEmptyBatch.id := JnlEmptyBatch.id;
                            oldJnlEmptyBatch.Delete();
                        until JnlEmptyBatch.Next() = 0;
                end;
            }
        }
    }
    var
        QueBatch: Query LineCountAPI1;

    trigger OnOpenPage()
    VAR
        I: Integer;
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        rec.Reset();
        if rec.find('+') then begin
            I := rec.id;
        end;
        if GenJnlBatch.FindSet() then
            repeat
                GenJnlLine.SetFilter("Journal Template Name", GenJnlBatch."Journal Template Name");
                GenJnlLine.SetFilter("Journal Batch Name", GenJnlBatch.Name);
                if not GenJnlLine.FindSet() then begin
                    i := i + 1;
                    rec.reset;
                    // rec.SetFilter("Count", '%1', QueBatch.Counts);
                    rec.SetFilter("Journal Template Name", '%1', GenJnlBatch."Journal Template Name");
                    rec.SetFilter(Name, '%1', GenJnlBatch.Name);
                    rec.SetFilter(Description, '%1', GenJnlBatch.Description);
                    if not rec.FindSet() then begin
                        //   rec."Count" := QueBatch.Counts;
                        rec."Journal Template Name" := GenJnlBatch."Journal Template Name";
                        rec.Name := GenJnlBatch.Name;
                        rec.Description := GenJnlBatch.Description;
                        rec.id := i;
                        rec.Insert();

                    end;

                end else
                    if GenJnlLine.FindSet() then begin
                        if (GenJnlLine."Account No." = '') and (GenJnlLine.Amount = 0.00) then begin


                            i := i + 1;
                            rec.reset;
                            // rec.SetFilter("Count", '%1', QueBatch.Counts);
                            rec.SetFilter("Journal Template Name", '%1', GenJnlBatch."Journal Template Name");
                            rec.SetFilter(Name, '%1', GenJnlBatch.Name);
                            rec.SetFilter(Description, '%1', GenJnlBatch.Description);
                            if not rec.FindSet() then begin
                                //   rec."Count" := QueBatch.Counts;
                                rec."Journal Template Name" := GenJnlBatch."Journal Template Name";
                                rec.Name := GenJnlBatch.Name;
                                rec.Description := GenJnlBatch.Description;
                                rec.id := i;
                                rec.Insert();

                            end;
                        end;
                    end;
            until GenJnlBatch.Next() = 0;














        /*
                QueBatch.SetFilter(QueBatch.Counts, '=0');
                QueBatch.Open();

                rec.Reset();
                if rec.find('+') then begin
                    I := rec.id;
                end;
                //Message('%1', i);
                while QueBatch.Read() do begin
                    i := i + 1;
                    rec.reset;
                    rec.SetFilter("Count", '%1', QueBatch.Counts);
                    rec.SetFilter("Journal Template Name", '%1', QueBatch.Journal_Template_Name);
                    rec.SetFilter(Name, '%1', QueBatch.Name);
                    rec.SetFilter(Description, '%1', QueBatch.Description);
                    //message('repeat');
                    if not rec.FindSet() then begin
                        //  message('inside not found');
                        rec."Count" := QueBatch.Counts;
                        rec."Journal Template Name" := QueBatch.Journal_Template_Name;
                        rec.Name := QueBatch.Name;
                        rec.Description := QueBatch.Description;
                        rec.id := i;
                        rec.Insert();

                    end;
                end;*/
        rec.Reset();
        if not rec.FindFirst() then begin
            //Error('There are no journals waiting to be posted');
            //res.Close();
        end
        else
            rec.FindFirst();

    end;

    trigger OnAfterGetRecord()
    begin
        if not QueBatch.Read() then
            exit
    end;

    trigger OnClosePage()
    begin
        QueBatch.Close();
    end;


}
/*
pageextension 50112 "Bus. Mgr. Role Center" extends "Business Manager Role Center"
{
    layout
    {
        modify(Control16)
        {
            Visible = false;
        }
        addafter(Control16)
        //        addbefore()
        {
            part(Journals; BatchJournals)
            {
                ApplicationArea = All;
                Caption = ' Unposted Journals';
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}*/
