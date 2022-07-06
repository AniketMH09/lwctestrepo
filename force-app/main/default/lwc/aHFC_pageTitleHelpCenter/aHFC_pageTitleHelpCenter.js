/* 
 * Component Name       :    AHFC_pageTitleHelpCenter
 * @Description        :    This Component is used to display Title page with back navigation for Help center
 * Modification Log   :
 * ---------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ---------------------------------------------------------------------------  
 * Aswin Jose                10/08/2021                Created
 */
import {
    api,
    LightningElement
  } from 'lwc';
  import {
    NavigationMixin
  } from "lightning/navigation";
 
  import AHFC_helpCenter_URL from "@salesforce/label/c.AHFC_helpCenter_URL";
  import { fireAdobeEvent } from "c/aHFC_adobeServices";
  
  export default class AHFC_pageTitleHelpCenter extends NavigationMixin(LightningElement) {
  
    @api title;
   
    @api showIcon;

    connectedCallback(){
      let adobedata = {
        "Page.page_name": this.title,
        "Page.site_section": this.title,
        "Page.referrer_url": document.referrer,
        // "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
    };
    fireAdobeEvent(adobedata, 'PageLoadReady');
      console.log('showIcon:: '+this.showIcon);
    }
  
    //Navigate To Dashboard
    navigateBackToHelpCenter() {
      
      if(window.history.length > 1 ){
        window.history.back();
      }else{
        console.log('no history');
        this.navigateToHomePage();
      }
      return false;
    }
    

    navigateToHomePage() {
      console.log('navigate to home');

    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
          pageName: 'help-center'
      }

    });
    } 
    

  
  }