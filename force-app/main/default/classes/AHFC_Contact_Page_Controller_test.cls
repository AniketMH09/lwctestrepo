/*Apex Class Name   :   AHFC_Contact_Page_Controller_test
* Description       :   This is test class for AHFC_Contact_Page_Controller
* Created By        :   Aniket Pharakate
* Created on        :   8/15/2021
*********************************************************************************/
@isTest
public class AHFC_Contact_Page_Controller_test {
    
    static testMethod void testBranchDataSearch() {
        test.startTest();
        List<AHFC_Branch_Data__mdt> nameList = AHFC_Contact_Page_Controller.getBranchData();
        System.assertEquals(nameList.isEmpty(),false,'Branch data has some records');
        test.stopTest();
    
    }
    
    static testMethod void testStateDataSearch() {
        test.startTest();
        List<AHFC_States__mdt> stateList = AHFC_Contact_Page_Controller.getStateData();
        System.assertEquals(stateList.isEmpty(),false,'state data has some records');
        test.stopTest();
    
    }
    
     static testMethod void testAddressDataSearch() {
        test.startTest();
        List<AHFC_Contact_Address__mdt> addressList = AHFC_Contact_Page_Controller.getAddressData();
        System.assertEquals(addressList.isEmpty(),false, 'address list has some records');
        test.stopTest();
    
    }
    
    static testMethod void testErrorNotificationSearch() {
        test.startTest();
        List<AHFC_Contact_Us_page_Error_State__mdt> errorList = AHFC_Contact_Page_Controller.getErrorNotification();
        System.assertEquals(errorList.isEmpty(),false,'error list has some data');
        test.stopTest();
    
    }
    
      static testMethod void testCommRefeSearch() {
        
        Finance_Account__c  finAcc = new Finance_Account__c (Name='Test', AHFC_Garaging_Zip__c='12345',
                                                             Vehicle_Identification_Number__c = '12345678912345678',AHFC_Last_4_SSN__c='1234',Finance_Account_Number__c ='123456789');
        insert finAcc;
        string finid = finAcc.id;
         List<Finance_Account__c> commList = new List<Finance_Account__c>();
        test.startTest();
        commList = AHFC_Contact_Page_Controller.finData(finid);
        integer abc = commList.size();
        System.assertEquals(1,abc,'comm list has some records');
        test.stopTest();
   
    }
    
    
    
}