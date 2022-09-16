// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!


query 50111 ItemAssgnQryPurch
{
    QueryType = Normal;

    elements
    {
        dataitem(DataItemName; "Item Charge Assignment (Purch)")
        {
            column(Applies_to_Doc__Type; "Applies-to Doc. Type")
            {

            }
            column(Applies_to_Doc__No_; "Applies-to Doc. No.")
            {

            }
            column(Applies_to_Doc__Line_No_; "Applies-to Doc. Line No.")
            {

            }
            column(Item_No_; "Item No.")
            {

            }
            column(Description; Description)
            {

            }
            column(Qty__to_Assign; "Qty. to Assign")
            {

            }
            column(Qty__Assigned; "Qty. Assigned")
            {

            }
            column(Amount_to_Assign; "Amount to Assign")
            {

            }
            /*                column(PurchLineInvoiced;PurchLineInvoiced)
            {

            }                column(Applies_to_Doc__Type;"Applies-to Doc. Type")
            {

            }                column(Applies_to_Doc__Type;"Applies-to Doc. Type")
            {

            }                column(Applies_to_Doc__Type;"Applies-to Doc. Type")
            {

            }                column(Applies_to_Doc__Type;"Applies-to Doc. Type")
            {

            }                column(Applies_to_Doc__Type;"Applies-to Doc. Type")
            {

            }                column(Applies_to_Doc__Type;"Applies-to Doc. Type")
            {

            }                column(Applies_to_Doc__Type;"Applies-to Doc. Type")
            {

            }                column(Applies_to_Doc__Type;"Applies-to Doc. Type")
            {

            }                column(Applies_to_Doc__Type;"Applies-to Doc. Type")
            {

            }                column(Applies_to_Doc__Type;"Applies-to Doc. Type")
            {

            }                column(Applies_to_Doc__Type;"Applies-to Doc. Type")
            {

            }                column(Applies_to_Doc__Type;"Applies-to Doc. Type")
            {

            }*/
            // filter(FilterName; SourceFieldName)
            // {

            // }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}