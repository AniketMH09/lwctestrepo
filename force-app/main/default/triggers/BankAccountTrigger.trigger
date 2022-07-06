/******************************************************************************************************* 
* @modified : 16 June 2019 
* @modified by : Rajeshwar Patel
* @Company : Capgemini 
* @update history : 
*    1. RSS 45480 - SMS activity subject for profile update is not correct.  
*/ 
trigger BankAccountTrigger on Payment_Source__c(after insert, after update, after delete) {
    
    Map < Id, List < Id >> financeMap = new Map < id, List < Id >> ();
    Map < Id, String > financeActType = new Map < Id, String > ();
    
    
    
    system.debug('the value'+Label.AHFC_SMS_Notification);
    for (Payment_Source__c pr: trigger.isdelete ? trigger.old : trigger.new) {
        if (financeMap.containsKey(pr.Finance_Account_Number__c)) {
            financeMap.get(pr.Finance_Account_Number__c).add(pr.id);
        } else {
            financeMap.put(pr.Finance_Account_Number__c, new List < Id > {
                pr.id
                    });
        }
    }
    //system.debug(financeMap.keySet());
    Map < Id, Communication_Preferences__c > orderMap = new Map < id, Communication_Preferences__c > ();
    //RSS-45325: Added new parameters Account_Status_Updates_via_Text__c 
    for (Finance_Account__c f: [Select id, Honda_Brand__c, Finance_Account_Number__c, (Select id, Email_Address__c, Payment_Confirmations_via_Email__c, EasyPay_Communications_via_Email__c, Text_Number__c, Payment_Reminders_via_Text__c, Payment_Confirmations_via_Text__c, EasyPay_Communications_via_Text__c,Account_Status_Updates_via_Text__c  from Communication_Preferences__r) from Finance_Account__c where Id IN: financeMap.keySet()]) {
        //orderMap.put(cr.Finance_Account_Number__c,cr.id);
        financeActType.put(f.id, f.Honda_Brand__c + '::' + f.Finance_Account_Number__c);
        for (Communication_Preferences__c cr: f.Communication_Preferences__r) {
            orderMap.put(f.id, cr);
        }
    }
    
    
    //Template List
    Map < String, Id > emailMap = new Map < String, Id > ();
    for (EmailTemplate e: [Select id, Name from EmailTemplate]) {
        emailMap.put(e.Name, e.Id);
    }
    
    //Template for Order
    
    Map < Id, Id > tempMap = new Map < Id, Id > ();
    Map < Id, Communication_Preferences__c > perferenceMap = new Map < Id, Communication_Preferences__c > ();
    /* 
for(Payment_Source__c po:trigger.isdelete ? trigger.old : trigger.new){

Communication_Preferences__c cp;
if(orderMap.containsKey(po.Finance_Account_Number__c)){
cp = orderMap.get(po.Finance_Account_Number__c);
perferenceMap.put(po.id,cp);
}

if(cp.Payment_Confirmations_via_Email__c == true || cp.Payment_Reminders_via_Email__c == true || cp.EasyPay_Communications_via_Email__c == true || cp.Paperless_Statements_Letters__c == true){
tempMap.put(po.Id,emailMap.get('Demo_Template'));
}   
}*/
    
    //SMS Notification
    //Bypass the SMS Service through Custom Label - this trigger will affect, while loading the data from integration profile/users
    String profilesString = label.IntegrationBypassProfileId;
    Set<string> profileList = new Set<string>(profilesString.trim().split(','));
    if(!profileList.contains(UserInfo.getProfileId())) {
        
        // Stop sending Text for the Suppress Finance Account (Fl_Suppress_All_Notifications__c )
        // Condition Starts
        Set<id> finId = new Set<id>();
        
        for (Payment_Source__c psc: trigger.isdelete ? trigger.old : trigger.new){
            finId.add(psc.Finance_Account_Number__c);
        }
        
        Map<id,Finance_Account__c> finSuppress = new Map<id,Finance_Account__c>([select id,Fl_Suppress_All_Notifications__c from Finance_Account__c where id in: finId]);
        // Suppress Condition ends  
        
        List < Messaging.SingleEmailMessage > mailList = new List < Messaging.SingleEmailMessage > ();
        for (Payment_Source__c p: trigger.isdelete ? trigger.old : trigger.new) {
            if(!finSuppress.get(p.Finance_Account_Number__c).Fl_Suppress_All_Notifications__c || finSuppress.get(p.Finance_Account_Number__c).Fl_Suppress_All_Notifications__c==null){  // Check the Finance Account is not Suppress
                /* List<String> s = new List<String>();
s.add(perferenceMap.get(p.id).Email_Address__c);

Messaging.SingleEmailMessage e = new Messaging.SingleEmailMessage();
e.setToAddresses(s);
e.setTargetObjectId(userinfo.getuserid());
//e.setTreatTargetObjectAsRecipient(false);
e.setTemplateId(tempMap.get(p.id));
e.setSaveAsActivity(false);
mailList.add(e);*/
                
                if (Trigger.isInsert || Trigger.isDelete || Trigger.isUpdate) {
                    system.debug('inside first loop');
                    system.debug('PFINNNNN'+p.Finance_Account_Number__c);
                    Communication_Preferences__c cp;
                    if (orderMap.containsKey(p.Finance_Account_Number__c)) {
                        cp = orderMap.get(p.Finance_Account_Number__c);
                        system.debug('cpppp--->'+cp);
                    }
                    //RSS-45325: Added new OR conditions for Account_Status_Updates_via_Text__c 
                    system.debug('CommmPref'+cp);
                    
                    if ((cp.Payment_Reminders_via_Text__c || cp.Payment_Confirmations_via_Text__c || cp.EasyPay_Communications_via_Text__c || cp.Account_Status_Updates_via_Text__c) && cp.Text_Number__c != null) {
                        system.debug('inside first loop 2');
                        //RSS 47625 begin
                        String MessageType = '';
                        Task task = new Task();
                        //RSS 47625 end
                        NotificationTextMsgs__c msgTemplate = null;
                        String isHonda, finAccNum;
                        if (orderMap.containsKey(p.Finance_Account_Number__c)) {
                            isHonda = financeActType.get(p.Finance_Account_Number__c).split('::')[0];
                            finAccNum = financeActType.get(p.Finance_Account_Number__c).split('::')[1];
                        }
                        system.debug('Bank Account Status---->' + p.status__c);
                        if (Trigger.isInsert) 
                            MessageType = (isHonda != 'AFS') ? 'AddedBankAccountHonda' : 'AddedBankAccountAcura'; 
                        
                        else if (Trigger.isUpdate && p.status__c == 'Deleted' && 
                                 p.Status__c != Trigger.oldMap.get(p.id).Status__c) 
                            
                            MessageType = (isHonda != 'AFS') ? 'DeletedBankAccountHonda' : 'DeletedBankAccountAcura'; 
                        
                        
                        AHFC_Payment__mdt paymt = [SELECT Added_Bank_Account__c, Deleted_Bank_Account__c
                                                   FROM AHFC_Payment__mdt];      
                                
                        
                        switch on MessageType {
                                    when 'AddedBankAccountHonda' {      
                                        msgTemplate = NotificationTextMsgs__c.getValues('AddedBankAccountHonda');
                                        task.Subject = paymt.Added_Bank_Account__c;
                                        
                                    }   
                                    when 'AddedBankAccountAcura' {      
                                        msgTemplate = NotificationTextMsgs__c.getValues('AddedBankAccountAcura');
                                        task.Subject = paymt.Added_Bank_Account__c;
                                    }
                                    when 'DeletedBankAccountHonda' {        
                                        msgTemplate = NotificationTextMsgs__c.getValues('DeletedBankAccountHonda');
                                        task.Subject = paymt.Deleted_Bank_Account__c;
                                        
                                    }   
                                    when 'DeletedBankAccountAcura' {        
                                        msgTemplate = NotificationTextMsgs__c.getValues('DeletedBankAccountAcura');
                                        task.Subject = paymt.Deleted_Bank_Account__c;
                                    }
                        }
                        
                        
                        System.debug(msgTemplate);
                        System.debug(cp.Text_Number__c);
                        if (msgTemplate != null && cp.Text_Number__c != null) {
                            finAccNum = finAccNum.substring(finAccNum.length() - 4);
                            String template = msgTemplate.MsgTemplate__c;
                            
                            template = template.replaceAll('<Last 4 of Fin Acct Nmbr>', finAccNum);
                            list < string > mobileNumbers = new list < string > ();
                            String mobilenum = cp.Text_Number__c;
                            if (mobilenum != null) {
                                mobileNum = mobileNum.replaceAll('\\(', '').replaceAll('\\)', '').replaceAll(' ', '').replaceAll('-', '');
                                
                                /* Fix - #112879. User is expected to enter 10 digit valid USA mobile number. Country code logic is not required.*/
                                //string countryCode = (mobileNum.substring(0,1)=='1')?'':'1';
                                //mobileNum = countryCode+mobileNum;
                                mobileNum = mobileNum.replaceAll('\\(', '').replaceAll('\\)', '').replaceAll(' ', '').replaceAll('-', '');
                                string countryCode = (mobileNum.substring(0, 1) == '1') ? '' : '1';
                                mobileNum = countryCode + mobileNum;
                                system.debug('Sending msg to ' + mobileNum + '. msg is ' + template);
                                
                                
                            }
                            system.debug('mobileNum--->>>'+mobileNum);
                            mobileNumbers.add(mobileNum);
                            
                            //Sajila : Adding Condition to avoid invoking the web service from test classes
                            if (!Test.isRunningTest()) {
                                ExactTargetService.sendSMS(mobileNumbers, true, true, template, cp.ID);
                            }
                            // Adding task to show the sms activity in the Notification History related list
                            //Task task = new Task();
                            task.WhatId = p.Id;
                            //task.Subject = 'SMS: PAYMENT PROFILE UPDATED';     RSS 45480 :- Task Subject Changed
                            //task.Subject = Label.AHFC_SMS_Notification;
                            //task.WhoId = 
                            task.ActivityDate = Date.today();
                            //      task.Description = 'SMS: PAYMENT NOTIFICATION SENT';
                            task.Description = template;
                            task.Priority = 'Normal';
                            task.Status = 'completed';
                            system.debug('>>>>>>'+task);
                            insert task;
                        }
                    }
                }    
            }
            
        }
        
        if (mailList.size() > 0) {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(mailList);
        }
    }   
}