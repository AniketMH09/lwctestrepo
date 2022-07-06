public class UtilitiyMethods {
    public static void createErrorlogevt(String errorMessage, String className, String finId,String requestBody,String responseBody) {
        log__e errorLog = new log__e();
        system.debug(errorMessage);
        system.debug(className);
        system.debug(finId);
        system.debug(requestBody);
        system.debug(responseBody);
        
        errorLog.ClassName__c = className;
        errorLog.Exception_Error_Message__c = errorMessage;
        errorLog.AffectedId__c = finId;
        errorLog.RequestBody__c = requestBody;
        errorLog.ResponseBody__c = responseBody;
        EventBus.publish(errorLog);
    }
    

}