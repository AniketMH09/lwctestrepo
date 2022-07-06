/* Apex Class Name       :    AHFC_PromiseMadeServiceHandlerTest
* @description        	 :    Test Class for AHFC_PromiseMadeServiceHandler
* Modification Log   	 :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               28th July 2021          Created For US 9020
*********************************************************************************/
@isTest
public class AHFC_PromiseMadeServiceHandlerTest {
    static Id custUserProfileId = [SELECT Id, Name FROM Profile Where Name = 'Customer'].Id;
    /**
* @description createTestData
**/
    @testSetup
    public static void createTestData(){
        List<Account> accList = new List<Account>();
        Id idSysAdmin = [select ID, Name FROM Profile where Name = 'System Administrator']?.Id;
        Id idPortalRole = [Select Id From UserRole where Name = 'Business Processes' Limit 1]?.Id;
        
        //insert System Admin
        User sysAdminUser = AHFC_TestDataFactory.getTestUser(idPortalRole, idSysAdmin, 'John', 'Lewis', true);
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
            User testUser = AHFC_TestDataFactory.getTestUser(null, custUserProfileId, 'John', 'Customer User', false);
            testUser.ContactId = personAcc.PersonContactId;
            insert testUser;
        }
    }
    
    /**
* @description testputPromisMade
**/
    @isTest 
    public static void testputPromisMade(){
        List<User> usr = [SELECT Id, Name FROM User Where Name Like 'John Customer User' AND ProfileId =:custUserProfileId];
    
        System.runAs(usr[0]){
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new AHFC_PromiseMadeServiceHandlerMock());
            String response = AHFC_PromiseMadeServiceHandler.putPromisMade('00000448513580','80736439',381.53,'Mailed');
            system.assertEquals('SUCCESS', response, 'Record created in external system');
            Test.StopTest();
        }
    }
}