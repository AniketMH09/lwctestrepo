Public Class PaymentsUtils {
    
    
    Public Static Map<String,Payment_Source__c> BankAccRecords  {get;set;}
    
    // RETURN TYPE OF METHOD IS CHANGED TO NEW WEBSERVICE AS PART OF PHOENIX
        Public Static PymtTokenizationService.PTSResult GetBankToken(Payment_Source__c PaymentRec){
        
        
        Payment_Source__c PaymentSource = New Payment_Source__c ();
        PaymentSource = PaymentRec;
        PaymentSource.Billing_First_Name__c = 'John';
        PaymentSource.Billing_Last_Name__c = 'Doe';
        PaymentSource.Billing_Street__c = '1295 Charleston Road';
        PaymentSource.Billing_City__c = 'Mountain View';
        PaymentSource.Billing_State__c = 'California';
        PaymentSource.Billing_Zip__c = '94043';
        PaymentSource.Billing_Country__c = 'US';
        PaymentSource.Billing_Email__c = 'null@cybersource.com';
        PaymentSource.Currency__c = 'U.S. Dollar';
        PaymentSource.Status__c ='Active';
            // CALLING THE 'CREATEPS' METHOD FROM PYMNTTOKENIZATIONSERVICE AS PART OF PHOENIX       
        PymtTokenizationService.PTSResult result = PymtTokenizationService.createPS(PaymentSource);

        return result ;
    }
    
    
    Public Static List<SelectOption> fetchBankAccSelecOptions ( String FinAccNumber, String Mode, String SelBankAccId ){
        
        
        
        //Query Bank Accounts for the Given Finance Account Number
        
        if ( FinAccNumber <> NULL ) {
        
            BankAccRecords =   PaymentsUtils.fetchBankAccs(FinAccNumber);
            System.debug('BankAccRecords:'+BankAccRecords);
            System.debug('SelBankAccId:'+SelBankAccId);
            List<SelectOption> BankAccsOptions = new List<SelectOption>();
           
            if ( Mode == 'EDIT' && SelBankAccId <> NULL && BankAccRecords.get(SelBankAccId).Payment_Source_Nickname__c <> NULL && BankAccRecords.get(SelBankAccId).Last_4__c <> NULL ) {
                
                BankAccsOptions.add(new SelectOption(SelBankAccId, BankAccRecords.get(SelBankAccId).Payment_Source_Nickname__c+' - ('+BankAccRecords.get(SelBankAccId).Last_4__c+')'));
            }
          
            
            for ( Payment_Source__c a :BankAccRecords.Values() ){ 
                
                System.Debug(' a ==> ' + a);
                
                if ( Mode == 'EDIT' && !SelBankAccId.Contains(a.Id) ) {
                    
                    String BankName= a.Payment_Source_Nickname__c+' - ('+a.Last_4__c+')';                 //Added on Aug 2018 as part of RSS 44804
                    BankAccsOptions.add(new SelectOption(a.Id, BankName));
                    system.debug('BankAccsOptions:'+BankAccsOptions);
                } else if ( Mode == 'NEW' ){
                    String BankName= a.Payment_Source_Nickname__c+' - ('+a.Last_4__c+')';                 //Added on Aug 2018 as part of RSS 44804
                    BankAccsOptions.add(new SelectOption(a.Id, BankName));
                }
                        
            }
            
        
            return BankAccsOptions;   
        
        } else {
        
            return NULL;
        }
       
         
    }
    
    Public Static Map<String,Payment_Source__c> fetchBankAccs( String FinAccId  ){
        
        BankAccRecords =  New Map<String,Payment_Source__c> ([ SELECT Id, Name, Bank_Name__c, Last_4__c, ChargentOrders_Tokenization__c, Payment_Source_Nickname__c,
                                                                    Preferred_Payment_Source__c  
                                                                    FROM Payment_Source__c
                                                                    WHERE Finance_Account_Number__r.Finance_Account_Number__c = : FinAccId 
                                                                            AND Status__c=:'Active'
                                                                            Order By Preferred_Payment_Source__c  desc]);
        return BankAccRecords;
        
    }
    
    
    
    // METHOD: CHECK THE NO OF PAYMENTS EXISTS FOR THIS FINANCE ACCOUNT 
    
    Public Static Boolean CheckPaymentCounts(String FinanceAccountId ){
        
        Boolean isPaymentAllowed = TRUE ;
       
        
        ChargentOrders__ChargentOrder__c[] Payments = [SELECT Id, RecordTypeId
                                                           FROM ChargentOrders__ChargentOrder__c 
                                                           WHERE Finance_Account_Number__c = : FinanceAccountId 
                                                           AND Payment_Display_Status__c IN ('Pending','Processing') ] ;
        
         
        
        Set<String> NONRecurringRecordTypeIDs = NEW Set<String> () ;
        NONRecurringRecordTypeIDs.add( Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId() ) ;
        NONRecurringRecordTypeIDs.add( Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId() ) ;
        NONRecurringRecordTypeIDs.add( Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId() ) ;
        
        
        Set<String> RecurringRecordTypeIDs = NEW Set<String> () ;
        RecurringRecordTypeIDs.add( Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId() ) ;
        
        
        Integer STDPaymentCounts = 0 ;
        Integer RecurringCounts  = 0 ;
                                                          
        if( !Payments.isEmpty() ) {
        
            for ( ChargentOrders__ChargentOrder__c a :Payments ) {
                
                // GET COUNT OF STD OTP PAYMENTS FOR THIS FINANCE ACCOUNT
                String RecordTypeId = a.RecordTypeId ;
                if( NONRecurringRecordTypeIDs.Contains(RecordTypeId) ) {
                    STDPaymentCounts += 1 ;
                } else if( RecurringRecordTypeIDs.Contains(RecordTypeId) )  {
                    RecurringCounts  += 1 ;
                }
                
            }
        
            
            isPaymentAllowed = FALSE ;
            
            System.Debug(' STDPaymentCounts  ==> ' + STDPaymentCounts );
            System.Debug(' RecurringCounts  ==> ' + RecurringCounts );
            
            
            
            // RULE 01 : ALLOW MAX SEVEN
            if (   STDPaymentCounts + RecurringCounts >= 7 ) {
                
                isPaymentAllowed = FALSE ;
            
            } else if (   STDPaymentCounts >= 6 && RecurringCounts ==1 ) {
            
                isPaymentAllowed = FALSE ;
            
            } else {
           
                isPaymentAllowed = TRUE ;
            } 
        
        }                                                   
        
        
        System.Debug(' isPaymentAllowed ==> ' + isPaymentAllowed );
        
        return isPaymentAllowed ;
    }
    
    
    Public Static String getCutOffTime() {
    
         Honda_Finance__c mc = Honda_Finance__c.getOrgDefaults() ;
         
         if ( mc.get('CutOff_Time__c') <>  NULL ) {
            Datetime  CutOffTime  =  Datetime.valueof(mc.get('CutOff_Time__c')) ;
            String CuttOFFTime =  CutOffTime.format('h:mm a' ,'America/Los_Angeles');
            return CuttOFFTime ;
         }
        
        return NULL;
    }    
    
    
    Public Static Boolean isBeforeCutOffTime() {
    
         Honda_Finance__c mc = Honda_Finance__c.getOrgDefaults() ;
         
          if ( mc.get('CutOff_Time__c') <>  NULL ) {
            Datetime  CutOffTime  =  Datetime.valueof(mc.get('CutOff_Time__c')) ;
            String tmp1 =  CutOffTime.format('HH:mm','America/Los_Angeles');
            String tmp2 =  DateTime.Now().format('HH:mm','America/Los_Angeles');
            
            Time CuttOFFTime = Time.newInstance(  Integer.Valueof(tmp1.SubstringBefore(':')),  Integer.Valueof(tmp1.SubstringAfter(':')), 0 ,0 );
            Time CurrentPSTTime = Time.newInstance(  Integer.Valueof(tmp2.SubstringBefore(':')),  Integer.Valueof(tmp2.SubstringAfter(':')), 0 ,0 );
            
            if ( CurrentPSTTime > CuttOFFTime ) {
                // AFTER CUTT OFF TIME 
                return False;
            }  else {
                // BEFORE CUTT OFF TIME 
                return True;
            }
          }
        
        return NULL;
    } 
}