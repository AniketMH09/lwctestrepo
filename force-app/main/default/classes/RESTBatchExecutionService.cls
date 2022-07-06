@RestResource(urlMapping = '/executebatch/*')
global class RESTBatchExecutionService {

    // REQUEST PARAMETERS   
    global class RequestWrapper {
        public String requestId;
        public String jobName;
        public Date runDate;
    }
    // RESPONSE PARAMETERS 
    global class ResponseWrapper {
        public String requestId;
        public String jobName;
        public Date runDate;
        public String jobId;
        public String status;
        public String errormsg;
    }
    
    @HttpPost
    global static ResponseWrapper executeBatch(RequestWrapper body) {
        
        Map< String, Zena_Job_Mapping__c > jobmappings = Zena_Job_Mapping__c.getAll();
                
        if(body.jobName != null && jobmappings != null && jobmappings.get(body.jobName).clsName__c != null) {
            
            try {
                // Retrieve apex batch classname against the job name for execution
                String clsName = jobmappings.get(body.jobName).clsName__c;
                Integer batchSize = Integer.valueOf(jobmappings.get(body.jobName).batchSize__c);
                
                // execute apex batch job
                ID id = runApexJob(clsName, batchSize);
                
                // Send REST response based on job execution status
                if(id != null)
                    return createResponse(body, BatchStatus.SUCCESS.name(), 'Success', id);
                else
                    return createResponse(body, BatchStatus.FAILURE.name(), 'Error occurred when instantiating the apex batch');
            }
            catch(Exception e)
            {
                RestRequest req = RestContext.request;
                UtilityClass.logErrorResp('RESTBatchExecutionService', e.getMessage(), body.requestId, body.toString(), BatchStatus.FAILURE.name());
                return createResponse(body, BatchStatus.FAILURE.name(), e.getMessage()); 
            }
            
        }
        // return failure response if job name cannot be found in Zena Job Mapping or the job name is not passed in Request
        else
        {
            UtilityClass.logErrorResp('RESTBatchExecutionService', 'Apex job could not be found', body.requestId, body.toString(), 'null');
            return createResponse(body, BatchStatus.FAILURE.name(), 'Apex job could not be found');
        }
        
        return null;
    }
    
    // Use the method to create REST response for Failures
    private static ResponseWrapper createResponse(RequestWrapper body, String status, String errMsg) {
        
        ResponseWrapper response = new ResponseWrapper();
        response.jobName = body.jobName;
        response.runDate = body.runDate;
        response.requestId = body.requestId;
        response.status = status;
        response.errormsg = errMsg;
        return response;
    }
    
    // Use the method to create REST response for Success with Job ID
    private static ResponseWrapper createResponse(RequestWrapper body, String status, String errMsg, ID jobId) {
        
        ResponseWrapper response = new ResponseWrapper();
        response.requestId = body.requestId;
        response.jobName = body.jobName;
        response.runDate = body.runDate;
        response.status = status;
        response.errormsg = errMsg;
        if(jobId != null)
            response.jobId = jobId;
        else
            response.jobId = '';
        
        return response;
    }
    
    // Instantiate the apex batch class based on the String Class name and executes the class

    private static ID runApexJob(String clsName, Integer scope) {
        ID id;
        Type t = Type.forName(clsName);
        Object obj = t.newInstance();
        
        if(obj instanceof batchChargentPaymentUpdate) {
            id = Database.executeBatch((batchChargentPaymentUpdate)obj, scope);
        }
        else if(obj instanceof BatchProcessReminderEmail) {
            id = Database.executeBatch((BatchProcessReminderEmail)obj, scope);            
        }
        else if(obj instanceof BatchProcessReminderSMS) {
            id = Database.executeBatch((BatchProcessReminderSMS)obj, scope);
        }
        else if(obj instanceof smsBounceBackHandler) {
            id = Database.executeBatch((smsBounceBackHandler)obj, scope);
        }
        else if(obj instanceof batchPaymentUpdateFlag) { // RSS 41357
            id = Database.executeBatch((batchPaymentUpdateFlag)obj, scope);
        }
        else if(obj instanceof batchUpdateNWD) { // RSS 49551 
            id = Database.executeBatch((batchUpdateNWD)obj, scope);
        }
         else if(obj instanceof BatchRetryDDCCall) { // RSS 49814 
            system.debug(obj);
            id = Database.executeBatch((BatchRetryDDCCall)obj, scope);
        }else if(obj instanceof BatchRetryLECall) { // RSS Need to update - sk 
            system.debug(obj);
            id = Database.executeBatch((BatchRetryLECall)obj, scope);
        }else if(obj instanceof BatchSyncSuspense) { // RSS 47534
            id = Database.executeBatch((BatchSyncSuspense)obj, scope);
        }
        else if(obj instanceof BatchAutomationProcessforEasypay) { // RSS 48128
            id = Database.executeBatch((BatchAutomationProcessforEasypay)obj, scope);
        }
  	  else if(obj instanceof SuspenseAutoAssign_NonHondaPayoff) { // RSS 40541
            id = Database.executeBatch((SuspenseAutoAssign_NonHondaPayoff)obj, scope);
        }
        else if(obj instanceof SuspenseAutoAssign_StopPayment) { // RSS 40541
            id = Database.executeBatch((SuspenseAutoAssign_StopPayment)obj, scope);
        }
        else if(obj instanceof SuspenseAutoAssign_MMS) { // RSS 40541
            id = Database.executeBatch((SuspenseAutoAssign_MMS)obj, scope);
        }
        else if(obj instanceof SuspenseAutoAssign_OriginCodes) { // RSS 40541
            id = Database.executeBatch((SuspenseAutoAssign_OriginCodes)obj, scope);
        }
        else if(obj instanceof BatchAutomation_ErrorLog_Deletion) { // RSS 50644
            id = Database.executeBatch((BatchAutomation_ErrorLog_Deletion)obj, scope);
        }
        else if(obj instanceof BatchProcessCASSCalloutErrorlog) { // RSS 46325
            id = Database.executeBatch((BatchProcessCASSCalloutErrorlog)obj, scope);
        }
        else if(obj instanceof BatchProcess_Dailymonitoring) { // RSS 51631
            id = Database.executeBatch((BatchProcess_Dailymonitoring)obj, scope);
        }
        else if(obj instanceof AdhocNotifiUnsubscribeBatch) { // RSS 53698 by Needa
            id = Database.executeBatch((AdhocNotifiUnsubscribeBatch)obj, scope);
        }
        return id;
    }
    
    private enum BatchStatus { SUCCESS, FAILURE }
}