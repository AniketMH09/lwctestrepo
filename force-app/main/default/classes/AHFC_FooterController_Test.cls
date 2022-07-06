/*=====================================================================
* (c) 2018 Appirio - A Wipro Company, Inc
* Name: AHFC_Due_Date_Controller_Test.apex
* Description: Unit Test class for AHFC_Due_Date_Controller component to get data from server
* Created Date: 12th Nov 2018
* Created By: Karunakar Pulkam
*  ===================================================================== */
@isTest
public class AHFC_FooterController_Test {
    public static testmethod void getFooterlinks(){
         Test.startTest();
         map<string, string> footerLinks = AHFC_FooterController.getFooterLinks();
         System.assertEquals(Label.AHFC_About_Us_URL_Honda, footerLinks.get('AHFC_About_Us_URL_Honda'));
         Test.stopTest();
        
    }
    
    
}