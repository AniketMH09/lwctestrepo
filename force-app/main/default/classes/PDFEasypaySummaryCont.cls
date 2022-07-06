Public Class PDFEasypaySummaryCont{

    public String OTPPayment { get; set; }
    
    Public ChargentOrders__ChargentOrder__c Payment {get;set;}
    Public Communication_Preferences__c Preference  {get;set;}
    Public String BankAccNumber {get;set;} 
    Public String WithdrawDate {get;set;}
    Public String PaymentDate {get;set;}
    Public String SumamryMessage  {get;set;}
    Public Decimal TotalPaymentAmount  {get;set;}
    Public String BankAccNickName {get;set;}
    Public String finnumber {get;set;}
    Public String finnumberWithoutZeroes {get;set;}
    String RPID ;
    String IsNew = 'enrolled' ;
   
    String FinRecordId ;
    
    Public PDFEasypaySummaryCont() {
        
        /*Changes made for Security Vulnerabilities for line 23,41 by Gufran 4/21/20 */
        //RPID = ApexPages.CurrentPage().getParameters().get('RPID').escapeHtml4();
        RPID = ApexPages.CurrentPage().getParameters().get('RPID') ;
        RPID = ESAPI.encoder().SFDC_HTMLENCODE(RPID);
        finnumber = ApexPages.CurrentPage().getParameters().get('finnumber') ;
        finnumber = ESAPI.encoder().SFDC_HTMLENCODE(finnumber);
        //finnumber = ApexPages.CurrentPage().getParameters().get('finnumber').escapeHtml4();
        WithdrawDate = ApexPages.CurrentPage().getParameters().get('WithdrawDate') ;
        
        
        
        
        if ( !String.isBlank(RPID)  ) {
             IsNew = 'updated' ;
        }
       
         
        if ( !String.isBlank(RPID) ) {
             
            Payment = PaymentQuerybyId(RPID);
        
        } else if ( !String.isBlank(finnumber) ) {
             
            Payment = PaymentQuerybyFinNum(finnumber);
        }  
        
        if ( FinRecordId <> NULL  ) {
            //Defect#114148: Modified by Shubham. 
            WithdrawDate =  String.valueof(Integer.valueOf(Payment.ChargentOrders__Charge_Date__c)) + PdfUtils.getDayOfMonthSuffix(Integer.valueOf(Payment.ChargentOrders__Charge_Date__c)) + ' of the month' ;
            Preference = PreferenceQuery(FinRecordId);
            PaymentDate = PDFUtils.FmtDate(Date.valueof(Payment.Next_Withdrawal_Date__c)) ;
            SumamryMessage = PDFUtils.SetEasyPaySummaryMessage( IsNew, PaymentDate, Preference );
            //Added Last_4__c for 114271
            BankAccNickName = Payment.Payment_Source_Nickname__r.Payment_Source_Nickname__c +'(XXXX-'+Payment.Payment_Source_Nickname__r.Last_4__c+')';
            
        }
         
        
        //Defect#114148: Added by Shubham    
           finnumberWithoutZeroes = String.valueOf(Integer.valueOf(finnumber));
        
    }
    
    Public ChargentOrders__ChargentOrder__c PaymentQuerybyId(String PaymentID){
    
         List<ChargentOrders__ChargentOrder__c> Payments =  New List<ChargentOrders__ChargentOrder__c> () ;
         //Added Last_4__c for 114271
         Payments = [SELECT Id, ChargentOrders__Payment_Start_Date__c, ChargentOrders__Charge_amount__c, Confirmation_Number__c,
                             Payment_Source_Nickname__r.Payment_Source_Nickname__c, Finance_Account_Number__r.Id,Finance_Account_Number__r.Name, Next_Withdrawal_Date__c,
                             ChargentOrders__Charge_Date__c,Payment_Source_Nickname__r.Last_4__c
                         FROM ChargentOrders__ChargentOrder__c 
                         WHERE Id = : PaymentID]; 
        
          if ( !Payments.isEmpty() ){
              FinRecordId = Payments[0].Finance_Account_Number__r.Id; 
              return Payments[0];
          } else {
              return null;
          }
    }
    
    Public ChargentOrders__ChargentOrder__c PaymentQuerybyFinNum(String finnumber){
    
         List<ChargentOrders__ChargentOrder__c> Payments =  New List<ChargentOrders__ChargentOrder__c> () ;
         //Added Last_4__c for 114271
         Payments = [SELECT Id, ChargentOrders__Payment_Start_Date__c, ChargentOrders__Charge_amount__c, Confirmation_Number__c,
                             Payment_Source_Nickname__r.Payment_Source_Nickname__c, Finance_Account_Number__r.Id,Next_Withdrawal_Date__c,
                             ChargentOrders__Charge_Date__c,Payment_Source_Nickname__r.Last_4__c
                         FROM ChargentOrders__ChargentOrder__c 
                         WHERE Finance_Account_Number__r.Finance_Account_Number__c = : finnumber
                             AND recordtype.developername = 'Recurring_Payment' AND Payment_Display_Status__c = 'Pending' LIMIT 1]; 
        
          if ( !Payments.isEmpty() ){
              FinRecordId = Payments[0].Finance_Account_Number__r.Id; 
              return Payments[0];
          } else {
              return null;
          }
          
    }  
    
    
    
     Public Communication_Preferences__c PreferenceQuery(String FinRecordId){
    
         List<Communication_Preferences__c> Preferences =  New List<Communication_Preferences__c> () ;
                 
         Preferences = [SELECT Id,Payment_Confirmations_via_Email__c, Payment_Confirmations_via_Text__c, Email_Address__c, Text_Number__c,
                                 EasyPay_Communications_via_Email__c, EasyPay_Communications_via_Text__c  
                         FROM Communication_Preferences__c 
                         WHERE Finance_Account_Number__r.Id = :FinRecordId LIMIT 1] ;
        
          if ( !Preferences.isEmpty() ){
              return Preferences[0];
          } else {
              return null;
          }
          
    } 
}