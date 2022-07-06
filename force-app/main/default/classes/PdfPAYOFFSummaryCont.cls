Public class PdfPAYOFFSummaryCont {

    Public String Payoffid    =  NUll ;
    Public String isHonda     =  'false' ;
  
    Public String PaymentRecordId   ;
    Public ChargentOrders__ChargentOrder__c Payment  {get;set;} 
    Public Communication_Preferences__c Preference  {get;set;}
    Public String BankAccNumber {get;set;} 
    String IsNew = 'scheduled' ; 
    Public String finnumber {get;set;}
    Public String PaymentDate {get;set;}
    Public String SumamryMessage  {get;set;}
    Public String finnumberWithoutZeroes {get;set;}
    Public String PaymentAuthDate {get;set;}         //Added as part of July 2018 release RSS 43709 
     
    
    Public PdfPAYOFFSummaryCont() {
        
        Payoffid = ApexPages.CurrentPage().getParameters().get('Payoffid') ;
        isHonda = ApexPages.CurrentPage().getParameters().get('isHonda') ;
        finnumber = ApexPages.CurrentPage().getParameters().get('finnumber') ; 
        
        //Defect#114148: Added by Shubham.    
        finnumberWithoutZeroes = String.valueOf(Integer.valueOf(finnumber));
        
        
        if ( !String.isBlank(Payoffid)  ) {
             IsNew = 'updated' ;
        }
        
        
        PayoffQuery();
        
        if ( Payment <> NULL && Payment <> NULL ) {
            PaymentDate = PDFUtils.FmtDate(Payment.ChargentOrders__Payment_Start_Date__c) ;
            SumamryMessage = PDFUtils.SetSummaryMessage( 'payoff', IsNew, PaymentDate, Preference );
            PaymentAuthDate = PDFUtils.FmtDate(Date.valueOf(Payment.PaymentAuthorizedOn__c)) ;     //Added as part of July 2018 release RSS 43709 
        }
    }
    
    
    
     
    Public void  PayoffQuery(){
    
        
    
        if ( finnumber <> NULL ) {
            
             List<ChargentOrders__ChargentOrder__c> Payments =  New List<ChargentOrders__ChargentOrder__c> () ;
             //Added Last_4__c for 114271
             //Added CreatedDate field as part of July 2018 release RSS 43709 
             Payments = [SELECT Id, ChargentOrders__Payment_Start_Date__c, ChargentOrders__Charge_amount__c, Confirmation_Number__c,
                                     Payment_Source_Nickname__r.Payment_Source_Nickname__c,Payment_Source_Nickname__r.Last_4__c, CreatedDate,PaymentAuthorizedOn__c
                                 FROM ChargentOrders__ChargentOrder__c 
                                 WHERE Finance_Account_Number__r.Finance_Account_Number__c = :finnumber 
                                     AND recordtype.developername = 'Payoff_Payment' 
                                     AND Payment_Display_Status__c = 'Pending' Limit 1];
             
             if ( !Payments.isEmpty() ){
                 
                 Payment = Payments[0];
                 
                 List<Communication_Preferences__c> Preferences =  New List<Communication_Preferences__c> () ;
                 
                 Preferences = [SELECT Id,Payment_Confirmations_via_Email__c, Payment_Confirmations_via_Text__c, Email_Address__c, Text_Number__c  
                                 FROM Communication_Preferences__c 
                                 WHERE Finance_Account_Number__r.Finance_Account_Number__c = :finnumber LIMIT 1] ;
                 
                 if ( !Preferences.isEmpty() ){
                     Preference = Preferences[0];
                 }     
                 
                 
             } 
        }
        
        
    } 
    
     
    
    
}