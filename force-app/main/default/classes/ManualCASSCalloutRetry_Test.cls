@isTest
public class ManualCASSCalloutRetry_Test {
    
     @testSetup static void TestData(){
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
        RetryObj.Finance_Account_Number__c = '987654321';
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
        RetryObjwitoutemail.Finance_Account_Number__c = '987654321';
        RetryObjwitoutemail.HTTP_Request__c = 'System.HttpRequest[Endpoint=callout:Update_EDelivery_Preference/SOAP/AHFC/TranHistorySvc/4.0/, Method=POST]';
        
        
        listRetryObj.add(RetryObjwitoutemail); 
        insert listRetryObj;
         
         Account a=new Account();
         a.Name='Test';
         insert a;
         
         Contact c=new Contact();
         c.LastName='TestName';
         c.AccountId=a.Id;
         c.Email='test@123.com';
         insert c;
         
         c.EmailBouncedDate=System.Today();
         update c;
         
         Finance_Account__c finacc = new Finance_Account__c();
         finacc.Finance_Account_Number__c='1111';
         finacc.Honda_Brand__c='AFS';
         //finacc.Customer__c=cfa.Id;
         insert finacc;
         
        Communication_Preferences__c commPreferences = New Communication_Preferences__c();
        commPreferences.Is_Comm_Pref_Set__c =true;
        commPreferences.Email_Address__c ='avner_uzan@hna.honda.com';
        commPreferences.Finance_Account_Number__c = finacc.Id;
        insert commPreferences;
        
    }
    static testMethod void refreshListMethod_Test(){
       Test.startTest();
        
       UpdateEDeliveryPreferenceService__c Credential = new UpdateEDeliveryPreferenceService__c();
       Credential.SiteId__c = 'SALESFORCE';
       Credential.BusinessId__c = 'SALESFORCE';
       Credential.TimeOut__c = '60000';
       Credential.Magic_String__c = 'SFoPmtMagic';
       Credential.Env__c = 'PROD';
       Credential.VendorId__c ='SALESFORCE';
       Credential.Name = 'eDeliveryService';
       insert Credential;
       
        List<Retry_Callout__c> retryCallout = [Select id from Retry_Callout__c limit 2]; 
        retryCallout[0].Number_of_Attempted__c =1;
        retryCallout[0].Synced_with_CASS__c=false;
        retryCallout[1].Number_of_Attempted__c =2;
        retryCallout[1].Synced_with_CASS__c=false;
        retryCallout[1].Email_Address__c='';
        update retryCallout;
        
        ManualCASSCalloutRetry calloutRetry = New ManualCASSCalloutRetry();
        calloutRetry.refreshListMethod();
        
        ManualCASSCalloutRetry.wrapperCallout wrapper = New ManualCASSCalloutRetry.wrapperCallout();
        system.debug('calloutRetry.wrapplist---->>>'+calloutRetry.wrapplist);
        calloutRetry.wrapplist[0].selection = true;
        calloutRetry.wrapplist[1].selection = true;
        calloutRetry.CalloutRefresh();
        Test.stopTest();
        
    }
}