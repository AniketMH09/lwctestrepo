Global class BatchRetryLECall implements Database.Batchable <Sobject>, Database.RaisesPlatformEvents, Database.AllowsCallouts {
    
    String closed_queue_id = system.label.Closed_Lease_Extension_Cases;
    String unassigned_queue_id = system.label.Unassigned_Lease_Extension_Cases;
    Integer Pending_Payment_Retries = integer.valueof(system.label.DDC_Pending_Payments_Retries);
    
    
    global Database.QueryLocator start (Database.BatchableContext bc){
        String processing_type = '\'Pending - Retry\'';
        String type='\'Lease Extension\'';
        String query = 'SELECT   ' +
            'Finance_Account__c,  ' +
            'Finance_Account__r.Finance_Account_Number__c,  ' +
            'Finance_Account__r.Next_Due_Date__c,  ' +
            'Finance_Account__r.Paid_to_Date__c,  ' +
            'Finance_Account__r.Maturity_Date__c, '+
            'Id,  ' +
            'Processing_Type__c,  ' +
            'Reason,  ' +
            'Requested_Next_Due_Date_Day__c,  ' +
            'Requested_Next_Due_Dte__c,  ' +
            'Status,  ' +
            'Type,  ' +
            'CreatedById,  ' +
            'OwnerId,  ' +
            'WebService_Result__c, ' +
            'Service_Request__c, ' +
            'DDC_Retry_Callout_Count__c, ' +
            'Requested_Months__c ' + 
            ' FROM Case  ' +
            'Where Processing_Type__c = ' + processing_type +
            ' and Type ='+type;
        
        system.debug('@@@@ query :'+ query);
        
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Case> lstCases) {
        
        LEWebSrvResults webSrvRslt;
            for (case cse :lstCases){
            //to update new maturity date on finance account change start
            /*
            LEDetails led = new LEDetails(cse.Finance_Account__r.id, Integer.valueOf(cse.Requested_Months__c));
            led.maturityDate=(cse.Finance_Account__r.Maturity_Date__c!=null)?cse.Finance_Account__r.Maturity_Date__c:null;
            led.nextMaturityDate=(cse.Finance_Account__r.Maturity_Date__c!=null)? cse.Finance_Account__r.Maturity_Date__c.addMonths(Integer.valueOf(cse.Requested_Months__c)):null;
            // change end*/
            if (cse.Finance_Account__r.Finance_Account_Number__c == null || cse.Requested_Months__c == null){
                Batcherror err = new Batcherror('Account Number or Requested Months is null', 'BatchRetryLECall', cse.id, 'Account Number or Requested Months is null', '');
                continue;
            }
            
            //compute the next due date
            // Decision Pending when Processing Type = Pending Payment.
            // As per jenn' feedback Pending payment cases will be considered as Automatic sucessful
           /* if (cse.Processing_Type__c == 'Pending Payment') {
                Date newDueDate;
                Integer DueDay = Integer.valueOf (cse.Requested_Next_Due_Date_Day__c);
                System.debug('cse.Requested_Next_Due_Date_Day__c-------'+ cse.Requested_Next_Due_Date_Day__c);
                system.debug('DueDay----'+ DueDay);
                If (cse.Finance_Account__r.Next_Due_Date__c != null && cse.Finance_Account__r.Paid_to_Date__c != null
                    && cse.Finance_Account__r.Paid_to_Date__c > cse.Finance_Account__r.Next_Due_Date__c)
                {
                    //newdueDate= CASSCallout.GetNextDueDate(cse.Finance_Account__r.Paid_to_Date__c, DueDay);
                    newdueDate= CASSCalloutLE.GetLEDate(cse.Finance_Account__r.Paid_to_Date__c, DueDay);
                    // cse.Requested_Next_Due_Dte__c = newdueDate
                }
                else if (cse.Finance_Account__r.Next_Due_Date__c != null) {
                    //newdueDate= CASSCalloutDDC.GetNextDueDate(cse.Finance_Account__r.Next_Due_Date__c,DueDay);
                    newdueDate= CASSCalloutLE.GetLEDate(cse.Finance_Account__r.Next_Due_Date__c,DueDay);
                }
                cse.Requested_Next_Due_Dte__c = newdueDate; 
                
                //string svcrequest = cse.Service_Request__c + '<p><strong>Updated Requested Due Date:</strong>' + CASSCalloutDDC.GetDueDayInWords (ddcdetails.DueDay) + '</p>';
                 //update Service_Request__c//
                 //
            }*/
            
            webSrvRslt = CallLEWebservice(cse.Finance_Account__r.Finance_Account_Number__c, Integer.valueOf(cse.Requested_Months__c));
            
            if (webSrvRslt.returnVal == 'SUCCESS') {
                cse.status = 'Closed';
                cse.Case_Reason__c = 'Resolved';
                cse.OwnerId = closed_queue_id;
                cse.Processing_Type__c = webSrvRslt.Processing_Type;
                cse.DDC_Retry_Callout_Count__c = cse.DDC_Retry_Callout_Count__c + 1;
                cse.WebService_Result__c = webSrvRslt.webServiceResult; 
                //CASSCalloutLE.updateMaturityDate(led);
            }
            system.debug('CalloutCountsss-->'+cse.DDC_Retry_Callout_Count__c);
                system.debug('Pending_Payment_Retriessssssss-->'+Pending_Payment_Retries);
                system.debug('ReturnValue-->'+webSrvRslt.returnVal);
                system.debug('ProcessingTypesss-->'+cse.Processing_Type__c);
                
            if (webSrvRslt.returnVal != 'SUCCESS' && cse.Processing_Type__c == 'Pending Payment' && 
                cse.DDC_Retry_Callout_Count__c < Pending_Payment_Retries) {
                    cse.DDC_Retry_Callout_Count__c = cse.DDC_Retry_Callout_Count__c + 1;
                    cse.WebService_Result__c = webSrvRslt.webServiceResult; 
                }
            else if (webSrvRslt.returnVal != 'SUCCESS'){
                cse.status = 'New';
                cse.OwnerId = unassigned_queue_id;
                cse.Processing_Type__c = webSrvRslt.Processing_Type;
                cse.WebService_Result__c = webSrvRslt.webServiceResult; 
                cse.DDC_Retry_Callout_Count__c = cse.DDC_Retry_Callout_Count__c + 1;
                Batcherror err = new Batcherror('Callout Failed', 'BatchRetryLECall',cse.id, 'Callout Failed',  webSrvRslt.webServiceResult);
            }  
        }
        if(!Test.isRunningTest()){
        	update lstCases;
        }
        Batcherror.publishBatcherrors();
    }
    
    global void finish(Database.BatchableContext bc){
        
        try {
            // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
            // Query the AsyncApexJob object to retrieve the current job's information.       
            AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id = : bc.getJobId()];
            //Send an email to the Apex job's submitter notifying of job completion.       
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            String emailLabel = Label.Batch_Notification_Emails;
            
            String[] toAddresses = new String[] {a.CreatedBy.Email};
                
                // Comma seperated values in Label Batch_Notification_Emails
                // Add each value to the toAddresses 
                for(String s: emailLabel.split(',')){
                    toAddresses.add(s);
                }
            
            // setToAddresses sends email to the email addresses in toAddresses 
            mail.setToAddresses(toAddresses);
            mail.setSubject('LE Retry Calls Completed ' + a.Status);
            mail.setPlainTextBody('The Batch Apex job BatchRetryLECall processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        }catch(System.Exception ex) {
            Batcherror err = new Batcherror(ex.getmessage(), 'BatchRetryLECall', Null,Null,Null);
            Batcherror.publishBatcherrors();           
        }
    }
    
    Private static  LEWebSrvResults CallLEWebservice(string finAcctNbr, Integer months){
        
        Http httpSrv = new Http();
        HttpRequest request = new HttpRequest();
       
        list<Case> lstCaseUpd = new list<case>();
        
        String CaseStatus;
        String returnval = 'Failed';
        String result = '';
        String webServiceResult = '';
        String Processing_type = 'Retry - Failed';
        
        try{
            CASSCalloutLE.buildRequest(request,finAcctNbr, months);  
            HttpResponse res = httpSrv.send(request);
            result = res.getBody();
            system.debug('response body =>' + result);
            LEResponse resp = LEResponse.parse(result);
            system.debug('LEResponse: ' +  resp);
            system.debug('resp.Header.Code: ' +  resp.Header.Code);
            
            //if (resp.Header.Code == 200){
            if (resp.Body.intErrorNumber == 0){    
                returnval = 'SUCCESS';
                Processing_type = 'Automatic - Successful';
                webServiceResult = String.valueOf(resp);   
                system.debug('webServiceResult :' + webServiceResult);
            }else{
                returnval = 'Failed';
                Processing_type = 'Retry - Failed';
                webServiceResult = String.valueOf(resp);
                webServiceResult =  webServiceResult.length() > 32767 ?  webServiceResult.substring(0, 32765) : webServiceResult; 
                system.debug('webServiceResult :' + webServiceResult);
                // Batcherror err = new Batcherror('Callout Failed', 'BatchRetryLECall', finAcctNbr, 'Callout Failed', webServiceResult);
            }
        }catch (Exception e){
            returnval = 'Failed';
            system.debug('in catch step');
            system.debug('body =>' + result);
            system.debug('err =>' + e.getMessage());
            Processing_type = 'Retry - Failed';
            webServiceResult = 'Error: ' + e.getMessage() + ' Response: ' +result;
            webServiceResult =  webServiceResult.length() > 32767 ?  webServiceResult.substring(0, 32765) : webServiceResult; 
            system.debug('webServiceResult :' + webServiceResult); 
        }
        
        LEWebSrvResults webSrvResults = new LEWebSrvResults(Processing_type, webServiceResult,returnVal) ;
        return webSrvResults;
    }
    
    Public class LEWebSrvResults {
        
        String Processing_type {get;set;}
        String webServiceResult {get;set;}
        String returnVal {get;set;}
        
        public LEWebSrvResults(String Processing_type, String webServiceResult, String returnVal){
            this.Processing_type = Processing_type;
            this.webServiceResult = webServiceResult;
            this.returnVal = returnVal;
            
        }   
    }
}