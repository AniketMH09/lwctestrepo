/*****************************************************
Author : Sajila Kadayaprath
Description : Test class for ChargentPaymentUpdateScheduler Batch class
*****************************************************/

@isTest
private class ChargentPaymentUpdateScheduler_Test{
    //public static String CRON_EXP = '0 0 0 15 3 ? 2022';
      public Static Date dateObj = Date.today().addDays(365);
   	  public static String year = String.valueOf(dateObj.year());
   	  public static String CRON_EXP = '0 0 0 15 3 ? '+year;
    static testmethod void test() {  
    
       Batch_Size_Settings__c bs=new Batch_Size_Settings__c();
       bs.Name='BatchSizeValue';
       bs.BatchSize__c=1;
       insert bs;
       
       Test.startTest();
    
       // Schedule the test job
       String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new ChargentPaymentUpdateScheduler());
       
       Test.stopTest();
    }
}