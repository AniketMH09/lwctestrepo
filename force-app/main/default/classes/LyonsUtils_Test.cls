/*
@ Author : Veeraraj
  */
@isTest
public class LyonsUtils_Test{

static testMethod void LyonsUtils_TestMethod1(){
Test.setMock(WebServiceMock.class , new LyonsNewServiceMock());
Test.startTest();
LyonsUtils.getRoutingNumber('hello'); 
  LyonsUtils.getRoutingNumber('021000089');  
    
//string RestWebservice = LyonsUtils.getBankName('021000089');
//string expected='[{"companyId":"2661","userName":"AhondaSB","password":"Lz7wsqPh","rtn":"021000089","country":"US","includeInactive":"false","includeWireSearch":"true","includeHistory":"false"}]';
  //string expected='[{"LyonCred.CompanyId__c":"2661","LyonCred.User_Name__c":"AhondaSB","nCred.Password__c":"Lz7wsqPh"}]';
    // system.assertnotequals(expected,RestWebservice);   
    
Test.stopTest();

}
    static testMethod void LyonsUtils_TestMethodforBankName(){
        LyonsCredentials__c LyonCred = LyonsCredentials__c.getOrgDefaults();
        LyonCred.CompanyId__c = '4341';
        LyonCred.User_Name__c = 'AHFC';  
        LyonCred.Password__c = 'l@lkfvsaw';
        insert LyonCred;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LyonsUtils_Mock());
        LyonsUtils.getRoutingNumber('021000089');
        Test.stopTest();
    }
}