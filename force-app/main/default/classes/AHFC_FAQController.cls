/*@Apex Class 	    :   AHFC_FAQController
* @description      :   This class is used to get the FAQ Articles 
* @created By       :   Aswin
* @created on       :   26/7/2021
* @modified on		:	26/7/2021
* @modified By		:	Aswin Jose
* @modification Log	:   
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Aswin Jose                26/7/2021                Created for US 5584
* Aswin Jose                16/8/2021                updated for US 5404
*********************************************************************************/

public without sharing class AHFC_FAQController {
    
/*@method 	        :   getFaqList
* @description      :   This method will get the FAQ data
* @developer 		: 	Aswin
* @date				:	26-Jul-2021
* @params			:	
*********************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<FAQ__DataCategorySelection> getFaqList(){
        List<FAQ__DataCategorySelection> faqList = new List<FAQ__DataCategorySelection>();
        try{
            faqList = [SELECT ParentId, Id, DataCategoryName, DataCategoryGroupName, Parent.Title, Parent.Summary,parent.UrlName, 
                       Parent.Details__c, Parent.PublishStatus,createdDate,Parent.ArticleTotalViewCount, parent.Is_Video_Enabled_Content__c  
                       FROM FAQ__DataCategorySelection WHERE Parent.PublishStatus = 'Online' and ParentId !=null
                       ORDER BY createdDate DESC];    
        }
        Catch(Exception ex){
            System.debug('Exception ::'+ex.getMessage()+''+ex.getLineNumber());
        }
 
        return faqList;
    }
    
/*@method 	        :   setFaqListBasedOnTopics
* @description      :   This method will set the wrapper with the list of FAQ
* @developer 		: 	Aswin
* @date				:	29-Jul-2021
* @params			:	pageName and recordSelectionMode
*********************************************************************************/    
    @AuraEnabled(cacheable=true)
    public static List<FAQWrapper> setFaqListBasedOnTopics(String pageName,String recordSelectionMode){
        system.debug('pageName-->'+pageName);
        system.debug('recordSelectionMode-->'+recordSelectionMode);
        List<FAQWrapper> faqWrapperList = new List<FAQWrapper>();
        Integer counter = 1;
        Boolean readMoreFlag = false;
        String descriptionSplit;
        String labelValue = System.Label.AHFC_FAQ_RecordCount;
        Integer counterCheck = Integer.valueOf(labelValue);
        try{
            List<FAQ__DataCategorySelection> faqList = getFaqList();
            system.debug('faqListsss-->'+faqList);
            for(FAQ__DataCategorySelection faqData : faqList){
                FAQWrapper faq = new FAQWrapper();
                if(recordSelectionMode == 'All'){
                    if(faqData.DataCategoryName ==  pageName){                       	
                        	readMoreFlag = checkCharacterCount(faqData.Parent.Details__c.stripHtmlTags()); //stripHtmlTags()
                        
                        	if(readMoreFlag){
                               	descriptionSplit = faqData.Parent.Details__c.stripHtmlTags();                               	
                                faq.description = descriptionSplit.substring(0, 280)+'...';
                            }else{
                                faq.description = faqData.Parent.Details__c.stripHtmlTags();                                
                                readMoreFlag = true;
                            }
                        
                            faq.IdValue = faqData.Id;
                            faq.className = 'slds-accordion__section';
                            faq.isOpened = false;
                            faq.header = faqData.Parent.Title;
                            faq.urlName = faqData.parent.UrlName;
                        	faq.faqReadMoreFlag = readMoreFlag;
                        	faq.knowledgeId = faqData.ParentId;
                            faqWrapperList.add(faq);
                        }
                }
                else{
                    if(counter < counterCheck){
                        system.debug('insidecounter');
                        system.debug('DataCategoryName-->'+faqData.DataCategoryName);                        
                        if(faqData.DataCategoryName ==  pageName){
                            readMoreFlag = checkCharacterCount(faqData.Parent.Details__c.stripHtmlTags());
                            counter = counter + 1;
                            
                            if(readMoreFlag){
                               // descriptionSplit = faqData.Parent.Details__c.stripHtmlTags();
                               descriptionSplit = faqData.Parent.Details__c;
                                faq.description = descriptionSplit.substring(0, 280)+'...';
                            }else{
                                //faq.description = faqData.Parent.Details__c.stripHtmlTags();
                                faq.description = faqData.Parent.Details__c;
                                readMoreFlag = true;
                            }
                            
                            faq.IdValue = faqData.Id;
                            faq.className = 'slds-accordion__section';
                            faq.isOpened = false;
                            faq.header = faqData.Parent.Title;
                            faq.urlName = faqData.parent.UrlName;
                            faq.faqReadMoreFlag = readMoreFlag;
                            faq.knowledgeId = faqData.ParentId;
                            faqWrapperList.add(faq);
                        }
                    }   
                }
                
                
            }
        }
        Catch(Exception ex){
            System.debug('Exception ::'+ex.getMessage()+':'+ex.getLineNumber());
        }
        system.debug('faqWrapperListss-->'+faqWrapperList);
        return faqWrapperList;
    }
    
/*@method 	        :   checkCharacterCount
* @description      :   This method will get the checkCharacterCount
* @developer 		: 	Aswin
* @date				:	29-Jul-2021
* @params			:	FAQ description
*********************************************************************************/
    @AuraEnabled(cacheable=true)
    public static Boolean checkCharacterCount(String description){
        system.debug('descriptionsss-->'+description);
        Boolean readMore = false;
        /*if(description.length() > 280){
            readMore = true;
        }else{
            readMore = false;
        }*/
        if(description.contains('\n'))
        {
         readMore = true;
        }else{
            readMore = false;
        }
        
        return readMore;
    }
    
    
/*@method 	        :   getArticlesList
* @description      :   This method will get the articles for Help center
* @developer 		: 	Aswin
* @date				:	10-Aug-2021
* @params			:	data category name
*********************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<FAQWrapper> getArticlesList(String dataCategoryName){
        List<FAQWrapper> faqWrapperList = new List<FAQWrapper>();
        Boolean readMoreFlag = false;
        String descriptionSplit;
        
        List<FAQ__DataCategorySelection> faqList = getFaqList();
        
        for(FAQ__DataCategorySelection faqData : faqList){
			FAQWrapper faq = new FAQWrapper();
            if(faqData.DataCategoryName ==  dataCategoryName){
                
                readMoreFlag = checkCharacterCount(faqData.Parent.Details__c.stripHtmlTags());
                
                if(faqData.Parent.Is_Video_Enabled_Content__c){
                    faq.isVideoContentAvailable = true;
                }
                
                
                if(readMoreFlag){
                    descriptionSplit = faqData.Parent.Details__c.stripHtmlTags();
                    faq.description = descriptionSplit.substring(0, 280)+'...';
                }else{
                    faq.description = faqData.Parent.Details__c.stripHtmlTags();
                }

                faq.IdValue = faqData.Id;
                faq.className = 'slds-accordion__section';
                faq.isOpened = false;
                faq.header = faqData.Parent.Title;
                faq.urlName = faqData.parent.UrlName;
                faq.faqReadMoreFlag = readMoreFlag;
                faq.knowledgeId = faqData.ParentId;
                faqWrapperList.add(faq);      
            }
            
        }
        System.debug('faqWrapperList Help center : '+faqWrapperList);
        
        return faqWrapperList;
        
    }
    
    /*@method 	        :   getSingleArticle
* @description      :   This method will get the clicked article
* @developer 		: 	Aswin
* @date				:	10-Aug-2021
* @params			:	data category name
*********************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<FAQWrapper> getSingleArticle(String dataCategoryName,String articleIdvalue){
        List<FAQWrapper> faqWrapperList = new List<FAQWrapper>();
        
        List<FAQ__DataCategorySelection> faqList = getFaqList();
        
        for(FAQ__DataCategorySelection faqData : faqList){
            FAQWrapper faq = new FAQWrapper();

            if(faqData.ParentId ==  articleIdvalue){

                faq.IdValue = faqData.Id;
                faq.className = 'slds-accordion__section';
                faq.isOpened = false;
                faq.header = faqData.Parent.Title;
                faq.urlName = faqData.parent.UrlName;
                faq.description = faqData.Parent.Details__c;
                faq.knowledgeId = faqData.ParentId;
                faqWrapperList.add(faq);
                
            }
            
        }
        System.debug('faqWrapperList Help center single Article : '+faqWrapperList);
        
        return faqWrapperList;
        
    }
    
    
        
 /*@method 	        :   setFaqListBasedOnTopicsViewCount
* @description      :   This method will set the wrapper with the list of FAQ
* @developer 		: 	Aswin
* @date				:	29-Jul-2021
* @params			:	pageName and recordSelectionMode
*********************************************************************************/    
    @AuraEnabled(cacheable=true)
    public static List<FAQWrapper> setFaqListBasedOnTopicsViewCount(){
        List<FAQWrapper> faqWrapperList = new List<FAQWrapper>();
        Boolean readMoreFlag = false;
        String descriptionSplit;
        Integer counter = 1;
        String labelValue = '4';//System.Label.AHFC_FAQ_RecordCount;
        Integer counterCheck = Integer.valueOf(labelValue);
        try{
            List<FAQ__kav> faqList = new List<FAQ__kav>();
            faqList = [SELECT Id, Title, Summary,UrlName,Details__c, PublishStatus,createdDate,ArticleTotalViewCount  
                       FROM FAQ__kav
                       ORDER BY ArticleTotalViewCount DESC]; 
            
            for(FAQ__kav faqData : faqList){
                if(counter < counterCheck){
                    counter = counter + 1;
                    FAQWrapper faq = new FAQWrapper();                       
                    readMoreFlag = checkCharacterCount(faqData.Details__c.stripHtmlTags());
                    
                    if(readMoreFlag){
                        descriptionSplit = faqData.Details__c.stripHtmlTags();
                        faq.description = descriptionSplit.substring(0, 280)+'...';
                        
                    }else{
                        faq.description = faqData.Details__c;
                    }
                    
                    faq.IdValue = faqData.Id;
                    faq.className = 'slds-accordion__section';
                    faq.isOpened = false;
                    faq.header = faqData.Title;
                    faq.urlName = faqData.UrlName;
                    faq.faqReadMoreFlag = readMoreFlag;
                    faqWrapperList.add(faq);
                }
            }
        }   
        Catch(Exception ex){
            System.debug('Exception ::'+ex.getMessage()+':'+ex.getLineNumber());
        }

        return faqWrapperList;
    }
    
    @AuraEnabled(cacheable=true)
    public static String setDataCategoryBasedOnFAQ(String faqIdValue){
        
        String dataCategory = '';
        List<FAQ__DataCategorySelection> faqList = new List<FAQ__DataCategorySelection>();
        faqList = [SELECT ParentId, Id, DataCategoryName, DataCategoryGroupName, Parent.Title, Parent.Summary,parent.UrlName, 
                       Parent.Details__c, Parent.PublishStatus,createdDate,Parent.ArticleTotalViewCount, parent.Is_Video_Enabled_Content__c  
                       FROM FAQ__DataCategorySelection WHERE Parent.PublishStatus = 'Online' and ParentId !=null
                       ORDER BY createdDate DESC];
        
        for(FAQ__DataCategorySelection faqData : faqList){
            if(faqData.ParentId == faqIdValue){
                system.debug('FAQ id Value  : '+faqData.ParentId);
                dataCategory = faqData.DataCategoryName;
            }
        }
            
        return dataCategory;
    }

    
    //Wrapper Class to send the data to LWC
    public without sharing class FAQWrapper{
        
        @AuraEnabled public String className;
        @AuraEnabled public Boolean isOpened;
        @AuraEnabled public String header;
        @AuraEnabled public String description;
        @AuraEnabled public Id IdValue;
        @AuraEnabled public String urlName;
        @AuraEnabled public Boolean faqReadMoreFlag;
        @AuraEnabled public Id knowledgeId;
        @AuraEnabled public Boolean isVideoContentAvailable;
    }
    

}