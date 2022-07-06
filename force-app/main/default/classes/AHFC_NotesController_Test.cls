/* Apex Class Name   :    AHFC_NotesController_Test
* Description        :    class used for testing AHFC_NotesController
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Edwin            		    AUG 27 2021             	Created
*********************************************************************************/
@isTest(seeAllData = True)
public class AHFC_NotesController_Test {
    
    public static testMethod void testRunAs() {
		User u = [Select id,username from User where username='prabu.community@webproj1.com'];
	 	//User u = [Select id,username from User where username='sucheta.gaikwad@lntinfotechhondatest.com'];
        
        System.runAs(u) {
	 	Set<Id> objLinkSet = new Set<Id>();
        
        List<ContentDocumentLink> docList =   [SELECT ContentDocumentId, visibility, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId ='5000U00000C81JDQAZ'];
        System.debug('>>>>SOQL---'+docList);
        
        List<ContentDocumentLink> docList2 =   [SELECT ContentDocumentId, visibility, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId ='5000U00000C81JDQAZ' AND ContentDocument.FileType = 'SNOTE'];
        System.debug('>>>>SOQL---'+docList2);
            
        for ( ContentDocumentLink objCDL : [ SELECT ContentDocumentId, visibility, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId ='5000U00000C81JDQAZ' ] )  
        objLinkSet.add( objCDL.ContentDocumentId );
        System.debug('>>>>objLinkSet---'+objLinkSet);
        
        List<ContentNote> objNoteList = new List<ContentNote>();
            
        for ( ContentNote objCN : [ SELECT Title, Content, CreatedDate FROM ContentNote WHERE Id IN :objLinkSet ] )  
        objNoteList.add( objCN );
        system.debug('>>>>>>>>>objNoteList'+objNoteList);
        }
    }
}