/*=====================================================================
* (c) 2018 Appirio - A Wipro Company, Inc
* Name: AHFC_Due_Date_Controller_Test.apex
* Description: Unit Test class for AHFC_ArticlePrintableVF
* Created Date: 21st Nov 2018
* Created By: Naveen Pilla
*  ===================================================================== */

@isTest
public class AHFC_ArticlePrintableApexController_Test {
    
    public static testMethod void testArticleView() {
       
         FAQ__Kav fa = new FAQ__Kav(UrlName='testurl', Title = 'Test faq', Allow_Print_Download__c = True);
        insert fa;
        Test.startTest();
        AHFC_ArticlePrintableApexController controller; 
        ApexPages.currentPage().getParameters().put('kid',fa.id );
        controller = new AHFC_ArticlePrintableApexController();
        System.assertEquals(fa.UrlName, controller.details.UrlName);
        System.assertEquals(fa.Title, controller.details.Title);
        Test.stopTest();
        
    }
    
    
}