/*@Apex Class 	    :   AHFC_ReviewPaymentDetails
* @description      :   This class is used to get the payment Details in Review Payment screen
* @created By       :   Aswin
* @created on       :   22/6/2021
* @modified on		:	22/6/2021
* @modified By		:	Aswin Jose
* @modification Log	:   updated for bug fix 4533
* @modified on		:	27/6/2021
* @modified By		:	Edwin Antony
* @modification Log	:   updated for US 3793 , include payment type check while cancelling OTP
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Aswin Jose                22/6/2021                  Created for US 4533,4534
* Aswin Jose                07/7/2021                  Updated for US 4533 bug fix
*********************************************************************************/
public without sharing class AHFC_ReviewPaymentDetails {
    
/*@method 	        :   commPrefDetail
* @description      :   This method will get the comm Pref Detail details
* @developer 		: 	Aswin
* @date				:	22-Jun-2021
* @params			:	Finance account record Id
*********************************************************************************/
    @AuraEnabled(cacheable=true)
    public static Communication_Preferences__c commPrefDetail(string finid){
        List<Communication_Preferences__c> commprefObjList = [SELECT Id,Email_Address__c,Text_Number__c,Payment_Confirmations_via_Email__c,Payment_Confirmations_via_Text__c 
                                                    from Communication_Preferences__c where Paperless_Statements_Letters__c = true and Finance_Account_Number__c = :finid 
                                                    ORDER BY CreatedDate ASC limit 1];
        
        System.debug('commList'+commprefObjList);
        if(commprefObjList.size() > 0){
            return commprefObjList[0];
        }
        else{
            return null;
        }
    }
    
 /*@method 	        :   commPrefDetailForEasyPay
* @description      :   This method will get the comm Pref Detail details
* @developer 		: 	Edwin
* @date				:	29-Oct-2021
* @params			:	Finance account record Id
*********************************************************************************/
    @AuraEnabled
    public static Communication_Preferences__c commPrefDetailForEasyPay(string finid){
        // Start - Record access check - Supriya Chakraborty 17-Nov-2021 
        if(!test.isRunningTest()){
            List<Finance_Account__c> finList = [SELECT Id,Origination_Branch_Code__c,Honda_Brand__c,Account_Type__c,AHFC_Product_Type__c,Finance_Account_Number__c from Finance_Account__c where Id = :finid  limit 1]; 
            boolean isUserAuth = UserSecurity.ValidateFinNumberInit(finList[0].Finance_Account_Number__c);        
            if(!isUserAuth){
                throw new AuraHandledException('invalid access');            
            } 
        }
		// End - Record access check - Supriya Chakraborty 17-Nov-2021  
        
        List<Communication_Preferences__c> commprefObjList = [SELECT Id,Email_Address__c,Text_Number__c,EasyPay_Communications_via_Email__c, EasyPay_Communications_via_Text__c
                                                    from Communication_Preferences__c where (EasyPay_Communications_via_Email__c = true OR EasyPay_Communications_via_Text__c = true) and Finance_Account_Number__c = :finid 
                                                    ORDER BY CreatedDate ASC limit 1];
        
        System.debug('commList'+commprefObjList);
        if(commprefObjList.size() > 0){
            return commprefObjList[0];
        }
        else{
            return null;
        }
    } 
    
    
 /*@method 	        :   commPrefDetailForOTP
* @description      :   This method will get the comm Pref Detail details
* @developer 		: 	Edwin
* @date				:	29-Oct-2021
* @params			:	Finance account record Id
*********************************************************************************/
    @AuraEnabled
    public static Communication_Preferences__c commPrefDetailForOTP(string finid){
        List<Communication_Preferences__c> commprefObjList = [SELECT Id,Email_Address__c,Text_Number__c,Payment_Confirmations_via_Email__c, Payment_Confirmations_via_Text__c
                                                    from Communication_Preferences__c where (Payment_Confirmations_via_Email__c = true OR Payment_Confirmations_via_Text__c = true) and Finance_Account_Number__c = :finid 
                                                    ORDER BY CreatedDate ASC limit 1];
        
        System.debug('commList'+commprefObjList);
        if(commprefObjList.size() > 0){
            return commprefObjList[0];
        }
        else{
            return null;
        }
    }
    
    @AuraEnabled
    public static List<ChargentOrders__ChargentOrder__c> insertEasyPayPayments(id finAccId, id idPaymentSource,decimal decPaymentAmount,string dtScheduleOn, Integer chargeDate) {
        // Start - Record access check - Supriya Chakraborty 17-Nov-2021 
        if(!test.isRunningTest()){
            List<Finance_Account__c> finList = [SELECT Id,Origination_Branch_Code__c,Honda_Brand__c,Account_Type__c,AHFC_Product_Type__c,Finance_Account_Number__c from Finance_Account__c where Id = :finAccId  limit 1]; 
            boolean isUserAuth = UserSecurity.ValidateFinNumberInit(finList[0].Finance_Account_Number__c);        
            if(!isUserAuth){
                throw new AuraHandledException('invalid access');            
            } 
        }
        // End - Record access check - Supriya Chakraborty 17-Nov-2021  
        
        Date myDate = date.valueOf(dtScheduleOn);
        List<ChargentOrders__ChargentOrder__c> lstPaymentsToSend = AHFC_ReviewPaymentDetails.insertPayments(finAccId,idPaymentSource,decPaymentAmount,myDate,chargeDate);
        return lstPaymentsToSend;
        }
    
/*@method      		:   InsertNewPayment
* @description      :   This method will insert the payments
* @developer		: 	Aswin Deepak Jose
* @date				:	29-Jun-2021
* @params			:	Finance account record Id,Payment source Id, Payment Amount,Additional Payment Amount,Schedule On date.
*********************************************************************************/
    @AuraEnabled
    public static List<ChargentOrders__ChargentOrder__c> insertPayments(id finAccId, id idPaymentSource, 
                                                                        decimal decPaymentAmount,Date dtScheduleOn, Integer chargeDate){
        
        Id recordtypeid;
        String paymentType = '';
		string bankTokenization = '';
        List<ChargentOrders__ChargentOrder__c> lstPayments = new List<ChargentOrders__ChargentOrder__c>();
        List<ChargentOrders__ChargentOrder__c> lstPaymentsToSend = new List<ChargentOrders__ChargentOrder__c>();
		Map<String,RecordType> recordTypeValues = new Map<String,RecordType>();
		recordTypeValues = RecordTypeUtility.getOrderRecordTypes();
		Finance_Account__c finAccount = [select id,Finance_Account_Number__c,Final_Due_Date__c from Finance_Account__c where id = :finAccId];
        Date finalDueDate = finAccount.Final_Due_Date__c;
        String finAccountNumber = finAccount.Finance_Account_Number__c;
        
        Payment_Source__c bankAccDetail = [Select ChargentOrders_Tokenization__c from Payment_Source__c where Id = :idPaymentSource];
		bankTokenization = bankAccDetail.ChargentOrders_Tokenization__c;
        
        try {
            if(decPaymentAmount > 0){
                paymentType = 'R';
                if(recordTypeValues.containsKey('Recurring_Payment')){
                    recordtypeid = recordTypeValues.get('Recurring_Payment').Id;
                }
                lstPayments.add(singlePayment(FinAccId, finAccountNumber,idPaymentSource, dtScheduleOn, decPaymentAmount, paymentType, recordtypeid, bankTokenization,finalDueDate, chargeDate));
            }
            system.debug('lstPayments'+lstPayments);
            insert lstPayments;
            
           	lstPaymentsToSend = [SELECT id, Confirmation_Number__c,Payment_Type__c, ChargentOrders__Payment_Start_Date__c, 
                              Payment_Source_Nickname__r.Name,PaymentAuthorizedOn__c FROM ChargentOrders__ChargentOrder__c WHERE id IN :lstPayments];
        } catch (Exception e) {
            UtilityClass.logError('AHFC_Payment insertPayments',e.getMessage(),FinAccId,'');
            system.debug('e.getMessage()'+e.getMessage());
           // throw new aurahandledexception(e.getmessage());
        }
        System.debug('@@@@@@@@@@@ Payment Record: '+lstPaymentsToSend);
        return lstPaymentsToSend;
    }
    
/*@method       	:   singlePayment
* @description      :   This method will insert the payments
* @developer    	: 	Aswin Jose
* @date				:	29-Jun-2021
* @params			:	Finance account record Id,Payment source Id, Payment Amount,Additional Payment Amount,Schedule On date,Payment Type,Record Type Id,Bank Tokenization.
*********************************************************************************/
    @AuraEnabled
    public static ChargentOrders__ChargentOrder__c singlePayment(id finAccId,String finAccountNumber,id idPaymentSource, Date dtScheduleOn, decimal amountVal, 
                                                                 String paymentType, id paymentRecordtypeId, String bankTokenization, Date finalDueDate, Integer chargeDate){       
           	
           	ChargentOrders__ChargentOrder__c objPayment = new ChargentOrders__ChargentOrder__c();
      		system.debug('dtScheduleOn>>>>'+dtScheduleOn);
            objPayment.Finance_Account_Number__c	 				= FinAccId;
            objPayment.Payment_Source_Nickname__c 					= idPaymentSource;
            objPayment.ChargentOrders__Payment_Start_Date__c 		= system.today();
            objPayment.ChargentOrders__Payment_End_Date__c 			= finalDueDate;
            objPayment.Next_Withdrawal_Date__c 						= dtScheduleOn;
            objPayment.ChargentOrders__Charge_Amount__c 			= amountVal;
           	objPayment.Payment_Type__c  							= paymentType;  
            objPayment.recordtypeid 								= paymentRecordtypeId;
            objPayment.ChargentOrders__Manual_Charge__c 			= true;
            //We are referring the existing code as suggested. based on that we are providing the hardcoded values for 5 fields
            objPayment.ChargentOrders__Payment_Method__c 			= 'check'; 
            objPayment.ChargentOrders__Payment_Status__c 			= 'Recurring';
            objPayment.Payment_Display_Status__c 					= 'Pending';
            objPayment.ChargentOrders__Payment_Stop__c 				= 'Date';
            objPayment.ChargentOrders__Payment_Frequency__c 		= 'Monthly';
            objPayment.Payment_Channel__c 							= 'R';
           	objPayment.ChargentOrders__Gateway__c 					= System.Label.GatewayId;
			objPayment.ChargentOrders__Tokenization__c 				= bankTokenization;
            objPayment.Duplicate_Key_Tracker__c 					=  finAccountNumber + 'Recurring_Payment' + 'ACTIVE';
            if(chargeDate < 10){
            	objPayment.ChargentOrders__Charge_Date__c = '0'+ string.valueOf(chargeDate);
			}else{
				objPayment.ChargentOrders__Charge_Date__c = string.valueOf(chargeDate) ;
			}
            /*
            if(dtScheduleOn.Day() < 10){
            	objPayment.ChargentOrders__Charge_Date__c = '0'+String.valueOf(dtScheduleOn.Day());
			}else{
				objPayment.ChargentOrders__Charge_Date__c = String.valueOf(dtScheduleOn.Day());
			}
            */
		System.debug('Payment Record : '+objPayment);                                           
        return objPayment;
    }
    
    
/*@method       	:   updatePaymentAfterCancelEasyPay
* @description      :   This method will update the payments after cancelling Easy pay Scheduled payments
* @developer    	: 	Aswin Jose
* @date				:	05-Jul-2021
* @params			:	paymentRecId
*********************************************************************************/
    @AuraEnabled
    public static List<ChargentOrders__ChargentOrder__c> updatePaymentAfterCancelEasyPay(Id paymentRecId){
        ChargentOrders__ChargentOrder__c paymentRecToUpdate = new ChargentOrders__ChargentOrder__c();
        List<ChargentOrders__ChargentOrder__c> paymentRecToUpdateList = new List<ChargentOrders__ChargentOrder__c>();
        
        try{
            paymentRecToUpdate = [SELECT id,Payment_Type__c, Finance_Account_Number__c,Finance_Account_Number__r.Finance_Account_Number__c, ChargentOrders__Payment_Status__c,
                                  Payment_Display_Status__c,Duplicate_Key_Tracker__c, Recordtype.Name FROM ChargentOrders__ChargentOrder__c
                                  WHERE id =: paymentRecId];
            
            paymentRecToUpdate.Payment_Display_Status__c = 'Cancelled';
            paymentRecToUpdate.ChargentOrders__Payment_Status__c = 'Complete';
            // US:3793 & 3794: while cancelling payment Duplicate_Key_Tracker__c flag is updated for recurring payment and payoff            
            If(paymentRecToUpdate.RecordType.Name == 'Recurring Payment'){
                paymentRecToUpdate.Duplicate_Key_Tracker__c =  paymentRecToUpdate.Finance_Account_Number__r.Finance_Account_Number__c + 'Recurring_Payment' + 'INACTIVE' + dateTime.now();            
            }
            else If(paymentRecToUpdate.RecordType.Name == 'Payoff Payment'){
                paymentRecToUpdate.Duplicate_Key_Tracker__c =  paymentRecToUpdate.Finance_Account_Number__r.Finance_Account_Number__c + 'Payoff_Payment' + 'INACTIVE' + dateTime.now();            
            }
            System.debug('payment to update'+paymentRecToUpdate);
            
            paymentRecToUpdateList.add(paymentRecToUpdate);
            if(paymentRecToUpdateList.size() > 0){
                update paymentRecToUpdateList;
            }
            
        }
        Catch(Exception ex){
            System.debug('Exception EX : '+ex.getMessage()+ ':' +ex.getLineNumber());
            UtilityClass.logError('AHFC_Payment updatePaymentAfterCancelEasyPay',ex.getMessage(),paymentRecId,'');
        }
        
        return paymentRecToUpdateList;
    }
    
/*@method       	:   getNumberOfPaymentsAlreadyCreated
* @description      :   This method will get the number of payments already available for a Finance Account. US : 3692
* @developer    	: 	Aswin Jose
* @date				:	12-Jul-2021
* @params			:	finAccId
*********************************************************************************/ 
    @AuraEnabled
    public static PaymentWrapper getNumberOfPaymentsAlreadyCreated(Id finAccId){
        List<ChargentOrders__ChargentOrder__c> paymentList = new List<ChargentOrders__ChargentOrder__c>();
        List<ChargentOrders__ChargentOrder__c> paymentListEZP = new List<ChargentOrders__ChargentOrder__c>();
        List<ChargentOrders__ChargentOrder__c> paymentListOTP = new List<ChargentOrders__ChargentOrder__c>();
        List<List<ChargentOrders__ChargentOrder__c>> paymentListToCheck = new List<List<ChargentOrders__ChargentOrder__c>>();
        
        PaymentWrapper payWrap = new PaymentWrapper();
        
        String paymentStatusPending =AHFC_GlobalConstans.paymentStatusPending;
        String paymentStatusProcessing = AHFC_GlobalConstans.paymentStatusProcessing;
        String stdOneTimePay = AHFC_GlobalConstans.stdOneTimePay;
        String principalOneTimePay = AHFC_GlobalConstans.principalOneTimePay;
        String reccuringPay = AHFC_GlobalConstans.reccuringPay;
        
        paymentList = [SELECT id,Payment_Display_Status__c,Duplicate_Key_Tracker__c,Payment_Type__c,Finance_Account_Number__c,RecordType.Name 
                       FROM ChargentOrders__ChargentOrder__c
                       WHERE Finance_Account_Number__c =: finAccId AND 
                       (Payment_Display_Status__c =:paymentStatusPending OR Payment_Display_Status__c =: paymentStatusProcessing)];
        System.debug('payment List : '+paymentList);
        
        for(ChargentOrders__ChargentOrder__c orderPayment : paymentList){
            if(orderPayment.RecordType.Name == stdOneTimePay || orderPayment.RecordType.Name == principalOneTimePay){
                paymentListOTP.add(orderPayment);
            }
            if(orderPayment.RecordType.Name == reccuringPay){
                paymentListEZP.add(orderPayment);
            }
        }
        
        paymentListToCheck.add(paymentListOTP);
        paymentListToCheck.add(paymentListEZP);
        
        if(paymentListOTP.size() >=6 && paymentListEZP.size() >=1){
         	payWrap.sixOtpAndEZPError = true;
            
        }else if(paymentListOTP.size() >=6){            
            payWrap.sixOtpError = true;
        }
        return payWrap;
    }
    
    /*@method       	:   getNumberOfPaymentsAlreadyCreated
    * @description      :   This method will get the number of payments already available for a Finance Account. US : 3692
    * @developer    	: 	Aswin Jose
    * @date				:	12-Jul-2021
    * @params			:	finAccId
    *********************************************************************************/ 
   
    //Wrapper Class to send the data to LWC
    public without sharing class PaymentWrapper{
        
        @AuraEnabled public Boolean sixOtpError = false;
        @AuraEnabled public Boolean sixOtpAndEZPError = false;
    }
    

    
}