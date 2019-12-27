tableextension 51207 "HBR Service Header" extends "Service Header"
{
    fields
    {
        field(51200; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval",Released;
            OptionCaption = 'Open,Pending Approval,Released';
            Editable = false;
        }
    }

    trigger OnBeforeModify()
    var
        ErrorApprovalStatus: label 'You cannot modify Service Order %1 because Approval Status is %2';
    begin
        if "Approval Status" = "Approval Status"::Released then
            Error(ErrorApprovalStatus, rec."No.", rec."Approval Status")
    end;
}