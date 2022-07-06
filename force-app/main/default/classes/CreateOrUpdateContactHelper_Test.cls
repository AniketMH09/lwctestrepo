/***************************************************************************************************
Apex Class Name    : CreateOrUpdateContactHelper_Test 
Version            : 1.0 
Created Date       : 28 MARCH 2018
Function           : This class is Test class for CreateOrUpdateMarketingContact trigger 
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               28/03/2018              Original Version
***************************************************************************************************/
@isTest(seeAllData = false )
public class CreateOrUpdateContactHelper_Test { 
     //Positive Test Case   
     static testMethod void  testPositiveCase()
        {
           Test.startTest();
           List<MC_Notification__c> mnRecList = TestDataUtility.createMCNotification();
           insert mnRecList;        
           List<Contact> contList = [Select id from Contact where 
                                     Finance_Account__c =: (mnRecList.get(0)).Finance_Account__c or 
                                     Finance_Account__c =: (mnRecList.get(1)).Finance_Account__c or 
                                     Finance_Account__c =: (mnRecList.get(2)).Finance_Account__c];
           System.assert(contList.size() == 2);
           Finance_Account__c finAcc = [Select Eligible_For_MC_Connector__c 
                                        from Finance_Account__c where id =: (mnRecList.get(0)).Finance_Account__c];
           System.assert(finAcc.Eligible_For_MC_Connector__c == true);   
           Communication_Preferences__c comPRec = [Select Eligible_For_MC_Connector__c 
                                                   from Communication_Preferences__c
                                                   where Finance_Account_Number__c =: (mnRecList.get(0)).Finance_Account__c];
           System.assert(comPRec.Eligible_For_MC_Connector__c == true);   
            Test.stopTest();
        }
        
     //Negative Test Case 
     static testMethod void  testNegativeCase()
        {
            Test.startTest();
            List<Communication_Preferences__c> ComPrefList = TestDataUtility.createComPref();
            insert ComPrefList;        
            Finance_Account__c finAcc = [Select Eligible_For_MC_Connector__c 
                                         from Finance_Account__c 
                                         where id =: (ComPrefList.get(0)).Finance_Account_Number__c];
            System.assert(finAcc.Eligible_For_MC_Connector__c == false);   
            Communication_Preferences__c comPRec=[Select Eligible_For_MC_Connector__c 
                                                  from Communication_Preferences__c 
                                                  where Finance_Account_Number__c =: (ComPrefList.get(0)).Finance_Account_Number__c];
            System.assert(comPRec.Eligible_For_MC_Connector__c == false);   
            Test.stopTest();
        }
        }