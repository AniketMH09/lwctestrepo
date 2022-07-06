/*@Apex class       :   AHFC_payment_Test
* @Description      :   Test class for AHFC_Payment
* @Developer Name	: 	Kanagaraj	
* @Modification Log	:	Added beforeAfterPayoff method line no - 77 for the US - 4338
*********************************************************************************/
@istest
public class AHFC_Payment_test {    
    static Finance_Account__c finacc;    
    static Finance_Account__c finacc1;  
    Static testMethod void AHFC_payments_Test(){  
        List<ChargentOrders__ChargentOrder__c> lstPayments =new List<ChargentOrders__ChargentOrder__c>();
        Date dateToday = System.today();
        finacc = new Finance_Account__c();  
        finacc1 = new Finance_Account__c();        
        finacc.Finance_Account_Number__c='2541345623';
        finacc.Honda_Brand__c='AFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c=true;
        finacc.Region_Code__c='BKC';
        finacc.Account_Type__c='Balloon';
        finacc.Fl_Refinanced__c=true;
        finacc.Payment_Due_Date__c=System.Today();
        finacc.Fl_Suppress_All_Notifications__c = false;
        finacc.AHFC_Product_Nickname__c ='test';
        finacc.Fl_DDC_Eligibility__c=true;
        finacc.FL_LE_Eligibility__c=true;
        finacc.AHFC_Total_days_past_due__c=25;
        finacc.AHFC_Web_Payoff_Calendar__c='y';
        insert finacc;
        
        Id recID=finacc.Id;
              
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc.id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        cPref2.Email_Address__c= 'testhonda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Text_Number__c = '(999) 999-9999' ;        
        cpref2.Payment_Reminders_via_Email__c = false;
        cpref2.Days_Prior_Reminder__c = '15';
        cpref2.Paperless_Statements_Letters__c = true;
        cPref2.Payment_Confirmations_via_Text__c = true; 
        cPref2.EasyPay_Communications_via_Text__c = true;
        cPref2.Statements_Letters__c = 'eDelivery';        
        insert cPref2;        
        date todo= system.today();
        String fcacc= finacc.Finance_Account_Number__c;
        Payment_Source__c bankAccDetail = new Payment_Source__c();        
        bankAccDetail.ChargentOrders_Tokenization__c='6213380946106607404007';      
        insert bankAccDetail;
        Id PaymentID=bankAccDetail.Id;
        Test.startTest();
        lstPayments = AHFC_Payment.insertPayments(recID, PaymentID, 100, 200, todo);
        AHFC_Payment.insertPayoffPurchasePayments(recID, PaymentID, 100,todo);
        AHFC_Payment.getOrgdetail();
        AHFC_Payment.commPrefDetail(finacc.id);
        AHFC_Payment.payoffPaymentDetail(finacc.id);
        AHFC_Payment.beforeAfterPayoff(finacc.id);
        AHFC_Payment.insertPayments(recID, PaymentID, 100, 200, todo);
        AHFC_Payment.updatePayment(lstPayments[0].id, PaymentID, 100.00, dateToday, 'Principal');
        system.assertEquals(finacc.id , recID,'Both the Finance Accounts should be same');
        Test.stopTest();
    }

}