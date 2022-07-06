/**
@Author Sumit
@name CommunicationPreferenceExtension_TEST
@CreateDate 19_Sep_2014
@Description This class is used to check Communication preferences of the AHFC customer.
**/

@isTest
public class CommunicationPreferenceExtension_Test{
    Static TestMethod void communicationPreferenceExtension_TestMethod(){
        
         UpdateEDeliveryPreferenceService__c cs = new UpdateEDeliveryPreferenceService__c ();
        cs.Name            = 'eDeliveryService' ;
        cs.SiteId__c       = 'SALESFORCE' ;
        cs.BusinessId__c   = 'SALESFORCE' ;
        cs.Magic_String__c = 'SFoRceMagic' ;
        cs.TimeOut__c      = '60000' ;
        cs.VendorId__c     = 'SALESFORCE' ;
        cs.Env__c     = 'TEST' ;
     insert cs;
     
        Test.startTest();
        
        Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1111';
            finacc1.Honda_Brand__c = 'AFS';
            //finacc1.EmailAddress__c = 'testorg@gmail.com';
            finacc1.FI_Stop_Reinstate_Recurring_Payment__c = 'S';
        insert finacc1;
        System.assertNotEquals(Null,finacc1.id);
        
        
        ApexPages.CurrentPage().getParameters().put('finnumber','1111');    
        Account a =new Account();
            a.Name='Test';
            insert a;
        
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc1.id;
        cPref.Customer__c=a.Id;
        cPref.Account_Status_Updates_via_Email__c=true;
        cPref.Account_Status_Updates_via_Text__c=true;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=false;
        cPref.Email_Address__c= 'testhonda@testorg.com';
        cPref.EasyPay_Communications_via_Email__c= true;
        cPref.Text_Number__c = '(999) 999-9999' ;
        cPref.Payment_Confirmations_via_Text__c = true;
        cpref.Payment_Reminders_via_Text__c = true;  
        cPref.EasyPay_Communications_via_Text__c = true;
        cPref.Statements_Letters__c = 'eDelivery';
        insert cPref;
        
        ID cfaId = CreateObjectTest.createCustomerFinanceAccount(a.Id,finacc1.id);
        NotificationTextMsgs__c ntm = new  NotificationTextMsgs__c();
            ntm.MsgTemplate__c = 'WelcomToNotificationHonda';
            ntm.Name ='WelcomToNotificationHonda' ;
        insert ntm;
        
        PageReference pageRef = Page.CommunicationPreferences;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('isReadOnly', 'true');
        ApexPages.CurrentPage().getParameters().put('finnumber',finacc1.Finance_Account_Number__c);
        
        ApexPages.StandardController con = new ApexPages.StandardController(cPref); 
        CommunicationPreferenceExtension cpe = new CommunicationPreferenceExtension(con);
        cpe.save();
        //Apexpages.NotificationTextMsgs__c
        //cpe.sendSMS('5959595995', 'khakhfka',cPref.Id);
        cpe.getclosePopUp();
        cpe.hidePopup();
        cpe.showpopUpAccOverview();
        cpe.hidepopUpaccOverview();
        cpe.showCancelPopup();
        cpe.hideCancelPopup();
        cpe.accountOverview();
        cpe.getHeaderDisplay();
        //cpe.sendSMS('9994562147','testmessage',cPref.Id);
        pagereference p=cpe.ValidateCancelBtn();
        
        finacc1.Honda_Brand__c = 'HFS';
        update finacc1;
       
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Payment_Confirmations_via_Text__c =false;
        update cPref;
        cpe.save();
       
        /*cPref.Payment_Reminders_via_Text__c=true;
        update cPref;
        cpe.save();*/
        
        cPref.Email_Address__c= 'test123@testorg.com';
        update cPref;
        cpe.save();
        
        Test.stopTest();
    }
    Static TestMethod void communicationPreferenceExtension_TestMethod1(){
        
         UpdateEDeliveryPreferenceService__c cs = new UpdateEDeliveryPreferenceService__c ();
        cs.Name            = 'eDeliveryService' ;
        cs.SiteId__c       = 'SALESFORCE' ;
        cs.BusinessId__c   = 'SALESFORCE' ;
        cs.Magic_String__c = 'SFoRceMagic' ;
        cs.TimeOut__c      = '60000' ;
        cs.VendorId__c     = 'SALESFORCE' ;
        cs.Env__c     = 'TEST' ;
     insert cs;
     
        Test.startTest();
        
        Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1111';
            finacc1.Honda_Brand__c = 'HFS';
            //finacc1.EmailAddress__c = 'testorg@gmail.com';
            finacc1.FI_Stop_Reinstate_Recurring_Payment__c = 'S';
        insert finacc1;
        System.assertNotEquals(Null,finacc1.id);
        
        
        ApexPages.CurrentPage().getParameters().put('finnumber','1111');    
        Account a =new Account();
            a.Name='Test';
            insert a;
        
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc1.id;
        cPref.Customer__c=a.Id;
        cPref.Account_Status_Updates_via_Email__c=true;
        cPref.Account_Status_Updates_via_Text__c=true;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Email_Address__c= 'testhonda@testorg.com';
        cPref.EasyPay_Communications_via_Email__c= true;
        cPref.Text_Number__c = '(999) 999-9999' ;
        cPref.Payment_Confirmations_via_Text__c = false;
        cpref.Payment_Reminders_via_Text__c = true;  
        cPref.EasyPay_Communications_via_Text__c = true;
        cPref.Statements_Letters__c = 'eDelivery';
        insert cPref;
        
        ID cfaId = CreateObjectTest.createCustomerFinanceAccount(a.Id,finacc1.id);
        
        NotificationTextMsgs__c ntm = new  NotificationTextMsgs__c();
            ntm.MsgTemplate__c = 'WelcomToNotificationHonda';
            ntm.Name ='WelcomToNotificationHonda' ;
        insert ntm;
        
        PageReference pageRef = Page.CommunicationPreferences;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('isReadOnly', 'true');
        ApexPages.CurrentPage().getParameters().put('finnumber',finacc1.Finance_Account_Number__c);
        
        ApexPages.StandardController con = new ApexPages.StandardController(cPref); 
        cPref.Email_Address__c= 'honda11@testorg.com';
        update cPref;
        CommunicationPreferenceExtension cpe = new CommunicationPreferenceExtension(con);
        cpe.save();
        
        //Apexpages.NotificationTextMsgs__c
        //cpe.sendSMS('5959595995', 'khakhfka',cPref.Id);
        cpe.getclosePopUp();
        cpe.hidePopup();
        cpe.showpopUpAccOverview();
        cpe.hidepopUpaccOverview();
        cpe.showCancelPopup();
        cpe.hideCancelPopup();
        cpe.accountOverview();
        cpe.getHeaderDisplay();
        //cpe.sendSMS('9994562147','testmessage',cPref.Id);
        
        cPref.Email_Address__c= 'honda@testorg.com';
        update cPref;
        pagereference p=cpe.ValidateCancelBtn();

        cPref.Payment_Reminders_via_Text__c=false;
        cPref.Payment_Confirmations_via_Text__c =true;
        update cPref;
        cpe.save();
        
        String t= cpe.Textnumber;
        Boolean b1= cpe.chkBox;
        
        Test.stopTest();
     
    }
        Static TestMethod void communicationPreferenceExtension_TestMethod2(){
        
        Test.startTest();
        
         UpdateEDeliveryPreferenceService__c cs = new UpdateEDeliveryPreferenceService__c ();
            cs.Name            = 'eDeliveryService' ;
            cs.SiteId__c       = 'SALESFORCE' ;
            cs.BusinessId__c   = 'SALESFORCE' ;
            cs.Magic_String__c = 'SFoRceMagic' ;
            cs.TimeOut__c      = '60000' ;
            cs.VendorId__c     = 'SALESFORCE' ;
            cs.Env__c     = 'TEST' ;
         insert cs;
         
        Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1111';
            finacc1.Honda_Brand__c = 'HFS';
            //finacc1.EmailAddress__c = 'testorg@gmail.com';
            finacc1.FI_Stop_Reinstate_Recurring_Payment__c = 'S';
        insert finacc1;
        System.assertNotEquals(Null,finacc1.id);
        
        
        ApexPages.CurrentPage().getParameters().put('finnumber','1111');    
        Account a =new Account();
            a.Name='Test';
            insert a;
        
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc1.id;
        cPref.Customer__c=a.Id;
        cPref.Account_Status_Updates_via_Email__c=true;
        cPref.Account_Status_Updates_via_Text__c=true;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Email_Address__c= 'testhonda@testorg.com';
        cPref.EasyPay_Communications_via_Email__c= true;
        cPref.Text_Number__c = '(999) 999-9999' ;
        cPref.Payment_Confirmations_via_Text__c = false;
        cpref.Payment_Reminders_via_Text__c = true;  
        cPref.EasyPay_Communications_via_Text__c = true;
        cPref.Statements_Letters__c = 'eDelivery';
        insert cPref;
        
        ID cfaId = CreateObjectTest.createCustomerFinanceAccount(a.Id,finacc1.id);
        
        NotificationTextMsgs__c ntm = new  NotificationTextMsgs__c();
            ntm.MsgTemplate__c = 'WelcomToNotificationHonda';
            ntm.Name ='WelcomToNotificationHonda' ;
        insert ntm;
        
        PageReference pageRef = Page.CommunicationPreferences;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('isReadOnly', 'true');
        ApexPages.CurrentPage().getParameters().put('finnumber',finacc1.Finance_Account_Number__c);
        
        ApexPages.StandardController con = new ApexPages.StandardController(cPref); 
        CommunicationPreferenceExtension cpe = new CommunicationPreferenceExtension(con);
        cpe.save();
        
        //Apexpages.NotificationTextMsgs__c
        //cpe.sendSMS('5959595995', 'khakhfka',cPref.Id);
        cpe.getclosePopUp();
        cpe.hidePopup();
        cpe.showpopUpAccOverview();
        cpe.hidepopUpaccOverview();
        cpe.showCancelPopup();
        cpe.hideCancelPopup();
        cpe.accountOverview();
        cpe.getHeaderDisplay();
        //cpe.sendSMS('9994562147','testmessage',cPref.Id);

        pagereference p=cpe.ValidateCancelBtn();
        pagereference p1=cpe.init();
        
        cPref.Payment_Reminders_via_Text__c=false;
        cPref.Payment_Confirmations_via_Text__c =true;
            //New DSX Parameters added
        cPref.Account_Status_Updates_via_Email__c=false;
        cPref.Account_Status_Updates_via_Text__c=false;
        update cPref;
        cpe.save();
        
        String t= cpe.Textnumber;
        Boolean b1= cpe.chkBox;
        
        Test.stopTest();
     
    }
}