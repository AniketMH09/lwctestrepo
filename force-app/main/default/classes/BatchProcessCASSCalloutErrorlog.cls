/*******************************************************************************************************
    * @author  : Kanagaraj 
    * @description :  RSS 46325 - PG-Systematic outage recovery/SF resync process.
********************************************************************************************************/
global class BatchProcessCASSCalloutErrorlog implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
        public String query;
        Public Static String isInsertOrUpdate;
    global Database.Querylocator start (Database.BatchableContext SC){  
         string MaximumAttemped = label.Retry_Maximum_Attempted;
         query = 'Select id,name,ClassName__c,Synced_with_CASS__c,BusinessId__c,SiteId__c,collectionTimeStamp__c,SOAPAction__c,Request_Method__c,Content_Type__c,TimeOut__c,Request_Endpoint__c,HTTP_Request__c,Email_Address__c,AffectedId__c,HTTP_Request_Body__c,Number_of_Attempted__c,createddate,Last_Retried_time__c,Finance_Account_Number__c from Retry_Callout__c where Synced_with_CASS__c=false and Number_of_Attempted__c <= '+Integer.Valueof(MaximumAttemped)+' order by createddate asc';
         return Database.getQueryLocator(query);
    }     
    
    global void execute(Database.BatchableContext BC, List<Retry_Callout__c> records){
        list<Retry_Callout__c> retrycalloutlist = new list<Retry_Callout__c>();
        list<Communication_Preferences__c> comprefencelist = new list<Communication_Preferences__c>();
        EDelivery_Resp_Code__c codes = EDelivery_Resp_Code__c.getOrgDefaults();
        system.debug('records--->>>'+records);
        for(Retry_Callout__c retrycallout : records){
            retrycallout.Number_of_Attempted__c = retrycallout.Number_of_Attempted__c+1;
            retrycallout.Last_Retried_time__c = system.now();
            retrycalloutlist.add(retrycallout);
            Http h = new Http();
            Integer statusCode;
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            
            if(retrycallout.Email_Address__c != null){
                Boolean successFlag = false;
                try{
                    UpdateCommPreferenceWebservice edeliveryService = new UpdateCommPreferenceWebservice();
                    successFlag = edeliveryService.updateEDeliveryPreference(true, retrycallout.Email_Address__c, retrycallout.Finance_Account_Number__c);
                }catch(exception e){
                   system.debug(e+'--if-->>>'+e.getlineNumber()); 
                }
                System.debug('Boolean Flag>>>>>>' + successFlag); 
                if(successFlag){
                    Communication_Preferences__c cp = new Communication_Preferences__c(id=retrycallout.AffectedId__c);
                    cp.Is_Comm_Pref_Set__c = true;
                    cp.Email_Address__c = retrycallout.Email_Address__c;
                    comprefencelist.add(cp);
                    retrycallout.Synced_with_CASS__c = true;
                } 
            }else{
                try{
                    request.setEndpoint(retrycallout.Request_Endpoint__c);
                    request.setHeader('hondaHeaderType.businessId', retrycallout.BusinessId__c);
                    request.setHeader('hondaHeaderType.collectionTimeStamp', retrycallout.collectionTimeStamp__c);
                    request.setHeader('hondaHeaderType.messageId', retrycallout.BusinessId__c);
                    request.setHeader('hondaHeaderType.siteId', retrycallout.SiteId__c);
                    request.setHeader('Content-Type', retrycallout.Content_Type__c);
                    request.setHeader('Accept', 'application/json');
                    request.setHeader('Content-Length', Label.Content_Length);
                    request.setTimeout((retrycallout.TimeOut__c).intValue());
                    if(retrycallout.HTTP_Request_Body__c != null)
                        request.setBody(retrycallout.HTTP_Request_Body__c);
                   else
                       request.setBody('');
                    request.setMethod(retrycallout.Request_Method__c);
                    system.debug('request---->>>'+request);
                    if(!Test.isRunningTest())
                        response = h.send(request);
                    statusCode = response.getStatusCode();
                    system.debug('statusCode---->>>'+statusCode);
                    system.debug('codes.HTTP_Success__c---->>>'+codes.HTTP_Success__c);
                    if(response != null && statusCode == codes.HTTP_Success__c)
                        retrycallout.Synced_with_CASS__c = true;
                }catch(exception e){
                    system.debug(e+'--else-->>>'+e.getlineNumber());
                }
            }
        } 
        try{
        if(retrycalloutlist.size() > 0){
                update retrycalloutlist;
            }
            if(comprefencelist.size() > 0){
                update comprefencelist;
            }
        }catch(exception e){
            system.debug(e+'---->>>'+e.getlineNumber());
        }
    }
    
    global void finish(Database.BatchableContext BC){   
    }
}