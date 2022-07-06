/*Apex Class Name   :   AHFC_FiservIntegrationHandlerTest
* Description       :   This is a webservice mock class for AHFC_FiservIntegrationHandler
* Created By        :   Akash Solanki
* Created on        :   25/5/2021
*********************************************************************************/
global class AHFC_FiservIntegrationHandlerCalloutMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request) {
        String XML = '<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">';
        XML +='<S:Body>';
        XML +='<DocumentSearchResponse xmlns="http://feds.fiserv.com/FEDServiceLib">';
        XML += '<UUID>83aeeef3-56f0-4bc2-b51c-c5d267193de9</UUID>';
        XML +='<Status>';
        XML +='<StatusCode>200</StatusCode>';
        XML +='<StatusDesc>Successful request.</StatusDesc>';
        XML +='</Status>';
        XML +='<SearchResult>';
        XML +='<DocumentID>ehKJ69WQ6NLeaCkByT37mImYDu_Pf_ePhmHwH3yy6rNZY2Wn3Wp-iHFHIys0ik3va0sRxzz0Q98yiw8J1AnUAsG3H4BncDdKkYNvspvWq8wuhmtf3HxfF_uKQviCwJQ1vZxLlVsXIsRckgi--AmV-adP_KuQvtU48tXjjjZQ2Cw.</DocumentID>';
        XML+='<PageCount>1</PageCount>';
        XML +='<ResultPage>67</ResultPage>';
        XML +='<Detail>';
        XML +='<Name>Letterid</Name>';
        XML +='<Value>STMT</Value>';
        XML +='</Detail>';
        XML +='<Detail>';
        XML +='<Name>Reprint</Name>';
        XML += '<Value>N</Value>';
        XML +='</Detail>';
        XML +='<Detail>';
        XML +='<Name>Accountid</Name>';
        XML +='<Value>00000200217887</Value>';
        XML +='</Detail>';
        XML +='<Detail>';
        XML +='<Name>Ltrdate</Name>';
        XML +='<Value>20210124</Value>';
        XML +='</Detail>';
        XML +='<Detail>';
        XML +='<Name>id</Name>';
        XML +='<Value>4748702a-7165-4d5b-9c0f-c55d274ab3bd</Value>';
        XML +='</Detail>';
        XML +='<Detail>';
        XML +='<Name>Vs</Name>';
        XML +='<Value>00000200217887</Value>';
        XML +='</Detail>';
        XML +='</SearchResult>';
        XML +='</DocumentSearchResponse>';
        XML+='</S:Body>';
        XML+='</S:Envelope>';
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'text/xml');
        response.setBody(XML);
        response.setStatusCode(200);
        return response; 
    }
}