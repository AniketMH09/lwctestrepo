/*=====================================================================
* Name: AHFC_AddFinanceAccountController_Test.apex
* Description: Unit Test class for AHFC_AddFinanceAccountController
* Created Date: 18th May 2021
* Created By: Abhijit kurapati
* Modified By : Akash Solanki
* Modified Date : 11 June 2021 || 23 August 2021
* Modification Log: Added new method getFinanceAccountExistsTest to  cover getFinanceAccountExists Method for Bug Fix
* 					Added new method updatedCommPrefsTest to  cover updatedCommPrefs Method of AHFC_AddFinanceAccountController Apex class
*  ===================================================================== */
@isTest
public class AHFC_AddFinanceAccountControllerTest {

 public static testMethod void testPaymentSource() {
    AHFC_Bank_Routing__c ahfcRouting = new AHFC_Bank_Routing__c();
    ahfcRouting.AHFC_Bank_Name__c = 'Test';
    ahfcRouting.AHFC_Routing_Number__c = '987654321';
    
    //System.assertNotEquals(Null,ahfcRouting.id);
    Account a1= new Account(Name='Test Account Name',AccountNumber ='12345567');
    
    
    Contact c1 = new Contact(LastName = 'Contact Last Name');
    
    Profile p = [SELECT Id FROM Profile WHERE Name='Customer']; 
    UserRole userrole = [Select Id, DeveloperName From UserRole Limit 1];
		
	User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' and IsActive=true Limit 1];
    adminUser.UserRoleId=userrole.Id;
    update adminUser;
     
    User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser13@testorg.com');
    
    RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
    Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
    
     Finance_Account__c finacc2 = new Finance_Account__c();
    finacc2.Finance_Account_Number__c='21932293';

    finacc2.AHFC_Last_4_SSN__c    ='1234';  
    finacc2.AHFC_Garaging_Zip__c   = '12345';
    finacc2.Vehicle_Identification_Number__c = '12345678901234567';
    
     
    
    Finance_Account__c finacc3 = new Finance_Account__c();
    finacc3.Finance_Account_Number__c='21972297';
    finacc3.Payoff_Amount__c = 201.00;  
    finacc3.AHFC_Last_4_SSN__c    ='1235';  

    
    Finance_Account__c finacc4 = new Finance_Account__c();
    finacc4.Finance_Account_Number__c='2195';      
    
    Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();    
    Customer_Finance_Account__c cfa1=new Customer_Finance_Account__c();
    
     
      system.runAs(adminUser)
    {
    insert ahfcRouting;
    insert a1;
    c1.AccountId = a1.id;
    insert c1; 
    u.ContactId=c1.id;
    insert u;
    insert newAccount;
    insert finacc2;
    insert finacc3; 
    insert finacc4;
    cfa.Finance_Account__c=finacc2.Id;    
    insert cfa;
    cfa1.Finance_Account__c=finacc3.Id;
    insert cfa1;
    }
          
    system.runAs(u)
    {
   		User testUser = AHFC_AddFinanceAccountController.fetchuserdetails();
        System.assertEquals(testUser.Email, u.Email,'User Email');
    	Account acc = AHFC_AddFinanceAccountController.fetchPersonAccount();
        System.assertEquals(acc.Id, a1.Id,'Account Id');
    	String var = AHFC_AddFinanceAccountController.createCustomerFinanceAccount('1234567','12345','1234','12345678','test@test.com');
        System.assertEquals('We could not identify that account. Please verify the information and try again.', var,'Returned String');
    	String var2 = AHFC_AddFinanceAccountController.createCustomerFinanceAccount('2197','12345','1234','12345678','test@test.com');
        System.assertEquals(var2,'We could not identify that account. Please verify the information and try again.','String value');
    	String var3 = AHFC_AddFinanceAccountController.updateCustomerFinanceAccount('2197','1235','','test@test.com');
        System.assertEquals(var3,'We could not identify that account. Please verify the information and try again.','String value');
    	String Var4 = AHFC_AddFinanceAccountController.updateCustomerFinanceAccount('2195','','','');
    }
 }
 public static testMethod void testPaymentSource1() {
    AHFC_Bank_Routing__c ahfcRouting = new AHFC_Bank_Routing__c();
    ahfcRouting.AHFC_Bank_Name__c = 'Test';
   // ahfcRouting.AHFC_Routing_Number__c = 10.2;
    
    //System.assertNotEquals(Null,ahfcRouting.id);
    Account a1= new Account(Name='Test Account Name',AccountNumber ='12345567');
    
    
    Contact c1 = new Contact(LastName = 'Contact Last Name', AccountId = a1.id);
     
    Profile p = [SELECT Id FROM Profile WHERE Name='Customer']; 
     
    UserRole userrole = [Select Id, DeveloperName From UserRole Limit 1];
		
	User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' and IsActive=true Limit 1];
    adminUser.UserRoleId=userrole.Id;
    update adminUser;
     
    User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser13@testorg.com',ContactId=c1.id);
    
     
    RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
    Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
    
     Finance_Account__c finacc2 = new Finance_Account__c();
    finacc2.Finance_Account_Number__c='2193';

    finacc2.AHFC_Last_4_SSN__c    ='1234';  
    finacc2.AHFC_Garaging_Zip__c   = '12345';
    finacc2.Vehicle_Identification_Number__c = '1234567';
    
    
    Finance_Account__c finacc3 = new Finance_Account__c();
    finacc3.Finance_Account_Number__c='2197';
    finacc3.Payoff_Amount__c = 201.00;  
    finacc3.AHFC_Last_4_SSN__c    ='1235';  

    
    
    Finance_Account__c finacc4 = new Finance_Account__c();
    finacc4.Finance_Account_Number__c='2195';

    
    
    //System.assertNotEquals(Null, finacc2.id);
    Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
    Customer_Finance_Account__c cfa1=new Customer_Finance_Account__c();
   
     system.runAs(adminUser)
    {
    insert ahfcRouting;
    insert a1;
    c1.AccountId = a1.id;
    insert c1; 
    u.ContactId=c1.id;
    insert u;
    insert newAccount;
    insert finacc2;
    insert finacc3; 
    insert finacc4;
    cfa.Finance_Account__c=finacc2.Id;    
    insert cfa;
    cfa1.Finance_Account__c=finacc3.Id;
    insert cfa1;
    }
     
    system.runAs(u)
    {
   		User testUser = AHFC_AddFinanceAccountController.fetchuserdetails();
        System.assertEquals(testUser.Email, u.Email,'User Email');
    	Account acc = AHFC_AddFinanceAccountController.fetchPersonAccount();
        System.assertEquals(acc.Id, a1.Id,'Account Id');
    	String var5 = AHFC_AddFinanceAccountController.createCustomerFinanceAccount('','','','','');
    	String var6 = AHFC_AddFinanceAccountController.createCustomerFinanceAccount('','','','','test@test.com');
   		String var7 =  AHFC_AddFinanceAccountController.updateCustomerFinanceAccount('','','','test@test.com');
         System.assertEquals(var7,'We could not identify that account. Please verify the information and try again.','String value');
    	String var8 = AHFC_AddFinanceAccountController.updateCustomerFinanceAccount('','','','');
         System.assertEquals(var8,'We could not identify that account. Please verify the information and try again.','String value');
    }
 }
 /**
* @description : This method will test the code for getFinanceAccountExists Method in AHFC_AddFinanceAccountController Apex class
* @author:	 Akash Solanki | June 11 2021
**/
    @isTest 
    public static void getFinanceAccountExistsTest(){
        
        Account a1= new Account(Name='Test Account Name',AccountNumber ='12345567');
        
        
        Contact c1 = new Contact(LastName = 'Contact Last Name');
       
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer']; 
        UserRole userrole = [Select Id, DeveloperName From UserRole Limit 1];
		
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' and IsActive=true Limit 1];
        adminUser.UserRoleId=userrole.Id;
        update adminUser;
        
        User u = new User(Alias = 'sandt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser131@testorg.com');
        
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
        
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='21932293';
        
        system.runAs(adminUser)
        {
           insert a1;
           c1.AccountId = a1.id;
           insert c1; 
           u.ContactId=c1.id;
           insert u;
           insert newAccount;
        }
        system.runAs(u){
            Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
            cfa.Finance_Account__c=finacc2.Id;
            cfa.Customer__c = a1.Id;
            insert cfa;
            Boolean value = AHFC_AddFinanceAccountController.getFinanceAccountExists();
            System.assertEquals(value, true,'Boolean Value');
        }
        
    }
    
