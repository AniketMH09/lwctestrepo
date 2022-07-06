/*=====================================================================
* Name: AHFC_AlreadyMadeaPaymentClass_Test.apex
* Description: Unit Test class for AHFC_AlreadyMadeaPaymentClass
* Created By: Kanagaraj
*  ===================================================================== */

@isTest
public class AHFC_AlreadyMadeaPaymentClass_Test {
    
    public static testMethod void testPaymentSource() {
        
        Account a1= new Account(Name='Test Account Name',AccountNumber ='123456');
        insert a1;
        
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='2197';
        finacc2.Honda_Brand__c = 'AFS';
        finacc2.Payoff_Amount__c = 200.00;         
        insert finacc2; 
        System.assertEquals('2197',finacc2.Finance_Account_Number__c);
              
        Test.startTest();
            AHFC_AlreadyMadeaPaymentClass.getFinanceAccountDetails(finacc2.id);
        Test.stopTest();
        
    }
}