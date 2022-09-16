// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

/*pageextension 50116 PurchaseJournExt extends "Purchase Journal"
{
    layout
    {
        modify("Debit Amount")
        { Visible = true; }
        modify("Credit Amount")
        { Visible = true; }
    }
}*/


report 50114 "Dimensions Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    AdditionalSearchTerms = 'dimensions, report';
    DefaultLayout = RDLC;
    RDLCLayout = 'layout/DimensionReport.rdl';

    dataset
    {
        dataitem(Company; Company)
        {
            DataItemTableView = where(Name = filter('Ancora Innovation, LLC' | 'Blue One Biosciences, LLC' | 'Blue Q Biosciences LLC' |
            'Bluefield Innovations, LLC' | 'Deerfield D??, LLC' | 'Exohalt Therapeutics, LLC' | 'Galium Biosciences LLC' |
            'Hudson Heights Innovations LLC' | 'Lakeside Discovery, LLC' | 'Pinnacle Hill, LLC' | 'Poseidon Innovation, LLC' |
            'West Loop Innovations, LLC'));
            column(Name; Name) { }
            dataitem("G/L Entry"; "G/L Entry")
            {
                column(Global_Dimension_1_Code; "Global Dimension 1 Code")
                {

                }
                column(Document_No_; "Document No.")
                {

                }
                column(Posting_Date; "Posting Date")
                {

                }
                column(G_L_Account_Name; "G/L Account Name")
                { }
                column(Amount; Amount)
                {

                }

                trigger OnPreDataItem()
                begin
                    SetFilter("Global Dimension 1 Code", '<>%1', '');
                end;
            }
            trigger OnAfterGetRecord()
            begin
                //                message(Name);
                "G/L Entry".ChangeCompany(Name);
            end;
        }

    }
    /*
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Name; SourceExpression)
                    {
                        ApplicationArea = All;
                        
                    }
                }
            }
        }
    
        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                    
                }
            }
        }
    }
    
    var
        myInt: Integer;
        */
}


pageextension 50118 GLEntriesExt extends "General Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        modify("Global Dimension 1 Code")
        {
            Visible = true;
        }
    }
}