/*@description The component aHFC_PayoffCalendar is used to display all payoff or prchase calender
@ author vishnu
@copyright L&T
@version 1.000
*/

import {
  LightningElement,
  wire,
  track
} from 'lwc';
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import handlePayoffInfoData from '@salesforce/apex/AHFC_PayOffInfoIntegrationHandler.handlePayoffInfo';
import fetchFinanceAccountDetails from '@salesforce/apex/AHFC_PayoffCalendarController.fetchFinanceAccountDetails';
import AHFC_Topic_Id_PayoffPurchase from "@salesforce/label/c.AHFC_Topic_Id_PayoffPurchase";
import {
  loadStyle
} from "lightning/platformResourceLoader";


import {
  CurrentPageReference,
  NavigationMixin
} from 'lightning/navigation';

import {
  label
} from "c/aHFC_payoffCalendarUtil";

import { registerListener, unregisterAllListeners } from 'c/pubsub';
import {fireEvent} from 'c/pubsub'; 
import { fireAdobeEvent } from "c/aHFC_adobeServices";


export default class AHFC_PayoffCalendar extends NavigationMixin(LightningElement) {
  pageRef;
  isPageLoaded;
  currentPageReference = null;
  @track recordData;
  @track label = label;
  @track changeStyle = false;
  @track showPopUp = false;
  @track firstBar = false;
  @track SecondBar = false;
  @track thirdBar = false;
  @track isAccTypeBalloon = false;
  brandName = '';

  accDetails = {};
  isAccClosed = false;
  isAcc500 = false;
  isAccHappyPath = false;
  isPayOff = false;
  isPurchase = false;
  goodThroughDate;
  defaultDetails;
  findDealer;
  recordDataSelectedDate;
  goodThroughDateSelectedDate;


  get className() {
      //if changeStle is true, getter will return class1 else class2
      return this.changeStyle ? 'class1' : 'slds-checkbox_faux';
  }
  navigateToPayoffArticlePage(){
    let origin = window.location.origin;
    let URLpart1 = origin+'/s/';
    let URLTORedirect = URLpart1+AHFC_Topic_Id_PayoffPurchase;
    window.location.href = URLTORedirect ;
  }

