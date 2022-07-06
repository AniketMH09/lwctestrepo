/* Apex Class Name   	 :    AHFC_SupportRequestController_Test
* Description        :    class used for testing AHFC_SupportRequestController
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Edwin            		    AUG 25 2021             	Created
*********************************************************************************/
@isTest
public class AHFC_SupportRequestController_Test {
    
    public static testMethod void testSupportCaseControllers() {
        List<Id> lstSACIdsToUpdate = new list<id>();
        AHFC_Bank_Routing__c ahfcRouting = new AHFC_Bank_Routing__c();
        ahfcRouting.AHFC_Bank_Name__c = 'Test';
        ahfcRouting.AHFC_Routing_Number__c = '987654321';
        insert ahfcRouting;
        System.assertNotEquals(Null,ahfcRouting.id);
        
        
        Account a1= new Account(Name='Test Account Name',AccountNumber ='123456');
        insert a1;
        System.assertEquals('123456',a1.AccountNumber);
        lstSACIdsToUpdate.add(a1.id);
        
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='2197';
        finacc2.Honda_Brand__c = 'AFS';
        finacc2.Payoff_Amount__c = 200.00;         
        insert finacc2; 
        System.assertEquals('2197',finacc2.Finance_Account_Number__c);
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Finance_Account__c=finacc2.Id;
        cfa.Customer__c = a1.id;
        cfa.Is_Active__c = true;
        insert cfa;
        System.assertEquals(a1.id,cfa.Customer__c);
        
        Case caseObj1 = new Case();
        Case caseObj2 = new Case();
        caseObj1.Type='Lease Extension';
        caseObj1.Status ='New';
        caseObj1.Finance_Account__c=finacc2.Id;
        caseObj1.Requested_Months__c =3;
        insert caseObj1;
        
        caseObj2.Type='Document Sharing';
        caseObj2.Status ='New';
        caseObj2.Finance_Account__c=finacc2.Id;
        caseObj2.Requested_Months__c =4;
        Test.startTest();
        
        List<Case> caseList = AHFC_SupportRequestController.fetchSupportRequests(finacc2.Id);
        System.assertEquals(caseList[0].Finance_Account__c,finacc2.Id);
        AHFC_SupportRequestController.SupportRequestWrapper supReqWrapper = AHFC_SupportRequestController.fetchSupportRequestDetails(caseObj1.id);       
        System.assertEquals(supReqWrapper.supportCase.Id,caseObj1.id);
        Test.stopTest();
        
    }
    
}