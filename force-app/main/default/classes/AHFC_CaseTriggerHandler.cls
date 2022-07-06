// (c) 2018 Appirio, Inc.
//
// AHFC_CaseTriggerHandler
// Handler for CaseTrigger
// 12 Dec, 2018   Karunakar Pulkam   Original

public with sharing class AHFC_CaseTriggerHandler{
    
    public static void onAfterInsert(List<Case> newList,Map<Id,Case> oldMap){
        AHFC_CaseTriggerHelper.sendCaseNotesToCass(newList,oldMap);
        AHFC_CaseTriggerHelper.shareCaseWithCustomer(newList,oldMap);
    }
    
    public static void onBeforeInsert(List<Case> newList,Map<Id,Case> oldMap) {
        AHFC_CaseTriggerHelper.updateCommPref(newList);
        AHFC_CaseTriggerHelper.updateAccountAndContactId(newList);
    }
    
   /*  public static void onAfterUpdate(List<Case> newList) { 
      AHFC_CaseTriggerHelper.updateFileExpiry(newList);
    }*/
}