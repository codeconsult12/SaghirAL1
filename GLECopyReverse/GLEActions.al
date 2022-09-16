// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50124 GLEExt extends "General Ledger Entries"
{
    actions
    {
        addafter(ReverseTransaction)
        {
            action("Copy General Journal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Copy General Journal';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Copy selected General Ledger Entries and paste in Genral Journal.';


                trigger OnAction()
                var
                    TempDimSetEntry: Record "Dimension Set Entry" temporary;
                    DimMgmt: Codeunit DimensionManagement;
                    GenJnlLine: Record "Gen. Journal Line";
                    lastGLE: Record "G/L Entry";
                    generalBatch: Record "Gen. Journal Batch";
                    AccSchedLineNo: Integer;
                    BankAccLE: Record "Bank Account Ledger Entry";
                    CustLE: Record "Cust. Ledger Entry";
                    EmpLE: Record "Employee Ledger Entry";
                    FALE: Record "FA Ledger Entry";
                    VendLE: Record "Vendor Ledger Entry";
                    dimEntry: Record "Dimension Set Entry";
                    dimIDEntry: Record "Dimension Set Entry";
                    vendorCard: Record Vendor;
                    dimValue: Record "Dimension Value";
                    // dimCU: Codeunit CreateDimEntry;
                    rowNo: Integer;
                    strRowNo: Code[10];
                    BName: text;
                    dimProject: Text;
                    dimDept: Text;
                    dimComp: Text;
                    dimVend: Text;
                    dimSetID: Integer;
                    num: Integer;
                    CheckDoc: Boolean;
                begin
                    CheckDoc := false;
                    generalBatch.SetFilter(Name, '%1', 'CPYJRNL');
                    if NOT generalBatch.Find('+') then begin

                        generalBatch.Init();
                        generalBatch.Name := 'CPYJRNL';
                        generalBatch.Description := 'Copied from GLE';
                        generalBatch."Bal. Account Type" := "Bal. Account Type"::"G/L Account";
                        generalBatch."No. Series" := 'GENJNL';
                        generalBatch."Journal Template Name" := 'GENERAL';
                        generalBatch.Insert(true);
                    end;

                    GenJnlLine.SetFilter("Journal Template Name", 'GENERAL');
                    GenJnlLine.SetFilter("Journal Batch Name", 'CPYJRNL');
                    if GenJnlLine.Find('+') then begin
                        AccSchedLineNo := GenJnlLine."Line No.";
                    end;



                    BankAccLE.SetFilter("Document No.", rec."Document No.");
                    CustLE.SetFilter("Document No.", Rec."Document No.");
                    EmpLE.SetFilter("Document No.", Rec."Document No.");
                    FALE.SetFilter("Document No.", rec."Document No.");
                    VendLE.SetFilter("Document No.", Rec."Document No.");

                    if BankAccLE.FindSet() then begin
                        lastGLE.Reset();
                        lastGLE.SetAscending("Entry No.", false);
                        lastGLE.SetFilter("Entry No.", '%1', BankAccLE."Entry No.");
                        if lastGLE.FindSet then begin
                            if lastGLE."Dimension Set ID" <> 0 then begin

                                DimEntry.SetFilter("Dimension Set ID", '%1', lastGLE."Dimension Set ID");
                                if DimEntry.FindSet() then
                                    repeat

                                        if DimEntry."Dimension Code" = 'PROJECT' then begin
                                            DimProject := DimEntry."Dimension Value Code";
                                        end else
                                            if DimEntry."Dimension Code" = 'DEPARTMENT' then begin
                                                DimDept := DimEntry."Dimension Value Code"
                                            end else
                                                if DimEntry."Dimension Code" = 'COMPANY' then begin
                                                    DimComp := DimEntry."Dimension Value Code"
                                                end else
                                                    if DimEntry."Dimension Code" = 'VENDOR' then begin
                                                        dimVend := DimEntry."Dimension Value Name";
                                                        VendorCard.SetFilter("No.", DimEntry."Dimension Value Code");
                                                        if VendorCard.FindSet() then begin
                                                            DimVend := VendorCard.Name;
                                                        end;
                                                    end;
                                    until DimEntry.Next() = 0;
                            end;
                            GenJnlLine.Init;
                            GenJnlLine."Journal Template Name" := 'General';
                            GenJnlLine."Journal Batch Name" := 'CPYJRNL';
                            AccSchedLineNo := AccSchedLineNo + 10000;
                            GenJnlLine."Line No." := AccSchedLineNo;
                            GenJnlLine."Document No." := lastGLE."Document No.";
                            GenJnlLine."Document Type" := lastGLE."Document Type";
                            GenJnlLine.Description := lastGLE.Description;
                            GenJnlLine.Amount := lastGLE.Amount;
                            GenJnlLine."Account No." := BankAccLE."Bank Account No.";
                            GenJnlLine."Account Type" := "Gen. Journal Account Type"::"Bank Account";
                            GenJnlLine."External Document No." := lastGLE."External Document No.";
                            //dimEntry.Init();
                            GenJnlLine."Dimension Set ID" := lastGLE."Dimension Set ID";
                            GenJnlLine."shortcut Dimension 1 Code" := lastGLE."Global Dimension 1 Code";
                            GenJnlLine."shortcut Dimension 2 Code" := lastGLE."Global Dimension 2 Code";
                            GenJnlLine.Insert();
                            CheckDoc := true;
                            //DimMgmt.GetDimensionSet(TempDimSetEntry, lastGLE."Dimension Set ID");
                            //TempDimSetEntry.Init();
                            //TempDimSetEntry.VALIDATE("Dimension Code", 'PROJECT');
                            //TempDimSetEntry.VALIDATE("Dimension Value Code", dimProject);
                            //if not TempDimSetEntry.INSERT then
                            //    TempDimSetEntry.Modify;
                            //GenJnlLine.Validate("Dimension Set ID", DimMgmt.GetDimensionSetID(TempDimSetEntry));

                            //GenJnlLine.MODIFY;

                            /*
                                                        GenJnlLine.Init;
                                                        GenJnlLine."Journal Template Name" := 'General';
                                                        GenJnlLine."Journal Batch Name" := 'CPYJRNL';
                                                        AccSchedLineNo := AccSchedLineNo + 10000;
                                                        GenJnlLine."Line No." := AccSchedLineNo;
                                                        GenJnlLine."Document No." := lastGLE."Document No.";
                                                        GenJnlLine."Document Type" := lastGLE."Document Type";
                                                        GenJnlLine.Description := lastGLE.Description;
                                                        GenJnlLine.Amount := 0 - lastGLE.Amount;

                                                        GenJnlLine."Account Type" := "Gen. Journal Account Type"::"G/L Account";
                                                        GenJnlLine."External Document No." := lastGLE."External Document No.";
                                                        GenJnlLine."Account No." := lastGLE."G/L Account No.";
                                                        GenJnlLine."Dimension Set ID" := lastGLE."Dimension Set ID";
                                                        GenJnlLine."shortcut Dimension 1 Code" := lastGLE."Global Dimension 1 Code";
                                                        GenJnlLine."shortcut Dimension 2 Code" := lastGLE."Global Dimension 2 Code";
                                                        //GenJnlLine.ba
                                                        //GenJnlLine."Shortcut Dimension  Code" := lastGLE."Shortcut Dimension 1 Code";
                                                        //                            GenJnlLine."Shortcut Dimension 2 Code" := lastGLE."Global Dimension 2 Code";
                                                        GenJnlLine.Insert();
                            */
                        end;
                    end;
                    if CustLE.FindSet() then begin

                    end;
                    if EmpLE.FindSet() then begin

                    end;
                    if FALE.FindSet() then begin

                    end;
                    if VendLE.FindSet() then begin

                    end;

                    lastGLE.Reset();
                    lastGLE.SetFilter("Document No.", Rec."Document No.");
                    if lastGLE.FindSet then
                        repeat
                            if (CheckDoc = true) then begin
                                if (lastGLE."G/L Account No." > '50000') then begin
                                    GenJnlLine.Init;
                                    GenJnlLine."Journal Template Name" := 'General';
                                    GenJnlLine."Journal Batch Name" := 'CPYJRNL';
                                    AccSchedLineNo := AccSchedLineNo + 10000;
                                    GenJnlLine."Line No." := AccSchedLineNo;
                                    GenJnlLine."Document No." := lastGLE."Document No.";
                                    GenJnlLine."Document Type" := lastGLE."Document Type";
                                    GenJnlLine.Description := lastGLE.Description;
                                    GenJnlLine.Amount := lastGLE.Amount;

                                    GenJnlLine."Account Type" := "Gen. Journal Account Type"::"G/L Account";
                                    GenJnlLine."External Document No." := lastGLE."External Document No.";
                                    GenJnlLine."Account No." := lastGLE."G/L Account No.";
                                    if lastGLE."Dimension Set ID" <> 0 then begin

                                        DimEntry.SetFilter("Dimension Set ID", '%1', lastGLE."Dimension Set ID");
                                        if DimEntry.FindSet() then
                                            repeat

                                                if DimEntry."Dimension Code" = 'PROJECT' then begin
                                                    DimProject := DimEntry."Dimension Value Code"
                                                end else
                                                    if DimEntry."Dimension Code" = 'DEPARTMENT' then begin
                                                        DimDept := DimEntry."Dimension Value Code"
                                                    end else
                                                        if DimEntry."Dimension Code" = 'COMPANY' then begin
                                                            DimComp := DimEntry."Dimension Value Code"
                                                        end else
                                                            if DimEntry."Dimension Code" = 'VENDOR' then begin
                                                                dimVend := DimEntry."Dimension Value Name";
                                                                VendorCard.SetFilter("No.", DimEntry."Dimension Value Code");
                                                                if VendorCard.FindSet() then begin
                                                                    DimVend := VendorCard.Name;
                                                                end;
                                                            end;
                                            until DimEntry.Next() = 0;
                                    end;
                                    GenJnlLine."Dimension Set ID" := lastGLE."Dimension Set ID";
                                    GenJnlLine."shortcut Dimension 1 Code" := lastGLE."Global Dimension 1 Code";
                                    GenJnlLine."shortcut Dimension 2 Code" := lastGLE."Global Dimension 2 Code";
                                    //GenJnlLine.ba
                                    //GenJnlLine."Shortcut Dimension  Code" := lastGLE."Shortcut Dimension 1 Code";
                                    //                            GenJnlLine."Shortcut Dimension 2 Code" := lastGLE."Global Dimension 2 Code";
                                    GenJnlLine.Insert();
                                    //DimMgmt.GetDimensionSet(TempDimSetEntry, lastGLE."Dimension Set ID");
                                    //TempDimSetEntry.Init();
                                    //TempDimSetEntry.VALIDATE("Dimension Code", 'PROJECT');
                                    //TempDimSetEntry.VALIDATE("Dimension Value Code", dimProject);
                                    //if not TempDimSetEntry.INSERT then
                                    //    TempDimSetEntry.Modify;
                                    //GenJnlLine.Validate("Dimension Set ID", DimMgmt.GetDimensionSetID(TempDimSetEntry));

                                    //GenJnlLine.MODIFY;

                                end;
                            end else begin
                                GenJnlLine.Init;
                                GenJnlLine."Journal Template Name" := 'General';
                                GenJnlLine."Journal Batch Name" := 'CPYJRNL';
                                AccSchedLineNo := AccSchedLineNo + 10000;
                                GenJnlLine."Line No." := AccSchedLineNo;
                                GenJnlLine."Document No." := lastGLE."Document No.";
                                GenJnlLine."Document Type" := lastGLE."Document Type";
                                GenJnlLine.Description := lastGLE.Description;
                                GenJnlLine.Amount := lastGLE.Amount;

                                GenJnlLine."Account Type" := "Gen. Journal Account Type"::"G/L Account";
                                GenJnlLine."External Document No." := lastGLE."External Document No.";
                                GenJnlLine."Account No." := lastGLE."G/L Account No.";
                                GenJnlLine."shortcut Dimension 1 Code" := lastGLE."Global Dimension 1 Code";
                                GenJnlLine."shortcut Dimension 2 Code" := lastGLE."Global Dimension 2 Code";
                                GenJnlLine."Dimension Set ID" := lastGLE."Dimension Set ID";
                                //GenJnlLine.ba
                                //GenJnlLine."Shortcut Dimension  Code" := lastGLE."Shortcut Dimension 1 Code";
                                //                            GenJnlLine."Shortcut Dimension 2 Code" := lastGLE."Global Dimension 2 Code";
                                GenJnlLine.Insert();
                                //DimMgmt.GetDimensionSet(TempDimSetEntry, lastGLE."Dimension Set ID");


                                /*                                if lastGLE."Dimension Set ID" > 0 then begin
                                                                    DimEntry.SetFilter("Dimension Set ID", '%1', lastGLE."Dimension Set ID");
                                                                    if DimEntry.FindSet() then
                                                                        repeat
                                                                            if DimEntry."Dimension Code" = 'PROJECT' then begin
                                                                                DimProject := DimEntry."Dimension Value Code";
                                                                                //Message(dimProject);
                                                                            end;
                                                                            if DimEntry."Dimension Code" = 'DEPARTMENT' then begin
                                                                                DimDept := DimEntry."Dimension Value Code";
                                                                                //Message(dimDept);
                                                                            end;
                                                                            if DimEntry."Dimension Code" = 'COMPANY' then begin
                                                                                DimComp := DimEntry."Dimension Value Code";
                                                                                //Message(dimComp);
                                                                            end;
                                                                            if DimEntry."Dimension Code" = 'VENDOR' then begin
                                                                                dimVend := DimEntry."Dimension Value Name";
                                                                                dimValue.SetFilter(dimValue.Code, DimEntry."Dimension Value Code");
                                                                                if dimValue.FindFirst() then begin
                                                                                    dimVend := dimValue.Code;
                                                                                end;
                                                                            end;
                                                                        until DimEntry.Next() = 0;

                                                                    //         GenJnlLine."Dimension Set ID" := dimsetid;//DimMgmt.GetDimensionSetID(dimIDEntry);
                                                                end;
                                                                Message('%1,%2,%3,%4', dimProject, dimDept, dimComp, dimVend);
                                                                TempDimSetEntry.DeleteAll();
                                                                if dimProject <> '' then begin
                                                                    Message('project temp');
                                                                    TempDimSetEntry.Init();
                                                                    Message('after init');
                                                                    TempDimSetEntry.VALIDATE("Dimension Code", 'PROJECT');
                                                                    Message('After Validate dimension code of project');
                                                                    TempDimSetEntry.VALIDATE("Dimension Value Code", dimProject);
                                                                    Message('After Validate  dimension value code of project');
                                                                    TempDimSetEntry.Insert();
                                                                    Message('After Insert');
                                                                End;
                                                                if dimDept <> '' then begin
                                                                    Message('Department Temp');
                                                                    TempDimSetEntry.Init();
                                                                    TempDimSetEntry.VALIDATE("Dimension Code", 'DEPARTMENT');
                                                                    TempDimSetEntry.VALIDATE("Dimension Value Code", dimDept);
                                                                    TempDimSetEntry.Insert();
                                                                end;
                                                                if dimComp <> '' then begin
                                                                    Message('Department Temp');
                                                                    TempDimSetEntry.Init();
                                                                    TempDimSetEntry.VALIDATE("Dimension Code", 'COMPANY');
                                                                    TempDimSetEntry.VALIDATE("Dimension Value Code", dimComp);
                                                                    TempDimSetEntry.Insert();
                                                                end;
                                                                if dimVend <> '' then begin
                                                                    Message('Department Temp');
                                                                    TempDimSetEntry.Init();
                                                                    TempDimSetEntry.VALIDATE("Dimension Code", 'VENDOR');
                                                                    TempDimSetEntry.VALIDATE("Dimension Value Code", dimVend);
                                                                    TempDimSetEntry.Insert();
                                                                end;
                                                                Message('%1', DimMgmt.GetDimensionSetID(TempDimSetEntry));
                                                                GenJnlLine."Dimension Set ID" := DimMgmt.GetDimensionSetID(TempDimSetEntry);

                                                                GenJnlLine.Modify();
                                */
                            end;

                        until lastGLE.Next = 0;

                    Message('Entries copied to CPYJRNL batch');
                end;
            }
        }

        addafter(ReverseTransaction)
        {
            action("Reverse General Journal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reverse General Journal';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Copy selected General Ledger Entries and paste Reverse Genral Journal.';


                trigger OnAction()
                var
                    TempDimSetEntry: Record "Dimension Set Entry" temporary;
                    DimMgmt: Codeunit DimensionManagement;

                    GenJnlLine: Record "Gen. Journal Line";
                    lastGLE: Record "G/L Entry";
                    BankAccLE: Record "Bank Account Ledger Entry";
                    CustLE: Record "Cust. Ledger Entry";
                    EmpLE: Record "Employee Ledger Entry";
                    FALE: Record "FA Ledger Entry";
                    VendLE: Record "Vendor Ledger Entry";
                    dimEntry: Record "Dimension Set Entry";
                    dimIDEntry: Record "Dimension Set Entry";
                    generalBatch: Record "Gen. Journal Batch";
                    AccSchedLineNo: Integer;
                    vendorCard: Record Vendor;
                    dimProject: Text;
                    dimDept: Text;
                    dimComp: Text;
                    dimVend: Text;

                    rowNo: Integer;
                    strRowNo: Code[10];
                    BName: text;
                    num: Integer;
                    CheckDoc: Boolean;
                begin
                    CheckDoc := false;
                    generalBatch.SetFilter(Name, '%1', 'REVJRNL');
                    if not generalBatch.Find('+') then begin
                        generalBatch.Init();
                        generalBatch.Name := 'REVJRNL';
                        generalBatch.Description := 'Copied from GLE';
                        generalBatch."Bal. Account Type" := "Bal. Account Type"::"G/L Account";
                        generalBatch."No. Series" := 'GENJNL';
                        generalBatch."Journal Template Name" := 'GENERAL';
                        generalBatch.Insert(true);
                    end;
                    /*                    if Evaluate(num, BName.Substring(StrLen(BName), 1))
                                        then begin
                                            num := num + 1;
                                            generalBatch.Init();
                                            generalBatch.Name := 'Batch_' + format(num);
                                            generalBatch.Description := 'Copied from GLE';
                                            generalBatch."Bal. Account Type" := "Bal. Account Type"::"G/L Account";
                                            generalBatch."No. Series" := 'GJNL-GEN';
                                            generalBatch."Journal Template Name" := 'GENERAL';
                                            generalBatch.Insert(true);
                                        end; */
                    //num := BName.Substring(StrLen(BName), 1);
                    GenJnlLine.SetFilter("Journal Template Name", 'GENERAL');
                    GenJnlLine.SetFilter("Journal Batch Name", 'REVJRNL');
                    if GenJnlLine.Find('+') then begin
                        AccSchedLineNo := GenJnlLine."Line No.";
                    end;
                    BankAccLE.SetFilter("Document No.", rec."Document No.");
                    CustLE.SetFilter("Document No.", Rec."Document No.");
                    EmpLE.SetFilter("Document No.", Rec."Document No.");
                    FALE.SetFilter("Document No.", rec."Document No.");
                    VendLE.SetFilter("Document No.", Rec."Document No.");

                    BankAccLE.SetFilter("Document No.", rec."Document No.");

                    if BankAccLE.FindSet() then begin
                        lastGLE.Reset();
                        lastGLE.SetAscending("Entry No.", false);
                        lastGLE.SetFilter("Entry No.", '%1', BankAccLE."Entry No.");
                        if lastGLE.FindSet then begin

                            GenJnlLine.Init;
                            GenJnlLine."Journal Template Name" := 'General';
                            GenJnlLine."Journal Batch Name" := 'REVJRNL';
                            AccSchedLineNo := AccSchedLineNo + 10000;
                            GenJnlLine."Line No." := AccSchedLineNo;
                            GenJnlLine."Document No." := lastGLE."Document No.";
                            GenJnlLine."Document Type" := lastGLE."Document Type";
                            GenJnlLine.Description := lastGLE.Description;
                            GenJnlLine.Amount := lastGLE.Amount * (-1);
                            GenJnlLine."Account No." := BankAccLE."Bank Account No.";
                            GenJnlLine."Account Type" := "Gen. Journal Account Type"::"Bank Account";
                            GenJnlLine."External Document No." := lastGLE."External Document No.";
                            if lastGLE."Dimension Set ID" <> 0 then begin

                                DimEntry.SetFilter("Dimension Set ID", '%1', lastGLE."Dimension Set ID");
                                if DimEntry.FindSet() then
                                    repeat

                                        if DimEntry."Dimension Code" = 'PROJECT' then begin
                                            DimProject := DimEntry."Dimension Value Code"
                                        end else
                                            if DimEntry."Dimension Code" = 'DEPARTMENT' then begin
                                                DimDept := DimEntry."Dimension Value Code"
                                            end else
                                                if DimEntry."Dimension Code" = 'COMPANY' then begin
                                                    DimComp := DimEntry."Dimension Value Code"
                                                end else
                                                    if DimEntry."Dimension Code" = 'VENDOR' then begin
                                                        dimVend := DimEntry."Dimension Value Name";
                                                        VendorCard.SetFilter("No.", DimEntry."Dimension Value Code");
                                                        if VendorCard.FindSet() then begin
                                                            DimVend := VendorCard.Name;
                                                        end;
                                                    end;
                                    until DimEntry.Next() = 0;
                            end;
                            GenJnlLine."Dimension Set ID" := lastGLE."Dimension Set ID";

                            GenJnlLine."shortcut Dimension 1 Code" := lastGLE."Global Dimension 1 Code";
                            GenJnlLine."shortcut Dimension 2 Code" := lastGLE."Global Dimension 2 Code";
                            GenJnlLine.Insert();
                            CheckDoc := true;
                            //                  DimMgmt.GetDimensionSet(TempDimSetEntry, lastGLE."Dimension Set ID");
                            //                    TempDimSetEntry.Init();
                            //                      TempDimSetEntry.VALIDATE("Dimension Code", 'PROJECT');
                            //                        TempDimSetEntry.VALIDATE("Dimension Value Code", dimProject);
                            //                          if not TempDimSetEntry.INSERT then
                            //                                TempDimSetEntry.Modify;
                            //GenJnlLine.Validate("Dimension Set ID", DimMgmt.GetDimensionSetID(TempDimSetEntry));

                            //                            GenJnlLine.MODIFY;

                            /*                            GenJnlLine.Init;
                                                        GenJnlLine."Journal Template Name" := 'General';
                                                        GenJnlLine."Journal Batch Name" := 'REVJRNL';
                                                        AccSchedLineNo := AccSchedLineNo + 10000;
                                                        GenJnlLine."Line No." := AccSchedLineNo;
                                                        GenJnlLine."Document No." := lastGLE."Document No.";
                                                        GenJnlLine."Document Type" := lastGLE."Document Type";
                                                        GenJnlLine.Description := lastGLE.Description;
                                                        GenJnlLine.Amount := lastGLE.Amount;

                                                        GenJnlLine."Account Type" := "Gen. Journal Account Type"::"G/L Account";
                                                        GenJnlLine."External Document No." := lastGLE."External Document No.";
                                                        GenJnlLine."Account No." := lastGLE."G/L Account No.";
                                                        GenJnlLine."Dimension Set ID" := lastGLE."Dimension Set ID";
                                                        GenJnlLine."shortcut Dimension 1 Code" := lastGLE."Global Dimension 1 Code";
                                                        GenJnlLine."shortcut Dimension 2 Code" := lastGLE."Global Dimension 2 Code";
                                                        //GenJnlLine.ba
                                                        //GenJnlLine."Shortcut Dimension  Code" := lastGLE."Shortcut Dimension 1 Code";
                                                        //                            GenJnlLine."Shortcut Dimension 2 Code" := lastGLE."Global Dimension 2 Code";
                                                        GenJnlLine.Insert();
                            */
                        end;
                    end;
                    if CustLE.FindSet() then begin

                    end;
                    if EmpLE.FindSet() then begin

                    end;
                    if FALE.FindSet() then begin

                    end;
                    if VendLE.FindSet() then begin

                    end;
                    lastGLE.Reset();
                    lastGLE.SetFilter("Document No.", Rec."Document No.");
                    if lastGLE.FindSet then
                        repeat
                            if (CheckDoc = true) then begin
                                if (lastGLE."G/L Account No." > '50000') then begin
                                    GenJnlLine.Init;
                                    GenJnlLine."Journal Template Name" := 'General';
                                    GenJnlLine."Journal Batch Name" := 'REVJRNL';
                                    AccSchedLineNo := AccSchedLineNo + 10000;
                                    GenJnlLine."Line No." := AccSchedLineNo;
                                    GenJnlLine."Document No." := lastGLE."Document No.";
                                    GenJnlLine."Document Type" := lastGLE."Document Type";
                                    GenJnlLine.Description := lastGLE.Description;
                                    GenJnlLine.Amount := lastGLE.Amount * (-1);

                                    GenJnlLine."Account Type" := "Gen. Journal Account Type"::"G/L Account";
                                    GenJnlLine."External Document No." := lastGLE."External Document No.";
                                    GenJnlLine."Account No." := lastGLE."G/L Account No.";
                                    if lastGLE."Dimension Set ID" <> 0 then begin

                                        DimEntry.SetFilter("Dimension Set ID", '%1', lastGLE."Dimension Set ID");
                                        if DimEntry.FindSet() then
                                            repeat

                                                if DimEntry."Dimension Code" = 'PROJECT' then begin
                                                    DimProject := DimEntry."Dimension Value Code"
                                                end else
                                                    if DimEntry."Dimension Code" = 'DEPARTMENT' then begin
                                                        DimDept := DimEntry."Dimension Value Code"
                                                    end else
                                                        if DimEntry."Dimension Code" = 'COMPANY' then begin
                                                            DimComp := DimEntry."Dimension Value Code"
                                                        end else
                                                            if DimEntry."Dimension Code" = 'VENDOR' then begin
                                                                dimVend := DimEntry."Dimension Value Name";
                                                                VendorCard.SetFilter("No.", DimEntry."Dimension Value Code");
                                                                if VendorCard.FindSet() then begin
                                                                    DimVend := VendorCard.Name;
                                                                end;
                                                            end;
                                            until DimEntry.Next() = 0;
                                    end;

                                    GenJnlLine."Dimension Set ID" := lastGLE."Dimension Set ID";
                                    GenJnlLine."shortcut Dimension 1 Code" := lastGLE."Global Dimension 1 Code";
                                    GenJnlLine."shortcut Dimension 2 Code" := lastGLE."Global Dimension 2 Code";
                                    //GenJnlLine.ba
                                    //GenJnlLine."Shortcut Dimension  Code" := lastGLE."Shortcut Dimension 1 Code";
                                    //                            GenJnlLine."Shortcut Dimension 2 Code" := lastGLE."Global Dimension 2 Code";
                                    GenJnlLine.Insert();
                                    //DimMgmt.GetDimensionSet(TempDimSetEntry, lastGLE."Dimension Set ID");
                                    //TempDimSetEntry.Init();
                                    //TempDimSetEntry.VALIDATE("Dimension Code", 'PROJECT');
                                    //TempDimSetEntry.VALIDATE("Dimension Value Code", dimProject);
                                    //if not TempDimSetEntry.INSERT then
                                    //    TempDimSetEntry.Modify;
                                    //GenJnlLine.Validate("Dimension Set ID", DimMgmt.GetDimensionSetID(TempDimSetEntry));

                                    //                                    GenJnlLine.MODIFY;

                                end;
                            end else begin
                                GenJnlLine.Init;
                                GenJnlLine."Journal Template Name" := 'General';
                                GenJnlLine."Journal Batch Name" := 'REVJRNL';
                                AccSchedLineNo := AccSchedLineNo + 10000;
                                GenJnlLine."Line No." := AccSchedLineNo;
                                GenJnlLine."Document No." := lastGLE."Document No.";
                                GenJnlLine."Document Type" := lastGLE."Document Type";
                                GenJnlLine.Description := lastGLE.Description;
                                GenJnlLine.Amount := lastGLE.Amount * (-1);

                                GenJnlLine."Account Type" := "Gen. Journal Account Type"::"G/L Account";
                                GenJnlLine."External Document No." := lastGLE."External Document No.";
                                GenJnlLine."Account No." := lastGLE."G/L Account No.";
                                //GenJnlLine."Dimension Set ID" := lastGLE."Dimension Set ID";
                                /*if lastGLE."Dimension Set ID" <> 0 then begin

                                    DimEntry.SetFilter("Dimension Set ID", '%1', lastGLE."Dimension Set ID");
                                    if DimEntry.FindSet() then
                                        repeat

                                            if DimEntry."Dimension Code" = 'PROJECT' then begin
                                                DimProject := DimEntry."Dimension Value Code"
                                            end else
                                                if DimEntry."Dimension Code" = 'DEPARTMENT' then begin
                                                    DimDept := DimEntry."Dimension Value Code"
                                                end else
                                                    if DimEntry."Dimension Code" = 'COMPANY' then begin
                                                        DimComp := DimEntry."Dimension Value Code"
                                                    end else
                                                        if DimEntry."Dimension Code" = 'VENDOR' then begin
                                                            dimVend := DimEntry."Dimension Value Name";
                                                            VendorCard.SetFilter("No.", DimEntry."Dimension Value Code");
                                                            if VendorCard.FindSet() then begin
                                                                DimVend := VendorCard.Name;
                                                            end;
                                                        end;
                                        until DimEntry.Next() = 0;
                                end;*/
                                GenJnlLine."Dimension Set ID" := lastGLE."Dimension Set ID";
                                GenJnlLine."shortcut Dimension 1 Code" := lastGLE."Global Dimension 1 Code";
                                GenJnlLine."shortcut Dimension 2 Code" := lastGLE."Global Dimension 2 Code";
                                //GenJnlLine.ba
                                //GenJnlLine."Shortcut Dimension  Code" := lastGLE."Shortcut Dimension 1 Code";
                                //                            GenJnlLine."Shortcut Dimension 2 Code" := lastGLE."Global Dimension 2 Code";
                                GenJnlLine.Insert();
                                //                                DimMgmt.GetDimensionSet(TempDimSetEntry, lastGLE."Dimension Set ID");
                                //                             TempDimSetEntry.Init();
                                //                               TempDimSetEntry.VALIDATE("Dimension Code", 'PROJECT');
                                //                                TempDimSetEntry.VALIDATE("Dimension Value Code", dimProject);
                                //                                if not TempDimSetEntry.INSERT then
                                //                                    TempDimSetEntry.Modify;
                                //                                GenJnlLine.Validate("Dimension Set ID", DimMgmt.GetDimensionSetID(TempDimSetEntry));

                                //                                GenJnlLine.MODIFY;

                            end;
                        until lastGLE.Next = 0;
                    Message('Entries copied to REVJRNL batch');
                end;
            }
        }
    }
}

