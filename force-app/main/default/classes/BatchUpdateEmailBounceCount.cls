global class BatchUpdateEmailBounceCount implements Database.Batchable<sObject>{

       // Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
        String query;
        if(!Test.isRunningTest())
            query = ('SELECT Email,EmailBouncedDate,accountId,EmailBouncedReason,Id,IsEmailBounced FROM Contact  WHERE IsEmailBounced = true AND EmailBouncedDate != null');
        else
            query = ('SELECT Email,EmailBouncedDate,accountId,EmailBouncedReason,Id,IsEmailBounced FROM Contact  limit 1');
         return Database.getQueryLocator(query);
        }
      
      // Execute Logic
       global void execute(Database.BatchableContext BC, List<Contact> scope){
            List<Communication_Preferences__c> Updatelst = new List<Communication_Preferences__c>();
                For(Contact CEmail : scope)
                {
                   
                    List<Communication_Preferences__c> Records = [SELECT id,EmailBouncedDate__c,IsEmailBounced__c,Email_BounceBack_Count__c from Communication_Preferences__c WHERE Customer__c = :CEmail.accountid]; 
                    if(Records.size()>0) {
                    for (Communication_Preferences__c cp : Records) {
                        if(CEmail.EmailBouncedDate != null){
                    
                            If(cp.EmailBouncedDate__c == null || (cp.EmailBouncedDate__c != null && cp.EmailBouncedDate__c != CEmail.EmailBouncedDate)){
                                cp.IsEmailBounced__c = true;
                                if(cp.Email_BounceBack_Count__c == null){
                                    cp.Email_BounceBack_Count__c=0;
                                }    
                                cp.Email_BounceBack_Count__c = cp.Email_BounceBack_Count__c + 1;
                                cp.EmailBouncedDate__c = CEmail.EmailBouncedDate;
                                 UpdateLst.add(cp);
                                }
                            }
                        }
                        if(UpdateLst.size()>0){
                         Update UpdateLst;
                       } 
                    } 
                }  
       } 
     
       global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
       }
    }