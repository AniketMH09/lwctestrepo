/* Apex Class Name   :    AHFC_NotesController
* @description       :    This Class is has been used for fetching all notes from ContentNote object based on object record ID
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Supriya Chakraborty         Aug 22 2021             Created
*********************************************************************************/

public without sharing class AHFC_NotesController {
    @AuraEnabled( cacheable=true )    
    public static List < NoteWrapper > fetchNotes( String strRecordId )  {  
        System.debug('strRecordId>>>>>>'+strRecordId);
        List < NoteWrapper > listNoteWrappers = new List < NoteWrapper >();  
        Set < Id > setDocIds = new Set < Id >();  
        for ( ContentDocumentLink objCDL : [ SELECT ContentDocumentId FROM ContentDocumentLink  WHERE LinkedEntityId =: strRecordId ] )  
            setDocIds.add( objCDL.ContentDocumentId );  
        System.debug('setDocIds>>>>>>'+setDocIds);
        //for( ContentNote objNote : [ SELECT Title, Content, CreatedDate FROM ContentNote WHERE Id IN ('0690U000001xRjBQAU','0690U000001xRjGQAU','0690U0000021vdZQAQ','0690U0000021vdjQAA')  ] ) {  commented by dev team  
   		for( ContentNote objNote : [ SELECT Title, Content, CreatedDate FROM ContentNote WHERE Id IN :setDocIds  ] ) {  
            NoteWrapper objWrapper = new NoteWrapper();  
            objWrapper.strTitle = objNote.Title;  
            //Below replaceAll removes all the HTML tags from the Content  
            objWrapper.strNotes = objNote.Content.toString().replaceAll( '<[^>]+>',' ' );  
            objWrapper.strCreatedDate = String.valueOf( objNote.CreatedDate.date() );  
            listNoteWrappers.add( objWrapper );    
        }  
        return listNoteWrappers;  
  
    }  
  
    public without sharing class NoteWrapper {  
  
        @AuraEnabled  
        public String strTitle;  
        @AuraEnabled  
        public String strNotes;  
        @AuraEnabled  
        public String strCreatedDate;  
  
    }  
}