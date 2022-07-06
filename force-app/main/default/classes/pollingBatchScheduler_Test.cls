/*****************************************************
Author : Sajila Kadayaprath
Description : Test class for pollingBatchScheduler Batch class
*****************************************************/

@isTest
private class pollingBatchScheduler_Test{
    //public static String CRON_EXP = '0 0 0 15 3 ? 2022';
      public Static Date dateObj = Date.today().addDays(365);
   	  public static String year = String.valueOf(dateObj.year());
   	  public static String CRON_EXP = '0 0 0 15 3 ? '+year;
    static testmethod void test() {  
       Test.startTest();
    
       // Schedule the test job
       String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new pollingBatchScheduler());
       
       Test.stopTest();
    }
}