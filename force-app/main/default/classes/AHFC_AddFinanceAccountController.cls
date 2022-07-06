/* Apex Class Name   :    AHFC_AddFinanceAccountController
* @description        :    This Class is used to update Custom Finance Account records
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               May 04 2021             Created
* Akash Solanki				  Aug 10 2021			  Modified - Updated to accomodate all the scenarios which can or cannot lead to creation of junction record from add account page.
*********************************************************************************/
/**
* @description AHFC_AddFinanceAccountController 
*/
public without sharing class AHFC_AddFinanceAccountController {
    /**
* @description This method will return the logged in user record
* @author Akash Solanki | May 04 2021
* @return User
* @param
**/
    @AuraEnabled(cacheable=true)
    public static User fetchuserdetails(){
        User usrRec;
        try {
            usrRec = [Select Name,Firstname, Email, ContactId
                      FROM User 
                      WHERE id =:UserInfo.getuserid() LIMIT 1];
            
        } 
        catch (Exception e) {
            String exdetails = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString();
            throw new AuraHandledException(exdetails); 
        }
        return usrRec;
    }
    
    /**
* @description This method will return if a person account has even a single finance account
* @author Akash Solanki | May 31 2021
* @return boolean
**/
    @AuraEnabled(cacheable=true)
    public static boolean getFinanceAccountWithActiveJunction(String finAcctNo){
        List<Customer_Finance_Account__c> cfa = new List<Customer_Finance_Account__c>();
        boolean accountExists = false;
        List<Finance_account__c> finAcct = [select Id from finance_account__c where Finance_Account_Number__c =: finAcctNo];
        system.debug('finAcct'+finAcct);
        if(!finAcct.isEmpty()){
            list<Customer_Finance_Account__c> cfaNew = [Select Id, Customer__c from Customer_Finance_Account__c where Finance_Account__c =: finAcct[0].Id];
            system.debug('cfaNew'+cfaNew);
            for(Customer_Finance_Account__c cf :cfaNew){
                cfa.add(cf);
            }
            if(!cfa.isEmpty()){
                accountExists=true;
            }
            else{
                accountExists=false;
            }
        }else{
            accountExists=false;
        }
        system.debug('accountExists=='+accountExists);
        return accountExists;
        
    }
    
    /**
* @description This method will return if a person account has even a single finance account
* @author Akash Solanki | May 31 2021
* @return boolean
**/ 
    @AuraEnabled
    public static boolean getFinanceAccountExists(){
        Account acc = fetchPersonAccount();    
                
        List<Customer_Finance_Account__c> cfa = new List<Customer_Finance_Account__c>();
        list<Customer_Finance_Account__c> cfaNew = new list<Customer_Finance_Account__c>();
        
        if(acc !=null){
            cfaNew  = [Select Id, Customer__c from Customer_Finance_Account__c where customer__c =: acc.Id and is_active__c = true];
        }        
       
        boolean accountExists1 = false;
        
        if(cfaNew.size()>0){
            accountExists1= true;
        }
        
        return accountExists1;
        
    }
    
    /**
* @description This method will return the person account associated with the logged in user
* @author Akash Solanki | May 04 2021
* @return person Account
* @param
**/
    public static Account fetchPersonAccount(){
        Id accId = [Select Contact.AccountId FROM User WHERE Id =: userinfo.getUserId() WITH Security_Enforced].Contact.AccountId;
        
        Account accRec = [Select Id, Name, PersonEmail 
                          FROM Account 
                          WHERE Id = :accId WITH Security_Enforced LIMIT 1];
        if(accRec!=null){
            return accRec;
        }else{
            return null;
        }
    }
    /**
* @description This method will return the customer finance record associated which will link finance account to the person account
* @author Akash Solanki | May 04 2021
* @return<String> returns the message in form of string
* @param vinNumber : 17 digit VIN number coming from UI
@param zipCode : 5 digit zip code coming from UI
@param last4Digits : 4 digits SSN coming from UI 
@param strFedId : Fed Id coming from UI for successful navigation to Landing page
@param strEmail : Email coming from UI
@return String

**/
    @AuraEnabled
    public static string createCustomerFinanceAccount(String vinNumber, String zipCode, String last4Digits, String strFedId, String strEmail){
        set<Id> finAcctSet = new set<Id>();
        String returnVar;
        Boolean isActiveAcct = false;
        try {
            list<Customer_Finance_Account__c> listcustFinAccRec = new list<Customer_Finance_Account__c>(); 
            list<Finance_Account__c> lstFinAccts = [SELECT id,Finance_Account_Number__c,AHFC_Last_4_SSN__c,AHFC_Web_Manage_Online__c 
                                                    from Finance_Account__c
                                                    where AHFC_Last_4_SSN__c =:last4Digits 
                                                    AND Vehicle_Identification_Number__c =:vinNumber
                                                    AND AHFC_Garaging_Zip__c =:zipCode]; //querying finance account related to the inputs from UI add account page
            
            if(!lstFinAccts.isEmpty() && lstFinAccts != null){  
                for(Finance_Account__c fa: lstFinAccts){
                    finAcctSet.add(fa.Id);
                }
            }
            list<Customer_Finance_Account__c> cfa = [select Id, customer__c,Finance_Account__c,Is_Active__c  
                                                     from Customer_Finance_Account__c
                                                     where Finance_Account__c IN :finAcctSet]; // querying customer finance account junction record against the finance account
            Account loggedInUserAccount = fetchPersonAccount(); // querying person account presented against the user
            
            if(!lstFinAccts.isEmpty() && loggedInUserAccount != null){
                if(cfa.isEmpty()){  // if not junction record found against the finance account then junction record is created only if AHFC_Web_Manage_Online__c is not N and user is redirected to dashboard.
                    if(lstFinAccts[0].AHFC_Web_Manage_Online__c != 'N'){
                        Customer_Finance_Account__c cfaRec = new Customer_Finance_Account__c();
                        cfaRec.Customer__c = loggedInUserAccount.Id;
                        cfaRec.Finance_Account__c =  lstFinAccts[0].Id;
                        cfaRec.Is_Active__c = true;
                        listcustFinAccRec.add(cfaRec);
                    }else{
                        returnVar = 'Web_Add_Account_To_Manage_Online'; //if this AHFC_Web_Manage_Online__c value in finance account record is N
                    }
                    try{
                        if(!listcustFinAccRec.isEmpty() && Schema.sObjectType.Customer_Finance_Account__c.fields.Customer__c.isupdateable()){
                            
                            insert listcustFinAccRec; // inserting junction object customer finance account record.
                            returnVar = 'SUCCESS';
                        }
                    } catch(Exception e){
                        returnVar = 'Database Error';
                    }      
                }else{ // If the junction record exists against the finance account either active or inactive
                    for(customer_finance_account__c objCFA : cfa){
                        if(objCFA.Is_Active__c == true){
                            isActiveAcct = true; //setting this flag to identify if active junction record is there against finance account
                        }
                    }
                    if(isActiveAcct){
                        returnVar = System.label.AHFC_ServiceAccExistsError; //if active then finance account is already registered
                    }else{
                        if(lstFinAccts[0].AHFC_Web_Manage_Online__c != 'N'){
                            Customer_Finance_Account__c cfaRec = new Customer_Finance_Account__c();
                            cfaRec.Customer__c = loggedInUserAccount.Id;
                            cfaRec.Finance_Account__c =  lstFinAccts[0].Id;
                            cfaRec.Is_Active__c = true;
                            insert cfaRec;
                            returnVar = 'SUCCESS';
                        }
                        else{
                            returnVar = 'Web_Add_Account_To_Manage_Online';
                        }
                    }
                }
            }else{ // if vin number or zip code or ssn doesnot match or ssn doesnot match then code will come to this part
                List<Finance_Account__c> lstfinAccCustNotEqualSSN=[SELECT id,Finance_Account_Number__c,AHFC_Last_4_SSN__c,AHFC_Web_Manage_Online__c 
                                                                   from Finance_Account__c
                                                                   where Vehicle_Identification_Number__c =:vinNumber];
                
                if(!lstfinAccCustNotEqualSSN.isEmpty() && loggedInUserAccount != null){
                    returnVar = System.label.AHFC_Account_No_Match_Criteria ;  
                }else{
                    returnVar = System.label.AHFC_Account_Not_Found;
                }
            }
            
        } catch (Exception e) {
            returnVar = e.getMessage();
        }
        return returnVar;
    }
    /**
* @description This method will return the customer finance record associated which will link finance account to the person account
* @author Akash Solanki | May 04 2021
* @return<String> returns the message in form of string
* @param accountNumber : 8 or 9 digit account number coming from UI
@param last4Digits : 4 digits SSN coming from UI 
@param strFedId : Fed Id coming from UI for successful navigation to Landing page
@param strEmail : Email coming from UI
@return String
**/
    @AuraEnabled
    public static String updateCustomerFinanceAccount(String accountNumber, String last4Digits, String strFedId, String strEmail){
        set<Id> finAcctSet = new set<Id>();
        String returnVar;
        Boolean isActiveAcct = false;
        string accountNumberWithZero = '00000' + accountNumber; // added for bug-id 22946
        list<Customer_Finance_Account__c> listcustFinAccRec = new list<Customer_Finance_Account__c>();
        list<Finance_Account__c> lstFinAccts = [SELECT id,Finance_Account_Number__c,AHFC_Last_4_SSN__c,AHFC_Web_Manage_Online__c 
                                                from Finance_Account__c
                                                where AHFC_Last_4_SSN__c =:last4Digits 
                                                //AND Finance_Account_Number_Without_Zeroes__c =:accountNumber]; //querying finance account related to the inputs from UI add account page
                                                AND Finance_Account_Number__c =:accountNumberWithZero]; //querying finance account related to the inputs from UI add account page
        if(!lstFinAccts.isEmpty() && lstFinAccts != null){
            for(Finance_Account__c fa: lstFinAccts){
                finAcctSet.add(fa.Id);
            }
        }
        list<Customer_Finance_Account__c> cfa = [select Id, Is_Active__c,customer__c,Finance_Account__c 
                                                 from Customer_Finance_Account__c
                                                 where Finance_Account__c IN :finAcctSet]; // querying customer finance account junction record against the finance account
        Account loggedInUserAccount = fetchPersonAccount(); // querying person account presented against the user
        
        if(!lstFinAccts.isEmpty() && loggedInUserAccount != null){
            if(cfa.isEmpty()){		// if not junction record found against the finance account then junction record is created only if AHFC_Web_Manage_Online__c is not N and user is redirected to dashboard.
                if(lstFinAccts[0].AHFC_Web_Manage_Online__c != 'N'){
                    Customer_Finance_Account__c cfaRec = new Customer_Finance_Account__c();
                    cfaRec.Customer__c = loggedInUserAccount.Id;
                    cfaRec.Finance_Account__c =  lstFinAccts[0].Id;
                    cfaRec.Is_Active__c = true;
                    listcustFinAccRec.add(cfaRec);
                }else{
                    returnVar = 'Web_Add_Account_To_Manage_Online';//if this AHFC_Web_Manage_Online__c value in finance account record is N
                }
                try{
                    if(!listcustFinAccRec.isEmpty() && Schema.sObjectType.Customer_Finance_Account__c.fields.Customer__c.isupdateable()){
                        
                        insert listcustFinAccRec;// inserting junction object customer finance account record.
                        returnVar = 'SUCCESS';
                    }
                } catch(Exception e){
                    returnVar = 'Database Error';
                }  
            }else{ 		// If the junction record exists against the finance account either active or inactive
                for(customer_finance_account__c objCFA : cfa){
                    if(objCFA.Is_Active__c == true){
                        isActiveAcct = true;	//setting this flag to identify if active junction record is there against finance account
                    }
                }
                if(isActiveAcct){
                    returnVar = System.label.AHFC_ServiceAccExistsError;	//if active then finance account is already registered
                }else{
                    if(lstFinAccts[0].AHFC_Web_Manage_Online__c != 'N'){
                        Customer_Finance_Account__c cfaRec = new Customer_Finance_Account__c();
                        cfaRec.Customer__c = loggedInUserAccount.Id;
                        cfaRec.Finance_Account__c =  lstFinAccts[0].Id;
                        cfaRec.Is_Active__c = true;
                        insert cfaRec;
                        returnVar = 'SUCCESS';
                    }
                    else{
                        returnVar = 'Web_Add_Account_To_Manage_Online';
                    }
                }
            }
        }else{	// if finance number doesnot match or ssn doesnot match then code will come to this part
            List<Finance_Account__c> lstfinAccCustNotEqualSSN=[SELECT id,Finance_Account_Number__c,AHFC_Last_4_SSN__c,AHFC_Web_Manage_Online__c 
                                                               from Finance_Account__c
                                                               //where Finance_Account_Number_Without_Zeroes__c =:accountNumber];
            													where Finance_Account_Number__c =:accountNumberWithZero];
            if(!lstfinAccCustNotEqualSSN.isEmpty() && loggedInUserAccount != null){
                returnVar = System.label.AHFC_Account_No_Match_Criteria ;  
            }else{
                returnVar = System.label.AHFC_Account_Not_Found;
            }
        }
        
        return returnVar;
    }
    
    /**
* 	@description 			: US 4965 This method will check the flags on the basis of 3 checkboxes check on the Add Account Page under customer's email.
* 	@author 				: Akash Solanki | Aug 23 2021
* 	@return<String> 		: returns the message in form of string
* 	@param accountNumber 	: 8 or 9 digit account number coming from UI
*	@param billingCheck 	: Finance Account Updates and Payment Activity checkbox on Add Account Page
*	@param paymentCheck 	: Paperless Statements & Correspondence checkbox on Add Account Page
*	@param offersCheck 		: Special Offers & Promotions checkbox on Add Account Page
*	@return String
**/
    @AuraEnabled
    public static String updateCommPrefs(String accountNumber,String billingCheck, String paymentCheck, String offersCheck, String customerEmail){
        
      //  Set<String> finAcctNumSet = new set<String>();
        String msg = '';
        string accountNumberWithZero = '00000' + accountNumber; // added for bug-id 22946
        List<Communication_Preferences__c> updatedCommPrefs = new List<Communication_Preferences__c>();
        
        try{
            list<Finance_Account__c> lstFinAccts = [SELECT id,Finance_Account_Number__c
                                                    from Finance_Account__c
                                                    //where Finance_Account_Number_Without_Zeroes__c =:accountNumber]; //querying finance account related to the inputs from UI add account page
            										where Finance_Account_Number__c =:accountNumberWithZero]; //querying finance account related to the inputs from UI add account page
            
            if(!lstFinAccts.isEmpty()){
                list<Communication_Preferences__c> commPrefsFinAcct = [select Id, Account_Status_Updates_via_Email__c,Payment_Profile_Updates_via_Email__c,
                                                                       Payment_Reminders_via_Email__c ,Payment_Confirmations_via_Email__c ,
                                                                       Marketing_Communications_Via_Email__c, Paperless_Statements_Letters__c,
                                                                       Statements_Letters__c, Email_Address__c,
                                                                       EasyPay_Communications_via_Email__c 
                                                                       from Communication_Preferences__c  
                                                                       where Finance_Account_Number__c =: lstFinAccts[0].Id]; //querying communication preference related to entered finance account
                if(!commPrefsFinAcct.isEmpty() && commPrefsFinAcct !=null){
                    for(Communication_Preferences__c commpref: commPrefsFinAcct){
                        commpref.Email_Address__c = customerEmail;
                        if(billingCheck == 'true'){ // When "Finance Account Updates and Payment Activity" is checked on add Account Page
                            commpref.Account_Status_Updates_via_Email__c 	= true;
                            commpref.Payment_Reminders_via_Email__c 		= true;
                            commpref.Payment_Confirmations_via_Email__c	    = true;
                            commpref.EasyPay_Communications_via_Email__c 	= true;
                            commpref.Payment_Profile_Updates_via_Email__c   = true;
                        }
                        else{
                            commpref.Account_Status_Updates_via_Email__c  = false;
                            commpref.Payment_Reminders_via_Email__c       = false;
                            commpref.Payment_Confirmations_via_Email__c   = false;
                            commpref.EasyPay_Communications_via_Email__c  = false;
                            commpref.Payment_Profile_Updates_via_Email__c = false;
                        }
                        if(paymentCheck == 'true'){ // When "Paperless Statements & Correspondence" is checked on add Account Page
                            commpref.Paperless_Statements_Letters__c = true;
                            commpref.Statements_Letters__c  = 'eDelivery';
                        }else{
                            commpref.Paperless_Statements_Letters__c = false;
                            commpref.Statements_Letters__c  = 'Paper';
                        }
                        if(offersCheck == 'true'){ // When "Special Offers & Promotions" is checked on add Account Page
                            commpref.Marketing_Communications_Via_Email__c  = true;
                        }else{
                            commpref.Marketing_Communications_Via_Email__c  = false;
                        }
                        updatedCommPrefs.add(commpref);
                        msg = 'SUCCESS'; 	// returns success message when update is done successfully
                    }
                    Communication_Preferences__c commPref = updatedCommPrefs[0];
                    Boolean successFlag = false;
                    UpdateEDeliveryPreferenceService edeliveryService = new UpdateEDeliveryPreferenceService();
                    successFlag = edeliveryService.updateEDeliveryPreference(commPref.Paperless_Statements_Letters__c, commPref.Email_Address__c, lstFinAccts[0].Finance_Account_Number__c);
                    if(successFlag){
                        update updatedCommPrefs;
                    }else{
                        msg = 'commPref Update Failed';
                    }
                    
                }else{
                        msg = 'commPref Update Failed';
                    }
            }
        }catch(exception e){
            msg = 'FAILURE'; // returns Failure message when update fails.
        }
        return msg;
    }
    
    /**
* 	@description 			: US 6850 This method will retutn finance account number.
* 	@return<List> 			: returns the finacnce account no in form of list
@Author 				: Narain 
**/
    @AuraEnabled 
    public static  String  getFinanceAccount(String accountNumber, String last4Digits){        
        String financeAccountNo;
        string accountNumberWithZero = '00000' + accountNumber; // added for bug-id 22946
        list<Finance_Account__c> listFinAcct  = [SELECT id,Finance_Account_Number__c,AHFC_Last_4_SSN__c,AHFC_Web_Manage_Online__c 
                                                 from Finance_Account__c
                                                 where AHFC_Last_4_SSN__c =:last4Digits 
                                                 //AND Finance_Account_Number_Without_Zeroes__c =:accountNumber ]; //querying finance account related to the inputs from UI add account page
                                                 AND Finance_Account_Number__c =:accountNumberWithZero ]; //querying finance account related to the inputs from UI add account page
        if(listFinAcct.size()>0)
        {
            for(Finance_Account__c financeAccountDetails : listFinAcct)
            {
                financeAccountNo =financeAccountDetails.Id;
            }
        }
        return financeAccountNo;
        
    }
    
    
    /**
* 	@description 			: US 4965 This method will check the flags on the basis of 3 checkboxes check on the Add Account Page under customer's email.
* 	@author 				: Akash Solanki | Aug 23 2021
* 	@return<String> 		: returns the message in form of string
* 	@param Vin			 	: 17 digit Vin number coming from UI
*	@param billingCheck 	: Finance Account Updates and Payment Activity checkbox on Add Account Page
*	@param paymentCheck 	: Paperless Statements & Correspondence checkbox on Add Account Page
*	@param offersCheck 		: Special Offers & Promotions checkbox on Add Account Page
*	@return String
**/
    @AuraEnabled
    public static String updateCommPrefsVinTab(String Vin, String billingCheck, String paymentCheck, String offersCheck, String customerEmail){
        
        //Set<String> finAcctNumSet = new set<String>();
        String msg = '';
        List<Communication_Preferences__c> updatedCommPrefs = new List<Communication_Preferences__c>();
        
        try{
            list<Finance_Account__c> lstFinAccts = [SELECT id,Finance_Account_Number__c
                                                    from Finance_Account__c
                                                    where Vehicle_Identification_Number__c =:Vin]; //querying finance account related to the inputs from UI add account page
            
            if(!lstFinAccts.isEmpty()){
                list<Communication_Preferences__c> commPrefsFinAcct = [select Id, Account_Status_Updates_via_Email__c,Payment_Profile_Updates_via_Email__c,
                                                                       Payment_Reminders_via_Email__c ,Payment_Confirmations_via_Email__c ,
                                                                       Marketing_Communications_Via_Email__c, Paperless_Statements_Letters__c,
                                                                       Statements_Letters__c, EasyPay_Communications_via_Email__c 
                                                                       from Communication_Preferences__c  
                                                                       where Finance_Account_Number__c =: lstFinAccts[0].Id]; //querying communication preference related to entered finance account
                if(!commPrefsFinAcct.isEmpty() && commPrefsFinAcct !=null){
                    for(Communication_Preferences__c commpref: commPrefsFinAcct){
                        commpref.Email_Address__c = customerEmail;
                        if(billingCheck == 'true'){ // When "Finance Account Updates and Payment Activity" is checked on add Account Page
                            commpref.Account_Status_Updates_via_Email__c 	= true;
                            commpref.Payment_Reminders_via_Email__c 		= true;
                            commpref.Payment_Confirmations_via_Email__c	    = true;
                            commpref.EasyPay_Communications_via_Email__c 	= true;
                            commpref.Payment_Profile_Updates_via_Email__c   = true;
                        }
                        else{
                            commpref.Account_Status_Updates_via_Email__c  = false;
                            commpref.Payment_Reminders_via_Email__c       = false;
                            commpref.Payment_Confirmations_via_Email__c   = false;
                            commpref.EasyPay_Communications_via_Email__c  = false;
                            commpref.Payment_Profile_Updates_via_Email__c = false;
                        }
                        if(paymentCheck == 'true'){ // When "Paperless Statements & Correspondence" is checked on add Account Page
                            commpref.Paperless_Statements_Letters__c = true;
                            commpref.Statements_Letters__c  = 'eDelivery';
                        }else{
                            commpref.Paperless_Statements_Letters__c = false;
                            commpref.Statements_Letters__c  = 'Paper';
                        }
                        if(offersCheck == 'true'){ // When "Special Offers & Promotions" is checked on add Account Page
                            commpref.Marketing_Communications_Via_Email__c  = true;
                        }else{
                            commpref.Marketing_Communications_Via_Email__c  = false;
                        }
                        updatedCommPrefs.add(commpref);
                        msg = 'SUCCESS'; 	// returns success message when update is done successfully
                    }
                    Communication_Preferences__c commPref = updatedCommPrefs[0];
                    Boolean successFlag = false;
                    UpdateEDeliveryPreferenceService edeliveryService = new UpdateEDeliveryPreferenceService();
                    successFlag = edeliveryService.updateEDeliveryPreference(commPref.Paperless_Statements_Letters__c, commPref.Email_Address__c, lstFinAccts[0].Finance_Account_Number__c);
                    if(successFlag){
                        update updatedCommPrefs;
                    }else{
                        msg = 'commPref Update Failed';
                    }
                    
                }else{
                        msg = 'commPref Update Failed';
                    }
            }
        }catch(exception e){
            msg = 'FAILURE'; // returns Failure message when update fails.
        }
        return msg;
    }
}