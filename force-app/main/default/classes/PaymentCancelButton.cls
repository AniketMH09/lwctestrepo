global class PaymentCancelButton {
    
    
    
    Webservice Static String init(String PaymentId) { 
        
        //Retrieve CUT OFF Time from Custom Settings 
        Honda_Finance__c mc = Honda_Finance__c.getOrgDefaults() ;         
        String Msg = 'NULL' ;
        //Checking the CutOff value in Honda_Finance__c Custom setting.
        if ( mc.get('CutOff_Time__c') <>  NULL ) 
        {
            Datetime  CutOffTime  =  Datetime.valueof(mc.get('CutOff_Time__c')) ;
            String tmp1 =  CutOffTime.format('HH:mm','America/Los_Angeles');
            String tmp2 =  DateTime.Now().format('HH:mm','America/Los_Angeles');            
            Time CuttOFFTime = Time.newInstance(  Integer.Valueof(tmp1.SubstringBefore(':')),  Integer.Valueof(tmp1.SubstringAfter(':')), 0 ,0 );
            Time CurrentPSTTime = Time.newInstance(  Integer.Valueof(tmp2.SubstringBefore(':')),  Integer.Valueof(tmp2.SubstringAfter(':')), 0 ,0 );
            Time StartTime = Time.newInstance(  1,  0, 0 ,0 );            
            ChargentOrders__ChargentOrder__c  PaymentRecord  =  [SELECT id,Payment_Display_Status__c,Next_Withdrawal_Date__c,ChargentOrders__Payment_Start_Date__c,
                                                                        recordtype.developername,Finance_Account_Number__r.Finance_Account_Number__c 
                                                                        FROM  ChargentOrders__ChargentOrder__c 
                                                                        WHERE id =: PaymentId] ; 
           Boolean iSFurtureDatedPayment = False;
           Boolean iSPaymentDateToday = False;
           if ( PaymentRecord.ChargentOrders__Payment_Start_Date__c > Date.Today() ) {
               iSFurtureDatedPayment  = True ;
           }  else if ( PaymentRecord.ChargentOrders__Payment_Start_Date__c == Date.Today() ){
               iSPaymentDateToday = True;
           }
            // Non Recurring Payments
            if(!iSFurtureDatedPayment && !iSPaymentDateToday && PaymentRecord.recordtype.developername <> 'Recurring_Payment' ) {
                // PAYMENT DATE IS IN PAST 
                Msg = 'Payments may not be edited or cancelled after the cutoff time on the payment date.' ;
                
            } 
            else if ( !iSFurtureDatedPayment  && CurrentPSTTime > CuttOFFTime && PaymentRecord.recordtype.developername != 'Recurring_Payment' ) {
                
                // AFTER CUTT OFF TIME 
                Msg = 'Payments may not be edited or cancelled after the cutoff time on the payment date.';
               
            } 
            else {
                 // BEFORE CUTT OFF TIME for recurring payments
                 if ( PaymentRecord.recordtype.developername == 'Recurring_Payment' ) {
                    // FOR RECURRING PAYMENTS IF ALREADY PAYMENT STATUS IS ANY OF THE FOLLOWINGS THROW ERROR MESSAGE
                    Set<String> DisplayStatuses = New Set<String> ();
                    DisplayStatuses.add('Complete');
                    DisplayStatuses.add('Cancelled');                    
                   // DisplayStatuses.add('Stopped');   // commented by kanagaraj for US_3803
                    
                    if ( DisplayStatuses.Contains(PaymentRecord.Payment_Display_Status__c) ) 
                    {
                        //If the easypay is already cancelled.
                        Msg = 'You may not modify this Payment since its status is '+PaymentRecord.Payment_Display_Status__c;
                    }
                    else if(('No'.equalsIgnoreCase(UIHelper.canUpdateEPStatus(PaymentRecord.Payment_Display_Status__c, PaymentRecord.Next_Withdrawal_Date__c))) && PaymentRecord.Payment_Display_Status__c != 'Suspended')
                      {                 
                            Msg = 'Recurring Payment cannot be cancelled during processing on the payment date. Please try again after processing is complete.' ;
                      }
                      else if(PaymentRecord.Payment_Display_Status__c == 'Processing'){
                        Msg = 'Recurring Payment cannot be cancelled during processing on the payment date. Please try again after processing is complete.' ;
                    }
                      //Before the cutoff Allow user to cancel the paymet
                      else{                  
                        // CANCEL THE RECURRING PAYMENT AND SHOW MESSAGE
                         ChargentOrders__ChargentOrder__c UpdateRec = new ChargentOrders__ChargentOrder__c();
                            UpdateRec.Id = PaymentId;  
                            UpdateRec.ChargentOrders__Payment_Status__c = 'Complete'; 
                            UpdateRec.Payment_Display_Status__c = 'Cancelled'; 
                            //Below Line Change added to the defect 114165 by Jayashree
                            UpdateRec.Duplicate_Key_Tracker__c = PaymentRecord.Finance_Account_Number__r.Finance_Account_Number__c + 'Recurring_Payment' + 'INACTIVE' + Datetime.now();
                            update UpdateRec; 
                            
                             Msg = 'Payment has been cancelled' ;
                          }    
                }
                
                else {
                    // FOR NON RECURRING PAYMENTS IF ALREADY PAYMENT STATUS IS ANY OF THE FOLLOWINGS THROW ERROR MESSAGE
                    Set<String> DisplayStatuses = New Set<String> ();
                    DisplayStatuses.add('Processing');
                    DisplayStatuses.add('Posted');
                    DisplayStatuses.add('Researching');
                    DisplayStatuses.add('Cleared to GL'); // added by kanagaraj for US_3800
                    DisplayStatuses.add('Cancelled');
                    if ( DisplayStatuses.Contains(PaymentRecord.Payment_Display_Status__c) ) {
                        Msg = 'You may not modify this Payment since its status is '+PaymentRecord.Payment_Display_Status__c+'.';
                    } 
                    else {
                        // CANCEL THE PAYMENT AND SHOW MESSAGE
                         ChargentOrders__ChargentOrder__c UpdateRec = new ChargentOrders__ChargentOrder__c();
                            UpdateRec.Id = PaymentId;  
                            UpdateRec.ChargentOrders__Payment_Status__c = 'Complete'; 
                            UpdateRec.Payment_Display_Status__c = 'Cancelled'; 
                            //Below changes added to the defect 114165 by Jayashree
                            If(PaymentRecord.recordtype.developername == 'Payoff_Payment') {
                            UpdateRec.Duplicate_Key_Tracker__c = PaymentRecord.Finance_Account_Number__r.Finance_Account_Number__c + 'Payoff_Payment' + 'INACTIVE' + Datetime.now();
                            } 
                            // End of Defect 114165
                            update UpdateRec; 
                            Msg = 'Payment has been cancelled' ;
                    }
                }
            }
        }
        return msg ;
    }
}