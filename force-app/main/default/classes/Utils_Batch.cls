public class Utils_Batch 
{
	public static final String BATCH_IN_PROGRESS = 'INPROGRESS';
	public static final String BATCH_COMPLETED = 'COMPLETED';

	public static String genRandomId()
	{
		Blob blobKey = crypto.generateAesKey(128);
		String key = EncodingUtil.convertToHex(blobKey);
		String randID = key.substring(0,18);
	
		return randID;
	}
	
	public static boolean recordBatchScheduleTracking(string randomId, String status, String BatchName)
	{
	    Batch_Schedule_Tracking__c newBtchSchTracking = new Batch_Schedule_Tracking__c();
		newBtchSchTracking.Batch_Name__c = BatchName;
		newBtchSchTracking.Start_Date__c = system.today();
		newBtchSchTracking.Start_Date_Time__c = system.now();
		newBtchSchTracking.Status__c = status;
		newBtchSchTracking.UniqueRandomId__c = randomId;

		try
		{
			insert newBtchSchTracking;
			return true;	
		}
		catch (Exception e)
		{
			return false;	
		}
	}
	
	public static boolean updateBatchScheduleTracking(string status, string randomId, string batchProcessId)
	{
		boolean updateStatus = false;
	    // Update record in Batch_Schedule_Tracking__c to status as Completed 
    	list<Batch_Schedule_Tracking__c> batchScheduleTrackRecord = new list<Batch_Schedule_Tracking__c>();
    	batchScheduleTrackRecord = [Select Id, JobId__c, End_Date__c, End_Date_Time__c, Status__c from Batch_Schedule_Tracking__c where UniqueRandomId__c = :randomId];
    	  
    	if (batchScheduleTrackRecord.size()>0)
    	{
    		batchScheduleTrackRecord[0].End_Date__c = system.today();
    		batchScheduleTrackRecord[0].End_Date_Time__c = system.now();
    		batchScheduleTrackRecord[0].Status__c = status;
    		batchScheduleTrackRecord[0].JobId__c = batchProcessId;
    		
    		try
    		{
    			update batchScheduleTrackRecord;
    			updateStatus = true;	
    		}
    		catch (Exception e)
    		{
    			updateStatus = false;
    		}
    	}
    	
    	return updateStatus;
	}
    
}