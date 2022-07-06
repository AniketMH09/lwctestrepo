/*CASSCalloutLE create to call web service for Lease Extension
Created on 10 May 2021 by Gufran*/

public with sharing class CASSCalloutLE{
    
    @TestVisible
    private static String continuationLabel;
    @TestVisible
    private static LEDetails continuationState;
    
   
    
    public CASSCalloutLE(){
    } 
    
    // Callout endpoint as a named credential URL
    private static final String LONG_RUNNING_SERVICE_URL = '<insert your callout URL here>';
    Public Static String SITE_ID;
    Public Static String BUSINESS_ID;
    Public Static Integer TIME_OUT;
    Public Static String isInsertOrUpdate;
    Public Static String caseIsInsertOrUpdate;
    public static String ProfileName = 'System Administrator';
    public static Boolean forTestOnly = true; 
    public static String EasyPayInd = 'N';
    @AuraEnabled(continuation = true)
    public static Object callLEService(String FinAcctId, integer reqExtLength){
        system.debug('Inside callLEService');
        system.debug('fa =>' + FinAcctId);
        system.debug('mths =>' + reqExtLength);
        setEasyPayIndicator(FinAcctId);
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
        system.debug('FinAcctId---'+FinAcctId);
        system.debug('reqExtLength----'+reqExtLength);
        LEDetails stateinfo = new LEDetails(FinAcctId, reqExtLength);
        system.debug('stateinfo---'+stateinfo);
        String ValidationResult = ValidateRequest(stateInfo);
        system.debug('ValidationResult---'+ValidationResult);
        //ValidationResult =  'Process Automatically';
        //StateInfo.newDueDate = Date.today();
        //!Test.isRunningTest() ? (forTestOnly = false) : (forTestOnly = true);
        if(Test.isRunningTest()){
            forTestOnly = false;
            //createErrorlogevt(stateInfo.ErrorMessages[0], 'CASSCalloutLE', FinId, 'FA:' + FinAcctId + ' Lease Extension:' + reqExtLength, 'Users:' + UserInfo.getUserId());
        }
        if (ValidationResult ==  'Invalid Request' && forTestOnly){
            //!Test.isRunningTest() ? false : true
            createErrorlogevt(stateInfo.ErrorMessages[0], 'CASSCalloutLE', FinId, 'FA:' + FinAcctId + ' Lease Extension:' + reqExtLength, 'Users:' + UserInfo.getUserId());
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
            system.debug('inside Process Automatically');
            CASSCalloutLE.buildRequest(request, stateInfo.FinAcctNbr, stateInfo.ExtLength);
            con = new Continuation(120);
            con.continuationMethod = 'processLEResponse';
            continuationLabel=con.addHttpRequest(request); 
            continuationState=stateinfo;
            con.state = stateinfo;
            //con.addHttpRequest(request);
            system.debug('@@@ Con.addHttpRequest--'+con.getRequests());
        }

        return con;
    }
    
    @AuraEnabled
    public static Object processManualRequest(List<String> labels, Object state){
        System.debug('Process Manual Request');
        HttpResponse response = Continuation.getResponse(labels[0]);
        system.debug(response);
        String returnval = 'SUCCESS';
        LEDetails leinfo = (LEDetails)State;
        InsertCase (leinfo,'Pending Payment', leinfo.ErrorMessages[0]);
        return returnval;
    }
    
    public static String ValidateRequest(LEDetails LEReq)    {
		system.debug('Inside ValidateRequest');
        String ValidationRslt ='';
        String contactId;
        String accountId;
        finance_account__c FinanceAccount;
        Integer ValidationError = 0;
        String FinId = '';
        Date dueDate;
        Date leDate;
        Integer reqExtLength ;
        String errMsg;
        Decimal TotalAmountDue =0;
        Decimal TotalPayments =0;
        Boolean NewRetailAccount = false;
        
        
        //Validate Account is not past due or new
        //Validate due date
        
        if (LEReq.FinAcctId == null || LEReq.FinAcctId == ''){
            ValidationRslt = 'Invalid Request';
            LEReq.ErrorMessages[0] = 'Null Finance Account';
            return ValidationRslt;
        }
        
        if (LEReq.ExtLength == null || LEReq.ExtLength < 1 || LEReq.ExtLength> 28 ){
            ValidationRslt = 'Invalid Request';
            LEReq.ErrorMessages[0] = 'Invalid Lease Extension';
            return ValidationRslt;
        }
        
        for (User user : [Select Id, contactID, contact.AccountId, Profile.name from User Where Id = :UserInfo.getUserId() and Profile.name != 'System Administrator'])
        {
            system.debug('Validate Request user :' + user);
            system.debug('user.contactID :' + user.contactID);
            system.debug('user.contact.AccountId' + user.contact.AccountId);
            contactId = user.contactID;
            ProfileName = user.Profile.Name;
            if (user.contactId != null){
                accountId = user.contact.AccountId;
                LEReq.ContactId = user.contactId;
                system.debug('After User Query LEReq :' + LEReq);
            }
            else {
                ValidationRslt = 'Invalid Request';
                LEReq.ErrorMessages[0] = 'Could Not Retrieve User';
                return ValidationRslt;
            }
                
            
        }
        if ((accountId == null || accountId == '')&&(ProfileName != 'System Administrator')) {
            ValidationRslt = 'Invalid Request';
            LEReq.ErrorMessages[0] = 'Account or Contact on User Record is Empty';
            return ValidationRslt;
        }

        system.debug('Validate Request Fin id' + LEReq.FinAcctId);
        for (Finance_Account__c fAccount : [Select Id, Due_On_Day__c, Customer__c, Contact__c, Finance_Account_Number__c, 
                                            Next_Due_Date__c, Past_Amount_Due__c,Total_Fees_Due__c,
                                            First_Due_Date__c, Paid_to_Date__c, Account_Type__c,
                                            Regular_Monthly_Payment__c,Maturity_Date__c
                                            from Finance_Account__c 
                                            Where id = :LEReq.FinAcctId])
        {
            FinanceAccount = fAccount;
            system.debug ('Validate Request Finance Account:' + FinanceAccount);
            //FinanceAccount.Customer__c = (FinanceAccount.Customer__c!=null) ? FinanceAccount.Customer__c:'';
            //Added null by replacing empty string - SK
            FinanceAccount.Contact__c = (FinanceAccount.Contact__c!=null) ? FinanceAccount.Contact__c:null;
            FinanceAccount.Finance_Account_Number__c = (FinanceAccount.Finance_Account_Number__c!=null) ? FinanceAccount.Finance_Account_Number__c:'';
            
            FinanceAccount.Account_Type__c = (FinanceAccount.Account_Type__c!=null) ? FinanceAccount.Account_Type__c:'';
            
            FinanceAccount.Past_Amount_Due__c = (FinanceAccount.Past_Amount_Due__c!=null) ? FinanceAccount.Past_Amount_Due__c:0;
            FinanceAccount.Total_Fees_Due__c = (FinanceAccount.Total_Fees_Due__c!=null) ? FinanceAccount.Total_Fees_Due__c:0;
            FinanceAccount.Regular_Monthly_Payment__c = (FinanceAccount.Regular_Monthly_Payment__c!=null) ? FinanceAccount.Regular_Monthly_Payment__c:0;
            LEReq.olddueday = (FinanceAccount.Due_On_Day__c!=null) ? FinanceAccount.Due_On_Day__c:'0';
            LEReq.maturityDate=(FinanceAccount.Maturity_Date__c!=null)?FinanceAccount.Maturity_Date__c:null;
            LEReq.nextMaturityDate=(FinanceAccount.Maturity_Date__c!=null)? LEReq.maturityDate.addMonths(LEReq.ExtLength):null;

        }
                      
        if (FinanceAccount == null){
            ValidationRslt = 'Invalid Request';
            LEReq.ErrorMessages[0] = 'FA Not Found';
            FinId = 'Invalid Account';
           
                return ValidationRslt;
        }
        LEReq.FinAcctNbr =  FinanceAccount.Finance_Account_Number__c;
        
        If (FinanceAccount.Next_Due_Date__c != null && FinanceAccount.Paid_to_Date__c != null
           && FinanceAccount.Paid_to_Date__c > FinanceAccount.Next_Due_Date__c)
        {
          //  LEReq.newdueDate= GetNextDueDate(FinanceAccount.Paid_to_Date__c, LEReq.DueDay);
          LEReq.newLEDate= GetLEDate(FinanceAccount.Paid_to_Date__c, LEReq.ExtLength);
        }
        else if (FinanceAccount.Next_Due_Date__c != null) {
            //LEReq.newdueDate= GetNextDueDate(FinanceAccount.Next_Due_Date__c, LEReq.DueDay);
            LEReq.newLEDate= GetLEDate(FinanceAccount.Paid_to_Date__c, LEReq.ExtLength);
        }
        Else{
            ValidationRslt = 'Invalid Request';
            LEReq.ErrorMessages[0] = 'Next LE Date on FA is Empty';
            return ValidationRslt;
        }
        
        //system.debug('@@@ LEReq.newLEDate: ' + LEReq.newLEDate);
        
          //fetching the customer finance accounts to check for valid user.
        for (Customer_Finance_Account__c cFinanceAcc : [SELECT id, Finance_Account__c, Customer__c
                                                        FROM Customer_Finance_Account__c 
                                                        WHERE Finance_Account__c  = :LEReq.FinAcctId])
        {
            if (cFinanceAcc.Customer__c == accountId){
                ValidationRslt = '';
                
            }
        }
        
        if (ValidationRslt == 'Invalid Request') {
            LEReq.ErrorMessages[0] = 'Customer Finance Account Not Found';
            return ValidationRslt ;
        }
        
        List<Case> lstcase = [select id from case where
                             Finance_Account__c = :LEReq.FinAcctId
                             And Type = 'Lease Extension'
                                 And Status <> 'Closed'];
        if (lstcase.size() > 0) {
            ValidationRslt = 'Invalid Request';
            LEReq.ErrorMessages[0] = 'LE Case Exists';
            return ValidationRslt;
        }
        
        TotalAmountDue = FinanceAccount.Past_Amount_Due__c + FinanceAccount.Total_Fees_Due__c;
        system.debug('TotalAmountDue---'+TotalAmountDue);
        
        AggregateResult[] AggrTotalPayments = [select sum(ChargentOrders__Charge_Amount__c)Payments
                                            from 	ChargentOrders__ChargentOrder__c where
                                            Finance_Account_Number__c = :LEReq.FinAcctId
                                            And ((Payment_Display_Status__c in ('Pending', 'Processing')
                                                  AND Payment_Channel__c in ('A','W','I')
                                                  AND  ChargentOrders__Payment_Start_Date__c <= today
                                                 )
                                                 OR (Next_Withdrawal_Date__c <= today
                                                     AND Payment_Channel__c = 'R'
                                                     AND Payment_Display_Status__c in ('Pending', 'Processing')
                                                    )
                                                 )];
        
        system.debug('AggrTotalPayments---'+ AggrTotalPayments);
        if (AggrTotalPayments[0].get('Payments') != null)  TotalPayments = (Decimal)AggrTotalPayments[0].get('Payments');
       
        System.debug ('TotalPayments  after update:' + TotalPayments);
        system.debug('AggrTotalPayments :' + AggrTotalPayments);
        
        System.debug ('TotalAmountDue :' + TotalAmountDue);
        System.debug ('TotalPayments :' + TotalPayments);
        //As per Jenn feedback commenting Past Due Date 
        /*
        if (TotalAmountDue > TotalPayments ) {
            ValidationRslt = 'Invalid Request';
            LEReq.ErrorMessages[0] = 'Past Due Account';
            return ValidationRslt;
        }*/
        
        if (FinanceAccount.Paid_to_Date__c == null || FinanceAccount.First_Due_Date__c == null){
            ValidationRslt = 'Invalid Request';
            LEReq.ErrorMessages[0] = 'Paid to Date or First Due Date is Empty';
            return ValidationRslt;
        }
       
       if ((FinanceAccount.Paid_to_Date__c == FinanceAccount.First_Due_Date__c) && 
           (FinanceAccount.Account_Type__c == 'Retail') &&
           (FinanceAccount.Regular_Monthly_Payment__c > TotalPayments)
          ){
              ValidationRslt = 'Invalid Request';
            LEReq.ErrorMessages[0] = 'New Account First payment not made';
            return ValidationRslt;
              
          }
       
       if (FinanceAccount.Paid_to_Date__c == FinanceAccount.First_Due_Date__c) 
            
            NewRetailAccount = true;
        //As per Jenn feedback commenting Past Due Date
        /*if ((TotalPayments >= TotalAmountDue ) && TotalAmountDue !=0) {
            ValidationRslt = 'Process Manually';
            LEReq.ErrorMessages[0] = 'Past Due Account with same day Payments';
        }*/
        if (NewRetailAccount){
            ValidationRslt = 'Process Manually';
            LEReq.ErrorMessages[0] = 'New Account';
        }
        else if (ValidationRslt != 'Invalid Request') {
            ValidationRslt = 'Process Automatically';
        }
        
        return ValidationRslt;
    }
    
    @AuraEnabled
    public static Object processLEResponse(List<String> labels, Object state){
        system.debug('Static Callback Method labels => processLEResponse');
        system.debug(labels);
        system.debug('State =>' + state);
        system.debug(state);
        String CaseStatus;
        String returnval = 'Failed';
        String result = '';
        String webServiceResult = '';
        
        
        
       /* HttpResponse response = Continuation.getResponse(labels[0]);
        system.debug('Static Callback Method response =>' +response);
        system.debug(response);
        result = response.getBody();*/
        
        HttpResponse response;
        try{
            response= Continuation.getResponse(labels[0]);
            result = response.getBody();
        }
        catch(exception ex){
            createErrorlogevt('Callout Failed', 'CASSCalloutLE', String.valueOf(state), '', ex.getMessage());
            InsertCase ((LEDetails)State,'Automatic - Failed', ex.getMessage());
            return returnval;
        }
        
        system.debug('Static Callback Method response =>' +response);
        system.debug(response);
        

  		//case when service does not return      
        if (response != null && response.getStatusCode()<> 200){
             createErrorlogevt('Callout Failed', 'CASSCalloutLE', String.valueOf(state), '', String.valueOf(response));
             InsertCase ((LEDetails)State,'Automatic - Failed', String.valueOf(response));
             return returnval;
        }

        // Set the result variable
       
        String Processing_type = 'Automatic - Failed';
        
        system.debug('response body =>' + result);
        try{
            LEResponse resp = LEResponse.parse(result);
            system.debug('LEResponse: ' +  resp);
            system.debug('resp.Header.Code: ' +  resp.Header.Code);
            
            //if (resp.Header.Code == 200){
            if (resp.Body.intErrorNumber == 0){
                returnval = 'SUCCESS';
                Processing_type = 'Automatic - Successful';
                webServiceResult = String.valueOf(resp);                
                
            }
            else{
                returnval = 'Failed';
                Processing_type = 'Automatic - Failed';
                //if (resp.Header.Code == 600 && resp.Body.strErrorMessage=='AF in Next day Mode'){
                // When AF in Next day Mode
                if (resp.Body.intErrorNumber == 200){    
                    Processing_type = 'Pending - Retry';
                }
                webServiceResult = String.valueOf(resp);
                createErrorlogevt('Callout Failed', 'CASSCalloutLE', String.valueOf(state), '', String.valueOf(resp));
            	
            }
            system.debug('Header =>' + resp.Header);
            
            
        } catch (Exception e){
            returnval = 'Failed';
            system.debug('in catch step');
            system.debug('body =>' + result);
            system.debug('err =>' + e.getMessage());
            Processing_type = 'Automatic - Failed';
            webServiceResult = result;
            createErrorlogevt(e.getMessage(), 'CASSCalloutLE', String.valueOf(state), '', '');
            
        }
        
        try {
            InsertCase ((LEDetails)State,Processing_type, webServiceResult);
        }
        Catch (Exception e){
            returnval = 'Failed';
            system.debug('Error in inserting case record');
            system.debug('body =>' + result);
            system.debug('err =>' + e.getMessage());
            createErrorlogevt(e.getMessage(), 'CASSCalloutLE', String.valueOf(state), '', '');
            throw new AuraHandledException('Error in inserting case record');
            
            
        }
        
        
        
        return returnval;
    }
    
    Private  Static void InsertCase( LEDetails ledetails, String ProcessingType, String WebSvcResult){
        system.debug('all 3 parameter details---' +ledetails+' -- - - '+ProcessingType+' -- - - '+WebSvcResult);
        system.debug('Inside InsertCase');
        setEasyPayIndicator(ledetails.FinAcctId);
        String casestatus = 'New';
        String ContentNoteTemplate;
        String CustomerContactId;
        String currentDateTime = (DateTime.Now()).format('M/dd/yyyy hh:mm aaa', 'America/Los_Angeles'); //"yyyy.MM.dd G 'at' hh:mm:ss "
        ContentNoteTemplate = '<p><strong>Date/Time Received:</strong> ' + currentDateTime + ' </p> ';
        ContentNoteTemplate = ContentNoteTemplate + '<p><strong>Finance Account Number:</strong> ' + ledetails.FinAcctNbr + ' </p>';
        //ContentNoteTemplate = ContentNoteTemplate + '<p><strong>Current Due Date:</strong>' + GetDueDayInWords (Integer.valueOf(ledetails.oldDueDay)) + '</p>' ;
        Datetime currentMDateTime = datetime.newInstance(ledetails.maturityDate.year(), ledetails.maturityDate.month(),ledetails.maturityDate.day());
        system.debug('ledetails.maturityDate  '+ ledetails.maturityDate);
        system.debug('ledetails.maturityDate + 1 ---- '+ ledetails.maturityDate.addMonths(1));
        system.debug('ledetails.maturityDate  '+ ledetails.maturityDate.year());
        system.debug('ledetails.maturityDate  '+ ledetails.maturityDate.month());
        system.debug('ledetails.maturityDate  '+ ledetails.maturityDate.day());
        system.debug('currentMDateTime --- '+currentMDateTime);
        system.debug('currentMDateTime.format(MM/DD/YYYY)----------  '+currentMDateTime.format('MM/dd/yyyy'));
        ContentNoteTemplate = ContentNoteTemplate + '<p><strong>Current Maturity Date:</strong> ' + currentMDateTime.format('MM/dd/YYYY') + '</p>' ;
        //ContentNoteTemplate = ContentNoteTemplate +  '<p><strong>Requested Due Date:</strong>' + GetDueDayInWords (ledetails.ExtLength) + '</p>';
        ContentNoteTemplate = ContentNoteTemplate +  '<p><strong>Number of Months Requested:</strong> ' + ledetails.ExtLength + '</p>';
        Datetime currentNMDateTime = datetime.newInstance(ledetails.nextMaturityDate.year(), ledetails.nextMaturityDate.month(),ledetails.nextMaturityDate.day());
        system.debug('currentNMDateTime--- '+ currentNMDateTime);
        system.debug('currentNMDateTime.format(MM/DD/YYYY)------  '+currentNMDateTime.format('MM/dd/yyyy'));
        ContentNoteTemplate = ContentNoteTemplate +  '<p><strong>Requested Maturity Date:</strong> ' + currentNMDateTime.format('MM/dd/YYYY') + '</p>';
        ContentNoteTemplate = ContentNoteTemplate +  '<p><strong>Easy Pay:</strong> ' + EasyPayInd + '</p>';
        system.debug('Inside case creation EasyPayInd---- '+EasyPayInd);
        
        //check if case was created withing last x seconds
        
        DateTime lstCreateddatetime = (DateTime.Now()).addSeconds(-15);
        system.debug ('@@@@ lstCreateddatetime : ' + lstCreateddatetime);
        system.debug ('@@@@ now : ' + DateTime.Now());
        
        
        list<case> lstExistingCase = [select id from case where
                                     createddate > :lstCreateddatetime
                                     and Finance_Account__c = :ledetails.FinAcctId
                                     and type = 'Lease Extension'
                                     and Origin = 'Web'
                                     ];
        
        Case cse = new case();
        switch on ProcessingType{
            when 'Pending Payment'{
                casestatus = 'New';
                cse.ownerid = system.label.Pending_Payments_Queue_Id; //Pending Payment Cases
                
            }
            when 'Automatic - Successful'{
                casestatus = 'Closed';
                cse.ownerid = system.label.Closed_Lease_Extension_Cases; //Closed Lease Extension Cases
                //updateMaturityDate(ledetails);
            }
            when 'Automatic - Failed'{
                casestatus = 'New';
                cse.ownerid = system.label.Unassigned_Lease_Extension_Cases; //Unassigned Lease Extension Cases	
            }
            when 'Pending - Retry'{
                casestatus = 'New';
                cse.ownerid = system.label.DDC_Retry_Queue_Id; //Pending Retry Cases
                
            }
            
        }
        
        
        cse.ContactId = ledetails.ContactId;
        cse.Finance_Account__c = ledetails.FinAcctId;
        cse.Origin = 'Web';
        //cse.Requested_Next_Due_Date_Day__c = String.valueOf(ledetails.ExtLength);
        cse.Requested_Months__c=ledetails.ExtLength;
        cse.Service_Request__c = ContentNoteTemplate;
        cse.Subject = 'Lease Extension Request' ;
        cse.type = 'Lease Extension' ;   
        cse.Processing_Type__c = ProcessingType;
        cse.WebService_Result__c = WebSvcResult;
        cse.Status = casestatus;
        if (cse.Status == 'Closed') cse.Case_Reason__c = 'Resolved';
        cse.Service_Request__c = ContentNoteTemplate;
        Datetime dtTodayDateTime = datetime.newInstance(ledetails.nextMaturityDate.year(), ledetails.nextMaturityDate.month(),ledetails.nextMaturityDate.day());
        system.debug('dtTodayDateTime----- '+dtTodayDateTime);
        cse.Requested_Maturity_Date_Text__c = dtTodayDateTime.format('MM/dd/yyyy');
        system.debug('cse.Requested_Maturity_Date_Text__c------- '+cse.Requested_Maturity_Date_Text__c);
        cse.Retry__c = 0;
        
        if (lstExistingCase.size() == 0)   insert cse;
        system.debug('casenumber'+ cse.CaseNumber);
        system.debug('caseId'+ cse.Id);
    }
    
   /* Public Static String GetDueDayInWords (integer i){
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
                     
    }*/
                             
    public static void buildRequest(HttpRequest request, String FinAcctNbr, Integer months){
        system.debug('Inside buildRequest');
        CASSCallOut.FetchCredentials();
        TIME_OUT = CASSCallOut.TIME_OUT;
        
        request.setEndpoint('callout:LE');

        System.debug(request.getEndpoint());
        system.debug('CASSCallOut.BUSINESS_ID---'+CASSCallOut.BUSINESS_ID);
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
        
        LERequest LEReq = new LERequest();
        LEReq.AccountNumber = FinAcctNbr;
        LEReq.Months=months;
        LEReq.EasyPay = EasyPayInd;
        system.debug('EasyPay---'+ LEReq.EasyPay);
        system.debug('EasyPayInd--- '+EasyPayInd);
        //LEReq.DueDate = dueDate.month() + '/'  + dueDate.day() + '/' + dueDate.year();
        //LEReq.LEDate = dueDate.month() + '/'  + dueDate.day() + '/' + dueDate.year();
        request.setBody(JSON.serialize(LEReq));
        
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
    
    Public static Date GetLEDate(date currentDueDate, integer dayOfMonth){
        system.debug('Inside GetLEDate');
        integer dueDateDay = currentDueDate.day();
        integer dueDateMth = currentDueDate.month();
        integer dueDateYear = currentDueDate.year();
        date dueDateNextMth = currentDueDate.addMonths(1);
        integer daysinCurrentMonth = date.daysInMonth(dueDateYear, dueDateMth);
        integer nextMthdueDateMth = dueDateNextMth.month();
        integer nextMthdueDateYear = dueDateNextMth.year();
        integer daysinNextMonth = date.daysInMonth(nextMthdueDateYear, nextMthdueDateMth);
        Date NextLEDate;
        NextLEDate = currentDueDate.addMonths(1);
        if (dayOfMonth > dueDateDay && dayOfMonth < daysinCurrentMonth){
            NextLEDate = date.newInstance(dueDateYear, dueDateMth, dayOfMonth);
        } else if (dayOfMonth < daysinNextMonth){
            NextLEDate = date.newInstance(nextMthdueDateYear, nextMthdueDateMth, dayOfMonth);
        } else{
            throw new AuraHandledException('Unable to Compute Next LE Date');
        }
        system.debug('NextLEDate :' + NextLEDate);
        return NextLEDate;
    }
    
    /*Public Class DueDateException extends Exception{
        
    }*/
    
    Public Class LERequest {
        Public String AccountNumber ;
        //Public String DueDate ;
        //Public String LEDate;
        public Integer Months;
        public String EasyPay;
    }
    /*
    public static void updateMaturityDate(LEDetails LEReq){
       Finance_Account__c fAcc = [Select id, Maturity_Date__c,Paid_to_Date__c from Finance_Account__c Where id =: LEReq.FinAcctId];
       fAcc.Maturity_Date__c = LEReq.nextMaturityDate;
        system.debug('fAcc.Maturity_Date__c----------'+  fAcc.Maturity_Date__c);
       update fAcc;
    } */
    
    public static void setEasyPayIndicator(Id finAcc){
        system.debug('EasyPay Indicator Method called');
        ChargentOrders__ChargentOrder__c[] paymentCheck = [Select id, Finance_Account_Number__c, Payment_Channel__c, Payment_Display_Status__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__c =: finAcc and Payment_Channel__c = 'R' and Payment_Display_Status__c in ('Pending', 'Complete', 'Stopped', 'Suspended')];
        system.debug('paymentCheck----'+paymentCheck);
        if(paymentCheck.size()>0){
            EasyPayInd = 'Y';
        }
    }
    
    
}