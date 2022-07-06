/*
 * Class Name: smsBounceBackHandler
 * Purpose   : Steps:-
 *             1.Fetch all the Communication Preferences Objects for which the delivery has to be checked 
 *               based on NeedToCheckDelivery flag.
 *             2.Pass the token ID to the ExactTargetService CheckDelivery function and get the current Delivery Status
 *             3.Update the Delivery Status onto Communication Preferences Object
 * CreatedBy:  11167678
 * CreatedOn:  27-Oct-2015
 * LastModified:
 * LastModified Purpose:
 */

global class smsBounceBackHandler implements Database.Batchable<sObject>, Database.AllowsCallouts {
 
    List<Communication_Preferences__c> deliveredComPref = new List<Communication_Preferences__c>();
    List<Communication_Preferences__c> unDeliveredComPref = new List<Communication_Preferences__c>();
    Map<id,String> statusMsg = new Map<id,String>();
    public String trackingResponse;
    
    global Database.QueryLocator start(Database.BatchableContext  bc) {
        
        return Database.getQueryLocator('SELECT id, Finance_Account_Number__r.Finance_Account_Number__c,Payment_Reminders_via_Email__c,EasyPay_Communications_via_Email__c,last_sms_token__c,Is_SMS_Bounced_Back__c,Payment_Profile_Updates_via_Email__c,Payment_Confirmations_via_Email__c,SMS_Bounce_Back_Count__c,Last_SMS_Status_Message__c,Need_to_check_delivery__c,Account_Status_Updates_via_Text__c FROM Communication_Preferences__c where Need_To_Check_Delivery__c = true and last_sms_token__c != null');
    }
    

    global void execute(Database.BatchableContext  bc,List<Communication_Preferences__c> scope) {
    
        
        ManageErrorLogs__c manageErrorLog = ManageErrorLogs__c.getValues('SMSBounceBackHandler');
        for(Communication_Preferences__c  comPref :scope){
            if(!Test.isRunningTest()){
                System.debug('Inside tracking response');
                trackingResponse = new ExactTargetService().checkDeliveryStatus(comPref.last_sms_token__c,Label.Exact_Target_API_Key);
                system.debug('value of tracking response will be>>> '+trackingResponse);
            }
            
            List<String> Response = new List<String>();
            system.debug('======'+trackingResponse);  
            Response = (trackingResponse).Split(',');
            if ( !Response.isEmpty() && Response.size() == 2 ) {
                if(Response[0] == 'Delivered'){
                    deliveredComPref.add(comPref);
                }else if(Response[0] == 'Rejected'){
                    unDeliveredComPref.add(comPref);
                }else{
                    if(manageErrorLog <> NULL && manageErrorLog.isActive__c && Response[0] != 'Enroute'){ 
                    	UtilityClass.logError('SMS BOUNCE BACK HANDLER NEW CODES  ', 'Finance Acc Number ==>' + comPref.Finance_Account_Number__r.Finance_Account_Number__c , 'Communication Preference Id => ' + comPref.Id, 'Status Code : '  + Response[0] +  ' , Message : '  + Response[1]  );
                    }
                }
                statusMsg.put(comPref.id,trackingResponse != null? Response[1] : comPref.Last_SMS_Status_Message__c);
            }
        }       
       //Omkar :Start To Avoid Recursive execution of the Exact Target Class
        RecursiveRunClass.stopTrigger();
    //End   
        List<Communication_Preferences__c> masterList = new List<Communication_Preferences__c>();
        if(deliveredComPref != null){
            
            for(Communication_Preferences__c  delComPref : deliveredComPref){
            system.debug('======'+delComPref+'==='+delComPref.SMS_Bounce_Back_Count__c);
            delComPref.Is_SMS_Bounced_Back__c = false;
            delComPref.SMS_Bounce_Back_Count__c = 0;   
            delComPref.Last_SMS_Status_Message__c=statusMsg.get(delComPref.id);
            delComPref.Need_to_check_delivery__c = false;
            }
            masterList.addAll(deliveredComPref);
        }
        if(unDeliveredComPref != null){
            for(Communication_Preferences__c  delComPref : unDeliveredComPref){
            system.debug('======'+delComPref+'==='+delComPref.SMS_Bounce_Back_Count__c);
            delComPref.Is_SMS_Bounced_Back__c = true;
            delComPref.SMS_Bounce_Back_Count__c ++;                
            delComPref.Need_to_check_delivery__c = false;
            delComPref.Last_SMS_Status_Message__c=statusMsg.get(delComPref.id);
            //Added by Omkar for Defect 114000 for SMS bounce back is greater than or equal to 3 then all text pref should be false.
              if ( delComPref.SMS_Bounce_Back_Count__c >= 3  ) 
                {                                    
                   delComPref.Payment_Confirmations_via_Text__c = False;  
                   delComPref.Payment_Profile_Updates_via_Text__c = False;
                   delComPref.Payment_Reminders_via_Text__c = False;
                   delComPref.EasyPay_Communications_via_Text__c = False;
                   delComPref.Is_Comm_Pref_Set__c = False ;
                   delComPref.Unsubscribe_from_all__c = True ;
                   delComPref.Paperless_Statements_Letters__c = False;
                   delComPref.Statements_Letters__c = 'Paper' ;
                    //New DSX Changes to opt out customer from Account Status Updates via Text notification
                   delComPref.Account_Status_Updates_via_Text__c=False;                        
                 }   //End                       
            }
            masterList.addAll(unDeliveredComPref);
        }        
      
        update masterList;
        
        
    }
    
    global void finish(Database.BatchableContext  bc) {
        
    }
    
}