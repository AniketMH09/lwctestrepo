/*******************************************************************************************************
    * @author  : Mariappan,Paramasivan Arunachalam
    * @date    : 
    * @Created : 18 AUG 2015
    * @group    :  
    * @group-content : 
    * @description : This class will send the Pending payment details and Bank account details for the USAN provided finance account number. 
    *                 It will also received the response from USAN and will create the One-Time payment record in salesforce.
    *                 
     
********************************************************************************************************/
    
    
global with sharing class WSPendingPaymentController{
 
    /* Start of Send pending payment wrapper classes and methods*/
    global class PendingPaymentsResponse{
        webservice String AccountNumber;
        webservice String IsAccount;
        webservice Boolean one_time_ivr_eligibility_fl;
        webservice Boolean one_time_future_date_ivr_eligibility;
        webservice Boolean bankruptcy_fl;
        webservice date max_future_date;
        webservice PendingPayments PendingPayments;
        webservice PaymentSources PaymentSources;
        webservice EasyPay EasyPay;
        webservice Double minPaymentAmt;
        webservice Double PayoffAmount;
    }
    
    global class PendingPayments{
        webservice list<PendingPayment> PendingPayment;
    }
    
    global class PaymentSources{
        webservice list<PaymentSource> PaymentSource;
    }
    
    global class PendingPayment{
        webservice String PaymentId;
        webservice String PaymentSourceId;
        webservice Decimal PaymentAmount;
        webservice Date PaymentEffectiveDate;
        webservice String PaymentStatus;
        webservice String IsPastCutoff;
    }
    
    global class PaymentSource{
        webservice String PaymentSourceId;
        webservice String PaymentSourceName;
        webservice String Last4AccNumber;
        webservice Boolean IsPreferred;
    }
    
    
    global  class EasyPay{
        webservice String isEnrolled;
        webservice Decimal AutoDebitAmount;
        webservice Date AutoDebitDate;
    }
    
    
    
    webService static PendingPaymentsResponse PendingPayments(String AccountNumber){
        List<PendingPayment> PendingPayments = new List<PendingPayment>();
        List<PaymentSource> PaymentSources = new List<PaymentSource>();
        PaymentSources  psource=new PaymentSources();
        PendingPayments pps=new PendingPayments();
        ChargentOrders__ChargentOrder__c recurringPayment;
        //Query modified (added Paid_to_Date__c) for Defect: 113950 - Veera
        List<Finance_Account__c> FinAcc = [select id,Finance_Account_Number__c,Next_Due_Date__c,Payoff_Amount__c,Scheduled_EasyPay_Amount__c,Fl_OneTime_Payment_Eligible_IVR__c,Payment_Due_Date__c,Paid_to_Date__c,Past_Amount_Due__c,Fl_Future_OneTime_Payment_Eligible_IVR__c,Fl_Bankrupt__c,(select id,Payment_Source_Nickname__c,Last_4__c,Preferred_Payment_Source__c from Bank_Accounts__r where Status__c='Active'),(select id,recordtype.developername,ChargentOrders__Next_Transaction_Date__c,Payment_Source_Nickname__c,ChargentOrders__Charge_Amount__c,Finance_Account_Number__c,ChargentOrders__Payment_Start_Date__c,Payment_Display_Status__c from Chargent_Orders__r where Payment_Display_Status__c in('Pending','Processing')) from Finance_Account__c where Finance_Account_Number__c=:AccountNumber];
        
        PendingPaymentsResponse ppr = new PendingPaymentsResponse(); 
        ppr.AccountNumber = '';
        ppr.IsAccount = '';
        ppr.one_time_ivr_eligibility_fl = true;
        ppr.IsAccount = '';
        ppr.one_time_future_date_ivr_eligibility = true;
        ppr.bankruptcy_fl = true;
        
        ppr.PendingPayments = new PendingPayments();
        ppr.PaymentSources = new PaymentSources();
        ppr.EasyPay = new EasyPay();
        ppr.minPaymentAmt = 0.0;
        ppr.PayoffAmount = 0.0;
        
        try{
         if( !FinAcc.isEmpty() ){
                    
            ppr.AccountNumber = FinAcc[0].Finance_Account_Number__c;
            ppr.IsAccount = 'true';
            ppr.one_time_ivr_eligibility_fl = FinAcc[0].Fl_OneTime_Payment_Eligible_IVR__c;
            ppr.one_time_future_date_ivr_eligibility = FinAcc[0].Fl_Future_OneTime_Payment_Eligible_IVR__c;
            ppr.bankruptcy_fl = FinAcc[0].Fl_Bankrupt__c;
            
            // Defect: 113950 - Modification to Add 10 days for the "Current" FA and "PastDue (EE Delinquency, 1-10 DPD)" FA - Start
            if(FinAcc[0].Payment_Due_Date__c != null && FinAcc[0].Past_Amount_Due__c == null && ppr.one_time_future_date_ivr_eligibility ) {
               
                // Adding 10 days to 'Payment_Due_Date__c' for the Defect: 113950 - Veera -- for FA with Current Amount.
                ppr.max_future_date = FinAcc[0].Payment_Due_Date__c; 
            
            } else if(FinAcc[0].Payment_Due_Date__c !=null && FinAcc[0].Past_Amount_Due__c != null && ppr.one_time_future_date_ivr_eligibility ) {

                // Adding 10 days to 'Paid_to_Date__c' for the Defect: 113950 - Veera -- for FA with Past Due Amount.
                ppr.max_future_date = FinAcc[0].Paid_to_Date__c; 
           
            }
            
            // Defect: 113950 - Modification to Add 10 days for the "Current" FA and "PastDue (EE Delinquency, 1-10 DPD)" FA - End
            if ( FinAcc[0].Payoff_Amount__c <> NULL )  {
                ppr.PayoffAmount = FinAcc[0].Payoff_Amount__c;
            }
            
            //For adding the maximum future date in the response.
            List<Max_Future_Date__c> mcs = Max_Future_Date__c.getall().values();
            if(mcs.size()>0){
                for(Max_Future_Date__c max:mcs){
                    if(FinAcc[0].Payment_Due_Date__c!=null && ppr.one_time_future_date_ivr_eligibility== true){
                        ppr.max_future_date = ppr.max_future_date+Integer.valueof(max.days_in_future_ivr__c);
                    }
                    else{
                        ppr.max_future_date = null;
                    }
                    break;
                }
            }
            
            //For adding the minimum charge value in the response.
            list<minimum_value__c> Minval = minimum_value__c.getall().values();
            if(Minval.size()>0){
                for(minimum_value__c min:Minval){
                    ppr.minPaymentAmt = min.minval__c;
                    break;
                }
            }
            
            for(ChargentOrders__ChargentOrder__c charord: FinAcc[0].Chargent_Orders__r){
                
                if(charord.recordtype.developername != 'Recurring_Payment'){
                    PendingPayment ppt = new PendingPayment();
                    ppt.PaymentId = charord.id;
                    ppt.PaymentSourceId = charord.Payment_Source_Nickname__c;
                    ppt.PaymentAmount = charord.ChargentOrders__Charge_Amount__c;
                    ppt.PaymentEffectiveDate = charord.ChargentOrders__Payment_Start_Date__c;
                    ppt.PaymentStatus = charord.Payment_Display_Status__c;
                    DateTime today = date.today();
                    Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();   
                    if(Datetime.now().date() < charord.ChargentOrders__Payment_Start_Date__c){
                        ppt.IsPastCutoff = 'false'; 
                          }
                    else if(Datetime.now().date() > charord.ChargentOrders__Payment_Start_Date__c){  
                        ppt.IsPastCutoff = 'true';
                          } 
                     else if(PaymentsUtils.isBeforeCutOffTime()){
                    /*  Above line Added by veera for Defect: 113981
                    Initially condition used in IF condition is (to check if current transaction is before or after the Cutoff_Time ):
                     Date.Today().isSameDay(Date.valueof(charord.ChargentOrders__Payment_Start_Date__c)) && Datetime.now().format('hh:mm:ss a') < hfc.CutOff_Time__c.format('hh:mm:ss a'
                     in place of PaymentsUtils.isBeforeCutOffTime()
                     */
                         ppt.IsPastCutoff = 'false';     
                    }
                    else{
                        ppt.IsPastCutoff = 'True';
                        }
                    
                    PendingPayments.add(ppt);
                }
                else
                {
                    recurringPayment = new ChargentOrders__ChargentOrder__c();
                    recurringPayment = charord;
                }
                System.debug('Recurring Payment'+recurringPayment);
            }
            pps.PendingPayment=PendingPayments;
            ppr.PendingPayments=pps;
            for(Payment_Source__c pso : FinAcc[0].Bank_Accounts__r){
                PaymentSource psow = new PaymentSource();
                psow.PaymentSourceId = pso.id;
                psow.PaymentSourceName = pso.Payment_Source_Nickname__c;
                psow.Last4AccNumber = pso.Last_4__c;
                psow.IsPreferred = pso.Preferred_Payment_Source__c;
                PaymentSources.add(psow);
            }
            psource.PaymentSource=PaymentSources;
            ppr.PaymentSources=psource;
            
            EasyPay easp=new EasyPay();
            if(recurringPayment != null){
                easp.isEnrolled = 'true';
                easp.AutoDebitAmount = recurringPayment.ChargentOrders__Charge_Amount__c;
                easp.AutoDebitDate =recurringPayment.ChargentOrders__Next_Transaction_Date__c;
            }
            else
            {
                easp.isEnrolled = 'false';
            }
            ppr.EasyPay=easp;
            system.debug('@@@@@@@@@@@@@@@@@@in'+ppr);
        }
        
        else{
            ppr.AccountNumber = '';
            ppr.IsAccount = 'false';
            ppr.one_time_ivr_eligibility_fl = false;
            ppr.one_time_future_date_ivr_eligibility = false;
            ppr.minPaymentAmt = 0.00;
            ppr.bankruptcy_fl = false;
            pps.PendingPayment=PendingPayments;
            ppr.PendingPayments = pps;
            psource.PaymentSource=PaymentSources;
            ppr.PaymentSources =psource;
            ppr.EasyPay = new EasyPay();
        }
        system.debug('@@@@@@@@@@@@@@@@@@out'+ppr);
        return ppr;
        }
        catch (Exception e) {
          UtilityClass.logErrorResp('INT 20 and 23', 'WSPendingPaymentController', e.getMessage() , ppr.AccountNumber,  e.getStackTraceString()   );
          return null;
      }  
    }
    /* End of Send pending payment wrapper classes and methods*/
    
    /* Start of making One time Payment wrapper classes and methods*/
    
    
    
    global class Payment {
        
        webservice String PaymentId;
        webservice String accountNumber;
        webservice String paymentSourceId;
        webservice String paymentAmount;
        webservice String paymentEffectiveDate;
        webservice String status;
        
    }
    
    global class PaymentResponse {
        
        webservice String PaymentId;
        webservice String accountNumber;
        webservice String paymentSourceId;
        webservice String paymentAmount;
        webservice String paymentEffectiveDate;
        webservice string ConfirmationNbr;
        webservice String status;
        webservice Integer code;
        webservice String message;
        
    }
    /**
*  Description of the purpose of the class the method. 
*  @name oneTimePayment 
*  This method will receive the request from USAN and will create the One time Payment record in salesforce.
It will send the response to USAN based on the operation result.
*/
    webService static PaymentResponse oneTimePayment(Payment payment) {
        String gatewayName = Label.GatewayName;
        String accountNumber = payment.accountNumber;
        Boolean flag = false;
        ChargentOrders__ChargentOrder__c currOrder;
        List<Finance_Account__c> financeAccountList ;
        
        
        // Set of Finance Account Number
        RecordType rt = [select Id,Name from RecordType where SobjectType = 'ChargentOrders__ChargentOrder__c' and Name = 'Standard One-Time Payment' Limit 1];
        
        if(accountNumber != null)
        {
            financeAccountList = [SELECT id,Finance_Account_Number__c,(select id,recordtype.developername,Payment_Source_Nickname__c,ChargentOrders__Charge_Amount__c,Finance_Account_Number__c,ChargentOrders__Payment_Start_Date__c,Payment_Display_Status__c from Chargent_Orders__r where recordTypeId =: rt.id and Payment_Display_Status__c='Pending') from Finance_Account__c where Finance_Account_Number__c =:accountNumber ];
        }
        // Chargent order is queried to check whether USAN is trying to update the processed order record
        if(payment.PaymentId!='' && payment.PaymentId!=null)
        {
        // Query has been modified with querying RecordTypeID for Defect 113981 -- Veera
        // Query has been modified with querying RecordType.developername,Finance Account Number for Defect 114165 by Jayashree
        currOrder = [SELECT id,RecordTypeID,Recordtype.developername,Finance_Account_Number__r.Finance_Account_Number__c,Payment_Display_Status__c from ChargentOrders__ChargentOrder__c where id =: payment.PaymentId Limit 1];
        }
        list<ChargentBase__Gateway__c> gateWay = [SELECT id from ChargentBase__Gateway__c where Name =: gatewayName  and ChargentBase__Active__c = true limit 1];
        PaymentResponse paymentResponse=new PaymentResponse();
        if(financeAccountList != null )
        {
            /*Fix - 113052. Cancellation requests can bypass the validation on the number of existing payments on the account */
            if((payment.status =='CREATE' && financeAccountList[0].Chargent_Orders__r.size()<6) || payment.status =='CANCEL') 
            {
                
                ChargentOrders__ChargentOrder__c order = new ChargentOrders__ChargentOrder__c();
                if(payment.PaymentId!='' && payment.PaymentId!=null){
                    order.id = payment.PaymentId;
                }
                
                order.Finance_Account_Number__c =financeAccountList[0].id;
                
                if(gateWay.size()>0){
                    order.ChargentOrders__Gateway__c = gateWay[0].id;
                }
                
                Payment_Source__c  BankAcc ;
                
                if(payment.paymentSourceId!='' && payment.paymentSourceId!=null){ 
                    order.Payment_Source_Nickname__c = payment.paymentSourceId;
                   BankAcc = [Select id, ChargentOrders_Tokenization__c from Payment_Source__c  Where Id = : payment.paymentSourceId];
                }
                
                if(payment.paymentAmount != null)
                {
                    order.ChargentOrders__Charge_Amount__c = Decimal.valueof(payment.paymentAmount);
                }
                if(payment.paymentEffectiveDate!=null && payment.paymentEffectiveDate!=''){
                    string dates=payment.paymentEffectiveDate;
                    if(dates.length()==8){
                        
                        string month = dates.substring(0, 2);
                        string day = dates.substring(2, 4);
                        string year = dates.substring(4, 8);
                        date paydate = date.valueOf(year + '-' + month + '-' + day);
                        order.ChargentOrders__Payment_Start_Date__c = paydate;
                    }
                }
                
               
                
                 
                if(payment.status =='CREATE')
                {
                    order.Payment_Display_Status__c = 'Pending';
                    // 114159 - Prakash start 
                    order.Payment_Type__c = 'R';
                    order.Payment_Channel__c = 'I';
                    order.ChargentOrders__Payment_Status__c = 'Recurring';
                    order.ChargentOrders__Payment_Method__c = 'Check';
                    order.ChargentOrders__Manual_Charge__c = true;
                    order.ChargentOrders__Payment_Frequency__c = 'Once';
                    order.ChargentOrders__Tokenization__c= BankAcc.ChargentOrders_Tokenization__c;
                    // 114159 - Prakash end 
                
                }
                else if(payment.status =='CANCEL')
                {
                    // #Defect ID: 112508 - Added currOrder logic 
                    if(currOrder != null && currOrder.Payment_Display_Status__c == 'Pending'){
                       order.Payment_Display_Status__c = 'Cancelled';
                       order.ChargentOrders__Payment_Status__c = 'Complete';
                       
                       //Below Changes added to the defect 114165 by Jayashree
                       if(currOrder.RecordType.developerName == 'Payoff_Payment') {
                        order.Duplicate_Key_Tracker__c = currOrder.Finance_Account_Number__r.Finance_Account_Number__c + 'Payoff_Payment' + 'INACTIVE' + dateTime.now();       
                       }
                       //End of defect 114165
                    }   
                }
                
                /* Start: Defect: 113981 - - Assigning the correct Record type for Cancelling - veera */
                if(currOrder != null) {
                    order.RecordTypeID = currOrder.RecordTypeID;
                }  
                /* End: Defect: 113981 - - Assigning the correct Record type for Cancelling - veera */
                
                
                /* Fix - 112509.If order.id is not set then 'flag' for error response should be set */
                if((payment.status == 'CANCEL' && (payment.PaymentId=='' || payment.PaymentId==null || order.Payment_Display_Status__c == null )) || ( payment.status =='CREATE' &&(order.ChargentOrders__Payment_Start_Date__c == null || order.Payment_Source_Nickname__c == null || order.Payment_Display_Status__c == null  || order.ChargentOrders__Charge_Amount__c == null )))
                {
                    flag = true;
                }
                else
                {
                    paymentResponse.PaymentId = payment.PaymentId;
                    paymentResponse.accountNumber = payment.accountNumber;
                    paymentResponse.paymentSourceId = payment.paymentSourceId;
                    paymentResponse.paymentAmount = payment.paymentAmount;
                    paymentResponse.paymentEffectiveDate = payment.paymentEffectiveDate;
                    paymentResponse.status = payment.status;
                    
                    
                    
                    Database.UpsertResult upsertResult;
                    System.Debug('upsertResult==> ' + upsertResult);
                    try{
                        upsertResult = Database.upsert(order,ChargentOrders__ChargentOrder__c.fields.id,false) ;
                        
                        
                    }Catch(DMLException e){
                        System.Debug('DMLException ==> ' + e);
                    }
                    
                    
                    if(!upsertResult.isSuccess())
                    {    
                        paymentResponse.code = 121;
                        Database.Error[] errors=upsertResult.getErrors();
                        String errorMessage = '';
                        For(Database.Error error:errors)
                        {
                            if(error.getMessage()!= null){
                                errorMessage+= error.getMessage();
                            }
                        }
                        paymentResponse.message = errorMessage;
                    }
                    else
                    {    
                        
                        paymentResponse.PaymentId = upsertResult.getId();
                        if(upsertResult.getId()!=null){
                            paymentResponse.ConfirmationNbr=[select Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id=:upsertResult.getId()].Confirmation_Number__c;
                            system.debug(''+paymentResponse.ConfirmationNbr+paymentResponse.PaymentId);
                        }
                        paymentResponse.code = 111;
                        paymentResponse.message = 'SUCCESS';
                    }
                }
            }
            else { flag = true; }
        }
        else { flag = true; }
        
        if(flag)
        {
            //This else block is mainly for restricting the USAN System to make the One-Time Payment,if Finance account is already having six One-Time Payment. 
            
            paymentResponse.PaymentId = payment.PaymentId;
            paymentResponse.accountNumber = payment.accountNumber;
            paymentResponse.paymentSourceId = payment.paymentSourceId;
            paymentResponse.paymentAmount = payment.paymentAmount;
            paymentResponse.paymentEffectiveDate = payment.paymentEffectiveDate;
            paymentResponse.status = payment.status;
            paymentResponse.code = 121;
            paymentResponse.message = 'ERROR';
        }
        
        return paymentResponse;
        
    }
    /* End of making One time Payment wrapper classes and methods*/
    
}