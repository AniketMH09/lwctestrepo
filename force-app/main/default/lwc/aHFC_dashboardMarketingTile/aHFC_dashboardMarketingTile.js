import { api, wire, LightningElement, track } from 'lwc';
import CurrentOffersHondaAutoLogo from "@salesforce/resourceUrl/Current_Offers_Honda_Auto";
import CurrentOffersAcuraAutoLogo from "@salesforce/resourceUrl/Current_Offers_Acura_Auto";
import CurrentOffersMarineLogo from "@salesforce/resourceUrl/Current_Offers_Marine";
import CurrentOffersPowersportsLogo from "@salesforce/resourceUrl/Current_Offers_Powersports";
import CurrentOffersPowerEquipmentLogo from "@salesforce/resourceUrl/Current_Offers_Power_Equipment";
import HondaEOTContentLogo from "@salesforce/resourceUrl/Honda_EOT_Content";
import AcuraEOTContentLogo from "@salesforce/resourceUrl/Acura_EOT_Content";
import { labels } from "c/aHFC_paymentConstantsUtil";
import marketingFlagRetrieve from "@salesforce/apex/AHFC_MarketingTileController.marketingFlagRetrieve";
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { CurrentPageReference } from "lightning/navigation";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import { NavigationMixin } from "lightning/navigation";

 

import AHFC_Locked_Dashboard_Marketting_Honda from "@salesforce/resourceUrl/AHFC_Locked_Dashboard_Marketting_Honda";
import AHFC_Locked_Dashboard_Marketting_Acura from "@salesforce/resourceUrl/AHFC_Locked_Dashboard_Marketting_Acura";
import AHFC_Locked_Dashboard_Marketting_Marine from "@salesforce/resourceUrl/AHFC_Locked_Dashboard_Marketting_Marine";
import AHFC_Locked_Dashboard_Marketting_PE from "@salesforce/resourceUrl/AHFC_Locked_Dashboard_Marketting_PE";
import AHFC_Locked_Dashboard_Marketting_PS from "@salesforce/resourceUrl/AHFC_Locked_Dashboard_Marketting_PS";
import Acura_4Month_EOT from "@salesforce/resourceUrl/Acura_4Month_EOT";//RSS 53493
import Honda_4Month_EOT from "@salesforce/resourceUrl/Honda_4Month_EOT";//RSS 53493

export default class AHFC_dashboardMarketingTile extends NavigationMixin(LightningElement) {


  @track AHFC_Locked_Dashboard_Marketting_Honda = AHFC_Locked_Dashboard_Marketting_Honda;
  @track AHFC_Locked_Dashboard_Marketting_Acura = AHFC_Locked_Dashboard_Marketting_Acura;
  @track AHFC_Locked_Dashboard_Marketting_Marine = AHFC_Locked_Dashboard_Marketting_Marine;
  @track AHFC_Locked_Dashboard_Marketting_PE = AHFC_Locked_Dashboard_Marketting_PE;
  @track AHFC_Locked_Dashboard_Marketting_PS = AHFC_Locked_Dashboard_Marketting_PS;


