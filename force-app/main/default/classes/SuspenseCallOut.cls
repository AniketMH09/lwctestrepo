//Created By Vishal Chopra,  7/22/2020  
//Last Modified By  Admin Vishal ,  3/12/2020 2:10 PM
    


Public Class SuspenseCallOut{
    
    Public Static String    SITE_ID ;
    Public Static String    BUSINESS_ID ; 
    Public Static Integer   TIME_OUT ;
    Public Static String isInsertOrUpdate; 
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
    Public Static Void makeHttpCallforSuspense(String SuspenseId){
        System.Debug(' *** SuspenseId  ==> ' + SuspenseId );
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        
        try { 
        
        // HTTP CALL OUT
        
        SuspenseCallOut.FetchCredentials();
         
        request.setEndpoint('callout:Suspense_CASS_Integration/REST/AHFC/SalesForce/UpdateSFSuspense/1.0/');
        request.setHeader('hondaHeaderType.businessId', BUSINESS_ID);
        Datetime collectedTimestamp = system.now();
        String now = collectedTimestamp.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        request.setHeader('hondaHeaderType.collectionTimeStamp', now);
        request.setHeader('hondaHeaderType.messageId', BUSINESS_ID);
        request.setHeader('hondaHeaderType.siteId', SITE_ID);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Length', '250');
        request.setTimeout(TIME_OUT);
        
        // JSON GENERATOR
        String json = jsonSuspenseGenerator(SuspenseId);
       //String json=jsonSuspenseGenerator('1');
        System.Debug(' *** json  ==> ' + json );
        
        request.setBody(json);
        request.setMethod('POST');
        response = h.send(request);
          Integer statusCode;
        statusCode = response.getStatusCode();
        EDelivery_Resp_Code__c codes = EDelivery_Resp_Code__c.getOrgDefaults();
        if(response == null || statusCode != codes.HTTP_Success__c)
        {
            if(response == null)
                {
            		ErrorLog__c errorLog = new ErrorLog__c();
            		errorLog.ClassName__c = 'SuspenseCallOut';
            		errorLog.ExceptionMsg__c = 'Response is null';
            		errorLog.AffectedId__c = SuspenseId;
            		errorLog.RequestBody__c = request.getBody();
            		insert errorLog;
                }
                else
                {
            		ErrorLog__c errorLog = new ErrorLog__c();
            		errorLog.ClassName__c = 'SuspenseCallOut';
            		errorLog.ExceptionMsg__c = 'HTTP Error - StatusCode:' + statusCode;
            		errorLog.AffectedId__c = SuspenseId;
            		errorLog.RequestBody__c = request.getBody();
            		insert errorLog;
            
                  }
            
        }
        System.Debug(' *** response  ==> ' + response );             
        
        } Catch ( Exception e ){
            ErrorLog__c errorLog = new ErrorLog__c();
            errorLog.ClassName__c = 'SuspenseCallOut';
            errorLog.ExceptionMsg__c = e.getMessage();
            errorLog.AffectedId__c = SuspenseId;
            errorLog.RequestBody__c = request.getBody();
            insert errorLog;
            
        }
       
    }
       
  
    
    // (callout=true)
    Public Static Void makeHttpCallforSuspenseBatch(String SuspenseId){
        System.Debug(' *** SuspenseId  ==> ' + SuspenseId );
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        
        try { 
        
        // HTTP CALL OUT
        
        SuspenseCallOut.FetchCredentials();
         
        request.setEndpoint('callout:Suspense_CASS_Integration/REST/AHFC/SalesForce/UpdateSFSuspense/1.0/');
        request.setHeader('hondaHeaderType.businessId', BUSINESS_ID);
        Datetime collectedTimestamp = system.now();
        String now = collectedTimestamp.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        request.setHeader('hondaHeaderType.collectionTimeStamp', now);
        request.setHeader('hondaHeaderType.messageId', BUSINESS_ID);
        request.setHeader('hondaHeaderType.siteId', SITE_ID);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Length', '250');
        request.setTimeout(TIME_OUT);
        
        // JSON GENERATOR
        String json = jsonSuspenseGenerator(SuspenseId);
       //String json=jsonSuspenseGenerator('1');
        System.Debug(' *** json  ==> ' + json );
        
        request.setBody(json);
        request.setMethod('POST');
        response = h.send(request);
        
        System.Debug(' *** response  ==> ' + response );             
        
        } Catch ( Exception e ){
            ErrorLog__c errorLog = new ErrorLog__c();
            errorLog.ClassName__c = 'SuspenseCallOut';
            errorLog.ExceptionMsg__c = e.getMessage();
            errorLog.AffectedId__c = SuspenseId;
            errorLog.RequestBody__c = request.getBody();
            insert errorLog;
            
        }
       
    }
       
  
    Public static String jsonSuspenseGenerator(String SuspenseId){
         
       
        Suspense__c[] suspenses = [Select id,Account_Number__c,Action_Taken__c,CkReqCaseNum__c,Operator_Action_Taken__c,Cleared_Action_Taken_1__c
                                   ,Cleared_Action_Taken_2__c,Comments__c,Completed_By__c,Completed_Date__c,ConfirmDate__c,Account_Number1__c,Account_Number2__c,
                                   Effective_Date__c,Expense_Amt__c,Expense_Comment__c,Origin_Code__c,Pending_Date__c,User__r.Name,Process_Status__c,Process_Date__c
                                   ,Expense_Action_Taken__c,RefNum__c,Refund_Amt__c,Refund_Comments__c,Sequence_Number__c,Tran_Amount__c,TranCode__c,TranDesc__c,
                                   Transaction_Amount_Split_1__c,Transaction_Amount_Split_2__c
                                   from Suspense__c where Id  =: SuspenseId LIMIT 1];
        
        system.debug ('::Suspense::' +suspenses);
        if ( !suspenses.isEmpty() ) {
                                                         
            Suspense__c  suspense = suspenses[0];
            system.debug ('::jsonString::');
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            if (suspense.Sequence_Number__c != NULL) {
                gen.writeStringField('Seq', suspense.Sequence_Number__c);
            }
            else
            {
                gen.writeStringField('Seq', '');
            }
            
            if (suspense.Tran_Amount__c != NULL) {
                gen.writeStringField('TranAmount', String.valueof(suspense.Tran_Amount__c));
            }
            else
            {
                gen.writeStringField('TranAmount', '');
            }
            
            if (suspense.Effective_Date__c!= NULL){
                gen.writeStringField('EffDate', String.valueof(suspense.Effective_Date__c));
            }
            else
            {
                gen.writeStringField('EffDate', '');
            }
            
            if(suspense.Process_Date__c!= NULL){
                gen.writeStringField('ProcessDt', String.valueof(suspense.Process_Date__c));    
            }
            else
            {
                gen.writeStringField('ProcessDt', '');
            }
            
             if(suspense.Pending_Date__c!= NULL){
                gen.writeStringField('PendingDt', String.valueof(suspense.Pending_Date__c));    
            }
            else
            {
                gen.writeStringField('PendingDt', '');
            }
            
            if (suspense.Account_Number__c != NULL)
            {
                gen.writeStringField('AccountNumber', suspense.Account_Number__c);
            }
            else
            {
                gen.writeStringField('AccountNumber', '');
            }
            
            

            if (suspense.CkReqCaseNum__c != NULL)
            {
                gen.writeStringField('CkReqCasNo', suspense.CkReqCaseNum__c);
            }
            else
            {
                gen.writeStringField('CkReqCasNo', '');
            }

             if (suspense.Operator_Action_Taken__c!= NULL)
            {
                gen.writeStringField('ClearedActTak', suspense.Operator_Action_Taken__c);
            }
            else
            {
                gen.writeStringField('ClearedActTak', '');
            }


            if (suspense.Process_Status__c!= NULL)
            {
                gen.writeStringField('PendingStatus', suspense.Process_Status__c);
            }
            else
            {
                gen.writeStringField('PendingStatus', '');
            }




            if (suspense.Cleared_Action_Taken_1__c != NULL)
            {
                gen.writeStringField('ClearedActTak1', suspense.Cleared_Action_Taken_1__c);
            }
            else
            {
                gen.writeStringField('ClearedActTak1', '');
            }


            if (suspense.Cleared_Action_Taken_2__c != NULL)
            {
                gen.writeStringField('ClearedActTak2', suspense.Cleared_Action_Taken_2__c);
            }
            else
            {
                gen.writeStringField('ClearedActTak2', '');
            }




            if (suspense.Comments__c != NULL)
            {
                gen.writeStringField('comments', suspense.Comments__c);
            }
            else
            {
                gen.writeStringField('comments', '');
            }


            if (suspense.Completed_By__c != NULL)
            {
                gen.writeStringField('completedName', suspense.Completed_By__c + '-SF');
            }
            else
            {
                gen.writeStringField('completedName', '');
            }

 if (suspense.User__r.Name!= NULL)
            {
                gen.writeStringField('PendingOper', suspense.User__r.Name + '-SF');
            }
            else
            {
                gen.writeStringField('PendingOper', '');
            }

            if (suspense.Completed_Date__c != NULL)
            {
                gen.writeStringField('completeddt', String.valueof(suspense.Completed_Date__c));
            }
            else
            {
                gen.writeStringField('completeddt', '');
            }


            if (suspense.ConfirmDate__c != NULL)
            {
                gen.writeStringField('ConfirmDt', String.valueof(suspense.ConfirmDate__c));
            }
            else
            {
                gen.writeStringField('ConfirmDt', '');
            }


            if (suspense.Account_Number1__c != NULL)
            {
                gen.writeStringField('AccountNumber1', suspense.Account_Number1__c);
            }
            else
            {
                gen.writeStringField('AccountNumber1', '');
            }


            if (suspense.Account_Number2__c != NULL)
            {
                gen.writeStringField('AccountNumber2', suspense.Account_Number2__c);
            }
            else
            {
                gen.writeStringField('AccountNumber2', '');
            }


            if (suspense.Expense_Amt__c != NULL)
            {
                gen.writeStringField('ExpAmt', String.valueof(suspense.Expense_Amt__c));
            }
            else
            {
                gen.writeStringField('ExpAmt', '');
            }


            if (suspense.Expense_Comment__c != NULL)
            {
                gen.writeStringField('ExpenseComm', suspense.Expense_Comment__c);
            }
            else
            {
                gen.writeStringField('ExpenseComm', '');
            }


            if (suspense.Expense_Action_Taken__c != NULL)
            {
                gen.writeStringField('ExpenseActionTaken', suspense.Expense_Action_Taken__c);
            }
            else
            {
                gen.writeStringField('ExpenseActionTaken', '');
            }

            if (suspense.RefNum__c != NULL)
            {
                gen.writeStringField('RefNum', suspense.RefNum__c);
            }
            else
            {
                gen.writeStringField('RefNum', '');
            }


            if (suspense.Refund_Amt__c != NULL)
            {
                gen.writeStringField('RefundAmt', String.valueof(suspense.Refund_Amt__c));
            }
            else
            {
                gen.writeStringField('RefundAmt', '');
            }


            if (suspense.Refund_Comments__c != NULL)
            {
                gen.writeStringField('RefundComm', suspense.Refund_Comments__c);
            }
            else
            {
                gen.writeStringField('RefundComm', '');
            }


            if (suspense.Transaction_Amount_Split_1__c != NULL)
            {
                gen.writeStringField('TranamtSplit1', String.valueof(suspense.Transaction_Amount_Split_1__c));
            }
            else
            {
                gen.writeStringField('TranamtSplit1', '');
            }

           

            if (suspense.Transaction_Amount_Split_2__c != NULL)
            {
                gen.writeStringField('TranamtSplit2', String.valueof(suspense.Transaction_Amount_Split_2__c));
            }
            else
            {
                gen.writeStringField('TranamtSplit2', '');
            }

           
            
            gen.writeEndObject();
            system.debug ('::jsonString::');
            String jsonString = gen.getAsString();          
            system.debug ('::jsonString::' +jsonString);
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
    
  
    //Created by Anirudh Bora on 11/04/2016 as per I-371697
    private static void createErrorlog(String errorMessage, String caseId,String requestBody,String responseBody) {
        ErrorLog__c errorLog = new ErrorLog__c();
        errorLog.ClassName__c = 'SuspenseCallOut';
        errorLog.ExceptionErrorMessage__c = errorMessage;
        errorLog.AffectedId__c = caseId;
        errorLog.RequestBody__c = requestBody;
        errorLog.ResponseBody__c = responseBody;
        insert errorLog;
    }
    
}