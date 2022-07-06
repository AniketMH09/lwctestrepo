/*****************************************************
Author : Sajila Kadayaprath
Description : Test class for pollingBatch Batch class
*****************************************************/

@isTest
private class pollingBatch_Test{
    static testmethod void test() {  
    
       Batch_Schedule_Tracking__c b=new Batch_Schedule_Tracking__c();
       b.Status__c='INPROGRESS';
       b.Batch_Name__c='TestJob';
       insert b;

       Test.startTest();
       
       pollingBatch p=new pollingBatch();
       String jobID = System.scheduleBatch(p, 'job example', 1);
       
       b.JobId__c=jobID;
       update b;
       
       Database.executeBatch(p);
 
       Test.stopTest();
    }
}