/* Component Name     :    aHFC_dashboardFaq
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
import AHFC_Topic_Id_Statements from "@salesforce/label/c.AHFC_Topic_Id_Statements";

import AHFC_Topic_Id_Payment from "@salesforce/label/c.AHFC_Topic_Id_Payment";
import AHFC_Topic_Id_Service_Contracts from "@salesforce/label/c.AHFC_Topic_Id_Service_Contracts";
import AHFC_Topic_Id_Leasing from "@salesforce/label/c.AHFC_Topic_Id_Leasing";
import AHFC_Topic_Id_Financing from "@salesforce/label/c.AHFC_Topic_Id_Financing";
import AHFC_Topic_Id_End_Of_Lease from "@salesforce/label/c.AHFC_Topic_Id_End_Of_Lease";
import AHFC_Topic_Id_Credit_Preapproval from "@salesforce/label/c.AHFC_Topic_Id_Credit_Preapproval";
import AHFC_Topic_Id_Account_Management from "@salesforce/label/c.AHFC_Topic_Id_Account_Management";
import AHFC_FAQ_RecordSelectMode from "@salesforce/label/c.AHFC_FAQ_RecordSelectMode";
import AHFC_Topic_Id_PayoffPurchase from "@salesforce/label/c.AHFC_Topic_Id_PayoffPurchase";
import { fireAdobeEvent } from "c/aHFC_adobeServices";


import getFaqList from "@salesforce/apex/AHFC_FAQController.setFaqListBasedOnTopics"

export default class AHFC_dashboardFaq extends NavigationMixin(LightningElement) {

    @track faqListToDisplay = [];
    @api pageName;
    @track URLTORedirect ;


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
        var pageNamevalue = this.pageName;
        var recSelMode = AHFC_FAQ_RecordSelectMode; // 'Partial';
        console.log('Page '+pageNamevalue);
        getFaqList({
            pageName : pageNamevalue,
            recordSelectionMode : recSelMode
        }).then((result)=>{
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


    navigateToArticle(event){

        var origin = window.location.origin;

        var urlToNavigate = origin+'/s/article/'+event.target.dataset.id;
        console.log('urlToNavigate : '+urlToNavigate);
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 

    }


    NavigateToViewAllHelpCenter() {

        console.log('Origin : '+window.location.origin);

        var origin = window.location.origin;

        var URLpart1 = origin+'/s/';
        var type = this.pageName;
        let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": type+":Hyperlink:View All FAQS",
			"Event_Metadata.action_category": "FAQs Tile",
			"Page.page_name": type,
		};
		fireAdobeEvent(adobedata, 'click-event');

        switch (type) {
            case "Statements":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_Statements;
            break;

            case "Payments":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_Payment;
            break;

            case "Service_Contracts":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_Service_Contracts;
            break;

            case "Leasing":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_Leasing;
            break;

            case "Financing":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_Financing;
            break;

            case "End_Of_Term":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_End_Of_Lease;
            break;

            case "Credit_Pre_Approval":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_Credit_Preapproval;
            break;

            case "Account_Management":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_Account_Management;
            break;

            case "Payoff_Purchase":
                this.URLTORedirect = URLpart1+AHFC_Topic_Id_PayoffPurchase;
            break;

        }

        console.log('URL TO REDIRECT :'+this.URLTORedirect);

        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: this.URLTORedirect
            }
        }); 
    }

    

}