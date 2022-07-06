@isTest
public class AHFC_Case_List_View_Test {
    
   
     public static testMethod void testBranchDataSearch() {
         
         List<Id> lstSACIdsToUpdate = new list<id>();
         
         
         Account a1= new Account(Name='Test Account Name',AccountNumber ='123456');
         insert a1;
         System.assertEquals('123456',a1.AccountNumber);
         lstSACIdsToUpdate.add(a1.id);
         
         Finance_Account__c finacc2 = new Finance_Account__c();
         finacc2.Finance_Account_Number__c='2197';
         insert finacc2; 
         System.assertEquals('2197',finacc2.Finance_Account_Number__c);
         
         Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
         cfa.Finance_Account__c=finacc2.Id;
         cfa.Customer__c = a1.id;
         cfa.Is_Active__c = true;
         insert cfa;
         System.assertEquals(a1.id,cfa.Customer__c);
         
         Case caseObj1 = new Case();
         caseObj1.Type='CCPA';
         //caseObj1.Record_Type_Name__c = 'CCPA';
         caseObj1.Status ='New';
         caseObj1.Finance_Account__c=finacc2.Id;
         insert caseObj1;
         
         test.startTest();
         List<Case> nameList = AHFC_Case_List_View.getBranchData(finacc2.id);
         System.assertEquals(nameList.isEmpty(),true,'finance account has no cases');
         test.stopTest();
    
    }
    
    
}