/*
codeunit 50106 CreateDimEntry
{
    Permissions = tabledata "Dimension Set Entry" = rimd;
    trigger OnRun()
    begin

    end;

    procedure insertEntry(dimSetID: Integer; Project: Text; Dept: Text; Company: Text; Vendor: Text)
    var
        DimSetEnt: Record "Dimension Set Entry";
        VendorList: Record Vendor;
        DimVal: Record "Dimension Value";
        VendorNum: Text;
    begin
        // Message('in code unit dim set id is %1', dimSetID);
        if Vendor <> ''
        then begin
            VendorList.SetFilter(Name, Vendor);
            if VendorList.Find() then begin
                VendorNum := VendorList."No.";
            end;
        end;
        DimSetEnt.init();
        if Project <> '' then begin
            DimSetEnt."Dimension Set ID" := dimSetID + 1;
            DimSetEnt."Dimension Code" := 'PROJECT';
            DimVal.Init();
            DimVal.SetFilter(DimVal."Dimension Code", 'PROJECT');
            DimVal.SetFilter(DimVal.Code, Project);
            if DimVal.FindFirst() then begin
                DimSetEnt."Dimension Value ID" := DimVal."Dimension Value ID";
            end;
            DimSetEnt."Dimension Value Code" := Project;
            DimSetEnt.Insert();
        end;
        DimSetEnt.init();
        if Dept <> '' then begin
            DimSetEnt."Dimension Set ID" := dimSetID + 1;
            DimSetEnt."Dimension Code" := 'DEPARTMENT';
            DimVal.Init();
            DimVal.SetFilter(DimVal."Dimension Code", 'DEPARTMENT');
            DimVal.SetFilter(DimVal.Code, Dept);
            if DimVal.FindFirst() then begin
                DimSetEnt."Dimension Value ID" := DimVal."Dimension Value ID";
            end;
            DimSetEnt."Dimension Value Code" := Dept;
            DimSetEnt.Insert();
        end;
        DimSetEnt.init();
        if Company <> '' then begin
            DimSetEnt."Dimension Set ID" := dimSetID + 1;
            DimSetEnt."Dimension Code" := 'COMPANY';
            DimVal.Init();
            DimVal.SetFilter(DimVal."Dimension Code", 'COMPANY');
            DimVal.SetFilter(DimVal.Code, Company);
            if DimVal.FindFirst() then begin
                DimSetEnt."Dimension Value ID" := DimVal."Dimension Value ID";
            end;
            DimSetEnt."Dimension Value Code" := Company;
            DimSetEnt.Insert();
        end;
        DimSetEnt.Init();
        if VendorNum <> '' then begin
            DimSetEnt."Dimension Set ID" := dimSetID + 1;
            DimSetEnt."Dimension Code" := 'VENDOR';
            DimVal.Init();
            DimVal.SetFilter(DimVal."Dimension Code", 'VENDOR');
            DimVal.SetFilter(DimVal.Code, Vendor);
            if DimVal.FindFirst() then begin
                DimSetEnt."Dimension Value ID" := DimVal."Dimension Value ID";
            end;
            DimSetEnt."Dimension Value Code" := Vendor;
            DimSetEnt."Dimension Value Name" := VendorNum;
            DimSetEnt.Insert();
        end;

    end;

}*/
