/*******************************************************************************************************
* @author  : Sankalan Ghorai
* @date    : 
* @Created : 17 AUG 2016
* @group    :  
* @group-content : 
* @description : The purpose of this controller is for the SMS Delivery Service for the Finance Account while payment. 
This controller will send the sms delivery to the customer Mobile number.
In case of any sms deilvery failures, an Error log will be created without affecting the payment.
********************************************************************************************************/

/********************** @Update History **********************
@8 October 2018 -Defect RSS-41333 by PWC Team
/********************** @Update History **********************/

public class SMSDeliveryService {
    
    public static void sendPymtConfBySMS(List < SObject > orders, Map < Id, SObject > oldOrderMap) {
        
        String finAccountNumber = ''; // TO PASS THE FINANCE ACCOUNT NUMBER IN ERROR LOG OBJECT 
        Date paymentStartDate;
        Date paymentWithdrawalDate;
        Integer yearInt;
        Integer yearInt2;
        String yearSubString;
        String formattedDate;
        
        try{     
            Map < Id, Communication_Preferences__c > orderMap = new Map < id, Communication_Preferences__c > ();
            Map < Id, String > financeActType = new Map < Id, String > ();
            
            Map < Id, List < Id >> financeMap = new Map < id, List < Id >> ();
            
            for (SObject pymt: orders) {
                ChargentOrders__ChargentOrder__c cr = (ChargentOrders__ChargentOrder__c)pymt;
                system.debug(cr.Finance_Account_Number__c);
                if (financeMap.containsKey(cr.Finance_Account_Number__c)) {
                    financeMap.get(cr.Finance_Account_Number__c).add(cr.id);
                } else {
                    financeMap.put(cr.Finance_Account_Number__c, new List < Id > {
                        cr.id
                            });
                }
            }
            
            for (Finance_Account__c f: [Select id, Honda_Brand__c, Finance_Account_Number__c, (Select id, Email_Address__c, Payment_Confirmations_via_Email__c, EasyPay_Communications_via_Email__c, Text_Number__c, Payment_Reminders_via_Text__c, Payment_Confirmations_via_Text__c, EasyPay_Communications_via_Text__c from Communication_Preferences__r) from Finance_Account__c where Id IN: financeMap.keySet()]) {
                system.debug('f.Communi' + financeMap.keySet());
                system.debug('f.Communication_Preferences__r' + f.Communication_Preferences__r);
                for (Communication_Preferences__c cr: f.Communication_Preferences__r) {
                    orderMap.put(f.id, cr);
                    
                    financeActType.put(f.id, f.Honda_Brand__c + '::' + f.Finance_Account_Number__c);
                }
            }
            
            // Stop sending Text for the Suppress Finance Account (Fl_Suppress_All_Notifications__c )
            // Condition Starts
            Set < id > finId = new Set < id > ();
            for (SObject pymt: orders) {
                ChargentOrders__ChargentOrder__c co = (ChargentOrders__ChargentOrder__c)pymt;
                finId.add(co.Finance_Account_Number__c);
                if (co.Finance_Account_Number__c != NULL)finAccountNumber += co.Finance_Account_Number__c +' '; // ADDING THE FINANCE ACCOUNT NUMBER WITH SPACE
            }
            Map<id,Finance_Account__c> finSuppress = new Map<id,Finance_Account__c>([select id,Fl_Suppress_All_Notifications__c from Finance_Account__c where id in: finId]);
            // Suppress Condition ends
            
            // List of tasks to be created for every sms delivery
            List <Task> tasks = new List <Task>();
            
            For(SObject pymt: orders) {
                ChargentOrders__ChargentOrder__c co = (ChargentOrders__ChargentOrder__c)pymt;
                ChargentOrders__ChargentOrder__c oldCo;
                if (Trigger.isUpdate && Trigger.isAfter) {
                    oldCo = (ChargentOrders__ChargentOrder__c)oldOrderMap.get(co.Id);
                }
                
                if(Trigger.isAfter) {       
                    
                    Communication_Preferences__c cp;
                    // NotificationTextMsgs__c msgTemplate = null;
                    String MessageType = '';
                    Task task = new Task();
                    
                    if (orderMap.containsKey(co.Finance_Account_Number__c)) {
                        cp = orderMap.get(co.Finance_Account_Number__c);
                    }
                    if (financeActType.containsKey(co.Finance_Account_Number__c)) {
                        String afsHfsFlg = financeActType.get(co.Finance_Account_Number__c).split('::')[0];
                        String finAccNumber = financeActType.get(co.Finance_Account_Number__c).split('::')[1];
                        if (finAccNumber != null && finAccNumber.length() > 4) {
                            finAccNumber = finAccNumber.substring(finAccNumber.length() - 4);
                            system.debug('SMS subscribe : ' + cp.Payment_Confirmations_via_Text__c + ' Payment type ' + co.Payment_Type__c);
                            
                            
                            //Start searching for correct template
                            if(!finSuppress.get(co.Finance_Account_Number__c).Fl_Suppress_All_Notifications__c || finSuppress.get(co.Finance_Account_Number__c).Fl_Suppress_All_Notifications__c==null) {  // Check the Finance Account is not Suppress
                                if ((co.ChargentOrders__Payment_Status__c == 'Recurring' || co.ChargentOrders__Payment_Status__c == 'Complete') && co.ChargentOrders__Payment_Frequency__c == 'Once' && co.Payment_Type__c != 'P' && cp.Payment_Confirmations_via_Text__c) {
                                    
                                    if (Trigger.isInsert && Trigger.isAfter) {
                                        MessageType = (afsHfsFlg != 'AFS') ? 'ScheduledPaymentHonda' : 'ScheduledPaymentAcura';
                                        
                                    } else if (Trigger.isUpdate && Trigger.isAfter && (co.ChargentOrders__Charge_Amount__c != oldCo.ChargentOrders__Charge_Amount__c || co.Payment_Source_Nickname__c != oldCo.Payment_Source_Nickname__c || co.ChargentOrders__Payment_Start_Date__c != oldCo.ChargentOrders__Payment_Start_Date__c || co.Payment_Display_Status__c  != oldCo.Payment_Display_Status__c)) {
                                        
                                        //Check if the One time payment is cancelled
                                        if (co.Payment_Display_Status__c == 'Cancelled' && oldCo.Payment_Display_Status__c != 'Cancelled') {
                                            MessageType = (afsHfsFlg != 'AFS') ? 'CancelledOTPHonda' : 'CancelledOTPAcura';
                                            
                                        } else {
                                            MessageType = (afsHfsFlg != 'AFS') ? 'ModifiedPaymentHonda' : 'ModifiedPaymentAcura';
                                            
                                        }
                                    }
                                } else if ((co.ChargentOrders__Payment_Status__c == 'Recurring' || co.ChargentOrders__Payment_Status__c == 'Stopped' || co.ChargentOrders__Payment_Status__c == 'Complete') && co.ChargentOrders__Payment_Frequency__c == 'Monthly' && cp.EasyPay_Communications_via_Text__c) {
                                    system.debug('Condition Matched');
                                    if (Trigger.isInsert && Trigger.isAfter) {
                                        MessageType = (afsHfsFlg != 'AFS') ? 'CreatedEasyPayHonda' : 'CreatedEasyPayAcura';
                                        
                                    } else if (Trigger.isUpdate && Trigger.isAfter && (co.ChargentOrders__Charge_Amount__c != oldCo.ChargentOrders__Charge_Amount__c || co.Payment_Source_Nickname__c != oldCo.Payment_Source_Nickname__c || co.ChargentOrders__Payment_Start_Date__c != oldCo.ChargentOrders__Payment_Start_Date__c || co.Payment_Display_Status__c  != oldCo.Payment_Display_Status__c)) {
                                        //Check if the One time payment is cancelled
                                        
                                        if (co.Payment_Display_Status__c == 'Cancelled' && oldCo.Payment_Display_Status__c != 'Cancelled') {
                                            MessageType = (afsHfsFlg != 'AFS') ? 'CancelledEasyPayHonda' : 'CancelledEasyPayAcura';
                                            
                                        } else if (co.Payment_Display_Status__c == 'Suspended' && oldCo.Payment_Display_Status__c != 'Suspended') {
                                            MessageType = (afsHfsFlg != 'AFS') ? 'SuspendedEasyPayHonda' : 'SuspendedEasyPayAcura';
                                            
                                        } else {
                                            MessageType = (afsHfsFlg != 'AFS') ? 'ModifiedEasyPayHonda' : 'ModifiedEasyPayAcura';
                                            
                                        }
                                    }
                                } else if ((co.ChargentOrders__Payment_Status__c == 'Recurring' || co.ChargentOrders__Payment_Status__c == 'Complete') && co.ChargentOrders__Payment_Frequency__c == 'Once' && co.Payment_Type__c == 'P' && cp.Payment_Confirmations_via_Text__c) {
                                    
                                    if (Trigger.isInsert && Trigger.isAfter) {
                                        MessageType = (afsHfsFlg != 'AFS') ? 'CreatedPayOffHonda' : 'CreatedPayOffAcura';
                                        
                                    } else if (Trigger.isUpdate && Trigger.isAfter && (co.ChargentOrders__Charge_Amount__c != oldCo.ChargentOrders__Charge_Amount__c || co.Payment_Source_Nickname__c != oldCo.Payment_Source_Nickname__c || co.ChargentOrders__Payment_Start_Date__c != oldCo.ChargentOrders__Payment_Start_Date__c || co.Payment_Display_Status__c  != oldCo.Payment_Display_Status__c)) {
                                        //Check if the One time payment is cancelled
                                        if (co.Payment_Display_Status__c == 'Cancelled' && oldCo.Payment_Display_Status__c != 'Cancelled') {
                                            MessageType = (afsHfsFlg != 'AFS') ? 'CancelledPayOffHonda' : 'CancelledPayOffAcura';
                                            
                                        } else {
                                            MessageType = (afsHfsFlg != 'AFS') ? 'ModifiedPayOffHonda' : 'ModifiedPayOffAcura';
                                            
                                            
                                        }
                                    }
                                }
                                NotificationTextMsgs__c msgTemplate = null;
                               AHFC_Payment__mdt paymt = [SELECT EasyPay_Cancelled__c,EasyPay_Suspended__c,
                                                          Payment_Cancelled__c,Payment_Confirmation__c,
                                                          Payment_Updated__c,EasyPay_Updated__c,
                                                          EasyPay_Created__c,PayOff_Cancelled__c, 
                                                          PayOff_Updated__c, PayOff_Created__c FROM AHFC_Payment__mdt];      
                                
                                switch on MessageType {
                                    when 'ScheduledPaymentHonda' {		
                                        msgTemplate = NotificationTextMsgs__c.getValues('ScheduledPaymentHonda');
                                        task.Subject = paymt.Payment_Confirmation__c;
                                        
                                    }	
                                    when 'ScheduledPaymentAcura' {		
                                        msgTemplate = NotificationTextMsgs__c.getValues('ScheduledPaymentAcura');
                                        task.Subject = paymt.Payment_Confirmation__c;
                                    }
                                    when 'CancelledOTPHonda' {		
                                        msgTemplate = NotificationTextMsgs__c.getValues('CancelledOTPHonda');
                                        task.Subject = paymt.Payment_Cancelled__c;
                                    }
                                    when 'CancelledOTPAcura' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('CancelledOTPAcura');
                                        task.Subject = paymt.Payment_Cancelled__c;
                                    }
                                    when 'ModifiedPaymentHonda' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('ModifiedPaymentHonda');
                                        task.Subject = paymt.Payment_Updated__c;
                                    }
                                    when 'ModifiedPaymentAcura' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('ModifiedPaymentAcura');
                                        task.Subject = paymt.Payment_Updated__c;
                                    }
                                    when 'CreatedEasyPayHonda' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('CreatedEasyPayHonda');
                                        task.Subject = paymt.EasyPay_Created__c;
                                    }
                                    when 'CreatedEasyPayAcura' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('CreatedEasyPayAcura');
                                        task.Subject = paymt.EasyPay_Created__c;
                                    }
                                    when 'CancelledEasyPayHonda' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('CancelledEasyPayHonda');
                                        task.Subject = paymt.EasyPay_Cancelled__c;
                                    }
                                    when 'CancelledEasyPayAcura' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('CancelledEasyPayAcura');
                                        task.Subject = paymt.EasyPay_Cancelled__c;
                                    }
                                    when 'SuspendedEasyPayHonda' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('SuspendedEasyPayHonda');
                                        task.Subject = paymt.EasyPay_Suspended__c;
                                    }
                                    when 'SuspendedEasyPayAcura' {		 
                                        msgTemplate = NotificationTextMsgs__c.getValues('SuspendedEasyPayAcura');
                                        task.Subject = paymt.EasyPay_Suspended__c;
                                    }
                                    when 'ModifiedEasyPayHonda' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('ModifiedEasyPayHonda');
                                        task.Subject = paymt.EasyPay_Updated__c ;
                                    }
                                    when 'ModifiedEasyPayAcura' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('ModifiedEasyPayAcura');
                                        task.Subject = paymt.EasyPay_Updated__c ;
                                    }
                                    when 'CreatedPayOffHonda' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('CreatedPayOffHonda');
                                        task.Subject = paymt.PayOff_Created__c ;
                                    }
                                    when 'CreatedPayOffAcura' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('CreatedPayOffAcura');
                                        task.Subject = paymt.PayOff_Created__c ;
                                    }
                                    when 'CancelledPayOffHonda' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('CancelledPayOffHonda');
                                        task.Subject = paymt.PayOff_Cancelled__c ;
                                    }
                                    when 'CancelledPayOffAcura' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('CancelledPayOffAcura');
                                        task.Subject = paymt.PayOff_Cancelled__c ;
                                    }
                                    when 'ModifiedPayOffHonda' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('ModifiedPayOffHonda');
                                        task.Subject = paymt.PayOff_Updated__c ;
                                    }
                                    when 'ModifiedPayOffAcura' {		  
                                        msgTemplate = NotificationTextMsgs__c.getValues('ModifiedPayOffAcura');
                                        task.Subject = paymt.PayOff_Updated__c ;
                                    }
                                    
                                    
                                }
                                
                                
                                system.debug('msgTemplate' + msgTemplate);
                                if (msgTemplate != null && cp.Text_Number__c != null) {
                                    system.debug('Is SMS sent ' + SMSTaskHelper.istriggerExecuted());
                                    if(!SMSTaskHelper.istriggerExecuted()) {
                                        
                                        String template = msgTemplate.MsgTemplate__c;
                                            
                                        if (co.Confirmation_Number__c != null && template.contains('<Con Num>')) template = template.replace('<Con Num>', co.Confirmation_Number__c); // Added for RSS 54121
                                         
                                        
                                        if(co.ChargentOrders__Payment_Start_Date__c != Null){
                                            paymentStartDate = co.ChargentOrders__Payment_Start_Date__c;
                                            yearInt = paymentStartDate.Year();
                                            yearSubString = String.valueof(yearInt).right(2);
                                            yearInt2 = Integer.valueof(yearSubString);
                                            formattedDate =  paymentStartDate.month() +'/'+paymentStartDate.day()+'/'+yearInt2 ;
                                            
                                            template = template.replace('<Payment Date>', formattedDate);
                                        }
                                        
                                        if(co.Next_Withdrawal_Date__c != Null){
                                            paymentWithdrawalDate = co.Next_Withdrawal_Date__c;
                                            yearInt = paymentWithdrawalDate.Year();
                                            yearSubString = String.valueof(yearInt).right(2);
                                            yearInt2 = Integer.valueof(yearSubString);
                                            formattedDate =  paymentWithdrawalDate.month() +'/'+paymentWithdrawalDate.day()+'/'+yearInt2 ;
                                            
                                            template = template.replace('<Next Withdrawal Date>', formattedDate); 
                                        }
                                        
                                        template = template.replace('<Payment Amount>', String.valueOf(co.ChargentOrders__Charge_Amount__c));
                                        template = template.replace('<Last 4 of Fin Acct Nmbr>', finAccNumber);
                                        
                                        list < string > mobileNumbers = new list < string > ();
                                        String mobilenum = cp.Text_Number__c;
                                        if (mobilenum != null) {
                                            mobileNum = mobileNum.replaceAll('\\(', '').replaceAll('\\)', '').replaceAll(' ', '').replaceAll('-', '');
                                            string countryCode = (mobileNum.substring(0, 1) == '1') ? '' : '1';
                                            mobileNum = countryCode + mobileNum;
                                            system.debug('Sending msg to ' + mobileNum + '. msg is ' + template);
                                        }
                                        mobileNumbers.add(mobileNum);
                                        
                                        
                                        ExactTargetService.sendSMS(mobileNumbers, true, true, template, cp.Id);
                                        //This line of code is moved to line#180 as part of RSS-41333
                                        //SMSTaskHelper.setTriggerAsExecuted();
                                        
                                        // Adding task to show the sms activity in the Notification History related list
                                        // 
                                        
                                        
                                        task.WhatId = co.Id;
                                        task.ActivityDate = Date.today();
                                        task.Description = template;
                                        task.Priority = 'Normal';
                                        task.Status = 'completed';
                                        tasks.add(task);
                                        
                                        
                                        
                                        
                                    }
                                    
                                }
                            }    
                        }
                    }
                }
            }
            //RSS-41333 Changes starts
            SMSTaskHelper.setTriggerAsExecuted();
            //RSS-41333 Changes ends
            if (!tasks.isEmpty()) {
                insert tasks;
            }      
        }
        Catch(Exception e)
        {
            system.debug('Entered into Exception handling');
            UtilityClass.logErrorResp('SMSDeliveryService', 'SMS Delivery failed', finAccountNumber, e.getmessage(), NULL  ); 
            
        }
    }
}