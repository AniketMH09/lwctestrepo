/* Apex Class Name       :    AHFC_GetAccountInfoIntHandlerMock
* @description        	 :    Mock Callout Class for AHFC_GetAccountInfoIntergationHandler
* Modification Log   	 :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               26 June 2021              Created
*********************************************************************************/
/**
* @description AHFC_GetAccountInfoIntHandlerMock
**/
public class AHFC_GetAccountInfoIntHandlerMock implements HttpCalloutMock {
/**
* @description createTestData
* @param request
* @return response mock response
**/
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        String jsonResposne = '{';
        jsonResposne+='"allowPayoffQuote": true,';
        jsonResposne+='"archived": false,';
        jsonResposne+='"contractGroup": "B",';
        jsonResposne+='"eDelCancelDate": "2021-07-06T00:00:00",';
        jsonResposne+='"eDelCancelReason": "Web",';
        jsonResposne+='"eDelLastEnrollment": "0001-01-01T00:00:00",';
        jsonResposne+='"eDelLastUndeliverable": "0001-01-01T00:00:00",';
        jsonResposne+='"ewtAllowance": 500,';
        jsonResposne+='"ewtCalcCode": "B",';
        jsonResposne+='"ewtLoyaltyWaiver": 500,';
        jsonResposne+='"fullName": "FNAMEA LNAMEABFI",';
        jsonResposne+='"garagingState": "CO",';
        jsonResposne+='"isWebsiteRestricted": true,';
        jsonResposne+='"owningRegion": "108",';
        jsonResposne+='"promiseToPay": true,';
        jsonResposne+='"statementSuppressed": false,';
        jsonResposne+='"turnInFee": 350';
        jsonResposne+='}';
        response.setBody(jsonResposne);
        response.setStatusCode(200);
        return response; 
    }
}