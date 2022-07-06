@isTest
global class ExactTargetServiceMock implements HttpCalloutMock {
    protected Integer code;
    protected string msg;
    protected Integer statuscode;
    public ExactTargetServiceMock(Integer statuscode, Integer standardStatusCode,string message) {
        this.code = statuscode;
        this.statuscode = standardStatusCode;
        this.msg = message;
            
    }
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response.
        // Set response values, and 
        // return response.
      
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(code == 401){
       		res.setBody('{"message": "Not Authorized"}');     
        }else{
          	res.setBody('{"message": "'+msg+'", "count": 1, "excludedCount": 0, "createDate": "2020-06-24T06:14:34.063", "completeDate": "2020-06-24T06:14:35.287", "status": "Finished","tracking": [{"mobileNumber": "1234567890","statusCode": "2","message": "'+msg+'","standardStatusCode": "'+statuscode+'","description": "Delivered to handset"}]}');  
        }
        res.setStatusCode(code);
        res.setStatus('Complete');
        
        return res;
    }
}