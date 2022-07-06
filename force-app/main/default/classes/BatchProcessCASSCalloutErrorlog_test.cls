@isTest
public class BatchProcessCASSCalloutErrorlog_test {
    static list<Retry_Callout__c> getCallouttest(){
        list<Retry_Callout__c> listRetryObj = new list<Retry_Callout__c>();
        Retry_Callout__c RetryObj = new Retry_Callout__c();
        RetryObj.Request_Endpoint__c = 'callout:Update_EDelivery_Preference/SOAP/AHFC/TranHistorySvc/4.0/';
        RetryObj.Request_Method__c  = 'POST';
        RetryObj.HTTP_Request_Body__c = 'SALESFORCEec63091ead1ab7c83b62cc21d232f17fPROD2020-02-06T12:56:57Zb692a2eb-8707-209b-4a64-5a7419cee27fSALESFORCESALESFORCE2020-02-06T12:54:57Z00000411870892Esaigriram12@gmail.com';
        RetryObj.TimeOut__c  = 60000;
        RetryObj.AffectedId__c = 'a1a4B000000myTyQAI';
        RetryObj.Content_Type__c = 'text/xml';
        RetryObj.SOAPAction__c = 'http://Honda.GenEx/HondaGenEx/UpdateEDeliveryPreference';
        RetryObj.Email_Address__c ='test@salesforce.com';
        RetryObj.HTTP_Responce__c= 'System.HttpResponse[Status=OK, StatusCode=200]';
        RetryObj.ClassName__c = 'INT 32';
        RetryObj.Number_of_Attempted__c = 0;
        RetryObj.BusinessId__c = 'CASS';
        RetryObj.collectionTimeStamp__c = 'CASS';
        RetryObj.SiteId__c = 'CASS';
        RetryObj.Finance_Account_Number__c = '123456789';
        RetryObj.HTTP_Request__c = 'System.HttpRequest[Endpoint=callout:Update_EDelivery_Preference/SOAP/AHFC/TranHistorySvc/4.0/, Method=POST]';
        listRetryObj.add(RetryObj); 
        
        Retry_Callout__c RetryObjwitoutemail = new Retry_Callout__c();
        RetryObjwitoutemail.Request_Endpoint__c = 'callout:Update_EDelivery_Preference/SOAP/AHFC/TranHistorySvc/4.0/';
        RetryObjwitoutemail.Request_Method__c  = 'POST';
        RetryObjwitoutemail.HTTP_Request_Body__c = 'SALESFORCEec63091ead1ab7c83b62cc21d232f17fPROD2020-02-06T12:56:57Zb692a2eb-8707-209b-4a64-5a7419cee27fSALESFORCESALESFORCE2020-02-06T12:54:57Z00000411870892Esaigriram12@gmail.com';
        RetryObjwitoutemail.TimeOut__c  = 60000;
        RetryObjwitoutemail.AffectedId__c = 'a1a4B000000myTyQAI';
        RetryObjwitoutemail.Content_Type__c = 'text/xml';
        RetryObjwitoutemail.SOAPAction__c = 'http://Honda.GenEx/HondaGenEx/UpdateEDeliveryPreference';
        RetryObjwitoutemail.HTTP_Responce__c= 'System.HttpResponse[Status=OK, StatusCode=200]';
        RetryObjwitoutemail.ClassName__c = 'INT 32';
        RetryObjwitoutemail.Number_of_Attempted__c = 0;
        RetryObjwitoutemail.BusinessId__c = 'CASS';
        RetryObjwitoutemail.collectionTimeStamp__c = 'CASS';
        RetryObjwitoutemail.SiteId__c = 'CASS';
        RetryObj.Finance_Account_Number__c = '987654321';
        RetryObjwitoutemail.HTTP_Request__c = 'System.HttpRequest[Endpoint=callout:Update_EDelivery_Preference/SOAP/AHFC/TranHistorySvc/4.0/, Method=POST]';
        listRetryObj.add(RetryObjwitoutemail); 
        insert listRetryObj;
        return listRetryObj;
    }
    static testMethod void retryCallouttest(){
       list<Retry_Callout__c> RetryObj = getCallouttest();
       UpdateEDeliveryPreferenceService__c Credential = new UpdateEDeliveryPreferenceService__c();
       Credential.SiteId__c = 'SALESFORCE';
       Credential.BusinessId__c = 'SALESFORCE';
       Credential.TimeOut__c = '60000';
       Credential.Magic_String__c = 'SFoPmtMagic';
       Credential.Env__c = 'PROD';
       Credential.VendorId__c ='SALESFORCE';
       Credential.Name = 'eDeliveryService';
       insert Credential;
        
        /* Test.setMock(HttpCalloutMock.class, new RetryCASSCallout_test());
        HttpResponse res = BatchProcessCASSCalloutErrorlog.getInfoFromExternalService(RetryObj[0].Id);
        BatchProcessCASSCalloutErrorlog batchretry= new BatchProcessCASSCalloutErrorlog();
        Test.startTest();
        batchretry.execute(null, RetryObj);
        Test.startTest();
Test.setMock(HttpCalloutMock.class, new RetryCASSCallout_test());
new CalloutBatch(new Case[]{caseRecord}).execute(null,new Case[]{caseRecord});
Test.stopTest();*/
        Test.startTest();
        try{
            BatchProcessCASSCalloutErrorlog batchretry = new BatchProcessCASSCalloutErrorlog(); 
            database.executebatch(batchretry,2);
            batchretry.execute(null, RetryObj);
            batchretry.finish(null);  
        }catch(exception e){}
         Test.stopTest();
    }
}