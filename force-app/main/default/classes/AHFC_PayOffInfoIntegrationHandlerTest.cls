/* Apex Class Name       :    AHFC_PayOffInfoIntegrationHandlerTest
* Description        :    Test Class for AHFC_PayOffInfoIntegrationHandler
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Prabu Mohanasundaram               5th JUNE 2021              Created
*********************************************************************************/
@isTest
public class AHFC_PayOffInfoIntegrationHandlerTest {
    static Id custUserProfileId = [SELECT Id, Name FROM Profile Where Name =:AHFC_GlobalConstans.CUSTOMER_PROFILE].Id;
    @testSetup
    public static void createTestData(){
        List<Account> accList = new List<Account>();
        Id sysAdminProfile = [select ID, Name FROM Profile where Name =:AHFC_GlobalConstans.SYSTEM_ADMINISTRATOR].Id;
        Id portalRole = [Select Id From UserRole where Name = 'Business Processes' Limit 1].Id;
        User sysAdminUser = AHFC_TestDataFactory.getTestUser(portalRole, sysAdminProfile, 'John', 'Lewis', true);
        System.runAS(sysAdminUser)
        {
            //create Person Accounts
            for(Integer i=0; i<5; i++){
                accList.add(AHFC_TestDataFactory.createPersonAccount());
            }
            if(!accList.isEmpty()){
                insert accList;
            }
            
            Account personAcc = [Select PersonContactId From Account Where Id = :accList[0].Id];
            //create community user 1
            User testUser = AHFC_TestDataFactory.getTestUser(null, custUserProfileId, 'Test', 'Customer User', false);
            testUser.ContactId = personAcc.PersonContactId;
            insert testUser;
        }
    }
    
    @isTest 
    static void testPayOffCallout(){
        List<User> usr = [SELECT Id, Name FROM User Where Name Like 'Test Customer User' AND ProfileId =:custUserProfileId];
        System.assert(!usr.isEmpty());
        System.runAs(usr[0]){
            AHFC_PayOffInfoIntegrationHandler.handlePayoffInfo('00000438705024', Date.valueOf('2021-05-27'), Date.valueOf('2021-05-27'));  
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new AHFC_PayOffInfoIntegrationMock());
            Test.stopTest();
        }
    }
}