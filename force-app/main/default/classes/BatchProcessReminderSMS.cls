global class BatchProcessReminderSMS implements Database.batchable<sObject>, Database.allowscallouts{

   global String query;
   global Map<string, String> newEmailMap = new Map<String, String>();
 

   global Database.Querylocator start (Database.BatchableContext SC)
   {   
       	Date tendaysfromtoday = system.today().adddays(10); 
       	query = 'SELECT id,Days_Prior_Reminder__c, Finance_Account_Number__c, Finance_Account_Number__r.Fl_Suppress_All_Notifications__c, Finance_Account_Number__r.Payment_Due_Date__c, Finance_Account_Number__r.Finance_Account_Number__c,Payment_Confirmations_via_Text__c,Payment_Reminders_via_Email__c, Email_Address__c, Text_Number__c, Payment_Reminders_via_Text__c, Email_Finance_Account_Last_4__c, Finance_Account_Number__r.Honda_Brand__c FROM Communication_Preferences__c where (Payment_Reminders_via_Text__c = true ) and Finance_Account_Number__r.Payment_Due_Date__c> TODAY and Unsubscribe_from_all__c=false';
       	return Database.getQueryLocator(query);
   }     

   global void execute(Database.BatchableContext SC,List<Communication_Preferences__c> RC) {
   
        List<String> accNos = new List<String>();
        map<String,Finance_Account__c> preferenceMap = new map<String,Finance_Account__c>();
        List<task> tskList = new List<task>();
        List<MC_Notification__c> mcRecList=new List<MC_Notification__c>();
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
                        if(comnpref.Payment_Reminders_via_Text__c){
                            // formatting mobile number and adding to list
                           
                           /* List<string> moblist = new List<string>();
                            moblist.add(formatMobile(comnpref.Text_Number__c));
                             // Commenting this code for DSX on 30/03/2018
                            //Composing msg template
                            NotificationTextMsgs__c msgTemplate = null;
                            if(comnpref.Finance_Account_Number__r.Honda_Brand__c != 'AFS')
                            {
                                msgTemplate = NotificationTextMsgs__c.getValues('PaymentDueHonda');
                            }
                            else
                            {
                                msgTemplate = NotificationTextMsgs__c.getValues('PaymentDueAcura');
                            }
                            
                            
                            String template = msgTemplate.MsgTemplate__c;
                            template = template.replaceAll('<selected Days Prior Reminder>',String.valueof(nodays));
                            
                            String acc = comnpref.Finance_Account_Number__r.Finance_Account_Number__c;
                            template = template.replaceAll('<Last 4 of Fin Acct Nmbr>', acc.substring(acc.length()-4,acc.length()));*/                                                   
                            // Send SMS
                            if(!Test.isRunningTest())
                            {
                                /*ExactTargetService.sendSMSBatch(moblist ,true,true, template,comnpref.Id); // Senthil - Removed API key & Keyword as we using custom label now.
                               -- Commented as part of DSX Changes*/ 
                                String acc = comnpref.Finance_Account_Number__c;
                                mcRecList.add(insertMCNotificationForReminder(comnpref.Finance_Account_Number__c,
                                                                  Integer.valueOf(comnpref.Days_Prior_Reminder__c),
                                                                 acc.substring(acc.length()-4,acc.length())));
								  Task task = new Task();
                                  task.WhatId = comnpref.Finance_Account_Number__c;
                                  task.Subject = 'SMS: PAYMENT REMINDER SENT';
                                  //task.WhoId = 
                                  task.ActivityDate = Date.today();
                                  task.Description = acc.substring(acc.length()-4,acc.length());//template; template is replace with new changes as part of DSX Changes
                                  task.Priority = 'Normal';
                                  task.Status = 'completed';
                                  tskList.add(task);
                            }
                            
                            
                        }
                    }   
                }
            }
            
        }
        if(!mcRecList.isEmpty())
            insert mcRecList;
        if(!tskList.isEmpty())
        	insert tskList;
                 
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
            mail.setSubject('BatchProcessReminderSMS Processed ' + a.Status);
            mail.setPlainTextBody('The Batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }
        catch(System.Exception ex)
        {
   
        }    
   } 
    
   public String formatMobile(String mobilenum){
        
        // Formatting phone number
        if(mobilenum != null){
            mobileNum = mobileNum.replaceAll('\\(','').replaceAll('\\)','').replaceAll(' ','').replaceAll('-','');
                              string countryCode = (mobileNum.substring(0,1)=='1')?'':'1';
                              mobileNum = countryCode+mobileNum;
        }
                        
        return mobilenum;
    }
    
    public MC_Notification__c insertMCNotificationForReminder(String pFinanceAccount, Integer pDaysPriorReminder, String pAccountLast4)
        {
                MC_Notification__c mcrecord = new MC_Notification__c();
                mcrecord.Finance_Account__c = pFinanceAccount;
                mcrecord.Days_Prior_Reminder__c = pDaysPriorReminder;
                mcrecord.Account_Last_4__c = pAccountLast4;
                mcrecord.Notification_Code__c = 'Reminder';
                return mcrecord;
        }
}