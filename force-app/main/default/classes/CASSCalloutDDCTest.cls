@isTest
public class CASSCalloutDDCTest {
@isTest  
    Private static void PastDueAccount_Test(){
        
        //Create Past Due Finance Account
        
        String ContactId;
        Boolean isUpdate = false;
        Finance_Account__c f = new Finance_Account__c();
        setFinAcctValues(f);
        f.Past_Amount_Due__c = 200;
        f.Total_Fees_Due__c = 100;
        insert f;
        system.debug(f.id);
       
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=f.Id;
        
        insert cPref;
        ProvisionCustomerUserController.RequestWrapper registrationRequest = new ProvisionCustomerUserController.RequestWrapper();
        
        registrationRequest.userEmail = 'test@test.com';
        registrationRequest.userName = 'test123';
        registrationRequest.eCustomerId = '12345';
        registrationRequest.accountNumber = '123123123';
        registrationRequest.eDelivery = 'true';
        Test.startTest();
        	ProvisionCustomerUserController.ResponseWrapper registrationResponse
            	= ProvisionCustomerUserController.Customerlogic(registrationRequest);
        	
        	
        	system.debug(registrationResponse);
        test.stopTest();
        
     list<User> u = [Select id, userName,contactId from user where createddate=today];
     ContactId = u[0].contactId;
     
     //Update fin acct to make it grant new user access to it 
     for(Finance_Account__c fAccount : [ Select Id, Customer__c, Contact__c, Finance_Account_Number__c from Finance_Account__c 
                                           Where id = :f.id ])
     {
         
         
         if(fAccount.Contact__c != contactId){
             fAccount.Contact__c =  contactId;
             update fAccount; 
         }
     }
     
                 
     system.debug(u.size());
        
     System.runAs(u[0]) {
              // The following code runs as user 'u'
              System.debug('Current User: ' + UserInfo.getUserName());
              System.debug('Current Profile: ' + UserInfo.getProfileId());
        DDCDetails DDCReq = new DDCDetails(f.id, 24);      
        String ValidationResult = CassCalloutDDC.ValidateRequest(DDCReq);
        System.debug(ValidationResult);
        system.debug(DDCReq);
        //system.assertEquals('Invalid Request',ValidationResult);
        //system.assertEquals('Past Due Account',DDCReq.ErrorMessages[0]);
       
          } 
      
    } 
    
    @istest
     Private static void FA_Id_Blank_Test(){
        Finance_Account__c f = new Finance_Account__c();
        setFinAcctValues(f);
        f.Past_Amount_Due__c = 200;
        f.Total_Fees_Due__c = 100;
        insert f;
        system.debug(f.id);
         
        DDCDetails DDCReq = new DDCDetails('', 28);  
         String ValidationResult = CassCalloutDDC.ValidateRequest(DDCReq);
        System.debug(ValidationResult);
        system.debug(DDCReq);
        //system.assertEquals('Invalid Request',ValidationResult);
        //system.assertEquals('Null Finance Account',DDCReq.ErrorMessages[0]);
         
     }
    
     @istest
     Private static void DueDayGreaterThan28_Test(){
        Finance_Account__c f = new Finance_Account__c();
        setFinAcctValues(f);
        f.Past_Amount_Due__c = 200;
        f.Total_Fees_Due__c = 100;
        insert f;
        system.debug(f.id);
         
        DDCDetails DDCReq = new DDCDetails(f.id, 29);  
         String ValidationResult = CassCalloutDDC.ValidateRequest(DDCReq);
        System.debug(ValidationResult);
        system.debug(DDCReq);
        //system.assertEquals('Invalid Request',ValidationResult);
        //system.assertEquals('Invalid Due Day',DDCReq.ErrorMessages[0]);
         
     }
    
    
    private static void setFinAcctValues(finance_account__c f){
        f.Finance_Account_Number__c= '123123123' ;
        f.Honda_Brand__c='AFS';
        f.IsUpdated__c=true;
        f.Fl_Suppress_All_Notifications__c = true;
        f.Account_Type__c = 'Retail' ;
        f.Payment_Due_Date__c = date.today();
        f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
        f.Fl_Extend_Recurring_Payment_Today__c = true ;
        f.Regular_Monthly_Payment__c=200;
        
        f.Next_Due_Date__c = date.today();
        
    }
    
