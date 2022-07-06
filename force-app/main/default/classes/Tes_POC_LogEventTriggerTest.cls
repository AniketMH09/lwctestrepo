@isTest

public class Tes_POC_LogEventTriggerTest {

    @isTest static void testValidEvent() {
        
        Log__e logEvent = new Log__e(AffectedId__c = 'Test Fin Acct',
                                     ClassName__c = 'Test Class',
                                     Exception_Error_Message__c = 'Test Exception Error Message',
                                     ExceptionMsg__c = 'Test ExceptionMsg',
                                     RequestBody__c = 'Test RequestBody',
                                     ResponseBody__c = 'Test ResponseBody');
        
         Test.startTest();
        
        // Publish test event
        Database.SaveResult sr = EventBus.publish(logEvent);
            
        Test.stopTest();
        
        // Verify SaveResult value - isSuccess should be false
        System.assertEquals(true, sr.isSuccess());
        
        // Log the error message
        for(Database.Error err : sr.getErrors()) {
            System.debug('Error returned: ' +
                        err.getStatusCode() +
                        ' - ' +
                        err.getMessage()+' - '+err.getFields());
        }
        
    }
}