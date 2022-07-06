/* Component Name     :    AHFC_managePayments
    * Description        :    This is LWC for Manage Payments page. 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aniket                     20/05/2021              Created 
    */

import { LightningElement, track, wire } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import { fireEvent } from 'c/pubsub';
import { CurrentPageReference } from "lightning/navigation";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import spinnerWheelMessage from "@salesforce/label/c.Spinner_Wheel_Message";



export default class AHFC_managePayments extends LightningElement {


    @track spinnerMessage = spinnerWheelMessage;
    @track loadingspinner = true;
    @track pageRef;

    // Get service account customer id from previous page
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.loadingspinner = false;

        this.pageRef = currentPageReference;
    }

    @track labels = {
        PaymentActivity: 'Payment Activity',
        ScheduledPayments: 'SCHEDULED PAYMENTS',
        TransactionHistory_Title: 'Transaction History'
    };
    @track tabItems = [{
            key: 'scheduledPayments',
            name: this.labels.ScheduledPayments,
            tabIndex: '0',
            ariaSelected: 'true',
            ariaControls: 'scheduled-payments-tab',
            ariaLabelledby: 'scheduled-payments-tab_item',
            headerClass: 'slds-tabs_default__item schedulePayTab ahfc-info-label ahfc-text-dark slds-is-active',
            contentClass: 'slds-tabs_default__content slds-show',
            isScheduledPayment: true
        },
        {
            key: 'transactionHistory',
            name: this.labels.TransactionHistory_Title,
            tabIndex: '-1',
            ariaSelected: 'false',
            ariaControls: 'transaction-history-tab',
            ariaLabelledby: 'transaction-history-tab_item',
            headerClass: 'slds-tabs_default__item ahfc-info-label ahfc-text-dark transactionTab ',
            contentClass: 'slds-tabs_default__content slds-hide',
            isTransactionHistory: true
        }
    ];
    onTabChangeEnterKey(event){
        if(event.keyCode === 13){
            this.onTabChange(event);
        }
    }
    onTabChange(event) {
        console.log('00000000000000001',event.target.dataset.tabname);
        if (event.target.dataset.tabname == 'scheduledPayments' && this.tabItems[0].ariaSelected != 'true') {
            this.tabItems[0].ariaSelected = 'true';
            this.tabItems[0].tabIndex = '0';
            this.tabItems[0].headerClass = 'slds-tabs_default__item ahfc-info-label ahfc-text-dark schedulePayTab  slds-is-active';
            this.tabItems[0].contentClass = 'slds-tabs_default__content slds-show';
            this.tabItems[1].ariaSelected = 'false';
            this.tabItems[1].tabIndex = '-1';
            this.tabItems[1].headerClass = 'slds-tabs_default__item ahfc-info-label ahfc-text-dark transactionTab ';
            this.tabItems[1].contentClass = 'slds-tabs_default__content slds-hide';
            this.loadingspinner = false;
            let adobedata = {
                'Event_Metadata.action_type': 'Tab',
                "Event_Metadata.action_label": "Manage Payment:Tab:ScheduledPayments",
                "Event_Metadata.action_category": "Navigation",
                "Page.page_name": "Manage Payment",
               // "Page.brand_name": this.brandName
            };
            fireAdobeEvent(adobedata, 'click-event');

        } else if (event.target.dataset.tabname == 'transactionHistory' && this.tabItems[1].ariaSelected != 'true') {
            this.tabItems[1].ariaSelected = 'true';
            this.tabItems[1].tabIndex = '0';
            this.tabItems[1].headerClass = 'slds-tabs_default__item ahfc-info-label ahfc-text-dark transactionTab  slds-is-active';
            this.tabItems[1].contentClass = 'slds-tabs_default__content slds-show';
            this.tabItems[0].ariaSelected = 'false';
            this.tabItems[0].tabIndex = '-1';
            this.tabItems[0].headerClass = 'slds-tabs_default__item ahfc-info-label ahfc-text-dark schedulePayTab ';
            this.tabItems[0].contentClass = 'slds-tabs_default__content slds-hide';
            this.loadingspinner = false;
            let adobedata = {
                'Event_Metadata.action_type': 'Tab',
                "Event_Metadata.action_label": "Manage Payment:Tab:TransactionHistory",
                "Event_Metadata.action_category": "Navigation",
                "Page.page_name": "Manage Payment",
               // "Page.brand_name": this.brandName
            };
            fireAdobeEvent(adobedata, 'click-event');

        }
    }

    get isTransaction() {
        this.loadingspinner = false;

        return (this.tabItems[1].ariaSelected == 'true') ? true : false;
    }

 

    connectedCallback() {
        let adobedata = {
            "Page.page_name": "Manage Payment",
            "Page.site_section": "Manage Payment",
            "Page.referrer_url": document.referrer,
            // "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');

        // if (sessionStorage.getItem('isRefreshed') != null) {
        //   if (sessionStorage.getItem('isRefreshed') == 'false') {
        //     sessionStorage.setItem('isRefreshed', 'true');
        //     window.location.reload();
        //   }
        // }
        this.loadingspinner = false;


        loadStyle(this, ahfctheme + '/theme.css').then(() => {});
    }

    renderedCallback() {
        this.loadingspinner = false;

        let firstClass = this.template.querySelector(".main-content");
        fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
    }

}