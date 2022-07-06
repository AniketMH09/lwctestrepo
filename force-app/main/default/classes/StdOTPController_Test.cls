/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for StdOTPController
*****************************************************************************/

@isTest
public class StdOTPController_Test{
    //@isTest(seeAllData=true)
    private static testmethod void testOTP2(){
        
        Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='5123';
            finacc1.Past_Amount_Due__c=2000;
            finacc1.Total_Amount_Due__c=30000;
            finacc1.Paid_to_Date__c =System.today()+10;
            finacc1.Payment_Due_Date__c =System.today()-2;
            finacc1.Maturity_Date__c=System.Today()+30;
            finacc1.Fl_OneTime_Payment_Eligible_Agent__c=false;
            finacc1.Fl_Charged_Off__c=false;
            finacc1.Payoff_Amount__c=3335555.685;

        insert finacc1;
        
        Id accId=CreateObjectTest.createpersonAccount();
        Id cId=CreateObjectTest.createCommunicationPreferences(finacc1.Id,accId);
        Id payId=CreateObjectTest.createPaymentSource(finacc1.Id);
        String payNickName=(String)payId;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg; 
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c=finacc1.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=255764.56;
        RecordType rt = [select Id from RecordType where Name ='Recurring Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
        ch.RecordTypeId=rt.Id;
        ch.ChargentOrders__Payment_Start_Date__c=System.Today()+2;
        ch.Payment_Display_Status__c='Pending';
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';
        ch.Payment_Source_Nickname__c=payNickName;
        insert ch;
        
        PageReference pageRef = Page.CheckOTP;
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getparameters().put('finnumber', finacc1.Finance_Account_Number__c);
        ApexPages.CurrentPage().getparameters().put('Id',null);
        
        ApexPages.StandardController sc = new ApexPages.standardController(ch);
        StdOTPController c=new StdOTPController(sc);
        
        Pagereference p=c.saveOTP();
        Pagereference p1=c.saveandnewOTP();    
        Pagereference p2=c.CancelOTP();
        c.AccountPopulated();
        c.FromValidationRules();
        c.checkDatevalueOTP();
        
    }
    //@isTest(seeAllData=true)
    private static testmethod void testOTP3(){
        
        Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='5123';
            finacc1.Past_Amount_Due__c=2000;
            finacc1.Total_Amount_Due__c=30000;
            finacc1.Paid_to_Date__c =System.today()+10;
            finacc1.Payment_Due_Date__c =System.today()-2;
            finacc1.Maturity_Date__c=System.Today()+30;
            finacc1.Fl_OneTime_Payment_Eligible_Agent__c=false;
            finacc1.Fl_Charged_Off__c=false;
            finacc1.Payoff_Amount__c=3335555.685;

        insert finacc1;
        
        Id accId=CreateObjectTest.createpersonAccount();
        Id cId=CreateObjectTest.createCommunicationPreferences(finacc1.Id,accId);
        Id payId=CreateObjectTest.createPaymentSource(finacc1.Id);
        String payNickName=(String)payId;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg; 
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c=finacc1.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=255764.56;
        RecordType rt = [select Id from RecordType where Name ='Recurring Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
        ch.RecordTypeId=rt.Id;
        ch.ChargentOrders__Payment_Start_Date__c=System.Today()+2;
        ch.Payment_Display_Status__c='Pending';
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';
        ch.Payment_Source_Nickname__c=payNickName;
        insert ch;
        
        PageReference pageRef = Page.CheckOTP;
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getparameters().put('finnumber', finacc1.Finance_Account_Number__c);
        ApexPages.CurrentPage().getparameters().put('Id',ch.Id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(ch);
        StdOTPController c=new StdOTPController(sc);
        
        Pagereference p=c.saveOTP();
        Pagereference p1=c.saveandnewOTP();    
        Pagereference p2=c.CancelOTP();
        c.AccountPopulated();
        c.FromValidationRules();
        c.checkDatevalueOTP();
        
    }
        private static TestMethod void testOTP(){
    
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Past_Amount_Due__c=2000;
        finacc.Payoff_Amount__c=1000;

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
        ch.ChargentOrders__Charge_Amount__c=null;
        RecordType rt = [select Id from RecordType where Name ='Recurring Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
        ch.RecordTypeId=rt.Id;
        ch.ChargentOrders__Payment_Start_Date__c=System.Today()+2;
        ch.Payment_Display_Status__c='Processing';
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';
        ch.Payment_Source_Nickname__c=null;
        insert ch;
        
        PageReference pageRef = Page.CheckOTP;
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getparameters().put('finnumber', finacc.Finance_Account_Number__c);
        ApexPages.CurrentPage().getparameters().put('Id', ch.Id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(ch);
        StdOTPController c=new StdOTPController(sc);
        
        Pagereference p=c.saveOTP();
        Pagereference p1=c.saveandnewOTP();    
        Pagereference p2=c.CancelOTP();
        c.AccountPopulated();
        c.FromValidationRules();
        c.checkDatevalueOTP();
        
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
            finacc.Payment_Due_Date__c =System.today()-2;
            finacc.Maturity_Date__c=System.Today()+30;
            finacc.Fl_OneTime_Payment_Eligible_Agent__c=true;
            finacc.Fl_Charged_Off__c=false;
            finacc.Payoff_Amount__c=1000;
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
            ch.ChargentOrders__Charge_Amount__c=251550;
            RecordType rt = [select Id from RecordType where Name ='Standard One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            ch.RecordTypeId=rt.Id;
            ch.ChargentOrders__Payment_Start_Date__c=System.Today()-5;
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            insert ch;
        //System.runAs(u)
        //{
            PageReference pageRef = Page.CheckOTP;
            Test.setCurrentPage(pageRef);
        
            ApexPages.CurrentPage().getparameters().put('finnumber', null);
            ApexPages.CurrentPage().getparameters().put('Id', ch.Id);
        
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdOTPController c=new StdOTPController(sc);
        
            Pagereference p3=c.saveOTP();
            Pagereference p1=c.saveandnewOTP();    
            Pagereference p2=c.CancelOTP();
        	Pagereference p5=c.cancelPayment();
            c.AccountPopulated();
            String s=c.finIDVF;
            String s1=c.OTPid;
            String s2=c.fname;
            String s3=c.BankaccntNameotp;
            String s4=c.ReviewBanknameOTP;
            String s5=c.reviewBankName;
            String s6=c.chargeDate;
            String s7=c.reviewDate;
            String s8=c.confirmationStandard;
            String s9=c.RecordSelect;
            String s10=c.paymentStartDate;
            String s11=c.confirmationStd;
            
            Date d=c.NextTransactionDate;
            
            Boolean b=c.recordTypeName;
            Boolean b1=c.suspendedStatus;
        //}
        
    }
    
     private static TestMethod void testOTP22(){
    
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
            finacc.Fl_OneTime_Payment_Eligible_Agent__c=true;
            finacc.Fl_Charged_Off__c=false;
            finacc.Payoff_Amount__c=1000;
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
            ch.ChargentOrders__Charge_Amount__c=251550;
         	ch.Next_Withdrawal_Date__c = system.today();
         
           RecordType recType = [Select ID,name,DeveloperName from RecordType where DeveloperName = 'Recurring_Payment'];	
            ch.RecordTypeId=recType.Id;
            ch.ChargentOrders__Payment_Start_Date__c=System.Today()-5;
            ch.Payment_Display_Status__c='Pending';
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c='Once';
            ch.Payment_Source_Nickname__c=payNickName;
            insert ch;
        //System.runAs(u)
        //{
            PageReference pageRef = Page.CheckOTP;
            Test.setCurrentPage(pageRef);
        
            ApexPages.CurrentPage().getparameters().put('finnumber', null);
            ApexPages.CurrentPage().getparameters().put('Id', ch.Id);
        
            ApexPages.StandardController sc = new ApexPages.standardController(ch);
            StdOTPController c=new StdOTPController(sc);
        
            Pagereference p3=c.saveOTP();
            Pagereference p1=c.saveandnewOTP();    
            Pagereference p2=c.CancelOTP();
        	Pagereference p5=c.cancelPayment();
            c.AccountPopulated();
            String s=c.finIDVF;
            String s1=c.OTPid;
            String s2=c.fname;
            String s3=c.BankaccntNameotp;
            String s4=c.ReviewBanknameOTP;
            String s5=c.reviewBankName;
            String s6=c.chargeDate;
            String s7=c.reviewDate;
            String s8=c.confirmationStandard;
            String s9=c.RecordSelect;
            String s10=c.paymentStartDate;
            String s11=c.confirmationStd;
            
            Date d=c.NextTransactionDate;
            
            Boolean b=c.recordTypeName;
            Boolean b1=c.suspendedStatus;
        //}
        
    }
}