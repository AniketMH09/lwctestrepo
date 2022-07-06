global  class NewPaymentFromBank {

    WebService static response  init(String BankAccRecordId) {
        
        NewPaymentFromBank.response res = new NewPaymentFromBank.response ();
        
      try {
      
            if ( String.isNotBlank(BankAccRecordId)  ) {
                
                Payment_Source__c BankAcc = [SELECT Id, Finance_Account_Number__c, Finance_Account_Number__r.Finance_Account_Number__c FROM Payment_Source__c WHERE Id = :BankAccRecordId ]  ; 
                
                String FinAccId     = BankAcc.Finance_Account_Number__c ;
                String FinAccNumber = BankAcc.Finance_Account_Number__r.Finance_Account_Number__c ;
                
                ChargentOrders__ChargentOrder__c[] Payments = [SELECT id, recordtype.developername 
                                                                   FROM ChargentOrders__ChargentOrder__c
                                                                   WHERE Payment_Display_Status__c = 'Pending' 
                                                                       AND Finance_Account_Number__r.Id = :FinAccId ] ;
                
                Boolean IsRecurringScheduled = False ;
                Integer OTPCount = 0 ;
                
                for ( ChargentOrders__ChargentOrder__c  p :Payments ) {
                    if ( P.recordtype.developername == 'Recurring_Payment' ) {
                        
                        IsRecurringScheduled = True ;
                        
                    } else {
                        
                        OTPCount += 1;
                        
                    } 
                }                                               
                
                System.debug(' IsRecurringScheduled  ==> ' + IsRecurringScheduled );
                System.debug(' OTPCount  ==> ' + OTPCount  );
                
                if( IsRecurringScheduled  && OTPCount >=6) { 
              
                    res.isSuccess = false ;
                    res.Msg = 'Only six pending one-time payments and one EasyPay schedule are allowed at a time';
                
                } else{
                    res.isSuccess = true ;
                    res.FinNumber = FinAccNumber ;
                }     
                
                 
            }     
          return res  ;     
        }
        catch (Exception e) {
            res.isSuccess = false ;
            res.Msg = 'Exception occured :' + e.getmessage() ;
            return res  ;  
        }
    }
    
    
    global class response{
        
        WebService Boolean isSuccess ;
        WebService String Msg ;
        WebService String FinNumber ;
        
    }
}