/*Apex Class Name   :   AHFC_ECRMIntegration
* Description       :   This class is used to Validate the Customer entered address
* Created By        :   Kanagaraj
* Created on        :   25/5/2021
*********************************************************************************/
public class AHFC_ECRMIntegration {
    
    // SOAP Web service Callout 
    @AuraEnabled
    public static AHFC_ECRMIntegrationHandler.ValidatedAddressWrapper getValidatedAddress(string address1, string address2,string city,string stateName,string zipcode){
       system.debug('<<<---addresss>>>>'+address1+'<<<address2>>>'+address2+'<<<---city---->>>'+city+'<<<---stateName--->>>>'+stateName+'<<<zip>>>'+zipcode);
        AHFC_ECRMIntegrationHandler.ValidatedAddressWrapper responsehandler;
        try{
            AHFC_addressValidation__mdt AHFCValidateComp = [select Url_sei__c, Url_soapNS__c, Url_vo__c, userName__c, password__c,Content_Type__c,Method__c,DeveloperName from AHFC_addressValidation__mdt where DeveloperName = 'GET_ECRM_VALIDATION'];
            String XmlResponse ='';
            if(AHFCValidateComp!= null){
                string xmlBody = formatingXML(AHFCValidateComp,address1,address2,city,stateName,zipcode);
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                req.setEndpoint('callout:ECRM_validateAddress');
                req.setMethod(AHFCValidateComp.Method__c);
                req.setHeader('Content-Type', AHFCValidateComp.Content_Type__c);
                system.debug('<<<<---xmlBody--->>>'+xmlBody);
                req.setBody(xmlBody);
                system.debug('<<<<---Request--->>>'+req);
                List<String> lstSuccessStatuses =  new List<String>();
                lstSuccessStatuses.add('200');
                String strMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId();
                AHFC_IntegrationLogUtil objIntUtil = new AHFC_IntegrationLogUtil('','AHFC_ECRMIntegration','getValidatedAddress','ECRM Webservice', 'Contact', strMessageId);
                HttpResponse objResponse = objIntUtil.handleRetryMechanism(req,lstSuccessStatuses,1);
                system.debug('<<<<---objResponse--->>>'+objResponse);
                XmlResponse = objResponse.getBody();
                system.debug('<<<<---XmlResponse--->>>'+XmlResponse);
                AHFC_ECRMIntegrationHandler ECRMresponse = new AHFC_ECRMIntegrationHandler();
                responsehandler = ECRMresponse.parserXML(XmlResponse);
                system.debug('<<<<---responsehandler--->>>'+responsehandler);
            }
        return responsehandler;
        }catch(exception e){
            return responsehandler;
        }
    }
    private static string formatingXML(AHFC_addressValidation__mdt AHFCValidateComp,string address1, string address2,string city,string stateName,string zipcode){
        DOM.Document doc = new DOM.Document();
        
        dom.XmlNode envelope = doc.createRootElement(system.label.Root_Element, AHFCValidateComp.Url_soapNS__c, system.label.Root_node);
        envelope.setNamespace(system.label.Namespace_sei, AHFCValidateComp.Url_sei__c);
        envelope.setNamespace(system.label.Namespace_vo, AHFCValidateComp.Url_vo__c);
        envelope.setNamespace(system.label.Root_node, AHFCValidateComp.Url_soapNS__c);
		// Header        
        dom.XmlNode header = envelope.addChildElement(system.label.Root_header,AHFCValidateComp.Url_soapNS__c, null);
        
        dom.XmlNode Body = envelope.addChildElement(system.label.Dom_Body,AHFCValidateComp.Url_soapNS__c , null);
        dom.XmlNode cleanseAddress = Body.addChildElement(system.label.cleanse_Address, AHFCValidateComp.Url_sei__c, null);
        dom.XmlNode ecrmDataIn= cleanseAddress.addChildElement(system.label.ecrm_Data_In, AHFCValidateComp.Url_sei__c, null);
        dom.XmlNode message= ecrmDataIn.addChildElement(system.label.message, AHFCValidateComp.Url_vo__c, null);
        dom.XmlNode address= message.addChildElement(system.label.address, AHFCValidateComp.Url_vo__c, null);
        address.addChildElement(system.label.addressLine1, AHFCValidateComp.Url_vo__c, null).addTextNode(address1);
        address.addChildElement(system.label.addressLine2, AHFCValidateComp.Url_vo__c, null).addTextNode(address2);
        address.addChildElement(system.label.soap_response_city, AHFCValidateComp.Url_vo__c, null).addTextNode(city);
        address.addChildElement(system.label.plus4, AHFCValidateComp.Url_vo__c, null).addTextNode('');
        address.addChildElement(system.label.state, AHFCValidateComp.Url_vo__c, null).addTextNode(stateName);
        address.addChildElement(system.label.zip, AHFCValidateComp.Url_vo__c, null).addTextNode(zipcode);
        address.addChildElement(system.label.countyCode, AHFCValidateComp.Url_vo__c, null).addTextNode('');
        address.addChildElement(system.label.countyName, AHFCValidateComp.Url_vo__c, null).addTextNode('');
        address.addChildElement(system.label.failLevelCode, AHFCValidateComp.Url_vo__c, null).addTextNode('');
        
        dom.XmlNode messageCode= message.addChildElement(system.label.messageCode, AHFCValidateComp.Url_vo__c, null).addTextNode('');
        dom.XmlNode securityInfo= message.addChildElement(system.label.security_Info, AHFCValidateComp.Url_vo__c, null);
        
        securityInfo.addChildElement(system.label.password, AHFCValidateComp.Url_vo__c, null).addTextNode(AHFCValidateComp.password__c);
        securityInfo.addChildElement(system.label.userName, AHFCValidateComp.Url_vo__c, null).addTextNode(AHFCValidateComp.userName__c);  
        
        System.debug(doc.toXmlString()); 
        return doc.toXmlString();
    }
}