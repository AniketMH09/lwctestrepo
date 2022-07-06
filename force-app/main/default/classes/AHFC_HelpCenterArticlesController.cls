/*@Apex Class 	    :   AHFC_HelpCenterArticlesController
* @description      :   This class is used to get the Help Center Articles 
* @created By       :   Aswin
* @created on       :   10/8/2021
* @modified on		:	10/8/2021
* @modified By		:	Aswin Jose
* @modification Log	:   
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Aswin Jose                10/8/2021                Created for US 5584
*********************************************************************************/

public class AHFC_HelpCenterArticlesController {
    
/*@method 	        :   getArticlesList
* @description      :   This method will get the FAQ data
* @developer 		: 	Aswin
* @date				:	26-Jul-2021
* @params			:	
*********************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<FAQ__DataCategorySelection> getArticlesList(){
        List<FAQ__DataCategorySelection> faqList = new List<FAQ__DataCategorySelection>();
        try{
            faqList = [SELECT ParentId, Id, DataCategoryName, DataCategoryGroupName, Parent.Title, Parent.Summary,parent.UrlName, 
                       Parent.Details__c, Parent.PublishStatus,createdDate 
                       FROM FAQ__DataCategorySelection WHERE Parent.PublishStatus = 'Online' and ParentId !=null
                       ORDER BY createdDate DESC];    
        }
        Catch(Exception ex){
            System.debug('Exception ::'+ex.getMessage()+''+ex.getLineNumber());
        }
 
        return faqList;
    }

}