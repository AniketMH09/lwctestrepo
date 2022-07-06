/* @ created Date :9/17/2015 
    @ Author : Hari Charan Nethi  
  */
@isTest
public class BankAcctLandingController_Test{
    static testMethod void bankAcctLandingControllerTestMethod(){
         
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser@testorg.com');
        insert u;

        system.runAs(u)
        {

        Finance_Account__c finacc1 = new Finance_Account__c();
        finacc1.Finance_Account_Number__c='1111';
        finacc1.Honda_Brand__c = 'HFS';
        insert finacc1;
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc1.id;
        cPref.Customer__c=a.Id;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Email_Address__c= 'testhonda@testorg.com';
        cPref.EasyPay_Communications_via_Email__c= true;
        cPref.Text_Number__c = '12345' ;
        cPref.Payment_Confirmations_via_Text__c = true; 
        cPref.EasyPay_Communications_via_Text__c = true;
        cPref.Text_Number__c='9992223334';
        cPref.Statements_Letters__c = 'eDelivery';
        insert cPref;
        
        //Creating Payment_Source__c records
        Payment_Source__c psor = new Payment_Source__c();
        psor.Finance_Account_Number__c = finacc1.id; 
        psor.Bank_Name__c = 'ICICI';
        psor.Payment_Source_Nickname__c = 'Small Bank';
        psor.Bank_Account_Number__c = '1230000004560001';
        PSOR.Status__c = 'Active';
        insert psor; 
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg;

        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Payment_Source_Nickname__c = psor.id;
            coco1.Finance_Account_Number__c = finacc1.id;
            coco1.Payment_Display_Status__c = 'Pending';
            coco1.ChargentOrders__Payment_Start_Date__c=System.today();
        insert coco1; 
          
        Test.setCurrentPage(page.BankAccountsLandingPage);
        
        Apexpages.currentPage().getParameters().put('finnumber', finacc1.Finance_Account_Number__c);
        apexpages.currentpage().getparameters().put('bankaccid', psor.id);
        apexpages.currentpage().getparameters().put('bankid',psor.id);
        Apexpages.currentPage().getParameters().put('isReadOnly','true');
        ApexPages.currentPage().getHeaders().put('User-Agent','SomethingElse');
    Apexpages.currentPage().getParameters().put('param1','SBI');
    Apexpages.currentPage().getParameters().put('param2','BOI');
    Apexpages.currentPage().getParameters().put('param4','BOB');

        BankAcctLandingController balc = new BankAcctLandingController();
        
        balc.save();
        balc.closePopup();
        balc.showPopup();
        balc.Cancel();
        balc.accountoverview();
        balc.Rename();
        balc.Delete1();
        balc.Delete2();
        balc.newbankaccount();
        balc.Updatepreferredbank();
        balc.doNothingMethod();
        balc.checkDevice();
        pagereference p1=balc.redirectToHFS();
        
        ApexPages.currentPage().getHeaders().put('User-Agent','Android');
        balc.checkDevice();
        ApexPages.currentPage().getHeaders().put('User-Agent','BlackBerry');
        balc.checkDevice();
        ApexPages.currentPage().getHeaders().put('User-Agent','IEMobile');
        balc.checkDevice();
        ApexPages.currentPage().getHeaders().put('User-Agent','iPad');
        balc.checkDevice();
        ApexPages.currentPage().getHeaders().put('User-Agent','iPhone');
        balc.checkDevice();
        ApexPages.currentPage().getHeaders().put('User-Agent','iPod');
        balc.checkDevice();
        
        }     
    }
}