global class ExactTargetService {
    
    Public static String accessToken = '';

    public class creds{
        public String clientId {get; set;}
        public String clientSecret {get; set;}
    }
    
    
    public class sendmessage{
        public list<String> mobileNumbers{get; set;}
        public boolean Subscribe{get; set;}
        public boolean Resubscribe{get; set;}
        public String keyword {get; set;}
        public String SendTime {get; set;}     
        public String messageText {get; set;}  
        public boolean overrideStatus {get; set;} 
    }
    
  
    
     /** 
       * Method Name  :getAuthCode
       * Parameters   : NA
       * Return Value : Access token as string
      **/
      
    global static String getAuthCode(){
    
        creds exact = new creds();
        exact.clientId =Label.Exact_Target_Client_id;
        exact.clientSecret =Label.Exact_Target_Client_Secret;
        
        String jsonBody = json.serialize(exact);
        
        //114155 - Prakash start 
        //String endpoint= 'https://auth.exacttargetapis.com/v1/requestToken';
        String endPoint = 'callout:ExactTarget_Auth';
        //114155 - Prakash end
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        
        Http http = new Http();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setBody(jsonBody);
        
        res = http.send(req);
        
        if(res.getStatusCode() == 200){
            accessToken = jsonprocessing(res.getbody(),'accessToken');
        }
        system.debug ('::accessToken::' +accessToken);
        return accessToken;
    }
    
    /*    
    @future(callout=true)
    global static void sendSMS(list<String> mobilenos, boolean forcesendmsg, String key, String apikey, boolean tooverride, String msgtxt, ID comPrefId){
    
        sendmessage msg = new sendmessage();
        msg.mobileNumbers= mobilenos;
        msg.Subscribe = forcesendmsg? true: false;
        msg.Resubscribe = forcesendmsg? true: false;
        msg.keyword = key;
        msg.overrideStatus = tooverride;
        msg.messageText = msgtxt;
        
        msg.SendTime = string.valueOfGmt(datetime.now());
        
        String jsonBody = json.serialize(msg);
        jsonBody = jsonBody.replace('overrideStatus', 'Override');
        system.debug('JSON body is ' + jsonbody);
        String endpoint= 'https://www.exacttargetapis.com/sms/v1/messageContact/' + apikey+'/send';
        system.debug('Endpoint is ' + endpoint);
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
       // String accesstoken = getCustomsetting();
        if(accesstoken == null){
            accesstoken = getAuthCode();
            system.debug('New token created' + accesstoken);
        }
        try{
            Http http = new Http();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            system.debug('accesstoken' +accesstoken);
            req.setHeader('Authorization','Bearer ' + accesstoken);        
            req.setBody(jsonBody);
            
            res = http.send(req);
            system.debug('Custom message: response is ' + res.getbody() + 'Code is ' + res.getStatusCode());
            if(res.getStatusCode() == 202){
                String resp =  jsonprocessing(res.getbody(),'tokenId');
                
                if(String.isNotBlank(resp)){
                    Communication_Preferences__c toup = new Communication_Preferences__c(id=comPrefId);
                    toup.Need_To_Check_Delivery__c = true;
                    toup.Last_SMS_Token__c = resp;
                    update toup;
                }
            }else if(res.getStatusCode() == 401){
                //  Token expires every 60 mins. No seperate method to test expiry
                if(jsonprocessing(res.getbody(),'message').equalsignorecase('Not Authorized')){
                    //if(getAuthCode() != null){
                        String newAccesstoken = getAuthCode();
                        req.setHeader('Authorization','Bearer ' + newAccesstoken);      
                        res = http.send(req);
                        system.debug('Custom message: response is ' + res.getbody() + 'Code is ' + res.getStatusCode());
                        if(res.getStatusCode() == 202){
                            
                            String resp =  jsonprocessing(res.getbody(),'tokenId');
                            Communication_Preferences__c toup = new Communication_Preferences__c(id=comPrefId);
                            toup.Need_To_Check_Delivery__c = true;
                            toup.Last_SMS_Token__c = resp;
                            update toup;
                        }else if(res.getStatusCode() == 401){
                            system.debug('Error Accessing Token');
                        } else if ( res.getStatusCode() == 400 ) {
                            
                            Communication_Preferences__c  CommPref = [SELECT Id, SMS_Bounce_Back_Count__c,Is_SMS_Bounced_Back__c FROM Communication_Preferences__c WHERE Id = :comPrefId ];
                            CommPref.SMS_Bounce_Back_Count__c = CommPref.SMS_Bounce_Back_Count__c + 1 ;
                            CommPref.Is_SMS_Bounced_Back__c = True;
                            if ( CommPref.SMS_Bounce_Back_Count__c >= 3 ) {
                                CommPref.Is_Comm_Pref_Set__c= False ;
                            }
                            Update CommPref;

                        }
                        //sendSMSAfterLogin(mobilenos,forcesendmsg,key,apikey,tooverride,msgtxt,comPrefId);
                    //}else{
                        //system.debug('Error in requesting authentication token');
                    //}
                }else{
                     system.debug(jsonprocessing(res.getbody(),'errors'));
                }
            }else{          
                system.debug(jsonprocessing(res.getbody(),'errors'));
            }    
         }catch(exception e){
             // Handle errors for refresh token expiry
             system.debug('Unexpected Exception ');
         }    
            
    } */
    
    @future(callout=true)
    global static void sendSMS(list<String> mobilenos, boolean forcesendmsg, boolean tooverride, String msgtxt, ID comPrefId){
    
        String key = Label.Exact_Target_Keyword;
        String apikey = Label.Exact_Target_API_Key;
        
        sendmessage msg = new sendmessage();
        msg.mobileNumbers= mobilenos;
        msg.Subscribe = forcesendmsg? true: false;
        msg.Resubscribe = forcesendmsg? true: false;
        msg.keyword = key;
        msg.overrideStatus = tooverride;
        msg.messageText = msgtxt;
        
        msg.SendTime = string.valueOfGmt(datetime.now());
        
        String jsonBody = json.serialize(msg);
        jsonBody = jsonBody.replace('overrideStatus', 'Override');
        system.debug('JSON body is ' + jsonbody);
        // 114155 Prakash Start 
        //String endpoint= 'https://www.exacttargetapis.com/sms/v1/messageContact/' + apikey+'/send';
        String endpoint = 'callout:ExactTarget'+'/'+apikey+'/send';
        // 114155 Prakash End 
        
        system.debug('Endpoint is ' + endpoint);
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
       // String accesstoken = getCustomsetting();
        if(accesstoken == null){
            accesstoken = getAuthCode();
            system.debug('New token created' + accesstoken);
        }
        try{
            Http http = new Http();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            system.debug('accesstoken' +accesstoken);
            req.setHeader('Authorization','Bearer ' + accesstoken);        
            req.setBody(jsonBody);
            
            res = http.send(req);
            system.debug('Custom message: response is ' + res.getbody() + 'Code is ' + res.getStatusCode());
            system.debug('code >>>>>>>>'+res.getStatusCode());
            if(res.getStatusCode() == 202){
            system.debug('inside 202 >>>>>>>');
                String resp =  jsonprocessing(res.getbody(),'tokenId');
                
                if(String.isNotBlank(resp)){
                    Communication_Preferences__c toup = new Communication_Preferences__c(id=comPrefId);
                    toup.Need_To_Check_Delivery__c = true;
                    toup.Last_SMS_Token__c = resp;
                    update toup;
                }
            }else if(res.getStatusCode() == 401){
                system.debug('Inside 401>>>>>>>');
                // Token expires every 60 mins. No seperate method to test expiry
                if(jsonprocessing(res.getbody(),'message').equalsignorecase('Not Authorized')){
                system.debug('Inside 2nd If 401 >>>>>>>>');
                    //if(getAuthCode() != null){
                        String newAccesstoken = getAuthCode();
                        req.setHeader('Authorization','Bearer ' + newAccesstoken);      
                        res = http.send(req);
                        system.debug('Custom message: response is ' + res.getbody() + 'Code is ' + res.getStatusCode());
                         if(res.getStatusCode() == 202){    
                                                 
                            String resp =  jsonprocessing(res.getbody(),'tokenId');
                            Communication_Preferences__c toup = new Communication_Preferences__c(id=comPrefId);
                            toup.Need_To_Check_Delivery__c = true;
                            toup.Last_SMS_Token__c = resp;
                            update toup;
                        }else if(res.getStatusCode() == 401){
                            system.debug('Error Accessing Token');
                        } else if ( res.getStatusCode() == 400 ) {
                           
                           Map<Id,Communication_Preferences__c> CommPreferences = New Map<Id,Communication_Preferences__c> ([SELECT Id, Email_BounceBack_Count__c, Customer__r.PersonEmail,
                                                                                     Payment_Confirmations_via_Email__c, Payment_Profile_Updates_via_Email__c, Payment_Reminders_via_Email__c, EasyPay_Communications_via_Email__c,  
                                                                                     Payment_Confirmations_via_Text__c,  Payment_Profile_Updates_via_Text__c,  Payment_Reminders_via_Text__c, EasyPay_Communications_via_Text__c,
                                                                                     Unsubscribe_from_all__c, SMS_Bounce_Back_Count__c, Is_Comm_Pref_Set__c ,Statements_Letters__c,Paperless_Statements_Letters__c                    
                                                                                 FROM Communication_Preferences__c 
                                                                                    WHERE Id = :comPrefId ]) ;
                         List<Communication_Preferences__c > cpref = new List<Communication_Preferences__c>();   
                                                                             

                          if ( !CommPreferences.Isempty() ){
                              
                              for( Communication_Preferences__c c :CommPreferences.values()){   
                                           
                                    c.SMS_Bounce_Back_Count__c = c.SMS_Bounce_Back_Count__c + 1;
                                    c.Is_SMS_Bounced_Back__c = True;
                                    c.Is_Comm_Pref_Set__c = True ;
                                    
                                    
                                    // SET FLAG TO FALSE WHEN SMS BOUNCED 3 TIMES
                                  
                                    if ( c.SMS_Bounce_Back_Count__c >= 3  ) {
                                         
                                         c.Payment_Confirmations_via_Text__c = False;
                                         c.Payment_Profile_Updates_via_Text__c = False;
                                         c.Payment_Reminders_via_Text__c = False;
                                         c.EasyPay_Communications_via_Text__c = False;
                                         
                                         if ( c.Email_BounceBack_Count__c >= 3  ||
                                               ( !c.Payment_Confirmations_via_Email__c && !c.Payment_Profile_Updates_via_Email__c && !c.Payment_Reminders_via_Email__c && !c.EasyPay_Communications_via_Email__c ) ) {
                                             c.Is_Comm_Pref_Set__c = False ;
                                             c.Unsubscribe_from_all__c = True ;
                                             c.Paperless_Statements_Letters__c = False;
                                             c.Statements_Letters__c = 'Paper' ;
                                         }
                                         TaskHelper.setTriggerAsExecutedSMS();
                                    }
                                    cPref.add(c);
                                }
                                
                                
                            } 
                            
                             
                            //Update CommPreferences.values() ;
                            Update cPref;

                        }
                        //sendSMSAfterLogin(mobilenos,forcesendmsg,key,apikey,tooverride,msgtxt,comPrefId);
                    //}else{
                        //system.debug('Error in requesting authentication token');
                    //}
                }else{
                     system.debug(jsonprocessing(res.getbody(),'errors'));
                }
            }else{          
                system.debug(jsonprocessing(res.getbody(),'errors'));
            }    
         }catch(exception e){
             // Handle errors for refresh token expiry
             system.debug('Unexpected Exception ');
         }    
            
    }
    
    global static void sendSMSBatch(list<String> mobilenos, boolean forcesendmsg, boolean tooverride, String msgtxt, ID comPrefId){
    
        String key = Label.Exact_Target_Keyword;
        String apikey = Label.Exact_Target_API_Key;
        
        sendmessage msg = new sendmessage();
        msg.mobileNumbers= mobilenos;
        msg.Subscribe = forcesendmsg? true: false;
        msg.Resubscribe = forcesendmsg? true: false;
        msg.keyword = key;
        msg.overrideStatus = tooverride;
        msg.messageText = msgtxt;
        
        msg.SendTime = string.valueOfGmt(datetime.now());
        
        String jsonBody = json.serialize(msg);
        jsonBody = jsonBody.replace('overrideStatus', 'Override');
        system.debug('JSON body is ' + jsonbody);
        // 114155 Prakash Start 
        //String endpoint= 'https://www.exacttargetapis.com/sms/v1/messageContact/' + apikey+'/send';
         String endpoint = 'callout:ExactTarget'+'/'+apikey+'/send';
        // 114155 Prakash End 
        system.debug('Endpoint is ' + endpoint);
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
       // String accesstoken = getCustomsetting();
        if(accesstoken == null){
            accesstoken = getAuthCode();
            system.debug('New token created' + accesstoken);
        }
        try{
            Http http = new Http();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            system.debug('accesstoken' +accesstoken);
            req.setHeader('Authorization','Bearer ' + accesstoken);        
            req.setBody(jsonBody);
            
            res = http.send(req);
            system.debug('Custom message: response is ' + res.getbody() + 'Code is ' + res.getStatusCode());
            if(res.getStatusCode() == 202){
                String resp =  jsonprocessing(res.getbody(),'tokenId');
                
                if(String.isNotBlank(resp)){
                    Communication_Preferences__c toup = new Communication_Preferences__c(id=comPrefId);
                    toup.Need_To_Check_Delivery__c = true;
                    toup.Last_SMS_Token__c = resp;
                    update toup;
                }
            }else if(res.getStatusCode() == 401){
                // Token expires every 60 mins. No seperate method to test expiry
                if(jsonprocessing(res.getbody(),'message').equalsignorecase('Not Authorized')){
                    //if(getAuthCode() != null){
                        String newAccesstoken = getAuthCode();
                        req.setHeader('Authorization','Bearer ' + newAccesstoken);      
                        res = http.send(req);
                        system.debug('Custom message: response is ' + res.getbody() + 'Code is ' + res.getStatusCode());
                        if(res.getStatusCode() == 202){
                            
                            String resp =  jsonprocessing(res.getbody(),'tokenId');
                            Communication_Preferences__c toup = new Communication_Preferences__c(id=comPrefId);
                            toup.Need_To_Check_Delivery__c = true;
                            toup.Last_SMS_Token__c = resp;
                            update toup;
                        }else if(res.getStatusCode() == 401){
                            system.debug('Error Accessing Token');
                        } else if ( res.getStatusCode() == 400 ) {

                           Map<Id,Communication_Preferences__c> CommPreferences = New Map<Id,Communication_Preferences__c> ([SELECT Id, Email_BounceBack_Count__c, Customer__r.PersonEmail,
                                                                                     Payment_Confirmations_via_Email__c, Payment_Profile_Updates_via_Email__c, Payment_Reminders_via_Email__c, EasyPay_Communications_via_Email__c,  
                                                                                     Payment_Confirmations_via_Text__c,  Payment_Profile_Updates_via_Text__c,  Payment_Reminders_via_Text__c, EasyPay_Communications_via_Text__c,
                                                                                     Unsubscribe_from_all__c, SMS_Bounce_Back_Count__c, Is_Comm_Pref_Set__c ,Statements_Letters__c,Paperless_Statements_Letters__c                    
                                                                                 FROM Communication_Preferences__c 
                                                                                    WHERE Id = :comPrefId ]) ;
                         List<Communication_Preferences__c > cpref = new List<Communication_Preferences__c>();                                                           

                          if ( !CommPreferences.Isempty() ){
                              
                              for( Communication_Preferences__c c :CommPreferences.values()){   
                                           
                                    c.SMS_Bounce_Back_Count__c = c.SMS_Bounce_Back_Count__c + 1;
                                    c.Is_SMS_Bounced_Back__c = True;
                                    c.Is_Comm_Pref_Set__c = True ;
                                    
                                    
                                    // SET FLAG TO FALSE WHEN SMS BOUNCED 3 TIMES
                                    if ( c.SMS_Bounce_Back_Count__c >= 3  ) {
                                         
                                         c.Payment_Confirmations_via_Text__c = False;
                                         c.Payment_Profile_Updates_via_Text__c = False;
                                         c.Payment_Reminders_via_Text__c = False;
                                         c.EasyPay_Communications_via_Text__c = False;
                                         
                                         if ( c.Email_BounceBack_Count__c >= 3  ||
                                               ( !c.Payment_Confirmations_via_Email__c && !c.Payment_Profile_Updates_via_Email__c && !c.Payment_Reminders_via_Email__c && !c.EasyPay_Communications_via_Email__c ) ) {
                                             c.Is_Comm_Pref_Set__c = False ;
                                             c.Unsubscribe_from_all__c = True ;
                                             c.Paperless_Statements_Letters__c = False;
                                             c.Statements_Letters__c = 'Paper' ;
                                         }
                                         TaskHelper.setTriggerAsExecutedSMS();
                                    }
                                    cPref.add(c);
                                }
                                
                                
                            } 
                            
                             
                            //Update CommPreferences.values() ;
                            Update cPref;

                        }
                        //sendSMSAfterLogin(mobilenos,forcesendmsg,key,apikey,tooverride,msgtxt,comPrefId);
                    //}else{
                        //system.debug('Error in requesting authentication token');
                    //}
                }else{
                     system.debug(jsonprocessing(res.getbody(),'errors'));
                }
            }else{          
                system.debug(jsonprocessing(res.getbody(),'errors'));
            }    
         }catch(exception e){
             // Handle errors for refresh token expiry
             system.debug('Unexpected Exception ');
         }    
            
    }

    global String checkDeliveryStatus(String tokenid, String apikey){
        
        
        // 114155 Prakash Start 
        // String endpoint= 'https://www.exacttargetapis.com/sms/v1/messageContact/' + apikey+'/deliveries/' + tokenid;
         String endpoint = 'callout:ExactTarget'+'/'+apikey+'/deliveries/' + tokenid;
        // 114155 Prakash End 
        List<String> lstSuccessCodes = new List<String>();
        List<String> lstProcessCodes = new List<String>();
        lstSuccessCodes = (Label.SMS_TRACKING_SUCCESS_CODES).Split(',') ;
        List<String> lstFailureCodes = new List<String>();
        lstFailureCodes = (Label.SMS_TRACKING_FAILURE_CODES).Split(',');
        lstProcessCodes = (Label.SMS_TRACKING_PROCESS_CODES).Split(',');
        Set<String> SuccessCodes = new Set<String>(lstSuccessCodes);
        Set<String> FailureCodes = new Set<String>(lstFailureCodes);
        Set<String> ProcessCodes = new Set<String>(lstProcessCodes);
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();

        if(accesstoken == null){
            accesstoken = getAuthCode();
            system.debug('New token created' + accesstoken);
        }
        try{
            Http http = new Http();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer ' + accesstoken);    
            res = http.send(req);
            system.debug('Response in SMS Delivery check: response is ' + res.getbody() + 'Code is ' + res.getStatusCode());
            if(res.getStatusCode() == 200){
                DeliveryStatus dst =(DeliveryStatus)Json.deserialize(res.getbody(), DeliveryStatus.class);   
                if(dst != null && !dst.tracking.isEmpty()){
                    boolean EnrouteSMS = false;
                    for(TrackingStatus trcst:dst.tracking){
                        EnrouteSMS = false;
                        system.debug('trcst.standardStatusCode>>>>'+trcst.standardStatusCode+'<<<>>>>'+ trcst.statusCode);
                        if(SuccessCodes.Contains(trcst.standardStatusCode))
                            return 'Delivered'+','+ trcst.message; 
                        else if(FailureCodes.Contains(trcst.standardStatusCode))
                            return 'Rejected'+','+ trcst.message; 
                        else if(ProcessCodes.Contains(trcst.standardStatusCode))
                            EnrouteSMS = true;
                    }
                    if(EnrouteSMS)
                        return 'Enroute,Enroute';
                    else
                        return 'Unable to track';  
                } else{
                    return 'Unable to track';
                } //End
                
            }else if(res.getStatusCode() == 401){
                // Token expires every 60 mins. No seperate method to test expiry
                
                if(jsonprocessing(res.getbody(),'message').equalsignorecase('Not Authorized')){
                    String newAccesstoken = getAuthCode();
                    req.setHeader('Authorization','Bearer ' + newAccessToken);  
                    system.debug('<<<req>>>'+req.getEndpoint());
                    res = http.send(req);
                    
                    system.debug('Response in SMS Delivery check: response ==> ' + res.getbody() + 'Code is ' + res.getStatusCode());
                    if(res.getStatusCode() == 200){
                        
                        DeliveryStatus dst =(DeliveryStatus)Json.deserialize(res.getbody(), DeliveryStatus.class);   
                       
                        if(dst != null && !dst.tracking.isEmpty()){
                            boolean EnrouteSMS = false;
                            for(TrackingStatus trcst:dst.tracking){
                                EnrouteSMS = false;
                                system.debug('trcst.standardStatusCode>>>>'+trcst.standardStatusCode+'<<<statusCode>>>>'+ trcst.statusCode);
                                if(SuccessCodes.Contains(trcst.standardStatusCode))
                                    return 'Delivered'+','+ trcst.message; 
                                else if(FailureCodes.Contains(trcst.standardStatusCode))
                                    return 'Rejected'+','+ trcst.message; 
                                else if(ProcessCodes.Contains(trcst.standardStatusCode))
                                    EnrouteSMS = true;
                            }
                            if(EnrouteSMS)
                                return 'Enroute,Enroute';
                            else
                                return 'Unable to track';
                        }else{
                            return 'Unable to track';
                        } //End
                    }else if(res.getStatusCode() == 401){
                        return 'Unable to track';
                    }
                    return 'Unable to track';
                    
                }else{
                   return jsonprocessing(res.getbody(),'errors');
                }
            }else{          
                   
                return jsonprocessing(res.getbody(),'errors');
            }    
         }catch(exception e){
             // Handle errors for refresh token expiry
             system.debug('Response in SMS Delivery check: exception e ==> ' + e.getMessage());
             return e.getMessage();
         }   
    }
    
    global static String jsonprocessing(String inputJsonResponse, string keyname){
         
     JSONParser parser = JSON.createParser(inputJsonResponse);    
     String fieldvalue= '';
     while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                String fieldName = parser.getText();
                parser.nextToken();
                if(parser.getCurrentToken() == JSONToken.START_ARRAY){
                    while(parser.nextToken() != null){
                        fieldvalue = parser.getText();
                        break;
                    }
                    
                }else if(fieldName == keyname) {
                    fieldvalue = parser.getText();
                }
            }   
     }
    return fieldvalue;
  }
    /*
     *"message":"mstText",
             *                            "count":1,
             *                            "excludedCount":0,
             *                            "createDate":"2015-10-26T22:42:02.283",
             *                            "completeDate":"2015-10-26T22:42:50.153",
             *                            "status":"Finished",
             *                            "tracking":[{"mobileNumber":"16264638805","statusCode":"0","message":"DELIVERED TO Air2Web"}]} 
     */
    Public class TrackingStatus{
            String mobileNumber{get; set;}
            String statusCode{get; set;}
            String message{get; set;}
            string standardStatusCode{get; set;}
    }
    Public class DeliveryStatus {
            String mstText {get; set;}
            Integer count{get; set;}
            Integer excludedCount{get; set;}
            String createDate{get; set;}
            String completeDate{get; set;}
            String status{get; set;}
            List<TrackingStatus> tracking {get; set;}
    }
    
    
  
  /** 
   * Method Name  :setCustomSetting
   * Parameters   : Access token
   * Return Value : Void
  **/ 
    global static void setCustomSetting(string atoken){ 
       // string pId=userinfo.getUserId();
       // Exact__c setting = Exact__c.getInstance(pId);
        Exact__c setting = Exact__c.getInstance();
        setting.Token__c=atoken;
        upsert setting;
    }
  /** 
   * Method Name  :getCustomsetting
   * Parameters   : NA
   * Return Value : string
  **/
    global static string getCustomsetting(){
        string customSettingVal;
        try{
        //   customSettingVal= String.valueOf(Exact__c.getInstance(userinfo.getUserId()).get('Token__c'));
             customSettingVal= String.valueOf(Exact__c.getInstance().get('Token__c'));
        }
         catch(exception e){
            system.debug('Exception in getting custom setting'+e.getMessage()+e.getLinenumber());
        }
        return customSettingVal;
    }
    /*global static void sendSMSAfterLogin(list<String> mobilenos, boolean forcesendmsg, String key, String apikey, boolean tooverride, String msgtxt, ID comPrefId){
    
        sendmessage msg = new sendmessage();
        msg.mobileNumbers= mobilenos;
        msg.Subscribe = forcesendmsg? true: false;
        msg.Resubscribe = forcesendmsg? true: false;
        msg.keyword = key;
        msg.overrideStatus = tooverride;
        msg.messageText = msgtxt;
        
        msg.SendTime = string.valueOfGmt(datetime.now());
        
        String jsonBody = json.serialize(msg);
        jsonBody = jsonBody.replace('overrideStatus', 'Override');
        system.debug('JSON body is ' + jsonbody);
        system.debug('Reuses token ' + getCustomsetting());
        String endpoint= 'https://www.exacttargetapis.com/sms/v1/messageContact/' + apikey+'/send';
        system.debug('Endpoint is ' + endpoint);
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        String accesstoken = getCustomsetting();
        if(accesstoken == null){
            getAuthCode();
            accesstoken = getCustomsetting();
            system.debug('New token created' + accesstoken);
        }
        try{
            Http http = new Http();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer ' + accesstoken);        
            req.setBody(jsonBody);
            
            res = http.send(req);
            system.debug('Custom message: response is ' + res.getbody() + 'Code is ' + res.getStatusCode());
            if(res.getStatusCode() == 202){
               String resp =  jsonprocessing(res.getbody(),'tokenId');
                Communication_Preferences__c toup = new Communication_Preferences__c(id=comPrefId);
                toup.Need_To_Check_Delivery__c = true;
                toup.Last_SMS_Token__c = resp;
                update toup;
            }else if(res.getStatusCode() == 401){
                // Token expires every 60 mins. No seperate method to test expiry
                if(jsonprocessing(res.getbody(),'message').equalsignorecase('Not Authorized')){
                    //if(getAuthCode() != null){
                        getAuthCode();
                        sendSMSAfterLogin(mobilenos,forcesendmsg,key,apikey,tooverride,msgtxt,comPrefId);
                    //}else{
                        system.debug('Error in requesting authentication token');
                    //}
                }else{
                     system.debug(jsonprocessing(res.getbody(),'errors'));
                }
            }else{          
                system.debug(jsonprocessing(res.getbody(),'errors'));
            }    
         }catch(exception e){
             // Handle errors for refresh token expiry
             system.debug('Unexpected Exception ');
         }    
            
    }*/
}