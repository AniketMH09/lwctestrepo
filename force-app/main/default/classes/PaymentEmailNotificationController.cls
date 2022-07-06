/*******************************************************************************************************
    * @author  : Accenture
    * @date    :  JAN 18 2016
    * @modified : 12 AUG 2016 
    * @group    :  
    * @group-content : 
    * @description : THIS CLASS SENDS EMAIL NOTIFICATIONS TO CUSTOMERS BASED ON THE OPERATION PERFORMED
                     ON PAYMENT,BANK ACCOUNT, COMMUNICATION PREFERENCE RECORDS
********************************************************************************************************/
public class PaymentEmailNotificationController {
          
        /******************************************************************************************************
                 SENDS EMAIL FOR THE BANK ACCOUNT CONFIRMATION    
        *******************************************************************************************************/
        public static void sendBankAccEmailConfirmation(Payment_Source__c src, String operation) {

            List<Map<string, String>> newEmailMapList = new List<Map<String, String>>();
            Map<string, String> newEmailMap = new Map<String, String>();

            system.debug('Inside PaymentNotification ' + src);
            system.debug('Inside PaymentNotification12 ' + operation);
            EmailTemplate eTemplate = null;
            String tempName = '';
            //Removed contact reference for defect # 114261
            //Contact c = null;
            String category = 'BA';
            Communication_Preferences__c pref = null;

            if (src != null) {
                List < Communication_Preferences__c > prefs = [Select Id, Email_Address__c, Days_Prior_Reminder__c, Paperless_Statements_Letters__c,
                Payment_Confirmations_via_Email__c, Payment_Profile_Updates_via_Email__c,
                Payment_Reminders_via_Email__c,EasyPay_Communications_via_Email__c, Unsubscribe_from_all__c, IsEmailBounced__c
                from Communication_Preferences__c
                where Finance_Account_Number__c = : src.Finance_Account_Number__c limit 1];

                if (prefs != null && prefs.size() > 0) {
                    pref = prefs[0];
                    System.debug('Prefs exists - doNotify Result - ' + doNotify(pref, category));
                    if (doNotify(pref, category)) {
                        // Decide the template
                        if (src.Email_Account_Brand__c != 'AFS') {
                            tempName = 'Notify Bank Account ' + operation + ' Honda';
                        } else {
                            tempName = 'Notify Bank Account ' + operation + ' Acura';
                        }
                        
                        System.debug('Template Name - ' + tempName);

                     //   eTemplate = [select id from EmailTemplate where developerName = : tempName];

                        // Retreieve Contact from chargent order for setting TargetObject
                        //c = getContactByFinAcc(src.Finance_Account_Number__c, pref,'sendBankAccEmailConfirmation');
                        //Added for Defect # 114093 - Email notifications being sent to wrong email address.    
                        if(pref!= null){
                        Finance_Account__c finAccnt = fetchFinanceDetails(src.Finance_Account_Number__c);
                        if(finAccnt!= null && !string.isblank(pref.Email_Address__c) && !string.isblank(finAccnt.Customer_Name__c)){
                            newEmailMap.put('Account_Last_4__c', src.Email_Finance_Account_Last_4__c);
                            newEmailMap.put('Contact_Email__c', ''+pref.Email_Address__c);
                            newEmailMap.put('Contact_Lastname__c', ''+finAccnt.Customer_Name__c);
                            newEmailMap.put('Finance_Account_Number__c', src.Finance_Account_Number__c);
                            newEmailMap.put('Notification_Template_Name__c', tempName);
                            
                            newEmailMapList.add(newEmailMap);
                            system.debug('List Values------>' + newEmailMapList);
                           
                            CreateEmailMessageService.createEmailMessage(newEmailMapList);  
                            //Removed contact reference for defect # 114261
                            //if(c!= null){
                            Task task = new Task();
                                task.WhatId = src.id;
                            if(operation == 'Addition'){    
                                task.Subject = 'Email: PAYMENT PROFILE UPDATED';
                                task.Description = 'Email: PAYMENT PROFILE UPDATED';
                            }else if(operation == 'Deletion'){    
                                task.Subject = 'Email: PAYMENT PROFILE UPDATED';
                                task.Description = 'Email: PAYMENT PROFILE UPDATED';
                            }        
                                //task.WhoId = c.id;
                                task.ActivityDate = Date.today();
                                task.Priority = 'Normal';
                                task.Status = 'completed';
                            insert task;                
                            //}
                            system.debug('New Email Service method Called');                    
                        }else if(pref!= null && string.isblank(pref.Email_Address__c)){
                            UtilityClass.logError('PaymentEmailNotificationController','Email Address is empty in communication preference.',pref.id,'');
                        }
                        else if(pref!= null && finAccnt!= null && string.isblank(finAccnt.Customer_Name__c)){
                            UtilityClass.logError('PaymentEmailNotificationController','No Customer Name present in Finance Account.',finAccnt.id,'');
                        }
                    }
                        
                        //System.debug('Contact  - ' + c);

                        // if(c != null)
                        //    doSendEmail(c.Id, src.Id, eTemplate.Id, src.Email_Account_Brand__c);
                         }
                } else {
                    System.debug(System.LoggingLevel.DEBUG, 'PaymentEmailNotificationController - No comm preference has been set for the customer');
                }
            } else {
                System.debug(System.LoggingLevel.DEBUG, 'PaymentEmailNotificationController - Bank account could be found or notification is disabled');
            }
        }
        
        
        /*******************************************************************************************************
               SENDS EMAIL CONFIRMATION WHEN USER SAVES THE COMMUNICATION PREFERENCE      
        *******************************************************************************************************/
        public static void sendCommPrefConfirmation(Communication_Preferences__c pref, String operation) {

            List<Map<string, String>> newEmailMapList = new List<Map<String, String>>();
            Map<string, String> newEmailMap = new Map<String, String>();

            EmailTemplate eTemplate = null;
            String tempName = '';
            //Removed contact reference for defect # 114261
            //Contact c = null;
            String category = 'CP';
            system.debug('Inside ComPref Confirmation Email Handler');
            if (pref != null && doNotify(pref, category)) {
                if (pref.Email_Account_Brand__c != 'AFS') {
                       tempName = 'Notify Comm Pref ' + operation + ' Honda';
                       //tempName = 'HFS_EP_SUSPEND' + operation;                     
                       //  tempName ='HFS_EP_SUSPEND'+ operation;  
                } else {
                    tempName = 'Notify Comm Pref ' + operation + ' Acura';
                }

              //  eTemplate = [select id from EmailTemplate where developerName = : tempName_task];

                // Retreieve Contact from chargent order for setting TargetObject
                //c = getContactByFinAcc(pref.Finance_Account_Number__c, pref,'sendCommPrefConfirmation');
                //Added for Defect # 114093 - Email notifications being sent to wrong email address.    
                if(pref!=null){
                    Finance_Account__c finAccnt = fetchFinanceDetails(pref.Finance_Account_Number__c);
                    if(finAccnt!= null && !string.isblank(pref.Email_Address__c) && !string.isblank(finAccnt.Customer_Name__c)){
                        //Added releated value into Map for the new Email Services
                        newEmailMap.put('Account_Last_4__c', pref.Email_Finance_Account_Last_4__c);
                        //newEmailMap.put('Contact__c', ''+c.id);
                        newEmailMap.put('Contact_Email__c', ''+pref.Email_Address__c);
                        newEmailMap.put('Contact_Lastname__c', ''+finAccnt.Customer_Name__c);
                        newEmailMap.put('Finance_Account_Number__c', pref.Finance_Account_Number__c);
                        newEmailMap.put('Notification_Template_Name__c', tempName);
                        newEmailMapList.add(newEmailMap);
                        CreateEmailMessageService.createEmailMessage(newEmailMapList);
                        if(pref.Email_Address__c!=null){
                            Task task = new Task();
                            task.WhatId = pref.id;
                            task.Subject = 'Email: COMMUNICATION PREFERENCES SAVED';
                            task.Description = 'Email: COMMUNICATION PREFERENCES SAVED';
                            //task.WhoId = c.id;
                            task.ActivityDate = Date.today();
                            task.Priority = 'Normal';
                            task.Status = 'completed';
                            insert task;    
                        }                        
                    }else if(pref!= null && string.isblank(pref.Email_Address__c)){
                            UtilityClass.logError('PaymentEmailNotificationController','Email Address is empty in communication preference.',pref.id,'');
                    }else if(pref!= null && finAccnt!= null && string.isblank(finAccnt.Customer_Name__c)){
                            UtilityClass.logError('PaymentEmailNotificationController','No Customer Name present in Finance Account.',finAccnt.id,'');
                    } 
                }
                //if(c != null)
                //    doSendEmail(c.Id, pref.Id, eTemplate.Id, pref.Email_Account_Brand__c);

                } else {
                System.debug(System.LoggingLevel.ERROR, 'PaymentEmailNotificationController - Comm Preference could be found or notification is disabled');
            }
        }

