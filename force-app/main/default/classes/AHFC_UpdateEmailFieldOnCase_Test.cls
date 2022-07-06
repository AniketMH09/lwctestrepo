/*=====================================================================
* (c) 2018 Appirio - A Wipro Company, Inc
* Name: AHFC_UpdateEmailFieldOnCase_Test.apex
* Description: Unit Test class for AHFC_UpdateEmailFieldOnCase
* Created Date: 19th Feb 2019
* Created By: Alla Chaitanya Reddy
*  ===================================================================== */
@IsTest
public class AHFC_UpdateEmailFieldOnCase_Test {
    
    @IsTest
    public static void updateEmailOnCasetest(){
        
        Id SelfServiceCaseRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Self Service').getRecordTypeId();
        
        test.startTest();
        Finance_Account__c fAccount  = new Finance_Account__c(name = '123456',Next_Due_Date__c = Date.today()+5,honda_brand__c='HFS',
                                                              First_Due_Date__c = Date.today(),Finance_Account_Number__c ='123456');
        insert fAccount;
        
        Communication_Preferences__c testComPrefRec = new Communication_Preferences__c(Finance_Account_Number__c=fAccount.id,
                                                                                       Account_Status_Updates_via_Email__c=true,
                                                                                       Email_Address__c='test@ahfc.com');
        insert testComPrefRec;
        
        list<id> caseid = new list<id>();
        Case caseRec= new Case();
        caseRec.Finance_Account__c=fAccount.id;
        caseRec.RecordTypeId=SelfServiceCaseRTId;
        caseRec.Type = 'Due Date Change';
        caseRec.status='new';
        caseRec.Origin='Email';
        caseRec.Retry__c=1.5;
        caseRec.Comm_Pref_Email__c='test@ahfc.com';
        
        insert caseRec;
        
        caseid.add(caseRec.id);
        test.stopTest();
        //system.assert(!caseRec.Finance_Account__c.isEmpty());
        system.assertEquals(caseRec.Finance_Account__c, fAccount.id);
        system.debug('value'+ caseRec.Finance_Account__c);
        AHFC_UpdateEmailFieldOnCase.updateEmailOnCase(caseid);
    }
    
}