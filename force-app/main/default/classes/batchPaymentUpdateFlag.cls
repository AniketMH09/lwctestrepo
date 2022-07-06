/*******************************************************************************************************
    * @author  : JAYASHREE S
    * @date    :  
    * @modified : 04 APR 2016 
    * @group    :  
    * @group-content : 
    * @description : INTEGRATION 6B, PURPOSE : UPDATE ISUPDATED_FLAG IN FINANCE ACCOUNT TO FALSE 
    * 
    *
********************************************************************************************************/

global class batchPaymentUpdateFlag implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM Finance_Account__c where IsUpdated__c = TRUE';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Finance_Account__c > finScope) {
         try {      
         List < Finance_Account__c > finAccList = new list < Finance_Account__c > ();
         
          for (Finance_Account__c finAcc: finScope) {
          finAcc.IsUpdated__c = false;
          finAccList.add(finAcc);
          }
          
          update finAccList;
             
    } Catch ( Exception e ) {
           /*******************************************************************************************************
                 EXCEPTION HANDLING  - ANY EXCEPTION WILL BE LOGGED IN ERROR LOG OBJECT    
            *******************************************************************************************************/
             
             // UTILITY CLASS TO CREATE ERROR LOG OBJECT RECORD
             UtilityClass.logError('INT 6B Finish Method', e.getmessage(), NULL ,  NULL  );
       
       }
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}