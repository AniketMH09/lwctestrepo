/*@Apex Class Name   :   AHFC_Payment
* @Description       :   This class is used to insert the payment 
* @Created By        :   Kanagaraj
* @Created on        :   17/6/2021
* @Modified on		:	21-June-2021
* @Modified By		:	Akash Solanki
* @Modification Log	:	US 4528, 4529 & 4587 - Added line no. 55 to get the confirmation number for chargent order record inserted.
* @Modified on		:	4-Aug-2021
* @Modified By		:	Edwin Antony
* @Modification Log	:	US 3793,3794 - Added updatepayment method for updating data while editing prinipal,standard,payoff or purchase payments
* @Modification Log	:	Added the method - beforeAfterPayoff for the US - 4338
*********************************************************************************/

public without sharing class AHFC_Payment {

/*@Method Name      :   InsertNewPayment
* @Description      :   This method will insert the payments
* @Developer Name	: 	Kanagaraj
* @Date				:	17-Jun-2021
* @params			:	Finance account record Id,Payment source Id, Payment Amount,Additional Payment Amount,Schedule On date.
*********************************************************************************/
    @AuraEnabled
    public static List<ChargentOrders__ChargentOrder__c> insertPayments(id finAccId, id idPaymentSource, decimal decPaymentAmount,
                                                       decimal decAdditionalPayment, Date dtScheduleOn){
        
        decimal newdecPaymentAmount = decPaymentAmount.setscale(2);
        List<ChargentOrders__ChargentOrder__c> lstPayments = new List<ChargentOrders__ChargentOrder__c>();
        List<ChargentOrders__ChargentOrder__c> lstPaymentsToSend = new List<ChargentOrders__ChargentOrder__c>();
		Map<String,RecordType> recordTypeValues = new Map<String,RecordType>();
		recordTypeValues = RecordTypeUtility.getOrderRecordTypes();
		Id recordtypeid;
        String paymentType = '';
		string bankTokenization = '';
        Payment_Source__c bankAccDetail = [Select ChargentOrders_Tokenization__c from Payment_Source__c where Id = :idPaymentSource];
		bankTokenization = bankAccDetail.ChargentOrders_Tokenization__c;
        try {
            if(decAdditionalPayment > 0){
                paymentType = 'O';
                if(recordTypeValues.containsKey('Principal_One_Time_Payment')){
					recordtypeid = recordTypeValues.get('Principal_One_Time_Payment').Id;
                }
                lstPayments.add(singlePayment(FinAccId, idPaymentSource, dtScheduleOn, decAdditionalPayment, paymentType, recordtypeid, bankTokenization));
            }
            
            if(newdecPaymentAmount > 0){
                paymentType = 'R';
                if(recordTypeValues.containsKey('One_Time_Payment')){
                    recordtypeid = recordTypeValues.get('One_Time_Payment').Id;
                }
                lstPayments.add(singlePayment(FinAccId, idPaymentSource, dtScheduleOn, newdecPaymentAmount, paymentType, recordtypeid, bankTokenization));
            }
            
            insert lstPayments;
            
           	lstPaymentsToSend = [SELECT id, Confirmation_Number__c,Payment_Type__c, ChargentOrders__Payment_Start_Date__c,PaymentAuthorizedOn__c,
                               Payment_Source_Nickname__r.Name FROM ChargentOrders__ChargentOrder__c WHERE id IN :lstPayments];
        } catch (Exception e) {
            UtilityClass.logError('AHFC_Payment',e.getMessage(),FinAccId,'');
        }
        System.debug(lstPaymentsToSend);
        return lstPaymentsToSend;
    }
    
/* @Method Name      :   singlePayment
* @Description       :   This method will insert the payments
* @Developer Name	: 	Kanagaraj
* @Date				:	17-Jun-2021
* @params			:	Finance account record Id,Payment source Id, Payment Amount,Additional Payment Amount,Schedule On date,Payment Type,Record Type Id,Bank Tokenization.
*********************************************************************************/
     @AuraEnabled
    public static ChargentOrders__ChargentOrder__c singlePayment(id finAccId, id idPaymentSource, 
                                                      Date dtScheduleOn, decimal amountVal, String paymentType, id paymentRecordtypeId, String bankTokenization){
        ChargentOrders__ChargentOrder__c objPayment = new ChargentOrders__ChargentOrder__c();
      
            objPayment.Finance_Account_Number__c	 				= FinAccId;
            objPayment.Payment_Source_Nickname__c 					= idPaymentSource;
            objPayment.ChargentOrders__Payment_Start_Date__c 		= dtScheduleOn;
            objPayment.ChargentOrders__Charge_Amount__c 			= amountVal;
           	objPayment.Payment_Type__c  							= paymentType;  
            objPayment.recordtypeid 								= paymentRecordtypeId;
            objPayment.ChargentOrders__Manual_Charge__c 			= true;                                
            objPayment.ChargentOrders__Payment_Method__c 			= 'check';
            objPayment.ChargentOrders__Payment_Status__c 			= 'Recurring';
            objPayment.Payment_Display_Status__c 					= 'Pending';
            objPayment.ChargentOrders__Payment_Frequency__c 		= 'Once';
            objPayment.Payment_Channel__c 							= 'W';
            //'a1Nj0000002dZts';
           	//objPayment.ChargentOrders__Gateway__c 					= System.Label.GatewayId;
			objPayment.ChargentOrders__Tokenization__c 				= bankTokenization;
            
        return objPayment;
    }
    
/*@Method Name      :   insertPayoffPurchasePayments
* @Description      :   This method will insert the payoff/purchase payments
* @Developer Name	: 	Prabu Mohanasundaram
* @Date				:	14-Jul-2021
* @params			:	Finance account record Id,Payment source Id, Payment Amount,Schedule On date.
*********************************************************************************/
    @AuraEnabled
    public static List<ChargentOrders__ChargentOrder__c> insertPayoffPurchasePayments(id finAccId, id idPaymentSource, decimal decPaymentAmount,
                                                        Date dtScheduleOn){                                                                  
        
        // Start - Record access check - Supriya Chakraborty 17-Nov-2021 
        if(!test.isRunningTest()){
            List<Finance_Account__c> finList = [SELECT Id,Origination_Branch_Code__c,Honda_Brand__c,Account_Type__c,AHFC_Product_Type__c,Finance_Account_Number__c from Finance_Account__c where Id = :finAccId  limit 1]; 
            boolean isUserAuth = UserSecurity.ValidateFinNumberInit(finList[0].Finance_Account_Number__c);        
            if(!isUserAuth){
                throw new AuraHandledException('invalid access');            
            } 
        }
		// End - Record access check - Supriya Chakraborty 17-Nov-2021  
        List<ChargentOrders__ChargentOrder__c> lstPayments = new List<ChargentOrders__ChargentOrder__c>();
        List<ChargentOrders__ChargentOrder__c> lstPaymentsToSend = new List<ChargentOrders__ChargentOrder__c>();
		Map<String,RecordType> recordTypeValues = new Map<String,RecordType>();
		recordTypeValues = RecordTypeUtility.getOrderRecordTypes();
		Id recordtypeid;
        String paymentType = '';
		string bankTokenization = '';
        Payment_Source__c bankAccDetail = [Select ChargentOrders_Tokenization__c from Payment_Source__c where Id = :idPaymentSource];
		bankTokenization = bankAccDetail.ChargentOrders_Tokenization__c;
        Finance_Account__c finAccount = [select id,Finance_Account_Number__c,Final_Due_Date__c from Finance_Account__c where id = :finAccId];
        String finAccountNumber = finAccount.Finance_Account_Number__c;
        try {
                      
            if(decPaymentAmount > 0){
                system.debug('decPaymentEntry');
                paymentType = 'P';
                if(recordTypeValues.containsKey('Payoff_Payment')){
                    recordtypeid = recordTypeValues.get('Payoff_Payment').Id;
                }
                lstPayments.add(singlePayoffPurchasePayment(finAccId, finAccountNumber,idPaymentSource, dtScheduleOn, decPaymentAmount, paymentType, recordtypeid, bankTokenization));
            }
            
            insert lstPayments;
            
           	lstPaymentsToSend = [SELECT id, Confirmation_Number__c,Payment_Type__c, ChargentOrders__Payment_Start_Date__c, 
                               Payment_Source_Nickname__r.Name,Finance_Account_Number__r.Finance_Account_Number__c,PaymentAuthorizedOn__c FROM ChargentOrders__ChargentOrder__c WHERE id IN :lstPayments];
        } catch (Exception e) {
            UtilityClass.logError('AHFC_Payment',e.getMessage(),FinAccId,'');
        }
        
        return lstPaymentsToSend;
    }
    
/* @Method Name      :   singlePayoffPurchasePayment
* @Description       :   This method will insert the payoff purchase payments
* @Developer Name	: 	Prabu Mohanasundaram
* @Date				:	14-Jul-2021
* @params			:	Finance account record Id,Payment source Id, Payment Amount,Schedule On date,Payment Type,Record Type Id,Bank Tokenization.
*********************************************************************************/
     @AuraEnabled
    public static ChargentOrders__ChargentOrder__c singlePayoffPurchasePayment(id finAccId, String finAccountNumber, id idPaymentSource, 
                                                      Date dtScheduleOn, decimal amountVal, String paymentType, id paymentRecordtypeId, String bankTokenization){
                                                          
        ChargentOrders__ChargentOrder__c objPayment = new ChargentOrders__ChargentOrder__c();
           
            objPayment.Finance_Account_Number__c	 				= finAccId;
            objPayment.Payment_Source_Nickname__c 					= idPaymentSource;
            objPayment.ChargentOrders__Payment_Start_Date__c 		= dtScheduleOn;
            objPayment.ChargentOrders__Charge_Amount__c 			= amountVal;
           	objPayment.Payment_Type__c  							= paymentType;  
            objPayment.recordtypeid 								= paymentRecordtypeId;
            objPayment.ChargentOrders__Manual_Charge__c 			= true;                                
            objPayment.ChargentOrders__Payment_Method__c 			= 'check';
            objPayment.ChargentOrders__Payment_Status__c 			= 'Recurring';
            objPayment.Payment_Display_Status__c 					= 'Pending';
            objPayment.ChargentOrders__Payment_Frequency__c 		= 'Once';
            objPayment.Payment_Channel__c 							= 'W';
			objPayment.ChargentOrders__Tokenization__c 				= bankTokenization;
            objPayment.Duplicate_Key_Tracker__c 					= finAccountNumber + 'Payoff_Payment' + 'ACTIVE';
        return objPayment;
    }
    
/* @Method Name      :   getOrgdetail
* @Description       :   This method will insert the payments
* @Developer Name	: 	Kanagaraj
* @Date				:	17-Jun-2021
* @params			:	-
*Update:			 Commenting this method as we are no longer using by Narain
*********************************************************************************/
   @AuraEnabled(cacheable=true)
    public static boolean getOrgdetail(){
        Organization orgObj = [SELECT IsSandbox FROM Organization];
        return orgObj.IsSandbox;
    }
     
    /**
    * @description	: This method will return the Communication Refer record
    * @author 		:kanagraj | 7/6/2021
    * @return		:Communication_Preferences__c
    * @param 		:Finance account record Id
    **/
    
    @AuraEnabled(cacheable=true)
    public static Communication_Preferences__c commPrefDetail(string finid){
        Communication_Preferences__c commprefObj = new Communication_Preferences__c();
        try{
            commprefObj = [SELECT Id,Email_Address__c,Text_Number__c,Payment_Confirmations_via_Email__c,Payment_Confirmations_via_Text__c from Communication_Preferences__c where Paperless_Statements_Letters__c = true and Finance_Account_Number__c = :finid ORDER BY CreatedDate ASC limit 1];
        }catch(exception ex){
        }
        return commprefObj;
    }
    
    /**
    * @description	: This method will return the payoff payment detail repective finance account
    * @author 		:kanagraj / prabu | 08-July-2021
    * @return		:ChargentOrders__ChargentOrder__c
    * @param 		:Finance account record Id
    **/
    @AuraEnabled
    public static ChargentOrders__ChargentOrder__c payoffPaymentDetail(ID finAccId){
        try {            
            set<string> paymentStatus = new set<string>{'Pending', 'Processing'};
            if(finAccId != null){
                ChargentOrders__ChargentOrder__c payoffDetail =  [SELECT id,RecordType.name, Finance_Account_Number__c, ChargentOrders__Charge_Amount__c, 
                                                                      Confirmation_Number__c,Payment_Channel__c, PaymentAuthorizedOn__c,
                                                                      Payment_Source_Nickname__r.Payment_Source_Nickname__c,
                                                                      Payment_Source_Nickname__r.Last_4__c,Payment_Source_Nickname__c, 
                                                                      Last_Payment_Display_Status__c,Payment_Type__c,
                                                                      ChargentOrders__Payment_Start_Date__c,Payment_Display_Status__c
                                                                      FROM ChargentOrders__ChargentOrder__c  
                                                                      WHERE Finance_Account_Number__c =:finAccId 
                                                                      AND Payment_Display_Status__c IN:paymentStatus
                                                                      AND RecordType.DeveloperName =:'Payoff_Payment' limit 1];
                 
                return payoffDetail;
            }else{                 
                return null;
            } 
        }catch(exception e){             
            return null;}
    }
    
    
    /**
    * @description	: This method will update payment record
    * @author 		:Edwin | 21 July 2021
    * @return		:ChargentOrders__ChargentOrder__c
    * @param 		:id paymentRecId, id paymentSource, decimal paymentAmount, Date paymentDate
    * @Modificatied by : Edwin Antony
    * @Modified On     : 4 Aug 2021
    * Modification Log : include payment type parameter
    **/
    
    @AuraEnabled    
    public static ChargentOrders__ChargentOrder__c updatePayment(id paymentRecId, id paymentSource, decimal paymentAmount, Date paymentDate , string paymentType){
        system.debug('#####Inside updatePayment');
        ChargentOrders__ChargentOrder__c paymentDetails = new ChargentOrders__ChargentOrder__c();
        string bankTokenization = '';
        try{
            paymentDetails =[Select id,Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id = :paymentRecId];            
            paymentDetails.Payment_Source_Nickname__c = paymentSource;
            Payment_Source__c bankAccDetail = [Select ChargentOrders_Tokenization__c from Payment_Source__c where Id = :paymentSource];
		    bankTokenization = bankAccDetail.ChargentOrders_Tokenization__c;
            paymentDetails.ChargentOrders__Tokenization__c= bankTokenization;
            //US:3794: payment amount and payment source are editable only for principal and standard payment
            if(paymentType == 'Principal' || paymentType == 'Standard'){
                paymentDetails.ChargentOrders__Charge_Amount__c = paymentAmount;
                paymentDetails.ChargentOrders__Payment_Start_Date__c = paymentDate;
            }
            update paymentDetails;
        }catch(exception ex){
            UtilityClass.logError('AHFC_Payment',ex.getMessage(),paymentRecId,'');
        }
        return paymentDetails;
    }
    
    
     /**
    * @description	: This method will return the payoff payment detail repective finance account
    * @author 		:Prabu | 24-Aug-2021
    * @return		:ChargentOrders__ChargentOrder__c
    * @param 		:Finance account record Id
    **/
    @AuraEnabled //(cacheable=true) modified by sagar for bug fix 22296
    public static ChargentOrders__ChargentOrder__c beforeAfterPayoff(ID finId){        
        try {
            set<string> paymentStatus = new set<string>{'Pending', 'Processing', 'Posted'};
            if(finId != null){
                ChargentOrders__ChargentOrder__c payoffDetail =  [SELECT id,RecordType.name, Finance_Account_Number__c, Account_Type__c, ChargentOrders__Charge_Amount__c, 
                                                                      Confirmation_Number__c,Payment_Channel__c, PaymentAuthorizedOn__c,
                                                                      Payment_Source_Nickname__r.Payment_Source_Nickname__c,
                                                                      Payment_Source_Nickname__r.Last_4__c,Payment_Source_Nickname__c, 
                                                                      Last_Payment_Display_Status__c,Payment_Type__c,
                                                                      ChargentOrders__Payment_Start_Date__c,Payment_Display_Status__c
                                                                      FROM ChargentOrders__ChargentOrder__c  
                                                                      WHERE Finance_Account_Number__c =:finId 
                                                                      AND Payment_Display_Status__c IN:paymentStatus                                                                  	                     
                                                                      AND RecordType.DeveloperName =:'Payoff_Payment' limit 1];                
                return payoffDetail;
            }else{
                return null;
            } 
        }catch(exception e){return null;}
    }
    
}