@isTest
public class UtilityClass_Test{
    public static testMethod void utilityClass_TestMethod(){
      
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
        insert newAccount;
       
        Finance_Account__c finacc1 = new Finance_Account__c();
        finacc1.Finance_Account_Number__c='8476';
        finacc1.Honda_Brand__c = 'AFS';
        finacc1.Payoff_Amount__c = 200.00;   
        insert finacc1; 
        
        // ApexPages.CurrentPage().getParameters().put('finnumber','1112');
        System.assertNotEquals(Null, finacc1.id);
        
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='2197';
        finacc2.Honda_Brand__c = 'AFS';
        finacc2.Payoff_Amount__c = 200.00;         
        insert finacc2; 
        
        ApexPages.CurrentPage().getParameters().put('finnumber','1112');
        System.assertNotEquals(Null, finacc2.id);
        
        /*Account a=new Account();
        a.Name='Test';
        insert a;*/
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Customer__c= newAccount.Id;
        cfa.Finance_Account__c=finacc2.Id;
        insert cfa;
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
        cPref2.Customer__c=newAccount.Id;
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
        psor2.Preferred_Payment_Source__c = true;
        PSOR2.Status__c = 'Active';
        insert psor2; 
        
        System.assertNotEquals(Null,psor2.id);
        
        //Creating Payment_Source__c records
        Payment_Source__c psor1 = new Payment_Source__c();
        psor1.Finance_Account_Number__c = finacc2.id; 
        psor1.Bank_Name__c = 'ICICkI';
        psor1.Payment_Source_Nickname__c ='1112' ;
        psor1.Bank_Account_Number__c = '1230000004560002';
        psor1.Bank_Account_Type__c = 'K';
        psor1.Bank_Routing_Number__c = 'IKBL01538';
        PSOR1.Status__c = 'Active';
            //psor1.Preferred_Payment_Source__c = true;
        
        insert psor1; 
        System.assertNotEquals(Null,psor1.id);
        
        List<Payment_Source__c> psorList = new List<Payment_Source__c>();
        psorList.add(psor2);
        psorList.add(psor1);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg; 
       
         //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
        coco1.Finance_Account_Number__c = finacc2.id;
        coco1.Payment_Source_Nickname__c = psor2.id;
        coco1.Payment_Display_Status__c = 'Pending';
        coco1.ChargentOrders__Payment_Start_Date__c = system.today();
        coco1.ChargentOrders__Charge_Amount__c = 120.00;
        coco1.ChargentOrders__Payment_Status__c = 'Recurring';
        coco1.ChargentOrders__Payment_Frequency__c = 'Once';
        coco1.Payment_Type__c = 'P';
        coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
        insert coco1;
        
        ApexPages.CurrentPage().getParameters().put('Id',coco1.id);
        Test.startTest();
        
        /*Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco2 = new ChargentOrders__ChargentOrder__c();
        coco2.Finance_Account_Number__c = finacc1.id;
        coco2.Payment_Source_Nickname__c = psor2.id;
        coco2.Payment_Display_Status__c = 'Stopped';
        coco2.ChargentOrders__Payment_Start_Date__c = system.today();
        coco2.ChargentOrders__Charge_Amount__c = 120.00;
        coco2.ChargentOrders__Payment_Status__c = 'Recurring';
        coco2.ChargentOrders__Payment_Frequency__c = 'Once';
        coco2.Payment_Type__c = 'P';
        coco2.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
        insert coco2;
        
        ApexPages.CurrentPage().getParameters().put('Id',coco2.id);*/
        //Label lab = new Label(Name='GatewayName', Value='Cybersource');   
        
        Map<Id,Payment_Source__c> psorMap = new Map<Id,Payment_Source__c>(psorList);
        UtilityClass ucl = new UtilityClass();
        UtilityClass.getBankAccounts(psorMap);
        UtilityClass.getBankAccounts(psorMap,coco1.Id);
        UtilityClass.getBankAccountNames(finacc2.id,'popup');
        UtilityClass.getLastBankAccounts(psorMap);
        UtilityClass.getChargentOrdersRP(finacc1.id);
        UtilityClass.getChargentOrders(finacc2.id);
        UtilityClass.dateSplitProcess('dateSplit');
        UtilityClass.getRemainingAmountDue(finacc2.Finance_Account_Number__c);
       String s= UtilityClass.GetFinAccountNumer(coco1.Id);
       Boolean b= UtilityClass.CheckSecurity(finacc2.Finance_Account_Number__c);
    
    }
    public static testMethod void utilityClass_TestMethod1(){
    
        //Profile p = [SELECT Id FROM Profile WHERE Name='Customer']; 
        /*User u = [SELECT Id FROM User WHERE ProfileId=:p.Id AND isActive=true limit 1]; */
        //System.runAs(u)
        //{
            /*RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
            Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
            insert newAccount;*/
            
            Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1112';
            finacc1.Honda_Brand__c = 'AFS';
            finacc1.Payoff_Amount__c = 200.00;
                 
            insert finacc1; 

            /*Account a=new Account();
            a.Name='Test';
            insert a;*/
            
           /* Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
            //cfa.Customer__c= a.Id;
            cfa.Finance_Account__c=finacc1.Id;
            insert cfa;*/
            
            Communication_Preferences__c cPref2 = new Communication_Preferences__c();
            cPref2.Finance_Account_Number__c=finacc1.id;
            //cPref2.Customer__c=a.Id;
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
            psor2.Finance_Account_Number__c = finacc1.id; 
            //psor2.Bank_Name__c = 'ICICkI';
            //psor2.Payment_Source_Nickname__c ='1112' ;
            psor2.Bank_Account_Number__c = '1230000004560002';
            psor2.Bank_Account_Type__c = 'K';
            psor2.Bank_Routing_Number__c = 'IKBL01538';
           // psor2.Preferred_Payment_Source__c = true;
            PSOR2.Status__c = 'Active';
        
            insert psor2; 
            System.assertNotEquals(Null,psor2.id);
        
            //Creating Payment_Source__c records
            Payment_Source__c psor1 = new Payment_Source__c();
            psor1.Finance_Account_Number__c = finacc1.id; 
            psor1.Bank_Name__c = 'ICICkI';
            psor1.Payment_Source_Nickname__c ='1112' ;
            psor1.Bank_Account_Number__c = '1230000004560002';
            psor1.Bank_Account_Type__c = 'K';
            psor1.Bank_Routing_Number__c = 'IKBL01538';
            PSOR1.Status__c = 'Active';
            //psor1.Preferred_Payment_Source__c = true;
        
            insert psor1; 
            System.assertNotEquals(Null,psor1.id);
        
            List<Payment_Source__c> psorList = new List<Payment_Source__c>();
            psorList.add(psor2);
            psorList.add(psor1);
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
       
             //Creating List of ChargentOrders__ChargentOrder__c records
            ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc1.id;
            coco1.Payment_Source_Nickname__c = psor2.id;
            coco1.Payment_Display_Status__c = 'Pending';
            coco1.ChargentOrders__Payment_Start_Date__c = system.today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Payment_Status__c = 'Stopped';
            coco1.ChargentOrders__Payment_Frequency__c = 'Once';
            coco1.Payment_Type__c = 'P';
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
            insert coco1;
            ApexPages.CurrentPage().getParameters().put('Id',coco1.id);
             /*Creating List of ChargentOrders__ChargentOrder__c records
            ChargentOrders__ChargentOrder__c coco2 = new ChargentOrders__ChargentOrder__c();
            coco2.Finance_Account_Number__c = finacc1.id;
            coco2.Payment_Source_Nickname__c = psor2.id;
            coco2.Payment_Display_Status__c = 'Stopped';
            coco2.ChargentOrders__Payment_Start_Date__c = system.today();
            coco2.ChargentOrders__Charge_Amount__c = 120.00;
            coco2.ChargentOrders__Payment_Status__c = 'Recurring';
            coco2.ChargentOrders__Payment_Frequency__c = 'Once';
            coco2.Payment_Type__c = 'P';
            coco2.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
            insert coco2;
            ApexPages.CurrentPage().getParameters().put('Id',coco2.id); */
            
            //Label lab = new Label(Name='GatewayName', Value='Cybersource');   
        
            Map<Id,Payment_Source__c> psorMap = new Map<Id,Payment_Source__c>(psorList);
            UtilityClass ucl = new UtilityClass();
            UtilityClass.getBankAccounts(psorMap);
            UtilityClass.getBankAccounts(psorMap,coco1.Id);
            UtilityClass.getBankAccountNames(finacc1.id,'popup');
            UtilityClass.getLastBankAccounts(psorMap);
            UtilityClass.getChargentOrdersRP(finacc1.id);
            UtilityClass.getChargentOrders(finacc1.id);
            UtilityClass.dateSplitProcess('dateSplit');
            String s= UtilityClass.GetFinAccountNumer(coco1.Id);
            Boolean b= UtilityClass.CheckSecurity(finacc1.Id);
        //}
        //Test.stopTest();
    }
  