    @istest
     Private static void Invalid_User_Test(){
        Finance_Account__c f = new Finance_Account__c();
        setFinAcctValues(f);
        f.Past_Amount_Due__c = 200;
        f.Total_Fees_Due__c = 100;
        insert f;
        system.debug(f.id);
         
        DDCDetails DDCReq = new DDCDetails('12345', 28);  
         String ValidationResult = CassCalloutDDC.ValidateRequest(DDCReq);
        System.debug(ValidationResult);
        system.debug(DDCReq);
        //system.assertEquals('Invalid Request',ValidationResult);
        //system.assertEquals('Could Not Retrieve User',DDCReq.ErrorMessages[0]);
         
     }
    private static void setComPrefValues(communication_preferences__c cPref){
        
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Payment_Confirmations_via_Text__c=true;
        cPref.EasyPay_Communications_via_Text__c =true;
        cPref.Text_Number__c='9992223334';
        cPref.Email_Address__c='test@123.com';
        cPref.Email_BounceBack_Count__c=5; 
        cPref.EmailBouncedDate__c=null;
    }

@isTest
Private static void PaidTodateEmpty_Test(){
        
        //Create Past Due Finance Account
        
        String ContactId;
        Boolean isUpdate = false;
        Finance_Account__c f = new Finance_Account__c();
        setFinAcctValues(f);
        //f.Past_Amount_Due__c = 200;
        //f.Total_Fees_Due__c = 100;
        insert f;
        system.debug(f.id);
       
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=f.Id;
        
        insert cPref;
        ProvisionCustomerUserController.RequestWrapper registrationRequest = new ProvisionCustomerUserController.RequestWrapper();
        
        registrationRequest.userEmail = 'test@test.com';
        registrationRequest.userName = 'test123';
        registrationRequest.eCustomerId = '12345';
        registrationRequest.accountNumber = '123123123';
        registrationRequest.eDelivery = 'true';
        Test.startTest();
        	ProvisionCustomerUserController.ResponseWrapper registrationResponse
            	= ProvisionCustomerUserController.Customerlogic(registrationRequest);
        	
        	
        	system.debug(registrationResponse);
        test.stopTest();
        
     list<User> u = [Select id, userName,contactId from user where createddate=today];
     ContactId = u[0].contactId;
     
     //Update fin acct to make it grant new user access to it 
     for(Finance_Account__c fAccount : [ Select Id, Customer__c, Contact__c, Finance_Account_Number__c from Finance_Account__c 
                                           Where id = :f.id ])
     {
         
         
         if(fAccount.Contact__c != contactId){
             fAccount.Contact__c =  contactId;
             update fAccount; 
         }
     }
     
                 
     system.debug(u.size());
        
     System.runAs(u[0]) {
              // The following code runs as user 'u'
              System.debug('Current User: ' + UserInfo.getUserName());
              System.debug('Current Profile: ' + UserInfo.getProfileId());
        DDCDetails DDCReq = new DDCDetails(f.id, 24);      
        String ValidationResult = CassCalloutDDC.ValidateRequest(DDCReq);
        System.debug(ValidationResult);
        system.debug(DDCReq);
        //system.assertEquals('Invalid Request',ValidationResult);
        //system.assertEquals('Paid to Date or First Due Date is Empty',DDCReq.ErrorMessages[0]);
       
          } 
      
    }     

@isTest
Private static void AutoProcessing_Test(){
        
        //Create Past Due Finance Account
        
        String ContactId;
        Boolean isUpdate = false;
        Finance_Account__c f = new Finance_Account__c();
        setFinAcctValues(f);
        f.Paid_to_Date__c = Date.newInstance(2024, 11, 25) ;
    	f.First_Due_Date__c = Date.newInstance(2020, 01, 25) ;
        
        insert f;
        system.debug(f.id);
       
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=f.Id;
        
        insert cPref;
        ProvisionCustomerUserController.RequestWrapper registrationRequest = new ProvisionCustomerUserController.RequestWrapper();
        
        registrationRequest.userEmail = 'test@test.com';
        registrationRequest.userName = 'test123';
        registrationRequest.eCustomerId = '12345';
        registrationRequest.accountNumber = '123123123';
        registrationRequest.eDelivery = 'true';
        Test.startTest();
        	ProvisionCustomerUserController.ResponseWrapper registrationResponse
            	= ProvisionCustomerUserController.Customerlogic(registrationRequest);
        	
        	
        	system.debug(registrationResponse);
        test.stopTest();
        
     list<User> u = [Select id, userName,contactId from user where createddate=today];
     ContactId = u[0].contactId;
     
     //Update fin acct to make it grant new user access to it 
     for(Finance_Account__c fAccount : [ Select Id, Customer__c, Contact__c, Finance_Account_Number__c from Finance_Account__c 
                                           Where id = :f.id ])
     {
         
         
         if(fAccount.Contact__c != contactId){
             fAccount.Contact__c =  contactId;
             update fAccount; 
         }
     }
     
                 
     system.debug(u.size());
        
     System.runAs(u[0]) {
              // The following code runs as user 'u'
              System.debug('Current User: ' + UserInfo.getUserName());
              System.debug('Current Profile: ' + UserInfo.getProfileId());
        DDCDetails DDCReq = new DDCDetails(f.id, 24);      
        String ValidationResult = CassCalloutDDC.ValidateRequest(DDCReq);
        System.debug(ValidationResult);
        system.debug(DDCReq);
        //system.assertEquals('Process Automatically',ValidationResult);
        //system.assertEquals(null,DDCReq.ErrorMessages[0]);
       
          } 
      
    }     
        
@isTest
Private static void NewAccount_Test(){
        
        
        
        String ContactId;
        Boolean isUpdate = false;
        Finance_Account__c f = new Finance_Account__c();
        setFinAcctValues(f);
        f.Paid_to_Date__c = Date.newInstance(2020, 05, 25) ;
    	f.First_Due_Date__c = Date.newInstance(2020, 05, 25) ;
        
        insert f;
        system.debug(f.id);
       
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=f.Id;
        
        insert cPref;
        ProvisionCustomerUserController.RequestWrapper registrationRequest = new ProvisionCustomerUserController.RequestWrapper();
        
        registrationRequest.userEmail = 'test@test.com';
        registrationRequest.userName = 'test123';
        registrationRequest.eCustomerId = '12345';
        registrationRequest.accountNumber = '123123123';
        registrationRequest.eDelivery = 'true';
        Test.startTest();
        	ProvisionCustomerUserController.ResponseWrapper registrationResponse
            	= ProvisionCustomerUserController.Customerlogic(registrationRequest);
        	
        	
        	system.debug(registrationResponse);
        test.stopTest();
        
     list<User> u = [Select id, userName,contactId from user where createddate=today];
     ContactId = u[0].contactId;
     
     //Update fin acct to make it grant new user access to it 
     for(Finance_Account__c fAccount : [ Select Id, Customer__c, Contact__c, Finance_Account_Number__c from Finance_Account__c 
                                           Where id = :f.id ])
     {
         
         
         if(fAccount.Contact__c != contactId){
             fAccount.Contact__c =  contactId;
             update fAccount; 
         }
     }
     
                 
     system.debug(u.size());
        
     System.runAs(u[0]) {
              // The following code runs as user 'u'
              System.debug('Current User: ' + UserInfo.getUserName());
              System.debug('Current Profile: ' + UserInfo.getProfileId());
        DDCDetails DDCReq = new DDCDetails(f.id, 24);      
        String ValidationResult = CassCalloutDDC.ValidateRequest(DDCReq);
        System.debug(ValidationResult);
        system.debug(DDCReq);
       // system.assertEquals('Process Manually',ValidationResult);
       // system.assertEquals('New Account',DDCReq.ErrorMessages[0]);
       
          } 
      
    }         
   
