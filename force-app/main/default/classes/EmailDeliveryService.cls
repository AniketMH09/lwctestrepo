/*******************************************************************************************************
    * @author  : Senthil Subramani
    * @date    : 
    * @Created : 31 AUG 2016
    * @group    :  
    * @group-content : 
    * @description : The purpose of this controller is for the Email Delivery Service for the Finance Account while payment. 
                     This controller will send the email delivery to the customer email address.
                     In case of any Email delivery failures, an Error log will be created without affecting the payment.
********************************************************************************************************/

/********************** @Update History **********************
@8 October 2018 -Defect RSS-41333 by PWC Team
/********************** @Update History **********************/

Public class EmailDeliveryService {

    public static void sendPymtEmailConfirmation(List <SObject> orders, Map <Id, SObject> oldOrderMap, string insertOrUpdate){
    
    String finAccountNumber = ''; // TO PASS THE FINANCE ACCOUNT NUMBER IN ERROR LOG OBJECT 
    try{
           
        system.debug('insertOrUpdate Is  ' + insertOrUpdate);
        List<Task> tobeInsertTaskList = new List<Task> ();
        //This line of code is moved to line#57 as part of RSS-41333
       //List<Map<string, String>> newEmailMapList = new List<Map<String, String>>();
        Map<string, String> newEmailMap = new Map<String, String>();

        EmailTemplate eTemplate = null;
        String tempName = '';
        String category = 'PC';
        
        // ADD ALL FINANCE ACCOUNT NUMBER INTO THE SET 
        Set<Id> finAccNumberSet = new Set<Id>();
        List<ChargentOrders__ChargentOrder__c> chargentOrderList = new List<ChargentOrders__ChargentOrder__c>();
        
        for (SObject pymt: orders) {
            ChargentOrders__ChargentOrder__c cr = (ChargentOrders__ChargentOrder__c)pymt;
            finAccNumberSet.add(cr.Finance_Account_Number__c);
            chargentOrderList.add(cr); // ADD THE TRIGGER RECORDS IN LIST 
            if (cr.Finance_Account_Number__c != NULL)finAccountNumber += cr.Finance_Account_Number__c +' '; // ADDING THE FINANCE ACCOUNT NUMBER WITH SPACE
        }
        
        
        Map<id,Finance_Account__c> finSuppress = new Map<id,Finance_Account__c>([select id,Fl_Suppress_All_Notifications__c from Finance_Account__c where id in: finAccNumberSet]);
        
        Map<Id,Communication_Preferences__c> chargentOrderIdAndCommPreferRecMap = new Map<Id,Communication_Preferences__c>();
        // QUERY THE COMMUNICATION PREFERENCES BELONGS TO THE FINANCE ACCOUNT NUMBER.
        for (Communication_Preferences__c comm : [SELECT Id, Email_Address__c, Days_Prior_Reminder__c, Paperless_Statements_Letters__c,
                                                  Payment_Confirmations_via_Email__c, Payment_Profile_Updates_via_Email__c, EasyPay_Communications_via_Email__c,
                                                  Payment_Reminders_via_Email__c, Unsubscribe_from_all__c, IsEmailBounced__c,Finance_Account_Number__c
                                                  FROM  Communication_Preferences__c 
                                                  WHERE Finance_Account_Number__c IN :finAccNumberSet]) {
                                                  
            chargentOrderIdAndCommPreferRecMap.put(comm.Finance_Account_Number__c, comm);
        }
        
      // ITERATE THE TRIGGER RECORDS
        for (ChargentOrders__ChargentOrder__c cOrder :chargentOrderList) {
            //RSS-41333 changes starts
        	List<Map<string, String>> newEmailMapList = new List<Map<String, String>>();
           //RSS-41333 changes ends   
            ChargentOrders__ChargentOrder__c co = (ChargentOrders__ChargentOrder__c)cOrder;
             ChargentOrders__ChargentOrder__c oldCo;
             if (Trigger.isUpdate && Trigger.isAfter) {
                 oldCo = (ChargentOrders__ChargentOrder__c)oldOrderMap.get(co.Id);
                 system.debug('  &&&&&&&&&&& Got Invoked in Trigger check&&&&&&&&&&&&&');
             }
            
            if((insertOrUpdate == 'Insert') || (insertOrUpdate == 'Update' && (cOrder.ChargentOrders__Charge_Amount__c != oldCo.ChargentOrders__Charge_Amount__c || cOrder.Payment_Source_Nickname__c != oldCo.Payment_Source_Nickname__c || cOrder.ChargentOrders__Payment_Start_Date__c != oldCo.ChargentOrders__Payment_Start_Date__c || cOrder.Payment_Display_Status__c  != oldCo.Payment_Display_Status__c ))) {      
                if (cOrder != null) {
                    Communication_Preferences__c pref = new Communication_Preferences__c();
                    String operation = '';
                    
                    if(insertOrUpdate == 'Insert' && (!finSuppress.get(cOrder.Finance_Account_Number__c).Fl_Suppress_All_Notifications__c || finSuppress.get(cOrder.Finance_Account_Number__c).Fl_Suppress_All_Notifications__c ==null)){
                    
                        operation = 'Creation';
                }else if(insertOrUpdate == 'Update' && cOrder.Payment_Display_Status__c == 'Pending' && (!finSuppress.get(cOrder.Finance_Account_Number__c).Fl_Suppress_All_Notifications__c || finSuppress.get(cOrder.Finance_Account_Number__c).Fl_Suppress_All_Notifications__c ==null)){
                    
                        operation = 'Modification';                  
                    }else if(insertOrUpdate == 'Update' && cOrder.Payment_Display_Status__c == 'Cancelled' && (!finSuppress.get(cOrder.Finance_Account_Number__c).Fl_Suppress_All_Notifications__c || finSuppress.get(cOrder.Finance_Account_Number__c).Fl_Suppress_All_Notifications__c ==null)){ 
                    
                        operation = 'Cancellation';
                    }else if(insertOrUpdate == 'Update' && cOrder.Payment_Display_Status__c == 'Suspended' && (!finSuppress.get(cOrder.Finance_Account_Number__c).Fl_Suppress_All_Notifications__c || finSuppress.get(cOrder.Finance_Account_Number__c).Fl_Suppress_All_Notifications__c ==null)){
                    
                        operation = 'Suspension';
                    }
                    if ((cOrder.ChargentOrders__Payment_Status__c == 'Recurring' || cOrder.ChargentOrders__Payment_Status__c == 'Stopped' || cOrder.ChargentOrders__Payment_Status__c == 'Complete') &&         cOrder.ChargentOrders__Payment_Frequency__c == 'Monthly'){
                     
                        category ='EP';
                    }
                    pref = chargentOrderIdAndCommPreferRecMap.containsKey(cOrder.Finance_Account_Number__c)? chargentOrderIdAndCommPreferRecMap.get(cOrder.Finance_Account_Number__c) : NULL;
                    
                    if (pref != null ) {
                        
                            if (doNotify(pref, category)) {
                    
                        // Decide the template
                                            
                            if ((cOrder.ChargentOrders__Payment_Status__c == 'Recurring' || cOrder.ChargentOrders__Payment_Status__c == 'Complete') && cOrder.ChargentOrders__Payment_Frequency__c == 'Once' && cOrder.Payment_Type__c != 'P') {
                                         
                                if (cOrder.Email_Account_Brand__c != 'AFS') {
                                    tempName = 'Notify OTP ' + operation + ' Honda';
                                } else {
                                    tempName = 'Notify OTP ' + operation + ' Acura';
                                }
                              } else if ((cOrder.ChargentOrders__Payment_Status__c == 'Recurring' || cOrder.ChargentOrders__Payment_Status__c == 'Stopped' || cOrder.ChargentOrders__Payment_Status__c == 'Complete') && cOrder.ChargentOrders__Payment_Frequency__c == 'Once' && cOrder.Payment_Type__c == 'P') {
                                 
                                if (cOrder.Email_Account_Brand__c != 'AFS') {
                                    tempName = 'Notify Payoff ' + operation + ' Honda';
                                } else {
                                    tempName = 'Notify Payoff ' + operation + ' Acura';
                                }
                            } else if ((cOrder.ChargentOrders__Payment_Status__c == 'Recurring' || cOrder.ChargentOrders__Payment_Status__c == 'Stopped' || cOrder.ChargentOrders__Payment_Status__c == 'Complete') && cOrder.ChargentOrders__Payment_Frequency__c == 'Monthly') {
                                
                                if (cOrder.Email_Account_Brand__c != 'AFS') {
                                    tempName = 'Notify EasyPay ' + operation + ' Honda';
                                } else {
                                    tempName = 'Notify EasyPay ' + operation + ' Acura';
                                }
                            } else if (cOrder.ChargentOrders__Payment_Status__c == 'Recurring' && cOrder.ChargentOrders__Payment_Frequency__c == 'Once' && cOrder.Payment_Display_Status__c == 'Reversed') {
                                if (cOrder.Email_Account_Brand__c != 'AFS') {
                                    tempName = 'HFS_PREV_' + operation;
                                } else {
                                    tempName = 'AFS_PREV_' + operation;
                                }
                            }

                            if(tempName != null && tempName != '')
        
                            //Added releated value into Map for the new Email Services
                            //Added for Defect # 114093 - Email notifications being sent to wrong email address. 
                            if(pref!= null)  {
                            Finance_Account__c finAccnt = fetchFinanceDetails(cOrder.Finance_Account_Number__c);
                            if(finAccnt!= null && !string.isblank(pref.Email_Address__c) && !string.isblank(finAccnt.Customer_Name__c)){
                                newEmailMap.put('Account_Last_4__c', cOrder.Email_Finance_Account_Last_4__c);
                                newEmailMap.put('Confirmation_Number__c', cOrder.Confirmation_Number__c);
                                newEmailMap.put('Contact_Email__c', ''+pref.Email_Address__c);
                                newEmailMap.put('Contact_Lastname__c', ''+finAccnt.Customer_Name__c);
                              if(pref.Days_Prior_Reminder__c <> NULL) {   // Check if Days Prior Reminder value is set or not
                                newEmailMap.put('Days_Prior_Reminder__c', pref.Days_Prior_Reminder__c.replace('days','').replace('day','')); 
                              }
                                newEmailMap.put('Finance_Account_Number__c', cOrder.Finance_Account_Number__c);
                              if(cOrder.Next_Withdrawal_Date__c !=null)
                                newEmailMap.put('Next_Withdrawal_Date__c', String.valueof(cOrder.Next_Withdrawal_Date__c)); 
                                newEmailMap.put('Notification_Template_Name__c', tempName);
                                newEmailMap.put('Payment_Amount__c', String.valueOf(cOrder.ChargentOrders__Charge_Amount__c));
                              if(cOrder.ChargentOrders__Payment_Start_Date__c !=null)
                                 newEmailMap.put('Payment_Effective_Date__c', String.valueOf(cOrder.ChargentOrders__Payment_Start_Date__c));
                                 
                                newEmailMapList.add(newEmailMap);
                                CreateEmailMessageService.createEmailMessage(newEmailMapList);

                                Task task = new Task();
                                    task.WhatId = cOrder.id;
                                if(tempName.CONTAINS('OTP')) {
                                    if(operation == 'Creation'){
                                        task.Subject = 'Email: PAYMENT CONFIRMATION';
                                        task.Description = 'Email: PAYMENT CONFIRMATION';
                                    }else if(operation == 'Modification'){
                                        task.Subject = 'Email: PAYMENT UPDATED';
                                        task.Description = 'Email: PAYMENT UPDATED';
                                    }else if(operation == 'Cancellation'){
                                        task.Subject = 'Email:  PAYMENT CANCELLED';
                                        task.Description = 'Email:  PAYMENT CANCELLED';
                                    }
                                }else if(tempName.CONTAINS('EasyPay')) {
                                    if(operation == 'Creation'){
                                        task.Subject = 'Email: EASYPAY ENROLLMENT CONFIRMATION';
                                        task.Description = 'Email: EASYPAY ENROLLMENT CONFIRMATION';
                                    }else if(operation == 'Modification'){
                                        task.Subject = 'Email: EASYPAY UPDATED';
                                        task.Description = 'Email: EASYPAY UPDATED';
                                    }else if(operation == 'Cancellation'){
                                        task.Subject = 'Email: EASYPAY CANCELLED';
                                        task.Description = 'Email: EASYPAY CANCELLED';
                                    }else if(operation == 'Suspension'){
                                        task.Subject = 'Email: EASYPAY SUSPENDED';
                                        task.Description = 'Email: EASYPAY SUSPENDED';
                                    }
                                }else if(tempName.CONTAINS('Payoff')) {
                                    if(operation == 'Creation'){
                                        task.Subject = 'Email: PAYMENT CONFIRMATION';
                                        task.Description = 'Email: PAYMENT CONFIRMATION';
                                    }else if(operation == 'Modification'){
                                        task.Subject = 'Email: PAYMENT UPDATED';
                                        task.Description = 'Email: PAYMENT UPDATED';
                                    }else if(operation == 'Cancellation'){
                                        task.Subject = 'Email:  PAYMENT CANCELLED';
                                        task.Description = 'Email:  PAYMENT CANCELLED';
                                    }
                                }  
        
                                task.ActivityDate = Date.today();
                                task.Priority = 'Normal';
                                task.Status = 'completed';                      
                                tobeInsertTaskList.add(task);
    
                            }else if(pref!= null && string.isblank(pref.Email_Address__c)){
                                UtilityClass.logError('EmailDeliveryService','Email Address is empty in communication preference.',pref.id,'');
                            }
                            else if(pref!= null && finAccnt!= null && string.isblank(finAccnt.Customer_Name__c)){
                                UtilityClass.logError('EmailDeliveryService','No Customer Name present in Finance Account.',finAccnt.id,'');
                            }
                        }
                     }
                    }else {
                         UtilityClass.logError('EmailDeliveryService', 'No comm preference has been set for the customer', finAccountNumber , 'Error Log creation for No comm preference');
                    }
                }else {
                     UtilityClass.logError('EmailDeliveryService', 'chargent order could not be found or notification is disabled', finAccountNumber , 'Error Log creation for chargent order could not be found or notification is disabled');
                }
            }
        }
            if(tobeInsertTaskList != NULL && tobeInsertTaskList.size() > 0){
                insert tobeInsertTaskList;
            }    
        }catch(Exception e)
        {
         UtilityClass.logError('EmailDeliveryService', 'Send Email confirmation Delivery failed', finAccountNumber, 'Email Delivery Failed');
        }
    }
    
    //Added for Defect # 114093 - Email notifications being sent to wrong email address.    
    private static Finance_Account__c fetchFinanceDetails(ID finId){
        List<Finance_Account__c> finAccnts = [Select Customer_Name__c from Finance_Account__c where id =:finId];
        if(finAccnts!= null && finAccnts.size()>0)
        return finAccnts[0];
        return null;
    }
    
    public static boolean doNotify(Communication_Preferences__c pref, String category) {

        if (pref == null || pref.Unsubscribe_from_all__c || pref.Email_Address__c == null) return false;
        // stop emailing when payment confirmation email is false
        else if (category == 'PC' && !pref.Payment_Confirmations_via_Email__c) return false;
        else if (category == 'EP' && !pref.EasyPay_Communications_via_Email__c) return false;
        else return true;
    }
}