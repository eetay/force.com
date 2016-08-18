public without sharing class ApprovalUtils {
  public static boolean isInApproval(ID recordId, boolean isApproved) {
    String status = isApproved ? 'Approved' : 'Pending';
    List<ProcessInstance> pi = [
        SELECT Id, Status, TargetObject.Name,
        (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),
        (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance
        WHERE TargetObjectID = :recordId AND Status = :status
    ];
    return !pi.isEmpty();
  }
  public static boolean isLockedByApproval(ID recordId) {
    return Approval.isLocked(recordId);
  }
  // https://developer.salesforce.com/forums/?id=906F00000008r1AIAQ
}
