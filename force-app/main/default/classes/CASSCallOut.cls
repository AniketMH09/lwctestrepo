//  updatedBy      date     Purpose     
//  Anirudh   8th-feb-2017  I-364167
//Mohit Parnami 14 March 2019 T-787449

Public Class CASSCallOut{
    
    Public Static String    SITE_ID ;
    Public Static String    BUSINESS_ID ; 
    Public Static Integer   TIME_OUT ;
    Public Static String isInsertOrUpdate; // For 114159 added by Prakash
    Public Static String caseIsInsertOrUpdate;
    
    // FETCH CREDENETIALS FROM CUSTOM SETTINGS
    Public Static Void FetchCredentials () {
            
        List<CASSCallOut__c> Credentials = CASSCallOut__c.getall().values();
        
        if ( !Credentials.isEmpty() ) {
        
            CASSCallOut__c  Credential = Credentials[0];
            SITE_ID     = Credential.SiteId__c ;
            BUSINESS_ID = Credential.BusinessId__c ;
            TIME_OUT    = Integer.Valueof(Credential.TimeOut__c) ;
        }
       
    }
    
    
    
    @Future(callout=true)
    Public Static Void MakeHttpCall(String PaymentRecId, String isInsertOrUpdateVal){
        
        isInsertOrUpdate = isInsertOrUpdateVal; // For 114159 added by Prakash
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        String now;
        
        try { 
        
        // HTTP CALL OUT
        
        CASSCallOut.FetchCredentials();
         
        request.setEndpoint('callout:Pending_Payments_CASS/REST/AHFC/SalesForce/PendingPayments/1.0/');
        request.setHeader('hondaHeaderType.businessId', BUSINESS_ID);
        Datetime collectedTimestamp = system.now();
        now = collectedTimestamp.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        request.setHeader('hondaHeaderType.collectionTimeStamp', now);
        request.setHeader('hondaHeaderType.messageId', BUSINESS_ID);
        request.setHeader('hondaHeaderType.siteId', SITE_ID);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Length', '250');
        request.setTimeout(TIME_OUT);
        
        // JSON GENERATOR
        String json = jsonGenerator(PaymentRecId);
        System.Debug(' *** json  ==> ' + json );
        
        request.setBody(json);
        request.setMethod('POST');
        response = h.send(request);
        System.Debug(' *** request1  ==> ' + request );
        System.Debug(' *** response1  ==> ' + response );
       
        } Catch ( Exception e ){
            /* RSS 46325 - PG-Systematic outage recovery/SF resync process */
            RetryCallout.RetrycalloutCreationfromCASScallout(request.getEndpoint(),'POST',request.getBody(),BUSINESS_ID,SITE_ID,TIME_OUT,PaymentRecId,'CASSCallOut',string.valueof(response),string.valueof(request),request.getHeader('Content-Type'),now);
            /* RSS 46325 - PG-Systematic outage recovery/SF resync process */
            ErrorLog__c errorLog = new ErrorLog__c();
            errorLog.ClassName__c = 'CASSCallOut';
            errorLog.ExceptionMsg__c = e.getMessage();
            errorLog.AffectedId__c = PaymentRecId;
            errorLog.RequestBody__c = request.getBody();
            insert errorLog;
        
        }
    } 
    
    Public Static Void MakeHttpCallRealTime(String PaymentRecId){
               
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        String now ;
        try { 
        
        // HTTP CALL OUT
        
        CASSCallOut.FetchCredentials();
        
        request.setEndpoint('callout:Pending_Payments_CASS/REST/AHFC/SalesForce/PendingPayments/1.0/');
        request.setHeader('hondaHeaderType.businessId', BUSINESS_ID);
        Datetime collectedTimestamp = system.now();
        now = collectedTimestamp.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        request.setHeader('hondaHeaderType.collectionTimeStamp', now);
        request.setHeader('hondaHeaderType.messageId', BUSINESS_ID);
        request.setHeader('hondaHeaderType.siteId',SITE_ID);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Length', '250');
        request.setTimeout(TIME_OUT);
        
        // JSON GENERATOR
        String json = jsonGenerator(PaymentRecId);
        System.Debug(' *** json  ==> ' + json );
        
        request.setBody(json);
        request.setMethod('POST');
        response = h.send(request);
        
        System.Debug(' *** response2  ==> ' + response );
             
        } Catch ( Exception e ){  
            /* RSS 46325 - PG-Systematic outage recovery/SF resync process */
            RetryCallout.RetrycalloutCreationfromCASScallout(request.getEndpoint(),'POST',request.getBody(),BUSINESS_ID,SITE_ID,TIME_OUT,PaymentRecId,'CASSCallOut',string.valueof(response),string.valueof(request),'application/json;charset=UTF-8',now);
            /* RSS 46325 - PG-Systematic outage recovery/SF resync process */
            ErrorLog__c errorLog = new ErrorLog__c();
            errorLog.ClassName__c = 'CASSCallOut';
            errorLog.ExceptionMsg__c = e.getMessage();
            errorLog.AffectedId__c = PaymentRecId;
            errorLog.RequestBody__c = request.getbody();
            insert errorLog;
        }
    } 
    
    Public static String jsonGenerator(String PaymentRecId){
         
        system.debug ('::isInsertOrUpdate::' +isInsertOrUpdate);       
        //Added Confirmation_Number__c, LastModifiedById in query for QC #114159  - Prakash 
        ChargentOrders__ChargentOrder__c[] orders = [Select id,Finance_Account_Number__r.Finance_Account_Number__c,Finance_Account_Number__r.Payoff_Amount__c,
                                                        Payment_Source_Nickname__r.Last_4__c,ChargentOrders__Payment_Start_Date__c,Payment_Display_Status__c,
                                                        Payment_Type__c,ChargentOrders__Charge_Amount__c,Confirmation_Number__c, LastModifiedById, CreatedDate, LastModifiedDate
                                                    from ChargentOrders__ChargentOrder__c where Id  =: PaymentRecId LIMIT 1];
        
        system.debug ('::orders::' +orders);
        if ( !Orders.isEmpty() ) {
                                                         
            ChargentOrders__ChargentOrder__c  order = orders[0];
            
             // QC #114159  - Prakash start
            string lastmodifiedName = getLastModifiedBy(Order.LastModifiedById);
                      
            // QC #114159  - Prakash end 
                        
            String PaymentDate = '';
            if ( Order.ChargentOrders__Payment_Start_Date__c <> NULL ) {
                
                PaymentDate  = Order.ChargentOrders__Payment_Start_Date__c.month()+'/'+ Order.ChargentOrders__Payment_Start_Date__c.Day()+'/'+ Order.ChargentOrders__Payment_Start_Date__c.year();
            }
            system.debug ('::PaymentDate::' +PaymentDate);
                     
            JSONGenerator gen = JSON.createGenerator(true);
            system.debug ('::PaymentDate::'+PaymentDate);
            gen.writeStartObject();
            gen.writeStringField('AccountNumber', order.Finance_Account_Number__r.Finance_Account_Number__c);
            if(order.Payment_Source_Nickname__r.Last_4__c != null)
            {
                gen.writeStringField('PaymentSource', order.Payment_Source_Nickname__r.Last_4__c);
            }
            else
            {
                gen.writeStringField('PaymentSource', '');
            }
            gen.writeStringField('PaymentDate', PaymentDate);
                        
            system.debug ('::order.ChargentOrders__Charge_Amount__c::' +order.ChargentOrders__Charge_Amount__c);
            if (order.ChargentOrders__Charge_Amount__c != NULL) {
                gen.writeStringField('PaymentAmount', String.valueof(order.ChargentOrders__Charge_Amount__c));
            }else {
                gen.writeStringField('PaymentAmount', '');
            }            
            system.debug (':::order.Finance_Account_Number__r.Payoff_Amount__c::' +order.Finance_Account_Number__r.Payoff_Amount__c);
            if (order.Finance_Account_Number__r.Payoff_Amount__c != NULL) {
                gen.writeStringField('PayoffAmount', String.valueof(order.Finance_Account_Number__r.Payoff_Amount__c)); 
            }else {
                gen.writeStringField('PayoffAmount', ''); 
            }
            // START QC #114159  - Prakash           
            gen.writeStringField('PaymentStatus', isInsertOrUpdate);
            // END QC #114159  - Prakash 
            gen.writeStringField('PaymentType', order.Payment_Type__c);
            gen.writeStringField('PaymentId', order.Id);
            
            //Added ConfirmationNumber for QC #114159  - Prakash             
            gen.writeStringField('ConfirmationNumber', order.Confirmation_Number__c);
            gen.writeStringField('LastModifiedBy', lastmodifiedName);
            // QC #114159  - Prakash End           
            gen.writeEndObject();
            system.debug ('::jsonString::');
            String jsonString = gen.getAsString();          
            system.debug ('::jsonString::');
            return jsonString;  
        } else {
            
            return null;
        }
    }
    
    // QC #114159  - Prakash start
    public static string getLastModifiedBy(Id userId) {
        
        String lastModifiedBy = '';
        List<User> userList = new List<User>();
        userList = [SELECT Id, Profile.Name FROM User WHERE Id = :userId];
        String profileName = (userList!=null && !userList.isEmpty()) ? userList[0].Profile.Name : '';
        
        if(CASS_Callout_LastModifiedBy__c.getInstance(profileName)!= null){
            return CASS_Callout_LastModifiedBy__c.getInstance(profileName).LastModifiedBy__c;
        }
        return '';
        
    }           
    // QC #114159  - Prakash End
    
    //method for Case noteIntegration
    @Future(callout=true)
    public static void makeHttpCallforCaseNoteInt(String caseId){
        System.debug('I entered in makeHttpCallforCaseNoteInt method of CASSCallout' +caseId);
        Datetime collectedTimestamp = system.now();
        String now = collectedTimestamp.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        //caseIsInsertOrUpdate = caseIsInsertOrUpdate; 
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        EDelivery_Resp_Code__c codes = EDelivery_Resp_Code__c.getOrgDefaults();
        String requestString;
        String urlParms;
        urlParms = generateURLParamString(caseId);
        try { 
        
        // HTTP CALL OUT
        
        CASSCallOut.FetchCredentials();
        System.Debug('===urlParms===' + urlParms );
        if(urlParms != '') {
            request.setEndpoint('callout:Case_Notes_CASS/REST/AHFC/Salesforce/LogNotes'+urlParms);
            //request.setEndpoint('123callout:Case_Notes_CASS/REST/AHFC/Salesforce/LogNotes'+urlParms);
            request.setHeader('hondaHeaderType.businessId', BUSINESS_ID);
            request.setHeader('hondaHeaderType.collectionTimeStamp', now);
            request.setHeader('hondaHeaderType.messageId', BUSINESS_ID);
            request.setHeader('hondaHeaderType.siteId',SITE_ID);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
            request.setHeader('Accept', 'application/json');
            request.setHeader('Content-Length', '250');
            request.setTimeout(TIME_OUT);
            request.setBody('');
            request.setMethod('POST');
            response = h.send(request);
            requestString = request.toString();
            system.debug('<<<---request--->>>'+request);
            system.debug('<<<---response--->>>'+response);
            Integer statusCode;
            statusCode = response.getStatusCode();
            if(response == null || statusCode != codes.HTTP_Success__c){
                /* RSS 46325 - PG-Systematic outage recovery/SF resync process */
                RetryCallout.RetrycalloutCreationfromCASScallout('callout:Case_Notes_CASS/REST/AHFC/Salesforce/LogNotes'+urlParms,'POST','',BUSINESS_ID,SITE_ID,TIME_OUT,caseId,'CASSCallOut',string.valueof(response),string.valueof(request),'application/json;charset=UTF-8',now); 
                /* RSS 46325 - PG-Systematic outage recovery/SF resync process */
                if(response == null)
                {
                    createErrorlog('Response is null',caseId,requestString,'');
                }
                else
                {
                    createErrorlog('HTTP Error - StatusCode: ' + statusCode ,caseId,requestString,response.getBody());
                }
            }
            
        } else {
            createErrorlog('FinanceAccount or service request on Case is blank',caseId,requestString,'');
            
        }
        System.Debug(' *** response3  ==> ' + response );
             
        
        } Catch ( Exception e ){ 
            system.debug('e---->>>>');
            /* RSS 46325 - PG-Systematic outage recovery/SF resync process */
            RetryCallout.RetrycalloutCreationfromCASScallout('callout:Case_Notes_CASS/REST/AHFC/Salesforce/LogNotes'+urlParms,'POST','',BUSINESS_ID,SITE_ID,TIME_OUT,caseId,'CASSCallOut',string.valueof(response),string.valueof(request),'application/json;charset=UTF-8',now); 
            /* RSS 46325 - PG-Systematic outage recovery/SF resync process */
            if(response == null){
                createErrorlog(e.getMessage(),caseId,requestString,'');
            }else{
                createErrorlog(response.getStatusCode()+''+e.getMessage(),caseId,requestString,response.getBody());
            }
            //createCASScalloutEvent(request, caseId, e);
            System.debug('errorlogMessage:-'+e.getMessage());
            
            
       }
        
    }
    /*
    //Method to publish platformEvent AHFC_CASS_Callout__e on Exception
    public static void createCASScalloutEvent(HttpRequest request, String affectedId, Exception e) {
        AHFC_CASS_Callout__e cassCallout = new AHFC_CASS_Callout__e();
            cassCallout.AHFC_Payload__c = request.toString(); //to get the URL parameters
            cassCallout.AHFC_Request_Body__c = request.getBody(); // to get the request body
            cassCallout.AHFC_Request_Header__c = getRequestHeader(request); // to get the header values
            cassCallout.AHFC_Exception_Msg__c = e.getMessage(); // to get the exception message
            cassCallout.AHFC_AffectedId__c = affectedId; //to get the failed record id
            
            // Call method to publish events
            Database.SaveResult result = EventBus.publish(cassCallout);
            
            // Inspect publishing result for each event
            if (result.isSuccess()) {
                System.debug('Successfully published event.');
            } else {
                for(Database.Error err : result.getErrors()) {
                    System.debug('Error returned: ' + err.getStatusCode() + ' - ' + err.getMessage());
                }
            }       
            
    }
    */
    //Method to create Request header String
    public static String getRequestHeader(HttpRequest request) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('hondaHeaderType.businessId', request.getHeader('hondaHeaderType.businessId') != null ? request.getHeader('hondaHeaderType.businessId') : '' );
        gen.writeStringField('hondaHeaderType.collectionTimeStamp', request.getHeader('hondaHeaderType.collectionTimeStamp') != null ? request.getHeader('hondaHeaderType.collectionTimeStamp') : '' );
        gen.writeStringField('hondaHeaderType.messageId', request.getHeader('hondaHeaderType.messageId') != null ? request.getHeader('hondaHeaderType.messageId') : '');
        gen.writeStringField('hondaHeaderType.siteId', request.getHeader('hondaHeaderType.siteId') != null ? request.getHeader('hondaHeaderType.siteId') : '');
        gen.writeStringField('Content-Type', request.getHeader('Content-Type') != null ? request.getHeader('Content-Type') : '');
        gen.writeStringField('Accept', request.getHeader('Accept') != null ? request.getHeader('Accept') : '');
        gen.writeStringField('Content-Length', request.getHeader('Content-Length') != null ? request.getHeader('Content-Length') : '');        
        gen.writeEndObject();
        
        String jsonString = gen.getAsString();          
        system.debug ('===jsonString===' + jsonString); 
        return jsonString;  
    }
    
    //helper method for generation paramter values for CaseIntegration
    public static String generateURLParamString(String caseId) {
        String urlParams ='';
        List<Case> caseList = [SELECT id,Origin,Type,Service_Request__c,Finance_Account__r.Finance_Account_Number__c FROM Case
                   WHERE id =:caseId LIMIT 1]; //T-769061 | Namita
                   
        
            if(!caseList.isEmpty()) {
                Case cs = caseList[0];
                 if(cs.Service_Request__c != null && cs.Service_Request__c != '' && cs.Finance_Account__c != null && cs.Finance_Account__r.Finance_Account_Number__c != null) {
                     
                    JSONGenerator gen = JSON.createGenerator(true);
                    System.debug('caseRequest:-'+cs.Service_Request__c);
                    String serviceRequest = cs.Service_Request__c.replaceAll('\\<.*?\\>', '');
                    System.debug('serviceRequest:-'+serviceRequest);
                        String serviceRequestArray = serviceRequest.replaceAll('\\n',',');
                        String encodedNote= EncodingUtil.urlEncode(serviceRequestArray, 'UTF-8');
                        System.debug('serviceRequestArray:-'+serviceRequestArray);
                        urlParams = '?AccountNum='+cs.Finance_Account__r.Finance_Account_Number__c+'&NotesText='+encodedNote;
                
                    return urlParams;
              }
            } 
            return '';
    }
    //Created by Anirudh Bora on 11/04/2016 as per I-371697
    private static void createErrorlog(String errorMessage, String caseId,String requestBody,String responseBody) {
        ErrorLog__c errorLog = new ErrorLog__c();
        errorLog.ClassName__c = 'CASSCallOut';
        errorLog.ExceptionErrorMessage__c = errorMessage;
        errorLog.AffectedId__c = caseId;
        errorLog.RequestBody__c = requestBody;
        errorLog.ResponseBody__c = responseBody;
        insert errorLog;
    }
    
}