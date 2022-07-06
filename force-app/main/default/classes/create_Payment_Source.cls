/*******************************************************************************************************
    * @author  : AppFrontier 
    * @date    :  
    * @modified : 22 MAR 2016 
    * @group    :  
    * @group-content : 
    * @description : CREATE PAYMENT SOURCE IN CYBERSOURCE AND PROVIDE THE TOKEN AS RESPONSE.
    * THIS CLASS IS USED WHEN BANK ACCOUNT RECORD IS CREATED FROM AGENT CONSOLE AND COMMUNITY PAGES
********************************************************************************************************/
    

Public class create_Payment_Source {
    
    //GLOBAL VARIABLE DECLARATIONS 
    Private static boolean validationError = false;
    public static String finNumber = '';
    

    /*******************************************************************************************************
    * @description : CREATE PAYMENT SOURCE RECORD (BANK ACCOUNT) 
    * @param : PAYMENT SOURCE RECORD , GATEWAY RECORD ID 
    * @return : RETURNS CREATE RECORD AND BANK ACCOUNT TOKEN FROM CYBERSOURCE
    * @example 
    *  
    *******************************************************************************************************/
    public static result create(Payment_Source__c ps, ID gatewayID){
        
        System.Debug(' ***** create_Payment_Source ==> ***** ');
        
        ChargentBase.ChargentWebService.ChargentWebOutput oPaymentResult;
        result res = NULL ;
        
        try{
        
            res = validateData(ps);  

            if(res != null) return res;
            
            // INITIALIZE THE WEBSERVICE INSTANCE
            ChargentBase.ChargentWebService.ChargentWebInput oPayment = new ChargentBase.ChargentWebService.ChargentWebInput(); 
            System.Debug(' ***** oPayment   ==> ' + oPayment );         
            oPayment.Action = 'RegisterToken';
            oPayment.Gateway = gatewayId;
            oPayment.PaymentMethod = 'Check';
            oPayment.OOCId = UtilityClass.getEnvName(); //114221 - Send Environment Details
            
            // MAP THE FIELD VALUES 
            oPayment.BankRoutingNum = ps.Bank_Routing_Number__c;
            oPayment.BankAccountNum = ps.Bank_Account_Number__c;
            oPayment.BankAccountType = ps.Bank_Account_Type__c;//'Checking'; 
            oPayment.BankName = ps.Bank_Name__c;
            oPayment.BankAccountName = ps.Payment_Source_Nickname__c;
            oPayment.Amount = String.valueOf(0.00);
            
            // SPLIT THE FULL NAME TO FIRST NAME & LAST NAME
            if( ps.Finance_Account_Number__c <> NULL ) {
                
                Finance_Account__c[] finAcc = [SELECT Finance_Account_Number__c,Customer_Name__c  
                                                  FROM Finance_Account__c 
                                                 WHERE id = :ps.Finance_Account_Number__c];
                if ( !finAcc.isEmpty() ) {
                    
                    finNumber = finAcc[0].Finance_Account_Number__c;
                    
                    if ( finAcc[0].Customer_Name__c == NULL ) {
                        
                        System.Debug(' ***** CUSTOMER NAME NULL ==> ***** ');
                        // LOG EXCEPTION IN ERROR LOG OBJECT
                         UtilityClass.logErrorResp('Bank Account Creation', 'Customer Name is Blank in Finance Account', finNumber, 'Routing #  '+ ps.Bank_Routing_Number__c, NULL  );
                         return New Result(false,'Error') ;
                        
                    } else {
                    
                         Name name = SplitFullNAME(finAcc[0].Customer_Name__c) ;
                         ps.Billing_First_Name__c = name.FirstName;
                         ps.Billing_Last_Name__c  = name.LastName;
             
                    }
                    
                } else {
                
                    return  New Result(false,'Error'); 
                
                }
                
            }
            
            oPayment.FirstName = ps.Billing_First_Name__c;
            oPayment.LastName = ps.Billing_Last_Name__c;
            oPayment.Address = ps.Billing_Street__c;
            oPayment.City = ps.Billing_City__c;
            oPayment.State = ps.Billing_State__c;
            oPayment.Zip = ps.Billing_Zip__c;
            oPayment.country = ps.Billing_Country__c;
            oPayment.ShippingState = ps.Billing_State__c;
            oPayment.customerEmail = ps.Billing_Email__c;
            oPayment.AmountCurrency = ps.Currency__c;
            oPayment.Phone = '650-965-6000';
    
            system.debug('oPayment RECORD ==> '+oPayment);
           
            oPaymentResult = ChargentBase.ChargentWebService.ProcessWeb(oPayment);
                
            system.debug('oPaymentResult ==> '+oPaymentResult);
             
            // VERIFY THE TOKEN 
            //Changes added to the defect 114228 by Jayashree    
            if( oPaymentResult == NULL || String.isBlank(oPaymentResult.tokenization) ){
                // IF TOKEN IS NULL RETURN NULL
                String ErrorDetails = 'Cause => null' + '\n'; 
                       ErrorDetails += 'User => ' +Userinfo.getUserName() + '\n' ;
                       ErrorDetails += 'Routing# => ' +ps.Bank_Routing_Number__c + '\n';
                String Response = ' Response Token => NULL ' + '\n' + 'Finance Account Number =>' +finNumber;       
                UtilityClass.logError('Bank Account Creation', ErrorDetails  , ps.Finance_Account_Number__c,  Response  );  
                //End of defect 114228              
                res = New Result(false,oPaymentResult.GatewayResp);  
                System.debug('res  ==> '+res );
                
            } else {
                // IF TOKEN IS RECIVED ASSIGN THE TOKEN 
                
                ps.Bank_Account_Number__c = null;
                ps.Bank_Routing_Number__c = null;
                ps.ChargentOrders_Tokenization__c = oPaymentResult.tokenization;
                
                System.debug('ps ==> '+ps);
                
                //CREATE BANK ACCOUNT RECORD 
                insert ps;
                
                res = New Result(ps.id,ps.ChargentOrders_Tokenization__c);
                System.debug('Inside Token Scenario ==> '+res);
            }
            
        } catch(Exception e){
             System.Debug(' Exception e ==> ' + e);
             // DEFECT 114228 Fixed Error log Error
             UtilityClass.logErrorResp('Bank Account Creation',   'Exception Caught', finNumber, 'Routing #  '+ ps.Bank_Routing_Number__c, e.getStackTraceString().left(32000)  );
             return New Result(false,'Error') ;
        }

        return res;

    }
    
    
    /*******************************************************************************************************
    * @description : VALIDATE PAYMENT SOURCE RECORD GIVEN INPUT DATAS 
    * @param : PAYMENT SOURCE RECORD   
    * @return : RETURNS RESULT WRAPPER CLASS
    * @example 
    *  
    *******************************************************************************************************/
    
    Public class CustomException extends Exception {}
    
    Private static result validateData(Payment_Source__c ps){
        
        try {
        
            // COMMON MESSAGE FIRST LINE
            String msg = 'The following required data was missing:\r\n\r\n';

            // BANK ACCOUNT NUMBER  
            if(ps.Bank_Account_Number__c == null){
                addToError(msg,'Bank Account Number');
            }
    
            // BANK NAME 
            if(ps.Bank_Name__c == null){
                addToError(msg,'Bank Account Name');
            }
            
            // ROUTING NUMBER
            if(ps.Bank_Routing_Number__c == null){
                addToError(msg,'Bank Routing number');
            }
            
            // BILLING STREET
            if(ps.Billing_Street__c == null){
                addToError(msg,'Billing Address');
            }
            
            // BILLING CITY
            if(ps.Billing_City__c == null){
                addToError(msg,'Billing City');
            }
            
            // BILLING STATE
            if(ps.Billing_State__c == null){
                addToError(msg,'Billing State');
            }
            
            // BILLING ZIP CODE
            if(ps.Billing_Zip__c == null){
                addToError(msg,'Billing Zip');
            }
            
            // BILLING COUNTRY
            if(ps.Billing_Country__c == null){
                addToError(msg,'Billing Country');
            }
            
            // BILLING EMAIL
            if(ps.Billing_Email__c == null){
                addToError(msg,'Billing Email');
            }
              
     
            // FINANCE ACCOUNT
            if(ps.Finance_Account_Number__c == null){
                addToError(msg,'Finance Account');
            }
             
            // CURRENCY
            if(ps.Currency__c == null){
                addToError(msg,'Currency');
            }
            
            if(validationError){
                return new result(false, msg);
            }else{
                return null;
            }
        
        } catch(Exception e){
            // LOG EXCEPTION IN ERROR LOG OBJECT
            System.debug('getCause ' + e.getCause() );
            System.debug('getLineNumber' + e.getLineNumber() );
            System.debug('getMessage ' + e.getMessage() );
            System.debug('getStackTraceString ' + e.getStackTraceString() );
            System.debug('getTypeName ' + e.getTypeName() );
            
            
             UtilityClass.logErrorResp('Bank Account Creation', 'validate', finNumber, 'Routing #  '+ ps.Bank_Routing_Number__c, NULL  );
             return null;
        }

    }

    private static void addToError(String err, String msg){
        validationError = true;
        msg += err + '\r\n';
        System.debug('Payment Source Validation Failed - \n' + msg);

    }
    
    
    /*******************************************************************************************************
    * @description : SET FIRSTNAME,LASTNAME OF GIVEN INPUT DATAS 
    * @param : CUSTOMER NAME    
    * @return : 
    * @example 
    *  
    *******************************************************************************************************/
   //Changes added to the defect #113842 by Jayashree 
   
    Public Static Name  SplitFullNAME (String FullName) {
        
        if ( String.isBlank(FullName) ){
           
            return null;
            
        } else {
        
            String FName, LName = NULL;
            
            //REMOVE ANY SPECIAL CHARS
            FullName = FullName.replaceall('[^a-zA-Z0-9\\s]','');
            
            System.Debug(' FullName ==> ' + FullName );
             
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
            
            System.Debug(' FName  ==> +' + FName +'+');      
            System.Debug(' LName  ==> +' + LName +'+');   
            
            return (New Name(FName , LName ) );
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
    
     
   //End of defect #113842
     
    /*******************************************************************************************************
    * @description : WRAPPER CLASS 
    * @param : NO PARAMS
    * @return : RETURNS PERSON ACCOUNT RECORD
    * @example 
    *  
    *******************************************************************************************************/
    Public class result{
        public String pId;
        public String token;
        public boolean success;
        public String msg;

        public result(boolean s, String msg){
            success = s;
            this.msg = msg;
        }

        public result(String i, String t){
            pid = i;
            token = t;
            success = True;
        }
    }
}