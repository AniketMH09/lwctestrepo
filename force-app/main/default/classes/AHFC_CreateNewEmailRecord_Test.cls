/*
Author      :  Karunakar Pulkam
Description :  Test class for AHFC_CreateNewEmailRecord
*/

@isTest
public class AHFC_CreateNewEmailRecord_Test {
    @testSetup static void createTestData() {
        
         final string status = Label.AHFC_CreateNew_Status;
         final string className = Label.AHFC_ClassName;
        Id SelfServiceCaseRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Self Service').getRecordTypeId();
        
        
        
        List<Case> caseList = new List<Case>();
          Finance_Account__c fAccount  = new Finance_Account__c(name = '123456',Next_Due_Date__c = Date.today()+5,First_Due_Date__c = Date.today(),Finance_Account_Number__c ='123456');
          insert fAccount;
        for(Integer i=0; i<=10; i++)
        {
            Case caseRec= new Case();
            if(i<5){ 
                
        
        
        
                caseRec.RecordTypeId=SelfServiceCaseRTId;
                caseRec.Type = 'Due Date Change';
                caseRec.status='new';
                caseRec.Origin='Email';
                 caseRec.Finance_Account__c=fAccount.Id;
                //caseRec.Send_DDC_Email__c=false;
                //caseRec.Case_Closure_Email_Sent__c=true;
                //caseRec.Email_Template_Name__c = 'AHFC LE Honda Related Case Denied_Wrong_Template';]
                //caseRec.Email_Template_Name__c = 'AHFC LE Honda Related Case Denied';
                caseList.add(caseRec);
                
            }
            else
            {
                caseRec.RecordTypeId=SelfServiceCaseRTId;
                caseRec.Type = 'Lease Extension';
                caseRec.status='new';
                caseRec.Origin='Email';
                caseRec.Email_Template_Name__c = 'AHFC DDC Honda Related Case Submit';
                caseRec.Finance_Account__c=fAccount.Id;
                //caseRec.Send_DDC_Email__c=false;
                //caseRec.Case_Closure_Email_Sent__c=true;
                
                caseList.add(caseRec);               
            }
        }
        
        
        insert caseList;
        System.assert(caseList.size()>0);
    }    
    public static testmethod void caseEmailTest() {
        Test.startTest();
        
        List<Id> caseIds = new List<Id>();
        List<Case> csList = [SELECT Id,Status,Email_Template_Name__c FROM Case where Email_Template_Name__c ='AHFC DDC Honda Related Case Submit'];
        System.assert(csList.size()>0);
        for(Case c: csList){
            caseIds.add(c.Id);
        }
        List<String> emailTemplateName = AHFC_CreateNewEmailRecord.getEmailRecords(caseIds);
        List<EmailMessage> msg = [Select id from EmailMessage where ParentId =: caseIds[0]];
        System.assertNotEquals(0, msg.size());
        List<Id> caseIds1 = new List<Id>();
        List<Case> csList1 = [SELECT Id,Status,Email_Template_Name__c FROM Case where Email_Template_Name__c = 'AHFC LE Honda Related Case Denied'];
        //System.assert(csList1.size()>0);
        for(Case c: csList1){
            caseIds1.add(c.Id);
        }
        List<String> emailTemplateName1 = AHFC_CreateNewEmailRecord.getEmailRecords(caseIds1);
        
        Test.stopTest();
    }
    
}