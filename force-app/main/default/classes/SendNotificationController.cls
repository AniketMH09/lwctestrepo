/*******************************************************************************************************
    * @author  : ACCENTURE
    * @date    : 
    * @modified : 15 APR 2016 , 02 MAY 2016 - DEFECT 114076 BY VEERA
    * @group    :  
    * @group-content : 
    * @description : INTEGRATION 30, PURPOSE : PROVIDING DETAILS TO B2C ACCOUNT OVERVIEW PAGE.
********************************************************************************************************/
     
@RestResource(urlMapping='/SendNotification/*')
global with sharing class SendNotificationController {
    
    //Response 
    global class Result{
        global EasyPay EasyPay;
        global OneTimePayment OneTimePayment;
        global Boolean isAccount = false;
        global String accountNumber;
        global String emailBounceBack = Label.BOUNCEBACK_NO;
        global String smsBounceBack = Label.BOUNCEBACK_NO;
        global Boolean isComPrefSet = false;
        global Decimal paymentsRemaining = 0.0;
    }
    
    global class PendingPayments{
        global Response PendingPaymentsResponse;
    }
    
    global class Response{
        global Result result;
        global String code;
        global String message;
    }        
    
    global class EasyPay {
        global Boolean enrolled = False;
        global String DisplayStatus = '';
        global String paymentID;
        global String nextPaymentDate = '';
        global Decimal paymentAmount = 0.0;
        //BELOW DECLARATION ADDED TO THE DEFECT 114295 BY JAYASHREE
        global String LastWithdrawalDate = '';
    }
    
    global Class OneTimePayment {
        
        global Integer pendingOneTimePayments;
        global String nextPaymentDate;
        global Decimal paymentAmount = 0.0;
    }
       
    @HttpGet
    global static PendingPayments doPost(){
      
      String financeAccountNumber = NULL;
      
      try{
        
        Result res = new Result();
        PendingPayments pendingpay = new PendingPayments();
        Response resp = new Response();
        String[] uriKeys = RestContext.request.requestURI.split('/');
        integer finnumber=uriKeys.size()-1;
        
        /*************************************************************************************************************************************************
        Binding the Parent Node 
        **************************************************************************************************************************************************/
        
        String facc = uriKeys[finnumber];
        financeAccountNumber = facc;
        Finance_Account__c finAccObject = new Finance_Account__c();
        list<Finance_Account__c> finList = [SELECT Id,Remaining_Amount_Due__c FROM Finance_Account__c WHERE Finance_Account_Number__c = :facc limit 1];
        if(finList.size()>0)
            finAccObject = finList[0];
        if(finAccObject.id != null)
        {
            res.isAccount = true;
            res.accountNumber = uriKeys[finnumber];
            
                List<Communication_Preferences__c> comPrefList = [Select id,Email_Address__c,Text_Number__c,Email_BounceBack_Count__c,IsEmailBounced__c,SMS_Bounce_Back_Count__c,Is_SMS_Bounced_Back__c,Unsubscribe_from_all__c, Is_Comm_Pref_Set__c from Communication_Preferences__c where ((Finance_Account_Number__c =: finAccObject.id) and (Email_Address__c != null or Text_Number__c != null)) ];
            if(comPrefList.size() > 0)
            {
                Communication_Preferences__c pref = comPrefList[0];
                System.debug('Comm Pref - ' + ' pref.Is_Comm_Pref_Set__c - ' + pref.Is_Comm_Pref_Set__c + 'pref.IsEmailBounced__c - ' + pref.IsEmailBounced__c + ' pref.Email_BounceBack_Count__c - ' + pref.Email_BounceBack_Count__c + ' pref.Is_SMS_Bounced_Back__c - ' + pref.Is_SMS_Bounced_Back__c + ' pref.SMS_Bounce_Back_Count__c - ' + pref.SMS_Bounce_Back_Count__c);
                if(pref.Is_Comm_Pref_Set__c)
                {
                    res.isComPrefSet = true;
                }
                
                if(pref.IsEmailBounced__c && pref.Email_BounceBack_Count__c < 3){
                    res.emailBounceBack = Label.BOUNCEBACK_YES;
                }
                else if(pref.IsEmailBounced__c && pref.Email_BounceBack_Count__c >= 3) {
                    res.emailBounceBack = Label.BOUNCEBACK_UNSUBSC;
                }
                
                if(pref.Is_SMS_Bounced_Back__c && (pref.SMS_Bounce_Back_Count__c > 0 && pref.SMS_Bounce_Back_Count__c < 3)){
                    
                    res.smsBounceBack = Label.BOUNCEBACK_YES;
                }
                else if(pref.Is_SMS_Bounced_Back__c && pref.SMS_Bounce_Back_Count__c >= 3) {
                    res.smsBounceBack = Label.BOUNCEBACK_UNSUBSC;
                }
                else if(pref.SMS_Bounce_Back_Count__c == 0) {
                    res.smsBounceBack = Label.BOUNCEBACK_NO;
                }
                    
            }
            
            
            /*************************************************************************************************************************************************
                SCENARIO : ONETIMEPAYMENT (OTP) DETAILS 
            ***************************************************************************************************************************************************/            
           /*Changes for Security Vulnrabilities at line 114 by Gufran 4/22/2020*/
           List<AggregateResult> result = [select count(Finance_Account_Number__c)cnt from ChargentOrders__ChargentOrder__c where Finance_Account_Number__c = :finAccObject.id and Payment_Display_Status__c = 'Pending']; 
            Integer count = (Integer) result[0].get('cnt'); 
            // Integer count = database.Query('select count(Finance_Account_Number__c) from ChargentOrders__ChargentOrder__c where Finance_Account_Number__c =  \'' + finAccObject.id + '\' and Payment_Display_Status__c = \'Pending\'').size();
            List<ChargentOrders__ChargentOrder__c> corders = new List<ChargentOrders__ChargentOrder__c>();
            // Query has been modified for defect 113981
            corders = [select id,ChargentOrders__Charge_Amount__c,ChargentOrders__Payment_Start_Date__c,Finance_Account_Number__r.Remaining_Amount_Due__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__c = :finAccObject.id and recordtype.developername != 'Recurring_Payment' and Payment_Display_Status__c in('Pending','Processing') order by ChargentOrders__Payment_Start_Date__c asc];
            OneTimePayment OneTP=new OneTimePayment();
            OneTP.pendingOneTimePayments = corders.size();
            
            if(corders.size()>0){
                OneTP.paymentAmount = corders[0].ChargentOrders__Charge_Amount__c;
              
                if ( corders[0].ChargentOrders__Payment_Start_Date__c <> NULL ) { 
                       
                    OneTP.nextPaymentDate =  dateFormat( corders[0].ChargentOrders__Payment_Start_Date__c ) ;
                }
    
                res.paymentsRemaining = finList[0].Remaining_Amount_Due__c;
            }
            res.OneTimePayment = OneTP;
            
            
            /*************************************************************************************************************************************************
                SCENARIO : EASY PAY DETAILS 
            ***************************************************************************************************************************************************/

            // UPDATED 02 MAY 2016 DEFECT 114076 BY VEERA - STARTS 
            // Set<String> EasyPayNAStatus = New Set<String> {'Pending','Stopped','Suspended','Complete','Cancelled'};
            Set<String> EasyPayNAStatus = New Set<String> {'Pending','Suspended'};
            //QUERY EASYPAY PAYMENTS
            List<ChargentOrders__ChargentOrder__c> cordersEasypay = new List<ChargentOrders__ChargentOrder__c>();
                cordersEasypay = [SELECT id, Payment_Display_Status__c, ChargentOrders__Charge_Amount__c, ChargentOrders__Next_Transaction_Date__c, 
                                         Next_Withdrawal_Date__c , Last_Extraction_Date__c
                                    FROM ChargentOrders__ChargentOrder__c  
                                    WHERE Finance_Account_Number__c = :finAccObject.id AND recordtype.name = 'Recurring Payment' 
                                          AND Payment_Display_Status__c in('Pending','Suspended') ];
              
                ChargentOrders__ChargentOrder__c EasyPayRecord = New ChargentOrders__ChargentOrder__c ();

            // IF THERE IS NO PENDING PAYMENT TAKE THE LATEST PAYMENT START DATE RECORD
                    // INITIATE EASYPAY WRAPPER CLASS 
                EasyPay easyPay = new EasyPay();
                
                
                            
                    // EASYPAY WRAPPER CLASS DETAILS MAPPING - STARTS
                    if ( !cordersEasypay.isEmpty()  ) {
                        
                        EasyPayRecord = cordersEasypay[0]  ;
                        
                        // 1. MAP PAYMENT ID
                        easyPay.PaymentID = EasyPayRecord.Id ;
                        
                        // 2. MAP ENROLLED
                        easyPay.enrolled  = False ;
                        // IF THE STATUS IS PENDING OR SUSPENDED THEN ENROLLED SHOULD BE TRUE
                        if ( EasyPayRecord.Payment_Display_Status__c ==   'Pending' || EasyPayRecord.Payment_Display_Status__c == 'Suspended'   ) {
                            easyPay.enrolled = True;
                        }
                        
                        
                        // 3. MAP PAYMENT AMOUNT
                        if ( EasyPayRecord.ChargentOrders__Charge_Amount__c <> NULL ) {
                            easyPay.paymentAmount = EasyPayRecord.ChargentOrders__Charge_Amount__c;
                        }
                    
                        // 4. MAP DISPLAY STATUS
                        easyPay.DisplayStatus = EasyPayRecord.Payment_Display_Status__c ;
                        // IF THE STATUS IS PENDING - SET STATUS TO ACTIVE
                        if ( EasyPayRecord.Payment_Display_Status__c ==   'Pending' ) {
                            easyPay.DisplayStatus = 'Active';
                        }
                            
                        // 5. MAP NEXT PAYMENT DATE
                        // FORMAT THE NEXT WITHDRAWAL DATE
                        //Added to check the length of the month and day   
                        if ( EasyPayRecord.Next_Withdrawal_Date__c <> NULL ) { 
                            easyPay.nextPaymentDate =  dateFormat( EasyPayRecord.Next_Withdrawal_Date__c );
                        }
                        //6. MAP THE Last_Extraction_Date__c FIELD TO LastWithdrawalDate AS PART OF PHOENIX
                        if ( EasyPayRecord.Last_Extraction_Date__c <> NULL ) { 
                            
                            DateTime dT = EasyPayRecord.Last_Extraction_Date__c;
                            Date LstExtDate =  date.newinstance(dT.year(),dT.month(),dT.day());
                            easyPay.LastWithdrawalDate =  dateFormat(LstExtDate);
                            
                        }
    
                    } // EASYPAY WRAPPER CLASS DETAILS MAPPING -ENDS
 
                // MAP THE RESULT, CODE AND MESSAGE     
                res.EasyPay = easyPay ;
                resp.result = res;
                resp.code = Label.WS_RESP_CODE_SUCCESS;
                resp.message = Label.WS_RESP_MSG_SUCCESS;
                pendingpay.PendingPaymentsResponse = resp;
            return pendingpay;
        } 
        else {
             // REQUEST IS RECIEVED WITH OUT FINANCE ACCOUNT ID. SEND FAILURE REPSONSE 
            resp.result = null;
            resp.code = Label.WS_RESP_CODE_FAILURE;
            resp.message = Label.WS_RESP_MSG_INVALID_FA;
            pendingpay.PendingPaymentsResponse = resp;
            return pendingpay;
        }
        
      } catch (Exception e) {
          
          UtilityClass.logErrorResp('INT 30', 'SendNotificationController', e.getMessage() , financeAccountNumber,  e.getStackTraceString()   );
          return null;
      }  
        
        // UPDATED 02 MAY 2016 DEFECT 114076 BY VEERA - ENDS
    }
    
    Public Static String dateFormat (Date inpDate ){
        
        try {    
            if ( inpDate <> NULL ) {
                
                String day  = String.valueOf( inpDate.day() );
                       day  = (String.isNotBlank(day) && day.length() == 1)?'0' + day:day ;
                       
                String month = String.valueOf( inpDate.month() );
                       month = (String.isNotBlank(month) && month.length() == 1)?'0' + month:month ;
                
                String year  = String.valueOf(inpDate.year());
                String fomattedDate = month + day + year ;
                return fomattedDate ;
             } else {
                 return '';
                }
        } Catch ( Exception e ) {
                        return '';
                }
    }
    
    
      /*******************************************************************************************************
    * @description : FORMAT DATE IN MMDDYYYY FORMAT - ADDED TO DEFECT 114295 BY JAYASHREE 
    * @param : STRING DATE  
    * @return : RETURNS DATE
    * @example 
    *  
    *******************************************************************************************************/
       Public Static String setStringToDateFormat(String myDate) {
            
            String lastWithdrawDate = '' ;
            
            try {       
                
                if ( String.isNotBlank(myDate)  ) {
                
                    String[] SplitDate = myDate.split('/') ;
                    String Day = '' ;
                    String Month = '' ;
                    
                    
                    if ( SplitDate <> NULL && SplitDate.size() > 2 ) {   
                       
                        Month = (SplitDate[0].length() < 2) ? '0'+SplitDate[0] : SplitDate[0] ;
                        Day   = (SplitDate[1].length() < 2) ?' 0'+SplitDate[1] : SplitDate[1] ;
                        lastWithdrawDate =   Month  + Day + SplitDate[2] ;
                    }
                }
                
                
            } Catch(Exception e){
                UtilityClass.logErrorResp('INT 30 : Send Notification Controller' , e.getmessage(), NUll , myDate , e.getStackTraceString() );             
            }  
            
            return lastWithdrawDate ;  
       }

}