// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

controladdin PowerBIStretchAddIn
{
    StartupScript = './Addin/Script.js';
    StyleSheets = './Addin/Style.css';

    HorizontalStretch = true;
    HorizontalShrink = true;
    VerticalStretch = true;
    VerticalShrink = true;
    MinimumWidth = 250;
    MinimumHeight = 250;
    MaximumHeight = 800;
}
page 50121 PowerBIPage
{
    Caption = 'Power Bi Reports';
    ApplicationArea = all;
    AdditionalSearchTerms = 'powerbi, expense, dimension';
    UsageCategory = Documents;
    PageType = Card;
    layout
    {
        area(Content)
        //       area(FactBoxes)
        {
            fixed(Power)
            {
                //           part()
                //         }
                part(Powerbi; "Power BI Report Spinner Part")
                {
                    ApplicationArea = all;

                }
            }
            group(AddInGroup)
            {
                usercontrol(AddIn; PowerBIStretchAddIn)
                {
                    ApplicationArea = all;

                }

            }
        }
    }
}

pageextension 50120 PowerBIRoleCenter extends "Business Manager Role Center"
{

    /*    layout
        {
            modify(Control98)
            {
                // Add changes to page layout here
                Visible = true;
            }
            addafter(Control98)
            {
                part(Power; "Power BI Report FactBox")
                {
                    Enabled = true;
                    ApplicationArea = all;
                    Editable = true;
                    Visible = true;
                }
            }
        }*/
    actions
    {
        addafter("Excel Reports")
        {
            action("PowerBI")
            {
                ApplicationArea = all;
                RunObject = page PowerBIPage;
            }
        }
    }
}