        /*******************************************************************************************************
               SENDS EMAIL WHEN USER CLICKS ON UNSUBSCRIBE IN THE COMMUNICATION PREFERENCES      
        *******************************************************************************************************/
            public static void sendCommPrefConfirmationforUnsubscribe(Communication_Preferences__c pref, String operation) {

            List<Map<string, String>> newEmailMapList = new List<Map<String, String>>();
            Map<string, String> newEmailMap = new Map<String, String>();

            EmailTemplate eTemplate = null;
            String tempName = '';
                //Removed contact reference for defect # 114261
            //Contact c = null;
            String category = 'CP';
            if (pref != null ) {
                if (pref.Email_Account_Brand__c != 'AFS') {
                       tempName = 'Notify ' + operation + ' from All Honda';
                } else {
                    tempName = 'Notify ' + operation + ' from All Acura';
                }

              //  eTemplate = [select id from EmailTemplate where developerName = : tempName];

                // Retreieve Contact from chargent order for setting TargetObject
                //c = getContactByFinAcc(pref.Finance_Account_Number__c, pref,'sendCommPrefConfirmationforUnsubscribe');

                //Added for Defect # 114093 - Email notifications being sent to wrong email address.    
                Finance_Account__c finAccnt = fetchFinanceDetails(pref.Finance_Account_Number__c);
                if(finAccnt!= null && !string.isblank(pref.Email_Address__c) && !string.isblank(finAccnt.Customer_Name__c)){
                        //Added releated value into Map for the new Email Services
                        newEmailMap.put('Account_Last_4__c', pref.Email_Finance_Account_Last_4__c);
                        newEmailMap.put('Contact_Email__c', ''+pref.Email_Address__c);
                        newEmailMap.put('Contact_Lastname__c', ''+finAccnt.Customer_Name__c);
                        newEmailMap.put('Finance_Account_Number__c', pref.Finance_Account_Number__c);
                        newEmailMap.put('Notification_Template_Name__c', tempName);
                        newEmailMapList.add(newEmailMap);
                        system.debug('List Values------>' + newEmailMapList);
                        CreateEmailMessageService.createEmailMessage(newEmailMapList);
                        if(pref.Email_Address__c!= null){
                            Task task = new Task();
                            task.WhatId = pref.id;
                            task.Subject = 'Email: COMMUNICATION PREFERENCES UPDATED';
                            task.Description = 'Email: COMMUNICATION PREFERENCES UPDATED';
                            //task.WhoId = c.id;
                            task.ActivityDate = Date.today();
                            task.Priority = 'Normal';
                            task.Status = 'completed';
                            insert task;
                        }
                        system.debug('New Email Service method Called');            
                    }else if(pref!= null && string.isblank(pref.Email_Address__c)){
                            UtilityClass.logError('PaymentEmailNotificationController','Email Address is empty in communication preference.',pref.id,'');
                    }else if(pref!= null && finAccnt!= null && string.isblank(finAccnt.Customer_Name__c)){
                            UtilityClass.logError('PaymentEmailNotificationController','No Customer Name present in Finance Account.',finAccnt.id,'');
                    }
                
                // if(c != null)
                //    doSendEmail(c.Id, pref.Id, eTemplate.Id, pref.Email_Account_Brand__c);

            } else {
                System.debug(System.LoggingLevel.ERROR, 'PaymentEmailNotificationController - Bank account could be found or notification is disabled');
            }
        }
        
