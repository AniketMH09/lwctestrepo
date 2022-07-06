/* Component Name     :    aHFC_helpCenterDataCategoryArticles
    * Description        :    This is LWC for Help center articles based on the data category 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aswin Jose                10/08/2021                 Created 
    */


import { LightningElement, track,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getArticlesList from "@salesforce/apex/AHFC_FAQController.getArticlesList";
import videoIcon from "@salesforce/resourceUrl/AHFC_HELP_Center_VideoIcon";
import AHFC_FAQ_ArticleUrl from "@salesforce/label/c.AHFC_FAQ_ArticleUrl";


export default class AHFC_helpCenterDataCategoryArticles extends NavigationMixin(LightningElement) {

    @api CategoryDataTitle = 'Payments';
    @track articlesToDisplay;
    @track knowledgeId = '';
    @track knowledgeFlag = false;
    @track articleFlag = true;
    @track refreshPagination =true;
    @track articledataToDisplayOnPage = [];
    @track testDatavariableList = '';
    @track templateViewList;
    @track categoryDataName;
    @track backButtonLabel;
    @track tableData = [];

    connectedCallback(){
        this.CategoryValueBasedOnURL();
        this.backButtonBasedOnDataCategory();
        this.getArticlesList();
        this.knowledgeFlag = false;
        
    }

    getArticlesList(){

        getArticlesList({
            dataCategoryName : this.categoryDataName
        }).then((result)=>{
            console.log('RESULT** help center'+JSON.stringify(result));
            if(result !=null ){
                
                this.articlesToDisplay = JSON.parse(JSON.stringify(result));
                this.staticData =JSON.parse(JSON.stringify(this.articlesToDisplay));
                this.totalRecords = JSON.stringify(this.staticData);
                this.refreshPagination = false;
                this.recordCreationTest();

            }else{
                console.log('No Articles found!!');
            }

        }).catch((error)=>{
            this.error = error;
            console.log('Exception ** ',error);
          })
    }


    CategoryValueBasedOnURL(){

         var textFromURL = window.location.href;
 
        if(textFromURL.includes('account-management')){
            this.categoryDataName = 'Account_Management';
        }else if(textFromURL.includes('payments')){
            this.categoryDataName = 'Payments';
        }else if(textFromURL.includes('statements')){
            this.categoryDataName = 'Statements';
        }else if(textFromURL.includes('end-of-term')){
            this.categoryDataName = 'End_Of_Term';
        }else if(textFromURL.includes('service-contracts')){
            this.categoryDataName = 'Service_Contracts';
        }else if(textFromURL.includes('leasing')){
            this.categoryDataName = 'Leasing';
        }else if(textFromURL.includes('payoff-purchase')){
            this.categoryDataName = 'Payoff_Purchase';
        }else if(textFromURL.includes('credit-preapproval')){
            this.categoryDataName = 'Credit_Pre_Approval';
        }else if(textFromURL.includes('financing')){
            this.categoryDataName = 'Financing';
        }else if(textFromURL.includes('title')){
            this.categoryDataName = 'Title';
        }
        
    }

    backButtonBasedOnDataCategory(){

        var textFromURL = window.location.href;

       if(textFromURL.includes('account-management')){
           this.backButtonLabel = 'Account Management';
       }else if(textFromURL.includes('payments')){
           this.backButtonLabel = 'Payments';
       }else if(textFromURL.includes('statements')){
           this.backButtonLabel = 'Statements';
       }else if(textFromURL.includes('end-of-term')){
           this.backButtonLabel = 'End Of Term';
       }else if(textFromURL.includes('service-contracts')){
           this.backButtonLabel = 'Service Contracts';
       }else if(textFromURL.includes('leasing')){
           this.backButtonLabel = 'Leasing';
       }else if(textFromURL.includes('payoff-purchase')){
           this.backButtonLabel = 'Payoff Purchase';
       }else if(textFromURL.includes('credit-preapproval')){
           this.backButtonLabel = 'Credit Pre Approval';
       }else if(textFromURL.includes('financing')){
           this.backButtonLabel = 'Financing';
       }else if(textFromURL.includes('title')){
           this.backButtonLabel = 'Title';
       }
       
   }

    recordCreationTest(){ 
       
        
        this.staticData =JSON.parse(JSON.stringify(this.articlesToDisplay));
        this.totalRecords = JSON.stringify(this.staticData);
        this.refreshPagination = false;

        this.testDatavariableList = JSON.stringify(this.articlesToDisplay);
        this.templateViewList = JSON.parse(this.totalRecords);

    }

    
    pageChange(event) {
        let pageItems = JSON.parse(event.detail);
        this.templateViewList.length = 0;
        this.templateViewList = this.templateViewList.concat(pageItems);

    }

    get videoIconImage() {
        return videoIcon;
    }
    

    navigateToArticle1(event){

        var urlToNavigate = AHFC_FAQ_ArticleUrl+event.target.dataset.id;
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 

    }

    navigateToArticle(event){
        this.knowledgeId = event.target.dataset.id; 
        this.knowledgeFlag = true;
        this.articleFlag = false;

        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'singlearticle',
            },
            state: {
                knowledgeIdFromNavigation: this.knowledgeId,
                category : this.backButtonLabel,
                showIcon : true
            }
            
        });

    }


}