  @track IDSAC;
  @track pageRef;
  @track labels = labels;
  @api selServiceAccountWrapper;
  @track serviceAccountWrapper;
  @track isHondaAuto;
  @track isAcuraAuto;
  @track isMarine;
  @track isPowerSports;
  @track isPowerEquipment;
  @track isHondaEOT;
  @track isAcuraEOT;
  @track isHondafourMthEOT;//RSS 53493
  @track isAcurafourMthEOT;//RSS 53493
  @track marketingData;
  @api isLocked = false;

  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
    this.pageRef = currentPageReference;
  }

  get CurrentOffersHondaAutoLogoURL() {
    return CurrentOffersHondaAutoLogo;
  }
  get CurrentOffersAcuraAutoLogoURL() {
    return CurrentOffersAcuraAutoLogo;
  }
  get CurrentOffersMarineLogoURL() {
    return CurrentOffersMarineLogo;
  }
  get CurrentOffersPowersportsLogoURL() {
    return CurrentOffersPowersportsLogo;
  }
  get CurrentOffersPowerEquipmentLogoURL() {
    return CurrentOffersPowerEquipmentLogo;
  }
  get HondaEOTContentLogoURL() {
    return HondaEOTContentLogo;
  }
  get AcuraEOTContentLogoURL() {
    return AcuraEOTContentLogo;
  }

  //RSS 53493
  get Honda4MnthEOTContentLogoURL() {
    return Honda_4Month_EOT;
  }
  get Acura4MnthEOTContentLogoURL() {
    return Acura_4Month_EOT;
  }


  connectedCallback() {
    try {
      registerListener('financeAccountInfo', this.getDataFromPubsubEvent, this);
    } catch (error) {
      console.log('157', error);
    }
    let jsondata = JSON.parse(this.selServiceAccountWrapper);

    if ((sessionStorage.getItem(jsondata.serAccRec.Finance_Account_Number__c) != null)) {
      let sessdata = JSON.parse(sessionStorage.getItem(jsondata.serAccRec.Finance_Account_Number__c));
      if (sessdata.isWebsiteRestricted == true || (jsondata.serAccRec.AHFC_Fl_Archived__c != undefined && jsondata.serAccRec.AHFC_Fl_Archived__c == 'Y')) {
        this.isLocked = true;
      }
    } else {
      if ((jsondata.serAccRec.AHFC_Web_Account_Locked__c != undefined && jsondata.serAccRec.AHFC_Web_Account_Locked__c == 'Y') || (jsondata.serAccRec.AHFC_Fl_Archived__c != undefined && jsondata.serAccRec.AHFC_Fl_Archived__c == 'Y')) {
        this.isLocked = true;
      }
    }

    this.setdata(this.selServiceAccountWrapper);
    this.OnmarketingFlagRetrieve();

  }
  navigateToEndOFLeasePrelogin() {
    let adobedata = {
      'Event_Metadata.action_type': 'Hyperlink',
      "Event_Metadata.action_label": "Dashboard:Hyperlink:EOT Content",
      "Event_Metadata.action_category": "Marketing Tile",
      "Page.page_name": "Dashboard"
    };
    fireAdobeEvent(adobedata, 'click-event');
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: 'end-of-lease-pre-login'
      }
    });
}

  getDataFromPubsubEvent(data) {

    let jsondata = JSON.parse(data);
    if (jsondata.getAccountInfo == '') {
      if (jsondata.finaAccountData.AHFC_Fl_Archived__c == 'Y' || jsondata.finaAccountData.AHFC_Web_Account_Locked__c == 'Y') {
        this.isLocked = true;
      }
    } else {
      if (jsondata.finaAccountData.AHFC_Fl_Archived__c == 'Y' || jsondata.getAccountInfo.isWebsiteRestricted == true) {
        this.isLocked = true;
      }
    }

  }

  setdata(wrapper) {
    this.serviceAccountWrapper = JSON.parse(wrapper);
    this.IDSAC = this.serviceAccountWrapper.serAccRec.Id;
  }

  @api handleValueChange(wrapper) {

    this.setdata(wrapper);
    this.OnmarketingFlagRetrieve();
  }

  OnmarketingFlagRetrieve() {

    marketingFlagRetrieve({
      FinanceId: this.IDSAC
    })
      .then((result) => {
        if (result) {
          console.log('result', result);
          this.marketingData = result;
          this.isHondaAuto = this.marketingData.hondaAuto;
          this.isAcuraAuto = this.marketingData.acuraAuto;
          this.isMarine = this.marketingData.marine;
          this.isPowerSports = this.marketingData.powerSports;
          this.isPowerEquipment = this.marketingData.powerEquipment;
          this.isHondaEOT = this.marketingData.hondaEOT;
          this.isAcuraEOT = this.marketingData.acuraEOT;
          this.isHondafourMthEOT=this.marketingData.hondafourMthEOT;//RSS 53493
          this.isAcurafourMthEOT=this.marketingData.acurafourMthEOT;//RSS 53493
          
         
        }
      })
      .catch((error) => {
        console.log('Errorrrr', error);
      }

      );

  }

  onhonda(){
    let adobedata = {
      'Event_Metadata.action_type': 'Hyperlink',
      "Event_Metadata.action_label": "Dashboard:Hyperlink:Current Offers Honda Auto",
      "Event_Metadata.action_category": "Marketing Tile",
      "Page.page_name": "Dashboard"
    };
    fireAdobeEvent(adobedata, 'click-event');
    this[NavigationMixin.Navigate]({
      type: 'standard__webPage',
      attributes: {
          url: this.labels.CurrentOffersHondaAutoURL
      }
  },
  false // Replaces the current page in your browser history with the URL
);
  }

  onacura(){
    let adobedata = {
      'Event_Metadata.action_type': 'Hyperlink',
      "Event_Metadata.action_label": "Dashboard:Hyperlink:Current Offers Acura Auto",
      "Event_Metadata.action_category": "Marketing Tile",
      "Page.page_name": "Dashboard"
    };
    fireAdobeEvent(adobedata, 'click-event');
    this[NavigationMixin.Navigate]({
      type: 'standard__webPage',
      attributes: {
          url: this.labels.CurrentOffersAcuraAutoURL
      }
  },
  false // Replaces the current page in your browser history with the URL
);
  }
  onmarine(){
    let adobedata = {
      'Event_Metadata.action_type': 'Hyperlink',
      "Event_Metadata.action_label": "Dashboard:Hyperlink:Current Offers Marine",
      "Event_Metadata.action_category": "Marketing Tile",
      "Page.page_name": "Dashboard"
    };
    fireAdobeEvent(adobedata, 'click-event');
    this[NavigationMixin.Navigate]({
      type: 'standard__webPage',
      attributes: {
          url: this.labels.CurrentOffersMarineURL
      }
  },
  false // Replaces the current page in your browser history with the URL
);
  }
  onps(){
    let adobedata = {
      'Event_Metadata.action_type': 'Hyperlink',
      "Event_Metadata.action_label": "Dashboard:Hyperlink:Current Offers Powersports",
      "Event_Metadata.action_category": "Marketing Tile",
      "Page.page_name": "Dashboard"
    };
    fireAdobeEvent(adobedata, 'click-event');
    this[NavigationMixin.Navigate]({
      type: 'standard__webPage',
      attributes: {
          url: this.labels.CurrentOffersPowersportsURL
      }
  },
  false // Replaces the current page in your browser history with the URL
);
  }
  onpe(){
    let adobedata = {
      'Event_Metadata.action_type': 'Hyperlink',
      "Event_Metadata.action_label": "Dashboard:Hyperlink:Current Offers Power Equipment",
      "Event_Metadata.action_category": "Marketing Tile",
      "Page.page_name": "Dashboard"
    };
    fireAdobeEvent(adobedata, 'click-event');
    this[NavigationMixin.Navigate]({
      type: 'standard__webPage',
      attributes: {
          url: this.labels.CurrentOffersPowerEquipmentURL
      }
  },
  false // Replaces the current page in your browser history with the URL
);
  }

  //RSS 53493 added by Narain Start
