/*******************************************************************************************************
    * @author  : iConnect Dev Team
    * @date    : 
    * @Created : 28 SEP 2016
    * @group    :  
    * @group-content : 
    * @description : The purpose of this controller is for the new payment tokenization service in Salesforce. 
                     This Tokenization SOAP callout is responsible for sending the bank account number to Cybersource
                     for tokenization upon customer or agent’s request initiated to save a new bank account in the system
                     Instead of calling via Chargent.
********************************************************************************************************/
    
public class PymtTokenizationService{
  
    //GLOBAL VARIABLE DECLARATIONS 
    
    Private static boolean validationError = false;
    Private static boolean doNotCall = false;
    Private static boolean isErrorLogged = false;
    public static String finNumber = '';
    public static String FinalsubscriptionId; 
        
    /*******************************************************************************************************
                                        WRAPPER CLASS : Result
    *******************************************************************************************************/
    Public class PTSResult{
        public String pId;
        public String token;
        public boolean success;
        public String msg;

        public PTSResult(boolean s, String msg){
            success = s;
            this.msg = msg;
        }

        public PTSResult(String i, String t){
            pid = i;
            token = t;
            success = True;
        }
    }
    /*******************************************************************************************************
    * @description : addToError Method 
    * @param : PAYMENT SOURCE RECORD   
    * @return : RETURNS RESULT WRAPPER CLASS
    * @example 
    *  
    *******************************************************************************************************/
        private static String addToError(String err, String msg){
        validationError = true;
        err = err + msg + '\r\n';
        return err;
    }


    /*******************************************************************************************************
    * @description : VALIDATE PAYMENT SOURCE RECORD GIVEN INPUT DATAS 
    * @param : PAYMENT SOURCE RECORD   
    * @return : RETURNS RESULT WRAPPER CLASS
    * @example 
    *  
    *******************************************************************************************************/
    
    Private static PTSResult validateData(Payment_Source__c ps){
        
        try {
        
            // COMMON MESSAGE FIRST LINE
            String msg = 'The following required data was missing:\r\n\r\n';

            // BANK ACCOUNT NUMBER  
            if(String.isBlank(ps.Bank_Account_Number__c)){
                msg = addToError(msg,'Bank Account Number');
            }
    
            // BANK NAME 
            if(String.isBlank(ps.Bank_Name__c )){
                msg = addToError(msg,'Bank Account Name');
            }
            
            // ROUTING NUMBER
            if(String.isBlank(ps.Bank_Routing_Number__c )){
                msg = addToError(msg,'Bank Routing number');
            }
            
            // BILLING STREET
            if(String.isBlank(ps.Billing_Street__c )){
                msg = addToError(msg,'Billing Address');
            }
            
            // BILLING CITY
            if(String.isBlank(ps.Billing_City__c )){
                msg = addToError(msg,'Billing City');
            }
            
            // BILLING STATE
            if(String.isBlank(ps.Billing_State__c)){
                msg = addToError(msg,'Billing State');
            }
            
            // BILLING ZIP CODE
            if(String.isBlank(ps.Billing_Zip__c)){
                msg = addToError(msg,'Billing Zip');
            }
            
            // BILLING COUNTRY
            if(String.isBlank(ps.Billing_Country__c)){
                msg = addToError(msg,'Billing Country');
            }
            
            // BILLING EMAIL
            if(String.isBlank(ps.Billing_Email__c)){
                msg = addToError(msg,'Billing Email');
            }
              
     
            // FINANCE ACCOUNT
            if(ps.Finance_Account_Number__c == null){
                msg = addToError(msg,'Finance Account');
            }
             
            // CURRENCY
            if(ps.Currency__c == null){
                msg = addToError(msg,'Currency');
            }
            
            if(validationError){
                return new PTSResult(false, msg);
            }else{
                return null;
            }
        
        } catch(Exception e){
            // LOG EXCEPTION IN ERROR LOG OBJECT
             UtilityClass.logErrorResp('PymtTokenizationService', 'Failed in validation before tokenization', ps.CyBs_Customer_Id__c, '', 'Failed in validation before tokenization');
             return null;
        }

    }


    /*******************************************************************************************************
    * @description : WRAPPER CLASS 
    * @param : FIRST NAME AND LAST NAME
    * @return : RETURNS FIRST NAME AND LAST NAME
    * @example 
    *  
    *******************************************************************************************************/
    
