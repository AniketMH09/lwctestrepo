/*@ Author : Hari Charan Nethi  
  */
@isTest
public class PayoffAgentController_Test{
    static testMethod void payoffAgentController_TestMethod(){
        //Test.setCurrentPage(page.BankAccounts);
        Finance_Account__c finacc2 = new Finance_Account__c();
            finacc2.Finance_Account_Number__c='1112';
            finacc2.Honda_Brand__c = 'AFS';
            finacc2.Payoff_Amount__c = 200.00;
                 
        insert finacc2; 
        ApexPages.CurrentPage().getParameters().put('finnumber','1112');
        System.assertNotEquals(Null, finacc2.id);
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
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
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finacc2.id; 
            psor2.Bank_Name__c = 'ICICkI';
            psor2.Payment_Source_Nickname__c ='1112' ;
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
            
         //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc2.id;
            coco1.Payment_Source_Nickname__c = psor2.id;
            coco1.Payment_Display_Status__c = 'Reversed';
            coco1.ChargentOrders__Payment_Start_Date__c = system.today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Payment_Status__c = 'Recurring';
            coco1.ChargentOrders__Payment_Frequency__c = 'Once';
            coco1.Payment_Type__c = 'P';
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
            insert coco1;
        ApexPages.CurrentPage().getParameters().put('Id',coco1.id);
        Test.startTest();
         //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco2 = new ChargentOrders__ChargentOrder__c();
            coco2.Finance_Account_Number__c = finacc2.id;
            coco2.Payment_Source_Nickname__c = psor2.id;
            coco2.Payment_Display_Status__c = 'Reversed';
            coco2.ChargentOrders__Payment_Start_Date__c = system.today();
            coco2.ChargentOrders__Charge_Amount__c = 120.00;
            coco2.ChargentOrders__Payment_Status__c = 'Recurring';
            coco2.ChargentOrders__Payment_Frequency__c = 'Once';
            coco2.Payment_Type__c = 'P';
            //coco2.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff_Payment').getRecordTypeId();
            insert coco2;
        ApexPages.CurrentPage().getParameters().put('Id',coco2.id);
        
        
        System.assertNotEquals(Null,cbg.id);
        
        
        LyonsCredentials__c lcs = new LyonsCredentials__c();
            lcs.CompanyId__c = '123455';
            lcs.User_Name__c = 'test@gmail.com' ;
            lcs.Password__c = 'kflhkdshfksd12';
            
        insert lcs;
        //Label lab = System.Label.GatewayName;
        //ApexPages.CurrentPage().getParameters().put('gatewayName','gatewayName');
        
        ApexPages.StandardController con = new ApexPages.StandardController(coco2); 
        PayoffAgentController poac = new PayoffAgentController(con);
        poac.fetchDataPF();
        poac.checkDatevaluePF();
        poac.CancelPayoff();
        poac.savePayOff();
        
        Integer Initialtypecheck=poac.Initialtypecheck;
        
        Boolean displaypopupdrawer=poac.displaypopupdrawer;
        Boolean editMode=poac.editMode;
        Boolean reviewMode=poac.reviewMode;
        Boolean successMode=poac.successMode;
        Boolean displayModeRP=poac.displayModeRP;
        Boolean eligibleFlagRP=poac.eligibleFlagRP;
        Boolean recordTypeName=poac.recordTypeName;
        
        String finIDVF=poac.finIDVF;
        String OTPid=poac.OTPid;
        String RPID=poac.RPID;
        String RecurringID=poac.RecurringID;
        String PayoffID=poac.PayoffID;
        String fname=poac.fname;
        String StandardAmount=poac.StandardAmount;
        String PrincipalAmount=poac.PrincipalAmount;
        String BankaccntNameotp=poac.BankaccntNameotp;
        String ReviewBanknameOTP=poac.ReviewBanknameOTP;
        String chargeDate=poac.chargeDate;
        String confirmationRP=poac.confirmationRP;
        String reviewBankNamePF=poac.reviewBankNamePF;
        String RecordSelect=poac.RecordSelect;
        
        Test.stopTest();
         }
         
