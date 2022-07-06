/*******************************************************************************************************
    * @author  : Kanagaraj S
    * @Company : LTI
    * @description : RSS-48128 automation to move stopped EZP.
********************************************************************************************************/


global class BatchAutomationProcessforEasypay implements Database.batchable<sObject>{

   global String query;
   

   global Database.Querylocator start (Database.BatchableContext SC){
       integer beforeDays;
       EasyPay_Automation__mdt MaturityAutomation = [SELECT Days_of_maturity__c FROM EasyPay_Automation__mdt limit 1];
       beforeDays = Integer.ValueOf(MaturityAutomation.Days_of_maturity__c); 
       Date beforeMaturitydays = system.today().adddays(-beforeDays); 
        system.debug('<<<beforeMaturitydays>>>>'+beforeMaturitydays);    
        query = 'SELECT id,ChargentOrders__Payment_Status__c,Payment_Display_Status__c,Finance_Account_Number__r.Maturity_Date__c,Finance_Account_Number__r.Finance_Account_Number__c, Finance_Account_Number__c FROM ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.Maturity_Date__c <=:beforeMaturitydays and Finance_Account_Number__r.Account_Type__c =\'Lease\''+' and ChargentOrders__Payment_Status__c = \'Stopped\''+' and RecordTypeId in (SELECT Id FROM RecordType WHERE Name = \'Recurring Payment\''+')';
            
    return Database.getQueryLocator(query);
   }     

   global void execute(Database.BatchableContext SC,List<ChargentOrders__ChargentOrder__c> paymentLst) {
   
        List<String> accNos = new List<String>();
        List<ChargentOrders__ChargentOrder__c> chargntLst = new List<ChargentOrders__ChargentOrder__c>();
       for(ChargentOrders__ChargentOrder__c chargntord : paymentLst){
            chargntord.ChargentOrders__Payment_Status__c = 'Complete';
            chargntord.Payment_Display_Status__c = 'Complete';
            chargntord.Duplicate_Key_Tracker__c = chargntord.Finance_Account_Number__r.Finance_Account_Number__c + 'Recurring_Payment' + 'INACTIVE' + Datetime.now();
               chargntLst.add(chargntord);
       }       
       update chargntLst;   
       system.debug('chargntLst: '+chargntLst);
    }
    
   global void finish(Database.BatchableContext SC){
        try
        {
            // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
            // Query the AsyncApexJob object to retrieve the current job's information.       
            AsyncApexJob a = [  Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:SC.getJobId()];
            //Send an email to the Apex job's submitter notifying of job completion.       
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();      
            
            
            String emailLabel = Label.Batch_Notification_Emails;

            String[] toAddresses = new String[] {a.CreatedBy.Email};
            // Comma seperated values in Label Batch_Notification_Emails
            // Add each value to the toAddresses 
            for(String s : emailLabel.split(','))
            {
                toAddresses.add(s);
            }
            
            // setToAddresses sends email to the email addresses in toAddresses 
            mail.setToAddresses(toAddresses); 
            mail.setSubject('BatchAutomationProcessforEasypay Processed ' + a.Status);
            mail.setPlainTextBody('The Batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }
        catch(System.Exception ex)
        { throw ex; }   
   }
    
}