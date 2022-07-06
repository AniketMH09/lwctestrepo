/* Apex Class Name       :    AHFC_DashboardController
*  description         :    This Class is used to get all Finance Account details related to Service Account
*  Modification Log   :
* ---------------------------------------------------------------------------
*  Developer                    Date                   Description
* --------------------------------------------------------------------------- 
*  ANIKET PHARAKATE            20 May 2021               Created
*  Edwin Antony                12-Aug-2021               Modified US 10147 Already Enrolled in EasyPay - SUSPENDED EASYPAY 
*  Sagar Ghadigaonkar          09-Sep-2021               Modified US 7659 added filed AHFC_Web_Dashboard_Payment_Progress__c  in strServAccQuery query string
*/
public without sharing class AHFC_DashboardController {
    
    public static final Date DATETODAY = System.today();
    static String strUserProfile = '';
    static Boolean boolIsCustomer =true;
    static Map<Id, Id> mapSAToSAC =new Map<Id, Id>();
    
    
    /*Written By Aniket P | 20 may'2021
     * @Method Name : getServiceAccountdetails
     * @description:  to be called from UI
     */
    
    @AuraEnabled //(cacheable=true)
    public static List<ServiceAccountWrapper> getServiceAccountdetails(){
        List<Id> lstServAccountIDs = retrieveServiceAccount();
        
        List<Finance_Account__c> lstServiceAccounts = new List<Finance_Account__c>();
        
        Map<id,List<ChargentOrders__ChargentOrder__c>> mapofpayments = new Map<id,List<ChargentOrders__ChargentOrder__c>> ();
        List<ServiceAccountWrapper> lstserviceAccountWrapper = new List<ServiceAccountWrapper>();
        
        
        if(lstServAccountIDs!=null && !lstServAccountIDs.isEmpty()){
            lstServiceAccounts = getServiceAccountRecords(lstServAccountIDs);
            system.debug('lstServAccountIDs'+lstServAccountIDs);
            mapofpayments = paymentList(lstServAccountIDs);            
        }
        System.debug('@@@@lstServiceAccounts: '+lstServiceAccounts);
        Map<String, ChargentOrders__ChargentOrder__c> charOrderMap = new Map<String, ChargentOrders__ChargentOrder__c>();
        for (ChargentOrders__ChargentOrder__c charOrder: [SELECT id, Finance_Account_Number__c, ChargentOrders__Charge_Amount__c, Payment_Channel__c,RecordType.Name,
                                                          Last_Payment_Display_Status__c,Payment_Type__c,ChargentOrders__Payment_Start_Date__c,Payment_Display_Status__c FROM ChargentOrders__ChargentOrder__c 
                                                          WHERE Finance_Account_Number__c IN:lstServiceAccounts and RecordType.Name ='Recurring Payment' and (Payment_Display_Status__c = 'Pending' OR Payment_Display_Status__c = 'Processing' OR Payment_Display_Status__c = 'Suspended')]) {
                                                              charOrderMap.put(charOrder.Finance_Account_Number__c, charOrder);
                                                          }
        
        
        if(!lstServiceAccounts.isEmpty()){
            for(Finance_Account__c objSA : lstServiceAccounts){
                ServiceAccountWrapper SAWrapper = new ServiceAccountWrapper();
                SAWrapper.datToday = DATETODAY;
                SAWrapper.serAccRec = objSA;
                SAWrapper.dtContractdate = objSA.AHFC_Contract_Start_Date__c;
                SAWrapper.isHonda = true;
                
                ChargentOrders__ChargentOrder__c boolEnrolled = charOrderMap.get(objSA.Id);
                system.debug('***boolEnrolled: '+objSA.Id);
                system.debug('***boolEnrolled: '+boolEnrolled);
                SAWrapper.boolenrolled =false;  
                if(boolEnrolled != null){
                    if(boolEnrolled.Payment_Display_Status__c == 'Pending'  /*||boolEnrolled.Payment_Display_Status__c == 'Processing' */ || boolEnrolled.Payment_Display_Status__c == 'Suspended'){ //added suspended status check by edwin as part of US:10147
                        SAWrapper.boolenrolled =true; 
                    }
                    else{
                        SAWrapper.boolenrolled =false; 
                    }    
                }
                
                if(String.isNotBlank(objSA.Honda_Brand__c) && objSA.Honda_Brand__c.equalsIgnoreCase('AFS')){
                    SAWrapper.isHonda = false;
                } 
                
                if(mapofpayments.containsKey(objSA.id)){
                    SAWrapper.lstOtpPayments = mapofpayments.get(objSA.id);
                }
                
                SAWrapper.dblTotalAmountDue = (objSA.Current_Amount_Due__c != null ? objSA.Current_Amount_Due__c :0) + (objSA.Total_Fees_Due__c != null ? objSA.Total_Fees_Due__c: 0)+ (objSA.Past_Amount_Due__c!=null?objSA.Past_Amount_Due__c:0);
                SAWrapper.intDaysUntilDueDate = objSA.Next_Due_Date__c!=null? DATETODAY.daysBetween(objSA.Next_Due_Date__c):null;
                SAWrapper.dblTotalDaysPastDue = objSA.AHFC_Total_days_past_due__c!=null? objSA.AHFC_Total_days_past_due__c: 0;
                SAWrapper.inDaysEOT = objSA.Maturity_Date__c!=null? DATETODAY.daysBetween(objSA.Maturity_Date__c):0;
                lstserviceAccountWrapper.add(SAWrapper);
            }
            
        }
        
        lstserviceAccountWrapper.sort();
        return lstserviceAccountWrapper;
        
    } 
    
    /*Written By Narain  | 9 Jan'2022
     * @Method Name : AHFCInventoryShortageSwitch
     * @description:  AHFCInventoryShortageSwitch custom label value
     */
     @AuraEnabled
    public static String AHFCInventoryShortageSwitch(){
       String AHFCInventoryShortageSwitch ;
       
            AHFCInventoryShortageSwitch = System.Label.AHFC_Inventory_Shortage_Switch; 
        
        return AHFCInventoryShortageSwitch;
    }
    
    
    /*Written By Aniket P | 20 may'2021
     * @Method Name : retrieveServiceAccount
     * @description:  to GET JUNCTIONS DATA
     */
    @AuraEnabled 
    public static List<Id> retrieveServiceAccount(){
        List<Finance_Account__c> lstServiceAccounts = new List<Finance_Account__c>();
        List<Id> lstServAccountIDs = new List<Id>();
        List<Customer_Finance_Account__c> lstSACRecords;
        getProfileName();  
        
        if(boolIsCustomer){
            Id personAccId = getCustomerAccountId();
            System.debug('personAccId: '+personAccId);
            lstSACRecords = getServiceAccCustomerRecords(personAccId);
           
            
        }
        
        if(lstSACRecords != null && !lstSACRecords.isEmpty()){
            for(Customer_Finance_Account__c objServAccCustomer :lstSACRecords){
                 System.debug('lstSACRecords: '+objServAccCustomer.Finance_Account__c);
                lstServAccountIDs.add(objServAccCustomer.Finance_Account__c);
                mapSAToSAC.put(objServAccCustomer.Finance_Account__c,objServAccCustomer.Id);
            }
            
        }
        
        if(!lstServAccountIDs.isEmpty()){
            return lstServAccountIDs;
        }else{
            return null;
        }  
        
    }
    
    
    /*
     * Description : This method is used to get the list of  Service Account Customer Record associated with logged in user
     * @return object reference : Return Service Account Customer record(s)
     */
    public static List<Customer_Finance_Account__c> getServiceAccCustomerRecords(ID IdWebAccount){
        Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
        String strSACQuery = 'SELECT  Customer__c, Finance_Account__c FROM Customer_Finance_Account__c';
        
        if(IdWebAccount != null ){
            strSACQuery +=' WHERE Customer__c =:IdWebAccount and is_active__c=true ORDER BY CreatedDate DESC'; 
        }
        strSACQuery += ' limit :limitRows'; 
        
        return Database.query(strSACQuery);
    }
    
    
    
    /*
     * Description : This method is used to retrieve profile name of the logged in user
     *  @return object reference : Return list of logged in users profile name
     */
    @AuraEnabled
    public static string getProfileName()
    { 
        try{
            strUserProfile = [Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
            if(String.isNotBlank(strUserProfile) && strUserProfile.equals('Customer')){
                boolIsCustomer = true;
            }
            return strUserProfile;
        } 
        catch(Exception e)
        {  
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /*
     * Description : This method is used to retrieve logged in community users accountId
     * @return object reference : Return logged in community users accountId
     */
    @AuraEnabled
    public static Id getCustomerAccountId(){
        ID idAccount  = null;
        try{
            List<User> lstUser = [SELECT contactid, accountId from User where id=: Userinfo.getUserid()];
            
            if(!lstUser.isEmpty() && lstUser[0].accountId != null){
                idAccount = lstUser[0].accountId;
            }
        } catch (Exception e) {
            String exdetails = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString();
            throw new AuraHandledException(exdetails);
        }
        
        return idAccount;
    }
    
    /*
     * Description : This method is used to retrieve logged in community users FINANCE IDS
     * @return object reference : Return logged in community users FINANCE accounTS RECORDS
     */
    
    public static List<Finance_Account__c> getServiceAccountRecords(List<ID> lstServAccountIDs){
        
        Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
        if(!lstServAccountIDs.isEmpty()){
            String strServAccQuery = 'SELECT Name, Finance_Account_Number__c, Fl_Payoff_Payment_Eligible_Web__c, Fl_Payoff_Payment_Eligible_Agent__c, RecordType.Name, Region_Code__c,'
                +'Fl_OneTime_Payment_Eligible_Web__c,FL_LE_Eligibility__c,Fl_Recurring_Payment_Eligible_Agent__c,Principal_Balance_Amount__c,AHFC_Number_of_Payments_Remaining__c,createddate,AHFC_Original_Finance_Amount__c,'
                +'Fl_Future_OneTime_Payment_Eligible_Web__c,AHFC_Total_Payments__c,  Fl_Future_OneTime_Payment_Eligible_Agent__c,Fl_OneTime_Payment_Eligible_Agent__c, Current_Amount_Due__c,'
                +'Payment_Due_Date__c, Total_Amount_Due__c,Total_Fees_Due__c, Scheduled_EasyPay_Amount__c, Fl_Refinanced__c,Honda_Brand__c,Maturity_Date__c,AHFC_Fl_Archived__c,'
                +'AHFC_Last_Payment_Date__c, AHFC_Last_Payment_Amount__c, Remaining_Amount_Due__c, Next_Due_Date__c, Fl_Recurring_Payment_Eligible_Web__c,AHFC_Contract_Start_Date__c, AHFC_Web_Account_Locked__c,'
                +'Regular_Monthly_Payment__c,Payoff_Amount__c,Account_Type__c,FA_Next_Withdrawal_Date__c, AHFC_Product_Nickname__c,Term__c,AHFC_Total_days_past_due__c,Finance_Account_Number_Without_Zeroes__c,'
                +'AHFC_Vehicle_Model__c,AHFC_Web_Manage_Comm_Pref__c,Fl_Paid_Ahead__c,Paid_to_Date__c,Vehicle_Identification_Number__c,AHFC_Product_Type__c,AHFC_Vehicle_Year__c,Past_Amount_Due__c,AHFC_Product_Division__c,AHFC_Model_ID__c,AHFC_Web_Dashboard_Payment_Progress__c '
                +'FROM Finance_Account__c '
                +'WHERE Id IN :lstServAccountIDs ORDER BY AHFC_Contract_Start_Date__c DESC NULLS LAST';
            
            return Database.query(strServAccQuery);
        }else{
            return null;
        } 
    }
    
    /*
     * Description : This method is used to retrieve logged in community users PAYMENT IDS
     * @return object reference : Return logged in community users PAYMENT accounTS RECORDS
     */
    
    @AuraEnabled
    public static Map<id,List<ChargentOrders__ChargentOrder__c>> paymentList(List<id> sacRecID){
        Map<id,List<ChargentOrders__ChargentOrder__c>> mapofpayments = new  Map<id,List<ChargentOrders__ChargentOrder__c>>();
        
        try {
            for(ChargentOrders__ChargentOrder__c payment : [SELECT id,Next_Withdrawal_Date__c,RecordType.name, Finance_Account_Number__c, ChargentOrders__Charge_Amount__c, Payment_Channel__c, 
                                                            Last_Payment_Display_Status__c,Payment_Type__c,ChargentOrders__Payment_Start_Date__c,Payment_Display_Status__c 
                                                            FROM ChargentOrders__ChargentOrder__c 
                                                            WHERE Finance_Account_Number__c IN: sacRecID and ( Payment_Display_Status__c = 'Pending' OR Payment_Display_Status__c = 'Processing' OR Payment_Display_Status__c = 'Suspended') order by ChargentOrders__Payment_Start_Date__c ASC])
                                                             {
                                                                if(mapofpayments.containsKey(payment.Finance_Account_Number__c)){
                                                                    mapofpayments.get(payment.Finance_Account_Number__c).add(payment);
                                                                }
                                                                else{
                                                                    list<ChargentOrders__ChargentOrder__c> lst = new list<ChargentOrders__ChargentOrder__c>();
                                                                    lst.add(payment);
                                                                    mapofpayments.put(payment.Finance_Account_Number__c,lst);
                                                                    
                                                                }
                                                            }
            return mapofpayments;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
  
    
  
    public without sharing class ServiceAccountWrapper implements Comparable{
        @AuraEnabled
        public Date datToday {get;set;}
        @AuraEnabled
        public Finance_Account__c serAccRec{get;set;}
        @AuraEnabled
        public List<ChargentOrders__ChargentOrder__c> lstOtpPayments{get;set;}
        @AuraEnabled
        public List<ChargentOrders__ChargentOrder__c> lstPayoffPayments{get;set;}
        @AuraEnabled
        public Double dblTotalAmountDue{get;set;}
        @AuraEnabled
        public Double intDaysUntilDueDate{get;set;}
        @AuraEnabled
        public Boolean boolenrolled{get;set;}
        @AuraEnabled
        public String idSAC{get;set;}
        @AuraEnabled
        public boolean isHonda{get;set;}
        @AuraEnabled
        public date dtContractdate{get;set;}
        @AuraEnabled
        public Integer intStatusCheck{get;set;}
        @AuraEnabled
        public Double dblTotalDaysPastDue{get;set;}
        @AuraEnabled
        public Double inDaysEOT{get;set;}
        public Integer compareTo(Object compareTo) {
            ServiceAccountWrapper objCompareTo = (ServiceAccountWrapper)compareTo;
            if(this.intStatusCheck<objCompareTo.intStatusCheck){
                return 1;
            }else if(this.intStatusCheck>objCompareTo.intStatusCheck){
                return -1;
            }else{
                return 0;
            }
        }
    }
}