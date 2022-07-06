global class BatchSyncSuspense implements Database.batchable<sObject>, Database.allowscallouts{

   global String query;
   //global Map<string, String> newEmailMap = new Map<String, String>();
 

   global Database.Querylocator start (Database.BatchableContext SC)
   {   
       	Date yesterday = system.today().adddays(-1); 
       	query = 'SELECT id,AffectedId__c FROM ErrorLog__c where  LastModifiedDate = TODAY and ClassName__c=\'SuspenseCallOut\'';
       	return Database.getQueryLocator(query);
   }     

    global void execute(Database.BatchableContext SC,List<ErrorLog__c> RC) {
        
        List<ErrorLog__c> suspenseNos = new List<ErrorLog__c>();
        //map<String,ErrorLog__c> preferenceMap = new map<String,ErrorLog__c>();
        
        for(ErrorLog__c  susp :RC){
            SuspenseCallOut.makeHttpCallforSuspenseBatch( susp.AffectedId__c );
            
           // suspenseNos.add(susp);
            
        }
    }
    
     global void finish(Database.BatchableContext SC) 
   {
        try
        {
            // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
            // Query the AsyncApexJob object to retrieve the current job's information.       
            AsyncApexJob a = [  Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:SC.getJobId()];
            //Send an email to the Apex job's submitter notifying of job completion.       
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();      
            String[] toAddresses = new String[] {a.CreatedBy.Email, 'vishal_chopra@hna.honda.com'};
            
            String emailLabel = Label.Batch_Notification_Emails;

            //String[] toAddresses = new String[] {a.CreatedBy.Email};
            // Comma seperated values in Label Batch_Notification_Emails
            // Add each value to the toAddresses 
            for(String s : emailLabel.split(','))
            {
                toAddresses.add(s);
            }
            
            // setToAddresses sends email to the email addresses in toAddresses 
            mail.setToAddresses(toAddresses); 
            mail.setSubject('Suspense Sync Processed ' );
            mail.setPlainTextBody('The Batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }
        catch(System.Exception ex)
        {
   System.Debug(' *** Exception  ==> ' + ex.getMessage() ); 
        }   
   } 
}