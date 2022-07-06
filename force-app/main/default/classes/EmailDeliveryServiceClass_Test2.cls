@isTest
public class EmailDeliveryServiceClass_Test2{

/////////////////////////////////////////////// Method 1  ///////////////////////////////////////////////////////////////
    static testMethod void paymentEmailNotificationController_TestMethod(){
    
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
        
        List <ChargentOrders__ChargentOrder__c> coco1list = new List <ChargentOrders__ChargentOrder__c> ();      
        Map <Id, ChargentOrders__ChargentOrder__c> myMap = new Map <Id, ChargentOrders__ChargentOrder__c> ();
          
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
      //  Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe',Personemail='testhnda@testorg.com', Customer_Number__c='1234', RecordTypeId = recordType.id);
       // insert newAccount;
      
        
        Finance_Account__c finacc1 = new Finance_Account__c();
        finacc1.Finance_Account_Number__c='1111';
        finacc1.Honda_Brand__c = 'HFS';
        finacc1.Customer_Name__c='Testing Account';
        finacc1.Fl_Suppress_All_Notifications__c = False;
        insert finacc1; 
        
        
        System.assertNotEquals(Null, finacc1.id);
        
        /* Account a=new Account();
            a.Name='Test';
            insert a; */
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
      //  cfa.Customer__c= newAccount.Id;
        cfa.Finance_Account__c=finacc1.Id;
        insert cfa;
        update cfa;
        
        finacc1.Customer__c=cfa.Id;
        update finacc1;
        
        Communication_Preferences__c cPref1 = new Communication_Preferences__c();
        cPref1.Finance_Account_Number__c=finacc1.id;
       // cPref1.Customer__c=newAccount.Id;
        cPref1.Payment_Confirmations_via_Email__c=true;
        cPref1.Payment_Reminders_via_Text__c=true;
        cPref1.Email_Address__c= 'testhnda@testorg.com';
        cPref1.EasyPay_Communications_via_Email__c= true;
        cPref1.Text_Number__c = '(999) 999-9999' ;
        cpref1.Payment_Reminders_via_Email__c = true;
        cpref1.Days_Prior_Reminder__c = '15';
        cpref1.Paperless_Statements_Letters__c = true;
        cPref1.Payment_Confirmations_via_Text__c = true; 
        cPref1.EasyPay_Communications_via_Text__c = true;
        cPref1.Payment_Profile_Updates_via_Email__c= true;
        cPref1.Statements_Letters__c = 'eDelivery';
        
        insert cPref1;
       
        
        Payment_Source__c psor1 = new Payment_Source__c();
        psor1.Finance_Account_Number__c = finacc1.id; 
        psor1.Bank_Name__c = 'CITIBank';
        psor1.Payment_Source_Nickname__c ='1111' ;
        psor1.Bank_Account_Number__c = '1230000004560001';
        psor1.Bank_Account_Type__c = 's';
        psor1.Bank_Routing_Number__c = '021000089';
        psor1.Status__c = 'Active';
        
        insert psor1;
        
        Payment_Source__c psor2 = new Payment_Source__c();
        psor2.Finance_Account_Number__c = finacc1.id; 
        psor2.Bank_Name__c = 'CITIBanker';
        psor2.Payment_Source_Nickname__c ='111123' ;
        psor2.Bank_Account_Number__c = '12300000045600';
        psor2.Bank_Account_Type__c = 's';
        psor2.Bank_Routing_Number__c = '021000089';
        psor2.Status__c = 'Active';
        
        insert psor2; 
        System.assertNotEquals(Null,psor1.id);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
      
        
        //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
        coco1.Finance_Account_Number__c = finacc1.id;
        coco1.Payment_Source_Nickname__c = psor1.id;
        coco1.Payment_Display_Status__c = 'Pending';
        coco1.ChargentOrders__Payment_Start_Date__c = system.today();
        coco1.ChargentOrders__Charge_Amount__c = 200.00;
        coco1.Payment_Channel__c = 'W';
        coco1.ChargentOrders__Payment_Method__c = 'Credit Card';
        coco1.ChargentOrders__Payment_Frequency__c = 'Once';
        coco1.ChargentOrders__Payment_Status__c = 'Recurring';
        coco1.ChargentOrders__Payment_End_Date__c = system.today().addDays(20);
        coco1.ChargentOrders__Payment_Stop__c = 'Date' ;
        coco1.Payment_Type__c = 'H';
       
        
        //coco1.recordtypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        
        insert coco1;
       
        mymap.put(coco1.Id, coco1);
        coco1.ChargentOrders__Charge_Amount__c = 300.00 ;
        coco1.Payment_Display_Status__c ='Recurring';
        coco1.Payment_Source_Nickname__c = psor2.id;
        coco1.ChargentOrders__Charge_Amount__c = 350.00;
        coco1.ChargentOrders__Payment_Start_Date__c = system.today()+1;
        update coco1;                       
        
       
        coco1list.add(coco1);
       try{
            system.debug('coco1list operation ' + coco1list);
            system.debug('myMap operation ' + myMap);
            EmailDeliveryService.sendPymtEmailConfirmation(coco1list,myMap,'Update');
        }
        catch(Exception e){}
        
       }
       
    }
   ///////////////////////////////////////////////Method 2  ///////////////////////////////////////////////////////////////
   static testMethod void paymentEmailNotificationController_TestMethod2(){
    
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
        
        List <ChargentOrders__ChargentOrder__c> coco1list = new List <ChargentOrders__ChargentOrder__c> ();      
        Map <Id, ChargentOrders__ChargentOrder__c> myMap = new Map <Id, ChargentOrders__ChargentOrder__c> ();
          
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
      //  Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe',Personemail='testhnda@testorg.com', Customer_Number__c='1234', RecordTypeId = recordType.id);
       // insert newAccount;
      
        
        Finance_Account__c finacc1 = new Finance_Account__c();
        finacc1.Finance_Account_Number__c='1111';
        finacc1.Honda_Brand__c = 'HFS';
        finacc1.Customer_Name__c='Testing Account';
        finacc1.Fl_Suppress_All_Notifications__c = True;
        insert finacc1; 
        
        
        System.assertNotEquals(Null, finacc1.id);
        
        /* Account a=new Account();
            a.Name='Test';
            insert a; */
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
      //  cfa.Customer__c= newAccount.Id;
        cfa.Finance_Account__c=finacc1.Id;
        insert cfa;
        update cfa;
        
        finacc1.Customer__c=cfa.Id;
        update finacc1;
        
        Communication_Preferences__c cPref1 = new Communication_Preferences__c();
        cPref1.Finance_Account_Number__c=finacc1.id;
       // cPref1.Customer__c=newAccount.Id;
        cPref1.Payment_Confirmations_via_Email__c=true;
        cPref1.Payment_Reminders_via_Text__c=true;
        cPref1.Email_Address__c= 'testhnda@testorg.com';
        cPref1.EasyPay_Communications_via_Email__c= true;
        cPref1.Text_Number__c = '(999) 999-9999' ;
        cpref1.Payment_Reminders_via_Email__c = true;
        cpref1.Days_Prior_Reminder__c = '15';
        cpref1.Paperless_Statements_Letters__c = true;
        cPref1.Payment_Confirmations_via_Text__c = true; 
        cPref1.EasyPay_Communications_via_Text__c = true;
        cPref1.Payment_Profile_Updates_via_Email__c= true;
        cPref1.Statements_Letters__c = 'eDelivery';
        
        insert cPref1;
       
        
        Payment_Source__c psor1 = new Payment_Source__c();
        psor1.Finance_Account_Number__c = finacc1.id; 
        psor1.Bank_Name__c = 'CITIBank';
        psor1.Payment_Source_Nickname__c ='1111' ;
        psor1.Bank_Account_Number__c = '1230000004560001';
        psor1.Bank_Account_Type__c = 's';
        psor1.Bank_Routing_Number__c = '021000089';
        psor1.Status__c = 'Active';
        
        insert psor1;
        
        Payment_Source__c psor2 = new Payment_Source__c();
        psor2.Finance_Account_Number__c = finacc1.id; 
        psor2.Bank_Name__c = 'CITIBanker';
        psor2.Payment_Source_Nickname__c ='111123' ;
        psor2.Bank_Account_Number__c = '12300000045600';
        psor2.Bank_Account_Type__c = 's';
        psor2.Bank_Routing_Number__c = '021000089';
        psor2.Status__c = 'Active';
        
        insert psor2; 
        System.assertNotEquals(Null,psor1.id);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
      
        
        //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
        coco1.Finance_Account_Number__c = finacc1.id;
        coco1.Payment_Source_Nickname__c = psor1.id;
        coco1.Payment_Display_Status__c = 'Pending';
        coco1.ChargentOrders__Payment_Start_Date__c = system.today();
        coco1.ChargentOrders__Charge_Amount__c = 200.00;
        coco1.Payment_Channel__c = 'W';
        coco1.ChargentOrders__Payment_Method__c = 'Credit Card';
        coco1.ChargentOrders__Payment_Frequency__c = 'Once';
        coco1.ChargentOrders__Payment_Status__c = 'Recurring';
        coco1.ChargentOrders__Payment_End_Date__c = system.today().addDays(20);
        coco1.ChargentOrders__Payment_Stop__c = 'Date' ;
        coco1.Payment_Type__c = 'H';
        
       
        
        //coco1.recordtypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        
        insert coco1;
       
        mymap.put(coco1.Id, coco1);
        coco1.ChargentOrders__Charge_Amount__c = 300.00 ;
        coco1.Payment_Display_Status__c ='Pending';
        coco1.Payment_Source_Nickname__c = psor2.id;
        coco1.ChargentOrders__Charge_Amount__c = 350.00;
        coco1.ChargentOrders__Payment_Start_Date__c = system.today()+1;
        
        update coco1;                       
        
       
        coco1list.add(coco1);
       try{
            system.debug('coco1list operation ' + coco1list);
            system.debug('myMap operation ' + myMap);
            EmailDeliveryService.sendPymtEmailConfirmation(coco1list,myMap,'Update');
        }
        catch(Exception e){}
        
       }
       
    }
    
 
}