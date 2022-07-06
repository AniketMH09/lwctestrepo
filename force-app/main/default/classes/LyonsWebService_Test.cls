/*@ Author : Hari Charan Nethi  
  */
@isTest
public class LyonsWebService_Test{
    
    private static testMethod void testLyons()
    {
        Test.setMock(WebServiceMock.class , new LyonWebServiceMock());
        
        LyonsWebService lws = new LyonsWebService();
        LyonsWebService.ABAServiceSoap a=new LyonsWebService.ABAServiceSoap();
        integer i1=a.GetCompanyID('testtoken');
        Integer i=a.FindASCompanyID('testserialnum','testpayeecode');
        String s=a.Logon(100,'testname','testpassword');
        Boolean b=a.ValidateABA('testtoken','testaba');
        String s1=a.GetBanksWithWireXML_W3C('testtoken','testaba');
        Boolean b1=a.RequiredLogon('testtoken');
        String s2=a.GetBanksXML_W3C('testtoken','testaba');
        Boolean b2=a.VerifyWire('testtoken','testaba');
        Integer i2=a.FindCompanyID('testwildcard');
        Boolean b3=a.VerifyABA('testtoken','testaba');
        String s3=a.GetBanksXML('testtoken','testaba');
        a.Logoff('testtoken');
        String s4=a.GetBanksWithWireXML('testtoken','testaba');
    }
    
    private static testMethod void LyonsWebService_TestMethod(){ 
    
    //LyonsWebService lws = new LyonsWebService();
    Test.setMock(WebServiceMock.class , new LyonWebServiceMock());
    
    LyonsWebService.ABAServiceSoap lwsgb25 = new LyonsWebService.ABAServiceSoap();
    LyonsWebService.GetBanksXML_W3C_element lwsgb = new LyonsWebService.GetBanksXML_W3C_element();
    LyonsWebService.FindASCompanyIDResponse_element lwsfcre = new LyonsWebService.FindASCompanyIDResponse_element();
    LyonsWebService.GetBanksWithWireXML_element lwsgbwwe = new LyonsWebService.GetBanksWithWireXML_element();
    LyonsWebService.Logoff_element lwsgb2 = new LyonsWebService.Logoff_element();
    LyonsWebService.VerifyABA_element lwsgb3 = new LyonsWebService.VerifyABA_element();
    LyonsWebService.ValidateABA_element lwsgb4 = new LyonsWebService.ValidateABA_element();
    LyonsWebService.GetBanksWithWireXML_W3C_element lwsgb5 = new LyonsWebService.GetBanksWithWireXML_W3C_element();
    LyonsWebService.FindCompanyID_element lwsgb6 = new LyonsWebService.FindCompanyID_element();
    LyonsWebService.RequiredLogon_element lwsgb7 = new LyonsWebService.RequiredLogon_element();
    LyonsWebService.VerifyABAResponse_element lwsgb8 = new LyonsWebService.VerifyABAResponse_element();
    LyonsWebService.GetBanksXMLResponse_element lwsgb9 = new LyonsWebService.GetBanksXMLResponse_element();
    LyonsWebService.RequiredLogonResponse_element lwsgb10 = new LyonsWebService.RequiredLogonResponse_element();
    LyonsWebService.VerifyWireResponse_element lwsgb11 = new LyonsWebService.VerifyWireResponse_element();
    LyonsWebService.VerifyWire_element lwsgb12 = new LyonsWebService.VerifyWire_element();
    LyonsWebService.Logon_element lwsgb13 = new LyonsWebService.Logon_element();
    LyonsWebService.FindCompanyIDResponse_element lwsgb14 = new LyonsWebService.FindCompanyIDResponse_element ();
    LyonsWebService.GetBanksWithWireXML_W3CResponse_element lwsgb15 = new LyonsWebService.GetBanksWithWireXML_W3CResponse_element();
    LyonsWebService.LogoffResponse_element lwsgb16 = new LyonsWebService.LogoffResponse_element();
    LyonsWebService.GetBanksWithWireXMLResponse_element lwsgb17 = new LyonsWebService.GetBanksWithWireXMLResponse_element ();
    LyonsWebService.ValidateABAResponse_element lwsgb18 = new LyonsWebService.ValidateABAResponse_element();
    LyonsWebService.GetBanksXML_element lwsgb19 = new LyonsWebService.GetBanksXML_element();
    LyonsWebService.GetCompanyIDResponse_element lwsgb20 = new LyonsWebService.GetCompanyIDResponse_element();
    LyonsWebService.GetBanksXML_W3CResponse_element lwsgb21 = new LyonsWebService.GetBanksXML_W3CResponse_element();
    LyonsWebService.LogonResponse_element lwsgb22 = new LyonsWebService.LogonResponse_element();
    LyonsWebService.FindASCompanyID_element lwsgb23 = new LyonsWebService.FindASCompanyID_element();
    LyonsWebService.GetCompanyID_element lwsgb24 = new LyonsWebService.GetCompanyID_element();
    //lwsgb25.FindASCompanyID('13213','12231');
    }
}