/* Apex Class Name   :    AHFC_ListFileAndPreviewController_Test
* Description        :    class used for testing AHFC_ListFileAndPreviewController
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Edwin            		    AUG 27 2021             	Created
*********************************************************************************/
@isTest
public class AHFC_ListFileAndPreviewController_Test {
    public static testMethod void testSupportCaseControllers() {
        
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='2197';
        finacc2.Honda_Brand__c = 'AFS';
        finacc2.Payoff_Amount__c = 200.00;         
        insert finacc2; 
        System.assertEquals('2197',finacc2.Finance_Account_Number__c);
        
        Case caseObj1 = new Case();
        caseObj1.Type='Document Sharing';
        caseObj1.Status ='New';
        caseObj1.Finance_Account__c=finacc2.Id;
        caseObj1.Requested_Months__c =3;
        insert caseObj1;
        
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        //Create ContentDocumentLink 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = caseObj1.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        Test.startTest();
        AHFC_ListFileAndPreviewController.ListPreviewWrapper wrapperObj=   AHFC_ListFileAndPreviewController.getRelatedFilesByRecordId(caseObj1.id);  
        List<AHFC_ListFileAndPreviewController.ListPreviewWrapper> wrapperObj1=   AHFC_ListFileAndPreviewController.getAllFilesByRecordId(caseObj1.id); 
        
        System.assertEquals(wrapperObj1[0].contentTitle,cv.Title);
        System.assertEquals(wrapperObj.mapIdTitle.get(cv.Id),cv.Title);
        Test.stopTest();
    }
}