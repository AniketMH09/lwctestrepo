/* Component Name     :    aHFC_helpCenterSingleArticle
    * Description        :    This is LWC for Help center articles based on the data category 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aswin Jose                10/08/2021                 Created 
    */


import { LightningElement, track,api,wire } from 'lwc';
import {CurrentPageReference, NavigationMixin } from 'lightning/navigation';


import getSingleArticle from "@salesforce/apex/AHFC_FAQController.getSingleArticle"

export default class AHFC_helpCenterSingleArticle extends NavigationMixin(LightningElement) {
    @api categoryDataTitle;
    @track articleIdvalue = 'ka00U000000JqJEQA0';
    @track articlesToDisplay;
    @track backButtonLabel;
    @api knowledgeId;
    @api knowledgeIdFromNavigation;
    @api category;

    @track booleanShowIcon = true;
    @track showIcon;

    currentPageReference = null;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.currentPageReference= currentPageReference;
        console.log('curr ref',this.currentPageReference);
        console.log('kav',this.currentPageReference.state.knowledgeIdFromNavigation);
        this.knowledgeId = this.currentPageReference.state.knowledgeIdFromNavigation;
        this.category = this.currentPageReference.state.category;
        this.booleanShowIcon = this.currentPageReference.state.showIcon;
        console.log('kav 2',this.knowledgeId);
        console.log('show icon',this.booleanShowIcon);
 }


    connectedCallback(){
        this.getArticle();
        this.backButtonBasedOnDataCategory();
        this.setShowIcon();
    }

    setShowIcon(){
        if(this.booleanShowIcon === 'false'){
            this.showIcon = false;
            console.log('SHOW Icon false');
        }else{
            this.showIcon = true;
            console.log('SHOW Icon true');
        }
    }

    getArticle(){
        var categoryDataName = 'Payments';//this.CategoryDataTitle;
        console.log('categoryDataName :  '+categoryDataName);
        getSingleArticle({
            dataCategoryName : categoryDataName,
            articleIdvalue : this.knowledgeId
        }).then((result)=>{
            console.log('RESULT** help center single'+result);
            if(result !=null ){
                this.articlesToDisplay = JSON.parse(JSON.stringify(result));
            }else{
                console.log('No Articles found!!');
            }

        }).catch((error)=>{
            this.error = error;
            console.log('Exception ** ',error);
          })
    }


    downloadData(){
        console.log('download Data button clicked');
        window.print();
    }

    thumbsUpLogic(){
        console.log('thumbsUpLogic');
        var iconTag = this.template.querySelector('.ahfc-thumbsUp');
        if(iconTag){
            this.template.querySelector('.ahfc-thumbsUp').className='ahfc-thumbsUp-Click';
            //this.template.querySelector('.ahfc-thumbsDown').removeclass('ahfc-thumbsDown-Click');
        }        
    }

    thumbsDownLogic(){
        console.log('thumbsDownLogic');
        var iconTag = this.template.querySelector('.ahfc-thumbsDown');
        if(iconTag){
            this.template.querySelector('.ahfc-thumbsDown').className='ahfc-thumbsDown-Click';
           // this.template.querySelector('.ahfc-thumbsUp').removeclass('ahfc-thumbsUp-Click');
        }        
    }

    backButtonBasedOnDataCategory(){

        var textFromURL = window.location.href;
        console.log('textFromURL1  :'+textFromURL);

       if(textFromURL.includes('account-management')){
           this.backButtonLabel = 'Account Management';
       }else if(textFromURL.includes('payments')){
           this.backButtonLabel = 'Payments';
       }else if(textFromURL.includes('statements')){
           this.backButtonLabel = 'Statements';
       }else if(textFromURL.includes('end-of-lease')){
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
       }else if(textFromURL.includes('Title')){
           this.backButtonLabel = 'Title';
       }
       
   }
}