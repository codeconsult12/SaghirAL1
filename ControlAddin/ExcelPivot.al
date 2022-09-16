/*report 50121 CustLedgerEntry
{

    ProcessingOnly=true;
    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {


            trigger OnPreDataItem()
            begin
                CREATE(Excel);
                Excel.Workbooks.Add();
                Sheet := Excel.ActiveSheet;
                Sheet.Name := 'CUST_LEDGER';
                Window.OPEN(Text00001);
                Excel.Visible(TRUE);
                I := 5;
                Sheet.Range('A1').Value := "Cust. Ledger Entry".TABLECAPTION;
                Sheet.Range('C1').Value := 'USER ID ';
                Sheet.Range('D1').Value := USERID;
                Sheet.Range('C2').Value := 'DATE ';
                Sheet.Range('D2').Value := TODAY;
                UpdateExcelrange;
                Sheet.Range(ExcelRange[1]).Value := "Cust. Ledger Entry".FIELDCAPTION("Cust. Ledger Entry"."Entry No.");
                Sheet.Range(ExcelRange[2]).Value := "Cust. Ledger Entry".FIELDCAPTION("Cust. Ledger Entry"."Posting Date");
                Sheet.Range(ExcelRange[3]).Value := "Cust. Ledger Entry".FIELDCAPTION("Cust. Ledger Entry"."Customer No.");
                Sheet.Range(ExcelRange[4]).Value := Cust.FIELDCAPTION(Cust.Name);
                Sheet.Range(ExcelRange[5]).Value := "Cust. Ledger Entry".FIELDCAPTION("Cust. Ledger Entry"."Document No.");
                Sheet.Range(ExcelRange[6]).Value := "Cust. Ledger Entry".FIELDCAPTION("Cust. Ledger Entry".Description);
                Sheet.Range(ExcelRange[7]).Value := "Cust. Ledger Entry".FIELDCAPTION("Cust. Ledger Entry"."Global Dimension 1 Code");
                Sheet.Range(ExcelRange[8]).Value := "Cust. Ledger Entry".FIELDCAPTION("Cust. Ledger Entry"."Global Dimension 2 Code");
                Sheet.Range(ExcelRange[9]).Value := "Cust. Ledger Entry".FIELDCAPTION("Cust. Ledger Entry"."Amount (LCY)");
                Sheet.Range(ExcelRange[10]).Value := 'YEAR';
            end;

            trigger OnAfterGetRecord()
            begin
                CLEAR(Cust);
                IF Cust.GET("Cust. Ledger Entry"."Customer No.") THEN;
                K := ROUND(((I - 5) / "Cust. Ledger Entry".COUNT) * 10000, 1);
                Window.UPDATE(1, K);
                "Cust. Ledger Entry".CALCFIELDS("Cust. Ledger Entry"."Amount (LCY)");
                UpdateExcelrange;
                Sheet.Range(ExcelRange[1]).Value := "Cust. Ledger Entry"."Entry No.";
                Sheet.Range(ExcelRange[2]).Value := "Cust. Ledger Entry"."Posting Date";
                Sheet.Range(ExcelRange[3]).Value := "Cust. Ledger Entry"."Customer No.";
                Sheet.Range(ExcelRange[4]).Value := Cust.Name;
                Sheet.Range(ExcelRange[5]).Value := "Cust. Ledger Entry"."Document No.";
                Sheet.Range(ExcelRange[6]).Value := "Cust. Ledger Entry".Description;
                Sheet.Range(ExcelRange[7]).Value := "Cust. Ledger Entry"."Global Dimension 1 Code";
                Sheet.Range(ExcelRange[8]).Value := "Cust. Ledger Entry"."Global Dimension 2 Code";
                Sheet.Range(ExcelRange[9]).Value := "Cust. Ledger Entry"."Amount (LCY)";
                Sheet.Range(ExcelRange[10]).Value := FORMAT("Cust. Ledger Entry"."Posting Date", 0, '') + ' ' +
                FORMAT("Cust. Ledger Entry"."Posting Date", 0, '');
            end;

            trigger OnPostDataItem()
            begin
                xlPivotCache := Excel.ActiveWorkbook.PivotCaches.Add(1, 'CUST_LEDGER!A6:J' + FORMAT(I));
                xlPivotCache.CreatePivotTable('', 'PivotTable1');
                Sheet := Excel.ActiveSheet();
                xlPivotTable := Sheet.PivotTables('PivotTable1');
                Sheet.Name := 'Cust_Ledger_Pivot';
                xlPivotField := xlPivotTable.PivotFields('YEAR');
                xlPivotField.Orientation := 1;
                xlPivotField.Position := 1;
                IF "Pivot Base" = "Pivot Base"::Customer THEN
                    xlPivotField := xlPivotTable.PivotFields(Cust.FIELDCAPTION(Cust.Name))
                ELSE
                    IF "Pivot Base" = "Pivot Base"::Dimension THEN
                        xlPivotField := xlPivotTable.PivotFields("Cust. Ledger Entry".FIELDCAPTION("Cust. Ledger Entry"."Global Dimension 1 Code"));
                xlPivotField.Orientation := 1;
                xlPivotField.Position := 2;
                xlPivotField := xlPivotTable.PivotFields("Cust. Ledger Entry".FIELDCAPTION("Cust. Ledger Entry"."Amount (LCY)"));
                xlPivotTable.AddDataField(xlPivotField);
                xlPivotField := xlPivotTable.DataPivotField;
                xlPivotField := xlPivotTable.PivotFields('YEAR');
                xlPivotField.Orientation := 2;
                xlPivotField.Position := 1;
            end;
        }

    }
var
Excel: 
    local procedure UpdateExcelrange()
    begin
        I += 1;
        ExcelRange[1] := 'A' + FORMAT(I);
        ExcelRange[2] := 'B' + FORMAT(I);
        ExcelRange[3] := 'C' + FORMAT(I);
        ExcelRange[4] := 'D' + FORMAT(I);
        ExcelRange[5] := 'E' + FORMAT(I);
        ExcelRange[6] := 'F' + FORMAT(I);
        ExcelRange[7] := 'G' + FORMAT(I);
        ExcelRange[8] := 'H' + FORMAT(I);
        ExcelRange[9] := 'I' + FORMAT(I);
        ExcelRange[10] := 'J' + FORMAT(I);
    end;
}*/