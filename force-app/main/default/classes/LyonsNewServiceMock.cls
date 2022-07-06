@isTest
global class LyonsNewServiceMock implements WebServiceMock{
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
           
       if(request instanceof LyonsNewService.GetCompanyID_element)
       {
           LyonsNewService.GetCompanyIDResponse_element responseElement=new LyonsNewService.GetCompanyIDResponse_element();
           responseElement.GetCompanyIDResult=200;
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsNewService.FindASCompanyID_element )
       {
           LyonsNewService.FindASCompanyIDResponse_element responseElement=new LyonsNewService.FindASCompanyIDResponse_element();
           responseElement.FindASCompanyIDResult=200;
           response.put('response_x', responseElement);     
       }
       else if(request instanceof LyonsNewService.Logon_element)
       {
           LyonsNewService.LogonResponse_element responseElement=new LyonsNewService.LogonResponse_element();
           responseElement.LogonResult='DummyResult';
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsNewService.ValidateABA_element)
       {
           LyonsNewService.ValidateABAResponse_element responseElement=new LyonsNewService.ValidateABAResponse_element();
           responseElement.ValidateABAResult=true;
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsNewService.GetBanksWithWireXML_W3C_element)
       {
           LyonsNewService.GetBanksWithWireXML_W3CResponse_element responseElement=new LyonsNewService.GetBanksWithWireXML_W3CResponse_element();
           responseElement.GetBanksWithWireXML_W3CResult='TestResult';
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsNewService.RequiredLogon_element)
       {
           LyonsNewService.RequiredLogonResponse_element responseElement=new LyonsNewService.RequiredLogonResponse_element();
           responseElement.RequiredLogonResult=true;
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsNewService.GetBanksXML_W3C_element)
       {
           LyonsNewService.GetBanksXML_W3CResponse_element responseElement=new LyonsNewService.GetBanksXML_W3CResponse_element();
           responseElement.GetBanksXML_W3CResult='TestResult';
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsNewService.VerifyWire_element)
       {
           LyonsNewService.VerifyWireResponse_element responseElement=new LyonsNewService.VerifyWireResponse_element();
           responseElement.VerifyWireResult=true;
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsNewService.FindCompanyID_element)
       {
           LyonsNewService.FindCompanyIDResponse_element responseElement=new LyonsNewService.FindCompanyIDResponse_element();
           responseElement.FindCompanyIDResult=100;
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsNewService.VerifyABA_element)
       {
           LyonsNewService.VerifyABAResponse_element responseElement=new LyonsNewService.VerifyABAResponse_element();
           responseElement.VerifyABAResult=true;
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsNewService.GetBanksXML_element)
       {
           LyonsNewService.GetBanksXMLResponse_element responseElement=new LyonsNewService.GetBanksXMLResponse_element();
           responseElement.GetBanksXMLResult='TestResult';
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsNewService.Logoff_element)
       {
           LyonsNewService.LogoffResponse_element responseElement=new LyonsNewService.LogoffResponse_element();
           //responseElement.LogonResult='TestResult';
           response.put('response_x', responseElement); 
       }
       else if(request instanceof LyonsNewService.GetBanksWithWireXML_element)
       {
           LyonsNewService.GetBanksWithWireXMLResponse_element responseElement=new LyonsNewService.GetBanksWithWireXMLResponse_element();
           responseElement.GetBanksWithWireXMLResult='TestResult';
           response.put('response_x', responseElement); 
        }
   }
}