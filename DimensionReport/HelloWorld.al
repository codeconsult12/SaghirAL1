// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

report 50114 "Dimensions Report-Summary"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = None;
    AdditionalSearchTerms = 'dimensions, report';
    DefaultLayout = RDLC;
    RDLCLayout = 'layout/DimensionReport-Summary.rdl';

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
}

report 50115 "Dimensions Report - Detailed"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = None;
    AdditionalSearchTerms = 'dimensions, report';
    DefaultLayout = RDLC;
    RDLCLayout = 'layout/DimensionReport-Detail.rdl';

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
}


report 50116 "Dimensions Exp. Report-Summary"
{
    Caption = 'Dimensions Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    AdditionalSearchTerms = 'dimensions, report';
    DefaultLayout = RDLC;
    RDLCLayout = 'layout/DimensionExpReport-Summary.rdl';

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
                    SetFilter("G/L Account No.", '>50000');
                end;
            }
            trigger OnAfterGetRecord()
            begin
                //                message(Name);
                "G/L Entry".ChangeCompany(Name);
            end;
        }

    }
}

report 50117 "Dimensions Exp. Report-Detail"
{
    Caption = 'Dimensions Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = None;
    AdditionalSearchTerms = 'dimensions, report';
    DefaultLayout = RDLC;
    RDLCLayout = 'layout/DimensionExpReport-Detailed.rdl';

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
                    SetFilter("G/L Account No.", '>50000');
                end;
            }
            trigger OnAfterGetRecord()
            begin
                //                message(Name);
                "G/L Entry".ChangeCompany(Name);
            end;
        }

    }
}


report 50119 "Vendor Expense By Dimension"
{
    Caption = 'Vendor Expense By Dimension';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    AdditionalSearchTerms = 'dimensions, report, vendor, expense';
    DefaultLayout = RDLC;
    RDLCLayout = 'layout/DimensionVendorExpReport-Summary.rdl';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Amount; Amount) { }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Document No." = field("Document No.");

                dataitem(Vendor; Vendor)
                {
                    DataItemLink = "No." = field("Vendor No.");
                    column(Name; Name)
                    { }
                }
            }
            trigger OnPreDataItem()
            begin
                SetFilter("Document Type", '%1', "Document Type"::Invoice);
                SetFilter("G/L Account No.", '>50000');
            end;
        }
    }
}


pageextension 50118 "Bus. Mgr. Role Ext" extends "Business Manager Role Center"
{
    actions
    {
        addafter("Excel Reports")
        {
            action("Analysis Views")
            {
                Caption = 'Analysis View by Dimensions';
                Image = Action;
                Promoted = true;
                PromotedCategory = Report;
                RunObject = page "Analysis by Dimensions";
                ApplicationArea = All;
            }
            action("Analysis View Entries")
            {
                Caption = 'Analysis View Entries';
                Image = Action;
                Promoted = true;
                PromotedCategory = Report;
                RunObject = page "Analysis View Entries";
                ApplicationArea = All;

            }
        }
    }

}