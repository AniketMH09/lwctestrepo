public class UpdateCommPreferenceWebservice {
     
    Public Static String    SITE_ID ;
    Public Static String    BUSINESS_ID ;
    Public Static Integer   TIME_OUT ;
    Public Static String    MAGIC_STRING ;
    Public Static String    ENVIRONMENT ;
    Public Static String    VENDORID ;

    Public Static Void FetchCredentials () {
            
        List<UpdateEDeliveryPreferenceService__c> Credentials = New List<UpdateEDeliveryPreferenceService__c> ();
        Credentials = UpdateEDeliveryPreferenceService__c.getall().values();
        if ( !Credentials.isEmpty() ) {
        
            UpdateEDeliveryPreferenceService__c Credential = Credentials[0];
            SITE_ID      = Credential.SiteId__c ;
            BUSINESS_ID  = Credential.BusinessId__c ;
            TIME_OUT     = Integer.Valueof(Credential.TimeOut__c) ;
            MAGIC_STRING = Credential.Magic_String__c ;
            ENVIRONMENT  = Credential.Env__c ;
            VENDORID     = Credential.VendorId__c ;
        }
       
    }
    
    public boolean updateEDeliveryPreference(Boolean commPref,String commEmail, String finNumber ) {
        System.Debug(' updateEDeliveryPreference  ==> ' + finNumber );
        UpdateCommPreferenceWebservice.FetchCredentials();
		ManageErrorLogs__c manageErrorLog = ManageErrorLogs__c.getValues('UpdateEDeliveryPreferenceService');
        
        EDelivery_Resp_Code__c codes = EDelivery_Resp_Code__c.getOrgDefaults();
        String financeAcccountNumber = finNumber;
        String comPrefEmail = commEmail;
        String pref = commPref == true ? 'E' : 'P';
        HTTP httpInstance = new HTTP();
        HTTPRequest request = new HTTPRequest();
        HTTPResponse response = new HTTPResponse();
        String responseBody;
        request.setEndpoint('callout:Update_Communication_Preference');
        request.setHeader('Content-Type', 'text/xml');
        request.setTimeout(TIME_OUT);
        request.setHeader('SOAPAction', 'http://Honda.GenEx/HondaGenEx/UpdateEDeliveryPreference');
        request.setMethod('POST');
        
        String xmlOutput = xmlCreation(financeAcccountNumber, comPrefEmail, pref);
        request.setBody(xmlOutput);
        
        System.Debug(' pref ==> '+ pref);
        System.Debug(' xmlOutput ==> '+ xmlOutput);
        
        try {
            response = httpInstance.send(request);
            System.Debug(' response  ==> ' + response );
            System.Debug(' response.getStatusCode() ==> ' + response.getStatusCode() );
            
            Integer statusCode;
            statusCode = response.getStatusCode();
           if(response != null || statusCode == codes.HTTP_Success__c){
                responseBody = response.getBody();
               system.debug('<<<responseBody>>>>'+responseBody);
                String result = responseBody.substringBetween('<UpdateEDeliveryPreferenceResult>', '</UpdateEDeliveryPreferenceResult>');
               system.debug('<<<result>>>>'+result);
               Set<String> resultSuccessCodeSet = new Set<String>();
                if (codes.Result_Sucess__c != NULL) {
                    resultSuccessCodeSet = returnValue(codes.Result_Sucess__c);
                }
                system.debug ('::resultSuccessCodeSet::' +resultSuccessCodeSet);
                if(result != null && resultSuccessCodeSet.contains(result)){
                    System.debug('Success');
                    return true;
                }  
            }
            
        } catch (exception e) {
            System.Debug(' Exception e ==> '+ e);
            return false;
        }
        
        return false;
    }
    public String xmlCreation(String finAccNo, String emailAddress, String pref) {
        DOM.Document doc = new DOM.Document();
        String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        String hon = 'http://Honda.IVR.SOAP';
        String head = 'http://www.honda.com/header';
        String hon1 = 'http://Honda.GenEx';
        
        dom.XmlNode envelope = doc.createRootElement('Envelope', soapNS, 'soapenv');
        envelope.setNamespace('hon', hon);
        envelope.setNamespace('head', head);
        envelope.setNamespace('hon1', hon1);
        
        dom.XmlNode header = envelope.addChildElement('Header', soapNS, null);
        dom.XmlNode hondaCASS = header.addChildElement('HondaCASS', hon, null);
        
        dom.XmlNode hondaMsgHeader = header.addChildElement('hondaMsgHeader', head, null);
        hondaMsgHeader.addChildElement('messageId', head, null).addTextNode(UpdateCommPreferenceWebservice.getUUID());
        hondaMsgHeader.addChildElement('siteId', head, null).addTextNode(SITE_ID);
        hondaMsgHeader.addChildElement('businessId', head, null).addTextNode(BUSINESS_ID);
        
        
        dom.XmlNode body = envelope.addChildElement('Body', soapNS, null);
        dom.XmlNode updateEDeliveryPreference = body.addChildElement('UpdateEDeliveryPreference', hon1, null);
        dom.XmlNode objRequestData = updateEDeliveryPreference.addChildElement('objRequestData', hon1, null);
        objRequestData.addChildElement('AcctNumber', hon1, null).addTextNode(finAccNo);
        objRequestData.addChildElement('Preference', hon1, null).addTextNode(pref);
        if(!String.isBlank(emailAddress)){
        objRequestData.addChildElement('EmailAddress', hon1, null).addTextNode(emailAddress);
        }
        else{
        //objRequestData.addChildElement('EmailAddress', hon1, null);
        objRequestData.addChildElement('EmailAddress', hon1, null).addTextNode('');
        }
        
        String tempString = doc.toXmlString();
        String replacedString = tempString.replace('</soapenv:Body>', '<soapenv:Body>');
        String bodyPart = replacedString.substringBetween('<soapenv:Body>');
        bodyPart = bodyPart.replaceAll('\\s+','');
        bodyPart = bodyPart.replace('<hon1:UpdateEDeliveryPreference>', '<hon1:UpdateEDeliveryPreference xmlns:hon1="http://Honda.GenEx">');
        
        Datetime collectedTimestamp = system.now();
        String now = collectedTimestamp.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        Datetime expiryDate = collectedTimestamp.addminutes(2);
        String expiry = expiryDate.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        hondaMsgHeader.addChildElement('collectedTimestamp', head, null).addTextNode(now);
        
        String concatenated = bodyPart + '~' + BUSINESS_ID  + '~' + MAGIC_STRING + '~' + expiry + '~' + ENVIRONMENT ;
        Blob concatedBlob = Blob.valueOf(concatenated);
        Blob authorizationToken = Crypto.generateDigest('MD5', concatedBlob);
        String authToken = EncodingUtil.convertToHex(authorizationToken);
        
        hondaCASS.addChildElement('VendorID', hon, null).addTextNode(VENDORID);
        hondaCASS.addChildElement('Token', hon, null).addTextNode(authToken);
        hondaCASS.addChildElement('Env', hon, null).addTextNode(ENVIRONMENT);
        hondaCASS.addChildElement('Expiry', hon, null).addTextNode(expiry);
        
        
        return doc.toXmlString();
        
    }
    
    public static String getUUID()
    {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        return guid;
    }
    
    // ADD THE COMMA SEPERATED VALUE INTO THE SET 
    public static Set<String> returnValue(String val) {
    
        Set<String> valuesSet = new Set<String>(val.split(','));
               
        system.debug ('::values::' +valuesSet);               
        return valuesSet;    
    }
}