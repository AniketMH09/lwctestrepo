import { LightningElement, track, wire } from 'lwc';
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import FORM_FACTOR from "@salesforce/client/formFactor";
import FAQ1 from "@salesforce/resourceUrl/AHFS_Faq1";
import FAQ2 from "@salesforce/resourceUrl/AHFS_Faq2";
import FAQ3 from "@salesforce/resourceUrl/AHFS_Faq3";

import { NavigationMixin } from "lightning/navigation";

export default class AHFC_dashboardFAQHelpCenter extends NavigationMixin(LightningElement)
{
    @track showdesktop;
    @track showmobile;

    get FAQ_Frame1(){
        return FAQ1; 
    }
    get FAQ_Frame2(){
        return FAQ2; 
    }
    get FAQ_Frame3(){
        return FAQ3; 
    } @track mobileSections = [
        {
            id: "5",
            class: "slds-accordion__section",
            contentClass: "slds-accordion__content",
            isOpened: false,
            header: this.labels.DashboardFaq,
            isFaqs: true
        },

    ];


    connectedCallback() {
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
        if (FORM_FACTOR == this.labels.Large) {
            this.showdesktop = true;
            this.showmobile = false;
        } else if (FORM_FACTOR == this.labels.Medium) {
            this.showdesktop = true;
            this.showmobile = true;
        } else {
            this.showdesktop = false;
            this.showmobile = true;
        }
        this.showdesktop = true;
        console.log('143', this.showmobile);
    }
}