        public static testMethod void utilityClass_TestMethod2(){
    
       // Profile p = [SELECT Id FROM Profile WHERE Name='Customer']; 
        /* User u = [SELECT Id FROM User WHERE ProfileId=:p.Id AND isActive=true limit 1]; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');*/
        //System.runAs(u)
       // {
            /*RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
            Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
            insert newAccount;*/
            
            Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1112';
            finacc1.Honda_Brand__c = 'AFS';
            finacc1.Payoff_Amount__c = 200.00;
            finacc1.Total_Amount_Due__c = 500.00;
            finacc1.Payment_Due_Date__c = system.today().addDays(5);
            insert finacc1; 

            /*Account a=new Account();
            a.Name='Test';
            insert a;*/
            
           /* Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
            //cfa.Customer__c= a.Id;
            cfa.Finance_Account__c=finacc1.Id;
            insert cfa;*/
            
            Communication_Preferences__c cPref2 = new Communication_Preferences__c();
            cPref2.Finance_Account_Number__c=finacc1.id;
            //cPref2.Customer__c=a.Id;
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
            psor2.Finance_Account_Number__c = finacc1.id; 
            //psor2.Bank_Name__c = 'ICICkI';
            //psor2.Payment_Source_Nickname__c ='1112' ;
            psor2.Bank_Account_Number__c = '1230000004560002';
            psor2.Bank_Account_Type__c = 'K';
            psor2.Bank_Routing_Number__c = 'IKBL01538';
           // psor2.Preferred_Payment_Source__c = true;
            PSOR2.Status__c = 'Active';
        
            insert psor2; 
            System.assertNotEquals(Null,psor2.id);
        
            //Creating Payment_Source__c records
            Payment_Source__c psor1 = new Payment_Source__c();
            psor1.Finance_Account_Number__c = finacc1.id; 
            psor1.Bank_Name__c = 'ICICkI';
            psor1.Payment_Source_Nickname__c ='1112' ;
            psor1.Bank_Account_Number__c = '1230000004560002';
            psor1.Bank_Account_Type__c = 'K';
            psor1.Bank_Routing_Number__c = 'IKBL01538';
            PSOR1.Status__c = 'Active';
            //psor1.Preferred_Payment_Source__c = true;
        
            insert psor1; 
            System.assertNotEquals(Null,psor1.id);
        
            List<Payment_Source__c> psorList = new List<Payment_Source__c>();
            psorList.add(psor2);
            psorList.add(psor1);
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
       
             //Creating List of ChargentOrders__ChargentOrder__c records
            ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc1.id;
            coco1.Payment_Source_Nickname__c = psor2.id;
            coco1.Payment_Display_Status__c = 'Pending';
            coco1.ChargentOrders__Payment_Start_Date__c = system.today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Payment_Status__c = 'Recurring';
            coco1.ChargentOrders__Payment_Frequency__c = 'Once';
            coco1.Payment_Type__c = 'P';
            coco1.Next_Withdrawal_Date__c = system.today();
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert coco1;
            ApexPages.CurrentPage().getParameters().put('Id',coco1.id);
            Test.startTest();
            
            Map<Id,Payment_Source__c> psorMap = new Map<Id,Payment_Source__c>(psorList);
            UtilityClass ucl = new UtilityClass();
            UtilityClass.getBankAccounts(psorMap);
            UtilityClass.getBankAccounts(psorMap,coco1.Id);
            UtilityClass.getBankAccountNames(finacc1.id,'popup');
            UtilityClass.getLastBankAccounts(psorMap);
            UtilityClass.getChargentOrdersRP(finacc1.id);
            UtilityClass.getChargentOrders(finacc1.id);
            UtilityClass.dateSplitProcess('dateSplit');
            UtilityClass.getRemainingAmountDue(finacc1.Finance_Account_Number__c);
            String s= UtilityClass.GetFinAccountNumer(coco1.Id);
            Boolean b= UtilityClass.CheckSecurity(finacc1.Id);
            Map<String, RecordType> getRecordTypesMap =  UtilityClass.getRecordTypesMap('Case');
            
            Test.stopTest();
        //}
    }
 
