/*******************************************************************************************************
    * @author  : SARAVANAN C
    * @date    : 18 JAN 2016
    * @modified : 20 JUN 2016 
    * @group    :  
    * @group-content : 
    * @description : USER AUTHENTICATION TO VALIDATE THE RESPECTIVE USER IS ACCESSING THE COMMUNITY PAGES.
********************************************************************************************************/

Public Class UserSecurity{

    /*******************************************************************************************************
    * @description : VALIDATE BY FINANCE ACCOUNT NUMBER  
    * @param : FINANCE ACCOUNT NUMBER 
    * @param : 
    * @return : BOOLEAN
    * @example : 
    *  
    *******************************************************************************************************/
    // DEFECT 114196 UPDATED THE GENERIC ERROR PAGE ISSUE
    Public Static Boolean ValidateFinNumber( String FinAccNumber ){
        
        Boolean isValidUser = false;
        try {   // 114252 Prakash added         
            Cache.SessionPartition SessionPartition = New Cache.SessionPartition ('local.UserSecurity') ;
             system.debug('line number 26');                                   
            // CHECK THIS IS VALID FIN NUMBER OR NOT 
            if (queryFinanceAccNumber(FinAccNumber)) { // 114252 added by prakash
                     
                if ( SessionPartition.isAvailable() && SessionPartition.contains('isValidUser') ) {
                    
                    System.Debug(' SessionPartition.get(isValidUser) ==> ' + SessionPartition.get('isValidUser')  );
                    isValidUser = (Boolean)SessionPartition.get('isValidUser') ;
                    system.debug('line number 34'+isValidUser);   
                } else  {   // Added the below changes based on Sankalan's input
                    isValidUser = ValidateFinNumberInit(FinAccNumber);
                    system.debug('line number 37'+isValidUser);   
                    if(SessionPartition.isAvailable())
                        {
                           SessionPartition.Put('isValidUser', isValidUser);
                        }                                                             
                } 
            }
                
            System.debug(' isValidUser  ==> ' + isValidUser  );  
        }catch (exception e) { // 114252 Prakash added    
            
            UtilityClass.logErrorResp('UserSecurity', 'Customer Authentication has been failed', FinAccNumber, FinAccNumber, e.getmessage());
        }
        return isValidUser ;    
    }
    
    
    /*******************************************************************************************************
    * @description : VALIDATE BY PAYMENT RECORD ID  
    * @param : PAYMENT RECORD ID 
    * @param : 
    * @return : BOOLEAN
    * @example 
    *  
    *******************************************************************************************************/
    Public Static Boolean ValidateChargentId( String ChargentId ){
        
        string finAccNo = ''; // 114252 Prakash added 
        try { // 114252 Prakash added    
        
            //Query as a List to avoid the Query Exceptions
            List<ChargentOrders__ChargentOrder__c> Payments = New List<ChargentOrders__ChargentOrder__c> ();
            Payments = [SELECT Id, Finance_Account_Number__r.Finance_Account_Number__c FROM ChargentOrders__ChargentOrder__c WHERE Id = :ChargentId ] ;
            
            finAccNo = Payments != null && !Payments.isEmpty() ? Payments[0].Finance_Account_Number__r.Finance_Account_Number__c : '';// 114252 Prakash added 
            
            if ( !Payments.isEmpty() ){
                
                if ( Payments[0].Finance_Account_Number__r.Finance_Account_Number__c <> NULL ) {
                   return  ValidateFinNumber( Payments[0].Finance_Account_Number__r.Finance_Account_Number__c ) ;
                } else {
                    // Given Chargent Order Record Id If Finance Account Number is null - return False
                    return False ;
                }
                
            } else {
                // If There is NO Chargent Order record - return False
                return False ;
            }
        }catch (exception e) { // 114252 Prakash added    
                        
            UtilityClass.logErrorResp('UserSecurity', 'Customer Authentication has been failed', finAccNo, finAccNo, e.getmessage());
        }
        return false;  // 114252 Prakash added                 
    }
     
    
    /*******************************************************************************************************
    * @description : QUERY AND VERIFY THAT GIVEN USER IS THERE IN JUNC OBJECT  
    * @param : FINANCE ACCOUNT NUMBER 
    * @param : 
    * @return : BOOLEAN
    * @example 
    *  
    *******************************************************************************************************/
    Public Static Boolean ValidateFinNumberInit( String FinAccNumber ){
        
        Boolean isValidUser = False ;
        String CurrentUserId = Userinfo.getUserid();
        SYSTEM.debug('fin number>>'+FinAccNumber);
        List<String> CustomerUserIds = New List<String> ( getCustomerIds( FinAccNumber  ) );
        SYSTEM.debug('CustomerUserIds'+CustomerUserIds);
        // If Customer User ids list is empty, then there is no User for the given finance Account Number return default isValidUser = False
        if ( !CustomerUserIds.isEmpty() ){
            
            // Change isValidUser = True only when the Current User Ids is Contains in the list 
            Set<String> SetCustomerIds = New Set<String> ( CustomerUserIds ); 
            System.Debug(' SetCustomerIds ==> ' + SetCustomerIds );
            System.Debug(' CurrentUserId ==> ' + CurrentUserId );
            if ( SetCustomerIds.Contains(CurrentUserId) ) {
                system.debug('11117777');
                isValidUser = True ;
            }
            
            
        }
        
        // FOR DEVELOPMENT TIME BEING BYE PASS THE SYSTEM ADMIN USERS STARTS
        
        // 114252 Start
            SET<String> ExceptionProfiles = New SET<String> (system.label.UserSecurityByPassProfiles.split(','));
          /*  ExceptionProfiles.add('System Administrator');
            ExceptionProfiles.add('AHFC System Support'); 
            ExceptionProfiles.add('AHFC System Administrator');*/
            
            // 114252 end 
            
            String CurrentUserProfileId = (String)userinfo.getprofileid().Substring(0,15) ;
            Profile[] SystemAdminProfiles = [SELECT Id FROM Profile WHERE name  IN  :ExceptionProfiles ]; 
            
            for ( Profile a: SystemAdminProfiles ){
            
                if ( ((String)a.Id).Substring(0,15) ==  CurrentUserProfileId ) {
                    isValidUser = True ;
                }
            }
                          
            // FOR DEVELOPMENT TIME BEING BYE PASS THE SYSTEM ADMIN USERS ENDS
       return isValidUser ;
    }
    
    /*******************************************************************************************************
    * @description : HELPER METHOD WILL QUERY THE CUSTOMER USER IDS ASSOICATED WITH THE FINANCE ACCOUNT  
    * @param : FINANCE ACCOUNT NUMBER
    * @param : 
    * @return : USER IDS
    * @example 
    *  
    *******************************************************************************************************/
    Public Static String[] getCustomerIds ( String FinAccNumber ) {
        system.debug('155-->'+FinAccNumber);
        // Query the Customer Finance Accounts
        List<Customer_Finance_Account__c> CustomerFinanceAccounts = New List<Customer_Finance_Account__c> ();
        CustomerFinanceAccounts = [SELECT Id, Customer__r.Customer__c  
                                    FROM Customer_Finance_Account__c 
                                    WHERE Finance_Account__r.Finance_Account_Number__c = : FinAccNumber];
        
        System.debug('CustomerFinanceAccounts=='+CustomerFinanceAccounts);
        // List to Hold the Mapped User Contact Ids and User Ids
        List<String> ContactIds = New List<String> ();
        List<String> UserIds = New List<String> ();
        
        // Assign the Customer contact ids to the List
        for ( Customer_Finance_Account__c c: CustomerFinanceAccounts )  {
            if ( c.Customer__r.Customer__c <> NULL ) 
                system.debug('EntryInsideee');
                ContactIds.add(c.Customer__r.Customer__c);
        }
        System.debug('ContactIds=='+ContactIds);
        
        // If Contactids are there process further
        if ( !ContactIds.isEmpty() ) {
            
            // Query the Respective User Ids
            List<User> Users = New List<User>();
            Users = [SELECT id FROM User WHERE ContactId IN : ContactIds];
            
            // Assign it to User ids list
            for ( User a : users) {
                UserIds.add(a.Id);
            }
            System.debug('UserIds=='+UserIds);
        } 
        
        // If user ids list is Empty then, there is no user mapped to the given finance account number
        if ( !UserIds.isEmpty() ){
            return UserIds ;
        } else {
            return null ;
        }                         
    } 
    
    // 114252 - Prakash Start 
    // CHECK FIN NUMBER IS VALID OR NOT 
    public static Boolean queryFinanceAccNumber(String FinAccNumber) {
        
        Boolean isValidFinNo = false;
        
        List<Finance_Account__c> financeAccList = new List<Finance_Account__c>();
        financeAccList = [SELECT id,name,Honda_Brand__c 
                          FROM Finance_Account__c 
                          WHERE Finance_Account_Number__c= :FinAccNumber Limit 1 ];
                          
        isValidFinNo = financeAccList != NULL && !financeAccList.isEmpty() ? true : false;
        
        // ERROR LOG SHOUID BE CREATE
        if (!isValidFinNo) { 
            UtilityClass.logErrorResp('UserSecurity','401 Error', FinAccNumber, FinAccNumber, 'Finance account number does not exist');
        }
        return isValidFinNo;                                  
    }
    // 114252 - Prakash End 
    
    
}