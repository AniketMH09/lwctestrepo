/*@ Author : Hari Charan Nethi  
  */
@isTest
public class PaymentSourceControllerExtension_Test{
    static testMethod void PaymentSourceControllerExtension_TestMethod(){
        Test.setCurrentPage(page.BankAccounts);
                ApexPages.CurrentPage().getParameters().put('financeAccount','1112');
        Finance_Account__c finacc2 = new Finance_Account__c();
            finacc2.Finance_Account_Number__c='1112';
            finacc2.Honda_Brand__c = 'AFS';
                 
        insert finacc2; 

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
        ChargentOrders__ChargentOrder__c coco2 = new ChargentOrders__ChargentOrder__c();
            coco2.Finance_Account_Number__c = finacc2.id;
            coco2.Payment_Source_Nickname__c = psor2.id;
            coco2.Payment_Display_Status__c = 'Reversed';
            coco2.ChargentOrders__Payment_Start_Date__c = system.today();
            coco2.ChargentOrders__Charge_Amount__c = 120.00;
            coco2.ChargentOrders__Payment_Status__c = 'Recurring';
            coco2.ChargentOrders__Payment_Frequency__c = 'Once';
            coco2.Payment_Type__c = 'P';
            insert coco2;
        
        
        System.assertNotEquals(Null,cbg.id);
        
        
        LyonsCredentials__c lcs = new LyonsCredentials__c();
            lcs.CompanyId__c = '123455';
            lcs.User_Name__c = 'test@gmail.com' ;
            lcs.Password__c = 'kflhkdshfksd12';
            
        insert lcs;
        //Label lab = System.Label.GatewayName;
        //ApexPages.CurrentPage().getParameters().put('gatewayName','gatewayName');
        
        Test.setMock(WebServiceMock.class , new LyonWebServiceMock());
        
        PageReference pageRef = Page.BankAccounts;
        Test.setCurrentPage(pageRef);
        // ApexPages.CurrentPage().getParameters().put('financeAccount','1152');
        ApexPages.StandardController con = new ApexPages.StandardController(psor2); 
        PaymentSourceControllerExtension psce = new PaymentSourceControllerExtension(con);


        ApexPages.CurrentPage().getHeaders().put('User-Agent', 'null');
        psce.checkDevice();
        
        pagereference p=psce.redirectToHFS();
         
        ApexPages.CurrentPage().getHeaders().put('User-Agent', 'Android');
        
        psce.checkDevice();
        pagereference p1=psce.redirectToHFS();
        psce.doNothingMethod();
        psce.cancel();
        psce.save();
        psce.reviewBankAccounts();
        psce.editBankAccounts();
        //psce.submitBankAccounts();
        psce.validateRoutingNumber();
        psce.bankAccounts();
        psce.paymentPage();
        pagereference p2=psce.initialize();
        psce.displayPopUp();
        psce.hidePopUp();
        try{
        pagereference p3=psce.submitBankAccounts();
        }catch(Exception e){}
        
    }
}