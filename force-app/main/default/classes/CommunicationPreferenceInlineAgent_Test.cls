/************************************************************************
Author: Sajila Kadayaprath
Description : Test class for CommunicationPreferenceInlineAgent 
************************************************************************/
@isTest
public class CommunicationPreferenceInlineAgent_Test{
    Static TestMethod void testCommPrefInlineAgent(){
        
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
        
        PageReference pageRef = Page.CommunicationPreferenceInlineAgent;
        Test.setCurrentPage(pageRef);
        
        //ApexPages.CurrentPage().getparameters().put('isReadOnly', 'true');
        //ApexPages.CurrentPage().getParameters().put('finnumber',finacc1.Finance_Account_Number__c);
        
        ApexPages.StandardController con = new ApexPages.StandardController(cPref); 
        CommunicationPreferenceInlineAgent cpi = new CommunicationPreferenceInlineAgent(con);
        
        Pagereference p= cpi.updateEdeliveryPreference();
        Pagereference p1=cpi.updateReadOnly(); 
        
        cPref.Statements_Letters__c = 'Paper';
        cPref.Email_Address__c='changetest@mail.com';
        update cPref;
        
        Pagereference p2= cpi.updateEdeliveryPreference();
        }
    }