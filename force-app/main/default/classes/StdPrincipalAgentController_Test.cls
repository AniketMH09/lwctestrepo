/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for StdPrincipalAgentController
*****************************************************************************/

@isTest
public class StdPrincipalAgentController_Test{
    private static TestMethod void testOTP(){
    
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Past_Amount_Due__c=2000;
        finacc.Fl_OneTime_Payment_Eligible_Agent__c=true;
        finacc.Fl_Charged_Off__c=true;
        finacc.Principal_Balance_Amount__c=8000;
        //finacc.Remaining_Amount_Due__c =8000;
        finacc.Region_Code__c ='NRC';
        finacc.Payoff_Amount__c=5000;
        insert finacc;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg; 
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        //RecordType rt = [select Id from RecordType where Name ='Recurring Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
        ch.ChargentOrders__Payment_Start_Date__c=System.Today();
        ch.Payment_Display_Status__c='Processing';
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';
        ch.ChargentOrders__Bank_Name__c ='test';
        insert ch;
      
        PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getparameters().put('finnumber', finacc.Finance_Account_Number__c);
        ApexPages.CurrentPage().getparameters().put('Id', ch.Id);
       
     
       
        
        ApexPages.StandardController sc = new ApexPages.standardController(ch);
        StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
        
        c.fetchDataOTP();
        c.SaveEdit(); 
        c.FormValidationRules();
        Pagereference p1=c.SaveRecord(); 
        Pagereference p2=c.SaveAndNewRecord();    
        c.AccountPopulated();
        
    }
        private static TestMethod void testOTP1(){
    
        /*Profile p = [SELECT Id FROM Profile WHERE Name='NRC Agent']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/

            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Finance_Account_Number__c='1111';
            finacc.Past_Amount_Due__c=2000;
            finacc.Total_Amount_Due__c=30000;
            finacc.Paid_to_Date__c =System.today()+10;
            finacc.Payment_Due_Date__c =System.today()+5;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_Future_OneTime_Payment_Eligible_Agent__c=true;
            finacc.Payoff_Amount__c=2000;
            insert finacc;
        
            Id accId=CreateObjectTest.createpersonAccount();
            Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
            Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
            String payNickName=(String)payId;
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
        
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=555550.50;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch.ChargentOrders__Payment_Start_Date__c=System.Today()+2;
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            ch.ChargentOrders__Bank_Name__c='test';
            insert ch;
        //System.runAs(u)
        //{
            PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
            Test.setCurrentPage(pageRef);
        
            ApexPages.CurrentPage().getparameters().put('finnumber', null);
            ApexPages.CurrentPage().getparameters().put('Id', ch.Id);
        
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
        
            c.fetchDataOTP();
            c.SaveNew();   
            //String s=c.redirect();   
            c.AccountPopulated();
            c.PaymentRules();
        //}
        
    }
    private static TestMethod void testOTP2(){
    
        /*Profile p = [SELECT Id FROM Profile WHERE Name='NRC Agent']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/

            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Finance_Account_Number__c='1111';
            finacc.Past_Amount_Due__c=2000;
            finacc.Total_Amount_Due__c=30000;
            finacc.Paid_to_Date__c =System.today()+10;
            finacc.Payment_Due_Date__c =System.today()+5;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_Future_OneTime_Payment_Eligible_Agent__c=true;
            finacc.Payoff_Amount__c=2000;
            insert finacc;
        
            Id accId=CreateObjectTest.createpersonAccount();
            Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
            Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
            String payNickName=(String)payId;
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
        
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=555550.50;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch.ChargentOrders__Payment_Start_Date__c=System.Today()+2;
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            ch.ChargentOrders__Bank_Name__c='test';
            insert ch;
        //System.runAs(u)
        //{
            PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
            Test.setCurrentPage(pageRef);
        
            ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
            ApexPages.CurrentPage().getparameters().put('Id', null);
        
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
        
            c.fetchDataOTP();
            c.SaveNew();   
            //String s=c.redirect();   
            c.AccountPopulated();
            c.PaymentRules();
            
            String bankAccntName=c.bankAccntName;
            Boolean readOnlyPF=c.readOnlyPF;
            Boolean recordTypeName=c.recordTypeName;
        //}
        
    }
     private static TestMethod void testOTP3(){
    
        /*Profile p = [SELECT Id FROM Profile WHERE Name='NRC Agent']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/

            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Finance_Account_Number__c='1111';
            finacc.Past_Amount_Due__c=2000;
            finacc.Total_Amount_Due__c=30000;
            finacc.Principal_Balance_Amount__c =6000;
            finacc.Paid_to_Date__c =System.today()+10;
            finacc.Payment_Due_Date__c =System.today()+5;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_Future_OneTime_Payment_Eligible_Agent__c=false;
            finacc.Payoff_Amount__c=2000;
            insert finacc;
        
            Id accId=CreateObjectTest.createpersonAccount();
            Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
            Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
            String payNickName=(String)payId;
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
        
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch.ChargentOrders__Payment_Start_Date__c=System.today();
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            ch.ChargentOrders__Bank_Name__c='test';
            //insert ch;
        //System.runAs(u)
        //{
            PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
            Test.setCurrentPage(pageRef);
        
            ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
            ApexPages.CurrentPage().getparameters().put('Id', null);
        
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
            c.cOrder = ch;
            c.fetchDataOTP();
            c.isValidRule=true;
            c.SaveAndNewRecord();  
            c.SaveRecord();
            //String s=c.redirect();   
            c.AccountPopulated();
            c.PaymentRules();
            
            String bankAccntName=c.bankAccntName;
            Boolean readOnlyPF=c.readOnlyPF;
            Boolean recordTypeName=c.recordTypeName;
        //}
        
    }
     private static TestMethod void testOTP4(){
    
        /*Profile p = [SELECT Id FROM Profile WHERE Name='NRC Agent']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/

            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Finance_Account_Number__c='1111';
            finacc.Past_Amount_Due__c=2000;
            finacc.account_type__c = 'Retail';
            finacc.Total_Amount_Due__c=30000;
            finacc.Principal_Balance_Amount__c =6000;
            finacc.Paid_to_Date__c =System.today()+10;
            finacc.Payment_Due_Date__c =System.today()+5;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_Future_OneTime_Payment_Eligible_Agent__c=false;
            finacc.Payoff_Amount__c=2000;
            insert finacc;
        
            Id accId=CreateObjectTest.createpersonAccount();
            Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
            Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
            String payNickName=(String)payId;
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
        
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch.ChargentOrders__Payment_Start_Date__c=System.today();
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            ch.ChargentOrders__Bank_Name__c='test';
            //insert ch;
        //System.runAs(u)
        //{
            PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
            Test.setCurrentPage(pageRef);
        
            ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
            ApexPages.CurrentPage().getparameters().put('Id', null);
        
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
            c.cOrder = ch;
            c.fetchDataOTP();
            c.isValidRule=true;
            c.SaveAndNewRecord();  
            c.SaveRecord();
            //String s=c.redirect();   
            c.AccountPopulated();
            c.PaymentRules();
            
            String bankAccntName=c.bankAccntName;
            Boolean readOnlyPF=c.readOnlyPF;
            Boolean recordTypeName=c.recordTypeName;
        //}
        
    }
    private static TestMethod void testOTP5(){
    
        /*Profile p = [SELECT Id FROM Profile WHERE Name='NRC Agent']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/

            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Finance_Account_Number__c='1111';
            finacc.Past_Amount_Due__c=2000;
            finacc.account_type__c = 'Lease';
            finacc.Total_Amount_Due__c=30000;
            finacc.Principal_Balance_Amount__c =6000;
            finacc.Paid_to_Date__c =System.today()+10;
            finacc.Payment_Due_Date__c =System.today()+5;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_Future_OneTime_Payment_Eligible_Agent__c=false;
            finacc.Payoff_Amount__c=2000;
            insert finacc;
        
            Id accId=CreateObjectTest.createpersonAccount();
            Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
            Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
            String payNickName=(String)payId;
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
        
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=7000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch.ChargentOrders__Payment_Start_Date__c= null;
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            ch.ChargentOrders__Bank_Name__c='test';
            //insert ch;
        //System.runAs(u)
        //{
            PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
            Test.setCurrentPage(pageRef);
        
            ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
            ApexPages.CurrentPage().getparameters().put('Id', null);
        
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
            c.cOrder = ch;
            c.fetchDataOTP();
            c.isValidRule=true;
            c.SaveAndNewRecord();  
            c.SaveRecord();
            //String s=c.redirect();   
            c.AccountPopulated();
            c.PaymentRules();
            
            String bankAccntName=c.bankAccntName;
            Boolean readOnlyPF=c.readOnlyPF;
            Boolean recordTypeName=c.recordTypeName;
        //}
        
    }
    private static TestMethod void testOTP6(){
    
        /*Profile p = [SELECT Id FROM Profile WHERE Name='NRC Agent']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/

            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Finance_Account_Number__c='1111';
            finacc.Past_Amount_Due__c=2000;
            finacc.account_type__c = 'Lease';
            finacc.Total_Amount_Due__c=30000;
            finacc.Principal_Balance_Amount__c =6000;
            finacc.Paid_to_Date__c =System.today()+10;
            finacc.Payment_Due_Date__c =System.today()+5;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_Future_OneTime_Payment_Eligible_Agent__c=false;
            finacc.Payoff_Amount__c=2000;
            insert finacc;
        
            Id accId=CreateObjectTest.createpersonAccount();
            Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
            Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
            String payNickName=(String)payId;
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
        
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=7000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch.ChargentOrders__Payment_Start_Date__c= System.today().addDays(-2);
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            ch.ChargentOrders__Bank_Name__c='test';
            //insert ch;
        //System.runAs(u)
        //{
            PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
            Test.setCurrentPage(pageRef);
        
            ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
            ApexPages.CurrentPage().getparameters().put('Id', null);
        
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
            c.cOrder = ch;
            c.fetchDataOTP();
            c.isValidRule=true;
            c.SaveAndNewRecord();  
            c.SaveRecord();
            //String s=c.redirect();   
            c.AccountPopulated();
            c.PaymentRules();
            
            String bankAccntName=c.bankAccntName;
            Boolean readOnlyPF=c.readOnlyPF;
            Boolean recordTypeName=c.recordTypeName;
        //}
        
    }
    private static TestMethod void testOTP7(){
    
        /*Profile p = [SELECT Id FROM Profile WHERE Name='NRC Agent']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/

            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Fl_OneTime_Payment_Eligible_Agent__c = true;
            finacc.Finance_Account_Number__c='1111';
            finacc.Past_Amount_Due__c=2000;
            finacc.account_type__c = 'Lease';
            finacc.Total_Amount_Due__c=30000;
            finacc.Principal_Balance_Amount__c =6000;
            finacc.Paid_to_Date__c =System.today()+10;
            finacc.Payment_Due_Date__c =System.today()+5;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_Future_OneTime_Payment_Eligible_Agent__c=true;
            finacc.Payoff_Amount__c=2000;
            insert finacc;
        
            Id accId=CreateObjectTest.createpersonAccount();
            Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
            Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
            String payNickName=(String)payId;
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
        
        //System.runAs(u)
        //{
            PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
            Test.setCurrentPage(pageRef);
        
            ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
            ApexPages.CurrentPage().getparameters().put('Id', null);
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=null;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch.ChargentOrders__Payment_Start_Date__c = System.today().addDays(-5);
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            ch.ChargentOrders__Bank_Name__c='test';
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
            
            c.cOrder = ch;
            c.fetchDataOTP();
            c.isValidRule=true;
            c.SaveAndNewRecord();  
            c.SaveRecord();
            //String s=c.redirect();   
            c.AccountPopulated();
            c.PaymentRules();
            
            String bankAccntName=c.bankAccntName;
            Boolean readOnlyPF=c.readOnlyPF;
            Boolean recordTypeName=c.recordTypeName;
        //}
        
    }
    private static TestMethod void testOTP8(){
    
        /*Profile p = [SELECT Id FROM Profile WHERE Name='NRC Agent']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/

            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Fl_OneTime_Payment_Eligible_Agent__c = true;
            finacc.Finance_Account_Number__c='1111';
            finacc.Past_Amount_Due__c=2000;
            finacc.account_type__c = 'Lease';
            finacc.Total_Amount_Due__c=30000;
            finacc.Principal_Balance_Amount__c =6000;
            finacc.Paid_to_Date__c =System.today()+10;
            finacc.Payment_Due_Date__c =System.today()+5;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_Future_OneTime_Payment_Eligible_Agent__c=true;
            finacc.Payoff_Amount__c=2000;
            insert finacc;
        
            Id accId=CreateObjectTest.createpersonAccount();
            Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
            Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
            String payNickName=(String)payId;
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
            
            ChargentOrders__ChargentOrder__c ch1=new ChargentOrders__ChargentOrder__c ();
            ch1.Finance_Account_Number__c=finacc.Id;
            ch1.Payment_Type__c = 'O';
            ch1.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch1.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch1.ChargentOrders__Payment_Start_Date__c = System.today().addDays(-5);
            ch1.Payment_Display_Status__c='Pending';
            ch1.ChargentOrders__Payment_Status__c='Recurring';
            ch1.ChargentOrders__Payment_Frequency__c='Once';
            ch1.Payment_Source_Nickname__c=payNickName;
            ch1.ChargentOrders__Bank_Name__c='test';
            insert ch1;
            System.debug('Inserted id'+ch1.id+ch1);
        //System.runAs(u)
        //{
            PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
            Test.setCurrentPage(pageRef);
        
            //ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
            ApexPages.CurrentPage().getparameters().put('Id', ch1.id);
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch.ChargentOrders__Payment_Start_Date__c = System.today().addDays(-5);
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            ch.ChargentOrders__Bank_Name__c='test';
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
            
            c.cOrder = ch;
            c.fetchDataOTP();
            c.PaymentRules();
            c.isValidRule=true;
            c.SaveAndNewRecord();  
            c.SaveRecord();
            //String s=c.redirect();   
            c.AccountPopulated();
            c.PaymentRules();
            
            String bankAccntName=c.bankAccntName;
            Boolean readOnlyPF=c.readOnlyPF;
            Boolean recordTypeName=c.recordTypeName;
        //}
        
    }
    private static TestMethod void testOTP9(){
    
        /*Profile p = [SELECT Id FROM Profile WHERE Name='NRC Agent']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/

            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Fl_OneTime_Payment_Eligible_Agent__c = true;
            finacc.Finance_Account_Number__c='1111';
            finacc.Past_Amount_Due__c=2000;
            finacc.account_type__c = 'Lease';
            finacc.Total_Amount_Due__c=30000;
            finacc.Principal_Balance_Amount__c =6000;
            finacc.Paid_to_Date__c =System.today()+10;
            finacc.Payment_Due_Date__c =System.today()+5;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_Future_OneTime_Payment_Eligible_Agent__c=false;
            finacc.Payoff_Amount__c=2000;
            insert finacc;
        
            Id accId=CreateObjectTest.createpersonAccount();
            Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
            Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
            String payNickName=(String)payId;
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
            
            ChargentOrders__ChargentOrder__c ch1=new ChargentOrders__ChargentOrder__c ();
            ch1.Finance_Account_Number__c=finacc.Id;
            ch1.Payment_Type__c = 'O';
            ch1.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch1.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch1.ChargentOrders__Payment_Start_Date__c = System.today().addDays(100);
            ch1.Payment_Display_Status__c='Pending';
            ch1.ChargentOrders__Payment_Status__c='Recurring';
            ch1.ChargentOrders__Payment_Frequency__c='Once';
            ch1.Payment_Source_Nickname__c=payNickName;
            ch1.ChargentOrders__Bank_Name__c='test';
            insert ch1;
            System.debug('Inserted id'+ch1.id+ch1);
        //System.runAs(u)
        //{
            PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
            Test.setCurrentPage(pageRef);
        
            //ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
            ApexPages.CurrentPage().getparameters().put('Id', ch1.id);
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch.ChargentOrders__Payment_Start_Date__c = null;
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            ch.ChargentOrders__Bank_Name__c='test';
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
            
            c.cOrder = ch;
            c.fetchDataOTP();
            c.PaymentRules();
            c.isValidRule=true;
            c.SaveAndNewRecord();  
            c.SaveRecord();
            //String s=c.redirect();   
            c.AccountPopulated();
            c.PaymentRules();
            
            String bankAccntName=c.bankAccntName;
            Boolean readOnlyPF=c.readOnlyPF;
            Boolean recordTypeName=c.recordTypeName;
        //}
        
    }
    private static TestMethod void testOTP11(){
    
        /*Profile p = [SELECT Id FROM Profile WHERE Name='NRC Agent']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/

            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Fl_OneTime_Payment_Eligible_Agent__c = true;
            finacc.Fl_Charged_Off__c = true;
            finacc.Finance_Account_Number__c='1111';
            finacc.Past_Amount_Due__c = 2000;
            finacc.account_type__c = 'Lease';
            finacc.Total_Amount_Due__c=30000;
            finacc.Principal_Balance_Amount__c =6000;
            finacc.Paid_to_Date__c =System.today()+10;
            finacc.Payment_Due_Date__c =System.today()+5;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_Future_OneTime_Payment_Eligible_Agent__c=true;
            finacc.Payoff_Amount__c=2000;
            insert finacc;
        
            Id accId=CreateObjectTest.createpersonAccount();
            Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
            Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
            String payNickName=(String)payId;
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
            
            ChargentOrders__ChargentOrder__c ch1=new ChargentOrders__ChargentOrder__c ();
            ch1.Finance_Account_Number__c=finacc.Id;
            ch1.Payment_Type__c = 'O';
            ch1.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch1.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch1.ChargentOrders__Payment_Start_Date__c = System.today().addDays(100);
            ch1.Payment_Display_Status__c='Pending';
            ch1.ChargentOrders__Payment_Status__c='Recurring';
            ch1.ChargentOrders__Payment_Frequency__c='Once';
            ch1.Payment_Source_Nickname__c=payNickName;
            ch1.ChargentOrders__Bank_Name__c='test';
            insert ch1;
            System.debug('Inserted id'+ch1.id+ch1);
        //System.runAs(u)
        //{
            PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
            Test.setCurrentPage(pageRef);
        
            //ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
            ApexPages.CurrentPage().getparameters().put('Id', ch1.id);
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch.ChargentOrders__Payment_Start_Date__c = System.today().addDays(100);
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            ch.ChargentOrders__Bank_Name__c='test';
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
            
            c.cOrder = ch;
            c.fetchDataOTP();
            c.PaymentRules();
            c.isValidRule=true;
            c.SaveAndNewRecord();  
            c.SaveRecord();
            //String s=c.redirect();   
            c.AccountPopulated();
            c.PaymentRules();
            
            String bankAccntName=c.bankAccntName;
            Boolean readOnlyPF=c.readOnlyPF;
            Boolean recordTypeName=c.recordTypeName;
        //}
        
    }
    private static TestMethod void testOTP12(){
    
        /*Profile p = [SELECT Id FROM Profile WHERE Name='NRC Agent']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/

            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Fl_OneTime_Payment_Eligible_Agent__c = true;
            finacc.Fl_Charged_Off__c = false;
            finacc.Finance_Account_Number__c='1111';
            finacc.Past_Amount_Due__c = 2000;
            finacc.account_type__c = 'Lease';
            finacc.Total_Amount_Due__c=30000;
            finacc.Principal_Balance_Amount__c =6000;
            finacc.Paid_to_Date__c =System.today()+10;
            finacc.Payment_Due_Date__c =System.today()+5;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_Future_OneTime_Payment_Eligible_Agent__c=true;
            finacc.Payoff_Amount__c=2000;
            insert finacc;
        
            Id accId=CreateObjectTest.createpersonAccount();
            Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
            Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
            String payNickName=(String)payId;
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
            
            ChargentOrders__ChargentOrder__c ch1=new ChargentOrders__ChargentOrder__c ();
            ch1.Finance_Account_Number__c=finacc.Id;
            ch1.Payment_Type__c = 'O';
            ch1.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch1.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch1.ChargentOrders__Payment_Start_Date__c = System.today().addDays(100);
            ch1.Payment_Display_Status__c='Pending';
            ch1.ChargentOrders__Payment_Status__c='Recurring';
            ch1.ChargentOrders__Payment_Frequency__c='Once';
            ch1.Payment_Source_Nickname__c=payNickName;
            ch1.ChargentOrders__Bank_Name__c='test';
            insert ch1;
            System.debug('Inserted id'+ch1.id+ch1);
        //System.runAs(u)
        //{
            PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
            Test.setCurrentPage(pageRef);
        
            //ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
            ApexPages.CurrentPage().getparameters().put('Id', ch1.id);
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch.ChargentOrders__Payment_Start_Date__c = System.today().addDays(100);
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            ch.ChargentOrders__Bank_Name__c='test';
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
            
            c.cOrder = ch;
            c.fetchDataOTP();
            c.PaymentRules();
            c.isValidRule=true;
            c.SaveAndNewRecord();  
            c.SaveRecord();
            //String s=c.redirect();   
            c.AccountPopulated();
            c.PaymentRules();
            
            String bankAccntName=c.bankAccntName;
            Boolean readOnlyPF=c.readOnlyPF;
            Boolean recordTypeName=c.recordTypeName;
        //}
        
    }
    private static TestMethod void testOTP13(){
    
        /*Profile p = [SELECT Id FROM Profile WHERE Name='NRC Agent']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/

            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Fl_OneTime_Payment_Eligible_Agent__c = true;
            finacc.Fl_Charged_Off__c = false;
            finacc.Finance_Account_Number__c='1111';
            finacc.Past_Amount_Due__c = 0;
            finacc.account_type__c = 'Lease';
            finacc.Total_Amount_Due__c=30000;
            finacc.Principal_Balance_Amount__c =6000;
            finacc.Paid_to_Date__c =System.today()+10;
            finacc.Payment_Due_Date__c =System.today()+5;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_Future_OneTime_Payment_Eligible_Agent__c=true;
            finacc.Payoff_Amount__c=2000;
            insert finacc;
        
            Id accId=CreateObjectTest.createpersonAccount();
            Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
            Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
            String payNickName=(String)payId;
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
            
            ChargentOrders__ChargentOrder__c ch1=new ChargentOrders__ChargentOrder__c ();
            ch1.Finance_Account_Number__c=finacc.Id;
            ch1.Payment_Type__c = 'O';
            ch1.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch1.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch1.ChargentOrders__Payment_Start_Date__c = System.today().addDays(365);
            ch1.Payment_Display_Status__c='Pending';
            ch1.ChargentOrders__Payment_Status__c='Recurring';
            ch1.ChargentOrders__Payment_Frequency__c='Once';
            ch1.Payment_Source_Nickname__c=payNickName;
            ch1.ChargentOrders__Bank_Name__c='test';
            insert ch1;
            System.debug('Inserted id'+ch1.id+ch1);
        //System.runAs(u)
        //{
            PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
            Test.setCurrentPage(pageRef);
        
            //ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
            ApexPages.CurrentPage().getparameters().put('Id', ch1.id);
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch.ChargentOrders__Payment_Start_Date__c = System.today().addDays(365);
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            ch.ChargentOrders__Bank_Name__c='test';
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
            
            c.cOrder = ch;
            c.fetchDataOTP();
            c.PaymentRules();
            c.isValidRule=true;
            c.SaveAndNewRecord();  
            c.SaveRecord();
            //String s=c.redirect();   
            c.AccountPopulated();
            c.PaymentRules();
            
            String bankAccntName=c.bankAccntName;
            Boolean readOnlyPF=c.readOnlyPF;
            Boolean recordTypeName=c.recordTypeName;
        //}
        
    }
    private static TestMethod void testOTP14(){
    
        /*Profile p = [SELECT Id FROM Profile WHERE Name='NRC Agent']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/

            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Fl_OneTime_Payment_Eligible_Agent__c = true;
            finacc.Fl_Charged_Off__c = false;
            finacc.Finance_Account_Number__c='1111';
            finacc.Past_Amount_Due__c = 0;
            finacc.account_type__c = 'Lease';
            finacc.Total_Amount_Due__c=30000;
            finacc.Principal_Balance_Amount__c =6000;
            finacc.Paid_to_Date__c =System.today()+10;
            finacc.Payment_Due_Date__c =System.today()+5;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_Future_OneTime_Payment_Eligible_Agent__c=true;
            finacc.Payoff_Amount__c=2000;
            insert finacc;
        
            Id accId=CreateObjectTest.createpersonAccount();
            Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
            Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
            String payNickName=(String)payId;
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
            
            ChargentOrders__ChargentOrder__c ch1=new ChargentOrders__ChargentOrder__c ();
            ch1.Finance_Account_Number__c=finacc.Id;
            ch1.Payment_Type__c = 'O';
            ch1.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch1.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch1.ChargentOrders__Payment_Start_Date__c = System.today().addDays(75);
            ch1.Payment_Display_Status__c='Pending';
            ch1.ChargentOrders__Payment_Status__c='Recurring';
            ch1.ChargentOrders__Payment_Frequency__c='Once';
            ch1.Payment_Source_Nickname__c=payNickName;
            ch1.ChargentOrders__Bank_Name__c='test';
            insert ch1;
            System.debug('Inserted id'+ch1.id+ch1);
        //System.runAs(u)
        //{
            PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
            Test.setCurrentPage(pageRef);
        
            //ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
            ApexPages.CurrentPage().getparameters().put('Id', ch1.id);
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch.ChargentOrders__Payment_Start_Date__c = System.today().addDays(75);
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            ch.ChargentOrders__Bank_Name__c='test';
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
            
            c.cOrder = ch;
            c.fetchDataOTP();
            c.PaymentRules();
            c.isValidRule=true;
            c.SaveAndNewRecord();  
            c.SaveRecord();
            //String s=c.redirect();   
            c.AccountPopulated();
            c.PaymentRules();
            
            String bankAccntName=c.bankAccntName;
            Boolean readOnlyPF=c.readOnlyPF;
            Boolean recordTypeName=c.recordTypeName;
        //}
        
    }
    private static TestMethod void testOTP15(){
    
        /*Profile p = [SELECT Id FROM Profile WHERE Name='NRC Agent']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/

            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Fl_OneTime_Payment_Eligible_Agent__c = true;
            finacc.Fl_Charged_Off__c = false;
            finacc.Finance_Account_Number__c='1111';
            finacc.Past_Amount_Due__c = 0;
            finacc.account_type__c = 'Lease';
            finacc.Total_Amount_Due__c=30000;
            finacc.Principal_Balance_Amount__c =6000;
            finacc.Paid_to_Date__c =System.today()+10;
            finacc.Payment_Due_Date__c =System.today()+5;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_Future_OneTime_Payment_Eligible_Agent__c=true;
            finacc.Payoff_Amount__c=2000;
            insert finacc;
        
            Id accId=CreateObjectTest.createpersonAccount();
            Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
            Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
            String payNickName=(String)payId;
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
            
            ChargentOrders__ChargentOrder__c ch1=new ChargentOrders__ChargentOrder__c ();
            ch1.Finance_Account_Number__c=finacc.Id;
            ch1.Payment_Type__c = 'O';
            ch1.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch1.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch1.ChargentOrders__Payment_Start_Date__c = System.today().addDays(75);
            ch1.Payment_Display_Status__c='Pending';
            ch1.ChargentOrders__Payment_Status__c='Recurring';
            ch1.ChargentOrders__Payment_Frequency__c='Once';
            ch1.Payment_Source_Nickname__c=payNickName;
            ch1.ChargentOrders__Bank_Name__c='test';
            insert ch1;
            System.debug('Inserted id'+ch1.id+ch1);
        //System.runAs(u)
        //{
            PageReference pageRef = Page.VFP_PrincipalOneTimePayment;
            Test.setCurrentPage(pageRef);
        
            ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
            //ApexPages.CurrentPage().getparameters().put('Id', ch1.id);
            ApexPages.CurrentPage().getparameters().put('isfromBank', 'true');
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Principal One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
            ch.ChargentOrders__Payment_Start_Date__c = System.today().addDays(75);
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            ch.ChargentOrders__Bank_Name__c='test';
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdPrincipalAgentController c=new StdPrincipalAgentController(sc);
            
            c.cOrder = ch;
            c.fetchDataOTP();
            c.PaymentRules();
            c.isValidRule=true;
            c.SaveAndNewRecord();  
            c.SaveRecord();
            //String s=c.redirect();   
            c.AccountPopulated();
            c.PaymentRules();
            c.cancelPayment();
            String bankAccntName=c.bankAccntName;
            Boolean readOnlyPF=c.readOnlyPF;
            Boolean recordTypeName=c.recordTypeName;
        //}
        
    }
}