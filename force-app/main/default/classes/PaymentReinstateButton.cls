global class PaymentReinstateButton {
    
    
    
    Webservice Static String init(String PaymentId) { 
        
        System.debug('PaymentId ==>  ' + PaymentId ) ; 
        Date NextTransactionDate;
        String Msg = 'NULL' ;
        String BankStatus ='';   //bug 25963 - Supriya Chakraborty 15-Feb-2022
        //bug 25963 - Supriya Chakraborty 15-Feb-2022 - Payment_Source_Nickname__r.Status__c field added
        ChargentOrders__ChargentOrder__c  PaymentRecord  =  [SELECT id,Payment_Display_Status__c,ChargentOrders__Charge_Date__c,Next_Withdrawal_Date__c,ChargentOrders__Payment_Start_Date__c,
                                                                        recordtype.developername, ChargentOrders__Payment_Stop__c, ChargentOrders__Payment_End_Date__c, Extracted_Payment_Count__c, 
                                                                  		ChargentOrders__Payment_Count__c, Payment_Source_Nickname__r.Status__c  
                                                                        FROM  ChargentOrders__ChargentOrder__c 
                                                                        WHERE id =: PaymentId] ;  
            
        		BankStatus = PaymentRecord.Payment_Source_Nickname__r.Status__c;
             if ( PaymentRecord.recordtype.developername == 'Recurring_Payment' ) {
                // FOR RECURRING PAYMENTS IF ALREADY PAYMENT STATUS IS ANY OF THE FOLLOWINGS THROW ERROR MESSAGE
                Set<String> DisplayStatuses = New Set<String> ();
                DisplayStatuses.add('Complete');
                DisplayStatuses.add('Cancelled');
                DisplayStatuses.add('Stopped');
                DisplayStatuses.add('Pending');
                
                if ( DisplayStatuses.Contains(PaymentRecord.Payment_Display_Status__c) ) {
                    
                    Msg = 'Changes cannot be saved due to the Recurring Payment status.' ;
                    
                }else if(PaymentRecord.Payment_Display_Status__c == 'Suspended' && BankStatus =='Deleted'){//bug 25963 - Supriya Chakraborty 15-Feb-2022
                    Msg = 'EazyPay cannot be reinstated because it is associated to an inactive bank account.' ;
                }
                else if(PaymentRecord.Payment_Display_Status__c == 'Processing'){
                    Msg = 'Recurring Payment cannot be cancelled during processing on the payment date. Please try again after processing is complete.' ;
                }
                 else {
                
                    // REINSTATE THE RECURRING PAYMENT
                     ChargentOrders__ChargentOrder__c UpdateRec = new ChargentOrders__ChargentOrder__c();
                        UpdateRec.Id = PaymentId;  
                        UpdateRec.ChargentOrders__Payment_Status__c = 'Recurring'; 
                        UpdateRec.Payment_Display_Status__c = 'Pending'; 
                                                 
                        
                       // LOGIC for Next Withdrawal Date -- STARTS    
                       if ( PaymentRecord.ChargentOrders__Charge_Date__c <> NULL ) {
                
                          UpdateRec.Next_Withdrawal_Date__c = NWDManager.calculateNWD(PaymentRecord, Date.today(), false);

                            if ('No'.equalsIgnoreCase(UIHelper.canUpdateEPStatus(UpdateRec.Payment_Display_Status__c, UpdateRec.Next_Withdrawal_Date__c))) {
                                Msg = 'Recurring Payment cannot be cancelled during processing on the payment date.  Please try again after processing is complete.' ;
                            }
                           else
                           {
                               update UpdateRec;
                           }
                       }
        
                }  
                
                }
            return Msg;
         }
             
     }