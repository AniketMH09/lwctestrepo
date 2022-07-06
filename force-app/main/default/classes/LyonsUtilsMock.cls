@isTest
global class LyonsUtilsMock implements WebServiceMock{
global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {

LyonsUtils LU = new LyonsUtils();
LyonsUtils.getRoutingNumber('hello');

//LyonsNewService.GetCompanyIDResponse_element responseElement=new LyonsNewService.GetCompanyIDResponse_element();
//responseElement.GetCompanyIDResult=200;
//response.put('response_x', responseElement);
}
}