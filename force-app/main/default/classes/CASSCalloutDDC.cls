public with sharing class CASSCalloutDDC{
    public CASSCalloutDDC(){
    }
    
    // Callout endpoint as a named credential URL
    private static final String LONG_RUNNING_SERVICE_URL = '<insert your callout URL here>';
    Public Static String SITE_ID;
    Public Static String BUSINESS_ID;
    Public Static Integer TIME_OUT;
    Public Static String isInsertOrUpdate;
    Public Static String caseIsInsertOrUpdate;
    @AuraEnabled(continuation = true)
    public static Object callDDCService(String FinAcctId, integer reqDueDay){
        system.debug('fa =>' + FinAcctId);
        system.debug('mths =>' + reqDueDay);
        
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        Integer ValidationError = 0;
        Boolean isValiduser = false;
        string contactId = null;
        String accountId = null;
        Finance_Account__c FinanceAccount = null;
        String errmsg = '';
        String FinId = '';
        Date dueDate;
        Continuation con;
        DDCDetails stateinfo = new DDCDetails(FinAcctId, reqDueDay);
        
        String ValidationResult = ValidateRequest(stateInfo);
        //ValidationResult =  'Process Automatically';
        //StateInfo.newDueDate = Date.today();
        if (ValidationResult ==  'Invalid Request'){
            createErrorlogevt(stateInfo.ErrorMessages[0], 'CASSCalloutDDC', FinId, 'FA:' + FinAcctId + ' Due Day:' + reqDueDay, 'Users:' + UserInfo.getUserId());
            throw new AuraHandledException(errmsg);
        }
        
        if (ValidationResult ==  'Process Manually'){
            system.debug('Manual Processing');
            con = new Continuation(1);
            con.continuationMethod = 'processManualRequest';
            con.state = stateInfo;
            request.setEndpoint('https://invalidurl.com');
            con.addHttpRequest(request);
            request.setBody('Manual');
            con.state = stateinfo;
            system.debug(con);
  
        }
        
        if (ValidationResult ==  'Process Automatically'){
            
            CASSCalloutDDC.buildRequest(request, stateInfo.finacctnbr, stateInfo.newDueDate);
            con = new Continuation(120);
            con.continuationMethod = 'processDDCResponse';
            con.state = stateinfo;
            con.addHttpRequest(request);   
        }
        
        
        return con;
 
    }
    
    @AuraEnabled
    public static Object processManualRequest(List<String> labels, Object state){
        System.debug('Process Manual Request');
        HttpResponse response = Continuation.getResponse(labels[0]);
        system.debug(response);
        String returnval = 'SUCCESS';
        DDCDetails ddcinfo = (DDCDetails)State;
        InsertCase (ddcinfo,'Pending Payment', ddcinfo.ErrorMessages[0]);
        return returnval;
    }
    
    
    public static String ValidateRequest(DDCDetails DDCReq)    {
        
        String ValidationRslt ='';
        String contactId;
        String accountId;
        finance_account__c FinanceAccount;
        Integer ValidationError = 0;
        String FinId = '';
        Date dueDate;
        
        Integer reqDueDay ;
        String errMsg;
        Decimal TotalAmountDue =0;
        Decimal TotalPayments =0;
        Boolean NewRetailAccount = false;
        
        
        //Validate Account is not past due or new
        //Validate due date
        
        if (DDCReq.FinAcctId == null || DDCReq.FinAcctId == ''){
            ValidationRslt = 'Invalid Request';
            DDCReq.ErrorMessages[0] = 'Null Finance Account';
            return ValidationRslt;
        }
        
        if (DDCReq.DueDay == null || DDCReq.DueDay < 1 || DDCReq.DueDay> 28 ){
            ValidationRslt = 'Invalid Request';
            DDCReq.ErrorMessages[0] = 'Invalid Due Day';
            return ValidationRslt;
        }
        
        for (User user : [Select Id, contactID, contact.AccountId from User Where Id = :UserInfo.getUserId()])
        {
            system.debug('Validate Request user :' + user);
            system.debug('user.contactID :' + user.contactID);
            system.debug('user.contact.AccountId' + user.contact.AccountId);
            contactId = user.contactID;
            if (user.contactId != null){
                accountId = user.contact.AccountId;
                DDCReq.ContactId = user.contactId;
                system.debug('After User Query DDReq :' + DDCReq);
            }
            else {
                ValidationRslt = 'Invalid Request';
                DDCReq.ErrorMessages[0] = 'Could Not Retrieve User';
                return ValidationRslt;
            }
                
            
        }
        if (accountId == null || accountId == '') {
            ValidationRslt = 'Invalid Request';
            DDCReq.ErrorMessages[0] = 'Account or Contact on User Record is Empty';
            return ValidationRslt;
        }
        system.debug('Validate Request Fin id' + DDCReq.FinAcctId);
        for (Finance_Account__c fAccount : [Select Id, Due_On_Day__c, Customer__c, Contact__c, Finance_Account_Number__c, 
                                            Next_Due_Date__c, Past_Amount_Due__c,Total_Fees_Due__c,
                                            First_Due_Date__c, Paid_to_Date__c, Account_Type__c,
                                            Regular_Monthly_Payment__c
                                            from Finance_Account__c 
                                            Where id = :DDCReq.FinAcctId])
        {
            FinanceAccount = fAccount;
            system.debug ('Validate Request Finance Account:' + FinanceAccount);
            //FinanceAccount.Customer__c = (FinanceAccount.Customer__c!=null) ? FinanceAccount.Customer__c:'';
            FinanceAccount.Contact__c = (FinanceAccount.Contact__c!=null) ? FinanceAccount.Contact__c:'';
            FinanceAccount.Finance_Account_Number__c = (FinanceAccount.Finance_Account_Number__c!=null) ? FinanceAccount.Finance_Account_Number__c:'';
            
            FinanceAccount.Account_Type__c = (FinanceAccount.Account_Type__c!=null) ? FinanceAccount.Account_Type__c:'';
            
            FinanceAccount.Past_Amount_Due__c = (FinanceAccount.Past_Amount_Due__c!=null) ? FinanceAccount.Past_Amount_Due__c:0;
            FinanceAccount.Total_Fees_Due__c = (FinanceAccount.Total_Fees_Due__c!=null) ? FinanceAccount.Total_Fees_Due__c:0;
            FinanceAccount.Regular_Monthly_Payment__c = (FinanceAccount.Regular_Monthly_Payment__c!=null) ? FinanceAccount.Regular_Monthly_Payment__c:0;
            DDCReq.olddueday = (FinanceAccount.Due_On_Day__c!=null) ? FinanceAccount.Due_On_Day__c:'0';


        }
        
        
        
        if (FinanceAccount == null){
            ValidationRslt = 'Invalid Request';
            DDCReq.ErrorMessages[0] = 'FA Not Found';
            FinId = 'Invalid Account';
            
                return ValidationRslt;
        }
        DDCReq.FinAcctNbr =  FinanceAccount.Finance_Account_Number__c;
        
        If (FinanceAccount.Next_Due_Date__c != null && FinanceAccount.Paid_to_Date__c != null
           && FinanceAccount.Paid_to_Date__c > FinanceAccount.Next_Due_Date__c)
        {
            DDCReq.newdueDate= GetNextDueDate(FinanceAccount.Paid_to_Date__c, DDCReq.DueDay);
        }
        else if (FinanceAccount.Next_Due_Date__c != null) {
            DDCReq.newdueDate= GetNextDueDate(FinanceAccount.Next_Due_Date__c, DDCReq.DueDay);
        }
        Else{
            ValidationRslt = 'Invalid Request';
            DDCReq.ErrorMessages[0] = 'Next Due Date on FA is Empty';
            return ValidationRslt;
        }
        
        system.debug('@@@ DDCReq.newdueDate: ' + DDCReq.newdueDate);
        
          //fetching the customer finance accounts to check for valid user.
        ValidationRslt = 'Invalid Request';
        for (Customer_Finance_Account__c cFinanceAcc : [SELECT id, Finance_Account__c, Customer__c
                                                        FROM Customer_Finance_Account__c 
                                                        WHERE Finance_Account__c  = :DDCReq.FinAcctId])
        {
            if (cFinanceAcc.Customer__c == accountId){
                ValidationRslt = '';
                
            }
        }
        
        if (ValidationRslt == 'Invalid Request') {
            DDCReq.ErrorMessages[0] = 'Customer Finance Account Not Found';
            return ValidationRslt ;
        }
        
        List<Case> lstcase = [select id from case where
                             Finance_Account__c = :DDCReq.FinAcctId
                             And Type = 'Due Date Change'
                             And Status <> 'Closed'];
        if (lstcase.size() > 0) {
            ValidationRslt = 'Invalid Request';
            DDCReq.ErrorMessages[0] = 'DDC Case Exists';
            return ValidationRslt;
        }
        
        TotalAmountDue = FinanceAccount.Past_Amount_Due__c + FinanceAccount.Total_Fees_Due__c;
        
        AggregateResult[] AggrTotalPayments = [select sum(ChargentOrders__Charge_Amount__c)Payments
                                            from 	ChargentOrders__ChargentOrder__c where
                                            Finance_Account_Number__c = :DDCReq.FinAcctId
                                            And ((Payment_Display_Status__c in ('Pending', 'Processing')
                                                  AND Payment_Channel__c in ('A','W','I')
                                                  AND  ChargentOrders__Payment_Start_Date__c <= today
                                                 )
                                                 OR (Next_Withdrawal_Date__c <= today
                                                     AND Payment_Channel__c = 'R'
                                                     AND Payment_Display_Status__c in ('Pending', 'Processing')
                                                    )
                                                 )];
        
        
        if (AggrTotalPayments[0].get('Payments') != null)  TotalPayments = (Decimal)AggrTotalPayments[0].get('Payments');
       
        System.debug ('TotalPayments  after update:' + TotalPayments);
        system.debug('AggrTotalPayments :' + AggrTotalPayments);
        
        System.debug ('TotalAmountDue :' + TotalAmountDue);
        System.debug ('TotalPayments :' + TotalPayments);
        
        if (TotalAmountDue > TotalPayments ) {
            ValidationRslt = 'Invalid Request';
            DDCReq.ErrorMessages[0] = 'Past Due Account';
            return ValidationRslt;
        }
        
        if (FinanceAccount.Paid_to_Date__c == null || FinanceAccount.First_Due_Date__c == null){
            ValidationRslt = 'Invalid Request';
            DDCReq.ErrorMessages[0] = 'Paid to Date or First Due Date is Empty';
            return ValidationRslt;
        }
       
       if ((FinanceAccount.Paid_to_Date__c == FinanceAccount.First_Due_Date__c) && 
           (FinanceAccount.Account_Type__c == 'Retail') &&
           (FinanceAccount.Regular_Monthly_Payment__c > TotalPayments)
          ){
              ValidationRslt = 'Invalid Request';
            DDCReq.ErrorMessages[0] = 'New Account First payment not made';
            return ValidationRslt;
              
          }
       
       if (FinanceAccount.Paid_to_Date__c == FinanceAccount.First_Due_Date__c) 
            
            NewRetailAccount = true;
        
        if ((TotalPayments >= TotalAmountDue ) && TotalAmountDue !=0) {
            ValidationRslt = 'Process Manually';
            DDCReq.ErrorMessages[0] = 'Past Due Account with same day Payments';
        }
        else if (NewRetailAccount){
            ValidationRslt = 'Process Manually';
            DDCReq.ErrorMessages[0] = 'New Account';
        }
        else if (ValidationRslt != 'Invalid Request') {
            ValidationRslt = 'Process Automatically';
        }
        
        
        return ValidationRslt;
    }
    
    
    @AuraEnabled
    public static Object processDDCResponse(List<String> labels, Object state){
        system.debug('Static Callback Method labels =>');
        system.debug(labels);
        system.debug('State =>');
        system.debug(state);
        String CaseStatus;
        String returnval = 'Failed';
        String result = '';
        String webServiceResult = '';
        
        
        
        HttpResponse response = Continuation.getResponse(labels[0]);
        system.debug('Static Callback Method response =>');
        system.debug(response);
        result = response.getBody();
        
        
  //case when service does not return      
        if (response.getStatusCode()<> 200){
             createErrorlogevt('Callout Failed', 'CASSCalloutDDC', String.valueOf(state), '', String.valueOf(response));
             InsertCase ((DDCDetails)State,'Automatic - Failed', String.valueOf(response));
             return returnval;
        }
        
        
        // Set the result variable
       
        String Processing_type = 'Automatic - Failed';
        
        system.debug('response body =>' + result);
        try{
            DDCResponse resp = DDCResponse.parse(result);
         
            system.debug('DDCResponse: ' +  resp);
            system.debug('resp.Header.Code: ' +  resp.Header.Code);
            if (resp.Header.Code == 200){
                returnval = 'SUCCESS';
                Processing_type = 'Automatic - Successful';
                webServiceResult = String.valueOf(resp);                
                
            }
            else{
                returnval = 'Failed';
                Processing_type = 'Automatic - Failed';
                if (resp.Header.Code == 600 && resp.Body.strErrorMessage=='AF in Next day Mode'){
                    Processing_type = 'Pending - Retry';
                }
                webServiceResult = String.valueOf(resp);
                createErrorlogevt('Callout Failed', 'CASSCalloutDDC', String.valueOf(state), '', String.valueOf(resp));
            	
            }
            system.debug('Header =>' + resp.Header);
            
            
        } catch (Exception e){
            returnval = 'Failed';
            system.debug('in catch step');
            system.debug('body =>' + result);
            system.debug('err =>' + e.getMessage());
            Processing_type = 'Automatic - Failed';
            webServiceResult = result;
            createErrorlogevt(e.getMessage(), 'CASSCalloutDDC', String.valueOf(state), '', '');
            
        }
        
        try {
            InsertCase ((DDCDetails)State,Processing_type, webServiceResult);
        }
        Catch (Exception e){
            returnval = 'Failed';
            system.debug('Error in inserting case record');
            system.debug('body =>' + result);
            system.debug('err =>' + e.getMessage());
            createErrorlogevt(e.getMessage(), 'CASSCalloutDDC', String.valueOf(state), '', '');
            throw new AuraHandledException('Error in inserting case record');
            
            
        }
        
        
        
        return returnval;
    }
    
   
    
    Private  Static void InsertCase( DDCDetails ddcdetails, String ProcessingType, String WebSvcResult){
        String casestatus = 'New';
        String ContentNoteTemplate;
        String CustomerContactId;
        String currentDateTime = (DateTime.Now()).format('MM/dd/yyyy hh:mm:ss aaa', 'America/Los_Angeles'); //"yyyy.MM.dd G 'at' hh:mm:ss "
        ContentNoteTemplate = '<p><strong>Date/Time Received:</strong> ' + currentDateTime + ' </p> ';
        ContentNoteTemplate = ContentNoteTemplate + '<p><strong>Finance Account Number:</strong> ' + ddcdetails.FinAcctNbr + ' </p>';
        ContentNoteTemplate = ContentNoteTemplate + '<p><strong>Current Due Date:</strong>' + GetDueDayInWords (Integer.valueOf(ddcdetails.oldDueDay)) + '</p>' ;
        ContentNoteTemplate = ContentNoteTemplate +  '<p><strong>Requested Due Date:</strong>' + GetDueDayInWords (ddcdetails.DueDay) + '</p>';
        
        //check if case was created withing last x seconds
        
        DateTime lstCreateddatetime = (DateTime.Now()).addSeconds(-15);
        system.debug ('@@@@ lstCreateddatetime : ' + lstCreateddatetime);
        system.debug ('@@@@ now : ' + DateTime.Now());
        Case cse = new case();
        
        list<case> lstExistingCase = [select id from case where
                                     createddate > :lstCreateddatetime
                                     and Finance_Account__c = :ddcdetails.FinAcctId
                                     and type = 'Due Date Change'
                                     and Origin = 'Web'
                                     ];
        
        
        
        switch on ProcessingType{
            when 'Pending Payment'{
                casestatus = 'New';
                //cse.ownerid = system.label.unassigned_queue_id;
               cse.ownerid = system.label.Pending_Payments_Queue_Id;
                
                
            }
            when 'Automatic - Successful'{
                casestatus = 'Closed';
                cse.ownerid = system.label.Closed_Queue_Id;
                
            }
            when 'Automatic - Failed'{
                casestatus = 'New';
                cse.ownerid = system.label.unassigned_queue_id;
                
            }
            when 'Pending - Retry'{
                casestatus = 'New';
                cse.ownerid = system.label.DDC_Retry_Queue_Id;
                
            }
            
        }
        
        
        cse.ContactId = ddcdetails.ContactId;
        cse.Finance_Account__c = ddcdetails.FinAcctId;
        cse.Origin = 'Web';
        cse.Requested_Next_Due_Date_Day__c = String.valueOf(ddcdetails.DueDay);
        cse.Requested_Next_Due_Dte__c = ddcdetails.newDueDate;
        cse.Service_Request__c = ContentNoteTemplate;
        cse.Subject = 'Due Date Change Request' ;
        cse.type = 'Due Date Change' ;   
        cse.Processing_Type__c = ProcessingType;
        cse.WebService_Result__c = WebSvcResult;
        cse.Status = casestatus;
        if (cse.Status == 'Closed') cse.Case_Reason__c = 'Resolved';
        cse.Service_Request__c = ContentNoteTemplate;
        if (lstExistingCase.size() == 0)   insert cse;
        
    }
    
    Public Static String GetDueDayInWords (integer i){
        String DueDayInWords = '';
        if(i == 1|| i == 21 || i == 31){
                         DueDayInWords = i + 'st of the month';
                     }else if(i == 2  || i == 22) {
                         DueDayInWords = i + 'nd of the month';
                     }else if(i == 3 || i == 23){
                         DueDayInWords = i + 'rd of the month';  
                     }else {
                         DueDayInWords = i + 'th of the month';
                     }
        return DueDayInWords;
                     
    }
                             
    public static void buildRequest(HttpRequest request, String FinAcctNbr, Date dueDate){
        CASSCallOut.FetchCredentials();
        TIME_OUT = CASSCallOut.TIME_OUT;
        
        request.setEndpoint('callout:DDC');
        
        
        System.debug(request.getEndpoint());
        request.setHeader('hondaHeaderType.businessId', CASSCallOut.BUSINESS_ID);
        Datetime collectedTimestamp = system.now();
        String now = collectedTimestamp.formatGmt('yyyy-MM-dd HH:mm:ss');
        request.setHeader('hondaHeaderType.collectionTimeStamp', now);
        request.setHeader('hondaHeaderType.messageId', CASSCallOut.BUSINESS_ID);
        request.setHeader('hondaHeaderType.siteId', CASSCallOut.SITE_ID);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setTimeout(CASSCallOut.TIME_OUT);
        system.debug('hondaHeaderType.businessId:' + request.getHeader('hondaHeaderType.businessId'));
        system.debug('hondaHeaderType.collectionTimeStamp:' + request.getHeader('hondaHeaderType.collectionTimeStamp'));
        system.debug('hondaHeaderType.messageId:' + request.getHeader('hondaHeaderType.messageId'));
        system.debug('hondaHeaderType.siteId:' + request.getHeader('hondaHeaderType.siteId'));
        system.debug('Content-Type:' + request.getHeader('Content-Type'));
        system.debug('Accept' + request.getHeader('Accept'));
        system.debug('Timeout' + TIME_OUT);
        
        ddcRequest ddcReq = new ddcRequest();
        ddcReq.AccountNumber = FinAcctNbr;
        ddcReq.DueDate = dueDate.month() + '/'  + dueDate.day() + '/' + dueDate.year();
        request.setBody(JSON.serialize(ddcReq));
        
        
        system.debug(request.getBody());
        system.debug(request.getEndpoint());
        
        
        request.setMethod('POST');
    }
    
    
    private static void createErrorlogevt(String errorMessage, String className, String finId, String requestBody, String responseBody){
        log__e errorLog = new log__e();
        system.debug(errorMessage);
        system.debug(className);
        system.debug(finId);
        system.debug(requestBody);
        system.debug(responseBody);
        errorLog.ClassName__c = className;
        errorLog.Exception_Error_Message__c = errorMessage.abbreviate(131072);
        errorlog.ExceptionMsg__c = errorMessage.abbreviate(255);
        errorLog.AffectedId__c = finId;
        errorLog.RequestBody__c = requestBody;
        errorLog.ResponseBody__c = responseBody;
        EventBus.publish(errorLog);
    }
    
    Public static Date GetNextDueDate(date currentDueDate, integer dayOfMonth){
        integer dueDateDay = currentDueDate.day();
        integer dueDateMth = currentDueDate.month();
        integer dueDateYear = currentDueDate.year();
        date dueDateNextMth = currentDueDate.addMonths(1);
        integer daysinCurrentMonth = date.daysInMonth(dueDateYear, dueDateMth);
        integer nextMthdueDateMth = dueDateNextMth.month();
        integer nextMthdueDateYear = dueDateNextMth.year();
        integer daysinNextMonth = date.daysInMonth(nextMthdueDateYear, nextMthdueDateMth);
        Date NextDueDate;
        NextDueDate = currentDueDate.addMonths(1);
        if (dayOfMonth > dueDateDay && dayOfMonth <= daysinCurrentMonth){
            NextDueDate = date.newInstance(dueDateYear, dueDateMth, dayOfMonth);
        } else if (dayOfMonth <= daysinNextMonth){
            NextDueDate = date.newInstance(nextMthdueDateYear, nextMthdueDateMth, dayOfMonth);
        } else{
            throw new AuraHandledException('Unable to Compute Next Due Date');
        }
        system.debug('NextDueDate :' + NextDueDate);
        return NextDueDate;
    }
    
    Public Class DueDateException extends Exception{
        
    }
    Public Class DDCRequest {
        Public String AccountNumber ;
        Public String DueDate ;
    }
    
    
    
    
}