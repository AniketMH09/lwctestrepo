import {
    LightningElement,
    api
} from 'lwc';
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import HondaLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import acuraLogo from "@salesforce/resourceUrl/AHFC_Acura_Header_Logo";
import carSvg from "@salesforce/resourceUrl/AHFC_Honda_Header_Car";
import adobeLogo from "@salesforce/resourceUrl/Adobe_Logo";
import AHFC_Header_AccountNumber from "@salesforce/label/c.AHFC_Header_AccountNumber";
import {
    loadStyle
} from "lightning/platformResourceLoader";
export default class Contractduplicate extends LightningElement {
    get hondaLogoUrl() {
        return HondaLogo;
    }

    get acuraLogoUrl() {
        return acuraLogo;
    }

    get carImage() {
        return carSvg;
    }
    get adobeLogoUrl() {
        return adobeLogo;
    }
    label = {

        AHFC_Header_AccountNumber

    };
    servAccName;
    accNo;
    // this.accNo = this.userAccountInfo.Finance_Account_Number__c;
    // this.servAccName = this.userAccountInfo.AHFC_Product_Nickname__c;
    connectedCallback() {
        loadStyle(this, ahfctheme + "/theme.css").then(() => {});

    }
    isDataPresent =false;
    isCalloutError =true;
    
}