/*******************************************************************************************************
    * @author   : SHANKAR ANAND
    * @date     : 24 JUN 2016
    * @modified : 11 AUG 2016  
    * @description : MOCK WEB SERVICE RESPONSE GENERATOR FOR THE TEST CLASS 'CybSWSResp_Test', 
    *                PURPOSE : MOCK THE SUCCESS RESPONSE.
********************************************************************************************************/


@isTest
global class HttpMockSuccessResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {        
    
        String responseBody= '';
        responseBody+='<Report MerchantID="wfghfs1" Name="Batch Submission Detail Report" SubmissionFileID="0000OcE3" SubmissionDateTime="2016-06-15 13:35:37 GMT" Version="1.0">';
        responseBody+='<Transaction>';
        responseBody+='<TransactionDate>2016-06-01 21:35:57 GMT</TransactionDate>';
        responseBody+='<CybsMID>wfghfs1</CybsMID>';
        responseBody+='<ReasonCode>100</ReasonCode>';
        responseBody+='</Transaction>';
        responseBody+='<Transaction>';
        responseBody+='<TransactionDate>2016-06-01 21:35:57 GMT</TransactionDate>';
        responseBody+='<CybsMID>wfghfs1</CybsMID>';
        responseBody+='<ReasonCode>101</ReasonCode>';
        responseBody+='</Transaction>';
        responseBody+='<Transaction>';
        responseBody+='<TransactionDate>2016-06-01 21:35:57 GMT</TransactionDate>';
        responseBody+='<CybsMID>wfghfs1</CybsMID>';
        responseBody+='<ReasonCode>202</ReasonCode>';
        responseBody+='</Transaction>';
        responseBody+='<Transaction>';
        responseBody+='<TransactionDate>2016-06-01 21:35:57 GMT</TransactionDate>';
        responseBody+='<CybsMID>wfghfs1</CybsMID>';
        responseBody+='<ReasonCode>242</ReasonCode>';
        responseBody+='</Transaction>';
        responseBody+='</Report>';
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody(responseBody);
        res.setStatusCode(200); 
        return res;
    }
}