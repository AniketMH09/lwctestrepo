global class SuspenseAutoAssign_MMS implements Database.batchable<sObject>,Database.Stateful, Database.allowscallouts{

   global String query;
   
  public Integer intCount=0;

   global Database.Querylocator start (Database.BatchableContext SC)
   {   
       	Date yesterday = system.today().adddays(-1); 
        String strWhere ='MUST CLEAR M** BA';
        string strcodeA01='';
         strcodeA01='A01';
       string strcodeF01='';
        strcodeF01='F01';
       string strcodeF26='';
        strcodeF26='F26';
       string strcodeF27='';
        strcodeF27='F27';
       string strcodeF28='';
        strcodeF28='F28';
       
       string strcodeF29='';
        strcodeF29='F29';
       string strcodeF31='';
        strcodeF31='F31';
       string strcodeF36='';
        strcodeF36='F36';
       string strcodeDT1='';
        strcodeDT1='DT1';
       string strcodePM1='';
        strcodePM1='PM1';
       string strcodeT01='';
        strcodeT01='T01';
       string strcodeS6R='S6R';
       string strcodeS6W='S6W';
       query = 'SELECT id,TranDesc__c,Error_Description__c,Origin_Code__c FROM Suspense__c where (User__c =\'\' or User__c =null) and  CreatedDate = TODAY and Error_Description__c= :strWhere' + ' order by Origin_Code__c ';
       	return Database.getQueryLocator(query);
   }     

    global void execute(Database.BatchableContext SC,List<Suspense__c> RC) {
        
        List<Suspense__c> suspenseNos = new List<Suspense__c>();
        //String strId='';
        List<Suspense_Auto_Assign__c> suspenseAutoAssign= new List<Suspense_Auto_Assign__c>();
        suspenseAutoAssign= [Select IdNumber__c, AutoAssignUser__c from Suspense_Auto_Assign__c order by IdNumber__c];
        if (suspenseAutoAssign.size() >0)
        {
             System.Debug(' *** Size  ==> ' + suspenseAutoAssign.size() );
        
        	for(Suspense__c  susp :RC){
            	if (suspenseAutoAssign.size() <=intCount)
                	intCount=0;
            	System.Debug(' *** intCount  ==> ' + intCount );            
                System.Debug(' *** MUST CLEAR M** BA  ==> ' + suspenseAutoAssign[intCount].AutoAssignUser__c );
            	susp.User__c= suspenseAutoAssign[intCount].AutoAssignUser__c;
                suspenseNos.add(susp);
                //strId=susp.Id;
                intCount= intCount+1;
           	}
        }
        update suspenseNos;
         for(Suspense__c  susp :suspenseNos){
            SuspenseCallOut.makeHttpCallforSuspenseBatch( susp.Id );
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
            mail.setSubject('Suspense Auto Assign MMS Processed ' );
            mail.setPlainTextBody('The Batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }
        catch(System.Exception ex)
        {
   System.Debug(' *** Exception  ==> ' + ex.getMessage() ); 
        }   
   } 
}