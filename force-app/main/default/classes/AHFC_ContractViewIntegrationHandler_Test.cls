/************************************************************************************************
 * @Name         AHFC_ContractViewIntegrationHandler_Test
 * @Author       Satish Lokinindi
 * @Date         26/06/2021
 * @description  Test Class for AHFC_ContractViewIntegrationHandler
 *************************************************************************************************
 * MODIFICATION LOG
 * Version          Developer             Date              description
 *-------------------------------------------------------------------------------------------------
 *  1.0             Satish Lokinindi     26/06/2021         Created    
 *  2.0             Prabu Mohanasundaram 22/11/2021         Modified
 ************************************************************************************************/
@isTest
public class AHFC_ContractViewIntegrationHandler_Test {
    static Id custUserProfileId = [SELECT Id, Name FROM Profile Where Name = 'Customer'].Id;

    /***************************************************************************************************
     * @description  : Created Test Data 
     ***************************************************************************************************/
    @testSetup
    public static void createTestData() {
        List < Account > accList = new List < Account > ();
        Id idSysAdmin = [select ID, Name FROM Profile where Name = 'System Administrator']?.Id;
        Id idPortalRole = [Select Id From UserRole where Name = 'Business Processes' Limit 1]?.Id;

        //insert System Admin
        User sysAdminUser = AHFC_TestDataFactory.getTestUser(idPortalRole, idSysAdmin, 'John', 'Lewis', true);
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

    /***************************************************************************************************
     * @description  : Testing Mock Integration of Contract View 
     ***************************************************************************************************/
    @isTest
    public static void testContractViewIntegration() {
        List < User > usr = [SELECT Id, Name FROM User Where Name Like 'Test Customer User'
            AND ProfileId =: custUserProfileId
        ];
        System.runAs(usr[0]) {

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new AHFC_ContractViewIntegrationMock());
            try {
                AHFC_ContractViewIntegrationHandler.searchwrapper tmp = new AHFC_ContractViewIntegrationHandler.searchwrapper();
                tmp = AHFC_ContractViewIntegrationHandler.searchContracts('00000400039611');
                AHFC_ContractViewIntegrationHandler.getaccesstoken();
                String strResp = AHFC_ContractViewIntegrationHandler.getContracts('19663');
                System.assertNotEquals(strResp, null, 'Get contracts Failed');
            } catch (exception e) {
                System.assertNotEquals(e, null, 'Get contracts Failed');
            }

            Test.StopTest();
        }
    }
    /**
     * @description: Added the code for allow the valid User from the security check and then making the callout.
     * @author Prabu Mohanasundaram | Nov 19 2021
     **/
    @isTest
    public static void allowValidUserIntegration() {
        Account accObj;
        Contact conObj;
        Contact conObj2;
        User userObj;
        User currentUser = [select id, name FROM User WHERE id =: UserInfo.getUserId()];
        system.runAs(currentUser) {
            accObj = new Account(Name = 'Acura User');
            insert accObj;
            conObj = new Contact(LastName = 'Acura Sports', AccountId = accObj.id);
            insert conObj;
            conObj2 = new Contact(LastName = 'Acura', AccountId = accObj.id);
            insert conObj2;
        }

        Finance_Account__c finaccount = new Finance_Account__c();
        finaccount.Finance_Account_Number__c = '00000400039611';
        finaccount.Honda_Brand__c = 'HFS';
        finaccount.Fl_Recurring_Payment_Eligible_Agent__c = true;
        finaccount.Region_Code__c = 'BKC';
        finaccount.Account_Type__c = 'Balloon';
        finaccount.Fl_Refinanced__c = true;
        finaccount.Payment_Due_Date__c = System.Today();
        finaccount.Fl_Suppress_All_Notifications__c = false;
        finaccount.AHFC_Product_Nickname__c = 'Acura';
        finaccount.Contact__c = conObj.Id;
        insert finaccount;


        Customer_Finance_Account__c cFinanceAcc = new Customer_Finance_Account__c(Finance_Account__c = finaccount.Id, Customer__c = accObj.Id);
        insert cFinanceAcc;

        System.runAs(currentUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new AHFC_ContractViewIntegrationMock());
            AHFC_ContractViewIntegrationHandler.searchwrapper tmp = new AHFC_ContractViewIntegrationHandler.searchwrapper();
            tmp = AHFC_ContractViewIntegrationHandler.searchContracts('00000400039611');
            AHFC_ContractViewIntegrationHandler.getaccesstoken();
            String strResp = AHFC_ContractViewIntegrationHandler.getContracts('19663');
            System.assertNotEquals(strResp, null, 'Response Received Successfully');
            Test.StopTest();

        }
    }

}