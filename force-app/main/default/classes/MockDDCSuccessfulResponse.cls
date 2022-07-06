@isTest
global class MockDDCSuccessfulResponse implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        string response = '{' +
            '    "Body": {' +
            '        "NextDueDate": "2020-07-21T00:00:00",' +
            '        "intErrorNumber": 0,' +
            '        "strErrorMessage": ""' +
            '    },' +
            '    "Header": {' +
            '        "Code": "200",' +
            '        "Status": "Success",' +
            '        "Errors": null' +
            '    }' +
            '}' ;
        res.setBody(response);
        res.setStatusCode(200);
        
        
        
        return res;
    }

}