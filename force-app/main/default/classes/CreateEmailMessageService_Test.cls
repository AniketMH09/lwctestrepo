/*****************************************************
Author : Sajila Kadayaprath
Description : Test class for CreateEmailMessageService class
*****************************************************/

@isTest
private class CreateEmailMessageService_Test{
    
    static testmethod void test() { 
       Contact cn=new Contact();
       cn.LastName='TestName';
       insert cn;
        
       list<Map<string, String>> newEmailMapList=new list<Map<string, String>>();
       Map<string, String> newEmailMap=new Map<String,String>();
       newEmailMap.put('Confirmation_Number__c','testnum');
       newEmailMap.put('Days_Prior_Reminder__c','10');
       newEmailMap.put('Next_Withdrawal_Date__c','2013-05-05');
       newEmailMap.put('Payment_Amount__c','500000');
       newEmailMap.put('Payment_Effective_Date__c','2013-05-05');
       //removed for defect #114093
       //newEmailMap.put('Contact__c',cn.Id);
       newEmailMap.put('Contact_Email__c','test@mail.com');
       newEmailMap.put('Contact_Lastname__c','TestLName');
       newEmailMapList.add(newEmailMap);

       Test.startTest();
       CreateEmailMessageService c=new CreateEmailMessageService();
       CreateEmailMessageService.createEmailMessage(newEmailMapList);
       Test.stopTest();
    }
}