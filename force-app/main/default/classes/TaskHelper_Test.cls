/**************************************************
Author: Sajila Kadayaprath
Description : Test class for TaskHelper class
***************************************************/
@isTest
public class TaskHelper_Test
{
    private static testMethod void tesTaskHelper()
    {
        //TaskHelper t=new TaskHelper();
        Boolean b=TaskHelper.istriggerExecuted();
        TaskHelper.setTriggerAsExecuted();
        TaskHelper.setTriggerAsNotExecuted();
        Boolean b1=TaskHelper.istriggerExecutedSMS();
        TaskHelper.setTriggerAsExecutedSMS();
        TaskHelper.setTriggerAsNotExecutedSMS();
    }
}