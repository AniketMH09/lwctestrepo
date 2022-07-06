/*******************************************************************************************************
    * @author  : Kanagaraj 
    * @description :  RSS 46325 - PG-Systematic outage recovery/SF resync process.
********************************************************************************************************/
public class ManualCASSCalloutRetry {
    public list<Retry_Callout__c>  retrylist {get;set;} 
    public list<wrapperCallout> wrapplist {get;set;}
    public boolean selectall {get;set;}
    public ManualCASSCalloutRetry(){
        //list<Retry_Callout__c> retrylist = new list<Retry_Callout__c>();
        wrapplist = new list<wrapperCallout>();
        system.debug('constu---->>>');
        selectall = false;
        refreshListMethod();
    }
    
   
    public void refreshListMethod(){
        selectall = false;
        retrylist = new list<Retry_Callout__c>();
        wrapplist = new list<wrapperCallout>();
        string MaximumAttemped = label.Retry_Maximum_Attempted;
        retrylist = [Select id,name,createdby.name,ClassName__c,Synced_with_CASS__c,BusinessId__c,SiteId__c,collectionTimeStamp__c,SOAPAction__c,Request_Method__c,Content_Type__c,TimeOut__c,Request_Endpoint__c,HTTP_Request__c,Email_Address__c,AffectedId__c,HTTP_Request_Body__c,Number_of_Attempted__c,createddate,Last_Retried_time__c,Finance_Account_Number__c from Retry_Callout__c where Synced_with_CASS__c=false and Number_of_Attempted__c <=: Integer.Valueof(MaximumAttemped) order by lastmodifieddate desc];
        for(Retry_Callout__c retryobj:retrylist){
           wrapperCallout wrappObj = new wrapperCallout();
            wrappObj.wrapretryObj = retryobj;
            wrapplist.add(wrappObj);
        }
        system.debug('---->>>'+retrylist);
    }
    public void CalloutRefresh(){
        list<Retry_Callout__c>  retrycalloutlist = new list<Retry_Callout__c>();
        EDelivery_Resp_Code__c codes = EDelivery_Resp_Code__c.getOrgDefaults();
        list<Communication_Preferences__c> comprefencelist = new list<Communication_Preferences__c>();
        for(wrapperCallout wrapobj:wrapplist){
            system.debug('wrapobj.selection>>>>'+wrapobj.selection);
            if(wrapobj.selection){
                Retry_Callout__c retrycallout  = wrapobj.wrapretryObj;
                retrycallout.Last_Retried_time__c = system.now();
                retrycallout.Number_of_Attempted__c = retrycallout.Number_of_Attempted__c+1;
                retrycalloutlist.add(retrycallout);
                Http h = new Http();
                Integer statusCode;
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
               
                if(retrycallout.Email_Address__c != null){
                   Boolean successFlag = false;
                   UpdateCommPreferenceWebservice edeliveryService = new UpdateCommPreferenceWebservice();
                   successFlag = edeliveryService.updateEDeliveryPreference(true, retrycallout.Email_Address__c, retrycallout.Finance_Account_Number__c);
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
                        system.debug('<<<e>>>>'+e);
                    }
                }
            }
        }
        system.debug('---retrycalloutlist-----'+retrycalloutlist);
        system.debug('---comprefencelist-----'+comprefencelist);
        try{
        if(retrycalloutlist.size() > 0){
                update retrycalloutlist;
            }
            if(comprefencelist.size() > 0){
                update comprefencelist;
            }
            refreshListMethod();
        }catch(exception e){
            system.debug(e+'---->>>'+e.getlineNumber());
        }
    }
    public class wrapperCallout{
        public boolean selection {get;set;}  
        public Retry_Callout__c wrapretryObj {get;set;} 
        public wrapperCallout(){
            selection = false;
            wrapretryObj = new Retry_Callout__c();
        }
    }
}