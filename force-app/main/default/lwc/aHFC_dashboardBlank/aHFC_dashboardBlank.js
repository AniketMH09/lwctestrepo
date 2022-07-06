/* Component Name        :    AHFC_dashboardBlank
    * Description        :    This is LWC for Blank State Dashboard
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Akash                      14/07/2021              Created
*/



import { LightningElement, track, wire } from 'lwc';
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import FORM_FACTOR from "@salesforce/client/formFactor";
import { CurrentPageReference } from "lightning/navigation";

import hondaLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import acuraLogo from "@salesforce/resourceUrl/AHFC_Acura_Header_Logo";
import hondaCar from "@salesforce/resourceUrl/AHFC_Honda_Header_Car";

import AHFC_static_Image_Marine from "@salesforce/resourceUrl/AHFC_static_Image_Marine";
import AHFC_static_Image_Powerequipment from "@salesforce/resourceUrl/AHFC_static_Image_Powerequipment";
import AHFC_static_Image_Non_honda_acura from "@salesforce/resourceUrl/AHFC_static_Image_Non_honda_acura";
import AHFC_static_Image_Non_available from "@salesforce/resourceUrl/AHFC_static_Image_Non_available";
import blankDashboardMarketingTile from "@salesforce/resourceUrl/AHFC_BlankDashboard_MarketingTile";
import { fireAdobeEvent } from "c/aHFC_adobeServices";


import getServiceAccountDetails from "@salesforce/apex/AHFC_DashboardController.getServiceAccountdetails";
import handleGetAccountInfo from "@salesforce/apex/AHFC_GetAccountInfoIntergationHandler.handleGetAccountInfo";
import getEconfigResponse from "@salesforce/apex/AHFC_EConfigIntegrationHandler.getEconfigResponse";

import { refreshApex } from '@salesforce/apex';
import { labels } from "c/aHFC_dashboardConstantsUtil";
import { fireEvent } from 'c/pubsub';
import { NavigationMixin } from "lightning/navigation";

export default class AHFC_dashboardBlank extends NavigationMixin(LightningElement) {

    @track labels = labels;
    @track pageName = 'Statements';

    @wire(CurrentPageReference) pageRef;

    onAddFinAcctClick() {

        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Blank Dashboard:Button:Add Finance Account",
            "Event_Metadata.action_category": "",
            "Page.page_name": "Blank Dashboard / No Finance Account",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('addProductFromBlankDashboard', 'true');
        //Navigating to Add Finance Account - Added by Akash Solanki as Part of 4373
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'add-a-finance-account'
            },
        });
    }
    @track mobileSections = [

        {
            id: "0",
            class: "slds-accordion__section",
            contentClass: "slds-accordion__content",
            isOpened: false,
            header: this.labels.DashboardFaq,
            isFaqs: true
        }

    ];

    //Toggle Accordions in Mobile
    onMobileSectionsClick(event) {
        const open = "slds-accordion__section slds-is-open";
        const close = "slds-accordion__section";
        if (event.currentTarget.dataset.keyno) {
            this.mobileSections[event.target.dataset.keyno].isOpened = !this
                .mobileSections[event.target.dataset.keyno].isOpened;
            this.mobileSections[event.target.dataset.keyno].class =
                this.mobileSections[event.target.dataset.keyno].class === open
                    ? close
                    : open;
            this.mobileSections[event.target.dataset.keyno].contentClass = this
                .mobileSections[event.target.dataset.keyno].isOpened
                ? "slds-accordion__content mobile-accordion-content"
                : "slds-accordion__content";
        }
    }


    get blankDashboardMarketingTileURL() {
        return blankDashboardMarketingTile;
    }


    connectedCallback() {

        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
        let adobedata = {
            "Page.site_section": "Blank Dashboard / No Finance Account",
            "Page.page_name": "Blank Dashboard / No Finance Account",
            "Page.referrer_url": document.referrer,
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
    }
    renderedCallback() {
        let firstClass = this.template.querySelector(".main-content");
        fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
    }
}