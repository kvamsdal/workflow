codeunit 51201 "WF Integration Service"
{
    trigger OnRun()
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendServiceOrderforApproval(VAR ServHeader: Record "Service Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelServiceOrderApprovalRequest(VAR ServHeader: Record "Service Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnReopenServiceOrder(VAR ServHeader: Record "Service Header");
    begin
    end;

    local procedure IsServiceOrderEnabled(var ServHeader: Record "Service Header"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit "WF Code Service";
    begin
        exit(WFMngt.CanExecuteWorkflow(ServHeader, WFCode.RunWorkflowOnSendServiceOrderApprovalCode()))
    end;

    procedure CheckWorkflowEnabled(var ServHeader: Record "Service Header"): Boolean
    var
        NoWorkflowEnb: Label 'No workflow Enabled for this Record type';
    begin
        if not IsServiceOrderEnabled(ServHeader) then
            Error(NoWorkflowEnb);

        exit(true);
    end;
}