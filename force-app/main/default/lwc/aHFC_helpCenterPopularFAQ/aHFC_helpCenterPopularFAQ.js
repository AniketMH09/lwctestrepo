/* Component Name     :    aHFC_helpCenterPopularFAQ
    * Description        :    This is LWC for FAQ for Transactions Page. 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aniket                     20/05/2021              Created 
    */

import { LightningElement, track,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import AHFC_DashboardFaq_Label from "@salesforce/label/c.AHFC_DashboardFaq_Label";
import AHFC_helpCenter_URL from "@salesforce/label/c.AHFC_helpCenter_URL";
import AHFC_Topic_Id_Statements from "@salesforce/label/c.AHFC_Topic_Id_Statements";

import AHFC_Topic_Id_Payment from "@salesforce/label/c.AHFC_Topic_Id_Payment";
import AHFC_Topic_Id_Service_Contracts from "@salesforce/label/c.AHFC_Topic_Id_Service_Contracts";
import AHFC_Topic_Id_Leasing from "@salesforce/label/c.AHFC_Topic_Id_Leasing";
import AHFC_Topic_Id_Financing from "@salesforce/label/c.AHFC_Topic_Id_Financing";
import AHFC_Topic_Id_End_Of_Lease from "@salesforce/label/c.AHFC_Topic_Id_End_Of_Lease";
import AHFC_Topic_Id_Credit_Preapproval from "@salesforce/label/c.AHFC_Topic_Id_Credit_Preapproval";
import AHFC_Topic_Id_Account_Management from "@salesforce/label/c.AHFC_Topic_Id_Account_Management";
import AHFC_FAQ_RecordSelectMode from "@salesforce/label/c.AHFC_FAQ_RecordSelectMode";
import AHFC_FAQ_ArticleUrl from "@salesforce/label/c.AHFC_FAQ_ArticleUrl";

import getFaqList from "@salesforce/apex/AHFC_FAQController.setFaqListBasedOnTopicsViewCount";
import setDataCategoryBasedOnFAQ from "@salesforce/apex/AHFC_FAQController.setDataCategoryBasedOnFAQ"; 

export default class AHFC_helpCenterPopularFAQ extends NavigationMixin(LightningElement) {

    @track faqListToDisplay = [];
    @api pageName;
    @track URLTORedirect ;
    @track knowledgeId;
    @track faqDataCategory;


    @track viewAllButtonLabel = AHFC_DashboardFaq_Label;
    
    connectedCallback(){
        this.getFaqList();
    }

    onFaqAccordionClick(event) {
        const open = "slds-accordion__section slds-is-open";
        const close = "slds-accordion__section";
        console.log('accordion click : '+event.target.dataset.keyno);
        
        for (let i = 0; i < this.faqListToDisplay.length; i++) {

            if (this.faqListToDisplay[i].IdValue === event.target.dataset.keyno) {
                this.faqListToDisplay[i].isOpened = !this.faqListToDisplay[i].isOpened;
                this.faqListToDisplay[i].className = (this.faqListToDisplay[i].className === open) ? close : open;
                
            } else {
                this.faqListToDisplay[i].isOpened = false;
                this.faqListToDisplay[i].className =  close;
            }
        }
       
    }

    //Added By Aswin Jose for US:5584
    getFaqList(){

        getFaqList().then((result)=>{
            console.log('RESULT** FAQ'+result);
            if(result !=null ){
                this.faqListToDisplay = JSON.parse(JSON.stringify(result));
            }else{
                console.log('No Articles found!!');
            }

        }).catch((error)=>{
            this.error = error;
            console.log('Exception ** ',error);
          })
    }

   get NavigateToViewAllHelpCenter() {

        var URLpart1 = AHFC_helpCenter_URL;
        var type = 'Payments';//this.pageName;

        switch (type) {
            case "Statements":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_Statements;
            break;

            case "Payments":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_Payment;
            break;

            case "Service Contracts":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_Service_Contracts;
            break;

            case "Leasing":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_Leasing;
            break;

            case "Financing":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_Financing;
            break;

            case "End Of Lease":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_End_Of_Lease;
            break;

            case "Credit Pre-Approval":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_Credit_Preapproval;
            break;

            case "Account Management":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_Account_Management;
            break;

        }

        console.log('URL TO REDIRECT '+this.URLTORedirect);

        return this.URLTORedirect;
    }

   /* navigateToArticle(event){

        var urlToNavigate = AHFC_FAQ_ArticleUrl+event.target.dataset.id;
        console.log('urlToNavigate : '+urlToNavigate);
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 

    } */

    navigateToArticle(event){
        this.knowledgeId = event.target.dataset.id; 
        console.log('knowledgeId : '+this.knowledgeId);
        this.setDataCategoryBasedOnFAQ();

       /* this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'singlearticle',
            },
            state: {
                knowledgeIdFromNavigation: this.knowledgeId,
                category : this.faqDataCategory
            }
            
        }); */

    }

    setDataCategoryBasedOnFAQ(){
        setDataCategoryBasedOnFAQ({
            faqIdValue : this.knowledgeId
        }).then((result)=>{
            console.log('RESULT** FAQ data Category : '+result);
            if(result !=null ){
                this.faqDataCategory = JSON.parse(JSON.stringify(result));
                this.navigateToSingleArticle();
            }else{
                console.log('No Articles found!!');
            }

        }).catch((error)=>{
            this.error = error;
            console.log('Exception ** ',error);
          })


    }

    navigateToSingleArticle(){

        console.log('FAQ Article');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'singlearticle',
            },
            state: {
                knowledgeIdFromNavigation: this.knowledgeId,
                category : this.faqDataCategory
            }
            
        });
    }


}