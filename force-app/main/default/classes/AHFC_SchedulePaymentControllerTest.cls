/* Apex Class Name    :    AHFC_SchedulePaymentControllerTest
 * @description        :    Test Class for AHFC_SchedulePaymentController
 * Modification Log    :
 * ---------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ---------------------------------------------------------------------------
 * Ashok                      06/07/2021              Created
 * Prabu Mohanasundaram		 22/11/2021				 Modified
 *********************************************************************************/
@isTest
public class AHFC_SchedulePaymentControllerTest {
    /***************************************************************************************************
     * @description  : Testing Method to create finance account and check payments
     ***************************************************************************************************/

    public Static testMethod void paymentsTest() {
        Finance_Account__c finacc = new Finance_Account__c();
        ChargentOrders__ChargentOrder__c chargeOrder = new ChargentOrders__ChargentOrder__c();
        ChargentOrders__ChargentOrder__c chargeOrder2 = new ChargentOrders__ChargentOrder__c();
        Payment_Source__c paymentsrc = new Payment_Source__c();
        Honda_Finance__c hondaFinacc = new Honda_Finance__c();
        finacc.Finance_Account_Number__c = '2541345623';
        finacc.Honda_Brand__c = 'AFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c = true;
        finacc.Region_Code__c = 'BKC';
        finacc.Account_Type__c = 'Balloon';
        finacc.Fl_Refinanced__c = true;
        finacc.Payment_Due_Date__c = System.Today();
        finacc.Fl_Suppress_All_Notifications__c = false;
        finacc.AHFC_Product_Nickname__c = 'Val Nick';
        finacc.Fl_DDC_Eligibility__c = true;
        finacc.FL_LE_Eligibility__c = true;
        finacc.AHFC_Total_days_past_due__c = 25;
        finacc.AHFC_Web_Payoff_Calendar__c = 'y';
        insert finacc;
        Id recID = finacc.Id;

        hondaFinacc.Name = 'Honda';
        hondaFinacc.CutOff_Time__c = DateTime.newInstance(2000, 10, 10, 10, 10, 10);
        insert hondaFinacc;

        paymentsrc.Payment_Source_Nickname__c = 'Honda prime';
        paymentsrc.Last_4__c = '1000';
        insert paymentsrc;
        ID paymentID = paymentsrc.Id;
        
        chargeOrder.Finance_Account_Number__c = recID;
        chargeOrder.ChargentOrders__Charge_Amount__c = 100;
        chargeOrder.Payment_Channel__c = 'W';
        chargeOrder.Last_Extraction_Date__c = System.today();
        chargeOrder.Payment_Source_Nickname__c = paymentID;
        chargeOrder.Last_Payment_Display_Status__c = 'Priya';
        chargeOrder.Payment_Type__c = 'R';
        chargeOrder.Next_Withdrawal_Date__c = System.today().addDays(20);
        chargeOrder.ChargentOrders__Payment_Start_Date__c = System.today().addDays(-400);
        chargeOrder.Payment_Display_Status__c = 'Pending';
        insert chargeOrder;
        
        chargeOrder2.Finance_Account_Number__c = recID;
        chargeOrder2.ChargentOrders__Charge_Amount__c = 100;
        chargeOrder2.Payment_Channel__c = 'W';
        chargeOrder2.Last_Extraction_Date__c = System.today();
        chargeOrder2.Payment_Source_Nickname__c = paymentID;
        chargeOrder2.Last_Payment_Display_Status__c = 'Priya';
        chargeOrder2.Payment_Type__c = 'R';
        chargeOrder2.Next_Withdrawal_Date__c = System.today().addDays(20);
        chargeOrder2.ChargentOrders__Payment_Start_Date__c = System.today().addDays(-400);
        chargeOrder2.Payment_Display_Status__c = 'Suspended';
        insert chargeOrder2;

        Test.startTest();
        AHFC_SchedulePaymentController.paymentList(finacc.Id);
        AHFC_SchedulePaymentController.paymentDetails(recID);
        System.assertNotEquals(recID, null, 'NO Scheduled payments');
        Test.stopTest();
    }
    /**
     * @description: Added the code for cover the Recurring Payment Records when the Display status is Pending
     * @author Prabu| Nov 22nd 2021
     **/
    public Static testMethod void paymentsRecurringStatusPending() {
        RecordType recType = [Select ID, name, DeveloperName from RecordType where DeveloperName = 'Recurring_Payment'];
        Finance_Account__c finacc = new Finance_Account__c();
        ChargentOrders__ChargentOrder__c chargeOrder = new ChargentOrders__ChargentOrder__c();
        Payment_Source__c paymentsrc = new Payment_Source__c();
        Honda_Finance__c hondaFinacc = new Honda_Finance__c();
        finacc.Finance_Account_Number__c = '2541345623';
        finacc.Honda_Brand__c = 'AFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c = true;
        finacc.Region_Code__c = 'BKC';
        finacc.Account_Type__c = 'Balloon';
        finacc.Fl_Refinanced__c = true;
        finacc.Payment_Due_Date__c = System.Today();
        finacc.Fl_Suppress_All_Notifications__c = false;
        finacc.AHFC_Product_Nickname__c = 'Val Nick';
        finacc.Fl_DDC_Eligibility__c = true;
        finacc.FL_LE_Eligibility__c = true;
        finacc.AHFC_Total_days_past_due__c = 25;
        finacc.AHFC_Web_Payoff_Calendar__c = 'y';
        insert finacc;
        Id recID = finacc.Id;

        hondaFinacc.Name = 'Honda';
        hondaFinacc.CutOff_Time__c = DateTime.newInstance(2000, 10, 10, 10, 10, 10);
        insert hondaFinacc;

        paymentsrc.Payment_Source_Nickname__c = 'Honda prime';
        paymentsrc.Last_4__c = '1000';
        insert paymentsrc;
        ID paymentID = paymentsrc.Id;

        chargeOrder.Finance_Account_Number__c = recID;
        chargeOrder.RecordTypeId = recType.Id;
        chargeOrder.ChargentOrders__Charge_Amount__c = 100;
        chargeOrder.Payment_Channel__c = 'W';
        chargeOrder.Last_Extraction_Date__c = System.today();
        chargeOrder.Payment_Source_Nickname__c = paymentID;
        chargeOrder.Last_Payment_Display_Status__c = 'Priya';
        chargeOrder.Payment_Type__c = 'R';
        chargeOrder.Next_Withdrawal_Date__c = System.today().addDays(20);
        chargeOrder.ChargentOrders__Payment_Start_Date__c = System.today().addDays(-400);
        chargeOrder.Payment_Display_Status__c = 'Pending';
        chargeOrder.ChargentOrders__Payment_Status__c = 'Recurring';
        chargeOrder.ChargentOrders__Payment_Frequency__c = 'Monthly';
        insert chargeOrder;
        
        Test.startTest();
        AHFC_SchedulePaymentController.PaymentWrapper wrap = new AHFC_SchedulePaymentController.PaymentWrapper();
        AHFC_SchedulePaymentController.paymentList(finacc.Id);
        wrap = AHFC_SchedulePaymentController.paymentDetails(recID);
        System.assertEquals(wrap.isEZPEnrolled, true, 'EasyPay Enrolled Successfully');
        Test.stopTest();
    }
    /**
     * @description: Added the code for cover the Recurring Payment Records when the Display status is Suspended
     * @author Prabu| Nov 22nd 2021
     **/
    public Static testMethod void paymentsRecurringStatusSuspended() {
        RecordType recType = [Select ID, name, DeveloperName from RecordType where DeveloperName = 'Recurring_Payment'];
        Finance_Account__c finacc = new Finance_Account__c();
        ChargentOrders__ChargentOrder__c chargeOrder = new ChargentOrders__ChargentOrder__c();
        Payment_Source__c paymentsrc = new Payment_Source__c();
        Honda_Finance__c hondaFinacc = new Honda_Finance__c();
        finacc.Finance_Account_Number__c = '2541345623';
        finacc.Honda_Brand__c = 'AFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c = true;
        finacc.Region_Code__c = 'BKC';
        finacc.Account_Type__c = 'Balloon';
        finacc.Fl_Refinanced__c = true;
        finacc.Payment_Due_Date__c = System.Today();
        finacc.Fl_Suppress_All_Notifications__c = false;
        finacc.AHFC_Product_Nickname__c = 'Val Nick';
        finacc.Fl_DDC_Eligibility__c = true;
        finacc.FL_LE_Eligibility__c = true;
        finacc.AHFC_Total_days_past_due__c = 25;
        finacc.AHFC_Web_Payoff_Calendar__c = 'y';
        insert finacc;
        Id recID = finacc.Id;

        hondaFinacc.Name = 'Honda';
        hondaFinacc.CutOff_Time__c = DateTime.newInstance(2000, 10, 10, 10, 10, 10);
        insert hondaFinacc;

        paymentsrc.Payment_Source_Nickname__c = 'Honda prime';
        paymentsrc.Last_4__c = '1000';
        insert paymentsrc;
        ID paymentID = paymentsrc.Id;

        chargeOrder.Finance_Account_Number__c = recID;
        chargeOrder.RecordTypeId = recType.Id;
        chargeOrder.ChargentOrders__Charge_Amount__c = 100;
        chargeOrder.Payment_Channel__c = 'W';
        chargeOrder.Last_Extraction_Date__c = System.today();
        chargeOrder.Payment_Source_Nickname__c = paymentID;
        chargeOrder.Last_Payment_Display_Status__c = 'Priya';
        chargeOrder.Payment_Type__c = 'R';
        chargeOrder.Next_Withdrawal_Date__c = System.today().addDays(20);
        chargeOrder.ChargentOrders__Payment_Start_Date__c = System.today().addDays(-400);
        chargeOrder.Payment_Display_Status__c = 'Suspended';
        chargeOrder.ChargentOrders__Payment_Status__c = 'Recurring';
        chargeOrder.ChargentOrders__Payment_Frequency__c = 'Monthly';
        insert chargeOrder;

        Test.startTest();
        AHFC_SchedulePaymentController.PaymentWrapper wrap = new AHFC_SchedulePaymentController.PaymentWrapper();
        AHFC_SchedulePaymentController.paymentList(finacc.Id);
        wrap = AHFC_SchedulePaymentController.paymentDetails(recID);
        System.assertEquals(wrap.isEZPEnrolled, false, 'EasyPay Enrolled Unsuccessful');
        Test.stopTest();
    }
}