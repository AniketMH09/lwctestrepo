import { wire, LightningElement, track } from 'lwc';
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import {
    loadStyle
} from "lightning/platformResourceLoader";
import isguest from '@salesforce/user/isGuest';
import { labels } from "c/aHFC_paymentConstantsUtil";
import { NavigationMixin } from "lightning/navigation";
import hondaHeadLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import acuraHeadLogo from "@salesforce/resourceUrl/AHFC_Acura_Header_Logo";
import hondaVehImg from "@salesforce/resourceUrl/AHFC_Honda_Header_Car";
import { CurrentPageReference } from "lightning/navigation";
import { fireEvent } from 'c/pubsub';
import { fireAdobeEvent } from "c/aHFC_adobeServices";

import paymentFlagRetrieve from "@salesforce/apex/AHFC_paymentOptionsController.paymentFlagRetrieve";

export default class AHFC_paymentOptions extends NavigationMixin(LightningElement) {
    isCheck = isguest;
    @track labels = labels;
    @track isHondaPayment;
    @track isAcuraPayment;
    @track isState;
    @track isPaymentDta;
    @track sacRecordId = '';
    @track boolisState = false;
    @track pageRef;

    get hondaheadLogoUrl() {
        return hondaHeadLogo;
    }
    get acuraheadLogoUrl() {
        return acuraHeadLogo;
    }
    get hondaVehImgUrl() {
        return hondaVehImg;
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            console.log('urlStateParameters------> ' + this.urlStateParameters);
            if (typeof currentPageReference.state.sacRecordId != "undefined") {
                this.sacRecordId = currentPageReference.state.sacRecordId;
            }
            this.pageRef = currentPageReference;
        }
        console.log("sacRecordId -> " + this.sacRecordId);
    }

    @wire(paymentFlagRetrieve, { FinanceId: '$sacRecordId' })
    paymentFlagRetrieve({ error, data }) {
        console.log('data -' + JSON.stringify(data));

        if (data) {
            this.isPaymentDta = data;
            this.isHondaPayment = this.isPaymentDta.hondaPayment;
            this.isAcuraPayment = this.isPaymentDta.acuraPayment;
            this.isState = this.isPaymentDta.isState;
            if (this.isState) {
                this.boolisState = true;
            }

        } else if (error) {

            this.error = error;

        }
    }
    connectedCallback() {
        fireEvent(this.pageRef, 'populateMenu');
        let adobedata = {
            "Page.page_name": "Payment Option",
            "Page.site_section": "Payment Option",
            "Page.referrer_url": document.referrer,
            // "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        loadStyle(this, ahfctheme + "/theme.css").then(() => {});
        //this.getUserProfile();
        //this.getUserServiceAccountCustomers();
    }
    navigateBackToDashboard() {
            var url = window.location.href;
            var value = url.substr(0, url.lastIndexOf('/') + 1);
            window.history.back();
            return false;
        }
        //for ADA fix
    renderedCallback() {
        let firstClass = this.template.querySelector(".main-content");
        //fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
        setTimeout(() => { fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id')); }, 1000);
    }

    navigateToContactUS() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-post-login'
            }
        });
		return false;
    }
}