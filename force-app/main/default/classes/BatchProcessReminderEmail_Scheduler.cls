global class BatchProcessReminderEmail_Scheduler implements Schedulable 
{
    global integer batchSize;	
    global void execute(SchedulableContext ctx)
    {
		Map<String,Batch_Size_Settings__c> mapBatchSize = Batch_Size_Settings__c.getAll();
		batchSize = Integer.valueOf(mapBatchSize.get('BatchSizeReminderEmail').BatchSize__c);
		    	
		BatchProcessReminderEmail batchReminderEmail = new BatchProcessReminderEmail();
		
		// get a Random Id before the Job kicks in for the Batch Schedule Tracking Object 
		String randomId = Utils_Batch.genRandomId();
		
		// Insert in Batch Schedule Tracking Object
		Boolean boolInsertBatchTrack = Utils_Batch.recordBatchScheduleTracking(randomId, Utils_Batch.BATCH_IN_PROGRESS, 'Reminder Email');
		
        // execute the scheduled batch job  
        ID batchProcessId = Database.executeBatch(batchReminderEmail,batchSize);
        
		// Update the Batch Schedule Tracking Object
        Boolean boolUpdateBatchTrack = Utils_Batch.updateBatchScheduleTracking(Utils_Batch.BATCH_IN_PROGRESS, randomId, batchProcessId);        
    }
}