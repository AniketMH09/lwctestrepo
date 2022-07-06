/*Apex Class Name   :   AHFC_FiservIntegrationHandler
* @description      :	US 5029 & 4368: This class is used to retrieve letter dates and document Id from Fiserv's DocumentSearch Webservice & Actual PDF document from FISERV's documentGet webservice.
* Created By        :   Akash Solanki
* Created on        :   11/5/2021
* Modified By		:	Akash Solanki
* Modified On		:	25-June-2021
*********************************************************************************/
/*
 * Modification Log:	To rectify the class as per the automatic code scans - Akash Solanki
*********************************************************************************/
/**
* @description AHFC_FiservIntegrationHandler 
*/
Public without sharing class AHFC_FiservIntegrationHandler {
    /**
* @description documentSearch calls the search opeartion on FISERV Document Service
* @param  accountId Finance Account Number
* @param  docType   Type of Document (STMT or LETTERS)
* @return           return a list of wrapper class of type SearchResult
**/
    @AuraEnabled(cacheable=true)
    public static object documentSearch(String accountId,String docType) {
        Map<String,Object> response1 = new Map<String,Object>();
        list<SearchResult> listSearchResults = new list<SearchResult>();
        boolean isUserAuth = UserSecurity.ValidateFinNumberInit(accountId);
        if(!isUserAuth){
               throw new AuraHandledException('invalid access');
            
         }
        
        try{
            
            HttpRequest request= getHttpRequest(accountId, docType);
            HttpResponse response = new Http().send(request);
            System.debug('StatusCode--->'+response.getStatusCode());
            String responseBody = response.getbody();
            
            Dom.Document doc = new Dom.Document();  
            doc.load(responseBody);  
            Dom.XMLNode rootElement = doc.getRootElement();
            Dom.XMLNode documentSearchResponseElement = rootElement.getChildElements()[0].getChildElements()[0];
            
            string uuid;
            Dom.XMLNode status;
            list<Dom.XMLNode> listSearchResultElements = new list<Dom.XMLNode>();
            
            for (Dom.XMLNode childElement : DocumentSearchResponseElement.getChildElements()) {
                
                if (childElement.getName() == 'UUID'){
                    UUID = childElement.getText();
                }
                if (childElement.getName() == 'Status'){
                    status = childElement;
                }
                if (childElement.getName() == 'SearchResult'){
                    listSearchResultElements.add(childElement);
                } 
            }
            
            for (Dom.XMLNode searchresult: listSearchResultElements){
                SearchResult srchrslt = new SearchResult(); 
                for (Dom.XMLNode searchresultChild :searchresult.getChildElements()){
                    if (searchresultChild.getName() == 'DocumentID'){
                        srchrslt.DocumentID = searchresultChild.getText();
                    } 
                    if (searchresultChild.getName() == 'Detail'){
                        detail dtl = new detail();
                        for (Dom.XMLNode childElement : searchresultChild.getChildElements()) {
                            if (childElement.getName() == 'Name'){
                                dtl.name = childElement.getText();    
                            }
                            if (childElement.getName() == 'Value'){
                                dtl.value = childElement.getText();     
                            }
                        }
                        
                        if (dtl.name == 'Letterid') {
                            srchrslt.Letterid = dtl.value;
                        }  
                        
                        if (dtl.name == 'Ltrdate') {
                            srchrslt.Ltrdate = dtl.value;
                        }  
                        if (dtl.name == 'Reprint') {
                            system.debug(dtl.value+'dtl.value');
                            srchrslt.reprint = dtl.value;
                        } 
                    }  
                }
                listSearchResults.add(srchrslt);
                response1.put('listSearchResults',listSearchResults);
            }
        }
        catch(System.Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        return response1;
    }
    
    /**
* @description documentGet calls the get opeartion on FISERV Document Service
* @param docId document Id coming from the letter date exposed to the UI
* @return           return a string of binary data 
**/
    @AuraEnabled(cacheable=true)
    public static String documentGet(String docId) {
        String val='';
        
        try{
            HttpRequest request= getHttpRequestDocGet(docId);
            HttpResponse response = new Http().send(request);
            String responseBody = response.getbody();
            
            Dom.Document doc = new Dom.Document();  
            doc.load(responseBody);  
            Dom.XMLNode rootElement = doc.getRootElement();
            
            Dom.XMLNode documentGetResponseElement = rootElement.getChildElements()[0].getChildElements()[0];
            list<Dom.XMLNode> listDocumentGetResponse = new list<Dom.XMLNode>();
            
            for (Dom.XMLNode childElement : documentGetResponseElement.getChildElements()) {
                listDocumentGetResponse.add(childElement);
            }
            
            for(Dom.XmlNode documentGetResponseChild : listDocumentGetResponse){
                for(Dom.XmlNode documentNodeChild :documentGetResponseChild.getChildElements()){
                    if(documentNodeChild.getName() == 'bindata'){
                        val = documentNodeChild.getText();
                    }
                }
            }
        }catch(System.Exception ex){
            val = ex.getMessage();
            throw new AuraHandledException(ex.getMessage()); 
        }
        return val;
    }
    
/**
    * @description getXMLRequest for documentSearch Method
    * @param  accountId Finance Account Number
    * @param  docType   Document Type (STMT or LETTERS)
    * @return           return XML string to be used in SOAP Request
*/ 
    private static string getXMLRequest(String accountId,String docType){
        string xmlString = '<?xml version="1.0" encoding="utf-8"?>';  
        XMLString += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fed="'+System.label.Fiserv_Statement_FEDServiceLib+'">';  
        XMLString += '<soapenv:Header/>';  
        XMLString += '<soapenv:Body>';
        XMLString += '<fed:DocumentSearchRequest xmlns="'+System.label.Fiserv_Statement_FEDServiceLib+'">';  
        XMLString += '<UUID>'+System.label.Fiserv_Statements_UUID+'</UUID>';  
        XMLString += '<Criteria>';  
        XMLString += '<Name>'+System.label.Fiserv_Statement_Type+'</Name>';  
        XMLString += '<Value>'+docType+'</Value>'; 
        XMLString += '</Criteria>';
        XMLString += '<Criteria>';
        XMLString += '<Name>'+System.label.Fiserv_Statement_Accountid+'</Name>';
        XMLString += '<Value>'+accountId+'</Value>';  
        XMLString += '</Criteria>'; 
        XMLString += '</fed:DocumentSearchRequest>'; 
        XMLString += '</soapenv:Body>';  
        XMLString += '</soapenv:Envelope>';
        return xmlString;
    }
/**
    * @description getXMLRequest
    * @param  docId Document Id from the selected letter date on the dashboard statements for documentGet Method
    * @return           return XML string to be used in SOAP Request
*/ 
    private static string getXMLRequestDocGet(String docId){
        string xmlString = '<?xml version="1.0" encoding="utf-8"?>';  
        XMLString += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:head="http://www.honda.com/global/1.0/header/" xmlns:fed="'+System.label.Fiserv_Statement_FEDServiceLib+'">';  
        XMLString += '<soapenv:Body>';  
        XMLString += '<fed:DocumentGetRequest xmlns="'+System.label.Fiserv_Statement_FEDServiceLib+'">';
        XMLString += '<UUID>'+System.label.Fiserv_Statements_UUID+'</UUID>';  
        XMLString += '<Document>';  
        XMLString += '<DocumentID>'+docId+'</DocumentID>';  
        XMLString += '</Document>';  
        XMLString += '<OutputProperties>'; 
        XMLString += '<OutputType>'+System.label.Fiserv_Statement_OutputType+'</OutputType>';
        XMLString += '<AllPages>true</AllPages>';
        XMLString += '</OutputProperties>';
        XMLString += '</fed:DocumentGetRequest>';  
        XMLString += '</soapenv:Body>'; 
        XMLString += '</soapenv:Envelope>'; 
        return xmlString;
    }
/**
    * @description getHttpRequest 
    * @param  accountId Finance Account Number
    * @param  docType   Document Type (STMT or LETTERS)
    * @return           return http request containing SOAP Request
*/
    public static HttpRequest getHttpRequest(String accountId,String docType){
        string xmlString = getXMLRequest(accountId, docType);
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:AHFCFiservNamedCred');
        system.debug(request);
        request.setTimeout(Integer.valueOf(System.label.Fiserv_Statements_TimeOut)); 
        request.setMethod('POST');
        request.setHeader('SOAPAction', system.label.Fiserv_Statements_documentSearch);
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setBody(XMLString);
        return request;
    }
/**
    * @description getHttpRequest  for DocumentGet Method
    * @param  	docId
    * @return 	return http request containing SOAP Request
*/
    private static HttpRequest getHttpRequestDocGet(String docId){
        string xmlString = getXMLRequestDocGet(docId);
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:AHFCFiservNamedCred');
        request.setTimeout(Integer.valueOf(System.label.Fiserv_Statements_TimeOut)); 
        request.setMethod('POST');
        request.setHeader('SOAPAction', System.label.Fiserv_Statements_documentGet);
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setBody(XMLString);
        return request;
    }
/**
* @description SearchResult Wrapper class for parsing the webservice response 
*/
    public class SearchResult{
        @AuraEnabled
        public string documentId;
        @AuraEnabled
        public string letterId;
        @AuraEnabled
        public string ltrDate;  
        @AuraEnabled
        public string reprint;
    }
/**
* @description Detail Wrapper class for parsing the webservice response and get the value of name value nodes.
*/    
    private class Detail{
        String name;
        String value;
    } 
}