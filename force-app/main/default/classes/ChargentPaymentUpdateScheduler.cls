global class ChargentPaymentUpdateScheduler Implements Schedulable  
{
    global integer batchSize;
        
    global void execute(SchedulableContext ctx)
    { 
        //list<Batch_Size_Settings__c> CSBatchList = Batch_Size_Settings__c.getAll().values();
        //batchSize = Integer.valueOf(CSBatchList[0].BatchSize__c);
        
        Map<String,Batch_Size_Settings__c> mapBatchSize = Batch_Size_Settings__c.getAll();
        batchSize = Integer.valueOf(mapBatchSize.get('BatchSizeValue').BatchSize__c);
        
        batchChargentPaymentUpdate batchPaymentUpdate = new batchChargentPaymentUpdate();
        System.debug('$$$ Batch Size: ' + batchSize);

      /*  
        if ( batchSize == 0 || batchSize > 200)
        {
            // Set batch to default of 200
            batchSize = 200;
        }
       */             
       
        // get a Random Id before the Job kicks in for the Batch Schedule Tracking Object 
        String randomId = Utils_Batch.genRandomId();
        
        // Insert in Batch Schedule Tracking Object
        Boolean boolInsertBatchTrack = Utils_Batch.recordBatchScheduleTracking(randomId, Utils_Batch.BATCH_IN_PROGRESS, 'Chargent Payment Update');

        System.debug('$$$ Batch Started... ' + randomId);               
        // execute the scheduled batch job  
        ID batchProcessId = Database.executeBatch(batchPaymentUpdate,batchSize);
        
        // Update the Batch Schedule Tracking Object
        Boolean boolUpdateBatchTrack = Utils_Batch.updateBatchScheduleTracking(Utils_Batch.BATCH_IN_PROGRESS, randomId, batchProcessId);
        
        System.debug('$$$ Batch Completed... ');
    }
}