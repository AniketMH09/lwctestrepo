/* Component Name        :    AHFC_creditPreApproval
    * Description        :    This is LWC for Credit pre approval Main Page. 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aniket                     08/02/2021              Created for user story 5591 sprint-5\
    
*/
import { LightningElement, track, api, wire } from 'lwc';
import AHFC_Book_Pen from "@salesforce/resourceUrl/AHFC_Book_Pen";
import AHFC_Car_Sea from "@salesforce/resourceUrl/AHFC_Car_Sea";
import AHFC_Frame_1 from "@salesforce/resourceUrl/AHFC_Frame_1";
import AHFC_Frame_2 from "@salesforce/resourceUrl/AHFC_Frame_2";
import AHFC_Frame_3 from "@salesforce/resourceUrl/AHFC_Frame_3";
import AHFC_Honda_Centre from "@salesforce/resourceUrl/AHFC_Honda_Centre";
import AHFC_laptop from "@salesforce/resourceUrl/AHFC_laptop";
import AHFC_Icon_Frame_1 from "@salesforce/resourceUrl/AHFC_Icon_Frame_1";
import AHFC_Icon_Frame_2 from "@salesforce/resourceUrl/AHFC_Icon_Frame_2";
import AHFC_Icon_Frame_3 from "@salesforce/resourceUrl/AHFC_Icon_Frame_3";
import AHFC_Road_vally from "@salesforce/resourceUrl/AHFC_Road_vally";
import AHFC_Vector_cred from "@salesforce/resourceUrl/AHFC_Vector_cred";
import AHFC_cpa_hondaauto from "@salesforce/resourceUrl/AHFC_cpa_hondaauto";
import AHFC_cpa_acura from "@salesforce/resourceUrl/AHFC_cpa_acura";
import AHFC_cpa_marine from "@salesforce/resourceUrl/AHFC_cpa_marine";
import AHFC_cpa_pe from "@salesforce/resourceUrl/AHFC_cpa_pe";
import AHFC_cpa_ps from "@salesforce/resourceUrl/AHFC_cpa_ps";
import AHFC_Credit_Pre_Approval from "@salesforce/resourceUrl/AHFC_Credit_Pre_Approval";
import { fireEvent } from 'c/pubsub';
import { NavigationMixin } from "lightning/navigation";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import ahfc_preapproval_startapplication from "@salesforce/label/c.ahfc_preapproval_startapplication";
import ahfc_application_status_check from "@salesforce/label/c.ahfc_application_status_check";


import { CurrentPageReference } from 'lightning/navigation';
 

export default class AHFC_creditPreApproval extends NavigationMixin(LightningElement) {
    @track AHFC_cpa_hondaauto = AHFC_cpa_hondaauto;
    @track AHFC_cpa_acura = AHFC_cpa_acura;
    @track AHFC_cpa_marine = AHFC_cpa_marine;
    @track AHFC_cpa_pe = AHFC_cpa_pe;
    @track AHFC_cpa_ps = AHFC_cpa_ps;
    @track showWebsite = false;
    @track AHFC_Book_Pen = AHFC_Book_Pen;
    @track AHFC_Frame_1 = AHFC_Frame_1;
    @track AHFC_Frame_2 = AHFC_Frame_2;
    @track AHFC_Frame_3 = AHFC_Frame_3;
    @track AHFC_Car_Sea = AHFC_Car_Sea;
    @track AHFC_Honda_Centre = AHFC_Honda_Centre;
    @track AHFC_Icon_Frame_1 = AHFC_Icon_Frame_1;
    @track AHFC_Icon_Frame_2 = AHFC_Icon_Frame_2;
    @track AHFC_Icon_Frame_3 = AHFC_Icon_Frame_3;
    @track AHFC_Road_vally = AHFC_Road_vally;
    @track AHFC_laptop = AHFC_laptop;
    @track AHFC_Vector_cred = AHFC_Vector_cred;
    @track ahfc_text_1 = 'Securing pre-approval is the first step toward financing or leasing a new Honda or Acura product. Pre-approved customers arrive at the dealership pre-qualified for special offers.';
    @track ahfc_text_2 = 'To apply for pre-approval, you’ll enter a few details about yourself and your desired vehicle. We’ll review your application and respond by email. Take the first steps today to a new Honda or Acura!'

    @track opendealermodel = false;
    @track openstartapp = false;
    @track isIframe = true;
    @track openstatuscheck = false;

    @track iFrame = '';
    @track isLoaded = false;

    @track AHFC_Credit_Pre_Approval = AHFC_Credit_Pre_Approval;

    @track isModalPopUp = false;

    @wire(CurrentPageReference) pageRef;
    @track ahfc_preapproval_startapplication = ahfc_preapproval_startapplication;
  

    oncheckappstus() {
        this.openstatuscheck = true;
        this.isModalPopUp = true;
    }


