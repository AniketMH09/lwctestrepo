/******************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for smsBounceBackHandlerScheduler
*******************************************************/

@isTest
private class smsBounceBackHandlerScheduler_Test{

    static testMethod void testSmsBounceScheduler() {

            Test.startTest();
                    String CRON_EXP = '0 0 0 1 1 ? 2025'; 
                    //Insert record in BatchSizeSettings  custom settings
                    Batch_Size_Settings__c batchSize = new  Batch_Size_Settings__c();
                    batchSize.Name='BatchSizeSMSBounceBack';
                    batchSize.BatchSize__c = 20;                    
                    insert batchSize;
                    
                    String jobId = System.schedule('testScheduledApex', CRON_EXP, new smsBounceBackHandlerScheduler() );

                    CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];

                    System.assertEquals(CRON_EXP, ct.CronExpression); 
                    System.assertEquals(0, ct.TimesTriggered);
                    System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));

            Test.stopTest();
    }
}