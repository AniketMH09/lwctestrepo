@isTest
public class SCRA_SelectedfinanceAccountList_Test {
        
    /*@testSetup

    public static void  createTestData() {  
                    
            
                
            }*/
    


  @isTest public static void testServiceAccountdetails(){
      UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            system.debug('portalRole is ' + portalRole);
            
            Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
            User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test22@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
            );
            Database.insert(portalAccountOwner1);
            
          User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
          User u2 = [Select Firstname From User Where Id =: portalAccountOwner1.Id];

            system.debug('U2-->'+u2);
         
        Id idSysAdmin = [select ID, Name FROM Profile where Name = 'System Administrator']?.Id;
        Id idPortalRole = [Select Id From UserRole where Name = 'Business Processes' Limit 1]?.Id;
                User sysAdminUser = AHFC_TestDataFactory.getTestUser(idPortalRole, idSysAdmin, 'John', 'Lewis', true);
				//insert sysAdminUser;
            System.runAs(sysAdminUser) { 
             List<Account> lstAccounts = new List<Account>();
        List<Account> lstBusinessAccs = new List<Account>();
        List<Contact> lstContacts = new List<Contact>();
        List<Customer_Finance_Account__c> lstSACs = new List<Customer_Finance_Account__c>();
        List<Finance_Account__c> lstserAcc = new List<Finance_Account__c>();
        //create Person Accounts
            for(Integer i=0; i<=1; i++){
                lstAccounts.add(AHFC_TestDataFactory.createPersonAccount());
            }
            if(!lstAccounts.isEmpty()){
                insert lstAccounts;
                //u1.AccountId = lstAccounts[0].id;
                system.debug('Accounts Id'+lstAccounts[0].id);
            }
                
            
            //create Business Accounts
            for(Integer i=0; i<=1; i++){
                lstBusinessAccs.add(AHFC_TestDataFactory.createAccount('Dealer'));
            }
            if(!lstBusinessAccs.isEmpty()){
                insert lstBusinessAccs;
                system.debug('Business Account  '+lstBusinessAccs[0].id);
            }
            
            
            //create Contacts
            for(Account acc : lstBusinessAccs){
                lstContacts.add(AHFC_TestDataFactory.createContact(acc?.Id));
            }
            if(!lstContacts.isEmpty()){
                insert lstContacts;
                //u1.ContactId = lstContacts[0].id;
                //update u1;
            }
                
            System.debug('Contact list -->'+lstContacts);
             
            
              //create createServiceAccount
            for(Integer i=0; i<=1; i++){
                lstserAcc.add(AHFC_TestDataFactory.createServiceAccount(lstContacts[i]?.Id));
                lstserAcc[i].Name ='Test'+i;
                lstserAcc[i].Finance_Account_Number__c='123456'+i;
            }
            if(!lstserAcc.isEmpty()){
                insert lstserAcc;
                 system.debug('Service Account '+lstserAcc[0].id);
            }
            
                //create 1 customer finance account
                lstSACs.add(AHFC_TestDataFactory.createFinanceAccountCustomer(lstserAcc[0].id,lstAccounts[0].id));
                insert lstSACs;
            	system.debug('Cust Fin Acc -->'+lstSACs);
              
        List<User> usr = [SELECT Id, Name FROM User where firstName ='John'];
         system.debug('usr[0]'+usr[0]);
      
      string contactRecid=[SELECT Id, AccountId, ContactId FROM User where id =:u1.id].ContactId;
      string accRecid=[SELECT Id, AccountId, ContactId FROM User where id =:u1.id].AccountId;
      system.debug('contactRecid'+contactRecid);
 	  system.debug('accRecId '+accRecid);
      
        System.runAs(u1){
            Test.startTest();
             SCRA_SelectedfinanceAccountList.getFinanceAccountnumberList(u1.id);
            
            
            Test.stopTest();
        }
    }    
}
}