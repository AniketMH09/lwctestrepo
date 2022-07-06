/*=====================================================================
* Name: AHFC_ManagePaymentSourceClass_Test.apex
* Description: Unit Test class for AHFC_ManagePaymentSourceClass
* Created Date: 19thth May 2021
* Created By: Abhijit kurapati
*  ===================================================================== */
@isTest
public class AHFC_ManagePaymentSourceClass_Test {
    public static testMethod void testPaymentSource() {
       

 		Account a1= new Account(Name='Test Account Name',AccountNumber ='123456');
        insert a1;
        System.assertEquals('123456',a1.AccountNumber);
              
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='2197';
        finacc2.Honda_Brand__c = 'AFS';
        finacc2.Payoff_Amount__c = 200.00;         
        insert finacc2; 
        System.assertEquals('2197',finacc2.Finance_Account_Number__c);
        
        Payment_Source__c psor1 = new Payment_Source__c();
        psor1.Finance_Account_Number__c = finacc2.id; 
        psor1.Status__c = 'Active';
        psor1.Customer__c = a1.id;
        psor1.Payment_Source_Nickname__c ='ashok test';
        psor1.Last_4__c = '1234';
        insert psor1; 
        System.assertNotEquals(Null,psor1.id);
        
        Contact c1 = new Contact(LastName = 'Contact Last Name', AccountId = a1.id);
        insert c1;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer']; 
              
        
        User u1 =[SELECT Username,Accountid, Id FROM User where id= '0050a00000GZXnsAAH'];
         
        
        Honda_Finance__c hondaFinacc = new Honda_Finance__c();      
        hondaFinacc.Name='Honda';
        hondaFinacc.CutOff_Time__c=DateTime.newInstance(2000,10,10, 10,10,10);
        insert hondaFinacc;
        
        
        ChargentOrders__ChargentOrder__c chargeOrder = new ChargentOrders__ChargentOrder__c();
        chargeOrder.Finance_Account_Number__c = finacc2.Id;
        chargeOrder.ChargentOrders__Charge_Amount__c = 100;
        chargeOrder.Payment_Channel__c='W';
        chargeOrder.Last_Extraction_Date__c=System.today();
        chargeOrder.Payment_Source_Nickname__c = psor1.id;
        chargeOrder.Last_Payment_Display_Status__c = 'Priya';
        chargeOrder.Payment_Type__c='R';
        chargeOrder.Next_Withdrawal_Date__c=System.today().addDays(20);
        chargeOrder.ChargentOrders__Payment_Start_Date__c=System.today().addDays(-400);
        chargeOrder.Payment_Display_Status__c='Pending';
        insert chargeOrder;
        
       psor1.Payment_Source_Nickname__c = psor1.Id;
        List<Object>  paymentData = new List<Object>();
        paymentData.add(psor1);
        
        system.runAs(u1){
        Test.startTest();
            try{
                AHFC_ManagePaymentSourceClass.getPaymentSource(finacc2.Id);
            }
            catch(Exception ex){
                
            }
        
        AHFC_ManagePaymentSourceClass.getCustomerAccountId();
        AHFC_ManagePaymentSourceClass.getServiceAccountCustomers(finacc2.Id);
        AHFC_ManagePaymentSourceClass.deletePaymentSource(psor1.id);//Added by satish US#7027
        AHFC_ManagePaymentSourceClass.checkPaymentSource(psor1.id);
        AHFC_ManagePaymentSourceClass.deleteSchPaymentSource(psor1.Id);
        AHFC_ManagePaymentSourceClass.searchDetPaymentSource('ashok test','1234');
        AHFC_ManagePaymentSourceClass.updatePaymentsDeleteSources(paymentData);
       
        Test.StopTest();    
    }        
            
}

}