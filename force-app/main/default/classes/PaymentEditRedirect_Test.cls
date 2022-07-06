/*@ Author : Hari Charan Nethi  
  */
@isTest
public class PaymentEditRedirect_Test{
    static testMethod void paymentEditRedirect_TestMethod(){
    
    // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Agent']; 
        User u = new User(Alias = 'testu', Email='testagentuser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tes', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testagentuser@testorg.com');
            
        insert u;
       system.runAs(u){ 
     //Creating List of Finance_Account__c records
        List<Finance_Account__c> finaccList = new List<Finance_Account__c>();
        Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1111';
            finacc1.Honda_Brand__c = 'Unicorn';
           
        Finance_Account__c finacc2 = new Finance_Account__c();
            finacc2.Finance_Account_Number__c='1112';
            finacc2.Honda_Brand__c = 'AFS';
        
        Finance_Account__c finacc3 = new Finance_Account__c();
            finacc3.Finance_Account_Number__c='1113';
            finacc3.Honda_Brand__c = 'AFS';
        
        finaccList.add(finacc1);
        finaccList.add(finacc2);
        finaccList.add(finacc3);
        
        insert finaccList; 
        
        System.assertNotEquals(Null, finacc1.id);
        System.assertNotEquals(Null, finacc2.id);
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        List<Communication_Preferences__c> cprefList = new List<Communication_Preferences__c>();
        
        Communication_Preferences__c cPref1 = new Communication_Preferences__c();
        cPref1.Finance_Account_Number__c=finacc1.id;
        cPref1.Customer__c=a.Id;
        cPref1.Payment_Confirmations_via_Email__c=true;
        cPref1.Payment_Reminders_via_Text__c=true;
        cPref1.Email_Address__c= 'testhonda@testorg.com';
        cPref1.EasyPay_Communications_via_Email__c= true;
        cPref1.Text_Number__c = '12345' ;
        cPref1.Payment_Confirmations_via_Text__c = true; 
        cPref1.EasyPay_Communications_via_Text__c = true;
        cPref1.Text_Number__c='9992223334';
        cPref1.Statements_Letters__c = 'eDelivery';
        
        cprefList.add(cPref1);
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
        cPref2.Customer__c=a.Id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        cPref2.Email_Address__c= 'testhonda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Text_Number__c = '12345' ;
        cPref2.Payment_Confirmations_via_Text__c = true; 
        cPref2.EasyPay_Communications_via_Text__c = true;
        cPref2.Text_Number__c='9992223334';
        cPref2.Statements_Letters__c = 'eDelivery';
        cprefList.add(cPref2);
        
        insert cprefList ;
        
        List<Payment_Source__c> psorList = new List<Payment_Source__c>();
        
        //Creating Payment_Source__c records
        Payment_Source__c psor1 = new Payment_Source__c();
            psor1.Finance_Account_Number__c = finacc1.id; 
            psor1.Bank_Name__c = 'ICICI';
            psor1.Payment_Source_Nickname__c ='1111' ;
            psor1.Bank_Account_Number__c = '1230000004560001';
            psor1.Bank_Account_Type__c = 's';
            psor1.Bank_Routing_Number__c = 'IKBL01238';
            psor1.Status__c = 'Active';
        
        psorList.add(psor1); 
        
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finacc1.id; 
            psor2.Bank_Name__c = 'ICICI';
            psor2.Payment_Source_Nickname__c ='1112' ;
            psor2.Bank_Account_Number__c = '1230000004560001';
            psor2.Bank_Account_Type__c = 's';
            psor2.Bank_Routing_Number__c = 'IKBL01238';
            psor2.Status__c = 'Active';
        
        psorList.add(psor2); 
        
        
        //Creating Payment_Source__c records
        Payment_Source__c psor3 = new Payment_Source__c();
            psor3.Finance_Account_Number__c = finacc1.id; 
            psor3.Bank_Name__c = 'ICICI';
            psor3.Payment_Source_Nickname__c ='1113' ;
            psor3.Bank_Account_Number__c = '1230000004560001';
            psor3.Bank_Account_Type__c = 's';
            psor3.Bank_Routing_Number__c = 'IKBL01238';
            psor3.Status__c = 'Active';
        
        psorList.add(psor3); 
        
        insert psorList;
        
        System.assertNotEquals(Null,psor2.id);
        System.assertNotEquals(Null,psor1.id);
        System.assertNotEquals(Null,psor3.id);
        
        //apexpages.currentpage().getparameters().put('bankaccid', psor.id);
        //apexpages.currentpage().getparameters().put('bankid',psor.id);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        
        insert cbg;
        
        //Creating List of ChargentOrders__ChargentOrder__c records
        //List<ChargentOrders__ChargentOrder__c> cocoList = new List<ChargentOrders__ChargentOrder__c>();
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc1.id;
            coco1.Payment_Source_Nickname__c = psor1.id;
            coco1.Payment_Display_Status__c = 'Researching';
            coco1.ChargentOrders__Payment_Start_Date__c = system.today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Gateway__c  = cbg.Id;
            //coco1.recordtypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
          insert coco1;  
         //cocoList.add(coco1);
         
         ChargentOrders__ChargentOrder__c coco2 = new ChargentOrders__ChargentOrder__c();
            coco2.Finance_Account_Number__c = finacc1.id;
            coco2.Payment_Source_Nickname__c = psor2.id;
            coco2.Payment_Display_Status__c = 'Cancelled';
            coco2.ChargentOrders__Payment_Start_Date__c = system.today();
            coco2.ChargentOrders__Charge_Amount__c = 120.00;
            coco2.ChargentOrders__Gateway__c  = cbg.Id;

          insert coco2;
         //cocoList.add(coco2);
         
         ChargentOrders__ChargentOrder__c coco3 = new ChargentOrders__ChargentOrder__c();
            coco3.Finance_Account_Number__c = finacc1.id;
            coco3.Payment_Source_Nickname__c = psor3.id;
            coco3.Payment_Display_Status__c = 'Processing';
            coco3.ChargentOrders__Payment_Start_Date__c = system.today().addDays(-2);
            coco3.ChargentOrders__Charge_Amount__c = 120.00;
            coco3.ChargentOrders__Gateway__c  = cbg.Id;  
            coco3.recordtypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();  
        insert coco3;       
        // cocoList.add(coco3);
         
         ChargentOrders__ChargentOrder__c coco4 = new ChargentOrders__ChargentOrder__c();
            coco4.Finance_Account_Number__c = finacc1.id;
            coco4.Payment_Source_Nickname__c = psor3.id;
            coco4.Payment_Display_Status__c = 'Complete';
            coco4.ChargentOrders__Payment_Start_Date__c = system.today();
            coco4.ChargentOrders__Charge_Amount__c = 120.00;
            coco4.ChargentOrders__Gateway__c  = cbg.Id;   
            coco4.recordtypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();       
         insert coco4;
         //cocoList.add(coco4);
         
         ChargentOrders__ChargentOrder__c coco5 = new ChargentOrders__ChargentOrder__c();
            coco5.Finance_Account_Number__c = finacc1.id;
            coco5.Payment_Source_Nickname__c = psor3.id;
            coco5.Payment_Display_Status__c = 'Stopped';
            coco5.ChargentOrders__Payment_Start_Date__c = system.today();
            coco5.ChargentOrders__Charge_Amount__c = 120.00;
            coco5.ChargentOrders__Gateway__c  = cbg.Id;
            coco5.ChargentOrders__Payment_Frequency__c = 'NCe';
            coco5.ChargentOrders__Payment_Status__c = 'Recurring';
            coco5.recordtypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();        
         insert coco5;
         //cocoList.add(coco5);
         
         //insert cocoList;
         
         ApexPages.CurrentPage().getParameters().put('finnumber','1111');
         ApexPages.CurrentPage().getParameters().put('Id',coco1.id);
          
         
         ApexPages.CurrentPage().getParameters().put('finnumber','1112');
         ApexPages.CurrentPage().getParameters().put('Id',coco2.id);
         
         ApexPages.CurrentPage().getParameters().put('finnumber','1113');
         ApexPages.CurrentPage().getParameters().put('Id',coco3.id);
         ApexPages.CurrentPage().getParameters().put('Id',coco4.id);   
        /*
        ChargentOrders__ChargentOrder__c coco2 = new ChargentOrders__ChargentOrder__c();
            coco2.Finance_Account_Number__c = psor.id;
            coco2.Payment_Source_Nickname__c = finacc1.id;
            coco2.Payment_Display_Status__c = 'Processing';
            
        cocoList.add(coco1);
        cocoList.add(coco2);
        insert cocoList; 
        
        System.assertNotEquals(Null,coco1.id);
        System.assertNotEquals(Null,coco2.id);*/
        Test.StartTest();
    ApexPages.StandardController con1 = new ApexPages.StandardController(coco1); 
        paymentEditRedirect per1 = new paymentEditRedirect(con1);
        per1.redirPage();
        per1.redirectToVFPage();
        per1.goBack();
        
    ApexPages.StandardController con2 = new ApexPages.StandardController(coco2); 
        paymentEditRedirect per2 = new paymentEditRedirect(con2);
        per2.redirPage();
        //per2.redirectToVFPage();
        //per1.goBack(); 
        
    ApexPages.StandardController con3 = new ApexPages.StandardController(coco3); 
        paymentEditRedirect per3 = new paymentEditRedirect(con3);
        per3.redirPage(); 
        per3.redirectToVFPage();
    
    ApexPages.StandardController con4 = new ApexPages.StandardController(coco4); 
        paymentEditRedirect per4 = new paymentEditRedirect(con4);
        per4.redirPage();
         per4.redirectToVFPage();           
    
    ApexPages.StandardController con5 = new ApexPages.StandardController(coco5); 
        paymentEditRedirect per5 = new paymentEditRedirect(con5);
        per5.redirPage();  
         per5.redirectToVFPage();   
     
    Test.StopTest();
    }
    }
    
    static testMethod void paymentEditRedirect_TestMethod1(){
    
    // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name= 'System Administrator']; 
        User u = new User(Alias = 'testu', Email='testagentuser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tes', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testagentuser@testorg.com');
            
        insert u;
       system.runAs(u){ 
     //Creating List of Finance_Account__c records
        List<Finance_Account__c> finaccList = new List<Finance_Account__c>();
        Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1111';
            finacc1.Honda_Brand__c = 'Unicorn';
           
        Finance_Account__c finacc2 = new Finance_Account__c();
            finacc2.Finance_Account_Number__c='1112';
            finacc2.Honda_Brand__c = 'AFS';
        
        Finance_Account__c finacc3 = new Finance_Account__c();
            finacc3.Finance_Account_Number__c='1113';
            finacc3.Honda_Brand__c = 'AFS';
        
        finaccList.add(finacc1);
        finaccList.add(finacc2);
        finaccList.add(finacc3);
        
        insert finaccList; 
        
        System.assertNotEquals(Null, finacc1.id);
        System.assertNotEquals(Null, finacc2.id);
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        //List<Communication_Preferences__c> cprefList = new List<Communication_Preferences__c>();
        
        Communication_Preferences__c cPref1 = new Communication_Preferences__c();
        cPref1.Finance_Account_Number__c=finacc1.id;
        cPref1.Customer__c=a.Id;
        cPref1.Payment_Confirmations_via_Email__c=true;
        cPref1.Payment_Reminders_via_Text__c=true;
        cPref1.Email_Address__c= 'testhonda@testorg.com';
        cPref1.EasyPay_Communications_via_Email__c= true;
        cPref1.Text_Number__c = '12345' ;
        cPref1.Payment_Confirmations_via_Text__c = true; 
        cPref1.EasyPay_Communications_via_Text__c = true;
        cPref1.Text_Number__c='9992223334';
        cPref1.Statements_Letters__c = 'eDelivery';
        insert cPref1;
        
        //List<Payment_Source__c> psorList = new List<Payment_Source__c>();
        
        //Creating Payment_Source__c records
        Payment_Source__c psor1 = new Payment_Source__c();
            psor1.Finance_Account_Number__c = finacc1.id; 
            psor1.Bank_Name__c = 'ICICI';
            psor1.Payment_Source_Nickname__c ='1111' ;
            psor1.Bank_Account_Number__c = '1230000004560001';
            psor1.Bank_Account_Type__c = 's';
            psor1.Bank_Routing_Number__c = 'IKBL01238';
            psor1.Status__c = 'Active';
        insert psor1;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        
        insert cbg;
        
        //Creating List of ChargentOrders__ChargentOrder__c records
        //List<ChargentOrders__ChargentOrder__c> cocoList = new List<ChargentOrders__ChargentOrder__c>();
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc1.id;
            coco1.Payment_Source_Nickname__c = psor1.id;
            coco1.Payment_Display_Status__c = 'Pending';
            coco1.ChargentOrders__Payment_Start_Date__c = System.Today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Gateway__c  = cbg.Id;
            coco1.ChargentOrders__Payment_Frequency__c = 'NCe';
            coco1.ChargentOrders__Payment_Status__c = 'Recurring';
            coco1.recordtypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
          insert coco1;  
         //cocoList.add(coco1);
         

         ApexPages.CurrentPage().getParameters().put('finnumber','1111');
         ApexPages.CurrentPage().getParameters().put('Id',coco1.id); 

        Test.StartTest();
    ApexPages.StandardController con1 = new ApexPages.StandardController(coco1); 
        paymentEditRedirect per1 = new paymentEditRedirect(con1);
        per1.redirPage();
        per1.redirectToVFPage();
        per1.goBack();   
     
    Test.StopTest();
    }
    }
}