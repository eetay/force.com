public without sharing class ApprovalUtils {
  boolean isInApproval(ID recordId, boolean isApproved) {
    String status = isApproved ? 'Approved' : '';
    List<ProcessInstance> pi = [Select ID, Status, TargetObject.Name,
                    (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),
                    (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance
                    Where TargetObjectID = :recordId AND Status = :status];
    return !pi.isEmpty();
  }
  boolean isLockedByApproval(ID recordId) {
    return Approval.isLocked(recordId);
  }
  // https://developer.salesforce.com/forums/?id=906F00000008r1AIAQ
}
