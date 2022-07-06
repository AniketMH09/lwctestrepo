/* Apex Class Name   :    MockLEFailureResponse
 * Description        :    MockResponse of BatchRetryLECallTest
 * Modification Log   :
 * ---------------------------------------------------------------------------
 * Developer                             Date                   Description
 * ---------------------------------------------------------------------------
 * Prabu Mohanasundaram                23rd Nov 2021             Created
 *********************************************************************************/

/**
 * @description: Added the code for failure Mock Response.
 * @author Prabu Mohanasundaram | Nov 23 2021
 **/
@isTest
global class MockLEFailureResponse implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        string response = '{' +
            '    "Body": {' +
            '        "NextDueDate": "2020-07-21T00:00:00",' +
            '        "intErrorNumber": 1,' +
            '        "strErrorMessage": "Failed"' +
            '    },' +
            '    "Header": {' +
            '        "Code": "500",' +
            '        "Status": "Failed",' +
            '        "Errors": Failed' +
            '    }' +
            '}';
        res.setBody(response);
        res.setStatusCode(500);



        return res;
    }

}