/* Apex Class Name       :    AHFC_RemoveAndUpdateAddressHandler
    * Description        :    Test Class for AHFC_RemoveAndUpdateAddressHandler, AHFC_AddressIntegrationUtil
    * Modification Log   :
    * ---------------------------------------------------------------------------
    * Developer                          Date                   Description
    * ---------------------------------------------------------------------------
    * Prabu Mohanasundaram               25 JUNE 2021               Created
*********************************************************************************/
  
    @isTest
public class AHFC_RemoveAndUpdateAddressHandlerTest{
    static Id custUserProfileId = [SELECT Id, Name FROM Profile Where Name =: AHFC_GlobalConstans.CUSTOMER_PROFILE].Id;
    @testSetup
    public static void createTestData(){
        List<Account> lstAccounts = new List<Account>();
        List<Account> lstBusinessAccs = new List<Account>();
        List<Contact> lstContacts = new List<Contact>();
         
        Id sysAdminProfile = [select ID, Name FROM Profile where Name =: AHFC_GlobalConstans.SYSTEM_ADMINISTRATOR].Id;
        Id portalRole = [Select Id From UserRole where Name = 'Business Processes' Limit 1].Id;
         User sysAdminUser = AHFC_TestDataFactory.getTestUser(portalRole, sysAdminProfile, 'John', 'Lewis', true);
        System.runAS(sysAdminUser)
        {
            for(Integer i=0; i<5; i++){
                lstAccounts.add(AHFC_TestDataFactory.createPersonAccount());
            }
            if(!lstAccounts.isEmpty()){
                insert lstAccounts;
            }
			           
            //create Business Accounts
            for(Integer i=0; i<5; i++){
                lstBusinessAccs.add(AHFC_TestDataFactory.createAccount('Dealer'));
            }
            if(!lstBusinessAccs.isEmpty()){
                insert lstBusinessAccs;
            }
            
            //create Contacts
            for(Account acc : lstBusinessAccs){
                lstContacts.add(AHFC_TestDataFactory.createContact(acc?.Id));
            }
            if(!lstContacts.isEmpty()){
                insert lstContacts;
            }
            
            //create createFinanceAccount
            Finance_Account__c finAcc = AHFC_TestDataFactory.createFinanceAccount(lstContacts[0]?.Id);
            insert finAcc;

            
            Account personAcc = [Select PersonContactId From Account Where Id = :lstAccounts[0].Id];
            //create community user 1
            User testUser = AHFC_TestDataFactory.getTestUser(null, custUserProfileId, 'Test', 'Customer User', false);
            testUser.ContactId = personAcc.PersonContactId;
            insert testUser;
        }
    }
    
    @isTest public static void testUpdateAddress(){
        List<User> usr = [SELECT Id, Name FROM User Where Name Like 'Test Customer User' AND ProfileId =:custUserProfileId];
        List<Finance_Account__c> lstSAs = [SELECT ID, Finance_Account_Number__c FROM Finance_Account__c];
        System.runAs(usr[0]){
            AHFC_RemoveAndUpdateAddressHandler.UpdateAddressWrapper objWrapper = new AHFC_RemoveAndUpdateAddressHandler.UpdateAddressWrapper();
            if(lstSAs!=null && !lstSAs.isEmpty()){
                objWrapper.lookupID = lstSAs[0]?.Finance_Account_Number__c;
            }
            objWrapper.addressLine1 = '2226';
            objWrapper.addressLine2 = 'John House';
            objWrapper.city = 'Torrance';
            objWrapper.state = 'CA';           
            objWrapper.zipCode = '90501-2746';
            objWrapper.addressType = 'Garaging';
            objWrapper.isScrubbedAccepted = true;  
            AHFC_AddressIntegrationUtil.responseAddressWrapper addressResponse;
            addressResponse = AHFC_RemoveAndUpdateAddressHandler.handleUpdateAddress(JSON.serialize(objWrapper));
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new AHFC_UpdateAddressIntegrationMock());
            Test.stopTest();
            System.assertNotEquals(objWrapper, null,'Wrapper should not be Empty');
        }
    }
    @isTest public static void testRemoveBillToAddress(){
        List<User> usr = [SELECT Id, Name FROM User Where Name Like 'Test Customer User' AND ProfileId =:custUserProfileId];
        List<Finance_Account__c> lstSAs = [SELECT ID, Finance_Account_Number__c FROM Finance_Account__c];
        String strLookUpID='';
            System.runAs(usr[0]){
            AHFC_RemoveAndUpdateAddressHandler.UpdateAddressWrapper objWrapper = new AHFC_RemoveAndUpdateAddressHandler.UpdateAddressWrapper();
            if(lstSAs!=null && !lstSAs.isEmpty()){
                strLookUpID = lstSAs[0]?.Finance_Account_Number__c;
            }
            AHFC_RemoveAndUpdateAddressHandler.handleRemoveBillToAddress(strLookUpID);
           // objHandler.handleRemoveBillToAddress(strLookUpID);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new AHFC_RemoveBillToAddrIntegrationMock());
            Test.stopTest();
        }
        System.assertNotEquals(strLookUpID, null,'Finance Account Number should not be empty');
    }
}