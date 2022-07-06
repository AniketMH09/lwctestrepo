import { LightningElement,track } from 'lwc';
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import adobeLogo from "@salesforce/resourceUrl/Adobe_Logo";
import hondaHeadLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import hondaVehImg from "@salesforce/resourceUrl/AHFC_Honda_Header_Car";
import easypay from "@salesforce/resourceUrl/AHFC_Easypay"; 
import FORM_FACTOR from "@salesforce/client/formFactor";


import {
    loadStyle
  } from "lightning/platformResourceLoader";
 

 

  export default class AHFC_paymentOtp extends LightningElement {
    @track showdesktop;
    @track showmobile;
    @track labels = {
      Large: 'Large',
      Medium: 'Medium'
    };
  
    get easypayImg(){
       return easypay;
     }
     
  get hondaheadLogoUrl() {
    return hondaHeadLogo;
  }

  get hondaVehImgUrl(){
    return hondaVehImg;
  }

  get adobeLogoUrl() {
    return adobeLogo;
}
connectedCallback() {
  loadStyle(this, ahfctheme + "/theme.css").then(() => {});
  console.log('Form Factor Entry');
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
  console.log('Form Factor-->', FORM_FACTOR);
}
}