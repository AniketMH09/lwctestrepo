global class BatchProcessReminderSMS_Scheduler implements Schedulable 
{
    global integer batchSize;	
    global void execute(SchedulableContext ctx)
    {
		Map<String,Batch_Size_Settings__c> mapBatchSize = Batch_Size_Settings__c.getAll();
		batchSize = Integer.valueOf(mapBatchSize.get('BatchSizeReminderSMS').BatchSize__c);
		    	
		BatchProcessReminderSMS batchReminderSMS = new BatchProcessReminderSMS();
		
		// get a Random Id before the Job kicks in for the Batch Schedule Tracking Object 
		String randomId = Utils_Batch.genRandomId();
		
		// Insert in Batch Schedule Tracking Object
		Boolean boolInsertBatchTrack = Utils_Batch.recordBatchScheduleTracking(randomId, Utils_Batch.BATCH_IN_PROGRESS, 'Reminder SMS');

        // Execute the scheduled batch job  
        ID batchProcessId = Database.executeBatch(batchReminderSMS,batchSize);

		// Update the Batch Schedule Tracking Object
        Boolean boolUpdateBatchTrack = Utils_Batch.updateBatchScheduleTracking(Utils_Batch.BATCH_IN_PROGRESS, randomId, batchProcessId);
    }    
}