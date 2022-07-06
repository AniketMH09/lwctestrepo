/*
Author      :  Sajila Kadayaprath
Description :  Test class for UserSecurity
*/
@isTest
public class UserSecurity_Test{
    private static TestMethod void testUserSecurity(){
        
    RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
    Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
    insert newAccount;
    
    Finance_Account__c finacc = new Finance_Account__c();
    finacc.Finance_Account_Number__c='1000001';
    finacc.Honda_Brand__c='AFS';
    //finacc.Customer__c=cfa.Id;
    insert finacc;
    
    Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
    cfa.Customer__c= newAccount.Id;
    cfa.Finance_Account__c=finacc.Id;
    insert cfa;
    
    finacc.Customer__c=cfa.Id;
    update finacc;
    
    Communication_Preferences__c cPref=new Communication_Preferences__c();
    cPref.Finance_Account_Number__c=finacc.Id;
    cPref.Payment_Confirmations_via_Email__c=true;
    cPref.Payment_Reminders_via_Text__c=true;
    cPref.Payment_Confirmations_via_Text__c=true;
    cPref.EasyPay_Communications_via_Text__c =true;
    cPref.Text_Number__c='9992223334';
    cPref.Customer__c=newAccount.Id;
    insert cPref;
    
    ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
    cbg.Name = 'Cybersource';
    insert cbg;
    
    ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
    ch.Finance_Account_Number__c=finacc.Id;
    ch.Payment_Type__c = 'O';
    ch.ChargentOrders__Charge_Amount__c=5000;
    ch.ChargentOrders__Payment_Status__c='Recurring';
    ch.ChargentOrders__Payment_Frequency__c='Once';  
    ch.ChargentOrders__Payment_Start_Date__c =System.today();
    Test.startTest();
    //Recurring -Once-Insert
    insert ch;
    
    PageReference pageRef = Page.UserSecurityNotAuthorized;
    Test.setCurrentPage(pageRef);
    ApexPages.CurrentPage().getparameters().put('finnumber', finacc.Finance_Account_Number__c);
    
    UserSecurity u=new UserSecurity();
    Boolean pg=UserSecurity.ValidateFinNumber(finacc.Finance_Account_Number__c);
    Boolean b=UserSecurity.ValidateChargentId(ch.Id);
    Boolean b1=UserSecurity.ValidateFinNumber(finacc.Id);
    Boolean b2=UserSecurity.ValidateChargentId(ch.Id);
    Boolean b3=UserSecurity.ValidateFinNumberInit(finacc.Id);
    String[] s=UserSecurity.getCustomerIds(finacc.Id);
    Test.stopTest();       
    }
    
        private static TestMethod void testUserSecurity1(){
        
    RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
    Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
    insert newAccount;
    
    Finance_Account__c finacc = new Finance_Account__c();
    finacc.Finance_Account_Number__c='567657434';
    finacc.Honda_Brand__c='AFS';
    //finacc.Customer__c=cfa.Id;
    insert finacc;
    
    Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
    cfa.Customer__c= newAccount.Id;
    cfa.Finance_Account__c=finacc.Id;
    insert cfa;
    
    finacc.Customer__c=cfa.Id;
    update finacc;
    
    Communication_Preferences__c cPref=new Communication_Preferences__c();
    cPref.Finance_Account_Number__c=finacc.Id;
    cPref.Payment_Confirmations_via_Email__c=true;
    cPref.Payment_Reminders_via_Text__c=true;
    cPref.Payment_Confirmations_via_Text__c=true;
    cPref.EasyPay_Communications_via_Text__c =true;
    cPref.Text_Number__c='9992223334';
    cPref.Customer__c=newAccount.Id;
    insert cPref;
    
    ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
    cbg.Name = 'Cybersource';
    insert cbg;
    
    ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
    ch.Finance_Account_Number__c=finacc.Id;
    ch.Payment_Type__c = 'O';
    ch.ChargentOrders__Charge_Amount__c=5000;
    ch.ChargentOrders__Payment_Status__c='Recurring';
    ch.ChargentOrders__Payment_Frequency__c='Once';  
    ch.ChargentOrders__Payment_Start_Date__c =System.today();
    Test.startTest();
    //Recurring -Once-Insert
    insert ch;
    
    PageReference pageRef = Page.UserSecurityNotAuthorized;
    Test.setCurrentPage(pageRef);
    ApexPages.CurrentPage().getparameters().put('finnumber', Null);
    
    UserSecurity u=new UserSecurity();
    Boolean b=UserSecurity.ValidateChargentId(ch.Id);
    Boolean b1=UserSecurity.ValidateFinNumber(finacc.Id);
    Boolean b2=UserSecurity.ValidateChargentId(ch.Id);
    Boolean b3=UserSecurity.ValidateFinNumberInit(finacc.Id);
    String[] s=UserSecurity.getCustomerIds(finacc.Id);
    Boolean pg=UserSecurity.ValidateFinNumber(finacc.Finance_Account_Number__c);
    Test.stopTest();       
    }
    
 }