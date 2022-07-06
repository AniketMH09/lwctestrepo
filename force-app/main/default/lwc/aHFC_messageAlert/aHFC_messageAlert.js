import { api, LightningElement , track} from 'lwc';
import {label} from "c/ahfcConstantUtil";

export default class AHFC_messageAlert extends LightningElement {
    @api type;
    @api content;
    @api link;
    @api postLinkContent;
    @track labels = label;
    
    get className(){
        const baseClass = 'ahfc-alert slds-notify slds-notify_alert slds-theme_alert-texture';
        switch (this.type) {
            case 'info' : return `${baseClass} slds-theme_info`;
            case 'warning' : return `${baseClass} slds-theme_warning`;
            case 'error' : return `${baseClass} slds-theme_error`;
            case 'success' : return `${baseClass} ahfc-theme_success`;
        }
    }

    get icon(){
        if(this.type==='info'){
            return `utility:info_alt`;
        } else {
            return `utility:${this.type}`;
        }
    }

    //Dispatch Event on click of a link inside alert
    onLinkClick(){
        const selectedEvent = new CustomEvent("linkclicked", {});
        this.dispatchEvent(selectedEvent);
    }

    //Dispatch Event on closing the alert
    closeAlert() {
        const selectedEvent = new CustomEvent("closealert", {});
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }
}