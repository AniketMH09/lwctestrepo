//
// Class Name : AHFC_CaseTriggerHelper
// Helper Class for Case Trigger
// 12 Dec, 2018    Karunakar Pulkam    Original

public with sharing class AHFC_CaseTriggerHelper{
    
    // @Param : newList, oldList, oldMap
    // Return : void
    public static void updateCommPref(List<Case>newList){
        System.debug('@@inside');
        Set<Id> FinAccountIdSet = new Set<Id>();
        Map<Id,Communication_Preferences__c> faToCommPrefMap = new Map<Id,Communication_Preferences__c>();
        Map<Id,Id> faToAccountMap = new Map<Id,Id>();
        Map<Id,Id> faToContactMap = new Map<Id,Id>();
        for(Case theCase : newList){
            if(!String.isBlank(theCase.Finance_Account__c) && theCase.RecordType.Name != 'CCPA'){
                // add Finance Account Id to Set.
                FinAccountIdSet.add(theCase.Finance_Account__c);
            }
        }
        system.debug('FinAccountIdSet=='+ FinAccountIdSet);
        //Getting respective Communication Preferences and hold in MAP
        if(FinAccountIdSet.size()>0){
            for(Communication_Preferences__c cp: [SELECT Id, Email_Address__c,Finance_Account_Number__c,Account_Status_Updates_via_Email__c,Finance_Account_Number__r.Honda_Brand__c,
                                                  Finance_Account_Number__r.Customer_Name__c,Finance_Account_Number__r.Account_Last_4__c,Finance_Account_Number__r.Maturity_Date__c,Finance_Account_Number__r.Finance_Account_Number__c
                                                  FROM Communication_Preferences__c WHERE Finance_Account_Number__c IN : FinAccountIdSet AND Account_Status_Updates_via_Email__c=True]){
                                                      
                                                      if(!String.isBlank(cp.Finance_Account_Number__c) && cp.Finance_Account_Number__c!=NULL && !String.isBlank(cp.Email_Address__c)){
                                                          faToCommPrefMap.put(cp.Finance_Account_Number__c, cp);
                                                      }
                                                  } 
        }
        system.debug('faToCommPrefMap'+ faToCommPrefMap);
        
        for(Case cs : newList){
            //system.debug('in for');
            
            if( (faToCommPrefMap.containsKey(cs.Finance_Account__c))) 
                
            {
                system.debug('in-if==');
                
                Communication_Preferences__c Cp = faToCommPrefMap.get(cs.Finance_Account__c);
                //Copy Comm Pref Email to Case.
                
                cs.Comm_Pref_Email__c = cp.Email_Address__c;
                cs.Comm_Pref_Email_Check__c = cp.Account_Status_Updates_via_Email__c;
                
                system.debug('cp.Email_Address__c=='+ cp.Email_Address__c);
                system.debug('cp.Account_Status_update=='+ cp.Account_Status_Updates_via_Email__c);
                
                // system.debug('cs.Comm_Pref_Email__c'+cs.Comm_Pref_Email__c);
            }
            
        }     
        
        
        if(FinAccountIdSet.size()>0){
            for(Finance_Account__c fa: [SELECT Id, AHFC_Last_Active_User__c, AHFC_Last_Active_User__r.Id,  
                                        AHFC_Last_Active_User__r.ContactId, AHFC_Last_Active_User__r.AccountId
                                        FROM Finance_Account__c
                                        WHERE Id IN : FinAccountIdSet]){
                                            
                                            if(!String.isBlank(fa.AHFC_Last_Active_User__r.ContactId)){
                                                faToAccountMap.put(fa.Id, fa.AHFC_Last_Active_User__r.AccountId);
                                                faToContactMap.put(fa.Id, fa.AHFC_Last_Active_User__r.ContactId);
                                                
                                            }
                                        } 
            
            
            
        }
        system.debug('faToCommPrefMap'+ faToCommPrefMap);
        
        for(Case cs : newList){
            //system.debug('in for');
            
            if( (faToContactMap.containsKey(cs.Finance_Account__c))) 
                
            {
                system.debug('in-if==');
                
                
                //Copy Account to Case.
                
                cs.AccountId = faToAccountMap.get(cs.Finance_Account__c);
                cs.ContactId = faToContactMap.get(cs.Finance_Account__c);
                
                // system.debug('cs.Comm_Pref_Email__c'+cs.Comm_Pref_Email__c);
            }
            
        }       
        
    }
    
    public static void sendCaseNotesToCass(List<Case> newList, Map<Id,Case> oldMap) {
        
        for(Case cs: newList) {
            //Check that there is a Case Type and that the Case Type is in the custom label referenced below.
            if(cs.Type!=NULL && !String.isBlank(cs.Type) && Label.AHFC_caseTypesWithCassNotes.contains(cs.Type) && cs.RecordType.Name != 'CCPA'){
                CASSCallOut.makeHttpCallforCaseNoteInt(cs.Id);
            }
        }
    }
    // @Param : 
    // Return : void
    // Developer : Edwin Antony || 12-October-2021
    public static void updateFileExpiry(List<Case> newList) {
         System.debug('Inside AHFC_CaseTriggerHelper.updateFileExpiry');        
        try{
            List<Id> caseIds = new List<Id>();
            for(Case updatedCase : newList){
                if(updatedCase.Status == 'Closed'){ // fetching closed cases
                    caseIds.add(updatedCase.Id);
                }
            }
             System.debug('AHFC_CaseTriggerHelper.updateFileExpiry, caseIds :'+caseIds);  
            List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :caseIds];
            
            List<ID> fileIDs = new List<ID>();
            List<ContentDistribution> conDistributionToBeUpdated = new List<ContentDistribution>();            
            
            for (ContentDocumentLink docLink : files) {
                fileIDs.add(docLink.ContentDocumentId);
            }
            
            List<ContentVersion> docs = [SELECT Id,ContentDocumentId, FileExtension, Title 
                                         FROM ContentVersion WHERE ContentDocumentId IN : fileIDs AND FileType != 'SNOTE']; // excluding notes from content version
            Map<ID, String> mapIdTitle = new Map<ID, String>();
            for (ContentVersion docLink : docs) {
                mapIdTitle.put(docLink.Id, docLink.Title);
            }
               System.debug('AHFC_CaseTriggerHelper.updateFileExpiry, mapIdTitle :'+mapIdTitle.keySet()); 
            List<ContentDistribution> conDist = [SELECT ContentVersionId, DistributionPublicUrl, ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId IN :mapIdTitle.keySet()];
            for (ContentDistribution cd : conDist) {
                cd.ExpiryDate = System.today();
                cd.PreferencesExpires = true;
                conDistributionToBeUpdated.add(cd);
            }
            Update conDistributionToBeUpdated;     
        }
        catch(Exception ex){
            System.debug('Exception Inside AHFC_CaseTriggerHelper.updateFileExpiry, Message:'+ ex);
        }
        
    }
    // @Param : newList
    // Return : void
    // Developer : Supriya Chakraborty || 02-September-2021
    public static void updateAccountAndContactId(List<Case>newList){
        System.debug('@@inside');
        Set<Id> FinAccountIdSet = new Set<Id>();
        Map<Id,Communication_Preferences__c> faToCommPrefMap = new Map<Id,Communication_Preferences__c>();
        Map<Id,Id> faToAccountMap = new Map<Id,Id>();
        Map<Id,Id> faToContactMap = new Map<Id,Id>();
        Map<Id,Id> caseToUserIdMap = new Map<Id,Id>();
        Map<Id,Id> faToUserIdMap = new Map<Id,Id>();
        for(Case theCase : newList){
            if(!String.isBlank(theCase.Finance_Account__c)  && theCase.RecordType.Name != 'CCPA'){
                // add Finance Account Id to Set.
                FinAccountIdSet.add(theCase.Finance_Account__c);
            }
        }
        system.debug('FinAccountIdSet=='+ FinAccountIdSet);                
        if(FinAccountIdSet.size()>0){
            for(Finance_Account__c fa: [SELECT Id, AHFC_Last_Active_User__c, AHFC_Last_Active_User__r.Id,  
                                        AHFC_Last_Active_User__r.ContactId, AHFC_Last_Active_User__r.AccountId
                                        FROM Finance_Account__c
                                        WHERE Id IN : FinAccountIdSet]){
                                            
                                            if(!String.isBlank(fa.AHFC_Last_Active_User__r.ContactId)){
                                                faToAccountMap.put(fa.Id, fa.AHFC_Last_Active_User__r.AccountId);
                                                faToContactMap.put(fa.Id, fa.AHFC_Last_Active_User__r.ContactId);
                                                faToUserIdMap.put(fa.Id,fa.AHFC_Last_Active_User__r.Id);
                                            }
                                        } 
            
            
            
        }
        system.debug('faToContactMap=='+ faToContactMap);
        system.debug('faToAccountMap=='+ faToAccountMap);
        
        for(Case cs : newList){            
            if( (faToContactMap.containsKey(cs.Finance_Account__c)))                
            {
                system.debug('in-if-acc-update=='); 
                //Copy Account to Case.
                
                cs.AccountId = faToAccountMap.get(cs.Finance_Account__c);
                cs.ContactId = faToContactMap.get(cs.Finance_Account__c);     
                //caseToUserIdMap.put(cs.Id,faToUserIdMap.get(cs.Finance_Account__c));
                
            }
            
        }
        /*List<CaseShare> caseShareList = new List<CaseShare>();
if(caseToUserIdMap.size()>0){
for (Id key : caseToUserIdMap.keySet()) {
CaseShare csShare = new CaseShare();
csShare.CaseId = key;
csShare.UserOrGroupId = caseToUserIdMap.get(key);
csShare.CaseAccessLevel = 'Read';
csShare.RowCause = Schema.CaseShare.RowCause.Manual;
caseShareList.add(csShare);
}
if(caseShareList.size()>0){
Database.SaveResult[] lsr = Database.insert(caseShareList,false);

for(Integer i=0;i<lsr.size();i++){
if (lsr.get(i).isSuccess()){
System.debug('Save Successful==');

}else if (!lsr.get(i).isSuccess()){
// DML operation failed
Database.Error error = lsr.get(i).getErrors().get(0);
String failedDML = error.getMessage();

system.debug('Save Failed=='+failedDML);
}
}


}

}*/
        
    }
    
    public static void shareCaseWithCustomer(List<Case> newList, Map<Id,Case> oldMap){
        System.debug('@@inside');
        Set<Id> FinAccountIdSet = new Set<Id>();
        
        Map<Id,Id> faToAccountMap = new Map<Id,Id>();
        Map<Id,Id> faToContactMap = new Map<Id,Id>();
        Map<Id,Id> caseToUserIdMap = new Map<Id,Id>();
        Map<Id,Id> faToUserIdMap = new Map<Id,Id>();
        for(Case theCase : newList){
            if(!String.isBlank(theCase.Finance_Account__c)  && theCase.RecordType.Name != 'CCPA'){
                // add Finance Account Id to Set.
                FinAccountIdSet.add(theCase.Finance_Account__c);
            }
        }
        system.debug('FinAccountIdSet=='+ FinAccountIdSet);                
        if(FinAccountIdSet.size()>0){
            for(Finance_Account__c fa: [SELECT Id, AHFC_Last_Active_User__c, AHFC_Last_Active_User__r.Id,  
                                        AHFC_Last_Active_User__r.ContactId, AHFC_Last_Active_User__r.AccountId
                                        FROM Finance_Account__c
                                        WHERE Id IN : FinAccountIdSet]){
                                            
                                            if(!String.isBlank(fa.AHFC_Last_Active_User__r.ContactId)){
                                                faToAccountMap.put(fa.Id, fa.AHFC_Last_Active_User__r.AccountId);
                                                faToContactMap.put(fa.Id, fa.AHFC_Last_Active_User__r.ContactId);
                                                faToUserIdMap.put(fa.Id,fa.AHFC_Last_Active_User__r.Id);
                                            }
                                        } 
            
            
            
        }
        system.debug('faToContactMap=='+ faToContactMap);
        system.debug('faToAccountMap=='+ faToAccountMap);
        
        for(Case cs : newList){            
            if( (faToContactMap.containsKey(cs.Finance_Account__c)))                
            {
                system.debug('in-if-acc-update=='); 
                caseToUserIdMap.put(cs.Id,faToUserIdMap.get(cs.Finance_Account__c));
                
            }
            
        }
        List<CaseShare> caseShareList = new List<CaseShare>();
        if(caseToUserIdMap.size()>0){
            for (Id key : caseToUserIdMap.keySet()) {
                CaseShare csShare = new CaseShare();
                csShare.CaseId = key;
                csShare.UserOrGroupId = caseToUserIdMap.get(key);
                csShare.CaseAccessLevel = 'Read';
                csShare.RowCause = Schema.CaseShare.RowCause.Manual;
                caseShareList.add(csShare);
            }
            if(caseShareList.size()>0){
                Database.SaveResult[] lsr = Database.insert(caseShareList,false);
                
                for(Integer i=0;i<lsr.size();i++){
                    if (lsr.get(i).isSuccess()){
                        System.debug('Save Successful==');
                        
                    }else if (!lsr.get(i).isSuccess()){
                        // DML operation failed
                        Database.Error error = lsr.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        
                        system.debug('Save Failed=='+failedDML);
                    }
                }
                
            }
            
        }
        
    }
    
}