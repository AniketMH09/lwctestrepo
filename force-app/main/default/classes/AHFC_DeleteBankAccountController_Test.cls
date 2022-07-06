@isTest
public class AHFC_DeleteBankAccountController_Test {
    
    public Static testMethod void DeleteAccountTest(){    
    	Finance_Account__c finacc = new Finance_Account__c();  
        finacc.Finance_Account_Number__c='2541345623';
        finacc.Honda_Brand__c='AFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c=true;
        finacc.Region_Code__c='BKC';
        finacc.Account_Type__c='Balloon';
        finacc.Fl_Refinanced__c=true;
        finacc.Payment_Due_Date__c=System.Today();
        finacc.Fl_Suppress_All_Notifications__c = false;
        finacc.AHFC_Product_Nickname__c ='Val Nick';
        finacc.Fl_DDC_Eligibility__c=true;
        finacc.FL_LE_Eligibility__c=true;
        finacc.AHFC_Total_days_past_due__c=25;
        finacc.AHFC_Web_Payoff_Calendar__c='y';
        insert finacc;
        Id recID=finacc.Id;
        //System.assertEquals('2541345623',finacc.Id);
        
                       
        Payment_Source__c paymentsrc = new Payment_Source__c();
        paymentsrc.Payment_Source_Nickname__c='Honda prime';
        paymentsrc.Last_4__c='1000';
        paymentsrc.Status__c='Active';
        insert paymentsrc;
        ID paymentID = paymentsrc.Id;
        //System.assertNotEquals(Null,paymentsrc.id);
        
       
        ChargentOrders__ChargentOrder__c chargeOrder = new ChargentOrders__ChargentOrder__c();
        chargeOrder.Finance_Account_Number__c = recID;
        chargeOrder.ChargentOrders__Charge_Amount__c = 100;
        chargeOrder.Payment_Channel__c='W';
        chargeOrder.Last_Extraction_Date__c=System.today();
        chargeOrder.Payment_Source_Nickname__c = paymentID;
        chargeOrder.Last_Payment_Display_Status__c = 'Priya';
        chargeOrder.Payment_Type__c='R';
        chargeOrder.Next_Withdrawal_Date__c=System.today().addDays(20);
        chargeOrder.ChargentOrders__Payment_Start_Date__c=System.today().addDays(-400);
        chargeOrder.Payment_Display_Status__c='complete';        
        insert chargeOrder;           
                
        
        Test.startTest();
        String result1 =AHFC_DeleteBankAccountController.deleteBankAcc(paymentID);
        System.assertEquals(result1, 'Account succesfully deleted', 'Account should be deleted');
        Test.stopTest();
        
        
        
    }
    
    public Static testMethod void DeleteAccountTest1(){    
    	Finance_Account__c finacc = new Finance_Account__c();  
        finacc.Finance_Account_Number__c='12345678';
        finacc.Honda_Brand__c='AFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c=true;
        finacc.Region_Code__c='BKC';
        finacc.Account_Type__c='Balloon';
        finacc.Fl_Refinanced__c=true;
        finacc.Payment_Due_Date__c=System.Today();
        finacc.Fl_Suppress_All_Notifications__c = false;
        finacc.AHFC_Product_Nickname__c ='Val Nick';
        finacc.Fl_DDC_Eligibility__c=true;
        finacc.FL_LE_Eligibility__c=true;
        finacc.AHFC_Total_days_past_due__c=25;
        finacc.AHFC_Web_Payoff_Calendar__c='y';
        insert finacc;
        Id recID=finacc.Id;
                       
        Payment_Source__c paymentsrc = new Payment_Source__c();
        paymentsrc.Payment_Source_Nickname__c='Honda prime';
        paymentsrc.Last_4__c='1000';
        paymentsrc.Status__c='Active';
        insert paymentsrc;
        ID paymentID = paymentsrc.Id;
        
       
        ChargentOrders__ChargentOrder__c chargeOrder = new ChargentOrders__ChargentOrder__c();
        chargeOrder.Finance_Account_Number__c = recID;
        chargeOrder.ChargentOrders__Charge_Amount__c = 100;
        chargeOrder.Payment_Channel__c='W';
        chargeOrder.Last_Extraction_Date__c=System.today();
        chargeOrder.Payment_Source_Nickname__c = paymentID;
        chargeOrder.Last_Payment_Display_Status__c = 'ashok';
        chargeOrder.Payment_Type__c='R';
        chargeOrder.Next_Withdrawal_Date__c=System.today().addDays(20);
        chargeOrder.ChargentOrders__Payment_Start_Date__c=System.today().addDays(-400);
        chargeOrder.Payment_Display_Status__c='pending';        
        insert chargeOrder;
        
        Test.startTest();
        String result2 = AHFC_DeleteBankAccountController.deleteBankAcc(paymentID);
        System.assertEquals(result2, 'Bank account associated with pending payments cannot be deleted.', 'Account Shpuld not be deleted');
        Test.stopTest();       
        
        
    }

}