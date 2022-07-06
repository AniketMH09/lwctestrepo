/* Component Name   :    aHFC_endOfLeasePreLogin
* @Description      :    LWC for sub menu end of lease for pre login page
* Modification Log  :
* ------------------------------------------------------------------------------------------------------------------ 
* Developer                          Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Sagar Ghadigaonkar                 Aug 23 2021             LWC for sub menu end of lease for pre login page
 

********************************************************************************************************************/

import { LightningElement, track, wire } from 'lwc';
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import ahfc_endOfLeaseDesktop from "@salesforce/resourceUrl/ahfc_endOfLeaseDesktop";
import ahfc_endOfLeaseMobile from "@salesforce/resourceUrl/ahfc_endOfLeaseMobile";
import ahfc_leaseEndContact from "@salesforce/resourceUrl/ahfc_leaseEndContact";
import ahfc_leaseEndContactMobile from "@salesforce/resourceUrl/ahfc_leaseEndContactMobile";
import ahfc_step1EndOfLease from "@salesforce/resourceUrl/ahfc_step1EndOfLease";
import ahfc_step2EndOfLease from "@salesforce/resourceUrl/ahfc_step2EndOfLease";
import ahfc_step3EndOfLease from "@salesforce/resourceUrl/ahfc_step3EndOfLease";
import ahfc_step4EndOfLease from "@salesforce/resourceUrl/ahfc_step4EndOfLease";
import ahfc_endOfLeaseRAL from "@salesforce/resourceUrl/ahfc_endOfLeaseRAL";
import ahfc_endOfLeasePYV from "@salesforce/resourceUrl/ahfc_endOfLeasePYV";
import ahfc_endOfLeaseRYV from "@salesforce/resourceUrl/ahfc_endOfLeaseRYV";
import ahfc_odometerPdf from "@salesforce/resourceUrl/ahfc_odometerPdf";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import ahfc_vehicleInspectionPdf from "@salesforce/resourceUrl/ahfc_vehicleInspectionPdf";
import inspection_url from "@salesforce/label/c.Inspection_URL";
import {
    fireEvent
} from 'c/pubsub';
import {
    CurrentPageReference
} from "lightning/navigation";



export default class AHFC_endOfLease extends LightningElement {

    @wire(CurrentPageReference) pageRef;
    //  endOfLeaseDesktop = ahfc_endOfLease + '/images/check.jpg';

    inspection_label = inspection_url;
    get endOfLeaseDesktop() {
        return ahfc_endOfLeaseDesktop;
    }
    get endOfLeaseMobile() {
        return ahfc_endOfLeaseMobile;
    }
    get leaseEndContact() {
        return ahfc_leaseEndContact;
    }
    get leaseEndContactMobile() {
        return ahfc_leaseEndContactMobile;
    }
    get step1Url() {
        return ahfc_step1EndOfLease;
    }
    get step2Url() {
        return ahfc_step2EndOfLease;
    }
    get step3Url() {
        return ahfc_step3EndOfLease;
    }
    get step4Url() {
        return ahfc_step4EndOfLease;
    }
    get returnAndLease() {
        return ahfc_endOfLeaseRAL;
    }
    get purchaseYourVehicle() {
        return ahfc_endOfLeasePYV;
    }
    get returnYourVehicle() {
        return ahfc_endOfLeaseRYV;
    }
    get vehicleInspection() {
        return ahfc_vehicleInspectionPdf;
    }


    @track odometerPdf = ahfc_odometerPdf;
    @track showOrLess = true;
    @track stepperLineHeight = "ahfc_whitePatch ahfc_purchaseWPLess";
    // @track currentTabActive = true;
    @track currentTabActive = {
        returnAndLeaseNewVehicle: true,
        purchaseYourVehicle: false,
        returnYourVehicle: false
    };
    onTabChangeEnterKey(event){
        if(event.keyCode === 13){
            this.onTabChange(event);
        }
    }

    @track tabsList = [{
            id: 1,
            key: "returnAndLeaseNewVehicle",
            title: "RETURN AND LEASE A NEW VEHICLE",
            tabClass: "slds-tabs_default__item slds-is-active slds_tab"
        },
        {
            id: 2,
            key: "purchaseYourVehicle",
            title: "PURCHASE YOUR VEHICLE",
            tabClass: "slds-tabs_default__item slds_tab"
        },
        {
            id: 3,
            key: "returnYourVehicle",
            title: "RETURN YOUR VEHICLE",
            tabClass: "slds-tabs_default__item slds_tab"
        }
    ];

