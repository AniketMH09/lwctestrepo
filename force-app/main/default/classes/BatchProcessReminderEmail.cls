global class BatchProcessReminderEmail implements Database.batchable<sObject>{

   global String query;
   global Map<string, String> newEmailMap = new Map<String, String>();
   

   global Database.Querylocator start (Database.BatchableContext SC)
   {   
        Date tendaysfromtoday = system.today().adddays(10); 
        query = 'SELECT id,Days_Prior_Reminder__c, Finance_Account_Number__c, Finance_Account_Number__r.Fl_Suppress_All_Notifications__c, Finance_Account_Number__r.Payment_Due_Date__c, Finance_Account_Number__r.Finance_Account_Number__c,Payment_Confirmations_via_Text__c,Payment_Reminders_via_Email__c, Email_Address__c, Text_Number__c, Payment_Reminders_via_Text__c, Email_Finance_Account_Last_4__c, Finance_Account_Number__r.Honda_Brand__c FROM Communication_Preferences__c where (Payment_Reminders_via_Email__c=true) and Finance_Account_Number__r.Payment_Due_Date__c> TODAY and Unsubscribe_from_all__c=false';
        return Database.getQueryLocator(query);
   }     

   global void execute(Database.BatchableContext SC,List<Communication_Preferences__c> RC) {
   
        List<String> accNos = new List<String>();
        map<String,Finance_Account__c> preferenceMap = new map<String,Finance_Account__c>();
            
        
        // Get Finance account preference details for SMS subscribed users
        for(Communication_Preferences__c  comnpref :RC){
        List<Map<string, String>> newEmailMapList = new List<Map<String, String>>(); 
            
            if(comnpref.Finance_Account_Number__r.Payment_Due_Date__c!=null && comnpref.Days_Prior_Reminder__c != null){
                
                // Formatting and finding the number of days left for payment
                Datetime dT= comnpref.Finance_Account_Number__r.Payment_Due_Date__c;
               
                Integer nodays = system.today().daysBetween(comnpref.Finance_Account_Number__r.Payment_Due_Date__c);
                
                // Checking if number of days left for payment and reminder preference choise of days
                if(Integer.valueof((comnpref.Days_Prior_Reminder__c).replace('days','').replace('day','')) == nodays){
                    if(!comnpref.Finance_Account_Number__r.Fl_Suppress_All_Notifications__c || comnpref.Finance_Account_Number__r.Fl_Suppress_All_Notifications__c==null) {
                        if(comnpref.Payment_Reminders_via_Email__c){
                             Finance_Account__c account = [SELECT Id, Customer_Name__c,Finance_Account_Number__c, Honda_Brand__c ,Customer__r.Customer__c,Total_Amount_Due__c from Finance_Account__c where Id = :comnpref.Finance_Account_Number__c];
                            
                            // Defect 112915 & 113319 - contact needs to be retrived from finance account via customer_finance_account object
                            //Contact customer = PaymentEmailNotificationController.getContactByFinAcc(account.Id, null,'BatchProcessReminderEmail - Execute Method');

                            // Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                             String tempName = '';
                              if(account.Honda_Brand__c != 'AFS')
                              {
                                  tempName = 'Remind Payment Due'+' '+'Honda';
                              }
                              else
                                  tempName = 'Remind Payment Due'+' '+'Acura';
                             
                             //Added check for Defect # 114093
                              if (!string.isblank(comnpref.Email_Address__c) && account!= null && !string.isblank(account.Customer_Name__c)) {         
                                                                                        
                        //Added required value into List            
                        newEmailMap.put('Days_Prior_Reminder__c', comnpref.Days_Prior_Reminder__c.replace('days','').replace('day',''));
                        //Modified for defect 114093 - Starts
                        newEmailMap.put('Contact_Lastname__c', ''+account.Customer_Name__c);
                        newEmailMap.put('Contact_Email__c', ''+comnpref.Email_Address__c);  
                        //Modified for defect 114093 - Ends
                        newEmailMap.put('Payment_Amount__c', ''+String.valueOf(account.Total_Amount_Due__c));
                        newEmailMap.put('Account_Last_4__c', ''+comnpref.Email_Finance_Account_Last_4__c);
                        newEmailMap.put('Notification_Template_Name__c', tempName);  
                        newEmailMap.put('Finance_Account_Number__c', comnpref.Finance_Account_Number__c);                  
            
                        newEmailMapList.add(newEmailMap);
                        CreateEmailMessageService.createEmailMessage(newEmailMapList);
                        //Added check for Defect # 114093
                        if(comnpref.Email_Address__c!= null){
                            Task task = new Task();
                            task.WhatId = comnpref.Finance_Account_Number__c;
                            task.Subject = 'Email: PAYMENT REMINDER';
                            task.Description = 'Email: PAYMENT REMINDER';
                            //task.WhoId = customer.id;
                            task.ActivityDate = Date.today();
                            task.Priority = 'Normal';
                            task.Status = 'completed';
                            insert task;
                        }
                       }else{
                                  System.debug(System.LoggingLevel.ERROR, 'SendPymtEmailReminder - Could not find contact / prefere with the email address');
                                  //Logging error as part of Defect # 114093
                                  if(string.isblank(comnpref.Email_Address__c)){
                                    UtilityClass.logError('BatchProcessReminderEmail','The email is empty in Communication_Preferences__c. ',comnpref.id,'');  
                                  }else if(account!= null && string.isblank(account.Customer_Name__c)){
                                    UtilityClass.logError('BatchProcessReminderEmail','The Customer Name is empty in Finance Account. ',account.id,'');  
                                  }
                                  
                              }  
                        }
                    }   
                }
            }
            
        }
                 
    }
    
   global void finish(Database.BatchableContext SC) 
   {
        try
        {
            // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
            // Query the AsyncApexJob object to retrieve the current job's information.       
            AsyncApexJob a = [  Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:SC.getJobId()];
            //Send an email to the Apex job's submitter notifying of job completion.       
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();      
            //String[] toAddresses = new String[] {a.CreatedBy.Email, 'baljinder.sandhu@accenture.com'};
            
            String emailLabel = Label.Batch_Notification_Emails;

            String[] toAddresses = new String[] {a.CreatedBy.Email};
            // Comma seperated values in Label Batch_Notification_Emails
            // Add each value to the toAddresses 
            for(String s : emailLabel.split(','))
            {
                toAddresses.add(s);
            }
            
            // setToAddresses sends email to the email addresses in toAddresses 
            mail.setToAddresses(toAddresses); 
            mail.setSubject('BatchProcessReminderEmail Processed ' + a.Status);
            mail.setPlainTextBody('The Batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }
        catch(System.Exception ex)
        {
   
        }   
   } 
    
}