  /*get good throug date from webservice based to calender selection*/
  handleSelectedDate(event) {
    /*let adobedata = {
        'Event_Metadata.action_type': 'Calendar',
        "Event_Metadata.action_label": "Payoff Calendar:Calendar:Date Select",
        "Event_Metadata.action_category": "",
        "Page.page_name": "Payoff/Purchase Calendar",
        "Page.brand_name": this.brandName
    };
    fireAdobeEvent(adobedata, 'click-event');*/
    this.openPageLoader()
      var SelectedDate = event.detail.selectedDateInChild;
      console.log(SelectedDate,'SelectedDate');
      this.fetchPayoffInfo(SelectedDate).then(result => {
          this.recordDataSelectedDate = result;
          if (!(this.recordDataSelectedDate == null || this.recordDataSelectedDate == undefined || this.recordDataSelectedDate == {})) {
              this.goodThroughDateSelectedDate = Date.parse(this.recordDataSelectedDate.goodThruDate);
          } else {
              console.log('webservice Data Error');
              this.showWebserviceFailureError = true;
          }
          this.closePageLoader();
      }).catch(error => {
        this.closePageLoader();
        this.showWebserviceFailureError = true;
          console.log('search Error', error);
      });

  }
  closeToast() {
    this.showWebserviceFailureError = false;
    }
  /* get record id from url*/
  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
    this.pageRef = currentPageReference;
  }
  clearVariables(){
    this.showWebserviceFailureError = false;
    this.defaultDetails = undefined;
    this.isAcc500 = false;  
    this.isPayOff = false; 
    this.isPurchase = false;  
    this.isAccClosed = false;
    this.isAccHappyPath = false;
    this.isAccTypeBalloon = false;
    this.findDealer = undefined; 
    this.recordData = undefined;
    this.recordDataSelectedDate = undefined;
    this.goodThroughDate  = undefined;
    this.goodThroughDateSelectedDate = undefined;
  }
  /* get default record values*/
  getRecordValues(accId) {
        this.clearVariables();
      fetchFinanceAccountDetails({
          recID: accId
      }).then(result => {
          
          this.defaultDetails = JSON.parse(JSON.stringify(result));
          this.isAcc500 = this.defaultDetails.isAcc500;
          this.isPayOff = this.defaultDetails.isPayOff;
          this.isPurchase = this.defaultDetails.isPurchase;
          this.isAccClosed = this.defaultDetails.isAccClosed;
          this.isAccTypeBalloon = this.defaultDetails.isAccTypeBalloon;
          this.isAccHappyPath = this.defaultDetails.isAccHappyPath;
          if (this.defaultDetails.isHonda) {
              if (this.defaultDetails.productType == 'Auto') {
                  this.findDealer = this.label.HONDA_AUTO;
              } else if (this.defaultDetails.productType == 'Powersports') {
                  this.findDealer = this.label.HONDA_POWERSPORTS;
              } else if (this.defaultDetails.productType == 'Marine') {
                  this.findDealer = this.label.HONDA_MARINE;
              } else if (this.defaultDetails.productType == 'Power Equipment') {
                  this.findDealer = this.label.HONDA_POWEREQUIPMENT;
              } else {
                  this.findDealer = this.label.HONDA_AUTO;
              }
          } else if (this.defaultDetails.isAcura) {
              if (this.defaultDetails.productType == 'Auto') {
                  this.findDealer = this.label.ACURA_AUTO;
              }
          } else {
              this.findDealer = this.label.HONDA_AUTO;
          }

          if (this.isAcc500) {
            this.closePageLoader();
              return;
          }

          var today = new Date();
          var todayDate = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();

          var result = this.fetchPayoffInfo(todayDate).then(result => {
              this.recordData = result;
              this.recordDataSelectedDate = this.recordData;
              if (!(this.recordData == null || this.recordData == undefined || this.recordData == {})) {
                  this.goodThroughDate = Date.parse(this.recordData.goodThruDate);
                  this.goodThroughDateSelectedDate = this.goodThroughDate;
              } else {
                  console.log('webservice Data Error');
                  this.showWebserviceFailureError = true;
              }
              this.closePageLoader();
          });
      }).catch(error => {
         //Record access check exception handling - Supriya Chakraborty 11-Nov-2021
         if(error.body.message == 'invalid access'){
            this.returnToDashBoard();
        }
        this.closePageLoader();
        this.showWebserviceFailureError = true;
          console.log('search Error', error);
      });
  }

  /* call webservice apex class to get pament info*/
  fetchPayoffInfo(effectiveDate) {
    this.showWebserviceFailureError = false;
      var retVal =
          handlePayoffInfoData({
              strFinanceAccount: this.defaultDetails.accNo,
              dtChargeOffDate: null,
              dtEffectiveDate: new Date(effectiveDate)
          }).then(result => {
              return JSON.parse(result);
          })
          .catch(error => {
              console.log('search Error', error);
          });
      return retVal;
  }
  

  handleChange(event) {
      this.changeStyle = event.target.checked;
  }

  /*on submit click navigate make to payment page*/
  handleSubmitClick() {
    let adobedata = {
        'Event_Metadata.action_type': 'Button',
        "Event_Metadata.action_label": "Payoff Calendar:Button:Submit Payoff",
        "Event_Metadata.action_category": "",
        "Page.page_name": "Payoff/Purchase Calendar",
        "Page.brand_name": this.brandName
    };
    fireAdobeEvent(adobedata, 'click-event');
     /* if (!this.isAccTypeBalloon) {
          this.navigatetoPaymentPage();
      } else {
          this.showPopUp = true;
      }*/
      this.navigatetoPaymentPage();
  }
  
  onCancel() {
      this.showPopUp = false;
  }

  acceptContinue() {
      this.navigatetoPaymentPage();
  }

  printCurrentPage() {
 //   cAHFC_Community_Theme_Detail_Page
  //  var printWindow = window.open('', '', 'height=400,width=800');
  //  printWindow.print()
     window.print();

  }

  navigatetoPaymentPage() {
      this[NavigationMixin.Navigate]({
          type: "comm__namedPage",
          attributes: {
              pageName: "make-a-payment"
          },
          state: {
              sacRecordId: this.defaultDetails.accId,
              payOff: true

          }
      });

  }
  returnToDashBoard() {
      this[NavigationMixin.Navigate]({
          type: "comm__namedPage",
          attributes: {
              pageName: "dashboard"
          },
      });
  }
  renderedCallback(){
    try {
    let firstClass = this.template.querySelector(".main-content");
    fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));	
    } catch (error) {
    console.log('157', error);
    }
}
  connectedCallback() {
   /* let adobedata = {
        "Page.page_name": "Payoff Calender"
    };
    fireAdobeEvent(adobedata, 'PageLoadReady');*/
      loadStyle(this, ahfctheme + "/theme.css").then(() => {});
      try {
        registerListener('AHFC_Account_Selected', this.getDataFromPubsubEvent, this);
    } catch (error) {
        console.log('157', error);
    }
  }
  disconnectedCallback() {
    unregisterAllListeners(this);
}
  //pubsub function for get values from vehicle Switcher
    getDataFromPubsubEvent(data) {
    let dataValue = JSON.parse(data);
    this.brandName = dataValue.serAccRec.Honda_Brand__c ? dataValue.serAccRec.Honda_Brand__c : '';
    let adobedata = {
        "Page.page_name": "Payoff/Purchase Calendar",
        "Page.site_section": "Payoff/Purchase Calendar",
        "Page.referrer_url": document.referrer,
        "Page.brand_name": this.brandName
    };
    fireAdobeEvent(adobedata, 'PageLoadReady');
    this.getRecordValues(JSON.parse(data).serAccRec.Id);
    this.isPageLoaded = true;
   
}

/*
  @description opens Page loader coponent
  @ author vishnu US-11041
*/
openPageLoader(){
    this.template
    .querySelector("c-a-h-f-c_vehicleswitcher")
    .openLoader();
}


/*
  @closes Page loader coponent
  @ author vishnu US-11041
  */
closePageLoader(){
    this.template
    .querySelector("c-a-h-f-c_vehicleswitcher")
    .closeLoader();
}

}