Public with sharing class RecordTypeSelection {
        
        Public string Selected {get;set;}
        Public list<Finance_Account__c> financeAccounts;
        Public Finance_Account__c FinanceAcc ;
        Public String FinanceAccNumber ;
        Public String FinanceAccId ;
        Public String StdOTPRecordTypeId ;
        
        String finAccNum='';
        Public boolean displaymodeNonRecurringPaymntst{get;set;}
        Public boolean displaymodePaymntst{get;set;}
        public Map<String,RecordType>  orderRTMap ; 
        public boolean isPaymentAllowed{get;set;}
         
        public boolean isValid{get;set;}
     Integer STDPaymentCounts = 0 ;
        Integer RecurringCounts  = 0 ;
        
    Public RecordTypeSelection(ApexPages.StandardController controller) {
        
        isValid = true;
        isPaymentAllowed = true;
        
                                            
    }
    
    Public String IsFromBank = '';
    
    Public PageReference init(){
        
        if ( ApexPages.CurrentPage().getParameters().get('isfromBank') <> NULL  ) {
        
            isfromBank =ApexPages.CurrentPage().getParameters().get('isfromBank') ;
        }
        
        if ( ApexPages.CurrentPage().getParameters().get('finnumber') <> NULL  ) {
           
           FinanceAccNumber = ApexPages.CurrentPage().getParameters().get('finnumber') ;
           
           Finance_Account__c[] FinanceAccs = [SELECT id,Past_Amount_Due__c 
                                                   FROM Finance_Account__c 
                                                   WHERE Finance_Account_Number__c = :FinanceAccNumber ];  
           
           if ( !FinanceAccs.isEmpty() ) {
               FinanceAcc = FinanceAccs[0];
               FinanceAccId = FinanceAccs[0].Id;
               
               //isPaymentAllowed = PaymentsUtils.CheckPaymentCounts( FinanceAccId )  ;
           } 
       } 
       return null;
    
    }
    
    Public PageReference CancelAction() {
        PageReference pageRefCancel = new PageReference(System.Label.System_CL0002+FinanceAccId );
       // pageRefCancel.setRedirect(true);
        return pageRefCancel;
    }
	
    
    Public PageReference ContinueAction() {
        
        String PageName = NULL ;
        
        ChargentOrders__ChargentOrder__c[] Payments = [SELECT Id, RecordTypeId
                                                           FROM ChargentOrders__ChargentOrder__c 
                                                           WHERE Finance_Account_Number__c = : FinanceAccId
                                                           AND Payment_Display_Status__c IN ('Pending','Processing') ] ;
        
         
        
        Set<String> NONRecurringRecordTypeIDs = NEW Set<String> () ;
        NONRecurringRecordTypeIDs.add( Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId() ) ;
        NONRecurringRecordTypeIDs.add( Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId() ) ;
        //NONRecurringRecordTypeIDs.add( Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId() ) ;
        
        
        Set<String> RecurringRecordTypeIDs = NEW Set<String> () ;
        RecurringRecordTypeIDs.add( Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId() ) ;
        
                                                          
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
            }
        
        if ( Selected <> NULL ) {
        
            
            
        
            if( Selected == 'One_Time_Payment'){
                    // if(STDPaymentCounts >= 6 && (Selected == 'One_Time_Payment')){
                    // System.debug('******'+STDPaymentCounts +Selected);
                    
                    // isValid = false;
                    // }else{
                         PageName  = System.Label.System_CL0010 ;
                    // }
            } else if( Selected == 'Payoff_Payment'){
                 PageName  = System.Label.System_CL0011 ;
                 
                
            } else if( Selected == 'Principal_One_Time_Payment'){
                //  if(STDPaymentCounts >= 6 && (Selected == 'Principal_One_Time_Payment')){
                //     System.debug('******'+STDPaymentCounts +Selected);
                    
                //     isValid = false;
                //     }else{
                         PageName  = System.Label.System_CL0012 ;
                    // }
                
                
            } else if( Selected == 'Recurring_Payment'){
                
                      
                
                
                
  /*              
        StdOTPRecordTypeId = Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId() ;
                ChargentOrders__ChargentOrder__c[] COrder = [SELECT id,ChargentOrders__Charge_Amount__c, ChargentOrders__Charge_Date__c 
                                                               FROM ChargentOrders__ChargentOrder__c 
                                                               WHERE Finance_Account_Number__c = :FinanceAccId 
                                                               AND recordtypeid =: StdOTPRecordTypeId 
                                                               AND Payment_Display_Status__c IN ('Pending','Processing') ];
                Decimal ChargeAmount = 0;      
                
                for ( ChargentOrders__ChargentOrder__c a  :COrder ){
                    ChargeAmount = ChargeAmount + a.ChargentOrders__Charge_Amount__c;  
                }     
                
                
                if ( !COrder.isEmpty() ) {
                    
                    isPaymentAllowed = False ;
                    return NUll;
                    
                } else if (FinanceAcc.Past_Amount_Due__c >0 && ChargeAmount < FinanceAcc.Past_Amount_Due__c) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Account is past due. A payment must be scheduled for the Past Due Amount'));
                    return NUll;
                }      */   
                   PageName  = System.Label.System_CL0013 ;
                    
            }
        
        }

        
        if ( PageName <> NULL ) {
        
            
                PageReference pageRefContinue = new PageReference(PageName+FinanceAccNumber+'&isFromBank='+isfromBank);
                pageRefContinue.setRedirect(true);
                return pageRefContinue;
                } 
       
        else {
            
            return NUll;
        
        }
        
    
    }
   
 
    
   

}