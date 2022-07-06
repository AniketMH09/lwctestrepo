/*=====================================================================
* (c) 2018 Appirio - A Wipro Company, Inc
* Name: AHFC_ArticlePrintableApexController.apex
* Description: Apex class for AHFC_ArticlePrintableVF
* Created Date: 21st Nov 2018
* Created By: Naveen Pilla
*  ===================================================================== */

public without sharing class AHFC_ArticlePrintableApexController {
    
    
    public string kaID {get; set;}
    public FAQ__kav details{get;set;}
    public String RecordTypeName{get;set;}
    
    
    
    public AHFC_ArticlePrintableApexController()
    {
        //this.KavDetails = (FAQ__kav)controller.getRecord();
        
        //Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=AccountReport.pdf');
        // urlName = ApexPages.currentPage().getHeaders().get('Host');
        // system.debug('urlName'+urlName);
        kaID = System.currentPageReference().getParameters().get('kid');
        system.debug('kaID'+kaID);
        
        details = [select id,KnowledgeArticleId,validationStatus,Title,UrlName,ArticleNumber,Summary,Details__c,RecordType.Name 
                   from FAQ__kav where id=:kaID];
        
        RecordTypeName = details.RecordType.Name;
        
    }
    
}