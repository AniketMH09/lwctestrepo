/*=====================================================================
* (c) 2018 Appirio - A Wipro Company, Inc
* Name: AHFC_Due_Date_Controller_Test.apex
* Description: Unit Test class for AHFC_Lease_Terms_Conditions_Controller
* Created Date: 27st Feb 2019
* Created By: Naveen Pilla
*  ===================================================================== */
@istest
public class AHFC_Lease_Terms_Conditions_Test {
    
    @istest
    public static void AHFC_Lease_Terms_Conditions_Controllertest(){
        
        
        PageReference myVfPage = Page.AHFC_Lease_Terms_Conditions; 
        Test.setCurrentPage(myVfPage); 
        ApexPages.currentPage().getParameters().put('communityName','hondahelp'); 
        Test.startTest();
        AHFC_Lease_Terms_Conditions_Controller leaseterms = new AHFC_Lease_Terms_Conditions_Controller();
        leaseterms.getCommunityName();
        System.assertEquals('hondahelp',leaseterms.communityName);
        List<ErrorLog__c> errorLog = [Select Id From ErrorLog__c Where ClassName__c = :Label.AHFC_Lease_Terms_Conditions_Controller];
        System.assert(errorLog.size() == 0);
        Test.stopTest();
        
        
    }
    
    @istest
    public static void AHFC_Lease_Terms_Conditions_ControllertestwithBlank(){
        
        PageReference myVfPage = Page.AHFC_Lease_Terms_Conditions; 
        Test.setCurrentPage(myVfPage); 
        ApexPages.currentPage().getParameters().put('communityName',''); 
        Test.startTest();
        AHFC_Lease_Terms_Conditions_Controller leaseterms = new AHFC_Lease_Terms_Conditions_Controller();
        leaseterms.getCommunityName();
        System.assertEquals(leaseterms.communityName,'');
        List<ErrorLog__c> errorLog = [Select Id From ErrorLog__c Where ClassName__c = :Label.AHFC_Lease_Terms_Conditions_Controller];
        System.assert(errorLog.size() > 0);
        Test.stopTest();
        
        
    }
}