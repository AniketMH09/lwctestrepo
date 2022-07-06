import { LightningElement, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import { fireEvent } from 'c/pubsub';
export default class AHFC_aboutUs extends NavigationMixin(LightningElement) {
    returnToDashBoard() {
        // var url = window.location.href; 
        // var value = url.substr(0,url.lastIndexOf('/') + 1); 
        window.history.back();
        return false;
        // this[NavigationMixin.Navigate]({
        //   type: "comm__namedPage",
        //   attributes: {
        //       pageName: "dashboard"
        //   },
        // });
    }
    @wire(CurrentPageReference) pageRef;
    connectedCallback() {
        let adobedata = {
            "Page.page_name": "About Us",
            "Page.site_section": "About Us",
            "Page.referrer_url": document.referrer,
            //  "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        fireEvent(this.pageRef, 'populateMenu');
    }
}