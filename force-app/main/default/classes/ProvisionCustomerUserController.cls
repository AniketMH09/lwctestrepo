/*******************************************************************************************************
    * @author  : SARAVANAN C
    * @date    : 29 SEP 2015
    * @modified : 19 FEB 2016 
    * @group    :  
    * @group-content : 
    * @description : INTEGRATION 3B, PURPOSE : PROVISION B2C USER WITH FIANANCE ACCOUNT.
    * REQUEST 4 PARAMS : USERNAME, EMAIL, FEDERATION ID AND FINANCE ACCOUNT NUMBER
    * FEDERATION ID - UNIQUE KEY TO IDENTIFY USER
    * EMAIL - SEARCH PERSON ACCOUNT BY EMAIL
    * FINANCE ACCOUNT MUST TO PROVIDE PROVISION
    * RELATIONSHIP TO PROVISION THE USER ACCESS:  FINANCE ACCOUNT <-> CUSTOMER FINANCE ACCOUNT (JUNC OBJECT) <-> PERSON ACCOUNT - USER RECORD
    * CREATE AND PROVISION THE USER ACCESS - IF ANY ONE OR COMBINATION OF THE ABOVE RECORD IS MISSING 
********************************************************************************************************/
    
    
@RestResource(urlMapping = '/provisionCustomerUser/*')
global with sharing class ProvisionCustomerUserController {

    public Static Boolean successFlag;

    // REQUEST PARAMETERS   
    global class RequestWrapper {
        public String userEmail;
        public String userName;
        public String eCustomerId;
        public String accountNumber;
        public string eDelivery;
    }

    // RESPONSE PARAMETERS 
    global class ResponseWrapper {
        public String userEmail;
        public String userName;
        public String eCustomerId;
        public String accountNumber;
        public String code;
        public String message;
    }

    
    /*******************************************************************************************************
    * @description : USER PROVISION MAIN CLASS  
    * @param : REQUEST PARAMS 
    * @param : 
    * @return : RETURNS THE RESPONSE WRAPPER CLASS WITH CODE AND MESSAGE
    * @example 
    *  
    *******************************************************************************************************/
    
    @HttpPost
    global static ResponseWrapper Customerlogic(RequestWrapper Body) {
       
       // RESPONSE VARIABLE
       ResponseWrapper respWrapper = new ResponseWrapper();
        
       String FinanceAccId = NULL ;
       // Configuration to trace every payload request
       String isPayloadTraceEnabled = System.Label.Enable_Web_Service_Trace;
       
       // ALL SUB METHODS ARE CALLED INSIDE THIS TRY CATCH BLOCK. FOR ANY EXCEPTION- ERROR LOG OBJECT RECORD WILL BE CREATED
       try { 

            if(!String.isEmpty(isPayloadTraceEnabled) && isPayloadTraceEnabled.equalsIgnoreCase('TRUE'))
            {
                tracePayload(Body);
            }
           
           //QUERY PERSON ACCOUNT RECORD TYPE ID
           RecordType recType = [SELECT id FROM RecordType WHERE SobjectType = 'Account' AND IsPersonType = True];
           String PersonAccRecordTypeId = recType.Id;
           
           //SEARCH USER FOR THE GIVEN FEDERATION ID
           list <User> B2CUsers = [select id, contactid, accountid from User where FederationIdentifier = : Body.eCustomerId];
           System.Debug( 'B2CUsers  ==> ' + B2CUsers  );
           
           //SEARCH PERSON ACCOUNT RECORD FOR THE GIVEN EMAIL ID
           list <Account> personAccounts = [Select id from account where PersonEmail = : Body.userEmail and recordtypeid = : recType.id order by createddate desc ];
           System.Debug( 'personAccounts ==> ' + personAccounts );
           
           //SEARCH FINANCE ACCOUNT BY FINANCE ACCOUNT NUMBER
           list <Finance_Account__c> financeAccounts = [SELECT Id FROM Finance_Account__c WHERE Finance_Account_Number__c = : Body.accountNumber];
           
           List<Customer_Finance_Account__c> JuncObjs  =  New List<Customer_Finance_Account__c> (); 
          
           if( !isFederationIdZero(Body.eCustomerId) ) {
               
               /*******************************************************************************************************
                     SCENARIO 0 : FEDERATION ID IS NULL OR NOT IN SALESFORCE     
                *******************************************************************************************************/
               // UTILITY CLASS TO CREATE ERROR LOG OBJECT RECORD
               String ReqBody = 'Body { userEmail-' + Body.userEmail+'/n UserName' + Body.UserName ;
                    ReqBody += 'eCustomerId -' + Body.eCustomerId +'/n accountNumber' + Body.accountNumber + ' }';
                    
               UtilityClass.logError('INT 3B', 'Invalid Federation Id', Body.accountNumber,  ReqBody );
             
               return SendResponse ( Body, '121', 'Invalid Federation Id' ) ;
               
           
           }else {
           
             if ( !financeAccounts.isEmpty() ) {
               FinanceAccId = financeAccounts[0].Id ;
               
               if ( !B2CUsers.isEmpty() ) {
                   
                     
                    if ( isJuncObjExists ( B2CUsers[0].accountId , financeAccounts[0].Id ) ) {
                    
                        /*******************************************************************************************************
                             SCENARIO 02 : FIANNCE ACCOUNT, PERSON ACCOUNT, USER ACCOUNT AND JUNC OBJECT IS LINKED (ALL SET)    
                        *******************************************************************************************************/
                        //RSS 41959
                        eDeliveryUpdate(Body.AccountNumber,Body.userEmail, Body.eDelivery);
                        return SendResponse ( Body, '111', 'User already Exists' ) ;
                    
                    } else {

                        /*******************************************************************************************************
                             SCENARIO 03 : FIANNCE ACCOUNT, PERSON ACCOUNT, USER ACCOUNT EXISTS BUT JUNC OBJECT IS NOT THERE      
                        *******************************************************************************************************/
                        // CREATE JUNC OBJ
                        CreateJuncObj ( B2CUsers[0].accountId , financeAccounts[0].Id );
                        //RSS 41959
                        eDeliveryUpdate(Body.AccountNumber,Body.userEmail, Body.eDelivery);
                        
                        return SendResponse ( Body, '111', 'User Provisioned Successfully' ) ; 
                        
                    }
                    
               } else {
                    System.debug(' personAccounts ==> ' + personAccounts);
                    if ( !personAccounts.isEmpty() ){
                    // INSIDE THIS CONDITION - PERSON ACCOUNT RECORD IS AVAILABLE   
                    
                       // QUERY USER RECORDS FOR THE AVAILBLE PERSON ACCOUNT IDS
                        List<User> Users = New List<User> ();
                        Users = [SELECT Id, AccountId FROM User WHERE AccountId = :personAccounts[0].Id] ; 
                        
                        /*******************************************************************************************************
                             SCENARIO 05 : PERSON ACCOUNT EXISTS AND ASSOCIATED WITH USER RECORD - CREATE PERSON ACCOUNT, USER RECORD AND CREATE JUNC OBJ       
                        *******************************************************************************************************/
                                
                        if ( !Users.isEmpty() ) {
                            //LOG EXCEPTION
                            // UTILITY CLASS TO CREATE ERROR LOG OBJECT RECORD
                            /* DEFECT 114071 by Sarv 3/30/2016 - Depreciated Logic 
                           String ReqBody = 'Body { userEmail-' + Body.userEmail+'/n UserName' + Body.UserName ;
                                ReqBody += 'eCustomerId -' + Body.eCustomerId +'/n accountNumber' + Body.accountNumber +'}';
                                
                           UtilityClass.logError('INT 3B', 'Email Already Associated with another Federation Id', Body.accountNumber,  ReqBody );
                           
                           return SendResponse ( Body, '121', 'Email Already Associated with another Federation Id' ) ;  
                           */ 
                           // DEFECT 114071 by Sarv 3/30/2016 - New Logic 
                            
                            // CREATE PERSON ACCOUNT 
                            Account acc = CreatePersonAcccount ( Body, PersonAccRecordTypeId );
                            
                            // CREATE JUNCTION OBJECT 
                            CreateJuncObj( acc.Id , financeAccounts[0].Id );
                            
                            // CREATE USER 
                            CreateUser(Body.eCustomerId, Body.userEmail, Body.userName, acc.Id);
                            
                            //RSS 41959
                            eDeliveryUpdate(Body.AccountNumber,Body.userEmail, Body.eDelivery);
                            
                            return SendResponse ( Body, '111', 'User Provisioned Successfully' ) ;  
               
                        } else {
                            
                            /*******************************************************************************************************
                                 SCENARIO 06 : PERSON ACCOUNT EXISTS BUT NO USER RECORD, CREATE USER RECORD AND CREATE JUNC OBJ     
                            *******************************************************************************************************/
                        
                            // VERIFY IF JUNC OBJECT ALREADY EXISTS 
                            if ( !isJuncObjExists ( personAccounts[0].Id , financeAccounts[0].Id ) ) {
                                // SCENARIOR 04 - IF JUNC OBJ IS MISSING AND CREATE JUNC OBJECT  
                                CreateJuncObj( personAccounts[0].Id , financeAccounts[0].Id );
                            }
                            
                            // CREATE USER 
                            CreateUser(Body.eCustomerId, Body.userEmail, Body.userName, personAccounts[0].Id);
                            
                            //RSS 41959
                            eDeliveryUpdate(Body.AccountNumber,Body.userEmail, Body.eDelivery);
                            
                            return SendResponse ( Body, '111', 'User Provisioned Successfully' ) ;  
                        
                        }
                        
                                                 
                        
                    } else {
                        /*******************************************************************************************************
                             SCENARIO 04 : NO PERSON ACCOUNT AND NO USER RECORD, CREATE PERSON ACCOUNT, USER RECORD AND CREATE JUNC OBJ     
                        *******************************************************************************************************/
                            
                            // CREATE PERSON ACCOUNT 
                            Account acc = CreatePersonAcccount ( Body, PersonAccRecordTypeId );
                            
                            // CREATE JUNCTION OBJECT 
                            CreateJuncObj( acc.Id , financeAccounts[0].Id );
                            
                            // CREATE USER 
                            CreateUser(Body.eCustomerId, Body.userEmail, Body.userName, acc.Id);
                            
                            //RSS 41959
                            eDeliveryUpdate(Body.AccountNumber,Body.userEmail, Body.eDelivery);
                            
                            // DEFECT 114092 by Sarv 3/30/2016 - Added Response to B2C 
                            return SendResponse ( Body, '111', 'User Provisioned Successfully' ) ;
                    }
                    
               
               } // CLOSING ELSE - !B2CUsers.isEmpty() 
               
                   
           } else {
               
               /*******************************************************************************************************
                     SCENARIO 01 : FINANCE ACCOUNT IS NULL OR NOT IN SALESFORCE     
                *******************************************************************************************************/
               // UTILITY CLASS TO CREATE ERROR LOG OBJECT RECORD
               String ReqBody = 'Body { userEmail-' + Body.userEmail+'/n UserName' + Body.UserName ;
                    ReqBody += 'eCustomerId -' + Body.eCustomerId +'/n accountNumber' + Body.accountNumber;
                    
               UtilityClass.logError('INT 3B', 'Finance Account does not exists', Body.accountNumber,  ReqBody );
               
               return SendResponse ( Body, '121', 'Finance Account does not exists' ) ;   
           }
           
           
           return null;
           
           
       } 
       
      } Catch ( Exception e ) {
           /*******************************************************************************************************
                 EXCEPTION HANDLING  - ANY EXCEPTION WILL BE LOGGED IN ERROR LOG OBJECT    
            *******************************************************************************************************/
             String ReqBody = 'Body { userEmail-' + Body.userEmail+'/n UserName' + Body.UserName ;
                    ReqBody += 'eCustomerId -' + Body.eCustomerId +'/n accountNumber' + Body.accountNumber;
             
             // UTILITY CLASS TO CREATE ERROR LOG OBJECT RECORD
             UtilityClass.logError('INT 3B', e.getmessage(), FinanceAccId,  ReqBody );
             
             // DEFECT 114092 by Sarv 4/01/2016 - Added Response to B2C 
             return SendResponse ( Body, '121', 'User Not Provisioned Successfully' ) ;  

       }
         
         
    }
    
    /*******************************************************************************************************
    * @description : UPDATE COMMUNICATION PREFERENCE 
    * @param : FINANCE ACCOUNT ID AND eDELIVERY PREFERENCE. 
    * @return : 
    *  RSS - 41959
    *******************************************************************************************************/
    Public Static Void eDeliveryUpdate ( String pFinanceAccountId, String pUserEmail, String peDelivery ) 
    {
        List< Communication_Preferences__c> CommPrefList = [Select Id, Email_Address__c, 
                                                            Statements_Letters__c 
                                                            from Communication_Preferences__c 
                                                            where  Finance_Account_Number__r.Name =: pFinanceAccountId];
       System.debug('CommPrefList:'+CommPrefList);
        If (CommPrefList.size() > 0)
        {
                If (peDelivery == 'TRUE')
                {
                         CommPrefList[0].Email_Address__c = pUserEmail;
                         CommPrefList[0].Statements_Letters__c = 'eDelivery';
                         CommPrefList[0].Paperless_Statements_Letters__c = true;
                         DoCallout(true,CommPrefList[0].Email_Address__c.toLowerCase(), pFinanceAccountId,CommPrefList[0].id);
                }
               Else
               {
                        CommPrefList[0].Statements_Letters__c = 'Paper';
                        CommPrefList[0].Paperless_Statements_Letters__c = false;
                        //if (CommPrefList[0].Email_Address__c == NULL || CommPrefList[0].Email_Address__c == '')
                        //{
                            CommPrefList[0].Email_Address__c = pUserEmail;
                        //}
                        DoCallout(false,CommPrefList[0].Email_Address__c.toLowerCase(), pFinanceAccountId,CommPrefList[0].id);
                 }
                 try{
                 Update CommPrefList;
                 }
                 catch(exception ex){
                      UtilityClass.logError('Communication preferences eDelivery enrollment failure', ex.getmessage(), CommPrefList[0].Id, 'The Communication Pref failed to update');
                 }
       }
    }

    @future(callout=true)
    public static void DoCallout(boolean peDeliverySelection, string pEmail, string pFinanceAccountId,id commpreferId)
    {
         UpdateEDeliveryPreferenceService edeliveryService = new UpdateEDeliveryPreferenceService();
        /* RSS 46325 - PG-Systematic outage recovery/SF resync process */
         Boolean successFlag =  edeliveryService.updateEDeliveryPreference(peDeliverySelection, pEmail, pFinanceAccountId);  
        If(!successFlag){
            RetryCallout.Retrycallout(pEmail,pFinanceAccountId,peDeliverySelection,string.valueof(commpreferId));
        }
        /* RSS 46325 - PG-Systematic outage recovery/SF resync process */
    } 
     
    /*******************************************************************************************************
    * @description : CREATE PERSON ACCOUNT RECORD  
    * @param : REQUEST BODY AND PERSON ACCOUNT RECORD TYPE ID  
    * @return : RETURNS PERSON ACCOUNT RECORD
    * @example 
    *  
    *******************************************************************************************************/
     Public Static Account CreatePersonAcccount (RequestWrapper Body, String PersonAccRecordTypeId ){
     
         Account PersonAccount = new Account();
            PersonAccount.PersonEmail = Body.userEmail;
            PersonAccount.lastname = Body.userName;
            PersonAccount.recordtypeId = PersonAccRecordTypeId ;
            PersonAccount.Source_System__c = 'B2C';
          //30-03-2018 Eligible_For_MC_Connector__c field is set to false
            PersonAccount.Eligible_For_MC_Connector__pc = false;
            insert PersonAccount;
            
         return PersonAccount ;
     }
     
    /*******************************************************************************************************
    * @description : SEND RESPONSE BODY  
    * @param : REQUEST BODY, CODE, MESSAGE  
    * @return : RETURNS RESPONSE BODY TO B2C PORTAL
    * @example 
    *  
    *******************************************************************************************************/
     Public Static ResponseWrapper SendResponse(RequestWrapper Body, String Code, String Message){
         
         ResponseWrapper respWrapper = new ResponseWrapper();
            respWrapper.userEmail = Body.userEmail;
            respWrapper.userName = Body.userName;
            respWrapper.eCustomerId = Body.eCustomerId;
            respWrapper.accountNumber = Body.accountNumber;
            respWrapper.code = Code;
            respWrapper.message = Message;         
         
         return respWrapper ;
     }
     
    /*******************************************************************************************************
    * @description :  QUERY THE JUNC OBJECT RECORDS 
    * @param : PERSON ACCOUNT ID, FINANCE ACCOUNT ID  
    * @return : RETURNS TRUE IF JUNC OBJECT EXISTS ELSE FALSE
    * @example 
    *  
    *******************************************************************************************************/
     Public Static Boolean isJuncObjExists ( String PersonAccountId,  String FinanceAccountId ) {
         
         list <Customer_Finance_Account__c > JuncObjs = [ SELECT Id, Customer__c, Finance_Account__c 
                                                            FROM Customer_Finance_Account__c 
                                                            WHERE Customer__c = : PersonAccountId AND Finance_Account__c = : FinanceAccountId  ];
         
         if ( !JuncObjs.isEmpty() ){
             
             return True ;
         } else  {
             return False ; 
         } 
                 
     }
     
    /*******************************************************************************************************
    * @description :  CREATE JUNC OBJECT RECORD 
    * @param : PERSON ACCOUNT ID, FINANCE ACCOUNT ID  
    * @return : VOID
    * @example 
    *  
    *******************************************************************************************************/
    
     Public Static Void CreateJuncObj ( String PersonAccountId,  String FinanceAccountId )  {
         Customer_Finance_Account__c customerFinance = new Customer_Finance_Account__c();
            customerFinance.Customer__c = PersonAccountId ;
            customerFinance.Finance_Account__c = FinanceAccountId ;
            insert customerFinance;
         System.debug(' customerFinance ==> ' + customerFinance);   
     }
     
     
     /*******************************************************************************************************
    * @description :  FEDERATION ID IS NULL OR NOT NULL IN SALESFORCE 
    * @param : eCustomerId  
    * @return : RETURNS TRUE IF FEDERATION ID IS NOT NULL ELSE FALSE
    * @example 
    *  
    *******************************************************************************************************/
     Public Static Boolean isFederationIdZero ( String eCustomerId ) {
         
         if ( String.isNotBlank( eCustomerId ) ) {
             
             Integer fedId = Integer.valueOf(eCustomerId);
             
             if (fedId <> 0){
             
                 return True ;
             
             } else {
                 
                 return False ; 
             } 
         
         }  else  {
         
             return true ; 
         }        
                 
     }
     
    /*******************************************************************************************************
     
      
     
    /*******************************************************************************************************
    * @description :  CREATE USER RECORD , @ FUTURE TO AVOID MIXED DML OPERATION ERROR
    * @param : RESPONSE BODY PARAMS (eCustomerId, userEmail, userName), PERSON ACCOUNT ID  
    * @return : VOID
    * @example 
    *  
    *******************************************************************************************************/
    @Future
    Public Static Void CreateUser(String eCustomerId, String userEmail, String userName, String personAccountId ){
                        
        // CHECK USER NAME IS VALID OR NOT, IF IT IS MORE THAN 80 CHARCTERS WE SHUOID THROW THE ERROR        
        if ( String.isNotBlank(userName) && userName.length() >= 80 ) {
        
            UtilityClass.logError('ProvisionCustomerUserController', 'Username is too large(max length=80)', '',  '');
            
        }else {
      
            try { 
          
                // DEFECT 114167 START
                // REMOVE ALL THE SPACES FROM THE STRING 
                eCustomerId = removeAllSpacesFromStringMethod(eCustomerId);
                userEmail = removeAllSpacesFromStringMethod(userEmail);
                userName = removeAllSpacesFromStringMethod(userName);
                personAccountId = removeAllSpacesFromStringMethod(personAccountId);
                // DEFECT 114167 END
            
                Profile customerProfile = [select id from Profile where name = 'Customer'];
                //30-03-2018 Query Updated to filter records based on Eligible_For_MC_Connector__c = false
                Contact customerContact = [select id from contact where account.id = : personAccountId and Eligible_For_MC_Connector__c = false];
        
                Database.DMLOptions dmo1 = new Database.DMLOptions();
                dmo1.EmailHeader.triggerUserEmail = true;
                dmo1.EmailHeader.triggerOtherEmail = true;
                dmo1.EmailHeader.triggerAutoResponseEmail = true;
                dmo1.optAllOrNone = true;
            
                User createUser = new User();
                createUser.email = userEmail;
                createUser.emailencodingkey = 'ISO-8859-1';
                createUser.lastname = userName;
                createUser.alias = (userName.length() > 7) ? userName.substring(0, 7) : userName;
                createUser.languagelocalekey = 'en_US';
                createUser.localesidkey = 'en_US';
                createUser.profileid = customerProfile.Id;
                createUser.FederationIdentifier = eCustomerId;
                createUser.timezonesidkey = 'America/Los_Angeles';
                createUser.username = userName + '@hondafinance.com';
                createUser.contactid = customerContact.Id;
                createUser.setOptions(dmo1);
                insert createUser;
            
                System.debug(' createUser ==> ' + createUser );
             } catch (exception e) {
                 UtilityClass.logError('INT 3B', e.getmessage(), eCustomerId,  personAccountId );
             }
         }     
   }
   
   /*******************************************************************************************************
    * @description :  CREATE JUNC OBJECT RECORD 
    * @param : PERSON ACCOUNT ID, FINANCE ACCOUNT ID  
    * @return : VOID
    * @example 
    *  
    *******************************************************************************************************/
    
     Public Static Void tracePayload(RequestWrapper Body)  {
            RestRequest req = RestContext.request;
           String ReqBody = 'Body { userEmail- ' + Body.userEmail+' UserName- ' + Body.UserName ;
                    ReqBody += ' eCustomerId- ' + Body.eCustomerId +' accountNumber- ' + Body.accountNumber + ' IP Address - ' + req.remoteAddress;
             
             // UTILITY CLASS TO CREATE ERROR LOG OBJECT RECORD
             UtilityClass.logError('INT 3B', 'INFO', Body.eCustomerId,  ReqBody );
     }
     
      // DEFECT 114167 START
     /*******************************************************************************************************
     * @description :  REMOVE SPACES FROM STRING 
     * @param : RESPONSE BODY PARAMS (eCustomerId, userEmail, userName), PERSON ACCOUNT ID
     * @return : STRING
     * @example 
     *  
     *******************************************************************************************************/
    
     Public Static string removeAllSpacesFromStringMethod(String value) {
         
         value = value != NULL ? value.replaceAll( '\\s+', '') : '';
         return value;    
     }
     // DEFECT 114167 END 
}