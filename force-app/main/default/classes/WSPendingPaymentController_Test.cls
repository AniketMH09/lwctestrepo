@isTest
public class WSPendingPaymentController_Test{
    
    static testMethod void TestMyPendingPaymentWS(){ 
           
        Finance_Account__c finAcc = new Finance_Account__c();
        //finAcc.Name='Test123456';
        finAcc.Finance_Account_Number__c='9876547';
        finAcc.Next_Due_Date__c = system.today().addDays(20);
        finAcc.Fl_Future_OneTime_Payment_Eligible_IVR__c = true;
        finAcc.Honda_Brand__c = 'AFS';
        finAcc.Payoff_Amount__c = 200.00;
        finAcc.Scheduled_EasyPay_Amount__c = 120.00;
        finAcc.Fl_OneTime_Payment_Eligible_IVR__c = true;
        finAcc.Payment_Due_Date__c = system.today().addDays(05);
        finAcc.Fl_Bankrupt__c = true;
        insert finAcc;  
        
        //List Custom Settings
        Max_Future_Date__c mfd = new Max_Future_Date__c();
        mfd.Name = 'ghjgkjgj' ;
        mfd.days_in_future_ivr__c = 20;
        
        insert mfd;
        
        minimum_value__c mval = new minimum_value__c();
        mval.Name = 'ghjgkjgj' ;
        mval.minval__c = 25 ;
        insert mval;
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc.id;
        cPref2.Customer__c=a.Id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        cPref2.Email_Address__c= 'testhonda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Text_Number__c = '(999) 999-9999' ;
        //cpref2.Unsubscribe_from_all__c = true;
        cpref2.Payment_Reminders_via_Email__c = false;
        cpref2.Days_Prior_Reminder__c = '15';
        cpref2.Paperless_Statements_Letters__c = true;
        cPref2.Payment_Confirmations_via_Text__c = true; 
        cPref2.EasyPay_Communications_via_Text__c = true;
        cPref2.Statements_Letters__c = 'eDelivery';
        
        insert cPref2;
        
        /*Bank_Account__c bacc = new Bank_Account__c();
        bacc.Payment_Source_Nickname__c = Kick2;
        bacc.Last_4__c = '1345';
        bacc.Preferred_Payment_Source__c = 'one time payment' ;*/  
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finAcc.id; 
            psor2.Bank_Name__c = 'ICICkI';
            psor2.Payment_Source_Nickname__c =finAcc.id;
            psor2.Bank_Account_Number__c = '1230000004560002';
            psor2.Bank_Account_Type__c = 'K';
            psor2.Bank_Routing_Number__c = 'IKBL01538';
            Psor2.Status__c = 'Active';
        
        insert psor2; 
        System.assertNotEquals(Null,psor2.id);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg; 
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c= finAcc.Id;
        ch.Payment_Type__c = 'R';
        ch.ChargentOrders__Next_Transaction_Date__c = system.today().addDays(10);
        ch.Payment_Source_Nickname__c = psor2.id;
        ch.ChargentOrders__Charge_Amount__c=5000;
        ch.ChargentOrders__Payment_Start_Date__c = system.today();
        ch.Payment_Display_Status__c='Pending';
        ch.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        insert ch;
        
        WSPendingPaymentController wspp = new WSPendingPaymentController();   
        
        try{
        WSPendingPaymentController.PendingPayments(finAcc.Finance_Account_Number__c);
        }catch(Exception e){}
        WSPendingPaymentController.Payment wsppcp = new WSPendingPaymentController.Payment();   
        wsppcp.paymentId = ch.id;
        wsppcp.paymentSourceId =psor2.id;
        wsppcp.accountNumber = '9876547';
        //wsppcp.gatewayName = ;
        wsppcp.status = 'CREATE';
        
        wsppcp.paymentAmount = '230.00' ;
        WSPendingPaymentController.oneTimePayment(wsppcp); 
        
        Datetime myDatetime = Datetime.now();
        String myDatetimeStr = myDatetime.format('MMMM d,  yyyy');
        wsppcp.paymentEffectiveDate = myDatetimeStr;  
        
        finacc.Next_Due_Date__c=null;
        update finacc;
        
        WSPendingPaymentController.Payment wsppcp1 = new WSPendingPaymentController.Payment();   
        wsppcp1.paymentId = ch.id;
        wsppcp1.paymentSourceId =psor2.id;
        wsppcp1.accountNumber = '9876547';
        //wsppcp.gatewayName = ;
        wsppcp1.status = 'CANCEL';
        
        wsppcp1.paymentAmount = '230.00' ;
        WSPendingPaymentController.oneTimePayment(wsppcp1); 
                 
    }      
    static testMethod void TestMyPendingPaymentWS1(){ 
        WSPendingPaymentController wspp = new WSPendingPaymentController();    
        Finance_Account__c finAcc = new Finance_Account__c();
        //finAcc.Name='Test123456';
        finAcc.Finance_Account_Number__c='9876547';
        finAcc.Next_Due_Date__c = system.today().addDays(20);
        finAcc.Fl_Future_OneTime_Payment_Eligible_IVR__c = true;
        finAcc.Honda_Brand__c = 'AFS';
        finAcc.Payoff_Amount__c = 200.00;
        finAcc.Scheduled_EasyPay_Amount__c = 120.00;
        finAcc.Fl_OneTime_Payment_Eligible_IVR__c = true;
        finAcc.Payment_Due_Date__c = system.today().addDays(05);
        finAcc.Fl_Bankrupt__c = true;
        insert finAcc;  
        
        //List Custom Settings
        Max_Future_Date__c mfd = new Max_Future_Date__c();
        mfd.Name = 'ghjgkjgj' ;
        mfd.days_in_future_ivr__c = 20;
        
        insert mfd;
        
        minimum_value__c mval = new minimum_value__c();
        mval.Name = 'ghjgkjgj' ;
        mval.minval__c = 25 ;
        insert mval;
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc.id;
        cPref2.Customer__c=a.Id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        cPref2.Email_Address__c= 'testhonda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Text_Number__c = '(999) 999-9999' ;
        //cpref2.Unsubscribe_from_all__c = true;
        cpref2.Payment_Reminders_via_Email__c = false;
        cpref2.Days_Prior_Reminder__c = '15';
        cpref2.Paperless_Statements_Letters__c = true;
        cPref2.Payment_Confirmations_via_Text__c = true; 
        cPref2.EasyPay_Communications_via_Text__c = true;
        cPref2.Statements_Letters__c = 'eDelivery';
        
        insert cPref2;
        
        /*Bank_Account__c bacc = new Bank_Account__c();
        bacc.Payment_Source_Nickname__c = Kick2;
        bacc.Last_4__c = '1345';
        bacc.Preferred_Payment_Source__c = 'one time payment' ;*/  
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finAcc.id; 
            psor2.Bank_Name__c = 'ICICkI';
            psor2.Payment_Source_Nickname__c =finAcc.id;
            psor2.Bank_Account_Number__c = '1230000004560002';
            psor2.Bank_Account_Type__c = 'K';
            psor2.Bank_Routing_Number__c = 'IKBL01538';
            Psor2.Status__c = 'Active';
        
        insert psor2; 
        System.assertNotEquals(Null,psor2.id);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg; 
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c= finAcc.Id;
        ch.Payment_Type__c = 'R';
        ch.ChargentOrders__Next_Transaction_Date__c = system.today().addDays(10);
        ch.Payment_Source_Nickname__c = psor2.id;
        ch.ChargentOrders__Charge_Amount__c=5000;
        ch.ChargentOrders__Payment_Start_Date__c = system.today();
        ch.Payment_Display_Status__c='Pending';
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';
        ch.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        insert ch;
        
         
        WSPendingPaymentController.PendingPayments(finAcc.Finance_Account_Number__c);
        //WSPendingPaymentController.oneTimePayment(wsppcp);  
        WSPendingPaymentController.Payment p=new WSPendingPaymentController.Payment();
        p.status='CANCEL';
        p.paymentEffectiveDate=String.valueof(System.Today());
        WSPendingPaymentController.PaymentResponse p1=new WSPendingPaymentController.PaymentResponse();
        WSPendingPaymentController.oneTimePayment(p);

    }
    static testMethod void TestMyPendingPaymentWS2(){ 
           
        Finance_Account__c finAcc = new Finance_Account__c();
        //finAcc.Name='Test123456';
        finAcc.Finance_Account_Number__c='9876547';
        finAcc.Next_Due_Date__c = system.today().addDays(20);
        finAcc.Fl_Future_OneTime_Payment_Eligible_IVR__c = true;
        finAcc.Honda_Brand__c = 'AFS';
        finAcc.Payoff_Amount__c = 200.00;
        finAcc.Scheduled_EasyPay_Amount__c = 120.00;
        finAcc.Fl_OneTime_Payment_Eligible_IVR__c = true;
        finAcc.Payment_Due_Date__c = system.today().addDays(05);
        finAcc.Fl_Bankrupt__c = true;
        insert finAcc;  
        
        //List Custom Settings
        Max_Future_Date__c mfd = new Max_Future_Date__c();
        mfd.Name = 'ghjgkjgj' ;
        mfd.days_in_future_ivr__c = 20;
        
        insert mfd;
        
        minimum_value__c mval = new minimum_value__c();
        mval.Name = 'ghjgkjgj' ;
        mval.minval__c = 25 ;
        insert mval;
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc.id;
        cPref2.Customer__c=a.Id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        cPref2.Email_Address__c= 'testhonda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Text_Number__c = '(999) 999-9999' ;
        //cpref2.Unsubscribe_from_all__c = true;
        cpref2.Payment_Reminders_via_Email__c = false;
        cpref2.Days_Prior_Reminder__c = '15';
        cpref2.Paperless_Statements_Letters__c = true;
        cPref2.Payment_Confirmations_via_Text__c = true; 
        cPref2.EasyPay_Communications_via_Text__c = true;
        cPref2.Statements_Letters__c = 'eDelivery';
        
        insert cPref2;
        
        /*Bank_Account__c bacc = new Bank_Account__c();
        bacc.Payment_Source_Nickname__c = Kick2;
        bacc.Last_4__c = '1345';
        bacc.Preferred_Payment_Source__c = 'one time payment' ;*/  
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finAcc.id; 
            psor2.Bank_Name__c = 'ICICkI';
            psor2.Payment_Source_Nickname__c =finAcc.id;
            psor2.Bank_Account_Number__c = '1230000004560002';
            psor2.Bank_Account_Type__c = 'K';
            psor2.Bank_Routing_Number__c = 'IKBL01538';
            Psor2.Status__c = 'Active';
        
        insert psor2; 
        System.assertNotEquals(Null,psor2.id);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg; 
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c= finAcc.Id;
        ch.Payment_Type__c = 'R';
        ch.ChargentOrders__Next_Transaction_Date__c = system.today().addDays(10);
        ch.Payment_Source_Nickname__c = psor2.id;
        ch.ChargentOrders__Charge_Amount__c=5000;
        ch.ChargentOrders__Payment_Start_Date__c = system.today();
        ch.Payment_Display_Status__c='Pending';
        ch.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        insert ch;
        
        WSPendingPaymentController wspp = new WSPendingPaymentController();   
        
        WSPendingPaymentController.Payment wsppcp = new WSPendingPaymentController.Payment();   
        wsppcp.paymentId = ch.id;
        wsppcp.paymentSourceId =psor2.id;
        wsppcp.accountNumber = '9876547';
        //wsppcp.gatewayName = ;
        wsppcp.status = 'CREATE';
         //wsppcp.paymentEffectiveDate = String.valueof(System.Today());  
         Datetime yourDate = Datetime.now();
         wsppcp.paymentEffectiveDate = yourDate.format('dd/MM/yyyy');  
        wsppcp.paymentAmount = '230.00' ;
        WSPendingPaymentController.oneTimePayment(wsppcp); 
                 
    } 
                
}