    onStartApp() {
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Credit Pre-Approval:Button:Start App",
            "Event_Metadata.action_category": "CTA",
            "Page.page_name": "Credit Pre-Approval"

        };
        fireAdobeEvent(adobedata, 'click-event');
        this.openstartapp = true;
    }

    onDownload() {
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Credit Pre-Approval:Button:Download",
            "Event_Metadata.action_category": "CTA",
            "Page.page_name": "Credit Pre-Approval"

        };
        fireAdobeEvent(adobedata, 'click-event');
    }

    onFindDealer() {
        this.opendealermodel = true;
    }

    closeModal() {
        this.opendealermodel = false;
        this.openstartapp = false;
        this.openstatuscheck = false;
    }

    //onStartApplicationClick
    onStartApplicationClick(event) {
        event.stopPropagation();
        this.iFrame = '';
        this.isIframe = false;
        this.isLoaded = false;
        let adobedata = {};
console.log('this.ahfc_preapproval_startapplication',this.ahfc_preapproval_startapplication);
        switch (event.target.dataset.name) {
            case 'honda':
                this.iFrame = this.ahfc_preapproval_startapplication+'ProductDivisionCode=A&SiteOrigin=FN';
                adobedata = {
                    'Event_Metadata.action_type': 'Select',
                    "Event_Metadata.action_label": "Credit Pre-Approval:Select Product:Honda",
                    "Event_Metadata.action_category": "Credit App",
                    "Page.page_name": "Credit Pre-Approval"

                };
                fireAdobeEvent(adobedata, 'click-event');
                break;
            case 'marine':
                this.iFrame = '';
                adobedata = {
                    'Event_Metadata.action_type': 'Select',
                    "Event_Metadata.action_label": "Credit Pre-Approval:Select Product:Marine",
                    "Event_Metadata.action_category": "Credit App",
                    "Page.page_name": "Credit Pre-Approval"

                };
                fireAdobeEvent(adobedata, 'click-event');
                break;
            case 'acura':
                this.iFrame = this.ahfc_preapproval_startapplication+'ProductDivisionCode=B&SiteOrigin=FN';
                adobedata = {
                    'Event_Metadata.action_type': 'Select',
                    "Event_Metadata.action_label": "Credit Pre-Approval:Select Product:Acura",
                    "Event_Metadata.action_category": "Credit App",
                    "Page.page_name": "Credit Pre-Approval"

                };
                fireAdobeEvent(adobedata, 'click-event');
                break;
            case 'powersport':
                this.iFrame = this.ahfc_preapproval_startapplication+'ProductDivisionCode=M&SiteOrigin=FN';
                adobedata = {
                    'Event_Metadata.action_type': 'Select',
                    "Event_Metadata.action_label": "Credit Pre-Approval:Select Product:Powersports",
                    "Event_Metadata.action_category": "Credit App",
                    "Page.page_name": "Credit Pre-Approval"

                };
                fireAdobeEvent(adobedata, 'click-event');
                break;
            case 'powerequipment':
                this.iFrame = '';
                adobedata = {
                    'Event_Metadata.action_type': 'Select',
                    "Event_Metadata.action_label": "Credit Pre-Approval:Select Product:Power Equipment",
                    "Event_Metadata.action_category": "Credit App",
                    "Page.page_name": "Credit Pre-Approval"

                };
                fireAdobeEvent(adobedata, 'click-event');
                break;
        }
        this.openstartapp = false;
        if (this.iFrame != '') {
            this.isLoaded = true;
            this.isIframe = false;
        } else {
            this.isIframe = true;
        }

    }

    //onStartApplicationStatusCheck
    onCheckApplicationStatusClick(event) {
        event.stopPropagation();
        this.iFrame = '';
        this.isIframe = false;
        this.isLoaded = false;
        switch (event.target.dataset.name) {
            case 'honda':
                this.iFrame = ahfc_application_status_check+'?ProductDivisionCode=A&SiteOrigin=FN';
                break;
            case 'acura':
                this.iFrame = ahfc_application_status_check+'?ProductDivisionCode=B&SiteOrigin=FN';
                break;
            case 'powersport':
                this.iFrame = ahfc_application_status_check+'?ProductDivisionCode=M&SiteOrigin=FN';
                break;
        }
        this.openstatuscheck = false;
        if (this.iFrame != '') {
            this.isLoaded = true;
            this.isIframe = false;
        } else {
            this.isIframe = true;

        }

    }

    //once iFraame load
    oninframeload() {
        this.isLoaded = false;
        window.scrollTo(0, 0);
    }

    //on find a dealer click
    onFindClick(event) {
        event.stopPropagation();
        let dealerLink = '';
        switch (event.target.dataset.name) {
            case 'honda':
                dealerLink = 'https://automobiles.honda.com/tools/dealership-locator';
                break;
            case 'marine':
                dealerLink = 'https://marine.honda.com/dealer-locator';
                break;
            case 'acura':
                dealerLink = 'https://www.acura.com/dealer-locator-inventory';
                break;
            case 'powersport':
                dealerLink = 'https://powersports.honda.com/find-a-dealer';
                break;
            case 'powerequipment':
                dealerLink = 'https://powerequipment.honda.com/dealer-locator';
                break;
        }
        this.openmodel = false;

        if (dealerLink != '') {
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: dealerLink
                }
            });
        }
    }

    renderedCallback() {
        let firstClass = this.template.querySelector(".main-content");
        let abc = firstClass.getAttribute('id');
        fireEvent(this.pageRef, 'MainContent', abc);

    }


    connectedCallback() {
        fireEvent(this.pageRef, 'populateMenu');
        let adobedata = {
            "Page.page_name": "Credit Pre-Approval",
            "Page.site_section": "Credit Pre-Approval",
            "Page.referrer_url": document.referrer
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');

    }

}