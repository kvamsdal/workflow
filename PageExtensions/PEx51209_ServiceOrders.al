pageextension 51209 "HBR Service Order" extends "Service Order"
{
    layout
    {
        addafter("Release Status")
        {
            field("Approval Status"; "Approval Status")
            {
                ApplicationArea = all;
            }
        }

        modify(Status)
        {
            trigger OnAfterValidate()
            begin
                SetControlVisibility
            end;
        }
    }

    actions
    {
        addlast(processing)
        {
            group("Request Approval")
            {
                action(SendApprovalRequest)
                {

                    ApplicationArea = All;
                    Caption = 'Send Approval Request';
                    Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow AND RepairIsComplete;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = SendApprovalRequest;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    begin
                        if ServiceWFIntegr.CheckWorkflowEnabled(Rec) then
                            ServiceWFIntegr.OnSendServiceOrderforApproval(Rec);
                    end;

                }

                action(CancelApprovalRequest)
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Approval Request';
                    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ServiceWFIntegr.OnCancelServiceOrderApprovalRequest(Rec);
                        WorkflowWebhookMgt.FindAndCancel(RecordId);
                    end;
                }
                action("Reopen Approval")
                {
                    ApplicationArea = Suite;
                    Caption = 'Reopen';
                    Enabled = "Approval Status" <> "Approval Status"::Open;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';

                    trigger OnAction()
                    var
                    begin
                        ServiceWFIntegr.OnReopenServiceOrder(Rec);
                    end;
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        SetControlVisibility;
    end;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);

        RepairIsComplete := rec.Status = rec.status::Finished;
    end;

    var
        ServiceWFIntegr: Codeunit "WF Integration Service";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        CanCancelApprovalForRecord: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        RepairIsComplete: Boolean;
        CanCancelApprovalForFlow: Boolean;
}