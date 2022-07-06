global class pollingBatchScheduler Implements Schedulable  
{
    global void execute(SchedulableContext ctx)
    { 
    	pollingBatch polledBatch = new pollingBatch();
    	
    	// execute the scheduled batch job  
        ID batchProcessId = Database.executeBatch(polledBatch,200);
    }
}