onHondafourMthEOT(){
  let adobedata = {
    'Event_Metadata.action_type': 'Hyperlink',
    "Event_Metadata.action_label": "Dashboard:Hyperlink:End of Term for 4 Month below Maturity Honda Auto",
    "Event_Metadata.action_category": "Marketing Tile",
    "Page.page_name": "Dashboard"
  };
  fireAdobeEvent(adobedata, 'click-event');
  this[NavigationMixin.Navigate]({
    type: 'standard__webPage',
    attributes: {
        url: this.labels.Honda4MonthEOTURL
    }
},
false // Replaces the current page in your browser history with the URL
);
}


onAcurafourMthEOT(){
  let adobedata = {
    'Event_Metadata.action_type': 'Hyperlink',
    "Event_Metadata.action_label": "Dashboard:Hyperlink:End of Term for 4 Month below Maturity Acura Auto",
    "Event_Metadata.action_category": "Marketing Tile",
    "Page.page_name": "Dashboard"
  };
  fireAdobeEvent(adobedata, 'click-event');
  this[NavigationMixin.Navigate]({
    type: 'standard__webPage',
    attributes: {
        url: this.labels.Acura4MonthEOTURL
    }
},
false // Replaces the current page in your browser history with the URL
);
}

//RSS 53493 added by Narain Ended





}