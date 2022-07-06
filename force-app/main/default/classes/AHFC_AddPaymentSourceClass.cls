/* Apex Class Name       :    AHFC_AddPaymentSourceClass
* @Description        :    This Class is used to insert payment source record
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Kanagaraj                                             Created
* Satish                      14/05/2021                Modified for 4530 and 4526 user stories
* Akash Solanki               15-June-2021              US 3693 & 3694
* Edwin Antony                11-Aug-2021               US 10147 Already Enrolled in EasyPay - SUSPENDED EASYPAY 
*********************************************************************************/
public without sharing class AHFC_AddPaymentSourceClass {
    public static final Date datToday = System.today();
    static String strUserProfile = '';
    static ID financeAccCustomerId;
    static ID idCustomerId; 
    static Boolean boolIsCustomer =false;
    
    //Added by kanagaraj -start
    /**
* @description insertPaymentSource
* @return paymentSourceSACWrapper
* Developer : Kanagaraj
* @param  bankAccountNumber
* @param  bankName
* @param  bankAccountType
* @param  bankRoutingNumber
* @param  bankAccountNickName
* @param  preferredPaymentSource
* @param  sacRecordId
* @param  lstSACIdsToUpdate
*/
    @AuraEnabled 
    public static paymentSourceSACWrapper insertPaymentSource(String bankAccountNumber, String bankName, 
                                                              String bankAccountType, String bankRoutingNumber,
                                                              String bankAccountNickName, Boolean preferredPaymentSource,string sacRecordId,
                                                              List<Id> lstSACIdsToUpdate)
    {
        system.debug('sacRecordId-->'+sacRecordId);
        system.debug('bankRoutingNumber-->'+bankRoutingNumber);
        paymentSourceSACWrapper psSacWrap = new paymentSourceSACWrapper();
        //psSacWrap.lstSAC = new List<Customer_Finance_Account__c>();
        List<Customer_Finance_Account__c> lstSACRecords;
        Id personAccId = getCustomerAccountId();
        lstSACRecords = getServiceAccCustomerRecords(personAccId);
        
        Payment_Source__c objAhfcPaymentSource = new Payment_Source__c();
        try {
            
            if(String.isNotBlank(bankAccountNickName)){
                objAhfcPaymentSource.Payment_Source_Nickname__c = bankAccountNickName;
            }
            else{
                //objAhfcPaymentSource.Payment_Source_Nickname__c = bankName+'-'+bankAccountType; //Added by Aswin Jose for bug fix : 15445
                objAhfcPaymentSource.Payment_Source_Nickname__c = setBankNickName(bankName,bankAccountType);
            }
            objAhfcPaymentSource.Bank_Account_Number__c = bankAccountNumber;
            objAhfcPaymentSource.Bank_Routing_Number__c = bankRoutingNumber;
            objAhfcPaymentSource.Last_4__c = bankAccountNumber.right(4);
            objAhfcPaymentSource.Bank_Name__c = bankName;
            objAhfcPaymentSource.Status__c = 'Active' ;
            objAhfcPaymentSource.Bank_Account_Type__c = bankAccountType;            
            objAhfcPaymentSource.Finance_Account_Number__c = sacRecordId;
            if(personAccId != null)
                objAhfcPaymentSource.Customer__c = personAccId;
            objAhfcPaymentSource.Billing_First_Name__c = 'John';
            objAhfcPaymentSource.Billing_Last_Name__c = 'Doe';
            objAhfcPaymentSource.Billing_Street__c = '1295 Charleston Road';
            objAhfcPaymentSource.Billing_City__c = 'Mountain View';
            objAhfcPaymentSource.Billing_State__c = 'California';
            objAhfcPaymentSource.Billing_Zip__c = '94043';
            objAhfcPaymentSource.Billing_Country__c = 'US';
            objAhfcPaymentSource.Billing_Email__c = 'null@cybersource.com';
            objAhfcPaymentSource.Currency__c = 'U.S. Dollar';
            objAhfcPaymentSource.Preferred_Payment_Source__c = preferredPaymentSource;
            if(objAhfcPaymentSource != null){
                PymtTokenizationService.PTSResult rs = PymtTokenizationService.createPS(objAhfcPaymentSource);
                if(rs.success){
                    psSacWrap.insertedPaymentSource = objAhfcPaymentSource;
                }
                psSacWrap.successfulPaymentSource = rs.success;
            } 
        }catch (Exception e) {
            objAhfcPaymentSource = null;
        }
        return psSacWrap;
    }
    /**
* @description insertPaymentSource
* @param  bankAccountId
* @param  bankAccountNickName
* @param  preferredPaymentSource
*/
    @AuraEnabled
    public static void updatePaymentSource(Id bankAccountId,String bankAccountNickName, Boolean preferredPaymentSource){
        Payment_Source__c objAhfcPaymentSource = new Payment_Source__c(Id=bankAccountId);
        objAhfcPaymentSource.Payment_Source_Nickname__c = bankAccountNickName;
        objAhfcPaymentSource.Preferred_Payment_Source__c = preferredPaymentSource;
        update objAhfcPaymentSource;
    }
    
    /**
* @description insertPaymentSource
* @return strReturn - String
* @param  decRoutingNumber
*/
    @AuraEnabled
    public static String retrieveBankName(string decRoutingNumber){
        String strReturn = '';
        try{
            AHFC_Bank_Routing__c AHFC_BankRoutingNumber = [SELECT AHFC_Bank_Name__c
                                                           ,AHFC_Routing_Number__c 
                                                           FROM AHFC_Bank_Routing__c 
                                                           WHERE AHFC_Routing_Number__c =:decRoutingNumber 
                                                           LIMIT 1];
            
            if(AHFC_BankRoutingNumber != null && AHFC_BankRoutingNumber.AHFC_Bank_Name__c != null 
               && AHFC_BankRoutingNumber.AHFC_Bank_Name__c != ''){
                   strReturn = AHFC_BankRoutingNumber.AHFC_Bank_Name__c;
               }
        } catch (Exception e) {
        }
        return strReturn;
    }
    
    //Added by kanagaraj -END
    
    
    //Added by Satish --Start
    /**
* @description     getCustomerAccountId to get the customer account id
* @param           
* @return          ID
*/
    @AuraEnabled
    public static Id getCustomerAccountId(){
        ID idAccount  = null;
        try{
            User userObj = [SELECT contactid, accountId from User where id =: Userinfo.getUserid()];
            if(userObj != null && userObj.accountId != null){
                idAccount = userObj.accountId;
            }
        } catch (Exception e) {
        }
        return idAccount;
    }
    /**
* @description     getProfileName to get the profile name of customer
* @param           
* @return          string -profile name
* 
*/   
    @AuraEnabled
    public static string getProfileName()
    { 
        try{
            strUserProfile = [Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
            if(String.isNotBlank(strUserProfile) && strUserProfile.contains('Customer')){
                boolIsCustomer = true;
            }
            return strUserProfile;
        } 
        catch(Exception e)
        {  
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**
* @description     getServiceAccCustomerRecords 
* @param           IdWebAccount
* @return          strSACQuery List<Customer_Finance_Account__c>
* 
*/   
    public static List<Customer_Finance_Account__c> getServiceAccCustomerRecords(ID IdWebAccount){
        Integer limitRows = 1;
        String strSACQuery = 'SELECT  Customer__c, Finance_Account__c FROM Customer_Finance_Account__c WHERE Is_Active__c = true';
        
        if(IdWebAccount != null ){
            strSACQuery +=' AND Customer__c =:IdWebAccount ORDER BY CreatedDate DESC'; 
        }
        strSACQuery += ' limit :limitRows'; 
        
        return Database.query(strSACQuery);
    }
    
    @AuraEnabled
    Public static boolean getPaymentSourcePreferred(string finAccId){
        List<Payment_Source__c> lstPaymentSources = [SELECT id FROM Payment_Source__c WHERE Status__c = :'Active' AND Finance_Account_Number__c=:finAccId];
        if(lstPaymentSources!=null && !lstPaymentSources.isEmpty()){
            return false;
        }else{
            return true;
        }
    }
    
    //Wrapper class
    
    /** 
* @description  paymentSourceSACWrapper  
* 
*/
    public without sharing class paymentSourceSACWrapper{
        /** 
* @description  insertedPaymentSource  
* 
*/
        @AuraEnabled
        public Payment_Source__c insertedPaymentSource {get;set;}
        @AuraEnabled
        public boolean successfulPaymentSource {get;set;}
        /** 
* @description  lstSAC  
* 
*/
        @AuraEnabled
        public List<Customer_Finance_Account__c> lstSAC{get;set;}
    }
    //Wrapper class
    /** 
* @description  PaymentSourceWrapper  
* 
*/
    public without sharing class PaymentSourceWrapper{
        /** 
* @description  strID  
* 
*/
        @AuraEnabled
        public String strID {get;set;}
        /** 
* @description  strName  
* 
*/
        @AuraEnabled
        public String strName {get;set;}
        /** 
* @description  strLast4AccNumber  
* 
*/
        @AuraEnabled
        public String strLast4AccNumber {get;set;}
        /** 
* @description  boolIsPreferredSource  
* 
*/
        @AuraEnabled
        public Boolean boolIsPreferredSource {get;set;}
    }
    //Wrapper class
    /** 
* @description  paymentWrapper  
* 
*/
    
    
    @AuraEnabled
    public static List<PaymentSourceWrapper> getPaymentSources(string IdSACRecordVar){
        List<PaymentSourceWrapper> lstPaymentSourceWrapper = new List<PaymentSourceWrapper>();
        PaymentSourceWrapper objPaymentWrapper;
        // Start - Record access check - Supriya Chakraborty 16-Nov-2021 
        if(!test.isRunningTest()){
            List<Finance_Account__c> finList = [SELECT Id,Origination_Branch_Code__c,Honda_Brand__c,Account_Type__c,AHFC_Product_Type__c,Finance_Account_Number__c from Finance_Account__c where Id = :IdSACRecordVar  limit 1]; 
            boolean isUserAuth = UserSecurity.ValidateFinNumberInit(finList[0].Finance_Account_Number__c);        
            if(!isUserAuth){
                throw new AuraHandledException('invalid access');            
            } 
        }
		// End - Record access check - Supriya Chakraborty 16-Nov-2021        
        String webAccId = getCustomerAccountId();
        String serAccId;
        getProfileName();
        if(boolIsCustomer){
            
            List<Customer_Finance_Account__c> lstSACRecords = getServiceAccCustomerRecords(webAccId);
            serAccId = lstSACRecords[0].Finance_Account__c;
            idCustomerId = lstSACRecords[0].Customer__c;
            system.debug('idCustomerId-->'+idCustomerId);
            system.debug('IdSACRecordVar-->'+IdSACRecordVar);
        }
        
        String status = 'Active';
        List<Payment_Source__c> lstPaymentSources = [SELECT id, Name ,Finance_Account_Number__c,Payment_Source_Nickname__c,Customer__c,Status__c,Last_4__c,Preferred_Payment_Source__c,Bank_Account_Number__c
                                                     FROM Payment_Source__c 
                                                     WHERE Status__c = :status 
                                                     // AND Customer__c = :idCustomerId
                                                     AND Finance_Account_Number__c=:IdSACRecordVar];
        
        
        if(lstPaymentSources!=null && !lstPaymentSources.isEmpty()){
            for(Payment_Source__c objPaymentSource : lstPaymentSources){
                objPaymentWrapper = new  PaymentSourceWrapper();
                objPaymentWrapper.strID = objPaymentSource.id;
                objPaymentWrapper.strName = objPaymentSource.Payment_Source_Nickname__c;
                if(String.isNotBlank(objPaymentSource.Last_4__c)){
                    objPaymentWrapper.strLast4AccNumber = objPaymentSource.Last_4__c;
                }
                if(objPaymentSource.Preferred_Payment_Source__c){
                    objPaymentWrapper.boolIsPreferredSource = true;
                }
                lstPaymentSourceWrapper.add(objPaymentWrapper);
            }
        }
        return lstPaymentSourceWrapper;
    }
    /**
* @description     retrieveServiceAccount to get the Finance Account
* @param           IdSACRecord
* @return          List<Finance_Account__c>
*/
    @AuraEnabled 
    public static List<Finance_Account__c> retrieveServiceAccount(String IdSACRecord){
        List<Finance_Account__c> lstServiceAccounts = new List<Finance_Account__c>();
        List<Id> lstServAccountIDs = new List<Id>();
        List<Customer_Finance_Account__c> lstSACRecords;
        getProfileName();
        if(boolIsCustomer){
            Id personAccId = getCustomerAccountId();
            if(String.isNotBlank(personAccId)){
                lstSACRecords = getServiceAccCustomerRecords(personAccId);
            }
            
        }
        lstServAccountIDs.add(IdSACRecord);
        if(lstServAccountIDs!=null && !lstServAccountIDs.isEmpty()){
            lstServiceAccounts = getServiceAccountRecords(lstServAccountIDs);
            system.debug('sss'+lstServiceAccounts);
        }   
        if(!lstServiceAccounts.isEmpty()){
            return lstServiceAccounts;
        }else{
            return null;
        }    
    }
    /**
* @description     getServiceAccountRecords to get the list of Finance Account
* @param           lstServAccountIDs
* @return          List<Finance_Account__c>
*/
    public static List<Finance_Account__c> getServiceAccountRecords(List<ID> lstServAccountIDs){
        
        Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
        if(!lstServAccountIDs.isEmpty()){
            String strServAccQuery = 'SELECT Name , Finance_Account_Number__c, Fl_Payoff_Payment_Eligible_Web__c, Fl_Payoff_Payment_Eligible_Agent__c, RecordType.Name,'
                +'Fl_OneTime_Payment_Eligible_Web__c,Due_On_Day__c,Fl_Recurring_Payment_Eligible_Agent__c,Principal_Balance_Amount__c,AHFC_Number_of_Payments_Remaining__c,createddate,AHFC_Original_Finance_Amount__c,'
                +'Fl_Future_OneTime_Payment_Eligible_Web__c,AHFC_Total_Payments__c,  Fl_Future_OneTime_Payment_Eligible_Agent__c,Fl_OneTime_Payment_Eligible_Agent__c, Current_Amount_Due__c,'
                +'Payment_Due_Date__c, Total_Fees_Due__c, Scheduled_EasyPay_Amount__c, Fl_Refinanced__c,Honda_Brand__c,Maturity_Date__c,'
                +'AHFC_Last_Payment_Date__c,TermStat__c, AHFC_Last_Payment_Amount__c, Remaining_Amount_Due__c, Next_Due_Date__c, Fl_Recurring_Payment_Eligible_Web__c,AHFC_Contract_Start_Date__c,'
                +'Regular_Monthly_Payment__c,Payoff_Amount__c,Account_Type__c,FA_Next_Withdrawal_Date__c, AHFC_Product_Nickname__c,Term__c,AHFC_Total_days_past_due__c,'
                +'AHFC_Vehicle_Model__c ,Vehicle_Identification_Number__c,AHFC_Vehicle_Year__c,Past_Amount_Due__c,Region_Code__c,Good_Through_Date__c,Paid_to_Date__c,Final_Due_Date__c ,First_Due_Date__c ' 
                +'FROM Finance_Account__c '
                +'WHERE Id IN :lstServAccountIDs ORDER BY AHFC_Contract_Start_Date__c';
            
            return Database.query(strServAccQuery);
        }else{
            return null;
        } 
    }
    /**
* @description     paymentList to get the payment details from chargent order object
* @param           sacRecID
* @return          List<ChargentOrders__ChargentOrder__c>
*/
    @AuraEnabled
    public static List<ChargentOrders__ChargentOrder__c> paymentList(String sacRecID){
        try {
            
            List<ChargentOrders__ChargentOrder__c> lstPayments = [SELECT id,RecordType.name, Finance_Account_Number__c, ChargentOrders__Charge_Amount__c, 
                                                                  Confirmation_Number__c,Payment_Channel__c, PaymentAuthorizedOn__c,
                                                                  Payment_Source_Nickname__r.Payment_Source_Nickname__c,
                                                                  Payment_Source_Nickname__r.Last_4__c,Payment_Source_Nickname__c, 
                                                                  Last_Payment_Display_Status__c,Payment_Type__c,
                                                                  ChargentOrders__Payment_Start_Date__c,Payment_Display_Status__c,Next_Withdrawal_Date__c
                                                                  FROM ChargentOrders__ChargentOrder__c  WHERE Finance_Account_Number__c =:sacRecID 
                                                                  order by ChargentOrders__Payment_Start_Date__c ASC];
            for(ChargentOrders__ChargentOrder__c objPayment : lstPayments){
                system.debug('lstPayments'+objPayment);
            }
            return lstPayments;            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**
* @description     managePayOff to get the payment details to display on view details on make a payment page.
* @param           sacRecID
* @return          ServiceAccountWrapper 
*/
    @AuraEnabled
    public static ServiceAccountWrapper managePayOff(String sacRecID){
        
        Decimal OTPScheduledAmount = 0;
        Decimal EZPScheduledAmount = 0;
        Decimal totalScheduledAmount=0;
        Boolean pastDueStatusFlag = false; //Added by Aakash as part of US 3694
        Boolean enrollInEzPayFlag = false;//Added by Aakash as part of US 3694
        Boolean enrolledInEasyPayAndSuspended = false; // Added by Edwin as part of US 10147
        // Start - Record access check - Supriya Chakraborty 12-Nov-2021       
        list<Finance_Account__c> finObj = new list<Finance_Account__c>();    
        finObj = [select id,name,Finance_Account_Number__c,AHFC_Product_Nickname__c,AHFC_Web_Manage_Comm_Pref__c,AHFC_Web_Account_Locked__c  from Finance_Account__c where id=:sacRecId];
        boolean isUserAuth = UserSecurity.ValidateFinNumberInit(finObj[0].Finance_Account_Number__c);        
        if(!isUserAuth){
            throw new AuraHandledException('invalid access');            
        } 
        // End - Record access check - Supriya Chakraborty 12-Nov-2021
        
        ServiceAccountWrapper serAccWrapper = new ServiceAccountWrapper();
        try{
            List<Finance_Account__c> serAccRecList = retrieveServiceAccount(sacRecID);
            
            if(!serAccRecList.isEmpty()){
                List<ChargentOrders__ChargentOrder__c> lstpayment = paymentList(serAccRecList[0].id);
                List<ChargentOrders__ChargentOrder__c> lstOtpPayments = new List<ChargentOrders__ChargentOrder__c>();
                
                
                serAccWrapper.pendingOrProcessingFlag = false;
                
                for(ChargentOrders__ChargentOrder__c objPayment : lstpayment){
                    
                    if((objPayment.RecordType.name=='Standard One-Time Payment'||objPayment.RecordType.name=='Principal One-Time Payment') && (objPayment.Payment_Display_Status__c=='Pending'|| objPayment.Payment_Display_Status__c=='Processing')){
                        
                        lstOtpPayments.add(objPayment);
                        
                        if(objPayment.ChargentOrders__Payment_Start_Date__c<=serAccRecList[0].Next_Due_Date__c)
                        {
                            OTPScheduledAmount += objPayment.ChargentOrders__Charge_Amount__c > 0 ? objPayment.ChargentOrders__Charge_Amount__c : 0;    
                        }
                        
                        
                    }
                    
                    
                    
                    if(objPayment.RecordType.name=='Recurring Payment' && (objPayment.Payment_Display_Status__c=='Pending' /*|| objPayment.Payment_Display_Status__c=='Processing' */||  objPayment.Payment_Display_Status__c=='Suspended')){
                        
                        if(objPayment.Payment_Display_Status__c=='Pending' && objPayment.Next_Withdrawal_Date__c<=serAccRecList[0].Next_Due_Date__c)
                        {
                            EZPScheduledAmount +=objPayment.ChargentOrders__Charge_Amount__c > 0 ? objPayment.ChargentOrders__Charge_Amount__c : 0;    
                        }
                        
                        enrollInEzPayFlag = true;
                        
                        if(objPayment.Payment_Display_Status__c=='Suspended'){ //added by edwin US 10147 suspended easypay
                            enrolledInEasyPayAndSuspended = true;
                        }
                    }                     
                    
                    if(objPayment.RecordType.name!='Payoff Payment' && (objPayment.Payment_Display_Status__c=='Pending'|| objPayment.Payment_Display_Status__c=='Processing')){
                        serAccWrapper.pendingOrProcessingFlag = true;
                    }
                }
                
                
                //Added by Aakash as part of US 3694
                
                // added for bug id 14148
                
                System.debug('EZPScheduledAmount >>>>>> '+EZPScheduledAmount); 
                System.debug('OTPScheduledAmount >>>>>> '+OTPScheduledAmount); 
                if(lstpayment.size()>0)
                {
                    totalScheduledAmount=getTotalScheduledAmount(sacRecID,serAccRecList[0]);
                    System.debug('totalScheduledAmount >>>>>> '+totalScheduledAmount);  
                }
                
                
                if(serAccRecList[0].Past_Amount_Due__c == null || serAccRecList[0].Past_Amount_Due__c == 0 || totalScheduledAmount >= serAccRecList[0].Past_Amount_Due__c)
                {
                    pastDueStatusFlag = false;
                }else
                {
                    pastDueStatusFlag = true;
                }
                
                serAccWrapper.enrolledInEasyPayAndSuspended = enrolledInEasyPayAndSuspended;  //added by edwin US 10147 suspended easypay
                serAccWrapper.enrolledInEasyPay = enrollInEzPayFlag; 
                serAccWrapper.pastDueStatus = pastDueStatusFlag;
                
                //Added by Aakash as part of US 3694
                serAccWrapper.serAccRec = serAccRecList[0];
                serAccWrapper.lstOtpPayments=lstpayment;
                
                serAccWrapper.dblTotalAmountDue = (serAccRecList[0].Current_Amount_Due__c != null ? serAccRecList[0].Current_Amount_Due__c :0) + (serAccRecList[0].Total_Fees_Due__c != null ? serAccRecList[0].Total_Fees_Due__c: 0)+ (serAccRecList[0].Past_Amount_Due__c!=null?serAccRecList[0].Past_Amount_Due__c:0);
                serAccWrapper.strAccountType = serAccRecList[0].Account_Type__c; 
                serAccWrapper.boolRefinanced = serAccRecList[0].Fl_Refinanced__c; 
                serAccWrapper.boolOtpEligible = serAccRecList[0].Fl_OneTime_Payment_Eligible_Web__c;
                serAccWrapper.boolOtpEligibleAgent = serAccRecList[0].Fl_OneTime_Payment_Eligible_Agent__c;
                serAccWrapper.decPayoffAmount = serAccRecList[0].Payoff_Amount__c != null ? serAccRecList[0].Payoff_Amount__c :0;
                serAccWrapper.intDaysUntilDueDate = serAccRecList[0].Next_Due_Date__c!=null? datToday.daysBetween(serAccRecList[0].Next_Due_Date__c):null;
                serAccWrapper.dueOnDay = serAccRecList[0].Due_On_Day__c;
                if(serAccRecList[0].Scheduled_EasyPay_Amount__c != null){
                    serAccWrapper.dbEasypayAmount= serAccRecList[0].Scheduled_EasyPay_Amount__c;
                    serAccWrapper.dtScheduledDate= serAccRecList[0].FA_Next_Withdrawal_Date__c;
                }
                else{
                    serAccWrapper.dbEasypayAmount=0.00;
                    serAccWrapper.dtScheduledDate=null;
                }
                if(serAccRecList[0].FA_Next_Withdrawal_Date__c != null){
                    serAccWrapper.paymentDate = String.ValueOf(serAccRecList[0].FA_Next_Withdrawal_Date__c);
                }
                serAccWrapper.dbTotalSchedludedAmount=(EZPScheduledAmount!=0.00?EZPScheduledAmount:0.00)+(OTPScheduledAmount!=0 ? OTPScheduledAmount:0.00);
                serAccWrapper.strRecordType = serAccRecList[0].Recordtype.name;
                serAccWrapper.datToday = datToday;

                if(serAccRecList[0].TermStat__c != null){
                    serAccWrapper.termStat = serAccRecList[0].TermStat__c;
                }else{
                    serAccWrapper.termStat = '';
                }
                
                
            }    
        } catch (Exception e) {
        }
        return serAccWrapper;
    }
    
    /* Method Name : setBankNickName
* Author : Aswin Jose
* Description : to set the bank nickname when nickname is given as blank
* Bug ID : 15445
*/
    public static String setBankNickName(String bankName, String bankType){
        String bankNickName = '';
        String bankNameTrimmmed ='';
        if(bankName.length() >= 12 )
        {
            bankNameTrimmmed  = bankName.substring(0,12);
        }
        else
        {
            bankNameTrimmmed = bankName;
        }    
        
        System.debug('Trimmed Bank Name: '+bankNameTrimmmed);
        if(bankType == 'Checking'){
            bankNickName = bankNameTrimmmed+'-'+bankType;
        }else{
            bankNickName = bankNameTrimmmed+'-'+bankType;
        }
        System.debug('Bank NickName : '+bankNickName);
        return bankNickName;
    }
    
    
    public static Double getTotalScheduledAmount(String sacRecId,Finance_Account__c accRec)
    {
        Double totalScheduledAmount=0;
        
        try{
            AggregateResult[] groupedResults =[SELECT sum(ChargentOrders__Charge_Amount__c)totalAmt FROM ChargentOrders__ChargentOrder__c WHERE Finance_Account_Number__c =:sacRecId and 
                                               ((RecordType.name in ('Standard One-Time Payment','Principal One-Time Payment') and Payment_Display_Status__c in ('Pending','Processing') and ChargentOrders__Payment_Start_Date__c <=:accRec.Next_Due_Date__c) 
                                                or (RecordType.name in ('Recurring Payment') and Payment_Display_Status__c in ('Pending') and Next_Withdrawal_Date__c<=:accRec.Next_Due_Date__c))];   
            
            Object  totalAmt= groupedResults[0].get('totalAmt');
            
            totalScheduledAmount=Double.valueOf(totalAmt);   
            
        }catch(Exception e)
        {
            
        }
        return totalScheduledAmount;
    }
     /*@method       	:   getNumberOfPaymentsAlreadyCreated
    * @description      :   This method will calculate Next withdrawal date. Bug Id : 20276
    * @developer    	: 	vishnu Mohan
    * @date				:	12-Jul-2021
    * @params			:	dateValue
    *********************************************************************************/ 
    @AuraEnabled public static Date calculateNextWithdrawalDate(string dateValue,date firstDueDate){
        Date nextWithdrawalDate ;
        ChargentOrders__ChargentOrder__c newEasyPay = new ChargentOrders__ChargentOrder__c();
        newEasyPay.ChargentOrders__Charge_Date__c = dateValue;
        If (firstDueDate != null)
                {
                    If (firstDueDate.addDays(-21) > Date.Today())
                    {
                        nextWithdrawalDate = NWDManager.calculateNWD(newEasyPay,firstDueDate.addDays(-21), false);
                    }
                    else
                    {
                        nextWithdrawalDate = NWDManager.calculateNWD(newEasyPay, Date.today(), false);
                    }
                }
                else
                {
                    nextWithdrawalDate = NWDManager.calculateNWD(newEasyPay, Date.today(), false);
                }
        return nextWithdrawalDate;
    }
    
    
    //wrapper class
    /**
* @description     ServiceAccountWrapper
*/
    public without sharing class ServiceAccountWrapper{
        /**
* @description     datToday
*/
        @AuraEnabled
        public Date datToday {get;set;}
        /**
* @description     serAccRec
*/
        @AuraEnabled
        public Finance_Account__c serAccRec{get;set;}
        /**
* @description     lstOtpPayments
*/
        @AuraEnabled
        public List<ChargentOrders__ChargentOrder__c> lstOtpPayments{get;set;}

/**
* @description     FinanceAccount.TermStat__c
*/
        @AuraEnabled
        public String termStat{get;set;}
        
        
        
        /**
* @description     dbEasypayAmount
*/
        @AuraEnabled
        public Double  dbEasypayAmount{get;set;}
        /**
* @description     dtScheduledDate
*/
        @AuraEnabled
        public Date  dtScheduledDate{get;set;}
        /**
* @description     dbTotalSchedludedAmount
*/
        @AuraEnabled
        public Double  dbTotalSchedludedAmount{get;set;}
        /**
* @description     strCustomerName
*/
        @AuraEnabled
        public string strCustomerName{get;set;}
        /**
* @description     boolOtpEligible
*/
        @AuraEnabled
        public Boolean boolOtpEligible{get;set;}
        /**
* @description     boolOtpEligibleAgent
*/
        @AuraEnabled
        public Boolean boolOtpEligibleAgent{get;set;}
        /**
* @description     dblTotalAmountDue
*/
        @AuraEnabled
        public Double dblTotalAmountDue{get;set;}
        /**
* @description     intDaysUntilDueDate
*/
        @AuraEnabled
        public Double intDaysUntilDueDate{get;set;}
        /**
* @description     strRecordType
*/
        @AuraEnabled
        public string strRecordType{get;set;}
        /**
* @description     strAccountType
*/
        @AuraEnabled
        public String strAccountType{get;set;}
        /**
* @description     strAccountOwner
*/
        @AuraEnabled
        public String strAccountOwner{get;set;}
        /**
* @description     paymentDate
*/
        @auraEnabled
        public String paymentDate{get;set;}
        /**
* @description     dueOnDay
*/
        @auraEnabled 
        public string dueOnDay{get;set;}
        /**
* @description     decPayoffAmount
*/
        @AuraEnabled
        public Decimal decPayoffAmount{get;set;} //Added by Aakash as part of US 3694 & 3693
        /**
* @description     boolRefinanced
*/
        @AuraEnabled
        public Boolean boolRefinanced{get;set;} //Added by Aakash as part of US 3694
        /**
* @description     pastDueStatus
*/
        @AuraEnabled
        public Boolean pastDueStatus{get;set;} //Added by Aakash as part of US 3694
        /**
* @description     enrolledInEasyPay
*/
        @AuraEnabled
        public Boolean enrolledInEasyPay{get;set;} //Added by Aakash as part of US 3694
        
        @AuraEnabled
        public Boolean pendingOrProcessingFlag{get;set;} //Added by Kanagaraj as part of US 6061
        
        /**
* @description     enrolledInEasyPayAndSuspended
*/
        @AuraEnabled
        public Boolean enrolledInEasyPayAndSuspended{get;set;} //Added by Edwin as part of US 10147
    }
    
    //Added by Satish --END
}