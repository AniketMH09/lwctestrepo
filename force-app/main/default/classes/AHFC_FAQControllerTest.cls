/*@Apex Class   	 :   AHFC_FAQControllerTest
* @description       :   Test class for AHFC_FAQController
* @created By        :   Aswin Jose
* @created on        :   27/7/2021
* @modified on		 :	
* @modified By		 :	Aswin Jose
* @modification Log	 :	
*********************************************************************************/
@isTest
public class AHFC_FAQControllerTest {
    
    public static testMethod void testData1(){
        Test.startTest();
        
        User userData = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserPermissionsKnowledgeUser = true
        );
        
        Id recTypeId = Schema.SObjectType.FAQ__kav.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        FAQ__kav faq = new FAQ__kav();
        faq.Title = 'What are eStatements?';
        faq.Summary ='Briefly describe the article.';
        faq.Details__c = 'What are eStatements?';
        faq.ValidationStatus = 'Validated';
        faq.UrlName = 'WhatareeStatements';
        faq.RecordTypeId = recTypeId;
        insert faq;
        
        FAQ__DataCategorySelection abc = new FAQ__DataCategorySelection();
		abc.ParentId = faq.id;
		abc.DataCategoryGroupName = 'Customer';
		abc.DataCategoryName = 'Statements';
		insert abc;
        
        System.runAs(userData){
            FAQ__kav insertedTestFaq = [Select KnowledgeArticleId from FAQ__kav where ID = :faq.Id];
            KbManagement.PublishingService.publishArticle(insertedTestFaq.KnowledgeArticleId, true);
            
            List<AHFC_FAQController.FAQWrapper> faqWrapperListPartial = AHFC_FAQController.setFaqListBasedOnTopics('Statements', 'Partial');
            List<AHFC_FAQController.FAQWrapper> faqWrapperListAll = AHFC_FAQController.setFaqListBasedOnTopics('Statements', 'All');
            
            System.assertEquals(faqWrapperListPartial.size(), 1, 'Success');
            System.assertEquals(faqWrapperListAll.size(), 1, 'Success');
            
            String descriptionHTML = '<iframe class="AHFC_Video" allowfullscreen="" height="215" src="//www.youtube.com/embed/yCOY82UdFrw" width="381"></iframe><br /> Yes. Log in to your Honda Financial Services account, click on &quot;Communication Preferences&quot; and then select the type of notification you wish to receive. <div id="" style="left: 20px;top: 20px;">&nbsp;</div>';
            //AHFC_FAQController.checkIfVideoAvailable(descriptionHTML);
            AHFC_FAQController.getSingleArticle('Statements', faq.Id);
            AHFC_FAQController.setFaqListBasedOnTopicsViewCount();
            AHFC_FAQController.getArticlesList('Statements');
            
        }
        
        
        Test.stopTest();
    }

}