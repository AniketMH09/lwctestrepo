/*Apex Class Name   :   AHFC_ECRMIntegrationTest
* Description       :   This is a webservice mock class for AHFC_ECRM
* Created By        :   Kanagaraj
* Created on        :   06 JUN 2021
*********************************************************************************/
global class AHFC_ECRMIntegrationHandlerCalloutMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request) {
        String XML ='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
XML +='<soapenv:Header/>';
XML +='<soapenv:Body>';
XML +='<p788:cleanseAddressResponse xmlns:p788="http://sei.ejb.ecrm.honda.com">';
XML +=            '<p788:cleanseAddressReturn xmlns:p971="http://vo.ecrm.honda.com">';
XML +=                '<p971:message>';
XML +=                    '<p971:address>';	
 XML +=                       '<p971:addressLine1>321 DATA ST </p971:addressLine1>';
 XML +=                       '<p971:addressLine2>STE 123</p971:addressLine2>';
 XML +=                       '<p971:city>LOS ANGELES</p971:city>';
 XML +=                       '<p971:plus4/>';
 XML +=                       '<p971:state>CA</p971:state>';
  XML +=                      '<p971:zip>90045</p971:zip>';
  XML +=                      '<p971:countyCode>037</p971:countyCode>';
   XML +=                     '<p971:countyName>LOS ANGELES</p971:countyName>';
   XML +=                     '<p971:failLevelCode>2</p971:failLevelCode>';
   XML +=                 '</p971:address>';
   XML +=                 '<p971:messageCode>ADDRESS CLEANSING FAILED</p971:messageCode>';
   XML +=                 '<p971:securityInfo xsi:nil="true"/>';
   XML +=             '</p971:message>';
    XML +=        '</p788:cleanseAddressReturn>';
    XML +=    '</p788:cleanseAddressResponse>';
  XML +=  '</soapenv:Body>';
XML +='</soapenv:Envelope>';
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'text/xml');
        response.setBody(XML);
        response.setStatusCode(200);
        return response; 
    }
}