/* Apex Class Name   :    AHFC_CommunicationPreferenceTest
    * Description        :    class used as test class for AHFC_CommunicationPreferenceTest
    * Modification Log   :
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    * Vishnu            		JUL 28 2021             	Created
*********************************************************************************/
@isTest
public class AHFC_CommunicationPreferenceTest {
    
   
	static Finance_Account__c finacc;
    static Finance_Account__c finacc2;
    
    static testMethod void AHFC_CommunicationPref_Test() {
        UpdateEDeliveryPreferenceService__c cs = new UpdateEDeliveryPreferenceService__c ();
        cs.Name            = 'eDeliveryService' ;
        cs.SiteId__c       = 'SALESFORCE' ;
        cs.BusinessId__c   = 'SALESFORCE' ;
        cs.Magic_String__c = 'SFoRceMagic' ;
        cs.TimeOut__c      = '60000' ;
        cs.VendorId__c     = 'SALESFORCE' ;
        cs.Env__c     = 'TEST' ;
        
        finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='2541345676';
        finacc.Honda_Brand__c='AFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c=true;
        finacc.Region_Code__c='BKC';
        finacc.Account_Type__c='Balloon';
        finacc.Fl_Refinanced__c=true;
        finacc.Payment_Due_Date__c=System.Today();
        finacc.Fl_Suppress_All_Notifications__c = false;
        finacc.AHFC_Product_Nickname__c ='test';
        finacc.Fl_DDC_Eligibility__c=true;
        finacc.FL_LE_Eligibility__c=true;
        finacc.AHFC_Total_days_past_due__c=25;
        finacc.AHFC_Web_Payoff_Calendar__c='y';
        insert finacc;
        Test.setMock(HttpCalloutMock.class, new AHFC_UpdateEdeliveryMock());
        Test.startTest();
        Communication_Preferences__c communicationPrefRec= new Communication_Preferences__c();
        communicationPrefRec.Email_Address__c = 'Rohit@hondaInvalid.Com';
        communicationPrefRec.Paperless_Statements_Letters__c = true;
        communicationPrefRec.Unsubscribe_from_all__c = true;
        communicationPrefRec.Payment_Reminders_via_Email__c = true;
        communicationPrefRec.Account_Status_Updates_via_Email__c = true;
        communicationPrefRec.Finance_Account_Number__c = finacc.Id;
        insert communicationPrefRec;
        Communication_Preferences__c communicationPrefRec1 = [select id,Email_Address__c,name from Communication_Preferences__c where id =:communicationPrefRec.id];
        communicationPrefRec1.Email_Address__c =  'RSosshit@hondaInvalid.Com';
        //AHFC_CommunicationPreference.recDetailWrapper recDetails= AHFC_CommunicationPreference.commPrefDetail('Invalid');
        //system.assertEquals(recDetails.financeDetails,null,'error in data validation');
        AHFC_CommunicationPreference.recDetailWrapper recDetails6 = AHFC_CommunicationPreference.saveCommPref(JSON.serialize(communicationPrefRec1),finacc.Finance_Account_Number__c,JSON.serialize(communicationPrefRec));        
        AHFC_CommunicationPreference.recDetailWrapper recDetails1= AHFC_CommunicationPreference.commPrefDetail(finacc.Id);
        system.assertEquals(recDetails1.errorMessage,AHFC_GlobalConstans.SUCCESS,'error in data validation');
        AHFC_CommunicationPreference.recDetailWrapper recDetails2 = AHFC_CommunicationPreference.saveCommPref(JSON.serialize(communicationPrefRec),finacc.Finance_Account_Number__c,JSON.serialize(communicationPrefRec));
        
       
        insert cs;
        AHFC_CommunicationPreference.recDetailWrapper recDetails5 = AHFC_CommunicationPreference.saveCommPref(JSON.serialize(communicationPrefRec1),finacc.Finance_Account_Number__c,JSON.serialize(communicationPrefRec));
        AHFC_CommunicationPreference.recDetailWrapper recDetails3 = AHFC_CommunicationPreference.saveCommPref(JSON.serialize(communicationPrefRec),'00000455507679',JSON.serialize(communicationPrefRec1));
        AHFC_CommunicationPreference.recDetailWrapper recDetails4 = AHFC_CommunicationPreference.saveCommPref(JSON.serialize(communicationPrefRec1),finacc.Finance_Account_Number__c,JSON.serialize(communicationPrefRec));
        Test.stopTest(); 

    }
}