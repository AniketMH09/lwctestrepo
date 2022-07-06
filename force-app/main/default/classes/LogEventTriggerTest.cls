@isTest
public class LogEventTriggerTest {

    @isTest static void testValidEvent() {
        
        // Create a test event instance
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
                
        // Perform validations here
        
        // Verify SaveResult value
        System.assertEquals(true, sr.isSuccess());
        
        // Verify that a ErrorLog__c was created by a trigger.
        List<ErrorLog__c> lstErrObj = [SELECT Id FROM ErrorLog__c];
        // Validate that this case was found
        System.assertEquals(1, lstErrObj.size());
    }
    
    
}