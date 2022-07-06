/*=====================================================================
* (c) 2018 Appirio - A Wipro Company, Inc
* Name: AHFC_Article_Pdf_Button_Controller_test.apex
* Description: Unit Test class for AHFC_Article_Pdf_Button_Controller
* Created Date: 11th Dec 2018
* Created By: Naveen Pilla
*  ===================================================================== */

@isTest
public class AHFC_Article_Pdf_Button_Controller_test {
    
    
    public static testMethod void testDownloadButton() {
        Test.startTest();
       //List<FAQ__Kav> faq=new List<FAQ__Kav>();
       // faq = TestDataFactory.createFAQRecords(2);
         FAQ__Kav fa = new FAQ__Kav(UrlName='testurl', Title = 'Test faq', Allow_Print_Download__c = True);
        insert fa;
        System.assertEquals(fa.Allow_Print_Download__c ,AHFC_Article_Pdf_Button_Controller.getDownloadStatus(fa.id));
        //System.assertEquals(null,AHFC_Article_Pdf_Button_Controller.getDownloadStatus(null));
        Test.stopTest();
    }
    
}