 /**
* @description : This method will test the code for getFinanceAccountExists Method in AHFC_AddFinanceAccountController Apex class
* @author:	 Akash Solanki | June 11 2021
**/
    @isTest 
    public static void createJunctionForAlreadyInactiveTest(){
        
        Account a1= new Account(Name='Test Account Name',AccountNumber ='12345567');
        
        
        Contact c1 = new Contact(LastName = 'Contact Last Name');
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer']; 
        UserRole userrole = [Select Id, DeveloperName From UserRole Limit 1];
		
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' and IsActive=true Limit 1];
        adminUser.UserRoleId=userrole.Id;
        update adminUser;
        
        User u = new User(Alias = 'sandt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser131@testorg.com',ContactId=c1.id);
       
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
        
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='0000021932293';
        finacc2.AHFC_Last_4_SSN__c = '1234';
        finacc2.AHFC_Garaging_Zip__c = '12345';
        finacc2.Vehicle_Identification_Number__c = '5FPYK3F10MB000077';
        
        
        system.runAs(adminUser)
        {
		   insert a1;
           c1.AccountId = a1.id;
           insert c1; 
           u.ContactId=c1.id;
           insert u;
           insert newAccount;
           insert finacc2;            
        }
        system.runAs(u){
            Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
            cfa.Finance_Account__c=finacc2.Id;
            cfa.Customer__c = a1.Id;
            String value = AHFC_AddFinanceAccountController.getFinanceAccount('21932293','1234');            
            System.assertEquals(value, finacc2.Id,'Finance Account Id');
            String var9 = AHFC_AddFinanceAccountController.createCustomerFinanceAccount('5FPYK3F10MB000077', '12345', '1234','', '');
            String var10 = AHFC_AddFinanceAccountController.updateCustomerFinanceAccount('21932293', '1234', '', '');
        }
        
    }
    
    
 /**
* @description : This method will test the code for updatedCommPrefs Method in AHFC_AddFinanceAccountController Apex class
* @author:	 Akash Solanki | August 23 2021
**/
    @isTest 
    public static void updatedCommPrefsTest(){
        
        Account a1= new Account(Name='Test Account Name',AccountNumber ='12345567');
        
        
        Contact c1 = new Contact(LastName = 'Contact Last Name');
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer'];
        UserRole userrole = [Select Id, DeveloperName From UserRole Limit 1];
		
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' and IsActive=true Limit 1];
        adminUser.UserRoleId=userrole.Id;
        update adminUser;
        
        User u = new User(Alias = 'sandt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser131@testorg.com');
        
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
       
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='0000021932293';
        finacc2.AHFC_Last_4_SSN__c = '1234';
        finacc2.AHFC_Garaging_Zip__c = '12345';
        finacc2.Vehicle_Identification_Number__c = '5FPYK3F10MB000077';
        
        
        Communication_Preferences__c cp = new Communication_Preferences__c();
        cp.Text_Number__c = '2343243244';
        
        
        
        system.runAs(adminUser)
        {
		   insert a1;
           c1.AccountId = a1.id;
           insert c1; 
           u.ContactId=c1.id;
           insert u;
           insert newAccount;
           insert finacc2;
           cp.Finance_Account_Number__c = finacc2.Id;
           insert cp;
           
        }
        system.runAs(u){
            Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
            cfa.Finance_Account__c=finacc2.Id;
            cfa.Is_Active__c = false;
            cfa.Customer__c = a1.Id;
            String var11 = AHFC_AddFinanceAccountController.createCustomerFinanceAccount('5FPYK3F10MB000077', '12345', '1234','', '');
            String var12 = AHFC_AddFinanceAccountController.updateCustomerFinanceAccount('21932293', '1234', '', '');
            String msg1 = AHFC_AddFinanceAccountController.updateCommPrefs('21932293', 'true', 'true', 'true','akash@test.com');
            String msg2 = AHFC_AddFinanceAccountController.updateCommPrefs('21932293', 'false', 'false', 'false','akash@test.com');
            System.assertEquals(msg2, 'FAILURE', 'Value Of Strings');
            String msg3 = AHFC_AddFinanceAccountController.updateCommPrefsVinTab('5FPYK3F10MB000077', 'true', 'true', 'true','akash@test.com');
            System.assertEquals(msg3, 'FAILURE', 'Value Of Strings');
            String msg4 = AHFC_AddFinanceAccountController.updateCommPrefsVinTab('5FPYK3F10MB000077', 'false', 'false', 'false','akash@test.com');
            System.assertEquals(msg4, 'FAILURE', 'Value Of Strings');
            Boolean value = AHFC_AddFinanceAccountController.getFinanceAccountWithActiveJunction('000021932293');
            System.debug('Boollast '+value);
            System.assertEquals(value, false, 'Value Of Strings');
            
        }
        
    }
}