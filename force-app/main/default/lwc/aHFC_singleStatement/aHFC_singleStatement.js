/*
@description The component aHFC_singleStatement is used to display all statements
@ author vishnu
@copyright L&T
@version 1.000
*/
import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import adobeLogo from "@salesforce/resourceUrl/Adobe_Logo";
import aHFC_singleStatementMessage from "@salesforce/label/c.aHFC_singleStatementMessage";
import documentSearch from '@salesforce/apex/AHFC_FiservIntegrationHandler.documentSearch';
import documentGet from '@salesforce/apex/AHFC_FiservIntegrationHandler.documentGet';
import fetchRecDetails from '@salesforce/apex/AHFC_SingleStatementController.fetchFinanceAccountDetails';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { fireAdobeEvent } from "c/aHFC_adobeServices";

import {
  loadStyle
} from "lightning/platformResourceLoader";

import {
  getConstants
} from "c/ahfcConstantUtil";
const CONSTANTS = getConstants();
export default class AHFC_singleStatement extends NavigationMixin(LightningElement) {

  @track pageName = 'Statements';
  @track isData = false;
  @track tableData = [];
  @track defaultDetails;
  @track showSampleStatment = false;
  brandName="";
  showNoDataPage = false;
  showErrorPage = false;
  currentPageReference = null;
  pageRef;
  accountNumber = '';
  refreshPagination = true;
  staticData;
  aHFC_singleStatementMessage = aHFC_singleStatementMessage;
  get adobeLogoUrl() {
    return adobeLogo;
  }

