/* Apex Class Name       :    AHFC_ManagePaymentSourceClass
* Description        :    This Class is used to insert payment source record
* Modification Log   :    
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Kanagraj                   10 / 5 /2021             Created
* Satish                     14/06/2021               Modified for US#7027 
* Satish                     14/07/2021               Modified for US#4486 
* Supriya                    16/02/2022               Modified for Bug#25964 
*********************************************************************************/
public without sharing class AHFC_ManagePaymentSourceClass {
    
    static Boolean boolIsCustomer =false;
    /**
*  @description: getPaymentsource method to get the payment source UI.
*  
*/
    @AuraEnabled
    public static List<Payment_Source__c> getPaymentSource(string sacRecId){
        List<Payment_Source__c> lstPrefPaymentSource; 
        list<Finance_Account__c> finObj = new list<Finance_Account__c>();            
        // Start - Record access check - Supriya Chakraborty 10-Nov-2021 
        finObj = [select id,name,Finance_Account_Number__c,AHFC_Product_Nickname__c,AHFC_Web_Manage_Comm_Pref__c,AHFC_Web_Account_Locked__c  from Finance_Account__c where id=:sacRecId];
        boolean isUserAuth = UserSecurity.ValidateFinNumberInit(finObj[0].Finance_Account_Number__c);
        if(!isUserAuth){
            throw new AuraHandledException('invalid access');            
        } 
        // End - Record access check - Supriya Chakraborty 10-Nov-2021
        try{
            //Id personAccId = getCustomerAccountId();
            //if(personAccId != null)
            lstPrefPaymentSource =[SELECT id, Name,Bank_Name__c, Bank_Account_Type__c, Customer__c,Last_4__c,Finance_Account_Number__c,Preferred_Payment_Source__c,Payment_Source_Nickname__c
                                   FROM Payment_Source__c WHERE Status__c = 'Active'
                                   //AND Customer__c =:personAccId
                                   AND Finance_Account_Number__c=:sacRecId];
            System.debug(lstPrefPaymentSource);
        }
        catch(Exception e){
            String exdetails = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString();
            system.debug('<<>>>'+exdetails);
            throw new AuraHandledException(e.getMessage());        
        }
        return lstPrefPaymentSource;
    }
    
    /**
* @description     getCustomerAccountId to get the customer account id
* @param 	          
* @return          ID
* 
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
            String exdetails = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString();
            throw new AuraHandledException(e.getMessage());
        }
        return idAccount;
    }
    
    /**
* @description     getServiceAccountCustomers
* @param           sacRecId
* @return          list
* 
*/
    @AuraEnabled
    public static List<Customer_Finance_Account__c> getServiceAccountCustomers(String sacRecId){
        
        List<Customer_Finance_Account__c> lstSAC = new List<Customer_Finance_Account__c>();
        
        try{
            User userDetail = new User();
            userDetail = [select id,ContactId from user where id=:UserInfo.getUserId() and ContactId!= null];
            if(userDetail.ContactId != null)
                lstSAC = [SELECT id, Customer__c, Finance_Account__r.Name, Finance_Account__r.Finance_Account_Number__c FROM Customer_Finance_Account__c WHERE Id =:userDetail.ContactId];
            
        }catch (Exception e) {
            String exdetails = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString();
            
        }
        
        System.debug('lstSAC--->'+lstSAC);
        return lstSAC;
    }
    //Modified for US#7027  by satish -start
    /**
*  created deletePaymentSource method to set the status to delete once payment source is soft delete on payment source UI.
*  Input : Payment ID
*/
    @AuraEnabled
    public static Boolean deletePaymentSource(id paymentId){
        
        Boolean isDeleted = false;
        // Bug 25964 - Suspended status added by Supriya Chakraborty on 16-Feb-2022
        list<ChargentOrders__ChargentOrder__c> lstScheduledPayment = [SELECT id, Finance_Account_Number__c,Payment_Source_Nickname__c,Payment_Display_Status__c
                                                                      FROM ChargentOrders__ChargentOrder__c  WHERE Payment_Source_Nickname__c =:paymentId AND ( Payment_Display_Status__c='Pending' OR Payment_Display_Status__c='Processing' OR Payment_Display_Status__c='Suspended') ];
        
        if(lstScheduledPayment.isEmpty()){
            Payment_Source__c objAhfcPaymentSource = new Payment_Source__c();
            objAhfcPaymentSource.id = paymentId;
            objAhfcPaymentSource.Status__c ='Deleted';
            
            Database.SaveResult sr =Database.update(objAhfcPaymentSource,false);
            if(sr.isSuccess()){
                isDeleted =true;
            }
        }
        
        return isDeleted;
    }
    
    /**
* @description     checkPaymentSource to validate the payment source delete to display view scheduled pay or delete
* @param           paymentId
* @return          Boolean
* 
*/
    
    @AuraEnabled
    public static PaymentBoolWrapper checkPaymentSource(id paymentId){
        PaymentBoolWrapper payWrapper = new PaymentBoolWrapper();
        Boolean displaySchPayments = true;
        Boolean displayNoPayments = false;
        Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();
        Datetime  CutOffTime  =  Datetime.valueof(hfc.get('CutOff_Time__c')) ;
        String tmp1 =  CutOffTime.format('HH:mm','America/Los_Angeles');
        String tmp2 =  DateTime.Now().format('HH:mm','America/Los_Angeles');            
        Time CuttOFFTime = Time.newInstance(  Integer.Valueof(tmp1.SubstringBefore(':')),  Integer.Valueof(tmp1.SubstringAfter(':')), 0 ,0 );
        Time CurrentPSTTime = Time.newInstance(  Integer.Valueof(tmp2.SubstringBefore(':')),  Integer.Valueof(tmp2.SubstringAfter(':')), 0 ,0 );
        
        Boolean cutOffFlag =false;
        
        if(CurrentPSTTime > CuttOFFTime){
            cutOffFlag = true;
            system.debug(cutOffFlag);
        }else{
            cutOffFlag = false;
            
        } 
        list<ChargentOrders__ChargentOrder__c> lstScheduledPayment = [SELECT id,RecordType.name, Finance_Account_Number__c,Next_Withdrawal_Date__c,
                                                                      Payment_Source_Nickname__c,Payment_Display_Status__c
                                                                      FROM ChargentOrders__ChargentOrder__c  WHERE Payment_Source_Nickname__c =:paymentId AND ( Payment_Display_Status__c='Pending' OR Payment_Display_Status__c='Processing' OR Payment_Display_Status__c='Suspended') ];
        
        if(lstScheduledPayment.size()>0) {
            for(ChargentOrders__ChargentOrder__c co: lstScheduledPayment){
                if(cutOffFlag && co.Next_Withdrawal_Date__c == System.today() || co.Next_Withdrawal_Date__c < System.today() ){
                    displaySchPayments =false;
                }
            }
            
            
        }
        else {
            displayNoPayments = true;  
        }
        payWrapper.displaySchPayments =displaySchPayments;
        payWrapper.displayNoPayments = displayNoPayments;
        return payWrapper;
        
    }
    //wrapper class
    /**
* @description     PaymentWrapper
*/
    public without sharing class PaymentBoolWrapper{
        
        @AuraEnabled
        public Boolean displaySchPayments{get;set;} 
        @AuraEnabled
        public Boolean displayNoPayments{get;set;} 
    }
    //Modified for US#7027  by satish -END
    //wrapper class
    /**
* @description     PaymentWrapper
*/
    public without sharing class PaymentWrapper{
        @AuraEnabled
        public Map<string,List<ChargentOrders__ChargentOrder__c>> lstPayments{get;set;}
        @AuraEnabled
        public Boolean isDeleted{get;set;} 
        @AuraEnabled
        public Boolean cutOffFlag{get;set;} 
        @AuraEnabled
        public List<Payment_Source__c> lstPaymentSources{get;set;}
        @AuraEnabled
        public string nickName{get;set;} 
        @AuraEnabled
        public string accNumber{get;set;} 
        
        @AuraEnabled
        public string bank{get;set;} 
        @AuraEnabled
        public string accType{get;set;} 
        
        
    }
    @AuraEnabled
    public static PaymentWrapper searchDetPaymentSource(string bankName, string last4Digi){
        String webAccId = getCustomerAccountId();
        String status = 'Active';
        PaymentWrapper payWrapper = new PaymentWrapper();
        List<Payment_Source__c> lstPaymentSources = [SELECT id, Name ,Finance_Account_Number__c,Bank_Name__c,Bank_Account_Type__c,Payment_Source_Nickname__c,Customer__c,Status__c,Last_4__c,Preferred_Payment_Source__c,Bank_Account_Number__c
                                                     FROM Payment_Source__c 
                                                     WHERE Status__c = :status 
                                                     AND Customer__c = :webAccId AND Payment_Source_Nickname__c =:bankName AND Last_4__c =:last4Digi LIMIT 1
                                                    ];
        payWrapper.lstPaymentSources=lstPaymentSources;
        return payWrapper;
    }
    /**
* @description     deleteSchPaymentSource fetch the payment details related to delete payment
* @param           paymentId
* @return          wrapper
* 
*/
    @AuraEnabled
    public static PaymentWrapper deleteSchPaymentSource(id paymentId){
        String webAccId = getCustomerAccountId();
        String status = 'Active';
        PaymentWrapper payWrapper = new PaymentWrapper();
        Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();
        string cutOffTime = hfc.CutOff_Time__c.format('h:mm a') ;
        Boolean cutOffFlag =false;
        if(System.now().time() > hfc.CutOff_Time__c.time()){
            cutOffFlag = true;
            
        }else{
            cutOffFlag = false;
            
        } 
        Payment_Source__c finAccId = [select Finance_Account_Number__c from Payment_Source__c where id =:paymentId] ;
        List<Payment_Source__c> lstPaymentSourcesDetails = new List<Payment_Source__c> ();     
        List<Payment_Source__c> lstPaymentSources = [SELECT id, Name ,Finance_Account_Number__c,Bank_Name__c,Bank_Account_Type__c,Payment_Source_Nickname__c,Customer__c,Status__c,Last_4__c,Preferred_Payment_Source__c,Bank_Account_Number__c
                                                     FROM Payment_Source__c 
                                                     WHERE Status__c = :status 
                                                     //AND Customer__c = :webAccId 
                                                     AND Finance_Account_Number__c = : finAccId.Finance_Account_Number__c                                         
                                                    ];
        // Bug 25964 - Suspended status added by Supriya Chakraborty on 16-Feb-2022
        list<ChargentOrders__ChargentOrder__c> lstScheduledPayment = [SELECT Id,RecordType.name, Finance_Account_Number__c,Finance_Account_Number__r.AHFC_Product_Nickname__c, ChargentOrders__Charge_Amount__c, 
                                                                      Confirmation_Number__c,Payment_Channel__c, PaymentAuthorizedOn__c,Last_Extraction_Date__c,
                                                                      Payment_Source_Nickname__r.Payment_Source_Nickname__c,
                                                                      Payment_Source_Nickname__r.Last_4__c,Payment_Source_Nickname__c, 
                                                                      Last_Payment_Display_Status__c,Payment_Type__c,Next_Withdrawal_Date__c,
                                                                      ChargentOrders__Payment_Start_Date__c,Payment_Display_Status__c
                                                                      FROM ChargentOrders__ChargentOrder__c  WHERE Payment_Source_Nickname__c =:paymentId AND ( Payment_Display_Status__c='Pending' OR Payment_Display_Status__c='Processing' OR Payment_Display_Status__c='Suspended') ];
        
        
        Map<string,List<ChargentOrders__ChargentOrder__c>> mapofpayments = new  Map<string,List<ChargentOrders__ChargentOrder__c>>();
        for(ChargentOrders__ChargentOrder__c payment : lstScheduledPayment){
            
            if(mapofpayments.containsKey(payment.Finance_Account_Number__r.AHFC_Product_Nickname__c)){
                
                mapofpayments.get(payment.Finance_Account_Number__r.AHFC_Product_Nickname__c).add(payment);
            }
            else{
                
                list<ChargentOrders__ChargentOrder__c> lst = new list<ChargentOrders__ChargentOrder__c>();
                lst.add(payment);
                
                mapofpayments.put(payment.Finance_Account_Number__r.AHFC_Product_Nickname__c,lst);
                
            }
        }
        for(Payment_Source__c ps:lstPaymentSources){
            if(ps.id == paymentId){
                payWrapper.nickName =ps.Payment_Source_Nickname__c;
                payWrapper.accNumber =ps.Last_4__c;
                payWrapper.bank=ps.Bank_Name__c;
                payWrapper.accType=ps.Bank_Account_Type__c;
            }
            else{
                lstPaymentSourcesDetails.add(ps);   
            }
        }
        payWrapper.lstPaymentSources=lstPaymentSourcesDetails;
        payWrapper.lstPayments=mapofpayments;
        payWrapper.cutOffFlag=cutOffFlag;
        return payWrapper;
    }
    /**
* @description     updatePaymentsDeleteSources fetch the update payments and soft delete payment source
* @param           wrapper
* @return          wrapper
* 
*/
    @AuraEnabled
    public static Boolean updatePaymentsDeleteSources(list<Object> paymentData ){
        
        
        string js =JSON.serialize(paymentData);
        Boolean isUpdated =false;
        list<string> newPaymentIds = new list<string>(); //added for 
        map<string,string> newMapPaymentToken = new map<string,string>();
        List<Object> lst_JsonParse = (List<Object>)Json.deserializeUntyped(js);
        System.debug('lst_JsonParse>>>>>>>>>>>>>>>>>>>>>>'+lst_JsonParse);
        list<string> paymentIds = new list<string>();
        map<string,string> mapPayIds = new map<string,string>();
        for(Object obj : lst_JsonParse)
        {
            Map<String,Object> mp_StrObj = (Map<string,Object>)obj;
            System.debug('mp_StrObj>>>>>>>>>>>>>>>>>>>>>>'+mp_StrObj);
            paymentIds.add(string.valueof(mp_StrObj.get('Payment_Source_Nickname__c')));
            system.debug('Payment_Source_Nickname__c>>>'+string.valueof(mp_StrObj.get('Payment_Source_Nickname__c')));
            mapPayIds.put(string.valueof(mp_StrObj.get('Id')),string.valueof(mp_StrObj.get('psId')));
            newPaymentIds.add(string.valueof(mp_StrObj.get('psId')));
            System.debug('Id>>>>>>>>>>>>>>>>>>>>>>'+string.valueof(mp_StrObj.get('Id')));
            System.debug('psId>>>>>>>>>>>>>>>>>>>>>>'+string.valueof(mp_StrObj.get('psId')));
        }
        System.debug('mapPayIds>>>>>>>>>>>>>>>>>>>>>>'+mapPayIds);
        System.debug('318>>>>>>>>>>>>>>>>>>>>>>'+newPaymentIds);
        list<ChargentOrders__ChargentOrder__c> updatePayList = new list<ChargentOrders__ChargentOrder__c>();
        List<Payment_Source__c> bankAccDetail = [Select id,ChargentOrders_Tokenization__c from Payment_Source__c where Id in :newPaymentIds];
        // bankTokenization = bankAccDetail.ChargentOrders_Tokenization__c;
        system.debug('322>>'+bankAccDetail);
        system.debug('323>>'+mapPayIds.keyset());
        for(string payids: mapPayIds.keyset()){
            for(Payment_Source__c paysrc: bankAccDetail){ 
                if(mapPayIds.get(payids) == string.valueof(paysrc.id)){
                    newMapPaymentToken.put(payids,paysrc.ChargentOrders_Tokenization__c);  
                }
                
            }
        }
        system.debug('331>>>'+newMapPaymentToken);
        
        for(ChargentOrders__ChargentOrder__c co :[select Id,Payment_Source_Nickname__c from ChargentOrders__ChargentOrder__c where Id IN:mapPayIds.keyset() ] ){
            co.Payment_Source_Nickname__c = mapPayIds.get(co.Id);
            system.debug('335>>>'+newMapPaymentToken.get(co.Id));
            co.ChargentOrders__Tokenization__c = newMapPaymentToken.get(co.Id);
            
            updatePayList.add(co);
        }
        if(updatePayList.size()>0)
            update  updatePayList;
        
        Payment_Source__c ps =[select id from Payment_Source__c where ID =:paymentIds[0] limit 1] ;
        
        Payment_Source__c objAhfcPaymentSource = new Payment_Source__c();
        objAhfcPaymentSource.id = paymentIds[0];
        objAhfcPaymentSource.Status__c ='Deleted';
        
        Database.SaveResult sr =Database.update(objAhfcPaymentSource,false);
        if(sr.isSuccess()){
            isUpdated =true;
        }
        system.debug('isUpdated>>>>>>>>>>>>>>>>>>>>>>>'+isUpdated);
        return isUpdated;
    }
    
}