  public static testMethod void utilityClass_TestMethod3(){
    
        //Profile p = [SELECT Id FROM Profile WHERE Name='Customer']; 
        /* User u = [SELECT Id FROM User WHERE ProfileId=:p.Id AND isActive=true limit 1]; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com');
        System.runAs(u)
        {*/
            /*RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
            Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
            insert newAccount;*/
            
            Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1112';
            finacc1.Honda_Brand__c = 'AFS';
            finacc1.Payoff_Amount__c = 200.00;
            finacc1.Total_Amount_Due__c = 500.00;
            finacc1.Payment_Due_Date__c = system.today().addDays(5);
            insert finacc1; 

            /*Account a=new Account();
            a.Name='Test';
            insert a;*/
            
           /* Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
            //cfa.Customer__c= a.Id;
            cfa.Finance_Account__c=finacc1.Id;
            insert cfa;*/
            
            Communication_Preferences__c cPref2 = new Communication_Preferences__c();
            cPref2.Finance_Account_Number__c=finacc1.id;
            //cPref2.Customer__c=a.Id;
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
        /*
            //Creating Payment_Source__c records
            Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finacc1.id; 
            //psor2.Bank_Name__c = 'ICICkI';
            //psor2.Payment_Source_Nickname__c ='1112' ;
            psor2.Bank_Account_Number__c = '1230000004560002';
            psor2.Bank_Account_Type__c = 'K';
            psor2.Bank_Routing_Number__c = 'IKBL01538';
           // psor2.Preferred_Payment_Source__c = true;
            PSOR2.Status__c = 'Active';
        
            insert psor2; 
            System.assertNotEquals(Null,psor2.id);
        
            //Creating Payment_Source__c records
            Payment_Source__c psor1 = new Payment_Source__c();
            psor1.Finance_Account_Number__c = finacc1.id; 
            psor1.Bank_Name__c = 'ICICkI';
            psor1.Payment_Source_Nickname__c ='1112' ;
            psor1.Bank_Account_Number__c = '1230000004560002';
            psor1.Bank_Account_Type__c = 'K';
            psor1.Bank_Routing_Number__c = 'IKBL01538';
            PSOR1.Status__c = 'Active';
            //psor1.Preferred_Payment_Source__c = true;
        
            insert psor1; 
            System.assertNotEquals(Null,psor1.id); */
        
            List<Payment_Source__c> psorList = new List<Payment_Source__c>();
          /*  psorList.add(psor2);
            psorList.add(psor1);   */
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
       
             //Creating List of ChargentOrders__ChargentOrder__c records
            ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc1.id;
            //   coco1.Payment_Source_Nickname__c = psor2.id;
            coco1.Payment_Display_Status__c = 'Pending';
            coco1.ChargentOrders__Payment_Start_Date__c = system.today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Payment_Status__c = 'Recurring';
            coco1.ChargentOrders__Payment_Frequency__c = 'Once';
            coco1.Payment_Type__c = 'P';
            coco1.Next_Withdrawal_Date__c = system.today().addDays(10);
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert coco1;
            ApexPages.CurrentPage().getParameters().put('Id',coco1.id);
            Test.startTest();
            
            Map<Id,Payment_Source__c> psorMap = new Map<Id,Payment_Source__c>(psorList);
            UtilityClass ucl = new UtilityClass();
            //  UtilityClass.getBankAccounts(psorMap);
            // UtilityClass.getBankAccounts(psorMap,coco1.Id);
            UtilityClass.getBankAccountNames(finacc1.id,'popup');
            UtilityClass.getLastBankAccounts(psorMap);
            UtilityClass.getChargentOrdersRP(finacc1.id);
            UtilityClass.getChargentOrders(finacc1.id);
            UtilityClass.dateSplitProcess('dateSplit');
            UtilityClass.getRemainingAmountDue(finacc1.Finance_Account_Number__c);
            String s= UtilityClass.GetFinAccountNumer(coco1.Id);
            Boolean b= UtilityClass.CheckSecurity(finacc1.Id);
            
            Test.stopTest();
        //}
    }
    
