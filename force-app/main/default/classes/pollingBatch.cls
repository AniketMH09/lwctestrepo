global with sharing class pollingBatch implements Database.Batchable<sObject>
{
 
	global Database.QueryLocator start(Database.BatchableContext BC)
    {
    	String query = 'Select ' + 
    					'UniqueRandomId__c, ' + 
    					'Status__c, ' + 
    					'JobId__c, ' + 
    					'Id,  ' + 
    					'Batch_Name__c ' + 
    					'From Batch_Schedule_Tracking__c ' + 
    					'where Status__c = \'INPROGRESS\' and JobId__c != \'\'';
    
    	return Database.getQueryLocator(query);	
    } 
    
    global void execute(Database.BatchableContext BC, List<Batch_Schedule_Tracking__c> bstScope)
    {
    	// Find in AsyncApexJob for the jobs that are completed in the Batch Schedule Tracking QueryLocator Scope
    	// Add the 'In Progress' JobId in the Set 
    	
    	Set<Id> inProgressId = new Set<Id>();
    	
    	for(Batch_Schedule_Tracking__c bst : bstScope)
    	{
    		inProgressId.add(bst.JobId__c);
    	}
    	
    	// Query for the Job Ids in AsyncApexJob object for their status 
		list<AsyncApexJob> asynJobStatus = new list<AsyncApexJob>();    	
		
		asynJobStatus = [Select Status, Id, JobItemsProcessed, CreatedBy.Email From AsyncApexJob where id IN :inProgressId];
		
		//Find if the Jobs that were In Progress have been completed or not
		// If the jobs are set as completed in AsyncApexJob, then these should be set status of these jobId in Batch_Schedule_Tracking__c to Complete 
		//String myStatus = 'Failed';
		Set<Id> completedJobs = new Set<Id>();
		for (AsyncApexJob a : asynJobStatus)
		{
			if(a.Status == 'Completed')
			{
				// Get the Set of Compled JobId for AsyncApexJob Object
				completedJobs.add(a.Id);
			}
			else if((a.Status == 'Failed') || (a.Status == 'Aborted'))
			{
				// Send email for the Failed OR aborted Job
				sendEmailNotification(a.Status, a.Id, '', '', 'Failed/Aborted', '', a.CreatedBy.Email);
			}
		}

		// Update the Batch_Schedule_Tracking__c with Status as Completed of the Jobs completed in AsyncApexJob
		
		list<Batch_Schedule_Tracking__c> bstList = new list<Batch_Schedule_Tracking__c>();
		bstList = [Select Status__c, JobId__c, Id from Batch_Schedule_Tracking__c where JobId__c IN :completedJobs];
		
		if (bstList.size()>0)
		{
			for(integer i=0;i<bstList.size();i++)
			{
				bstList[i].Status__c = 'COMPLETED';
			}
		}
		
		// Finally Update the Batch_Schedule_Tracking__c records
		update bstList;
    }   
    
    
    global void finish(Database.BatchableContext BC)
    {
        try
        { 
 			AsyncApexJob a = [  Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
           
           sendEmailNotification(a.Status, a.Id, string.valueof(a.TotalJobItems), string.valueof(a.NumberOfErrors), 'Batch_Schedule_Tracking__c Updated', 'finishEmail', a.CreatedBy.Email);
           
           /*
            //Send an email to the Apex job's submitter notifying of job completion.       
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();      
            //String[] toAddresses = new String[] {a.CreatedBy.Email, 'baljinder.sandhu@accenture.com'};
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
            mail.setSubject('Batch_Schedule_Tracking__c Updated ' + a.Status);
            mail.setPlainTextBody('The Batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
    		*/
    
        }
        catch (exception ex)
        {
        	
        }
    }

    public void sendEmailNotification(string jobStatus, string batchId, string totalJobItems, string totalErrors, string batchSubject, string emailType, string createdByEmail)
    {
	 	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();      
        //String[] toAddresses = new String[] {a.CreatedBy.Email, 'baljinder.sandhu@accenture.com'};
       	String emailLabel = Label.Batch_Notification_Emails;

        String[] toAddresses = new String[] {createdByEmail};
        // Comma seperated values in Label Batch_Notification_Emails
        // Add each value to the toAddresses 
		for(String s : emailLabel.split(','))
        {
           	toAddresses.add(s);
        }
            
        // setToAddresses sends email to the email addresses in toAddresses 
        mail.setToAddresses(toAddresses); 
        mail.setSubject(batchSubject + ' - ' + jobStatus);
            
        if(emailType == 'finishEmail')
        {
        	mail.setPlainTextBody('The Batch Apex job Notification ' + totalJobItems + ' batches with '+ totalErrors + ' failures.');	
        }
        else
        {
        	mail.setPlainTextBody('The Batch Apex job Notification for Failure or Aborted Job with Id' + batchId);
        }
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }


}