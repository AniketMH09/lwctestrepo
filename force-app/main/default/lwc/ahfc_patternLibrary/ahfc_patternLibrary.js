import { LightningElement } from 'lwc';
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";

export default class Ahfc_patternLibrary extends LightningElement {

    connectedCallback() {
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
    }
}