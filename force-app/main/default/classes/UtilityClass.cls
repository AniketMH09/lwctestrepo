public class UtilityClass {


    /* Check the security context of the page 
       
       Author: Rajesh Krishnamohan
       Date: 3-Dec-2015
       
       Requirement: Only the authorized users having access to a FinAccount can view its details and make transactions.
       FinAccount is also accessible to user's relatives such as father / son etc.  However Portal users cannot 
       share the records through Sharing rules.  So the approach is to "remove" "with sharing" and build a custom
       security check each time the record is accessed
            
    */
    
    public static boolean isEnvSet = false;
    public static String envName;
    public static Date processingDate;
    
    public static boolean CheckSecurity(String FinAccountNumber)
    {
    
        try{
            //Retrieve the logged in User ID
            Id UserID = UserInfo.getUserId();
            
            //Retrieve the user's profile
            Id ProfileID = UserInfo.getProfileId();
            
            //List of Authorized Profiles to access the page 
            //To Do 1: Validate this list 
            //To Do 2: Eventually move these strings to custom settings or labels
            
            List<String> validProfiles = new List<String> { 'Agent', 'Customer','Customer Community Login User','System Administrator' };
            
            Map<ID, Profile> mapValidProfiles = new Map<ID, Profile>([SELECT Id,Name FROM Profile where Name in :validProfiles]);
            Boolean contains = mapValidProfiles.containsKey(ProfileID);
                         
            if (contains==true)
            {
                //Condition 1: If logged in user is an Agent - then allow - use Profiles to validate this
                if (mapValidProfiles.get(ProfileID).Name=='Agent' || mapValidProfiles.get(ProfileID).Name=='System Administrator' )
                {
                    return true;
                }
                //Condition 2: Retrieve the FinAccount number based on logged on user from database and verify against the ID passed
                else {
            
                    //Condition 2a: If FinAccountNumber is directly passed as URL Parameter
                    List<Customer_Finance_Account__c> ContactIDs=[SELECT  Customer__r.PersonContact.Id from Customer_Finance_Account__c where Finance_Account__r.Finance_Account_Number__c = :FinAccountNumber]; 
                    
                    List<ID> validContactIDs = new List<ID>();
                    
                    if (ContactIDs.IsEmpty())
                    {
                        //if the above list is empty it means no contacts are associated
                        return false;
                        
                    } else
                    
                    {
                        for (Customer_Finance_Account__c c:ContactIDs)
                        {
                            validContactIDs.add(c.Customer__r.PersonContact.Id);
                        }
                                      
                        List<User> validUsers = [SELECT  Id from User where Contact.Id in :validContactIDs];
                        Boolean match = false;
                        
                        for (User u:validUsers)
                        {
                            if (UserID == u.id)
                            {
                                match = true;
                            }
                        }
                        
                        return match;
                    
                        //Condition 2b: If ChargentID is passed and FinAccountNumber is NOT passed as URL Parameter        
                        //Condition 2c: If neither FinAccountNumber or ChargentID is passed - return False (and fix the calling pages)
                    }                    
                }
            }
            else
            {
                return false;
            }
            
            
        } catch (Exception e)
        {
            return false;            
        }
    
    }
    

    public static String GetFinAccountNumer(String chargentId)
    {
        try
        {
            return '';
        
        } catch (Exception e)
        {
            return '';                    
        }
    
    
    }
    
    
    
    
    public static List<selectOption> getBankAccounts(Map<Id,Payment_Source__c> bankAccountsMap){
        List<selectOption> options = new List<selectOption>(); 
        List<Payment_Source__c> bankAccountTmpList = new List<Payment_Source__c>() ;
      
        if(bankAccountsMap.values().size() > 0)
            options.add(new selectOption('Select One','Select One'));
         

        for(Payment_Source__c bankAccount : bankAccountsMap.values()) { 
            if(bankAccount.Id != null && bankAccount.Payment_Source_Nickname__c != null && bankAccount.Preferred_Payment_Source__c==true ){ 
                options.add(new selectOption(bankAccount.id, bankAccount.Payment_Source_Nickname__c + '(XXXX-' + BankAccount.Last_4__c +')')); // 114271 - Veera
            }
            else{
                bankAccountTmpList.add(bankAccount);
            }
        }
        
        
        if(bankAccountTmpList.size() > 0) {
           for(Payment_Source__c bankAccount : bankAccountTmpList){
                if(bankAccount.Id != null && bankAccount.Payment_Source_Nickname__c != null )
                    options.add(new selectOption(bankAccount.id,bankAccount.Payment_Source_Nickname__c + '(XXXX-' + BankAccount.Last_4__c +')')); // 114271 - Veera
            }
        }
        if(bankAccountsMap.values().size() == 0){
            options.add(new selectOption('Select One','Select One'));
        }
        
        if(bankAccountsMap.values().size() < 4) {
        options.add(new selectoption('Add New','Add New'));
        }
        return options;
    }
    public static List<selectOption> getBankAccounts(Map<Id,Payment_Source__c> bankAccountsMap,Id chargentId){
        List<selectOption> options = new List<selectOption>(); 
        List<Payment_Source__c> bankAccountTmpList = new List<Payment_Source__c>() ;
        // Defect: 114271 - Veera - Modified Query to retrieve additional fields -Veera
        ChargentOrders__ChargentOrder__c chargentOrder = [select Payment_Source_Nickname__r.Payment_Source_Nickname__c,
                Payment_Source_Nickname__r.id,Finance_Account_Number__r.id,  Payment_Source_Nickname__r.Last_4__c  
                from ChargentOrders__ChargentOrder__c where id = :chargentId Limit 1 ];
        System.debug('BankAccountsMap'+bankAccountsMap);
        System.debug('Chargent Order Record'+ chargentOrder );
        
        
        if(chargentOrder.Payment_Source_Nickname__r.id != null && chargentOrder.Payment_Source_Nickname__r.Payment_Source_Nickname__c != null){
            // Defect: 114271 - Modified the NickName field appearance  -Veera
            options.add(new selectOption(chargentOrder.Payment_Source_Nickname__r.id,chargentOrder.Payment_Source_Nickname__r.Payment_Source_Nickname__c + '(XXXX-' +chargentOrder.Payment_Source_Nickname__r.Last_4__c +')'  ));
            System.debug('Added correctly');
        }
        
        if(bankAccountsMap.values().size() > 0)
          options.add(new selectOption('Select One','Select One'));
        
        for(Payment_Source__c bankAccount : bankAccountsMap.values()) {
            if(bankAccount.Id != null && bankAccount.Payment_Source_Nickname__c != null && bankAccount.id != chargentOrder.Payment_Source_Nickname__r.id){
                options.add(new selectOption(bankAccount.id,bankAccount.Payment_Source_Nickname__c + '(XXXX-' + BankAccount.Last_4__c +')' )); // 114271 - Veera
            }
        }
        if(bankAccountsMap.values().size() < 4) {
        options.add(new selectoption('Add New','Add New'));
        }
        return options;
    }
    
    //method for adding bank name when it comes from popup
    public static List<selectOption> getBankAccountNames(string finid,string popup){
    
        List<selectOption> options = new List<selectOption>(); 
        // Defect: 114271 - Modified Query to retrieve additional fields  -Veera
        Map<Id, Payment_Source__c> bankAccountsMap = new Map<Id, Payment_Source__c> ([Select Payment_Source_Nickname__c,id,
                                Preferred_Payment_Source__c, Last_4__c 
                                from Payment_Source__c 
                                where Finance_Account_Number__r.id = :finid order by createddate desc]);
         
        List<Payment_Source__c> bankAccountTmpList = new List<Payment_Source__c>() ;
        for(Payment_Source__c bankAccount : bankAccountsMap.values()) {
            
            if(bankAccount.Id != null && bankAccount.Payment_Source_Nickname__c != null  )
            {
               
                options.add(new selectOption(bankAccount.id,bankAccount.Payment_Source_Nickname__c + '(XXXX-' + BankAccount.Last_4__c +')'  )); // 114271 -Veera
            }
            else
            {
                
                bankAccountTmpList.add(bankAccount);
            }
        }
        
        if(bankAccountTmpList.size() > 0) {
            for(Payment_Source__c bankAccount : bankAccountTmpList){
                if(bankAccount.Id != null && bankAccount.Payment_Source_Nickname__c != null )
                    options.add(new selectOption(bankAccount.id,bankAccount.Payment_Source_Nickname__c + '(XXXX-' + BankAccount.Last_4__c+')' )); // 114271 -Veera
            }
        }
        if(bankAccountsMap.values().size() == 0){
            options.add(new selectOption('None','None'));
        }
        
        if(bankAccountsMap.values().size() < 4) {
        options.add(new selectoption('Add New','Add New'));
        }
        return options;
    }
    
    public static List<selectOption> getLastBankAccounts(Map<Id,Payment_Source__c> bankAccountsMap){
        Boolean firstFlag = true;
        List<selectOption> options = new List<selectOption>(); 
        List<Payment_Source__c> bankAccountTmpList = new List<Payment_Source__c>() ;
        for(Payment_Source__c bankAccount : bankAccountsMap.values()) {
            if(bankAccount.Id != null && bankAccount.Payment_Source_Nickname__c != null && firstFlag ){
                options.add(new selectOption(bankAccount.id,bankAccount.Payment_Source_Nickname__c));
                firstFlag = false;
            }
            else{
                bankAccountTmpList.add(bankAccount);
            }
        }
        
        if(bankAccountTmpList.size() > 0) {
            for(Payment_Source__c bankAccount : bankAccountTmpList){
                if(bankAccount.Id != null && bankAccount.Payment_Source_Nickname__c != null )
                    options.add(new selectOption(bankAccount.id,bankAccount.Payment_Source_Nickname__c));
            }
        }
        if(bankAccountsMap.values().size() == 0){
            options.add(new selectOption('None','None'));
        }
        
        if(bankAccountsMap.values().size() < 4) {
        options.add(new selectoption('Add New','Add New'));
        }
        return options;
    }
    public static Map<String,List<ChargentOrders__ChargentOrder__c>> getChargentOrders(Id financeAccountId){
        Map<String,List<ChargentOrders__ChargentOrder__c>> chargentOrderMap = new Map<String, List<ChargentOrders__ChargentOrder__c>>();
        List<ChargentOrders__ChargentOrder__c> chargentOrderList = [Select id,ChargentOrders__Payment_Start_Date__c,ChargentOrders__Charge_Amount__c,RecordType.DeveloperName  from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.id = :financeAccountId and Payment_Display_Status__c='Pending'];
        for(ChargentOrders__ChargentOrder__c order : chargentOrderList ) {
            if(chargentOrderMap.containsKey(order.RecordType.DeveloperName)){
               List<ChargentOrders__ChargentOrder__c> orderList = chargentOrderMap.get(order.RecordType.DeveloperName);
                orderList.add(order);
            } 
            else{
                List<ChargentOrders__ChargentOrder__c> orderTmpList = new List<ChargentOrders__ChargentOrder__c>();
                orderTmpList.add(order);
                chargentOrderMap.put(order.RecordType.DeveloperName,orderTmpList);
            }
        }
        return chargentOrderMap;
    }
    
    public static Map<String,List<ChargentOrders__ChargentOrder__c>> getChargentOrdersRP(Id financeAccountId){
        Map<String,List<ChargentOrders__ChargentOrder__c>> chargentOrderMap = new Map<String, List<ChargentOrders__ChargentOrder__c>>();
        List<ChargentOrders__ChargentOrder__c> chargentOrderList = [Select id,ChargentOrders__Payment_Start_Date__c,ChargentOrders__Charge_Amount__c,RecordType.DeveloperName  from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.id = :financeAccountId and ChargentOrders__Payment_Status__c ='Stopped'];
        for(ChargentOrders__ChargentOrder__c order : chargentOrderList ) {
            if(chargentOrderMap.containsKey(order.RecordType.DeveloperName)){
                List<ChargentOrders__ChargentOrder__c> orderList = chargentOrderMap.get(order.RecordType.DeveloperName);
                orderList.add(order);
            } 
            else{
                List<ChargentOrders__ChargentOrder__c> orderTmpList = new List<ChargentOrders__ChargentOrder__c>();
                orderTmpList.add(order);
                chargentOrderMap.put(order.RecordType.DeveloperName,orderTmpList);
            }
        }
        return chargentOrderMap;
    }
    
    public static String[] dateSplitProcess(String dateSplit){
        String[] dateString;
        String[] myDate = dateSplit.split(' ');
        dateString = myDate[0].split('/');
        return dateString;
    }
    
    public static Decimal getRemainingAmountDue(String FinanceAccountNumber) {
    
        Decimal RemainingAmountDue = 0.00;
        Finance_Account__c finAcc = [select id,Total_Amount_Due__c,Payment_Due_Date__c,Scheduled_EasyPay_Amount__c from Finance_Account__c where Finance_Account_Number__c = :FinanceAccountNumber];
        List<ChargentOrders__ChargentOrder__c> cOrder = [select Next_Withdrawal_Date__c,ChargentOrders__Charge_Amount__c from ChargentOrders__ChargentOrder__c where recordtype.developerName = 'Recurring_Payment' and Finance_Account_Number__r.Finance_Account_Number__c = :FinanceAccountNumber and Payment_Display_Status__c='Pending' limit 1];
        if(cOrder.size() > 0) {
            if(cOrder[0].Next_Withdrawal_Date__c != null && finAcc.Payment_Due_Date__c != null)
            {
                if(cOrder[0].Next_Withdrawal_Date__c <= finAcc.Payment_Due_Date__c ) {
                RemainingAmountDue = finAcc.Total_Amount_Due__c - cOrder[0].ChargentOrders__Charge_Amount__c;
                    If(RemainingAmountDue < 0)
                        RemainingAmountDue = 0.00;
                
                }  
            
            if(cOrder[0].Next_Withdrawal_Date__c > finAcc.Payment_Due_Date__c ) 
              RemainingAmountDue = finAcc.Total_Amount_Due__c;   
           }  
        }else { 
           RemainingAmountDue = finAcc.Total_Amount_Due__c;  
        }  
        return RemainingAmountDue;
   } 
   
   
   /* @description       This method is used to log errors
      * @param            String     ClassName.
      * @param            String     errorMsg.
      * @param            String     recId.
      * @param            String     msg.
      * @return           Void
      * @throws           NA
    */
        public static void logError(String ClassName, String errorMsg, String recId, String msg){
             ErrorLog__c errorLog = new ErrorLog__c();
             errorLog.ClassName__c = ClassName;
             errorLog.ExceptionMsg__c = errorMsg;
             errorLog.AffectedId__c = recId;
             errorLog.RequestBody__c = msg;
             try{
                 insert errorLog;
             }
             catch(exception ex){}
        }
    
    /*******************************************************************
*             Method name   : errorLogDetails
*             Description         : This method returns the details of the Error Log to be inserted
*             Parameters        : String, String, String, String
*             Return Type       : ErrorLog__c
*             RSS#                      :
*             Developer  : Srividya
*             ***************************************************************/
    public static ErrorLog__c errorLogDetails(String ClassName, String errorMsg, String recId, String msg){
        ErrorLog__c errorLog = new ErrorLog__c();
        errorLog.ClassName__c = ClassName;
        errorLog.ExceptionMsg__c = errorMsg;
        errorLog.AffectedId__c = recId;
        errorLog.RequestBody__c = msg;
        return errorLog;
    }
        
      // Below changes added to the defect 114131 by Sankalan 
      /* @description       This method is used to log errors
      * @param            String     ClassName.
      * @param            String     errorMsg.
      * @param            String     recId.
      * @param            String     msg.
      * @return           Void
      * @throws           NA
    */
        public static void logErrorResp(String ClassName, String errorMsg, String recId, String req, String resp){
             ErrorLog__c errorLog = new ErrorLog__c();
             errorLog.ClassName__c = ClassName;
             errorLog.ExceptionMsg__c = errorMsg;
             errorLog.AffectedId__c = recId;
             errorLog.RequestBody__c = req;
             errorLog.ResponseBody__c = resp;
             try{
                 insert errorLog;
             }
             catch(exception ex){}
        }
        
     
      
        
    /* @description       This method is used to log errors
      * @param            String     ClassName.
      * @param            String     errorMsg.
      * @param            String     recId.
      * @param            String     msg.
      * @return           Void
      * @throws           NA
    */
        public static void logException( Exception e, String ClassName, String errorMsg, String recId, String msg){
             ErrorLog__c errorLog = new ErrorLog__c();
             errorLog.ClassName__c = ClassName;
             errorLog.ExceptionMsg__c = errorMsg;
             errorLog.AffectedId__c = recId;
             errorLog.RequestBody__c = msg;
             try{
                 insert errorLog;
             }
             catch(exception ex){}
        }
    //End of defect 114131
    
    
    // 114221 STARTS
    /*******************************************************************************************************
    * @description : This method provides the name of the sandbox or production 
    * @param : NA
    * @return : String
    * @example 
    *  
    *******************************************************************************************************/
    
    Public Static String getEnvName(){
        if(!isEnvSet) {
                if( [select  IsSandbox from Organization].IsSandbox ){
                    envName = 'Sandbox';
                if( String.isNotBlank(UserInfo.getUserName().substringAfterLast('.com.')) ) {
                    envName = UserInfo.getUserName().substringAfterLast('.');
                } else {
                    envName = 'SB'+UserInfo.getOrganizationId();
                }
            }
            else
            {
                envName = 'Prod';
            }
            isEnvSet = true;
        } 
        return envName;
    }
    // 114221 ENDS
    
    /**************************************************************************
*             Method Name  : getRecordTypesMap
*             Desciption           : Returns the Map of recordtypes for the object passed in parameter
*             Parameters        : sObjectAPIName
*             Return Type       : Map<String, RecordType>
*             Developer           : Srividya
* *****************************************************************************/
    public static Map<String, RecordType> getRecordTypesMap(String sObjectAPIName){
        Map<String, RecordType> recordtypesMap = new Map<String, RecordType>();
        List<RecordType> recordtypesList = [Select Id, Name 
                                            from RecordType 
                                            where sObjectType =: sObjectAPIName 
                                            and isActive=true];        
        //Create a map between the Record Type and Id for easy retrieval
        if(recordtypesList != Null){
            for(RecordType recType: recordtypesList){
                recordtypesMap.put(recType.Name,recType);
            }
        }
        return  recordtypesMap;
    }
    
}