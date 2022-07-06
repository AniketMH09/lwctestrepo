/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for RoutingNumberExtension
*****************************************************************************/

@isTest
public class RoutingNumberExtension_Test{
    private static TestMethod void routingNumberExtension(){
        
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
        insert newAccount;
        
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Past_Amount_Due__c=2000;
        //finacc.Customer__c=cfa.Id;
        insert finacc;
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Customer__c=newAccount.Id;
        cfa.Finance_Account__c=finacc.Id;
        insert cfa;
        
        finacc.Customer__c=cfa.Id;
        update finacc;
        
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc.Id;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Payment_Confirmations_via_Text__c=true;
        cPref.EasyPay_Communications_via_Text__c =true;
        cPref.Text_Number__c='9992223334';
        cPref.Customer__c=newAccount.Id;
        insert cPref;
        
        Payment_Source__c paysourcerecord = new Payment_Source__c();
        paysourcerecord.Bank_Name__c='TestCitiBank';
        paysourcerecord.Payment_Source_Nickname__c='TestABC';
        paysourcerecord.Bank_Routing_Number__c='021000089';
        paysourcerecord.Bank_Account_Type__c='TestSaving';
        paysourcerecord.Preferred_Payment_Source__c=false;
        paysourcerecord.Bank_Account_Number__c=''+1234567;
        paysourcerecord.Finance_Account_Number__c = finacc.Id;
        paysourcerecord.Status__c='Deleted';
        insert paysourcerecord;
        System.debug(paysourcerecord.Id);
        
        LyonsCredentials__c l=new LyonsCredentials__c();
        l.CompanyId__c='100';
        l.Password__c='TestPassword';
        l.User_Name__c='TestUName';
        insert l;
        
        Test.setMock(WebServiceMock.class , new LyonWebServiceMock());
        
        PageReference pageRef = Page.VF1_RoutingNumber;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('finnumber', finacc.Id);
        ApexPages.CurrentPage().getparameters().put('custNumber', finacc.Customer__c);
        Apexpages.currentPage().getParameters().put('id',paysourcerecord.Id);
        Apexpages.currentPage().getParameters().put('op','create');
        ApexPages.StandardController sc = new ApexPages.StandardController(paysourcerecord);
        RoutingNumberExtension c=new RoutingNumberExtension (sc);
        pagereference p=c.validateRoutingNumber();
        c.save();      
        c.cancel();
        c.SaveRec();
        pagereference p1=c.init();
        Boolean b=c.showFin;
        Boolean b1=c.showCust;
    }
    private static TestMethod void routingNumberExtension1(){
        
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
        insert newAccount;
        
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Past_Amount_Due__c=2000;
        //finacc.Customer__c=cfa.Id;
        insert finacc;
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Customer__c=newAccount.Id;
        cfa.Finance_Account__c=finacc.Id;
        insert cfa;
        
        finacc.Customer__c=cfa.Id;
        update finacc;
        
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc.Id;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Payment_Confirmations_via_Text__c=true;
        cPref.EasyPay_Communications_via_Text__c =true;
        cPref.Text_Number__c='9992223334';
        cPref.Customer__c=newAccount.Id;
        insert cPref;
        
        Payment_Source__c paysourcerecord = new Payment_Source__c();
        paysourcerecord.Bank_Name__c='TestCitiBank';
        paysourcerecord.Payment_Source_Nickname__c='TestABC';
        paysourcerecord.Bank_Routing_Number__c='021000089';
        paysourcerecord.Bank_Account_Type__c='TestSaving';
        paysourcerecord.Preferred_Payment_Source__c=false;
        paysourcerecord.Bank_Account_Number__c=''+1234567;
        paysourcerecord.Finance_Account_Number__c = finacc.Id;
        paysourcerecord.Status__c='Deleted';
        insert paysourcerecord;
        System.debug(paysourcerecord.Id);
        
        LyonsCredentials__c l=new LyonsCredentials__c();
        l.CompanyId__c='100';
        l.Password__c='TestPassword';
        l.User_Name__c='TestUName';
        insert l;
        
        Test.setMock(WebServiceMock.class , new LyonWebServiceMock());
        
        PageReference pageRef = Page.VF1_RoutingNumber;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('finnumber', finacc.Id);
        ApexPages.CurrentPage().getparameters().put('custNumber', finacc.Customer__c);
        Apexpages.currentPage().getParameters().put('id',null);
        Apexpages.currentPage().getParameters().put('op','create');
        
        ApexPages.StandardController sc = new ApexPages.StandardController(paysourcerecord);
        RoutingNumberExtension c=new RoutingNumberExtension (sc);
        pagereference p=c.validateRoutingNumber();
        c.save();      
        c.cancel();
        c.SaveRec();
        pagereference p1=c.init();
        Boolean b=c.showFin;
        Boolean b1=c.showCust;
    }
}