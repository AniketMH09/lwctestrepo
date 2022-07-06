@isTest
public class AHFC_TestDataFactory {
  public static User getTestUser(Id roleId, Id profileId, String firstName, String lastName, Boolean isInsert) {
        String orgId = userInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User rec = new User();
        rec.firstname = firstName;
        rec.lastName = lastName;
        rec.email = uniqueName + '@test' + orgId + '.org';
        rec.Username = uniqueName + '@test' + orgId + '.org';
        rec.EmailEncodingKey = 'ISO-8859-1';
        rec.Alias = uniqueName.substring(18, 23);
        rec.TimeZoneSidKey = 'America/Los_Angeles';
        rec.LocaleSidKey = 'en_US';
        rec.LanguageLocaleKey = 'en_US';
        rec.ProfileId = profileId;
        rec.UserRoleId = roleId;

        if(isInsert) {
            insert rec;
        }
        return rec;
    }
    
    // Create the test accounts
    public static Account createAccount(String recType){
        
        List<RecordType> rt = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND Name =: recType LIMIT 1];
        Account acc = new Account(Name='Test Account');
        if(!rt.isEmpty()){
            //Set the record type of the account 
            acc.RecordTypeId = rt[0].Id;
        }
        return acc;
    }
    
    // Create the test person accounts
    public static Account createPersonAccount(){
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc= new Account(RecordTypeID=recordTypeId, FirstName='Test FName', LastName='Test LName', PersonMailingStreet='test@yahoo.com',
                                 PersonMailingPostalCode='12345', PersonMailingCity='SFO', PersonEmail='test@yahoo.com', 
                                 PersonHomePhone='1234567', PersonMobilePhone='12345678');
        return acc;
    }
    
    // Create the test contacts
     public static Contact createContact(String accountId){
    
        Contact con = new Contact(LastName='Test Contact',Accountid=accountId,
                                  Email='test@gmail.com',Mobilephone='9876543210');
        return con;
    }
    
     public static Finance_Account__c  createServiceAccount(String contactId){
        Finance_Account__c  finAcc = new Finance_Account__c (Name='Test',Contact__c=contactId, AHFC_Garaging_Zip__c='12345',
                                                              Vehicle_Identification_Number__c = '12345678912345678',AHFC_Last_4_SSN__c='1234',Finance_Account_Number__c ='123456789');
        
        return finAcc;
    }
    
    public static Finance_Account__c  createFinanceAccount(String contactId){
        Finance_Account__c  finAcc = new Finance_Account__c (Name='Test',Contact__c=contactId, AHFC_Garaging_Zip__c='12345',
                                                              Vehicle_Identification_Number__c = '12345678912345678',AHFC_Last_4_SSN__c='1234',Finance_Account_Number__c ='123456789');
        
        return finAcc;
    }
    
     public static Customer_Finance_Account__c createFinanceAccountCustomer(Id FinanceAccountId, Id accountId){
        Customer_Finance_Account__c finAccCus = new Customer_Finance_Account__c(Finance_Account__c = FinanceAccountId,
                                                                                        Customer__c = accountId , is_active__c = true);
        return finAccCus;
    }
    
    
       public static ChargentOrders__ChargentOrder__c createpayment(Id IdServAcc,string paymentchannel,string paymenttype,string paymentstatus){
        
        ChargentOrders__ChargentOrder__c objpayment = new ChargentOrders__ChargentOrder__c();
        objpayment.Finance_Account_Number__c = IdServAcc;
        objpayment.ChargentOrders__Payment_Start_Date__c = System.today();
        objpayment.ChargentOrders__Charge_Amount__c = 200;
      
        objpayment.Payment_Channel__c = paymentchannel;
        objpayment.ChargentOrders__Tokenization__c = 'afggyt-7tt65yhhu-uuiuy76';
        objpayment.Payment_Type__c = paymenttype;
        objpayment.Last_Payment_Display_Status__c = paymentstatus;
        
        
        return objpayment;
        
        
    }

    
}