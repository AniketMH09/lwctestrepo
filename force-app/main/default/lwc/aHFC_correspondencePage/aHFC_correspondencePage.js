/* Component Name        :    AHFC_correspondencePage
    * Description        :    This is LWC for Correspondence Page. 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aniket                     07/06/2021              Created 
*/

import { LightningElement, track, api, wire } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import { NavigationMixin } from "lightning/navigation";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import documentSearch from '@salesforce/apex/AHFC_FiservIntegrationHandler.documentSearch';
import documentGet from '@salesforce/apex/AHFC_FiservIntegrationHandler.documentGet';
import nameSearch from '@salesforce/apex/AHFC_CorrespondenceHandler.nameSearch';
import adobeLogo from "@salesforce/resourceUrl/Adobe_Logo";
import { fireAdobeEvent } from "c/aHFC_adobeServices";

import AHFC_Correspondence_Document from "@salesforce/label/c.AHFC_Correspondence_Document";
import AHFC_Correspondence_Document_Name from "@salesforce/label/c.AHFC_Correspondence_Document_Name";
import AHFC_Correspondence_DATE_RECEIVED from "@salesforce/label/c.AHFC_Correspondence_DATE_RECEIVED";
import AHFC_Correspondence_ACTIONS from "@salesforce/label/c.AHFC_Correspondence_ACTIONS";
import AHFC_Correspondence_VIEW from "@salesforce/label/c.AHFC_Correspondence_VIEW";
import AHFC_Correspondence_No_Documents from "@salesforce/label/c.AHFC_Correspondence_No_Documents";
import AHFC_Correspondence_No_data from "@salesforce/label/c.AHFC_Correspondence_No_data";
import AHFC_Correspondence_Download_reader from "@salesforce/label/c.AHFC_Correspondence_Download_reader";
import Correspondance_Iterator_Number from "@salesforce/label/c.Correspondance_Iterator_Number"; 
import { CurrentPageReference } from "lightning/navigation";//Added by Prabu for the US - 10475

import { registerListener, unregisterAllListeners, fireEvent } from 'c/pubsub';



export default class AHFC_correspondencePage extends NavigationMixin(LightningElement) {
  @track tableData = [];
  @track isCalloutDone = false;
  @track codelList = [];
  @track totalRecords = "";
  @track refreshPagination = true;
  @track isLoaded = false;
  @track isData = false;
  @track sortSelected = "";
  @track accClosed = false;
  @track finid = "";
  @track isPageLoaded = false;
  @track isError = true;
  @track pageRef;
  @track sortMethods = [
    { value: "dateasc", label: "Date (Ascending)" },
    { value: "datedesc", label: "Date (Decending)" },
    { value: "nameasc", label: "Alphabetical (A-Z)" },
    { value: "nameasc", label: "Alphabetical (Z-A)" }
  ];

  defaultSortItem = "date";
  defaultSortType = "desc";
  labels = {
    AHFC_Correspondence_Document: AHFC_Correspondence_Document,
    AHFC_Correspondence_Document_Name: AHFC_Correspondence_Document_Name,
    AHFC_Correspondence_DATE_RECEIVED: AHFC_Correspondence_DATE_RECEIVED,
    AHFC_Correspondence_ACTIONS: AHFC_Correspondence_ACTIONS,
    AHFC_Correspondence_VIEW: AHFC_Correspondence_VIEW,
    AHFC_Correspondence_No_Documents: AHFC_Correspondence_No_Documents,
    AHFC_Correspondence_No_data: AHFC_Correspondence_No_data,
    AHFC_Correspondence_Download_reader: AHFC_Correspondence_Download_reader,
    Correspondance_Iterator_Number: Correspondance_Iterator_Number
  };
  
  onSortSelection(event) {
    this.sortItems(JSON.parse(this.totalRecords), event.target.value);
  }
  get adobeLogoUrl() {
    return adobeLogo;
  }
  // to check if user enrolled or not
  @wire(nameSearch)
  wiredData(result) {
    if (result.data) {
      this.codelList = JSON.parse(JSON.stringify(result.data));
    } else {
      console.log("error", result.error);
    }
  }

