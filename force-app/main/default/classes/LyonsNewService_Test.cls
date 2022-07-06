/*
Test Class for LyonsNewService

*/
@isTest
public class LyonsNewService_Test{
    
    private static testMethod void testLyons()
    {
        Test.setMock(WebServiceMock.class , new LyonsNewServiceMock());
        
        LyonsNewService lws = new LyonsNewService();
        LyonsNewService.ABAServiceSoap a=new LyonsNewService.ABAServiceSoap();
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
        //String s4 = a.GetBanksPrimarySortXML('testtoken','testaba');
        a.Logoff('testtoken');
        String s5=a.GetBanksWithWireXML('testtoken','testaba');
    }
    
    private static testMethod void LyonsNewService_TestMethod(){ 
    
    // LyonsNewService lws = new LyonsNewService();
    Test.setMock(WebServiceMock.class , new LyonsNewServiceMock());
    
    LyonsNewService.ABAServiceSoap lwsgb25 = new LyonsNewService.ABAServiceSoap();
    LyonsNewService.GetBanksXML_W3C_element lwsgb = new LyonsNewService.GetBanksXML_W3C_element();
    LyonsNewService.FindASCompanyIDResponse_element lwsfcre = new LyonsNewService.FindASCompanyIDResponse_element();
    LyonsNewService.GetBanksWithWireXML_element lwsgbwwe = new LyonsNewService.GetBanksWithWireXML_element();
    LyonsNewService.Logoff_element lwsgb2 = new LyonsNewService.Logoff_element();
    LyonsNewService.VerifyABA_element lwsgb3 = new LyonsNewService.VerifyABA_element();
    LyonsNewService.ValidateABA_element lwsgb4 = new LyonsNewService.ValidateABA_element();
    LyonsNewService.GetBanksWithWireXML_W3C_element lwsgb5 = new LyonsNewService.GetBanksWithWireXML_W3C_element();
    LyonsNewService.FindCompanyID_element lwsgb6 = new LyonsNewService.FindCompanyID_element();
    LyonsNewService.RequiredLogon_element lwsgb7 = new LyonsNewService.RequiredLogon_element();
    LyonsNewService.VerifyABAResponse_element lwsgb8 = new LyonsNewService.VerifyABAResponse_element();
    LyonsNewService.GetBanksXMLResponse_element lwsgb9 = new LyonsNewService.GetBanksXMLResponse_element();
    LyonsNewService.RequiredLogonResponse_element lwsgb10 = new LyonsNewService.RequiredLogonResponse_element();
    LyonsNewService.VerifyWireResponse_element lwsgb11 = new LyonsNewService.VerifyWireResponse_element();
    LyonsNewService.VerifyWire_element lwsgb12 = new LyonsNewService.VerifyWire_element();
    LyonsNewService.Logon_element lwsgb13 = new LyonsNewService.Logon_element();
    LyonsNewService.FindCompanyIDResponse_element lwsgb14 = new LyonsNewService.FindCompanyIDResponse_element ();
    LyonsNewService.GetBanksWithWireXML_W3CResponse_element lwsgb15 = new LyonsNewService.GetBanksWithWireXML_W3CResponse_element();
    LyonsNewService.LogoffResponse_element lwsgb16 = new LyonsNewService.LogoffResponse_element();
    LyonsNewService.GetBanksWithWireXMLResponse_element lwsgb17 = new LyonsNewService.GetBanksWithWireXMLResponse_element ();
    LyonsNewService.ValidateABAResponse_element lwsgb18 = new LyonsNewService.ValidateABAResponse_element();
    LyonsNewService.GetBanksXML_element lwsgb19 = new LyonsNewService.GetBanksXML_element();
    LyonsNewService.GetCompanyIDResponse_element lwsgb20 = new LyonsNewService.GetCompanyIDResponse_element();
    LyonsNewService.GetBanksXML_W3CResponse_element lwsgb21 = new LyonsNewService.GetBanksXML_W3CResponse_element();
    LyonsNewService.LogonResponse_element lwsgb22 = new LyonsNewService.LogonResponse_element();
    LyonsNewService.FindASCompanyID_element lwsgb23 = new LyonsNewService.FindASCompanyID_element();
    LyonsNewService.GetCompanyID_element lwsgb24 = new LyonsNewService.GetCompanyID_element();
    LyonsNewService.GetBanksPrimarySortXML_element lwsgb25a = new LyonsNewService.GetBanksPrimarySortXML_element();
    LyonsNewService.GetCompanyIDResponse_element lwsgb26 = new LyonsNewService.GetCompanyIDResponse_element();
    LyonsNewService.GetCompanyID_element  lwsgb27 = new LyonsNewService.GetCompanyID_element();
    LyonsNewService.GetBanksPrimarySortXMLResponse_element lwsgb28 = new LyonsNewService.GetBanksPrimarySortXMLResponse_element();
   // LyonsNewService.GetBanksPrimarySortXML lwsgb29 = new LyonsNewService.GetBanksPrimarySortXML();

   // LyonsNewService.GetCompanyID lwsgb27 = new LyonsNewService.GetCompanyID();
    //lwsgb25.FindASCompanyID('13213','12231');
    }
}