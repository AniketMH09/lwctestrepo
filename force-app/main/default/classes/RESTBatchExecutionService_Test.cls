/******************************************************************
* Class Name                     :               RESTBatchExecutionService_Test
* Description                    :               Test class for RESTBatchExecutionService
* RSS #                          :               
****************************************************************/

@isTest
public class RESTBatchExecutionService_Test {
    
/******************************************************************
*  Test Method Name         : executeBatch_Test1
*  Developer                : Srividya
*  RSS #                    :               
*  Description              : Test method for executeBatch()
*             ******************************************************************/
    static testmethod void executeBatch_Test1(){
        List<RESTBatchExecutionService.RequestWrapper> wrapperList = new List<RESTBatchExecutionService.RequestWrapper>();
        
        RESTBatchExecutionService.RequestWrapper wrapper1 = new RESTBatchExecutionService.RequestWrapper();
        wrapper1.jobName = 'batchChargentPaymentUpdate';
        wrapper1.requestId = '123124124';
        wrapper1.runDate = system.today();
        wrapperList.add(wrapper1);    
        
        RESTBatchExecutionService.RequestWrapper wrapper2 = new RESTBatchExecutionService.RequestWrapper();
        wrapper2.jobName = 'BatchProcessReminderEmail';
        wrapper2.requestId = '123124134';
        wrapper2.runDate = system.today();
        wrapperList.add(wrapper2);
        
        RESTBatchExecutionService.RequestWrapper wrapper3 = new RESTBatchExecutionService.RequestWrapper();
        wrapper3.jobName = 'BatchProcessReminderSMS';
        wrapper3.requestId = '1231241798';
        wrapper3.runDate = system.today();
        wrapperList.add(wrapper3);
        
        RESTBatchExecutionService.RequestWrapper wrapper4 = new RESTBatchExecutionService.RequestWrapper();
        wrapper4.jobName = 'smsBounceBackHandler';
        wrapper4.requestId = '123124124';
        wrapper4.runDate = system.today();
        wrapperList.add(wrapper4);
        
        RESTBatchExecutionService.RequestWrapper wrapper5 = new RESTBatchExecutionService.RequestWrapper();
        wrapper5.jobName = 'batchPaymentUpdateFlag';
        wrapper5.requestId = '123124124';
        wrapper5.runDate = system.today();
        wrapperList.add(wrapper5);
        
        RESTBatchExecutionService.RequestWrapper wrapper6 = new RESTBatchExecutionService.RequestWrapper();
        wrapper6.jobName = 'batchUpdateNWD';
       wrapper6.requestId = '123124124';
        wrapper6.runDate = system.today();
        wrapperList.add(wrapper6);
        
        RESTBatchExecutionService.RequestWrapper wrapper7 = new RESTBatchExecutionService.RequestWrapper();
        wrapper7.jobName = 'BatchRetryDDCCall';
        wrapper7.requestId = '123124124';
        wrapper7.runDate = system.today();
        wrapperList.add(wrapper7);
        
        RESTBatchExecutionService.RequestWrapper wrapper8 = new RESTBatchExecutionService.RequestWrapper();
        wrapper8.jobName = 'BatchRetryLECall';
        wrapper8.requestId = '123124124';
        wrapper8.runDate = system.today();
        wrapperList.add(wrapper8);
        
        RESTBatchExecutionService.RequestWrapper wrapper9 = new RESTBatchExecutionService.RequestWrapper();
        wrapper9.jobName = 'BatchSyncSuspense';
        wrapper9.requestId = '123124124';
        wrapper9.runDate = system.today();
        wrapperList.add(wrapper9);
        
        RESTBatchExecutionService.RequestWrapper wrapper10 = new RESTBatchExecutionService.RequestWrapper();
        wrapper10.jobName = 'BatchAutomationProcessforEasypay';
        wrapper10.requestId = '123124124';
        wrapper10.runDate = system.today();
        wrapperList.add(wrapper10);
        
        RESTBatchExecutionService.RequestWrapper wrapper11 = new RESTBatchExecutionService.RequestWrapper();
        wrapper11.jobName = 'SuspenseAutoAssign_NonHondaPayoff';
        wrapper11.requestId = '123124124';
        wrapper11.runDate = system.today();
        wrapperList.add(wrapper11);
        
        RESTBatchExecutionService.RequestWrapper wrapper12 = new RESTBatchExecutionService.RequestWrapper();
        wrapper12.jobName = 'SuspenseAutoAssign_StopPayment';
        wrapper12.requestId = '123124124';
        wrapper12.runDate = system.today();
        wrapperList.add(wrapper12);
        
        RESTBatchExecutionService.RequestWrapper wrapper13 = new RESTBatchExecutionService.RequestWrapper();
        wrapper13.jobName = 'SuspenseAutoAssign_MMS';
        wrapper13.requestId = '123124124';
        wrapper13.runDate = system.today();
        wrapperList.add(wrapper13);
        
        RESTBatchExecutionService.RequestWrapper wrapper14 = new RESTBatchExecutionService.RequestWrapper();
        wrapper14.jobName = 'SuspenseAutoAssign_OriginCodes';
        wrapper14.requestId = '123124124';
        wrapper14.runDate = system.today();
        wrapperList.add(wrapper14);
        
        RESTBatchExecutionService.RequestWrapper wrapper15 = new RESTBatchExecutionService.RequestWrapper();
        wrapper15.jobName = 'BatchAutomation_ErrorLog_Deletion';
        wrapper15.requestId = '123124124';
        wrapper15.runDate = system.today();
        wrapperList.add(wrapper15);
        
        RESTBatchExecutionService.RequestWrapper wrapper16 = new RESTBatchExecutionService.RequestWrapper();
        wrapper16.jobName = 'BatchProcessCASSCalloutErrorlog';
        wrapper16.requestId = '123124124';
        wrapper16.runDate = system.today();
        wrapperList.add(wrapper16);
        
        RESTBatchExecutionService.RequestWrapper wrapper17 = new RESTBatchExecutionService.RequestWrapper();
        wrapper17.jobName = 'BatchProcess_Dailymonitoring';
        wrapper17.requestId = '123124124';
        wrapper17.runDate = system.today();
        wrapperList.add(wrapper17);
        
        RESTBatchExecutionService.RequestWrapper wrapper18 = new RESTBatchExecutionService.RequestWrapper();
        wrapper18.jobName = 'AdhocNotifiUnsubscribeBatch';
        wrapper18.requestId = '123124124';
        wrapper18.runDate = system.today();
        wrapperList.add(wrapper18);
        
        List<Zena_Job_Mapping__c> zenaJobMappingsList = new List<Zena_Job_Mapping__c>();
        Map<String, Zena_Job_Mapping__c> jobmappings = new Map<String, Zena_Job_Mapping__c>();
        
        Zena_Job_Mapping__c custSettRec1 = new Zena_Job_Mapping__c();
        custSettRec1.clsName__c = 'batchChargentPaymentUpdate';
        custSettRec1.batchSize__c=20;
        custSettRec1.Name='batchChargentPaymentUpdate';
        zenaJobMappingsList.add(custSettRec1);
        
        Zena_Job_Mapping__c custSettRec2 = new Zena_Job_Mapping__c();
        custSettRec2.clsName__c = 'BatchProcessReminderEmail';
        custSettRec2.batchSize__c=20;
        custSettRec2.Name='BatchProcessReminderEmail';
        zenaJobMappingsList.add(custSettRec2);
        
        Zena_Job_Mapping__c custSettRec3 = new Zena_Job_Mapping__c();
        custSettRec3.clsName__c = 'BatchProcessReminderSMS';
        custSettRec3.batchSize__c=20;
        custSettRec3.Name='BatchProcessReminderSMS';
        zenaJobMappingsList.add(custSettRec3);
        
        Zena_Job_Mapping__c custSettRec4 = new Zena_Job_Mapping__c();
        custSettRec4.clsName__c = 'smsBounceBackHandler';
        custSettRec4.batchSize__c=20;
        custSettRec4.Name='smsBounceBackHandler';
        zenaJobMappingsList.add(custSettRec4);
        
        Zena_Job_Mapping__c custSettRec5 = new Zena_Job_Mapping__c();
        custSettRec5.clsName__c = 'batchPaymentUpdateFlag';
        custSettRec5.batchSize__c=20;
        custSettRec5.Name='batchPaymentUpdateFlag';
        zenaJobMappingsList.add(custSettRec5);
        
        Zena_Job_Mapping__c custSettRec6 = new Zena_Job_Mapping__c();
        custSettRec6.clsName__c = 'batchUpdateNWD';
        custSettRec6.batchSize__c=20;
        custSettRec6.Name='batchUpdateNWD';
        zenaJobMappingsList.add(custSettRec6);
        
        Zena_Job_Mapping__c custSettRec7 = new Zena_Job_Mapping__c();
        custSettRec7.clsName__c = 'BatchRetryDDCCall';
        custSettRec7.batchSize__c=20;
        custSettRec7.Name='BatchRetryDDCCall';
        zenaJobMappingsList.add(custSettRec7);
        
        Zena_Job_Mapping__c custSettRec8 = new Zena_Job_Mapping__c();
        custSettRec8.clsName__c = 'BatchRetryLECall';
        custSettRec8.batchSize__c=20;
        custSettRec8.Name='BatchRetryLECall';
        zenaJobMappingsList.add(custSettRec8);
        
        Zena_Job_Mapping__c custSettRec9 = new Zena_Job_Mapping__c();
        custSettRec9.clsName__c = 'BatchSyncSuspense';
       custSettRec9.batchSize__c=20;
        custSettRec9.Name='BatchSyncSuspense';
        zenaJobMappingsList.add(custSettRec9);
        
        Zena_Job_Mapping__c custSettRec10 = new Zena_Job_Mapping__c();
        custSettRec10.clsName__c = 'BatchAutomationProcessforEasypay';
        custSettRec10.batchSize__c=20;
        custSettRec10.Name='BatchAutomationProcessforEasypay';
        zenaJobMappingsList.add(custSettRec10);
        
        Zena_Job_Mapping__c custSettRec11 = new Zena_Job_Mapping__c();
        custSettRec11.clsName__c = 'SuspenseAutoAssign_NonHondaPayoff';
        custSettRec11.batchSize__c=20;
        custSettRec11.Name='SuspenseAutoAssign_NonHondaPayoff';
        zenaJobMappingsList.add(custSettRec11);
        
        Zena_Job_Mapping__c custSettRec12 = new Zena_Job_Mapping__c();
        custSettRec12.clsName__c = 'SuspenseAutoAssign_StopPayment';
        custSettRec12.batchSize__c=20;
        custSettRec12.Name='SuspenseAutoAssign_StopPayment';
        zenaJobMappingsList.add(custSettRec12);
        
        Zena_Job_Mapping__c custSettRec13 = new Zena_Job_Mapping__c();
        custSettRec13.clsName__c = 'SuspenseAutoAssign_MMS';
        custSettRec13.batchSize__c=20;
        custSettRec13.Name='SuspenseAutoAssign_MMS';
        zenaJobMappingsList.add(custSettRec13);
        
        Zena_Job_Mapping__c custSettRec14 = new Zena_Job_Mapping__c();
        custSettRec14.clsName__c = 'SuspenseAutoAssign_OriginCodes';
        custSettRec14.batchSize__c=20;
        custSettRec14.Name='SuspenseAutoAssign_OriginCodes';
        zenaJobMappingsList.add(custSettRec14);
        
        Zena_Job_Mapping__c custSettRec15 = new Zena_Job_Mapping__c();
        custSettRec15.clsName__c = 'BatchAutomation_ErrorLog_Deletion';
        custSettRec15.batchSize__c=20;
        custSettRec15.Name='BatchAutomation_ErrorLog_Deletion';
        zenaJobMappingsList.add(custSettRec15);
        
        Zena_Job_Mapping__c custSettRec16 = new Zena_Job_Mapping__c();
        custSettRec16.clsName__c = 'BatchProcessCASSCalloutErrorlog';
        custSettRec16.batchSize__c=20;
        custSettRec16.Name='BatchProcessCASSCalloutErrorlog';
        zenaJobMappingsList.add(custSettRec16);
        
        Zena_Job_Mapping__c custSettRec17 = new Zena_Job_Mapping__c();
        custSettRec17.clsName__c = 'BatchProcess_Dailymonitoring';
        custSettRec17.batchSize__c=20;
        custSettRec17.Name='BatchProcess_Dailymonitoring';
        zenaJobMappingsList.add(custSettRec17);
        
        Zena_Job_Mapping__c custSettRec18 = new Zena_Job_Mapping__c();
        custSettRec18.clsName__c = 'AdhocNotifiUnsubscribeBatch';
        custSettRec18.batchSize__c=200;
        custSettRec18.Name='AdhocNotifiUnsubscribeBatch';
        zenaJobMappingsList.add(custSettRec18);
        
        insert zenaJobMappingsList;
        
        for(Zena_Job_Mapping__c zenaMapp : zenaJobMappingsList){
            jobmappings.put(zenaMapp.Name, zenaMapp);
        }
        
        Test.startTest();
        for(RESTBatchExecutionService.RequestWrapper wrap : wrapperList){
            RESTBatchExecutionService.executeBatch(wrap);
        }
        Test.stopTest();        
    }
    
/******************************************************************
* Test Method Name         : executeBatch_NegTest
* Developer                : Srividya
* RSS #    				   :               
* Description			   : Negative test method for executeBatch()
* ******************************************************************/
    static testmethod void executeBatch_NegTest(){
        Test.startTest();
        RESTBatchExecutionService.RequestWrapper wrapper = new RESTBatchExecutionService.RequestWrapper();
        RESTBatchExecutionService.executeBatch(wrapper);
        Test.stopTest();        
    }
}