    Public Class Name {
        Public String FirstName ;
        Public String LastName ;
        
        Public Name(String FName, String LName){
            FirstName = FName ; LastName = LName ;
        }
    }

    
    /*******************************************************************************************************
    * @description : SET FIRSTNAME,LASTNAME OF GIVEN INPUT DATAS 
    * @param : CUSTOMER NAME    
    * @return : 
    * @example 
    *  
    *******************************************************************************************************/
   //Changes added to the defect #113842 by Jayashree 
   
    Public Static Name SplitFullNAME (String FullName) {
        
        if ( String.isBlank(FullName) ){
           
            return null;
            
        } else {
        
            String FName, LName = NULL;
            
            //REMOVE ANY SPECIAL CHARS
            FullName = FullName.replaceall('[^a-zA-Z0-9\\s]','');
             
            FullName  = FullName.trim();
            
            // SPLIT THE FIRST NAME AND LAST NAME WHEN THERE IS WHITE SPACE IN FULL NAME
            if ( FullName.Contains(' ') ) {
                 
                 FName = FullName.substringBefore(' ');
                 LName = FullName.substringAfter(' ');
                 
            } else {
                // WHEN NO WHITE SPACE IN FULL NAME ASSIGN FIRST NAME AND LAST NAME
                FName = FullName ;
                LName = FullName ;
            }
            
            return (New Name(FName,LName));
        }       
    }
    
    
    

/*******************************************************************************************************
    * @description : METHOD: Create Payment Source
    * @param       : BankNAME
    * @return      : RETURNS TOKEN
    * @example 
    *  
    *******************************************************************************************************/
        Public  static PTSResult createPS(Payment_Source__c ps){
        PTSResult res = NULL; 
            system.debug('PaymentSourceInputValues-->'+ps);
        try{
        
            res = validateData(ps);
            system.debug('validateData-->'+res);
            if(res != null)
            {
                return res;                
            }
            // INITIALIZE THE WEBSERVICE INSTANCE
             // MAP THE FIELD VALUES 
             // SPLIT THE FULL NAME TO FIRST NAME & LAST NAME
             system.debug('NextStepvalidateData-->'+res);
            if( ps.Finance_Account_Number__c <> NULL ) {
                system.debug('EnteringFinAcc-->');
            Finance_Account__c[] finAcc = [SELECT Finance_Account_Number__c,Customer_Name__c  
                                                  FROM Finance_Account__c 
                                                  WHERE id = :ps.Finance_Account_Number__c];
                                                  system.debug('PSFin-->'+ps.Finance_Account_Number__c);
                                                  //system.debug('FinCustomerName-->'+finAcc.Customer_Name__c);
                
            if ( finAcc!= null && !finAcc.isEmpty() ) {
            finNumber = finAcc[0].Finance_Account_Number__c;
                system.debug('finNumber---------------->'+finNumber);
            Integer custIdNbr = integer.valueOf(finNumber);
            ps.CyBs_Customer_Id__c = String.valueOf(custIdNbr);
             if ( String.isBlank(finAcc[0].Customer_Name__c) ) {
                        
                        // LOG EXCEPTION IN ERROR LOG OBJECT
                         UtilityClass.logErrorResp('PymtTokenizationService', 'Customer Name is Blank in Finance Account', ps.CyBs_Customer_Id__c, '', 'Customer Name is Blank in Finance Account');
             
                         return New PTSResult(false,'Error');
                        
                    } else {
                         Name name = SplitFullNAME(finAcc[0].Customer_Name__c) ;
                         ps.Billing_First_Name__c = name.FirstName;
                         ps.Billing_Last_Name__c  = name.LastName;
                    }
            } else {
                
                    return  New PTSResult(false,'Error'); 
                }                                                  
           }
            system.debug('afterPTS');
            system.debug('PSSS-->'+ps);
           
         String oPaymentResult = PymtTokenizationService.TokenizationRequest(ps);
             system.debug('PaymentResult-->'+oPaymentResult);
            // VERIFY THE TOKEN 
            //Changes added to the defect 114228 by Jayashree    
            if( oPaymentResult == NULL || String.isBlank(oPaymentResult) ){
                
                res = New PTSResult(false,oPaymentResult);  
            }else {
                // IF TOKEN IS RECIVED ASSIGN THE TOKEN 
                
                ps.Bank_Account_Number__c = null;
                ps.Bank_Routing_Number__c = null;
                ps.ChargentOrders_Tokenization__c = oPaymentResult;
                
                System.debug('ps ==> '+ps);
                
                //CREATE BANK ACCOUNT RECORD 
                insert ps;
                
                res = New PTSResult(ps.id,ps.ChargentOrders_Tokenization__c);
            }
            
        }
        catch (CyBsCalloutException ex) {
                res = New PTSResult(false,'Error') ;
            }
        catch(Exception e){
             UtilityClass.logErrorResp('PymtTokenizationService', e.getMessage(), ps.CyBs_Customer_Id__c, '', e.getStackTraceString().left(32000));
             res = New PTSResult(false,'Error') ;
        }
        return res;

    }

 
    /*******************************************************************************************************
    * @description : METHOD: TokenizationRequest 
    * @param       : Payment Source
    * @return      : RETURNS Subscription ID
    * @example 
    *  
    *******************************************************************************************************/
        Public Static String TokenizationRequest(Payment_Source__c ps) {
            system.debug('EnteringToken');
            String Token; 
            integer timeoutValue;
            CyberSourceTransactionData.ReplyMessage xmlResponse;
            system.debug('xmlResponse'+xmlResponse);
            CyberSourceTokenization__c CSToken = CyberSourceTokenization__c.getOrgDefaults();
            CyberSourceTransactionData.RequestMessage CSTRequest = new CyberSourceTransactionData.RequestMessage();
            CyberSourceTransactionData.portXML instance = new CyberSourceTransactionData.portXML ();
                //Tokenization Timeout Value
                try {
                    timeoutValue = integer.valueOf((CSToken.Tokenization_TimeOut_Value__c)*1000);
                    if(timeoutValue != null && timeoutValue != 0.0) {
                    instance.timeout_x = timeoutValue;
                }
                }
                catch (Exception e) {
                    system.debug('Error while reading timeout from custom setting');
                }
                
                String merchantID;
                String merchantReferenceCode;
                String clientEnvironment;
                String clientSecurityLibraryVersion;
                String clientApplication;
                String clientApplicationUser;
                String clientApplicationVersion;
                String customerID;
                
                String envName = UtilityClass.getEnvName();
                merchantID = '{!$Credential.UserName}';
                merchantReferenceCode = envName;
                
                clientEnvironment = (envName == 'Prod')?'Production':'Sandbox'; 
                
                // Set the clientApplication and clientApplicationUser
                if(Userinfo.getUserType().equalsIgnoreCase('Standard')) {
                    clientApplication = 'Console';   
                } else {
                    clientApplication = 'Community';  
                }
                clientApplicationUser = Userinfo.getUserName();
                
                // Sets the finance account number (after removing leading zeros)
                customerID = ps.CyBs_Customer_Id__c;             
         
                CyberSourceTransactionData.BillTo billTo = new CyberSourceTransactionData.BillTo();
                billTo.firstName = ps.Billing_First_Name__c;
                billTo.lastName = ps.Billing_Last_Name__c;
                billTo.street1 = CSToken.street1__c;
                billTo.city = CSToken.city__c;
                billTo.state = CSToken.state__c;
                billTo.postalCode = CSToken.postalCode__c;
                billTo.country = CSToken.country__c;
                billTo.phoneNumber = CSToken.phoneNumber__c;
                billTo.email = CSToken.email__c;
                 
            system.debug('BforeCyberSourceTransactionData');
                    
                CyberSourceTransactionData.PurchaseTotals purchaseTotals = new CyberSourceTransactionData.PurchaseTotals();
                purchaseTotals.currency_x = CSToken.currency__c;
                 
                CyberSourceTransactionData.Check check = new CyberSourceTransactionData.Check();
                check.accountNumber = ps.Bank_Account_Number__c;
                    if(ps.Bank_Account_Type__c == 'Checking')
                    {
                         check.accountType = 'C';
                    }
                    else if(ps.Bank_Account_Type__c == 'Savings')
                    {
                         check.accountType = 'S';
                    }                    
                    check.bankTransitNumber = ps.Bank_Routing_Number__c;                   
                
                
                CyberSourceTransactionData.Subscription subscription = new CyberSourceTransactionData.Subscription();
                subscription.paymentMethod = CSToken.paymentMethod__c;
                
                CyberSourceTransactionData.RecurringSubscriptionInfo recurringSubscriptionInfo = new CyberSourceTransactionData.RecurringSubscriptionInfo();
                recurringSubscriptionInfo.frequency = CSToken.frequency__c;
               
                CyberSourceTransactionData.PaySubscriptionCreateService paySubscriptionCreateService = new CyberSourceTransactionData.PaySubscriptionCreateService();
                paySubscriptionCreateService.run = 'true';
                
                
             try{
                    Datetime startTime = System.now();
                    // Calling the web service
                    xmlResponse  = instance.runTransaction(merchantID,merchantReferenceCode,clientEnvironment,clientSecurityLibraryVersion,clientApplication,clientApplicationUser,clientApplicationVersion,customerID,billTo,purchaseTotals,check,subscription,recurringSubscriptionInfo,paySubscriptionCreateService);
                    Datetime endTime = System.now();
                    Long totalTime = (endTime.getTime() - startTime.getTime());
                    System.debug('PymtTokenizationService | Cybersource API call total time - ' + totalTime);
                }
            Catch(CalloutException e)
                {
                    // If first call ends into Timeout error make a second attempt but no further calls must happen if 2nd call also times out
                     if(e.getMessage().containsIgnoreCase('Read timed out') && !doNotCall)
                     {
                             //We are still making a request for another time incase of Webservice failure to execute with in the time limit
                             doNotCall = true;
                             PymtTokenizationService.TokenizationRequest(ps); 
                      }
                      else
                      {
                          if(!Test.isRunningTest())
                          {
                              PymtTokenizationService.logError(FinalsubscriptionId,e.getMessage(),ps,e.getStackTraceString().left(32000));
                              throw new CyBsCalloutException();
                          }
                      }
                }
               
                                
                system.debug('CyberSourceTransactionData.ReplyMessage : -'+xmlResponse);
                
                // Cybersource response handling starts including error handling
                if(xmlResponse != Null)
                {    system.debug('xmlResponsesss-->'+xmlResponse);
                     PymtTokenizationService.validateResponse(xmlResponse, ps);
                }
                else
                {  
                    // Add error when response itself is NULL                     
                    PymtTokenizationService.logError(FinalsubscriptionId, 'Unable to tokenize bank account', ps, 'No soap response received from Cybersource');
                  //  return FinalsubscriptionId;
                }
          system.debug('FinalsubscriptionId-->'+FinalsubscriptionId);
            return FinalsubscriptionId;
            
        }
        
    
    /*******************************************************************************************************
    * @description : METHOD: validateResponse() parses the xml response received from Cybersource and retrieves the Subscription ID 
    * @param       : CyberSourceTransactionData.ReplyMessage, Payment_Source__c
    * @return      : RETURNS void
    * @example 
    *  
    *******************************************************************************************************/
        @testvisible 
        Private static void validateResponse(CyberSourceTransactionData.ReplyMessage xmlResponse, Payment_Source__c ps){
            system.debug('ValidatexmlResponse-->'+xmlResponse);
            String FinalReasoncode;
            Map< String, CybserSource_Error_Codes__c > CybErrCodes = CybserSource_Error_Codes__c.getAll();
            String cybsRequestId = String.valueOf(xmlResponse.requestID);
            FinalReasoncode =  String.valueOf(xmlResponse.reasonCode);
            if(xmlResponse.decision == 'ACCEPT')
               {
                     
                     if(FinalReasoncode == string.valueof(100) && !String.isblank(xmlResponse.paySubscriptionCreateReply.subscriptionID))
                     { 
                         FinalsubscriptionId =  String.valueOf(xmlResponse.paySubscriptionCreateReply.subscriptionID);
                     }
                } 
                else if(xmlResponse.decision == 'REJECT')
                {
                    String CyBsErrDesc;
                    try {
                        CyBsErrDesc = CybErrCodes.get(FinalReasoncode).Error_Message__c;
                    }
                    catch (Exception e) {
                        CyBsErrDesc = 'New error code received from Cybersource | ReasonCode - ' + FinalReasoncode;
                    }
                     
                    
                    
                    if (FinalReasoncode == String.valueOf(102)) { // ReasonCode 102 is for invalid fields in the request
                              String invalidfield = String.valueOf(xmlResponse.invalidField);
                              String ErrorDetails = 'ReasonCd: ' +FinalReasoncode + ' - InvalidField: ' + invalidfield +' - RequestId: ' + cybsRequestId; 
                              PymtTokenizationService.logError(FinalsubscriptionId, CyBsErrDesc, ps,ErrorDetails);
                         }
                         else {  
                             // For all other error related reason codes
                             
                             String ErrorDetails = 'ReasonCd: ' +FinalReasoncode + ' - Error: ' + CyBsErrDesc + '\n' + 'RequestId: ' + cybsRequestId;                         
                             PymtTokenizationService.logError(FinalsubscriptionId, 'Unable to tokenize bank account', ps, ErrorDetails);
                         }
                     }
        }
   
        Private static void logError(String FinalsubscriptionIds,string msg,Payment_Source__c ps,string stackMsg){
                   FinalsubscriptionIds = null;   
                   UtilityClass.logErrorResp('PymtTokenizationService', msg, ps.CyBs_Customer_Id__c, '', stackMsg);
                   //return FinalsubscriptionIds;
              
        }
    
    public class CyBsCalloutException extends Exception {
        
    }
      
}