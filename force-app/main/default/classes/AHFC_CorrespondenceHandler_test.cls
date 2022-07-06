/*Apex Class Name   :   AHFC_CorrespondenceHandler_test
* Description       :   This is test class for AHFC_CorrespondenceHandler
* Created By        :   Aniket Pharakate
* Created on        :   7/6/2021
*********************************************************************************/
@isTest
public class AHFC_CorrespondenceHandler_test {
    
    static testMethod void testNameSearch() {
        test.startTest();
        List<AHFC_Correspondence_code__mdt> nameList = AHFC_CorrespondenceHandler.nameSearch();
        System.assertEquals(nameList.isEmpty(),false);
        test.stopTest();
        
    }
    
    static testMethod void testCommRefeSearch() {
        Communication_Preferences__c rec = new Communication_Preferences__c();
        Finance_Account__c  finAcc = new Finance_Account__c (Name='Test', AHFC_Garaging_Zip__c='12345',
                                                             Vehicle_Identification_Number__c = '12345678912345678',AHFC_Last_4_SSN__c='1234',Finance_Account_Number__c ='123456789');
        insert finAcc;
        string finid = finAcc.id;
        List<Communication_Preferences__c> commList = new List<Communication_Preferences__c>();
        test.startTest();
        commList = AHFC_CorrespondenceHandler.commRefeSearch(finid);
        integer abc = commList.size();
        System.assertEquals(0,abc);
        test.stopTest();
        
    }
    
    
}