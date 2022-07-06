/*****************************************************
Author : Sajila Kadayaprath
Description : Test class for BatchProcessReminderSMS_Scheduler Batch class
*****************************************************/

@isTest
private class BatchProcessReminderSMS_Scheduler_Test{
    //public static String CRON_EXP = '0 0 0 15 3 ? 2022';
      public Static Date dateObj = Date.today().addDays(365);
   	  public static String year = String.valueOf(dateObj.year());
   	  public static String CRON_EXP = '0 0 0 15 3 ? '+year;
    static testmethod void test() {  
    
       Batch_Size_Settings__c bs=new Batch_Size_Settings__c();
       bs.Name='BatchSizeReminderSMS';
       bs.BatchSize__c=1;
       insert bs;
       
       Test.startTest();
    
       // Schedule the test job
       String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new BatchProcessReminderSMS_Scheduler());
       
       Test.stopTest();
    }
}