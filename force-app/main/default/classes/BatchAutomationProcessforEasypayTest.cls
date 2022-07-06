@isTest
public class BatchAutomationProcessforEasypayTest {

    public static Map<String,RecordType>  RTMap = RecordTypeUtility.getOrderRecordTypes(); 
    @IsTest private static void BatchAutoProEasyPayTest(){
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111222233';
        finacc.Past_Amount_Due__c=2000;
        finacc.Honda_Brand__c='AFS';
        //finacc.account_type__c='Retail';
        finacc.Fl_Charged_Off__c=true;
        finacc.Region_Code__c='100';
        finacc.account_type__c='Lease';
        finacc.Regular_Monthly_Payment__c = 2000;
        finacc.Fl_OneTime_Payment_Eligible_Web__c = true;
        finacc.Fl_Bankrupt__c = false;
      //  finacc.Remaining_Amount_Due__c =100;
        finacc.Payoff_Amount__c =10000;
        finacc.Maturity_Date__c = system.today().adddays(-100);
        finacc.Paid_to_Date__c = Date.valueof('2015-12-27');
        finacc.Current_Amount_Due__c = 200;
        finacc.Total_Fees_Due__c = 200;
        finacc.Total_Amount_Due__c = 200;
        finacc.Scheduled_EasyPay_Amount__c = 100;
        finacc.Next_Due_Date__c = Date.valueof('2016-01-18');
        finacc.Payment_Due_Date__c = Date.valueof('2016-01-18');
        finacc.Principal_Balance_Amount__c = 150;
        finacc.Fl_Refinanced__c = false;
        finacc.Due_On_Day__c = '12';
        insert finacc;
        
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe',Personemail='testhnda@testorg.com', Customer_Number__c='1234', RecordTypeId = recordType.id);
        insert newAccount;
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Customer__c= newAccount.Id;
        cfa.Finance_Account__c=finacc.Id;
        insert cfa;
        
        Communication_Preferences__c cPref1 = new Communication_Preferences__c();
        cPref1.Finance_Account_Number__c=finacc.id;
        cPref1.Customer__c=newAccount.Id;
        cPref1.Payment_Confirmations_via_Email__c=true;
        cPref1.Payment_Reminders_via_Text__c=true;
        cPref1.Email_Address__c= 'testhnda@testorg.com';
        cPref1.EasyPay_Communications_via_Email__c= true;
        cPref1.Text_Number__c = '(999) 999-9999' ;
        cpref1.Payment_Reminders_via_Email__c = true;
        cpref1.Days_Prior_Reminder__c = '5';
        cpref1.Paperless_Statements_Letters__c = true;
        cPref1.Payment_Confirmations_via_Text__c = true; 
        cPref1.EasyPay_Communications_via_Text__c = true;
        cPref1.Payment_Profile_Updates_via_Email__c= true;
        cPref1.Statements_Letters__c = 'eDelivery';
        insert cPref1;
        
        Payment_Source__c psor1 = new Payment_Source__c();
        psor1.Finance_Account_Number__c = finacc.id; 
        psor1.Bank_Name__c = 'CITIBank';
        psor1.Payment_Source_Nickname__c ='alpha' ;
        psor1.Bank_Account_Number__c = '1230000004560001';
        psor1.Bank_Account_Type__c = 's';
        psor1.Bank_Routing_Number__c = '021000089';
        psor1.Status__c = 'Active';

        insert psor1;

        ChargentOrders__ChargentOrder__c recurringpay = new ChargentOrders__ChargentOrder__c();
        recurringpay.Finance_Account_Number__c = finacc.id;
        recurringpay.Payment_Source_Nickname__c = psor1.id;
        recurringpay.Payment_Display_Status__c = 'Pending';
        recurringpay.ChargentOrders__Payment_Start_Date__c = system.today();
        recurringpay.ChargentOrders__Charge_Amount__c = 200.00;
        recurringpay.Payment_Channel__c = 'R';
        recurringpay.ChargentOrders__Payment_Method__c = 'Check';
        recurringpay.ChargentOrders__Payment_Frequency__c = 'Monthly';
        recurringpay.ChargentOrders__Payment_Status__c = 'Stopped';
        recurringpay.ChargentOrders__Payment_End_Date__c = system.today().addDays(20);
        recurringpay.ChargentOrders__Payment_Stop__c = 'Date' ;
        recurringpay.Payment_Type__c = 'H';
        recurringpay.Next_Withdrawal_Date__c = Date.valueof('2016-02-01');
        recurringpay.ChargentOrders__Next_Transaction_Date__c = Date.valueof('2016-02-01');
        recurringpay.recordtypeid =RTMap.get('Recurring_Payment').Id;
        insert recurringpay;
        
        Test.startTest();
        BatchAutomationProcessforEasypay le= new BatchAutomationProcessforEasypay();
        Id jobid= Database.executeBatch(le,10);
        //Database.executeBatch(new BatchAutomationProcessforEasypay(), 10);
        Test.stopTest();
    }
}