    @isTest
Private static void PastDueAccountWithPymts_Test(){
        
        //Create Past Due Finance Account
        
        String ContactId;
        Boolean isUpdate = false;
        Finance_Account__c f = new Finance_Account__c();
        setFinAcctValues(f);
        f.Past_Amount_Due__c = 200;
        f.Total_Fees_Due__c = 100;
        
        insert f;
        system.debug(f.id);
       
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=f.Id;
        
        insert cPref;
    
    
    
    //Insert OTP
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c=f.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=300;
        ch.Payment_Channel__c = 'W';
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        ch.Payment_Display_Status__c='Pending';
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';  
        ch.ChargentOrders__Payment_Start_Date__c=System.today();
        ch.ChargentOrders__Payment_End_Date__c=System.today()+30;
        ch.ChargentOrders__Charge_Date__c='1';
        insert ch;
  
    
    
    
        ProvisionCustomerUserController.RequestWrapper registrationRequest = new ProvisionCustomerUserController.RequestWrapper();
        
        registrationRequest.userEmail = 'test@test.com';
        registrationRequest.userName = 'test123';
        registrationRequest.eCustomerId = '12345';
        registrationRequest.accountNumber = '123123123';
        registrationRequest.eDelivery = 'true';
        Test.startTest();
        	ProvisionCustomerUserController.ResponseWrapper registrationResponse
            	= ProvisionCustomerUserController.Customerlogic(registrationRequest);
        	
        	
        	system.debug(registrationResponse);
        test.stopTest();
        
     list<User> u = [Select id, userName,contactId from user where createddate=today];
     ContactId = u[0].contactId;
     
     //Update fin acct to make it grant new user access to it 
     for(Finance_Account__c fAccount : [ Select Id, Customer__c, Contact__c, Finance_Account_Number__c from Finance_Account__c 
                                           Where id = :f.id ])
     {
         
         
         if(fAccount.Contact__c != contactId){
             fAccount.Contact__c =  contactId;
             update fAccount; 
         }
     }
     
                 
     system.debug(u.size());
        
     System.runAs(u[0]) {
              // The following code runs as user 'u'
              System.debug('Current User: ' + UserInfo.getUserName());
              System.debug('Current Profile: ' + UserInfo.getProfileId());
        DDCDetails DDCReq = new DDCDetails(f.id, 24);      
        String ValidationResult = CassCalloutDDC.ValidateRequest(DDCReq);
        System.debug(ValidationResult);
        system.debug(DDCReq);
        //system.assertEquals('Process Manually',ValidationResult);
       // system.assertEquals('Past Due Account with same day Payments',DDCReq.ErrorMessages[0]);
       
          } 
      
    }     
    
@isTest
Private static void PaidAhead_Test(){
        
        //Create Past Due Finance Account
        
        String ContactId;
        Boolean isUpdate = false;
        Finance_Account__c f = new Finance_Account__c();
        setFinAcctValues(f);
        f.Paid_to_Date__c = Date.newInstance(2020, 01, 24) ;
    	f.First_Due_Date__c = Date.newInstance(2020, 01, 25) ;
        
        insert f;
        system.debug(f.id);
       
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=f.Id;
        
        insert cPref;
        ProvisionCustomerUserController.RequestWrapper registrationRequest = new ProvisionCustomerUserController.RequestWrapper();
        
        registrationRequest.userEmail = 'test@test.com';
        registrationRequest.userName = 'test123';
        registrationRequest.eCustomerId = '12345';
        registrationRequest.accountNumber = '123123123';
        registrationRequest.eDelivery = 'true';
        Test.startTest();
        	ProvisionCustomerUserController.ResponseWrapper registrationResponse
            	= ProvisionCustomerUserController.Customerlogic(registrationRequest);
        	
        	
        	system.debug(registrationResponse);
        test.stopTest();
        
     list<User> u = [Select id, userName,contactId from user where createddate=today];
     ContactId = u[0].contactId;
     
     //Update fin acct to make it grant new user access to it 
     for(Finance_Account__c fAccount : [ Select Id, Customer__c, Contact__c, Finance_Account_Number__c from Finance_Account__c 
                                           Where id = :f.id ])
     {
         
         
         if(fAccount.Contact__c != contactId){
             fAccount.Contact__c =  contactId;
             update fAccount; 
         }
     }
     
                 
     system.debug(u.size());
        
     System.runAs(u[0]) {
              // The following code runs as user 'u'
              System.debug('Current User: ' + UserInfo.getUserName());
              System.debug('Current Profile: ' + UserInfo.getProfileId());
        DDCDetails DDCReq = new DDCDetails(f.id, 24);      
        String ValidationResult = CassCalloutDDC.ValidateRequest(DDCReq);
        System.debug(ValidationResult);
        system.debug(DDCReq);
        //system.assertEquals('Process Automatically',ValidationResult);
        //system.assertEquals(null,DDCReq.ErrorMessages[0]);
        
       
          } 
      
    }     

}