public with sharing  class CASSCalloutController {
    
    // Callout endpoint as a named credential URL
    
    private static final String LONG_RUNNING_SERVICE_URL =
        '<insert your callout URL here>';
    
    Public Static String    SITE_ID ;
    Public Static String    BUSINESS_ID ; 
    Public Static Integer   TIME_OUT ;
    Public Static String isInsertOrUpdate; 
    Public Static String caseIsInsertOrUpdate;
    
    
    @AuraEnabled(continuation=true )
    public static Object callPymtExtService(String FinAcctNbr, Integer NumOfMths) {
        system.debug('fa =>' + FinAcctNbr);
        system.debug('mths =>' + NumOfMths);
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        Integer ValidationError = 0;
        Boolean isValiduser = false;
        string contactId = null;
        String accountId = null;
        Finance_Account__c FinanceAccount = null;
        String errmsg = '';
        String FinId = '';
        
        //Validate Number of Months and Finance Account
        
            ValidationError =  ((NumOfMths) > Integer.valueof(system.label.AHFC_PE_Mnths) || (NumOfMths < 1)) ? 1:0;
        
        
             	
        // Get current community user's contactID
        for(User user : [Select Id, contactID,contact.AccountId from User Where Id = :UserInfo.getUserId()]){
            contactId = user.contactID;
            if(user.contactId != null) {
                accountId = user.contact.AccountId;
            }
         }
        
        for(Finance_Account__c fAccount : [ Select Id, Customer__c, Contact__c, Finance_Account_Number__c from Finance_Account__c 
                                           Where Finance_Account_Number__c = :FinAcctNbr ]){
                                               
                                               FinanceAccount = fAccount;
                                               
        }
                
        
        if(FinanceAccount == null){
            ValidationError = ValidationError + 2;
            FinId = 'Invalid Account';
            
        }
        
       //fetching the customer finance accounts to check for valid user.
           
        for(Customer_Finance_Account__c cFinanceAcc: [SELECT id,Finance_Account__c,Customer__c FROM Customer_Finance_Account__c
                                                      WHERE Finance_Account__c =: FinId]) {
                                                          
                                                          if(cFinanceAcc.Customer__c != accountId) {
                                                           ValidationError = ValidationError + 2;   
                                                          }
                                                          
         }
        
         system.debug(ValidationError);
         errmsg = (ValidationError == 1) ? 'Invalid Number of Months':'';
         errmsg = (ValidationError == 2) ? 'Invalid Finance Account':'';
         errmsg = (ValidationError == 3) ? 'Invalid Finance Account and Number of Months':'';                                     
         system.debug(errmsg);
        
        if   (ValidationError > 0)   {
            createErrorlogevt(errmsg, 'CASSCalloutController', FinId,'FA:'+FinAcctNbr+' Mths:'+ NumOfMths, 'Users:' + UserInfo.getUserId());
            throw new AuraHandledException(errmsg);
            
        }   
        
       
       
        CASSCalloutController.buildRequest(request, FinAcctNbr, NumOfMths);
        
        // Create continuation. Argument is timeout in seconds.
        Continuation con = new Continuation(120);
        
        // Set callback method
        con.continuationMethod='processPymtExtResponse';
        
        // Set state
        con.state=FinAcctNbr;
        
        
        
        // Add callout request to continuation
        
        
        con.addHttpRequest(request);
        
        // Return the continuation
        return con;
        //return 1;
    }
    
    
    // Callback method
    @AuraEnabled
    public static Object processPymtExtResponse(List<String> labels, Object state) {
        
        system.debug('Static Callback Method labels =>' );
        system.debug(labels);
        
        // Get the response by using the unique label
        HttpResponse response = Continuation.getResponse(labels[0]);
        system.debug('Static Callback Method response =>' );
        system.debug(response);
        
       
        
        
        // Set the result variable
        String result = response.getBody();
        String returnval ='Failed';
        system.debug('response body =>' + result);
        try {
            PymtExtResponse resp = PymtExtResponse.parse(result);
            if (resp.Header.Code == 200 ) {
                returnval = 'SUCCESS';
                
                            }
            else if (resp.Header.Code == 201 ) {
                returnval = 'InEligible';
                system.debug(' In header code 201 step');
                
                            }
            else  {
                returnval = 'Failed' ;
                
                createErrorlog('Callout Failed','CASSCalloutController - Payment Ext', String.valueOf(state),'',String.valueOf(resp));
            }
            system.debug('Header =>' + resp.Header);
           
            
        }
        catch (Exception e){
            
            returnval = 'Failed2';
            system.debug('in catch step');
            system.debug('body =>' + result);
            system.debug('err =>' + e.getMessage());
            createErrorlog(e.getMessage(),'CASSCalloutController - Payment Ext', String.valueOf(state),'','');
            
            
        }
        
        
        
        return returnval;
    }    
    
    
    
    public static void buildRequest (HttpRequest request,String FinAcctNbr, Integer NumOfMths) {
        CASSCallOut.FetchCredentials();
        TIME_OUT = CASSCallOut.TIME_OUT;
        String urlParms = generateURLParamString(FinAcctNbr, NumOfMths);
        
        request.setEndpoint('callout:Pymt_Ext' + urlParms);

        
        System.debug(request.getEndpoint());
        
        request.setHeader('hondaHeaderType.businessId', CASSCallOut.BUSINESS_ID);
        Datetime collectedTimestamp = system.now();
        String now = collectedTimestamp.formatGmt('yyyy-MM-dd HH:mm:ss');
        request.setHeader('hondaHeaderType.collectionTimeStamp', now);
        request.setHeader('hondaHeaderType.messageId', CASSCallOut.BUSINESS_ID);
        request.setHeader('hondaHeaderType.siteId',CASSCallOut.SITE_ID);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setTimeout(CASSCallOut.TIME_OUT);     
        system.debug('hondaHeaderType.businessId:' + request.getHeader('hondaHeaderType.businessId'));
        system.debug('hondaHeaderType.collectionTimeStamp:'+ request.getHeader('hondaHeaderType.collectionTimeStamp')   );          
        system.debug('hondaHeaderType.messageId:' + request.getHeader('hondaHeaderType.messageId'));
        system.debug('hondaHeaderType.siteId:' + request.getHeader('hondaHeaderType.siteId'));
        system.debug('Content-Type:' + request.getHeader('Content-Type'));
        system.debug('Accept' + request.getHeader('Accept'));
        system.debug('Timeout' + TIME_OUT);             
        
        
        
        system.debug(request.getBody()) ;
        system.debug(request.getEndpoint());
        
        
        request.setMethod('POST'); 
        
    }
    
    //helper method for generation paramter values for CaseIntegration
    public static String generateURLParamString(String financeAccountNumber, integer nummonths) {
        String urlParams ='';
        urlParams = '?AccountNum=' + financeAccountNumber +'&NotesText=deferral'+ nummonths;
        return urlParams;
        
    }
    
    private class returnResult{
        public string result;
        public string contactid ;
    }
    
    @future
    private static void createErrorlog(String errorMessage, String className, String finId,String requestBody,String responseBody) {
        ErrorLog__c errorLog = new ErrorLog__c();
        system.debug(errorMessage);
        system.debug(className);
        system.debug(finId);
        system.debug(requestBody);
        system.debug(responseBody);
        
        errorLog.ClassName__c = className;
        errorLog.ExceptionErrorMessage__c = errorMessage;
        errorLog.AffectedId__c = finId;
        errorLog.RequestBody__c = requestBody;
        errorLog.ResponseBody__c = responseBody;
        insert errorLog;
    }
    
    private static void createErrorlogevt(String errorMessage, String className, String finId,String requestBody,String responseBody) {
        log__e errorLog = new log__e();
        system.debug(errorMessage);
        system.debug(className);
        system.debug(finId);
        system.debug(requestBody);
        system.debug(responseBody);
        
        errorLog.ClassName__c = className;
        errorLog.Exception_Error_Message__c = errorMessage;
        errorLog.AffectedId__c = finId;
        errorLog.RequestBody__c = requestBody;
        errorLog.ResponseBody__c = responseBody;
        EventBus.publish(errorLog);
    }
    
    private class StateInfo {
    String msg { get; set; }
    List<String> urls  { get; set; }
    StateInfo(String msg, List<String> urls) {
        this.msg = msg;
        this.urls = urls;
    }
}
}