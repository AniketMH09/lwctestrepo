/*****************************************************
Author : Sajila Kadayaprath
Description : Test class for SMSTaskHelper class
*****************************************************/

@isTest(seeAllData=true)
private class SMSTaskHelper_Test{
    static testmethod void test() {
        Boolean b=SMSTaskHelper.istriggerExecuted();
        SMSTaskHelper.setTriggerAsExecuted();
        SMSTaskHelper.setTriggerAsNotExecuted();
    }
}