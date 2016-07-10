public with sharing class AttachEntitlementToCase {
	public AttachEntitlementToCase() {

	}
  public static void attachByContact(List<Case> cases) {
    try {
      System.debug('attachByContact');
      List<Id> contactIds = new List<Id>();
      for (Case c : cases) {
        contactIds.add(c.ContactId);
      }
      List <EntitlementContact> entlContacts = [
        Select e.EntitlementId, e.ContactId, e.Entitlement.AssetId, e.Entitlement.Name
        From EntitlementContact e
        Where e.ContactId in :contactIds
      ];
        //And e.Entitlement.EndDate >= Today
        //And e.Entitlement.StartDate <= Today
      if(entlContacts.isEmpty()) {
        System.debug('attachByContact done; no contacts');
        return;
      }
      for(Case c : cases){
        System.debug('attachByContact; case:' + c.Subject + ' contact:' + c.ContactId);
        if ((c.EntitlementId != null)||(c.ContactId == null)) continue;
        for(EntitlementContact ec : entlContacts) {
          if(ec.ContactId == c.ContactId){
            System.debug('attachByAccount; case:' + c.Subject + ' <-- entitlement:' + ec.Entitlement.Name);
            c.EntitlementId = ec.EntitlementId;
            if(c.AssetId==null && ec.Entitlement.AssetId!=null) {
              c.AssetId=ec.Entitlement.AssetId;
            }
            break;
          }
        }
      } // for
      System.debug('attachByContact done');
    }
    catch (Exception e) {
      System.debug(e);
    }
  }
  //
  //
  //
  public static void attachByAccount(List<Case> cases) {
    try {
      System.debug('attachByAccount');
      List<Id> acctIds = new List<Id>();
      for (Case c : cases) {
        acctIds.add(c.accountId);
      }
      List <Entitlement> entls = [
        Select e.StartDate, e.Id, e.EndDate, e.AccountId, e.AssetId, e.Name
        From Entitlement e
        Where e.AccountId in :acctIds
      ];
        //And e.EndDate >= Today
        //And e.StartDate <= Today
      if(entls.isEmpty()) return;
      for (Case c : cases) {
        System.debug('attachByAccount; case:' + c.Subject + ' account:' + c.AccountId);
        if((c.EntitlementId != null) || (c.AccountId == null)) continue;
        for(Entitlement e : entls){
          if (e.AccountId==c.AccountId) {
            System.debug('attachByAccount; case:' + c.Subject + ' <-- entitlement:' + e.Name);
            c.EntitlementId = e.Id;
            if(c.AssetId == null && e.AssetId != null) {
              c.AssetId = e.AssetId;
            }
            break;
          }
        }
      }  // for
      System.debug('attachByAccount done');
    }
    catch (Exception e) {
      System.debug(e);
    }
  }
} // class