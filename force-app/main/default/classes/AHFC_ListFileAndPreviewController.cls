/* Apex Class Name   :    AHFC_NotesController
* @description       :    This Class is has been used for fetching all files from ContentVersion object based on object record ID
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Supriya Chakraborty         Aug 22 2021             Created
*********************************************************************************/

public without sharing class AHFC_ListFileAndPreviewController {
    @AuraEnabled(cacheable=true)
        public static ListPreviewWrapper getRelatedFilesByRecordId(String recordId) {
            // Get record file IDs        
            List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
            ListPreviewWrapper wrapperObj = new ListPreviewWrapper();           
            List<ID> fileIDs = new List<ID>();

            wrapperObj.baseUrl = URL.getSalesforceBaseUrl().toExternalForm(); // to fetch base url
            for (ContentDocumentLink docLink : files) {
                fileIDs.add(docLink.ContentDocumentId);
            }
     
            List<ContentVersion> docs = [SELECT Id,ContentDocumentId, FileExtension, Title 
                FROM ContentVersion WHERE ContentDocumentId IN : fileIDs AND FileType != 'SNOTE']; // excluding notes from content version
            Map<ID, String> mapIdTitle = new Map<ID, String>();
            for (ContentVersion docLink : docs) {
                mapIdTitle.put(docLink.Id, docLink.Title);
            }            
                        
            wrapperObj.mapIdTitle =mapIdTitle;
            return wrapperObj;
        }
        @AuraEnabled(cacheable=true)
    	public static List<ListPreviewWrapper> getAllFilesByRecordId(String recordId) {
            // Get record file IDs        
            List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
                      
            List<ID> fileIDs = new List<ID>();
			List<ListPreviewWrapper> listWrapper = new List<ListPreviewWrapper>();
            
            
            for (ContentDocumentLink docLink : files) {
                fileIDs.add(docLink.ContentDocumentId);
            }
     
            List<ContentVersion> docs = [SELECT Id,ContentDocumentId, FileExtension, Title 
                FROM ContentVersion WHERE ContentDocumentId IN : fileIDs AND FileType != 'SNOTE']; // excluding notes from content version
            Map<ID, String> mapIdTitle = new Map<ID, String>();
            for (ContentVersion docLink : docs) {
                mapIdTitle.put(docLink.Id, docLink.Title);
                
                //option to download files
                  ListPreviewWrapper wrapperObj = new ListPreviewWrapper(); 
                    wrapperObj.baseUrl = URL.getSalesforceBaseUrl().toExternalForm(); // to fetch base url
                    wrapperObj.ContentDocumentId = docLink.ContentDocumentId;
                    wrapperObj.contentTitle =docLink.Title;
                    listWrapper.add(wrapperObj);
            }
            
            /* commented this code since client needed download option instead of preview
            List<ContentDistribution> conDist = [SELECT ContentVersionId, DistributionPublicUrl, ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId IN :mapIdTitle.keySet()];
            for (ContentDistribution cd : conDist) {
                
                if(mapIdTitle.containsKey(cd.ContentVersionId)){
                    ListPreviewWrapper wrapperObj = new ListPreviewWrapper(); 
                    wrapperObj.baseUrl = URL.getSalesforceBaseUrl().toExternalForm(); // to fetch base url
                    wrapperObj.contentVersionId = cd.ContentVersionId;
                    wrapperObj.publicContentUrl = cd.DistributionPublicUrl;
                    wrapperObj.contentTitle = mapIdTitle.get(cd.ContentVersionId);
                    listWrapper.add(wrapperObj);
                }
            }
            */
           system.debug('listWrapper=='+ listWrapper);
            return listWrapper;
        }

        //wrapper class
/**
* @description     SupportRequestWrapper
*/
public without sharing class ListPreviewWrapper{
    /**
* @description     easyPay
*/
    @AuraEnabled
    public Map<ID, String> mapIdTitle {get;set;}
    /**
* @description     supportCase
*/
    @AuraEnabled
    public String baseUrl {get;set;} 
    
    @AuraEnabled
    public String contentVersionId {get;set;} 
    
    @AuraEnabled
    public String contentTitle {get;set;}
    
    @AuraEnabled
    public String publicContentUrl {get;set;} 
    
    @AuraEnabled
    public String ContentDocumentId {get;set;} 
    
    }
}