  returnToDashBoard() {
    console.log('123');
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: "dashboard"
      },
    });
  }

  /*
   @description get pagereference Value
   @ author vishnu
   */
  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
    this.pageRef = currentPageReference;
  }

  /*
   @description  based on the record Id prepopulating data  is fetched from apex
   @ author vishnu
   */
  getRecordValues(accId) {
    fetchRecDetails({ recID: accId }).then(result => {
      this.defaultDetails = JSON.parse(JSON.stringify(result));
      this.accountNumber = this.defaultDetails.accNo;
      console.log('defaultDetails--?', result);
      this.fetchStatementDetails();
    }).catch(error => {
      console.log('search Error', error);
      this.closePageLoader();
    });
  }

  /*
  @description opens Page loader coponent
  @ author vishnu US-11041
  */
  openPageLoader() {
    this.template
      .querySelector("c-a-h-f-c_vehicleswitcher")
      .openLoader();
  }

  /*
  @closes Page loader coponent
  @ author vishnu US-11041
  */
  closePageLoader() {
    this.template
      .querySelector("c-a-h-f-c_vehicleswitcher")
      .closeLoader();
  }

  /*
  @description webservice apex call to retrive list of statements
  @ author vishnu
  */
  fetchStatementDetails() {
    this.showNoDataPage = false;
    this.isData = false;
    this.showErrorPage = false;
    this.tableData = [];
    documentSearch({
      accountId: this.accountNumber,
      docType: 'STATEMENTS'
    })
      .then(result => {
        let getData = JSON.parse(JSON.stringify(result));
        if (getData.listSearchResults == undefined || JSON.parse(JSON.stringify(JSON.parse(JSON.stringify(result)).listSearchResults)).length == 0) {
          this.showNoDataPage = true;
          this.closePageLoader();
          console.log('Statement Page error NoData');
          return;
        }

        let data = JSON.parse(JSON.stringify(JSON.parse(JSON.stringify(result)).listSearchResults));
        this.tableData = JSON.parse(JSON.stringify(JSON.parse(JSON.stringify(result)).listSearchResults));

        var oneYearBack = new Date();
        oneYearBack.setFullYear(oneYearBack.getFullYear() - 1);
        var tempData = [];
        for (let i = 0; i < data.length; i++) {
          let a = new Date(data[i].ltrDate.replace(/(\d{4})(\d{2})(\d{2})/g, '$1-$2-$3'));
          if (Date.parse(oneYearBack) < Date.parse(a)) {
            let b = a.toLocaleString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
            this.tableData[i].key = i;
            this.tableData[i].date = b;
            if (this.tableData[i].hasOwnProperty('reprint')) {
              if (this.tableData[i].reprint == 'Y') {
                this.tableData[i].date = this.tableData[i].date + ' (Reprint)';
              }
            }
            this.tableData[i].dateParseVal = Date.parse(a);
            tempData.push(this.tableData[i]);
          }
        }
        this.tableData = tempData;
        //records available are older than one year
        if (tempData.length == 0) {
          this.showNoDataPage = true;
          this.closePageLoader();
          console.log('records available are older than one year');
          return;
        }
        this.isData = true;
        this.staticData = JSON.parse(JSON.stringify(this.tableData));
        this.totalRecords = JSON.stringify(this.staticData);
        this.refreshPagination = false;
        this.closePageLoader();
      }).catch(error => {
        this.showErrorPage = true;
        console.log('Statement Page error', error);
        this.closePageLoader();
      });
  }

  connectedCallback() {

    loadStyle(this, ahfctheme + "/theme.css").then(() => { });
    try {
      registerListener('AHFC_Account_Selected', this.getDataFromPubsubEvent, this);
    } catch (error) {
      console.log('157', error);
    }
  }

  disconnectedCallback() {
    unregisterAllListeners(this);
  }

  /*
   @description  sorting statements based on th list
   @ author vishnu
   */
  sortByDate() {
    this.staticData = this.staticData.sort((a, b) => (a.dateParseVal > b.dateParseVal) ? 1 : -1);
    this.tableData = JSON.parse(JSON.stringify(this.staticData));
    this.totalRecords = JSON.stringify(this.staticData);
    if (!this.refreshPagination) {
      this.template
        .querySelector("c-a-h-f-c_pagination")
        .handleValueChange(this.totalRecords);
    }
  }

  /*
   @description  documentview/download function
   @ author vishnu
   */
  viewTheDocument(event) {
      let adobedata = {
        'Event_Metadata.action_type': 'Button',
        "Event_Metadata.action_label": "Statements:Button:View",
        "Event_Metadata.action_category": "",
        "Page.page_name": "Statements",
        "Page.brand_name": this.brandName
    };
    fireAdobeEvent(adobedata, 'click-event');
    this.openPageLoader();
    console.log(event.target.dataset.documentid);
    let docId = event.target.dataset.documentid;
    documentGet({
      docId: docId
    }).then(result => {
      let pdf = result;
      let byteCharacters = atob(pdf);
            let byteNumbers = new Array(byteCharacters.length);
             for (let i = 0; i < byteCharacters.length; i++) {
             byteNumbers[i] = byteCharacters.charCodeAt(i);
             }
            let byteArray = new Uint8Array(byteNumbers);
            let file = new Blob([byteArray], {
                type: "application/pdf;base64"
            });
            let fileURL = URL.createObjectURL(file);
            window.open(fileURL);
            this.closePageLoader();
    }).catch(error => {
      this.closePageLoader();
      console.log('error', error);
    });
  }

  /*
   @description child event funtion for page navigation
   @ author vishnu
   */
  pageChange(event) {
    let pageItems = JSON.parse(event.detail);
    this.tableData.length = 0;
    this.tableData = this.tableData.concat(pageItems);

  }

  //pubsub function
  getDataFromPubsubEvent(data) {
    let dataValue = JSON.parse(data);
    console.log('data --> 123', JSON.parse(data));
    this.brandName = dataValue.serAccRec.Honda_Brand__c ? dataValue.serAccRec.Honda_Brand__c : '';
    console.log('data --> 123', this.brandName);
    let adobedata = {
      "Page.page_name": "Statements",
      "Page.site_section": "Statements",
      "Page.referrer_url": document.referrer,
      "Page.brand_name": this.brandName
  };
  fireAdobeEvent(adobedata, 'PageLoadReady');
    this.getRecordValues(JSON.parse(data).serAccRec.Id);
    this.isPageLoaded = true;
  }

  /*
   @description  navigation to contact us page
   @ author vishnu US 122006
   */
  NavigateToContactUsPage() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: 'contact-us-post-login'
      }
    });

  }
  openComPref() {
    let adobedata = {
      'Event_Metadata.action_type': 'Hyperlink',
      "Event_Metadata.action_label": "Statements:Hyperlink:Edit Your Comm Prefs",
      "Event_Metadata.action_category": "",
      "Page.page_name": "Statements",
      "Page.brand_name": this.brandName
  };
  fireAdobeEvent(adobedata, 'click-event');

    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: 'communicationpreference'
      }
    });
  }

  /*
   @description close sample statement model cutom event  US 7638
   @ author Sagar 

   */
  onSampleStatementModelClose(event) {
    this.showSampleStatment = event.detail;
    // this.showSampleStatement = false;
  }

  

  /*
   @description open Sample Statment US 7638
   @ author Sagar 

   */
  openSampleStatment() {
    let adobedata = {
      'Event_Metadata.action_type': 'Button',
      "Event_Metadata.action_label": "Statements:Button:View Sample Statement",
      "Event_Metadata.action_category": "",
      "Page.page_name": "Statements",
      "Page.brand_name": this.brandName
  };
  fireAdobeEvent(adobedata, 'click-event');
    this.showSampleStatment = true;
    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
  }

   /* End US-7638 */

}