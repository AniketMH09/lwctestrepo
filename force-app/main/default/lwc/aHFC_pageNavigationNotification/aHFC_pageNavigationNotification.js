import { LightningElement } from 'lwc';
import {loadStyle} from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";

export default class AHFC_pageNavigationNotification extends LightningElement {

    acceptContinue(){
        const selectedEvent = new CustomEvent("accept");
        this.dispatchEvent(selectedEvent);
    }

    onCancel(){
        const selectedEvent = new CustomEvent("cancel");
        this.dispatchEvent(selectedEvent);
    }
    connectedCallback(){
        loadStyle(this, ahfctheme + "/theme.css").then(() => {});
    }

}