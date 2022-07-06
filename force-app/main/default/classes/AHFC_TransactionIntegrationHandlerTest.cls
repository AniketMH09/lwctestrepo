/* Apex Class Name       :    AHFC_TransactionIntegrationHandlerTest
 * Description        :    Test Class for AHFC_TransactionIntegrationHandlerTest
 * Modification Log   :
 * ---------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ---------------------------------------------------------------------------
 * Aniket  Pharakate          30 May 2021               Created
 * Prabu Mohanasundaram       22 Nov 2021               Modified
 *********************************************************************************/
@isTest
public class AHFC_TransactionIntegrationHandlerTest {
    static Id custUserProfileId = [SELECT Id, Name FROM Profile Where Name = 'Customer'].Id;
    @testSetup
    public static void createTestData() {
        List < Account > accList = new List < Account > ();
        Id IdSysAdmin = [select ID, Name FROM Profile where Name = 'System Administrator']?.Id;
        Id IdPortalRole = [Select Id From UserRole where Name = 'Business Processes' Limit 1]?.Id;

        //insert System Admin
        User sysAdminUser = AHFC_TestDataFactory.getTestUser(IdPortalRole, IdSysAdmin, 'John', 'Lewis', true);
        System.runAS(sysAdminUser) {

            //create Person Accounts
            for (Integer i = 0; i < 5; i++) {
                accList.add(AHFC_TestDataFactory.createPersonAccount());
            }
            if (!accList.isEmpty()) {
                insert accList;
            }

            Account personAcc = [Select PersonContactId From Account Where Id =: accList[0].Id];
            //create community user 1
            User testUser = AHFC_TestDataFactory.getTestUser(null, custUserProfileId, 'Test', 'Customer User', false);
            testUser.ContactId = personAcc.PersonContactId;
            insert testUser;
        }
    }


    @isTest public static void testTransactionhistory() {
        List < User > usr = [SELECT Id, Name FROM User Where Name Like 'Test Customer User'
            AND ProfileId =: custUserProfileId
        ];
        System.runAs(usr[0]) {
            date dt = Date.newInstance(2021, 1, 21);
            date dt1 = Date.newInstance(2020, 1, 21);
            date dt2;
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new AHFC_TransactionIntegrationMock());
            String response = AHFC_TransactionIntegrationHandler.handletransactionhistory('00000435253869', dt1, dt);
            String strresponse = AHFC_TransactionIntegrationHandler.handletransactionhistory('00000435253869', null, null);
            System.assertNotEquals(strresponse, null, 'Get TransactionHistory Failed');
            Test.StopTest();

        }
    }
    /**
     * @description: Added the code for allow the valid User from the security check and then making the callout.
     * @author Prabu Mohanasundaram | Nov 22 2021
     **/

    @isTest
    public static void allowValidUserIntegration() {
        Account accObj;
        Contact conObj;
        Contact conObj2;
        User userObj;
        User currentUser = [select id, name FROM User WHERE id =: UserInfo.getUserId()];
        system.runAs(currentUser) {
            accObj = new Account(Name = 'Test Account Name');
            insert accObj;
            conObj = new Contact(LastName = 'Contact Last Name', AccountId = accObj.id);
            insert conObj;
            conObj2 = new Contact(LastName = 'Honda', AccountId = accObj.id);
            insert conObj2;
        }

        Finance_Account__c finaccount = new Finance_Account__c();
        finaccount.Finance_Account_Number__c = '00000435253869';
        finaccount.Honda_Brand__c = 'HFS';
        finaccount.Fl_Recurring_Payment_Eligible_Agent__c = true;
        finaccount.Region_Code__c = 'BKC';
        finaccount.Account_Type__c = 'Balloon';
        finaccount.Fl_Refinanced__c = true;
        finaccount.Payment_Due_Date__c = System.Today();
        finaccount.Fl_Suppress_All_Notifications__c = false;
        finaccount.AHFC_Product_Nickname__c = 'test';
        finaccount.Contact__c = conObj.Id;
        insert finaccount;


        Customer_Finance_Account__c cFinanceAcc = new Customer_Finance_Account__c(Finance_Account__c = finaccount.Id, Customer__c = accObj.Id);
        insert cFinanceAcc;

        System.runAs(currentUser) {
            date dt = Date.newInstance(2021, 1, 21);
            date dt1 = Date.newInstance(2020, 1, 21);
            date dt2;
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new AHFC_TransactionIntegrationMock());
            String response = AHFC_TransactionIntegrationHandler.handletransactionhistory('00000435253869', dt1, dt);
            System.assertNotEquals(response, null, 'Response Received Successfully');
            Test.StopTest();
        }
    }
}