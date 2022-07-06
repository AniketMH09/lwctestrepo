/* Component Name     :    aHFC_helpCenterSearchResults
    * Description        :    This is LWC for Help center articles based on the data category 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aswin Jose                10/08/2021                 Created 
    */


import { LightningElement, track,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getArticlesList from "@salesforce/apex/AHFC_FAQController.getArticlesList"

export default class AHFC_helpCenterSearchResults extends NavigationMixin(LightningElement) {

    @api CategoryDataTitle = 'Search Results';
    @api searchResultsContent = 'Payments';
    @track refreshPagination;
    @track articlesToDisplay;

    connectedCallback(){
        this.getArticlesList();
    }
    
    getArticlesList(){
        var categoryDataName = 'Payments';//this.CategoryDataTitle;
        console.log('categoryDataName :  '+categoryDataName);
        getArticlesList({
            dataCategoryName : categoryDataName
        }).then((result)=>{
            console.log('RESULT** help center'+result);
            if(result !=null ){
                this.articlesToDisplay = JSON.parse(JSON.stringify(result));
                this.refreshPagination = false;
            }else{
                console.log('No Articles found!!');
            }

        }).catch((error)=>{
            this.error = error;
            console.log('Exception ** ',error);
          })
    }

    navigateToArticle(event){
        this.knowledgeId = event.target.dataset.id; 
        console.log('knowledgeId : '+this.knowledgeId);
        this.knowledgeFlag = true;
        this.articleFlag = false;
        this.CategoryDataTitle = 'Payments';
        console.log('cat : '+this.CategoryDataTitle);

    }

    navigateToViewAll(){
        console.log('View All button clicked');
    }
}