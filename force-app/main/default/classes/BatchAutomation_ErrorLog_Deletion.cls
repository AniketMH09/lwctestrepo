/*******************************************************************************************************
    * @author  : Kanagaraj S
    * @Company : LTI
    * @description : RSS 50644 Automate Deletion of Error Log Transactions
********************************************************************************************************/


global class BatchAutomation_ErrorLog_Deletion implements Database.batchable<sObject>{

   global String query;
   global Database.Querylocator start (Database.BatchableContext SC){
       integer n = 1;
       n = Integer.ValueOf(Label.ErrorLog_Deletion);   
       query = 'SELECT id from ErrorLog__c where createddate < LAST_N_DAYS:'+n;         
    return Database.getQueryLocator(query);
   }     

   global void execute(Database.BatchableContext SC,List<ErrorLog__c> errorloglst) {
       system.debug('<<>>>>'+errorloglst);
       if(errorloglst.size()>0){
           Delete errorloglst;          
           Database.emptyRecycleBin(errorloglst);
       }
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
            mail.setSubject('BatchAutomation_ErrorLog_Deletion Processed ' + a.Status);
            mail.setPlainTextBody('The Batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }
        catch(System.Exception ex)
        {
   
        }   
   }
    
}