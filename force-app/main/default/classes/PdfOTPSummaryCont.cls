/*******************************************************************************************************
    * @author   : Accenture
    * @date     :   
    * @modified :   
    * @group    :  
    * @group-content : 
    * @description :  Generate PDF Summary Page Controller for OTP and Principal
    * Last updated on 27-July for Defect - 114148
********************************************************************************************************/
    
    Public class PdfOTPSummaryCont {

    Public String OTPId    =  NUll ;
    Public String isHonda     =  'false' ;
    Public String StdOTPNumber   =  Null ;
    Public String PrincipalNumber   =  Null ;
    Public String FinRecordId   =  Null ;
    Public String PaymentRecordId   ;
    Public ChargentOrders__ChargentOrder__c OTPPayment  {get;set;} 
    Public ChargentOrders__ChargentOrder__c PRINPayment  {get;set;} 
    Public String BankAccNumber {get;set;} 
    Public Communication_Preferences__c Preference  {get;set;}
    Public String PaymentType {get;set;}
    
    String IsNew = 'scheduled' ; 
    
    Public String PaymentDate {get;set;}
    Public String SumamryMessage  {get;set;}
    Public Decimal TotalPaymentAmount  {get;set;}
    Public String BankAccNickName {get;set;}
    Public String finnumber {get; set;}
    Public String PaymentAuthorizedOn {get;set;}        // Added as part Of july 2018 release RSS 41776
    Public String finnumberWithoutZeroes {get; set;}
    
    
    /*******************************************************************************************************
    * @description :  Generate PDF Summary Page Controller Constructor  
    * @param : REQUEST PARAMS 
    * @param : 
    * @return :  
    * @example 
    *  
    *******************************************************************************************************/
    
    
    Public PdfOTPSummaryCont() {
        
        /*Changes made for Security Vulnerability RSS - 49578 by Gufran*/
        OTPId = ApexPages.CurrentPage().getParameters().get('OTPid');
        OTPId = ESAPI.encoder().SFDC_HTMLENCODE(OTPId);
        isHonda = ApexPages.CurrentPage().getParameters().get('isHonda');
        isHonda = ESAPI.encoder().SFDC_HTMLENCODE(isHonda);
        /*Changes proposed for Security Vulnerabilities against line 59. 63 -- Gufran Date 4/20/2020*/ 
        StdOTPNumber = ApexPages.CurrentPage().getParameters().get('StdOTPNumber') ;
        StdOTPNumber = ESAPI.encoder().SFDC_HTMLENCODE(StdOTPNumber);
        //StdOTPNumber = ApexPages.CurrentPage().getParameters().get('StdOTPNumber').escapeHtml4();
        //PrincipalNumber = ApexPages.CurrentPage().getParameters().get('PrincipalNumber').escapeHtml4();
        PrincipalNumber = ApexPages.CurrentPage().getParameters().get('PrincipalNumber');
        PrincipalNumber = ESAPI.encoder().SFDC_HTMLENCODE(PrincipalNumber);
        finnumber = ApexPages.CurrentPage().getParameters().get('finnumber');
        finnumber = ESAPI.encoder().SFDC_HTMLENCODE(finnumber);
        if ( !String.isBlank(OTPId)  ) {
             IsNew = 'updated' ;
        }
        if ( String.isNotBlank(StdOTPNumber)  ) {
             OTPPayment = PaymentQuery(StdOTPNumber);
             PaymentType = 'STD' ;
        }
        if ( String.isNotBlank(PrincipalNumber)  ) {
             PRINPayment = PaymentQuery(PrincipalNumber);
             PaymentType = 'PRINC' ;
        }
        
        if ( String.isNotBlank(StdOTPNumber) && String.isNotBlank(PrincipalNumber)  ) {
             PaymentType = 'BOTH' ;
        }
         
         
        if ( FinRecordId <> NULL  ) {
             
             Preference = PreferenceQuery(FinRecordId);
             
             ChargentOrders__ChargentOrder__c Payment ;
             if ( OTPPayment <> NULL ) {
                 Payment = OTPPayment ;
             } else if ( PRINPayment <> NULL ) {
                 Payment = PRINPayment ;
             }
             
             if ( PRINPayment <> NULL && OTPPayment <> NULL ) {
                 TotalPaymentAmount  = PRINPayment.ChargentOrders__Charge_amount__c + OTPPayment.ChargentOrders__Charge_amount__c ;
             }
             
             if ( Payment <> NULL && Preference <> NULL ) {
                 PaymentDate = PDFUtils.FmtDate(Payment.ChargentOrders__Payment_Start_Date__c) ;
                 PaymentAuthorizedOn = PDFUtils.FmtDate(Payment.CreatedDate.Date()) ;                           // Added as part Of july 2018 release RSS 41776
                 SumamryMessage = PDFUtils.SetSummaryMessage( 'one-time', IsNew, PaymentDate, Preference );
                 //Added Last_4__c for 114271
                 
                 BankAccNickName = Payment.Payment_Source_Nickname__r.Payment_Source_Nickname__c +'(XXXX-'+Payment.Payment_Source_Nickname__r.Last_4__c+')';
             }
                //Defect#114148: Added by Shubham 
               finnumberWithoutZeroes = String.valueOf(Integer.valueOf(Payment.Finance_Account_Number__r.Name));
         } 
           
       }
    
    /*******************************************************************************************************
    * @description :  Query the payment record  
    * @param : Finance account # 
    * @param : 
    * @return :  Finance account record
    * @example 
    *  
    *******************************************************************************************************/
    
    
    Public ChargentOrders__ChargentOrder__c PaymentQuery(String ConfirmNumber){
    
         List<ChargentOrders__ChargentOrder__c> Payments =  New List<ChargentOrders__ChargentOrder__c> () ;
         //Added Last_4__c for 114271
         // Added CreatedDate field as part Of july release RSS 41776
         Payments = [SELECT Id, ChargentOrders__Payment_Start_Date__c, ChargentOrders__Charge_amount__c, Confirmation_Number__c,
                             Payment_Source_Nickname__r.Payment_Source_Nickname__c, Finance_Account_Number__r.Id , Finance_Account_Number__r.Name,Payment_Source_Nickname__r.Last_4__c,CreatedDate  
                         FROM ChargentOrders__ChargentOrder__c 
                         WHERE Confirmation_Number__c = : ConfirmNumber];
                         
                        
        if ( !Payments.isEmpty() ){
          
          FinRecordId = Payments[0].Finance_Account_Number__r.Id; 
              return Payments[0];
               
                
          } else {
              return null;
       }
          
    } 
    
    
    /*******************************************************************************************************
    * @description :   query the communication preferences record  
    * @param : Finance account record id
    * @param : 
    * @return :  communication preferences record
    * @example 
    *  
    *******************************************************************************************************/
    
    Public Communication_Preferences__c PreferenceQuery(String FinRecordId){
    
         List<Communication_Preferences__c> Preferences =  New List<Communication_Preferences__c> () ;
                 
         Preferences = [SELECT Id,Payment_Confirmations_via_Email__c, Payment_Confirmations_via_Text__c, Email_Address__c, Text_Number__c 
                         FROM Communication_Preferences__c 
                         WHERE Finance_Account_Number__r.Id = :FinRecordId LIMIT 1] ;
        
          if ( !Preferences.isEmpty() ){
              return Preferences[0];
          } else {
              return null;
       }
          
    } 
    
 }