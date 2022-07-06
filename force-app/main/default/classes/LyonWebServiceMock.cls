@isTest
global class LyonWebServiceMock implements WebServiceMock{
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
           
       if(request instanceof LyonsWebService.GetCompanyID_element)
       {
           LyonsWebService.GetCompanyIDResponse_element responseElement=new LyonsWebService.GetCompanyIDResponse_element();
           responseElement.GetCompanyIDResult=200;
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsWebService.FindASCompanyID_element )
       {
           LyonsWebService.FindASCompanyIDResponse_element responseElement=new LyonsWebService.FindASCompanyIDResponse_element();
           responseElement.FindASCompanyIDResult=200;
           response.put('response_x', responseElement);     
       }
       else if(request instanceof LyonsWebService.Logon_element)
       {
           LyonsWebService.LogonResponse_element responseElement=new LyonsWebService.LogonResponse_element();
           responseElement.LogonResult='DummyResult';
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsWebService.ValidateABA_element)
       {
           LyonsWebService.ValidateABAResponse_element responseElement=new LyonsWebService.ValidateABAResponse_element();
           responseElement.ValidateABAResult=true;
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsWebService.GetBanksWithWireXML_W3C_element)
       {
           LyonsWebService.GetBanksWithWireXML_W3CResponse_element responseElement=new LyonsWebService.GetBanksWithWireXML_W3CResponse_element();
           responseElement.GetBanksWithWireXML_W3CResult='TestResult';
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsWebService.RequiredLogon_element)
       {
           LyonsWebService.RequiredLogonResponse_element responseElement=new LyonsWebService.RequiredLogonResponse_element();
           responseElement.RequiredLogonResult=true;
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsWebService.GetBanksXML_W3C_element)
       {
           LyonsWebService.GetBanksXML_W3CResponse_element responseElement=new LyonsWebService.GetBanksXML_W3CResponse_element();
           responseElement.GetBanksXML_W3CResult='TestResult';
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsWebService.VerifyWire_element)
       {
           LyonsWebService.VerifyWireResponse_element responseElement=new LyonsWebService.VerifyWireResponse_element();
           responseElement.VerifyWireResult=true;
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsWebService.FindCompanyID_element)
       {
           LyonsWebService.FindCompanyIDResponse_element responseElement=new LyonsWebService.FindCompanyIDResponse_element();
           responseElement.FindCompanyIDResult=100;
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsWebService.VerifyABA_element)
       {
           LyonsWebService.VerifyABAResponse_element responseElement=new LyonsWebService.VerifyABAResponse_element();
           responseElement.VerifyABAResult=true;
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsWebService.GetBanksXML_element)
       {
           LyonsWebService.GetBanksXMLResponse_element responseElement=new LyonsWebService.GetBanksXMLResponse_element();
           responseElement.GetBanksXMLResult='TestResult';
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsWebService.Logoff_element)
       {
           LyonsWebService.LogoffResponse_element responseElement=new LyonsWebService.LogoffResponse_element();
           //responseElement.LogonResult='TestResult';
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsWebService.GetBanksWithWireXML_element)
       {
           LyonsWebService.GetBanksWithWireXMLResponse_element responseElement=new LyonsWebService.GetBanksWithWireXMLResponse_element();
           responseElement.GetBanksWithWireXMLResult='TestResult';
           response.put('response_x', responseElement); 
       }
   }
}