  // To get fin account id.
  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
    this.pageRef = currentPageReference;
  }
  /*renderedCallback() {
    let firstClass = this.template.querySelector(".main-content");
    fireEvent(this.pageRef, "MainContent", firstClass.getAttribute("id"));
  }*/
  @track brand = "";
  // getting thr tabel data for correspondce
  handleMessage(data) {
    console.log("data ->>", data);
    this.isCalloutDone = false;
    this.isData = false;
    this.tableData = [];
    this.isError = false;
    this.isLoaded = true;
    let adobedata = {
      "Page.page_name": "Correspondence",
      "Page.site_section": "Correspondence",
      "Page.referrer_url": document.referrer,
      "Page.brand_name": data.serAccRec.Honda_Brand__c
        ? data.serAccRec.Honda_Brand__c
        : ""
    };
    fireAdobeEvent(adobedata, "PageLoadReady");

    this.brand = data.serAccRec.Honda_Brand__c
      ? data.serAccRec.Honda_Brand__c
      : "";
    documentSearch({
      accountId: data.serAccRec.Finance_Account_Number__c,
      // accountId: '00000444549136',
      docType: "LETTERS"
    })
      .then((result) => {
        console.log("122", result);
        this.isLoaded = false;
        this.isError = false;
        this.isCalloutDone = true;
        let getData = JSON.parse(JSON.stringify(result));
        //console.log('127>>',this.template.querySelector("c-a-h-f-c_communication-prefernce"))
        //this.template.querySelector("c-a-h-f-c_communication-prefernce").getEmailData(this.finid);
        if (
          getData.listSearchResults == undefined ||
          getData.listSearchResults.length == 0
        ) {
          return;
        }
        console.log("132");

        let data = JSON.parse(JSON.stringify(result)).listSearchResults;
        let tableData = JSON.parse(JSON.stringify(result)).listSearchResults;
        let newtableData = [];
        for (let i = 0; i < data.length; i++) {
          //data[i].aria = data[i].name + 'View';
          let a = new Date(
            data[i].ltrDate.replace(/(\d{4})(\d{2})(\d{2})/g, "$1-$2-$3")
          );
          console.log("xxx>>", data[i]);
          let b = a.toLocaleString("en-US", {
            month: "short",
            day: "numeric",
            year: "numeric"
          });
          tableData[i].newDate = b;
          tableData[i].key = i;
          
          const obj = this.codelList.find(
            (row) => row.Code__c.toUpperCase() == data[i].letterId.toUpperCase()
          );
          if (obj != undefined) {
            tableData[i].name = obj.Description__c;
            tableData[i].aria = obj.Description__c +' '+ 'View';
            newtableData.push(tableData[i]);
          }
        }
        console.log("149>>>");
        let date = new Date();
        date.setFullYear(date.getFullYear() - 1);
        date.setHours(0, 0, 0, 0);
        this.tableData = newtableData.filter(
          (o) => new Date(o.newDate) >= date
        );
        if (this.tableData.length > 0) {
          this.isData = true;
        }
        console.log("this.tableData", this.tableData);
        this.totalRecords = JSON.stringify(this.tableData);
        this.refreshPagination = false;
      })
      .catch((error) => {
        if (error.body.message == "invalid access") {
          this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
              pageName: "dashboard"
            }
          });
        }
        console.log("154");
        this.isLoaded = false;
        this.isCalloutDone = true;
        this.isError = true;
        console.log("line number error>>>", error);
      });
  }

  connectedCallback() {
    try {
      registerListener(
        "AHFC_Account_Selected",
        this.getDataFromPubsubEvent,
        this
      );
    } catch (error) {
      console.log("157", error);
    }

    loadStyle(this, ahfctheme + "/theme.css").then(() => {});
  }
  disconnectedCallback() {
    unregisterAllListeners(this);
  }

  //pubsub function
  getDataFromPubsubEvent(data) {
    this.accClosed = false;
    this.handleMessage(JSON.parse(data));
    this.finid = JSON.parse(data).serAccRec.Id;

    let sacRec = JSON.parse(data).serAccRec;
    if (
      sacRec.hasOwnProperty("AHFC_Web_Manage_Comm_Pref__c") &&
      sacRec.AHFC_Web_Manage_Comm_Pref__c == "NE"
    ) {
      this.accClosed = true;
    }
    this.isPageLoaded = true;
    setTimeout(() => {
      console.log(
        "127>>",
        this.template.querySelector("c-a-h-f-c_communication-prefernce")
      ),
        this.template
          .querySelector("c-a-h-f-c_communication-prefernce")
          .getEmailData(this.finid);
    }, 2000);
  }

  // Getting the Items from Pagination for Display
  pageChange(event) {
    let pageItems = JSON.parse(event.detail);
    this.tableData.length = 0;
    this.tableData = this.tableData.concat(pageItems);
  }

  // On Sorting Table Column Click
  onSortClick(event) {
    if (this.defaultSortItem != event.target.dataset.sorttype) {
      this.defaultSortItem = event.target.dataset.sorttype;
      this.defaultSortType = "desc";
    } else {
      this.defaultSortType = this.defaultSortType == "desc" ? "asc" : "desc";
    }

    const key = this.defaultSortItem + this.defaultSortType;
    console.log("219", key);
    this.sortItems(JSON.parse(this.totalRecords), key);
  }

  // Sorting Items
  sortItems(dataItems, key) {
    switch (key) {
      case "namedesc":
        dataItems.sort((a, b) => {
          console.log("230", a.name);
          return a.name < b.name ? -1 : 1;
        });
        break;
      case "nameasc":
        dataItems.sort((a, b) => {
          return b.name > a.name ? 1 : -1;
        });
        break;
      case "dateasc":
        dataItems.sort((a, b) => {
          return new Date(a.newDate).getTime() > new Date(b.newDate).getTime()
            ? 1
            : -1;
        });
        break;
      case "datedesc":
        dataItems.sort((a, b) => {
          return new Date(a.newDate).getTime() > new Date(b.newDate).getTime()
            ? -1
            : 1;
        });
        break;
    }
    this.setPaginationData(dataItems);
  }

  // Setting up Pagination
  setPaginationData(datastore) {
    let transactionsDataStore = [];
    datastore.forEach((val, index) => {
      val.key = index + 1;
      transactionsDataStore.push(val);
    });
    this.totalItems = JSON.stringify(transactionsDataStore);
    if (!this.refreshPagination) {
      this.template
        .querySelector("c-a-h-f-c_pagination")
        .handleValueChange(this.totalItems);
    } else {
      setTimeout(() => {
        this.refreshPagination = false;
      }, 100);
    }
  }
  downloadadobe() {
    let adobedata = {
      "Event_Metadata.action_type": "Hyperlink",
      "Event_Metadata.action_label":
        "Correspondence:Hyperlink:Download Acrobat Reader",
      "Event_Metadata.action_category": "",
      "Page.page_name": "Correspondence",
      "Page.brand_name": this.brand
    };
    fireAdobeEvent(adobedata, "click-event");
  }

  // downloading the document
  onViewClick(event) {
    let adobedata = {
      "Event_Metadata.action_type": "Button",
      "Event_Metadata.action_label": "Correspondence:Button:View",
      "Event_Metadata.action_category": "",
      "Page.page_name": "Correspondence",
      "Page.brand_name": this.brand
    };
    fireAdobeEvent(adobedata, "click-event");
    let docId = event.target.dataset.documentid;
    documentGet({
      docId: docId
    }).then((endata) => {
      let pdf = endata;
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
      //this.isLoaded = !this.isLoaded;
    });
  }

  renderedCallback() {
    let arr = document.getElementsByTagName("svg");
    console.log("arr", arr);
    for (let i = 0; i < arr.length; i++) {
      arr[i].setAttribute("role", "img");
    }
    let firstClass = this.template.querySelector(".main-content");
    setTimeout(() => {
      fireEvent(this.pageRef, "MainContent", firstClass.getAttribute("id"));
    }, 1000);
  }
}