        /*******************************************************************************************************
                     SENDS EMAIL TO THE TARGET ID WITH THE PROVIDED TEMPLATE
        *******************************************************************************************************/
        public static void doSendEmail(Id targetObjId, Id whatId, Id templateId, String brand) {
           Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            system.debug('Sending mail .. ' + targetObjId);
            system.debug('Sending mail .. ' + whatId);
            system.debug('Sending mail .. ' + templateId);
            Contact contact = [SELECT Id, Name, Email, IsEmailBounced, EmailBouncedReason FROM Contact WHERE Id = :targetObjId];

            if (contact != null) {
                

                
                /*
                String[] sendToBccAdd = new String[] {
                    'sankalan.ghorai@accenture.com'
                };
                message.setBccAddresses(sendToBccAdd); */
                message.setTargetObjectId(contact.Id);
                message.setTreatTargetObjectAsRecipient(true);
                message.setWhatId(whatId);
                message.setTemplateId(templateId);

                message.setSaveAsActivity(true);
                //message.setReplyTo('do_not_reply@americanhondafinancecorp.com');
                //message.setSenderDisplayName('American Honda Finance Corp');
                OrgWideEmailAddress[] addresses = [select Id, DisplayName, Address from OrgWideEmailAddress];
                
                // Use Organization Wide Address  
          for(OrgWideEmailAddress owa : addresses) 
                {
            System.debug('doSendEmail - ' + owa.DisplayName);
                    if(brand != 'AFS' && owa.DisplayName == 'do_not_reply@hondafinancialservices.com')
                    {
                        message.setOrgWideEmailAddressId(owa.Id);
                    }
                    else if(brand == 'AFS' && owa.DisplayName == 'do_not_reply@acurafinancialservices.com')
                    {
                        message.setOrgWideEmailAddressId(owa.Id);
                    }
                }
                
                if(addresses == null || addresses.size() < 1)
                {
                    message.setReplyTo('do_not_reply@americanhondafinancecorp.com');
                  message.setSenderDisplayName('American Honda Finance Corp');
                }

                System.debug(System.LoggingLevel.DEBUG, 'PaymentEmailNotificationController - Email values entered - targetObjId - ' + targetObjId + ' - whatId - ' + whatId + ' - templateId - ' + templateId);

                List < Messaging.SingleEmailMessage > messages = new List < Messaging.SingleEmailMessage > ();
                messages.add(message);
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages, false);

                if (results[0].isSuccess()) {
                    System.debug(System.LoggingLevel.DEBUG, 'doSendEmail - Email delivery successful');
                } else {
                    System.debug(System.LoggingLevel.ERROR, 'PaymentEmailNotificationController - Email delivery failed - ' + results[0].getErrors()[0].getMessage());
                }
            } else {
                System.debug(System.LoggingLevel.ERROR, 'PaymentEmailNotificationController - Could not find contact with the email address');
            }
        }

        public static boolean doNotify(Communication_Preferences__c pref, String category) {
            system.debug('Category is ' + category);
            system.debug('Payment_Confirmations_via_Email__c'  + pref.Payment_Confirmations_via_Email__c);
            system.debug('EasyPay_Communications_via_Email__c' + pref.EasyPay_Communications_via_Email__c);
            
           
            
            
            if (pref == null || pref.Unsubscribe_from_all__c || pref.Email_Address__c == null) return false;
            // stop emailing when payment confirmation email is false
            else if (category == 'PC' && !pref.Payment_Confirmations_via_Email__c) return false;
            else if (category == 'EP' && !pref.EasyPay_Communications_via_Email__c) return false;
            else if (category == 'REM' && !pref.Payment_Reminders_via_Email__c) return false;
            else if (category == 'PP' && !pref.Payment_Profile_Updates_via_Email__c) return false;
            else if (category == 'BA' && !pref.Payment_Profile_Updates_via_Email__c) return false;
            else if (category == 'CP' && !pref.Payment_Profile_Updates_via_Email__c) return false;
            else return true;
        }
        
        
        /*******************************************************************************************************
                     FETCHES THE CONTACTS ASSOCIATED WITH A FINANCE ACCOUNT
        *******************************************************************************************************/
        Public static Contact getContactByFinAcc(Id finId, Communication_Preferences__c pref, String MethodName) {
            
            // DEFECT 114130 03 MAY 2016 by TIRU, QUERY EXCEPTION FIX & ADDED EXCEPTION LOG
            
            Set<id> AccountIds = new Set<Id>();
            Contact ContactRec = new Contact();
            Integer Count = 0;                                              
            String AccountId;
                
            try{
             
                //QUERY THE CUSTOMER FINANCE ACCOUNTS
                List<Customer_Finance_Account__c> accounts = [SELECT Id, Customer__c, Customer__r.id, Customer__r.personemail, customer__r.Customer_Number__c, 
                                                                  Finance_Account__c, Finance_Account__r.Finance_Account_Number__c, Finance_Account_Number__c
                                                              FROM Customer_Finance_Account__c 
                                                              WHERE Finance_Account__c =:finId AND (customer__r.customer_number__c != NULL AND customer__r.customer_number__c != '') ];
                
                for(Customer_Finance_Account__c CustomerFinAccount : Accounts) {                
                    if(CustomerFinAccount.Finance_Account__r.Finance_Account_Number__c.right(12) == CustomerFinAccount.customer__r.Customer_Number__c.right(12)){
                        if(count < 1){
                            AccountId = CustomerFinAccount.Customer__r.id;
                        }
                        count = count + 1;    
                    }        
                }
    
                
                if(AccountId != Null){
                   // DEFECT 114130 03 MAY 2016 by TIRU - QUERY EXCEPTION FIX
                   List<Contact> ContactList = [SELECT Id, Name, Email, Lastname FROM Contact WHERE AccountId = : AccountId and Email != Null];  
                    
                    if( !ContactList.isEmpty() ) {
                        
                        return ContactList[0];
                                
                    } else {
                     
                        UtilityClass.logErrorResp('Class: PaymentEmailNotificationController : ' + MethodName,  ' Contact Email is NULL ' ,  finId , AccountId , NULL );
                        return null;   
                    }
                    // End of Defect:114130 
                } else {
                    return null;  
                }       
                
                /*
                if(Count > 1){
                    System.debug('Class: PaymentEmailNotificationController : '+MethodName + 'Duplicate Customer has been identified for Finance Account : '+ finId+'Communication Preference ID :'+ pref.Id );
                    //Commenting the below line since this method is called from batch class and to avoid the DML Exception.
                    //UtilityClass.logError('Class: PaymentEmailNotificationController : '+MethodName, 'Duplicate Customer has been identified for Finance Account', finId, pref.Id );
                }     
                */    
 
            } catch(Exception e) {            
                
                Utilityclass.logErrorResp('Class: PaymentEmailNotificationController : ' + MethodName, ' getContactByFinAcc ' , finId , AccountId , e.getStackTraceString() );
                return null;
           }
        }
        //Added for Defect # 114093 - Email notifications being sent to wrong email address.    
        private static Finance_Account__c fetchFinanceDetails(ID finId){
            List<Finance_Account__c> finAccnts = [Select Customer_Name__c from Finance_Account__c where id =:finId];
            if(finAccnts!= null && finAccnts.size()>0)
                return finAccnts[0];
            return null;
        }
    }