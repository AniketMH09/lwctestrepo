global class BatchUpdateCommunicationpreference implements Database.Batchable<sObject>,Database.stateful{

    global Database.QueryLocator start(Database.BatchableContext BC) {
    
    String query = '';
    
    //Sajila-Adding Condition check to fetch records in test class without isEmailBounced condition
    if(Test.isRunningTest())
        query = 'SELECT id,Customer__c,Finance_Account__c FROM Customer_Finance_Account__c WHERE Customer__c IN (SELECT AccountId FROM Contact)';
    else        
         query = 'SELECT id,Customer__c,Finance_Account__c FROM Customer_Finance_Account__c WHERE Customer__c IN (SELECT AccountId FROM Contact where IsEmailBounced=true  and EmailBouncedDate = Today)';
        //String query = 'SELECT id,IsEmailBounced__c,Email_BounceBack_Count__c from Communication_Preferences__c where Customer__c in (Select AccountId FROM Contact where IsEmailBounced=true and EmailBouncedDate = Today))';
    return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Customer_Finance_Account__c> finacc) {
       system.debug('hhhhhh'+finacc);
        List<Communication_Preferences__c> Updatelst = new List<Communication_Preferences__c>();
        Set<id> Finaccid = new Set<id>();
   
        For(Customer_Finance_Account__c finacct : finacc)
        {
         Finaccid.add(finacct.Finance_Account__c);
        }
        
        List<Communication_Preferences__c> Records = [SELECT id,IsEmailBounced__c,Email_BounceBack_Count__c from Communication_Preferences__c WHERE Finance_Account_Number__c IN :Finaccid];
        If(Records.size() > 0) 
        {
         For(Communication_Preferences__c  cp : Records)
          {
            cp.IsEmailBounced__c = true;
            cp.Email_BounceBack_Count__c = cp.Email_BounceBack_Count__c + 1;
            UpdateLst.add(cp);
          }       
        }
        
         if(UpdateLst.size()>0){
          Update UpdateLst;
         } 
    }   
    
    global void finish(Database.BatchableContext BC) {
        
        }         
}