    connectedCallback() {

        let adobedata = {
            "Page.page_name": "End of Lease",
            "Page.site_section": "End of Lease",
            "Page.referrer_url": document.referrer,
            'Event_Metadata.action_type': 'Tab',
            "Event_Metadata.action_label": "Return and Lease New",
            "Event_Metadata.action_category": "Navigation",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''

        };
        fireAdobeEvent(adobedata, 'PageLoadReady');

        /* let adobedatatab = {
             'Event_Metadata.action_type': 'Tab',
             "Event_Metadata.action_label": "Return and Lease New",
             "Event_Metadata.action_category": "Navigation",
             "Page.page_name": "End of Lease",
             "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
         };
         fireAdobeEvent(adobedatatab, 'PageLoadReady'); */



        loadStyle(this, ahfctheme + "/theme.css").then(() => {});
    }



    onTabChange(event) {
        this.onTabToggle(event.currentTarget.dataset.id);
    }

    onTabToggle(tab) {
        console.log(tab, 'tab value');
        if (tab === "returnAndLeaseNewVehicle") {

            let adobedata = {
                'Event_Metadata.action_type': 'Tab',
                "Event_Metadata.action_label": "End of Lease:Tab:Return and Lease New",
                "Event_Metadata.action_category": "Navigation",
                "Page.page_name": "End of Lease",
                "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
            };
            fireAdobeEvent(adobedata, 'click-event');

            this.template.querySelector('li[data-id="purchaseYourVehicle"]').classList.remove("slds-is-active");
            this.template.querySelector('li[data-id="returnYourVehicle"]').classList.remove("slds-is-active");
            this.template.querySelector('li[data-id="returnAndLeaseNewVehicle"]').classList.add("slds-is-active");
            this.currentTabActive.returnAndLeaseNewVehicle = true;
            this.currentTabActive.returnYourVehicle = false;
            this.currentTabActive.purchaseYourVehicle = false;
        } else if (tab === "purchaseYourVehicle") {

            let adobedata = {
                'Event_Metadata.action_type': 'Tab',
                "Event_Metadata.action_label": "End of Lease:Tab:Purchase",
                "Event_Metadata.action_category": "Navigation",
                "Page.page_name": "End of Lease",
                "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
            };
            fireAdobeEvent(adobedata, 'click-event');
            this.template.querySelector('li[data-id="returnAndLeaseNewVehicle"]').classList.remove("slds-is-active");
            this.template.querySelector('li[data-id="returnYourVehicle"]').classList.remove("slds-is-active");
            this.template.querySelector('li[data-id="purchaseYourVehicle"]').classList.add("slds-is-active");
            this.currentTabActive.returnAndLeaseNewVehicle = false;
            this.currentTabActive.returnYourVehicle = false;
            this.currentTabActive.purchaseYourVehicle = true;
        } else {

            let adobedata = {
                'Event_Metadata.action_type': 'Tab',
                "Event_Metadata.action_label": "End of Lease:Tab:Return",
                "Event_Metadata.action_category": "Navigation",
                "Page.page_name": "End of Lease",
                "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
            };
            fireAdobeEvent(adobedata, 'click-event');

            this.template.querySelector('li[data-id="returnAndLeaseNewVehicle"]').classList.remove("slds-is-active");
            this.template.querySelector('li[data-id="purchaseYourVehicle"]').classList.remove("slds-is-active");
            this.template.querySelector('li[data-id="returnYourVehicle"]').classList.add("slds-is-active");
            this.currentTabActive.returnAndLeaseNewVehicle = false;
            this.currentTabActive.returnYourVehicle = true;
            this.currentTabActive.purchaseYourVehicle = false;
        }
        // this.currentTabActive = tab === "returnAndLeaseNewVehicle";
    }

    onClickMore() {
        // var x = document.getElementById("myDIV");
        //   if (x.style.display === "none") {
        //     x.style.display = "block";
        //   } else {
        //     x.style.display = "none";
        //   }
        console.log(this.template.querySelector('div[data-id="purchaseWidth"]'), 'check');

        if (this.showOrLess == true) {
            this.showOrLess = false;
            this.stepperLineHeight = "ahfc_whitePatch ahfc_purchaseWPMore";
            // this.template.querySelector('div[data-id="purchaseWidth"]').classList.add("ahfc_whitePatch ahfc_purchaseWPMore");
            // this.template.querySelector('div[data-id="purchaseWidth"]').classList.remove("ahfc_whitePatch ahfc_purchaseWPLess");
        } else {
            this.showOrLess = true;
            this.stepperLineHeight = "ahfc_whitePatch ahfc_purchaseWPLess";
        }
    }

    handleClick(event) {
        let targetId = event.target.dataset.targetId;
        let target = this.template.querySelector(`[data-id="${targetId}"]`);
        target.scrollIntoView();
    }
    renderedCallback() {
       let firstClass = this.template.querySelector(".main-content");
        fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
    }
}