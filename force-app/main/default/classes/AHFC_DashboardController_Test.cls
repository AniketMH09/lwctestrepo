/* Apex Class Name       :    AHFC_DashboardController_Test
*  description           :    This test Class for AHFC_DashboardController
*  Modification Log      :
* ---------------------------------------------------------------------------
*  Developer                   Date                   Description
* --------------------------------------------------------------------------- 
*  ANIKET PHARAKATE             20 May 2021               Created
*/
@isTest
public class AHFC_DashboardController_Test {
    
    static Id custUserProfileId = [SELECT Id, Name FROM Profile Where Name = 'Customer'].Id;
    @testSetup
    public static void createTestData(){
        List<Account> lstAccounts = new List<Account>();
        List<Account> lstBusinessAccs = new List<Account>();
        List<Contact> lstContacts = new List<Contact>();
        List<Customer_Finance_Account__c> lstSACs = new List<Customer_Finance_Account__c>();
        List<Finance_Account__c> lstserAcc = new List<Finance_Account__c>();
        
        Id idSysAdmin = [select ID, Name FROM Profile where Name = 'System Administrator']?.Id;
        Id idPortalRole = [Select Id From UserRole where Name = 'Business Processes' Limit 1]?.Id;
        
        //insert System Admin
        User sysAdminUser = AHFC_TestDataFactory.getTestUser(idPortalRole, idSysAdmin, 'John', 'Lewis', true);
        System.runAS(sysAdminUser){
            //create Person Accounts
            for(Integer i=0; i<=1; i++){
                lstAccounts.add(AHFC_TestDataFactory.createPersonAccount());
            }
            if(!lstAccounts.isEmpty()){
                insert lstAccounts;
                system.debug('2222222222222222222lstAccounts'+lstAccounts[0].id);
            }
            
            //create Business Accounts
            for(Integer i=0; i<=1; i++){
                lstBusinessAccs.add(AHFC_TestDataFactory.createAccount('Dealer'));
            }
            if(!lstBusinessAccs.isEmpty()){
                insert lstBusinessAccs;
                system.debug('2222222222222222222lstAccounts'+lstBusinessAccs[0].id);
            }
            
            
            //create Contacts
            for(Account acc : lstBusinessAccs){
                lstContacts.add(AHFC_TestDataFactory.createContact(acc?.Id));
            }
            if(!lstContacts.isEmpty()){
                insert lstContacts;
            }
            
            //create createServiceAccount
            for(Integer i=0; i<=1; i++){
                lstserAcc.add(AHFC_TestDataFactory.createServiceAccount(lstContacts[i]?.Id));
                lstserAcc[i].Name ='Test'+i;
                lstserAcc[i].Finance_Account_Number__c='123456'+i;
            }
            if(!lstserAcc.isEmpty()){
                insert lstserAcc;
                 system.debug('2222222222222222222lstAccounts'+lstserAcc[0].id);
            }
            
            //create Service Account Customer
           // lstSACs.add(AHFC_TestDataFactory.createFinanceAccountCustomer(lstserAcc[0]?.Id, lstAccounts[0]?.Id));
            lstSACs.add(AHFC_TestDataFactory.createFinanceAccountCustomer(lstserAcc[0]?.Id, lstAccounts[0]?.Id));
            if(!lstSACs.isEmpty()){
                
                insert lstSACs;
                system.debug('lstSACs'+lstSACs[0].id);
            }
            
            
            List<ChargentOrders__ChargentOrder__c> lstpayment = new List<ChargentOrders__ChargentOrder__c>();
            lstpayment.add(AHFC_TestDataFactory.createpayment(lstserAcc[0]?.Id,'W','O','Pending'));
            
            
            if(!lstpayment.isEmpty()){
                lstpayment[0].Payment_Display_Status__c = 'Pending';
                insert lstpayment;
            }
            system.debug('lstpayment2222222222222'+lstpayment);
            Account personAcc = [Select PersonContactId From Account Where Id = :lstAccounts[0].Id];
            system.debug('personAcc'+personAcc.id);
            //create community user 1
            User testUser = AHFC_TestDataFactory.getTestUser(null, custUserProfileId, 'Test', 'Customer User', false);
            testUser.ContactId = personAcc.PersonContactId;
            insert testUser;
            system.debug('testUser'+testUser.ID);
        }
    }
    
    @isTest public static void testServiceAccountdetails(){
        List<User> usr = [SELECT Id, Name FROM User Where Name Like 'Test Customer User' AND ProfileId =:custUserProfileId];
        List<AHFC_DashboardController.ServiceAccountWrapper> lstserviceAccountWrapper = new List<AHFC_DashboardController.ServiceAccountWrapper>();
        system.debug('usr[0]'+usr[0]);
        System.runAs(usr[0]){
            Test.startTest();
            lstserviceAccountWrapper = AHFC_DashboardController.getServiceAccountdetails();
            Test.stopTest();
        }
    }
    
    @isTest public static void testServiceAccountrecords(){
        Test.startTest();
        List<AHFC_DashboardController.ServiceAccountWrapper> lstserviceAccountWrapper = new List<AHFC_DashboardController.ServiceAccountWrapper>();
        lstserviceAccountWrapper = AHFC_DashboardController.getServiceAccountdetails();
        AHFC_DashboardController.getServiceAccountRecords(new List<ID>());
       AHFC_DashboardController.paymentList(new List<ID>());
        AHFC_DashboardController.retrieveServiceAccount();
        Test.stopTest();
    }
    
}