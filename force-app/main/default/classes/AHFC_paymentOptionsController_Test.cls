/* Apex Class Name   :    AHFC_paymentOptionsController_Test
* @Description        :    This is the Test Class of AHFC_paymentOptionsController
* Modification Log   :
* --------------------------------------------------------------------------- 
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Saikiran Doddeni              Jun 29 2021             Created
*********************************************************************************/


@isTest
public class AHFC_paymentOptionsController_Test {

    @isTest static void AHFC_PaymentOptionsTest()
    {
        Finance_Account__c finacc = new Finance_Account__c();
        Finance_Account__c finacc2 = new Finance_Account__c();
        Finance_Account__c finacc3 = new Finance_Account__c();
        Finance_Account__c finacc4 = new Finance_Account__c();
       
        finacc.Finance_Account_Number__c='2541345678';
        finacc.Honda_Brand__c='HFS';
        finacc.Account_Type__c='Balloon';
        finacc.Maturity_Date__c=System.today();
        finacc.AHFC_Product_Type__c = 'Auto';
        
        finacc2.Finance_Account_Number__c='2541456698';
        finacc2.Honda_Brand__c='HFSP';
        finacc2.Account_Type__c='Balloon';
        finacc2.Maturity_Date__c=System.today();
        finacc2.AHFC_Product_Type__c = 'Auto';
        
        finacc3.Finance_Account_Number__c='2541378965';
        finacc3.Honda_Brand__c='AFS';
        finacc3.Account_Type__c='Balloon';
        finacc3.Maturity_Date__c=System.today();
        finacc3.AHFC_Product_Type__c = 'Auto';
        
        finacc4.Finance_Account_Number__c='25413465464';
        
        insert finacc;
        insert finacc2;
        insert finacc3;
        insert finacc4;
        
        AHFC_paymentOptionsController.PaymentWrapper ex = new AHFC_paymentOptionsController.PaymentWrapper();
		AHFC_paymentOptionsController.PaymentWrapper ex2 = new AHFC_paymentOptionsController.PaymentWrapper();
		AHFC_paymentOptionsController.PaymentWrapper ex3 = new AHFC_paymentOptionsController.PaymentWrapper();
        AHFC_paymentOptionsController.PaymentWrapper ex4 = new AHFC_paymentOptionsController.PaymentWrapper();
        
        Test.startTest();
        ex = AHFC_paymentOptionsController.paymentFlagRetrieve(finacc.id);
        System.assertEquals(ex.hondaPayment, true,'Retrieved value should be Hondapayment');
        ex2 = AHFC_paymentOptionsController.paymentFlagRetrieve(finacc2.id);
        System.assertEquals(ex2.hondaPayment, true,'Retrieved value should be Hondapayment');
        ex3 = AHFC_paymentOptionsController.paymentFlagRetrieve(finacc3.id);
        System.assertEquals(ex3.acuraPayment, true,'Retrieved value should be acuraPayment');
        ex4 = AHFC_paymentOptionsController.paymentFlagRetrieve(finacc4.id);
        System.assertEquals(ex4.acuraPayment, false,'Retrieved value should be acuraPayment');
        System.assertEquals(ex4.hondaPayment, false,'Retrieved value should be hondaPayment');
        Test.stopTest();
        
    }
}