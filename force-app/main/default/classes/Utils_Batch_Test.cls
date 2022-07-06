/*************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for Utils_Batch
*************************************************/

@isTest
public class Utils_Batch_Test{
    private static TestMethod void UtilTest(){
       
       Test.startTest();
       
       Utils_Batch u=new Utils_Batch();
       String r=Utils_Batch.genRandomId();
       Boolean b=Utils_Batch.recordBatchScheduleTracking(r,'status','testBatch');
      
       Batch_Schedule_Tracking__c bst=new Batch_Schedule_Tracking__c();
       bst.End_Date__c = system.today(); 
       bst.End_Date_Time__c = system.now();
       bst.Status__c = 'status';
       bst.JobId__c='testId';
       bst.Batch_Name__c='testn';
       bst.UniqueRandomId__c=r;
       insert bst;
       
       Boolean b1=Utils_Batch.updateBatchScheduleTracking('status',r,'testBatch');
       
       Test.stopTest();       
    }
 }