    //Added by Rohit
    public static testMethod void utilityClass_TestMethod4(){
    
      /*
        Profile p = [SELECT Id FROM Profile WHERE Name='Agent']; 
        system.debug('profile id is ' + p.id);
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
        insert newAccount;
        //User u = [SELECT Id FROM User WHERE ProfileId=:p.Id AND isActive=true limit 1]; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId =p.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1@testorg.com',accountid = newAccount.id);
        system.debug('user is using profile of ' + u.ProfileId); */
  
      		
        // System.runas(u){
            Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1112';
            finacc1.Honda_Brand__c = 'AFS';
            finacc1.Payoff_Amount__c = 200.00;
            finacc1.Total_Amount_Due__c = 500.00;
            finacc1.Payment_Due_Date__c = system.today().addDays(5);
            insert finacc1; 

            Communication_Preferences__c cPref2 = new Communication_Preferences__c();
            cPref2.Finance_Account_Number__c=finacc1.id;
            //cPref2.Customer__c=a.Id;
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
       
        
            List<Payment_Source__c> psorList = new List<Payment_Source__c>();
          /*  psorList.add(psor2);
            psorList.add(psor1);   */
        
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg; 
       
             //Creating List of ChargentOrders__ChargentOrder__c records
            ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc1.id;
            //   coco1.Payment_Source_Nickname__c = psor2.id;
            coco1.Payment_Display_Status__c = 'Pending';
            coco1.ChargentOrders__Payment_Start_Date__c = system.today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Payment_Status__c = 'Recurring';
            coco1.ChargentOrders__Payment_Frequency__c = 'Once';
            coco1.Payment_Type__c = 'P';
            coco1.Next_Withdrawal_Date__c = system.today().addDays(10);
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert coco1;
            ApexPages.CurrentPage().getParameters().put('Id',coco1.id);
            Test.startTest();
            
            Map<Id,Payment_Source__c> psorMap = new Map<Id,Payment_Source__c>(psorList);
            UtilityClass ucl = new UtilityClass();
            //  UtilityClass.getBankAccounts(psorMap);
            // UtilityClass.getBankAccounts(psorMap,coco1.Id);
            UtilityClass.getBankAccountNames(finacc1.id,'popup');
            UtilityClass.getLastBankAccounts(psorMap);
            UtilityClass.getChargentOrdersRP(finacc1.id);
            UtilityClass.getChargentOrders(finacc1.id);
            UtilityClass.dateSplitProcess('dateSplit');
            UtilityClass.getRemainingAmountDue(finacc1.Finance_Account_Number__c);
            String s= UtilityClass.GetFinAccountNumer(coco1.Id);
        	
           Boolean b= UtilityClass.CheckSecurity(finacc1.Id);
               
            
            Test.stopTest();
        //}
            
    }
    // 114221 STARTS
      public static testMethod void utilityClass_getEnvName_Test(){
          String envName = UtilityClass.getEnvName();
          system.assert(envName != null && (envName.contains('Prod')||envName.contains(UserInfo.getUserName().substringAfterLast('.'))||envName.contains('SB')));
      }
  public static testMethod void utilityClass_errorHandling_Test(){
      	  Exception e = new System.NullPointerException();
      
          UtilityClass.logError('UtilityClass', 'logError method test message', '123345','new messsage');
          UtilityClass.logErrorResp('UtilityClass', 'logErrorResp method test message', '12345', 'Sample Request' , 'Sample Response');
          UtilityClass.logException(e, 'UtilityClass', 'logError method test message', '123345','new messsage');
      }
    
    public static CreateSCRACaseAction.CreateCaseActionRequest getCreateCaseActionRequest(){

        CreateSCRACaseAction.CreateCaseActionRequest csar = new CreateSCRACaseAction.CreateCaseActionRequest();
        csar.strahfcaccount = 'test';
        csar.strAHFCCustomer = 'test';
        csar.strAuthorizedUser = true; 
        csar.strdob = '';
        csar.strEmail = 'test@test.com';
        csar.strFirstName = 'test';
        csar.strssn2 = '2222';
        csar.strLastName = 'test';
        csar.strOrigin = 'Email';
        csar.strPhoneNumber = '9999999999';
        csar.strCompref = '';
        csar.strAreyoutheServiceMember = 'yes';

        return csar;
    }

    
}