         //Here is testmethod1
         static testMethod void payoffAgentController_TestMethod1(){
        //Test.setCurrentPage(page.BankAccounts);
        Finance_Account__c finacc2 = new Finance_Account__c();
            finacc2.Finance_Account_Number__c='1112';
            finacc2.Honda_Brand__c = 'AFS';
            finacc2.Payoff_Amount__c = 200.00;
                 
        insert finacc2; 
        ApexPages.CurrentPage().getParameters().put('finnumber',null);
        System.assertNotEquals(Null, finacc2.id);
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
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
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finacc2.id; 
            psor2.Bank_Name__c = 'ICICkI';
            psor2.Payment_Source_Nickname__c ='1112' ;
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
            
         //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc2.id;
            coco1.Payment_Source_Nickname__c = psor2.id;
            coco1.Payment_Display_Status__c = 'Reversed';
            coco1.ChargentOrders__Payment_Start_Date__c = system.today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Payment_Status__c = 'Recurring';
            coco1.ChargentOrders__Payment_Frequency__c = 'Once';
            coco1.Payment_Type__c = 'P';
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
            insert coco1;
        ApexPages.CurrentPage().getParameters().put('Id',coco1.id);
        Test.startTest();
         //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco2 = new ChargentOrders__ChargentOrder__c();
            coco2.Finance_Account_Number__c = finacc2.id;
            coco2.Payment_Source_Nickname__c = psor2.id;
            coco2.Payment_Display_Status__c = 'Reversed';
            coco2.ChargentOrders__Payment_Start_Date__c = system.today();
            coco2.ChargentOrders__Charge_Amount__c = 120.00;
            coco2.ChargentOrders__Payment_Status__c = 'Recurring';
            coco2.ChargentOrders__Payment_Frequency__c = 'Once';
            coco2.Payment_Type__c = 'P';
            //coco2.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff_Payment').getRecordTypeId();
            insert coco2;
        ApexPages.CurrentPage().getParameters().put('Id',coco2.id);
        
        
        System.assertNotEquals(Null,cbg.id);
        
        
        LyonsCredentials__c lcs = new LyonsCredentials__c();
            lcs.CompanyId__c = '123455';
            lcs.User_Name__c = 'test@gmail.com' ;
            lcs.Password__c = 'kflhkdshfksd12';
            
        insert lcs;
        //Label lab = System.Label.GatewayName;
        //ApexPages.CurrentPage().getParameters().put('gatewayName','gatewayName');
         ApexPages.CurrentPage().getParameters().put('finnumber','1111');
        ApexPages.StandardController con = new ApexPages.StandardController(coco2); 
        PayoffAgentController poac = new PayoffAgentController(con);
        poac.fetchDataPF();
        poac.checkDatevaluePF();
        poac.CancelPayoff();
        poac.savePayOff();
        Test.stopTest();
        }
         
         
        /*
   static testMethod void payoffAgentController_TestMethod1(){
        //Test.setCurrentPage(page.BankAccounts);
        Finance_Account__c finacc2 = new Finance_Account__c();
            finacc2.Finance_Account_Number__c='1112';
            finacc2.Honda_Brand__c = 'AFS';
            finacc2.Payoff_Amount__c = 200.00;
                                 
        insert finacc2; 
        ApexPages.CurrentPage().getParameters().put('finnumber','null');
        System.assertNotEquals(Null, finacc2.id);
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
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
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finacc2.id; 
            psor2.Bank_Name__c = 'ICICkI';
            psor2.Payment_Source_Nickname__c ='1112' ;
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
            
         //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc2.id;
            coco1.Payment_Source_Nickname__c = psor2.id;
            coco1.Payment_Display_Status__c = 'Reversed';
            coco1.ChargentOrders__Payment_Start_Date__c = system.today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Payment_Status__c = 'Recurring';
            coco1.ChargentOrders__Payment_Frequency__c = 'Once';
            coco1.Payment_Type__c = 'P';
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
            insert coco1;
        ApexPages.CurrentPage().getParameters().put('Id',null);
        Test.startTest();
         //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco2 = new ChargentOrders__ChargentOrder__c();
            coco2.Finance_Account_Number__c = finacc2.id;
            coco2.Payment_Source_Nickname__c = psor2.id;
            coco2.Payment_Display_Status__c = 'Reversed';
            coco2.ChargentOrders__Payment_Start_Date__c = system.today();
            coco2.ChargentOrders__Charge_Amount__c = 120.00;
            coco2.ChargentOrders__Payment_Status__c = 'Recurring';
            coco2.ChargentOrders__Payment_Frequency__c = 'Once';
            coco2.Payment_Type__c = 'P';
            //coco2.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff_Payment').getRecordTypeId();
            insert coco2;
        ApexPages.CurrentPage().getParameters().put('Id',null);
        
        
        System.assertNotEquals(Null,cbg.id);
        
        
        LyonsCredentials__c lcs = new LyonsCredentials__c();
            lcs.CompanyId__c = '123455';
            lcs.User_Name__c = 'test@gmail.com' ;
            lcs.Password__c = 'kflhkdshfksd12';
            
        insert lcs;
        //Label lab = System.Label.GatewayName;
        //ApexPages.CurrentPage().getParameters().put('gatewayName','gatewayName');
        
        ApexPages.StandardController con = new ApexPages.StandardController(coco2); 
        PayoffAgentController poac = new PayoffAgentController(con);
        poac.fetchDataPF();
        poac.checkDatevaluePF();
        poac.CancelPayoff();
        poac.savePayOff();
        Test.stopTest();
        }
        */
        static testMethod void payoffAgentController_TestMethod2(){
        //Test.setCurrentPage(page.BankAccounts);
        Finance_Account__c finacc2 = new Finance_Account__c();
            finacc2.Finance_Account_Number__c='1112';
            finacc2.Honda_Brand__c = 'AFS';
            finacc2.Payoff_Amount__c = 200.00;
                 
        insert finacc2; 
        ApexPages.CurrentPage().getParameters().put('finnumber',null);
        System.assertNotEquals(Null, finacc2.id);
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
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
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finacc2.id; 
            psor2.Bank_Name__c = 'ICICkI';
            psor2.Payment_Source_Nickname__c ='1112' ;
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
            
         //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc2.id;
            coco1.Payment_Source_Nickname__c = psor2.id;
            coco1.Payment_Display_Status__c = 'Reversed';
            coco1.ChargentOrders__Payment_Start_Date__c = system.today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Payment_Status__c = 'Recurring';
            coco1.ChargentOrders__Payment_Frequency__c = 'Once';
            coco1.Payment_Type__c = 'P';
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
            insert coco1;
        ApexPages.CurrentPage().getParameters().put('Id',coco1.id);
        Test.startTest();
         //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco2 = new ChargentOrders__ChargentOrder__c();
            coco2.Finance_Account_Number__c = finacc2.id;
            coco2.Payment_Source_Nickname__c = psor2.id;
            coco2.Payment_Display_Status__c = 'Reversed';
            coco2.ChargentOrders__Payment_Start_Date__c = system.today();
            coco2.ChargentOrders__Charge_Amount__c = 120.00;
            coco2.ChargentOrders__Payment_Status__c = 'Recurring';
            coco2.ChargentOrders__Payment_Frequency__c = 'Once';
            coco2.Payment_Type__c = 'P';
            //coco2.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff_Payment').getRecordTypeId();
            insert coco2;
        ApexPages.CurrentPage().getParameters().put('Id',coco2.id);
        
        
        System.assertNotEquals(Null,cbg.id);
        
        
        LyonsCredentials__c lcs = new LyonsCredentials__c();
            lcs.CompanyId__c = '123455';
            lcs.User_Name__c = 'test@gmail.com' ;
            lcs.Password__c = 'kflhkdshfksd12';
            
        insert lcs;
        //Label lab = System.Label.GatewayName;
        //ApexPages.CurrentPage().getParameters().put('gatewayName','gatewayName');
         ApexPages.CurrentPage().getParameters().put('finnumber','1111');
        ApexPages.StandardController con = new ApexPages.StandardController(coco2); 
        PayoffAgentController poac = new PayoffAgentController(con);
        poac.fetchDataPF();
        poac.checkDatevaluePF();
        poac.CancelPayoff();
        poac.savePayOff();
        Test.stopTest();
        }
}