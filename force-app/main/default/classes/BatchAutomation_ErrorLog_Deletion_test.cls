@isTest
public class BatchAutomation_ErrorLog_Deletion_test {
	static testMethod void retryCallouttest(){
        list<ErrorLog__c> errorlst = new list<ErrorLog__c>();
        try{
            ErrorLog__c errorLog = new ErrorLog__c();
            errorLog.ClassName__c = 'CASSCallOut';
           	errorLog.ExceptionMsg__c = 'Exception';
            errorlst.add(errorLog);
            ErrorLog__c errorLog1 = new ErrorLog__c();
            errorLog1.ClassName__c = 'CASSCallOut';
            errorLog1.ExceptionMsg__c = 'Exception';
         	errorlst.add(errorLog1);
            insert errorlst;
        }catch(exception e){}
        Test.startTest();
        BatchAutomation_ErrorLog_Deletion batchretry = new BatchAutomation_ErrorLog_Deletion(); 
        database.executebatch(batchretry,2);
        batchretry.execute(null, errorlst);
        batchretry.finish(null);
         Test.stopTest();
    }
}