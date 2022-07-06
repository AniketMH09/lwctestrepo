/*
   Class used to keep sync of email address between Finance Account's communication peference and Case
   before sending email to customer
*/

public class AHFC_UpdateEmailFieldOnCase {
    
    @InvocableMethod
    public static void updateEmailOnCase(List<Id> CaseId) {
        
        Communication_Preferences__c cp;
        String FinAccountId = '';
        Case currentCase = [Select Id, Finance_Account__c, Comm_Pref_Email__c,case_reason__c, Comm_Pref_Email_Check__c,retry__c, Send_DDC_Email__c from Case where Id  =:CaseId[0]];
        
        if(!String.isBlank(currentCase.Finance_Account__c)){
            FinAccountId = currentCase.Finance_Account__c;
        }
        
        //Getting respective Communication Preferences and hold in MAP
        if(FinAccountId != ''){
            cp = [ SELECT Id, Email_Address__c,Finance_Account_Number__c,Account_Status_Updates_via_Email__c
                                                 FROM Communication_Preferences__c 
                                                WHERE Finance_Account_Number__c  =: FinAccountId LIMIT 1 ];
        }
        // update case with latest email information from finance account
        
            if(cp != null)  {
                Case cs = new Case(Id = currentCase.Id,retry__c = currentCase.retry__c,case_reason__c = currentCase.case_reason__c);
                //Copy Comm Pref Email to Case
                cs.Comm_Pref_Email__c = cp.Email_Address__c;
                cs.Comm_Pref_Email_Check__c = cp.Account_Status_Updates_via_Email__c;
                if(cs.retry__c != null && cs.case_reason__c != 'Denied'){
                    cs.retry__c = cs.retry__c  + 1;
                }
                try {
                    update cs;
                    
                }Catch(Exception e) {
                   ErrorLog__c errlog = new ErrorLog__c();
                   errlog.ExceptionErrorMessage__c= e.getMessage();
                   insert errlog;
                }
                  
            }
    }
}