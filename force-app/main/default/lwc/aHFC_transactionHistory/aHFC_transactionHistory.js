/* Component Name     :    AHFC_transactionHistory
    * Description        :    This is LWC for Transaction Tab. 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aniket                     20/05/2021              Created 
    * Akash Solanki              22/07/2021              Modified as Part of US-7781 - added navigatetostatements method
    * Akash Solanki              28/07/2021              Modified as part of US 6931 - View all transactions links to see 10 transactions.
    * Akash Solanki              26-Aug-2021             Modified as part of bug fix while switching transactions the validation errors were not getting removed. Method - clearErrorsOnSwitch
    * */
import { LightningElement, track, wire } from "lwc";
import getTransactionDetails from "@salesforce/apex/AHFC_TransactionIntegrationHandler.handletransactionhistory";
import AHFC_NoData from "@salesforce/label/c.AHFC_TransactionHistory_Label_No_Data";
import AHFC_Contract_Date_Error from "@salesforce/label/c.AHFC_TransactionHistory_Error_Contract_Date";
import AHFC_Todate_Error from "@salesforce/label/c.AHFC_TransactionHistory_Error_todate";
import AHFC_Callout_Error from "@salesforce/label/c.AHFC_TransactionHistory_Error_Callout";
import AHFC_Callout_Error_Phno from "@salesforce/label/c.AHFC_TransactionHistory_Error_Callout_Phno";
import AHFC_Sort_required from "@salesforce/label/c.AHFC_TransactionHistory_Error_Sort";
import AHFC_Future_Error from "@salesforce/label/c.AHFC_Transactionhistory_Future_Date_Error";
import { CurrentPageReference } from "lightning/navigation";
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { fireAdobeEvent } from "c/aHFC_adobeServices";

import { getConstants } from "c/ahfcConstantUtil";
import { NavigationMixin } from "lightning/navigation";
import { labels } from "c/aHFC_dashboardConstantsUtil";

const CONSTANTS = getConstants();

export default class AHFC_transactionHistory extends NavigationMixin(LightningElement) {
  @track searchValue = '';
  @track labels = labels;
  @track totalItems = "";
  defaultSortItem = CONSTANTS.mdate;
  defaultSortType = CONSTANTS.desc;
  @track refreshPagination = true;
  isDataPresent;
  //@track entries;
  @track dtfromdate;
  @track dttodate;
  @track sortSelected = '';
  @track entries = "";
  @track tableData = [];
  @track selServiceAccountWrapper;
  @track financeaccountno;
  @track contractdate;
  @track orginatedfinanceamount;
  @track isCalloutError = false;
  @track overlayClass = 'slds-hide_medium ahfc-background-lightest filter-sort-wrapper hide';
  @track pageRef;
  @track isLoaded = false;
  @track isViewAllStmts = false; //Added by Akash as part of US 6931
  @track sortMethods = [
    { value: CONSTANTS.dateasc, label: this.labels.DateAscending },
    { value: CONSTANTS.datedesc, label: this.labels.DateDescending },
    { value: CONSTANTS.totalasc, label: this.labels.TotalAscending },
    { value: CONSTANTS.totaldesc, label: this.labels.TotalDescending },
    { value: 'descasc', label: 'Description(Ascending)' },
    { value: 'descdsc', label: 'Description(Descending)' }
  ]
  // Expose the labels to use in the template.
  label = {
    AHFC_NoData,
    AHFC_Callout_Error,
    AHFC_Callout_Error_Phno
  };
  @track faq = {
    "id": "0",
    "class": "slds-accordion__section",
    "isOpened": false,
    "header": "HOW MAY I HELP YOU",

  };

  onFaqAccordionClick(event) {
    const open = "slds-accordion__section slds-is-open";
    const close = "slds-accordion__section";

    if (event.currentTarget.dataset.keyno) {
      this.faq.isOpened = !this.faq.isOpened;
      this.faq.class = (this.faq.class === open) ? close : open;
    }
  }

  searchKeyword(event) {

  }
  // Show Filter & Sort Overlay for Mobile
  onOverlayShowClick() {
    this.overlayClass = 'slds-hide_medium ahfc-background-lightest filter-sort-wrapper show'
  }

  // Hide Filter & Sort Overlay for Mobile
  onOverlayCloseClick() {
    this.overlayClass = 'slds-hide_medium ahfc-background-lightest filter-sort-wrapper hide'
  }

  // Getting the Items from Pagination for Display
  pageChange(event) {
    let pageItems = JSON.parse(event.detail);
    this.tableData.length = 0;
    this.tableData = this.tableData.concat(pageItems);
  }

  //Converting Date to PST and sending Timestamp
  getPSTDateTimeStamp(date) {
    let dateObj = new Date(date);
    return dateObj.getTime();
  }

  // Setting up Pagination
  setPaginationData(datastore) {
    let transactionsDataStore = [];
    datastore.forEach((val, index) => {
      val.key = index + 1;
      val.dateInTimestamp = this.getPSTDateTimeStamp(val.date);
      val.isDisabled = val.subEntries ? false : true;
      val.btnClass = val.subEntries
        ? "slds-button slds-button_reset table-accor-btn"
        : "slds-button slds-button_reset table-accor-btn disable-btn";
      val.linkClass = val.subEntries
        ? "ahfc-links ahfc-links-secondary table-accor-btn"
        : "ahfc-links ahfc-links-secondary table-accor-btn disable-btn";
      val.sectionClass = "slds-grid slds-wrap";
      val.isOpened = false;
      val.extrasClass = "slds-col slds-size_1-of-1 extra-details slds-hide";
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

  // Expand-Collapse Table Items
  onTableItemClick(event) {
    let item = this.tableData.findIndex((item) => {
      return item.key == event.target.dataset.keyno;
    });

    if (item != -1) {
      if (!this.tableData[item].isDisabled) {
        this.tableData[item].isOpened = !this.tableData[item].isOpened;
        this.tableData[item].extrasClass = this.tableData[item].isOpened
          ? "slds-col slds-size_1-of-1 extra-details slds-show"
          : "slds-col slds-size_1-of-1 extra-details slds-hide";
        this.tableData[item].sectionClass = this.tableData[item].isOpened
          ? "slds-grid slds-wrap ahfc-backgroud-lighter"
          : "slds-grid slds-wrap";
      }
    }
  }

  // On Sorting Table Column Click
  onSortClick(event) {
    if (this.defaultSortItem != event.target.dataset.sorttype) {
      this.defaultSortItem = event.target.dataset.sorttype;
      this.defaultSortType = CONSTANTS.desc;
    } else {
      this.defaultSortType = this.defaultSortType == CONSTANTS.desc ? CONSTANTS.asc : CONSTANTS.desc;
    }

    this.sortItems(JSON.parse(this.totalItems));
  }

  // Sorting Items
  sortItems(dataItems) {
    console.log('xxx', this.defaultSortItem);
    console.log('yyy', this.defaultSortType);
    const key = this.defaultSortItem + this.defaultSortType;
    console.log('key', key);
    switch (key) {
      case CONSTANTS.totalasc:
        dataItems.sort((a, b) => {
          return a.amount - b.amount;
        });
        break;
      case CONSTANTS.totaldesc:
        dataItems.sort((a, b) => {
          return b.amount - a.amount;
        });
        break;
      case CONSTANTS.dateasc:
        dataItems.sort((a, b) => {
          return new Date(a.date).getTime() > new Date(b.date).getTime()
            ? 1
            : -1;
        });
        break;
      case CONSTANTS.datedesc:
        dataItems.sort((a, b) => {
          return new Date(a.date).getTime() > new Date(b.date).getTime()
            ? -1
            : 1;
        });
        break;
      case 'descasc':
        dataItems.sort((a, b) => {
          return a.description > b.description ? 1 : -1;
        });
        break;
      case 'descdsc':
        dataItems.sort((a, b) => {
          return a.description > b.description ? -1 : 1;
        });
        break;
    }
    this.setPaginationData(dataItems);
  }
  //On page loads
  connectedCallback() {
    console.log('Inside connected callback!!!!');
    try {
      registerListener('AHFC_Account_Selected', this.getDataFromPubsubEvent, this);
    } catch (error) {
      console.log('157', error);
    }
  }

  //on page un-loads
  disconnectedCallback() {
    unregisterAllListeners(this);
  }

  //pubsub function
  getDataFromPubsubEvent(data) {
    console.log('232', JSON.parse(data));
    this.handleMessage(JSON.parse(data));
  }



  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
    this.pageRef = currentPageReference;
  }

  //handles the message from message channel
  handleMessage(message) {
    console.log('message------>', message);

    this.selServiceAccountWrapper = message;
    this.financeaccountno =
      typeof this.selServiceAccountWrapper.serAccRec
        .Finance_Account_Number__c != CONSTANTS.UNDEFINED
        ? this.selServiceAccountWrapper.serAccRec.Finance_Account_Number__c
        : "";
    this.contractdate = this.selServiceAccountWrapper.dtContractdate;
    console.log('this.contractdate-----> ' + this.contractdate);
    this.dtfromdate = this.subtractMonths(this.selServiceAccountWrapper.datToday);
    if (typeof this.contractdate != CONSTANTS.UNDEFINED) {
      this.dtfromdate = this.valid_date(this.contractdate, this.dtfromdate)
        ? this.dtfromdate
        : this.contractdate;
    }
    this.dttodate = this.selServiceAccountWrapper.datToday;
    this.gettransactionhistorylist();
    this.clearErrorsOnSwitch(); // Added by Akash as part of Bug fix
  }

  //set Sort Selection Value
  onSortSelection(event) {
    let inputfieldSort = this.template.querySelector(`[data-id="${CONSTANTS.sortcombo}"]`);
    inputfieldSort.setCustomValidity('');
    inputfieldSort.reportValidity();
    this.sortSelected = event.detail.value;
  }

  //Checks the transaction history on selected date ranges
  ondatechange() {
    let inputfield = this.template.querySelector(`[data-id="todate"]`);
    if (
      this.valid_date(this.dtfromdate, this.dttodate) === true &&
      (this.valid_date(this.contractdate, this.dtfromdate) === true ||
        typeof this.selServiceAccountWrapper.dtContractdate == CONSTANTS.UNDEFINED) && (this.dttodate <= this.selServiceAccountWrapper.datToday) // last condition added as part of US 6931
    ) {
      this.gettransactionhistorylist();
    }
  }

  //Checks the transaction history on selected date ranges Mobile
  ondatechangemobile() {
    if (this.sortSelected) {
      if (
        this.valid_date(this.dtfromdate, this.dttodate) === true &&
        (this.valid_date(this.contractdate, this.dtfromdate) === true ||
          typeof this.selServiceAccountWrapper.dtContractdate == CONSTANTS.UNDEFINED)
        && (this.dttodate <= this.selServiceAccountWrapper.datToday)
      ) {
        switch (this.sortSelected) {
          case CONSTANTS.dateasc: this.defaultSortItem = CONSTANTS.mdate;
            this.defaultSortType = CONSTANTS.asc;
            break;
          case CONSTANTS.datedesc: this.defaultSortItem = CONSTANTS.mdate;
            this.defaultSortType = CONSTANTS.desc;
            break;
          case CONSTANTS.totalasc: this.defaultSortItem = CONSTANTS.total;
            this.defaultSortType = CONSTANTS.asc;
            break;
          case CONSTANTS.totaldesc: this.defaultSortItem = CONSTANTS.total;
            this.defaultSortType = CONSTANTS.desc;
            break;
          case 'descasc': this.defaultSortItem = 'desc';
            this.defaultSortType = 'asc';
            break;
          case 'descdsc': this.defaultSortItem = 'desc';
            this.defaultSortType = 'dsc';
            break;
        }
        this.gettransactionhistorylist();
        this.onOverlayCloseClick();
      }
    } else {
      let inputfieldSort = this.template.querySelector(`[data-id="${CONSTANTS.sortcombo}"]`);
      inputfieldSort.setCustomValidity(AHFC_Sort_required);
      inputfieldSort.reportValidity();
    }
  }

  //on date changes
  handleDateChange(event) {
    let field_name = event.target.name;
    let inputfield = this.template.querySelector(`[data-id="${field_name}"]`);
    let inputfield1 = this.template.querySelector(`[data-id="${CONSTANTS.FROMDATE}"]`);
    let inputfield2 = this.template.querySelector(`[data-id="${CONSTANTS.TODATE}"]`);
    let contracterror = AHFC_Contract_Date_Error.replace('{0}', this.formatnumdate(this.contractdate));

    inputfield1.setCustomValidity("");
    inputfield2.setCustomValidity("");
    inputfield1.reportValidity();
    inputfield2.reportValidity();
    inputfield.setCustomValidity("");
    if (field_name == CONSTANTS.FROMDATE) {
      this.dtfromdate = event.target.value;
      if (!typeof this.dtfromdate != CONSTANTS.UNDEFINED && this.dtfromdate !== null) {
        console.log('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx--  1', this.valid_date(this.dtfromdate, this.dttodate));
        let inputfield1 = this.template.querySelector(`[data-id="${CONSTANTS.FROMDATE}"]`);
        if (!this.valid_date(this.dtfromdate, this.dttodate)) {
          inputfield1.setCustomValidity(AHFC_Todate_Error);
          inputfield1.reportValidity();
          return;
        }
      }
    }
    if (field_name == CONSTANTS.TODATE) {
      this.dttodate = event.target.value;
      console.log('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx--  2', this.valid_date(this.dtfromdate, this.dttodate));
      if (!this.valid_date(this.dtfromdate, this.dttodate)) {
        inputfield1.setCustomValidity(AHFC_Todate_Error);
        inputfield1.reportValidity();
        return;
      }

    }
    if (typeof this.selServiceAccountWrapper.dtContractdate != CONSTANTS.UNDEFINED) {
      //console.log('373', this.valid_date(this.contractdate, this.dtfromdate));
      if (!this.valid_date(this.contractdate, this.dtfromdate)) {
        inputfield1.setCustomValidity(contracterror);
        inputfield1.reportValidity();
        return;

      }

    }
    console.log(this.selServiceAccountWrapper.datToday);
    if (this.dttodate > this.selServiceAccountWrapper.datToday) {

      inputfield2.setCustomValidity(AHFC_Future_Error);
      inputfield2.reportValidity();
      return;
    }
    //Added by Akash as part of US 6931 starts
    /* if (field_name == CONSTANTS.TODATE) {
       this.dttodate = event.target.value;
       if (this.dttodate > this.selServiceAccountWrapper.datToday) {
         inputfield.setCustomValidity(AHFC_Future_Error);
       } 
     }*/
    //  inputfield.reportValidity();
    //   console.log('Inside Last')
    //    this.toDateSmallerValidation(this.dttodate, CONSTANTS.FROMDATE);
  }

  toDateSmallerValidation(toDateDesktop, field_name) {
    console.log('xxxxxxxxxxxxxxxsssssssssssssssssssss');
    let inputfield = this.template.querySelector(`[data-id="${CONSTANTS.FROMDATE}"]`);
    let toDate = new date(toDateDesktop);
    let fromDate = new date(this.dtfromdate);
    if (field_name == CONSTANTS.FROMDATE) {
      console.log('132213213toDateDesktop' + toDateDesktop);
      console.log('132213213AHFC_Todate_Error' + this.dtfromdate);
      console.log('132213213AHFC_Todate_Errorhhhhhhhhhhhhhhhhhhhhh' + toDateDesktop < this.dtfromdate);
      if (toDate < fromDate) {
        console.log('132213213sssssssssssss');
        inputfield.setCustomValidity(AHFC_Todate_Error);
      }
    }
    inputfield.reportValidity();
  }
  //Added by Akash as part of US 6931 Ends

  //on date changes in Mobile Overlay
  handleDateChangeMob(event) {
    let field_name = event.target.name;
    let inputfield = this.template.querySelector(`[data-id="${field_name}"]`);
    let inputfield1 = this.template.querySelector(`[data-id="${CONSTANTS.fromdatemob}"]`);
    let inputfield2 = this.template.querySelector(`[data-id="${CONSTANTS.todatemob}"]`);
    let contracterror = AHFC_Contract_Date_Error.replace('{0}', this.formatnumdate(this.contractdate));

    inputfield1.setCustomValidity('');
    inputfield2.setCustomValidity('');
    inputfield1.reportValidity();
    inputfield2.reportValidity();
    inputfield.setCustomValidity('');
    //console.log('367', inputfield);
    if (field_name == CONSTANTS.fromdatemob) {
      this.dtfromdate = event.target.value;

      if (typeof this.dtfromdate != CONSTANTS.UNDEFINED && this.dtfromdate !== null) {
        if (!this.valid_date(this.dtfromdate, this.dttodate)) {
          inputfield1.setCustomValidity(AHFC_Todate_Error);
          inputfield1.reportValidity();
          return;
        }
      }
    }
    if (field_name == CONSTANTS.todatemob) {
      this.dttodate = event.target.value;
      if (!this.valid_date(this.dtfromdate, this.dttodate)) {
        inputfield1.setCustomValidity(AHFC_Todate_Error);
        inputfield1.reportValidity();
        return;
      }

    }

    //console.log('371', contracterror);
    if (typeof this.selServiceAccountWrapper.dtContractdate != CONSTANTS.UNDEFINED) {
      //console.log('373', this.valid_date(this.contractdate, this.dtfromdate));
      if (!this.valid_date(this.contractdate, this.dtfromdate)) {
        inputfield1.setCustomValidity(contracterror);
        inputfield1.reportValidity();
        return;

      }

    }
    if (this.dttodate > this.selServiceAccountWrapper.datToday) {
      inputfield2.setCustomValidity(AHFC_Future_Error);
      inputfield2.reportValidity();
      return;
    }

    //Added by Akash as part of US 6931 starts
    /* if (field_name == CONSTANTS.todatemob) {
       this.dttodate = event.target.value;
       if (this.dttodate > this.selServiceAccountWrapper.datToday) {
         inputfield.setCustomValidity(AHFC_Future_Error);
       } else {
         inputfield.setCustomValidity("");
       }
     }
     inputfield.reportValidity();
     this.toDateSmallerValidationMob(this.dttodate, CONSTANTS.fromdatemob);*/
  }

  toDateSmallerValidationMob(toDateMob, field_name) {
    let inputfield = this.template.querySelector(`[data-id="${CONSTANTS.fromdatemob}"]`);
    if (field_name == CONSTANTS.fromdatemob) {
      if (toDateMob < this.dtfromdate) {
        inputfield.setCustomValidity(AHFC_Todate_Error);
      }
    }
    inputfield.reportValidity();
  }
  //Added by Akash as part of US 6931 Ends

  //validates dates which are greater and retruns true or false
  valid_date(sdate, edate) {
    /* edate = new Date(edate);
     sdate = new Date(sdate);
     edate = new Date(edate.getTime() + edate.getTimezoneOffset() * 60 * 1000);
     sdate = new Date(sdate.getTime() + sdate.getTimezoneOffset() * 60 * 1000);
     return edate >= sdate;*/

    let endDate = new Date(edate);
    let startDate = new Date(sdate);
    endDate = new Date(endDate.getTime() + endDate.getTimezoneOffset() * 60 * 1000);
    startDate = new Date(startDate.getTime() + startDate.getTimezoneOffset() * 60 * 1000);
    return endDate >= startDate;
  }

  //format date to mm/dd/yyyy
  formatnumdate(dt) {
    let formatdate = new Date(dt);
    if (formatdate != CONSTANTS.INVALID_DATE) {
      formatdate = new Date(formatdate.getTime() + formatdate.getTimezoneOffset() * 60 * 1000);
      const options = { month: '2-digit', day: '2-digit', year: 'numeric' };
      formatdate = formatdate.toLocaleString("en-US", options);
      return formatdate;
    } else {
      return "";
    }
  }

  //Subtracts the today date from 6 months
  subtractMonths(dt) {
    let fromdate = new Date(dt);
    fromdate = new Date(fromdate.getTime() + fromdate.getTimezoneOffset() * 60 * 1000);
    fromdate.setMonth(fromdate.getMonth() - 3);
    return new Date(fromdate).toLocaleDateString('en-CA');
  }
  @track alldata = [];
  //Get list of transaction details through API Call
  gettransactionhistorylist() {
    this.isLoaded = true;
    getTransactionDetails({
      strFinanceAccount: this.financeaccountno,
      // strFinanceAccount: '00000444549136',
      dtfromdate: this.dtfromdate,
      dttodate: this.dttodate
    })
      .then((result) => {

        this.isLoaded = false;
        console.log('result->>', result);
        if (result == 'invalid access') {
          this.navigatetodashboard();
          return;
        }
        if (result !== null && result != CONSTANTS.FAILED) {
          this.isCalloutError = false;
          let parsedresult = JSON.parse(result);
          let dataStore = parsedresult.entries;
          console.log('464', dataStore);
          this.entries = JSON.parse(result);
          this.formattedentries = this.formatentries(this.entries.entries);
          this.alldata = dataStore;
          this.isDataPresent = dataStore.length > 0 ? true : false;
          this.refreshPagination = true;
          this.sortItems(dataStore);
        } else {
          this.isDataPresent = false;
          this.isCalloutError = true;
        }
      })
      .catch((error) => {
        this.isLoaded = false;
        this.isCalloutError = true;
        console.log(error);

      });
  }

  //export the transaction history items to CSV
  exportlist() {
    // call the function which returns the CSV data as a String
    let newData = [];
    console.log('487', this.tableData);
    console.log('488', this.alldata);
    this.formattedentries = this.formatentries(JSON.parse(JSON.stringify(this.alldata)));
    for (let i = 0; i < this.formattedentries.length; i++) {
      let item = {};
      item.date = this.formattedentries[i].date;
      item.description = this.formattedentries[i].description;
      item.total = this.formattedentries[i].amount;
      item.subEntries = this.formattedentries[i].subEntries;
      newData.push(item);

    }
    let csv = this.convertListToCSV(newData);
    if (csv === null) {
      return;
    }

    let blob = new Blob([csv], { type: 'application/octet-stream' });
    // Create a temporal <a> html tag to download the CSV file
    let hiddenElement = document.createElement("a");
    hiddenElement.href = URL.createObjectURL(blob);
    hiddenElement.download = this.labels.Tranasactionlabel;
    hiddenElement.dataset.downloadurl = ['application/octet-stream', hiddenElement.download, hiddenElement.href].join(',');
    document.body.appendChild(hiddenElement); //Required for FireFox browser
    hiddenElement.click(); // using click() js function to download csv file
    document.body.removeChild(hiddenElement);
  }

  //this method is used to format the date and amount
  formatentries(datastore) {
    let transactiondata = [];
    datastore.forEach((val, index) => {
      val.date = this.formatDate(val.date);
      val.amount = this.formatCurrency(val.amount);
      if (val.subEntries !== null) {
        val.subEntries.forEach((subval, i) => {
          subval.amount = this.formatCurrency(subval.amount);
        });
      }
      transactiondata.push(val);
    });
    return transactiondata;
  }

  //used to convert the number to currency format 
  formatCurrency(curNumber) {
    if (typeof curNumber != CONSTANTS.UNDEFINED && curNumber !== "" && curNumber !== 0) {
      let formatter = new Intl.NumberFormat("en-US", {
        style: "currency",
        currency: "USD",
        maximumFractionDigits: 2
      });
      return formatter.format(curNumber);
    }
    else if (curNumber === 0) {
      return "0.00";
    } else {
      return "";
    }
  }

  //used to convert the date format to Ex:20 Sep,2020
  formatDate(dt) {
    let formatdate = new Date(dt);

    if (formatdate !== CONSTANTS.INVALID_DATE) {
      const options = { year: "numeric", month: "short", day: "2-digit" };
      return formatdate.toLocaleString("en-US", options);
    } else {
      return "";
    }
  }

  //Convert the itemlist to comma separted values
  convertListToCSV(sObjectList) {
    if (sObjectList === null || sObjectList.length == 0) {
      return null;
    }

    // CSV file parameters.
    let columnEnd = ",";
    let lineEnd = "\n";

    // Get the CSV header from the list.
    let keys = new Set();
    sObjectList.forEach(function (record) {
      Object.keys(record).forEach(function (key) {
        keys.add(key);
      });
    });

    keys = Array.from(keys);
    let rowkeys = Array.from(keys);
    rowkeys.splice(keys.length - 1, 1);
    var csvString = "";
    csvString += rowkeys.join(columnEnd);
    csvString = csvString.toUpperCase();
    csvString += lineEnd;

    for (let i = 0; i < sObjectList.length; i++) {
      let counter = 0;
      for (let sTempkey in keys) {
        let skey = keys[sTempkey];
        // add , after every value except the first.
        if (counter > 0) {
          csvString += columnEnd;
        }
        // If the column is undefined, leave it as blank in the CSV file.
        let value = sObjectList[i][skey] === null ? "" : sObjectList[i][skey];
        if (typeof value == this.labels.OBJECT) {
          for (let j = 0; j < value.length; j++) {
            let subkeys = new Set();
            Object.keys(value[j]).forEach(function (key) {
              subkeys.add(key);
            });
            subkeys = Array.from(subkeys);
            csvString += lineEnd;
            csvString += '"' + "" + '"';
            csvString += columnEnd;
            let subcounter = 0;
            for (let sTempkey in subkeys) {
              if (subcounter > 0) {
                csvString += columnEnd;
              }
              let skey = subkeys[sTempkey];
              let subvalue = value[j][skey] === null ? "" : value[j][skey];
              csvString += '"' + subvalue + '"';
              subcounter++;
            }
          }
        } else {
          csvString += '"' + value + '"';
        }
        counter++;
      }
      csvString += lineEnd;
    }

    return csvString;
  }




  //Navigates to Dashboard Page
  navigatetodashboard() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: 'dashboard'
      }
    });
  }
  // Added by Aakash as Part of US 7781
  //Navigates to Statement Page
  navigatetostatements() {
    let adobedata = {
      'Event_Metadata.action_type': 'Button',
      "Event_Metadata.action_label": "Payment Activity:Button:View Statements",
      "Event_Metadata.action_category": "Transaction History"
  };
  fireAdobeEvent(adobedata, 'click-event');
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: 'singlestatement'
      }
    });
  }
  //Added by Akash as part of US 6931 starts
  showViewAllStatements() {
    let inputfield1 = this.template.querySelector(`[data-id="todate"]`);
    let inputfield2 = this.template.querySelector(`[data-id="todatemob"]`);
    let inputfield3 = this.template.querySelector(`[data-id="fromdate"]`);
    let inputfield4 = this.template.querySelector(`[data-id="fromdatemob"]`);
    this.isViewAllStmts = true;
    if (this.selServiceAccountWrapper.dtContractdate !== null) {
      this.dtfromdate = this.selServiceAccountWrapper.dtContractdate;
      this.dttodate = this.selServiceAccountWrapper.datToday;
      this.ondatechange();
      this.ondatechangemobile();
      inputfield1.setCustomValidity("");
      inputfield2.setCustomValidity("");
      inputfield3.setCustomValidity("");
      inputfield4.setCustomValidity("");
      inputfield1.reportValidity();
      inputfield2.reportValidity();
      inputfield3.reportValidity();
      inputfield4.reportValidity();
    } else {
      this.dtfromdate = this.subtractMonths(this.selServiceAccountWrapper.datToday);
      this.dttodate = this.selServiceAccountWrapper.datToday;
      this.ondatechange();
      this.ondatechangemobile();
      inputfield1.setCustomValidity("");
      inputfield2.setCustomValidity("");
      inputfield3.setCustomValidity("");
      inputfield4.setCustomValidity("");
      inputfield1.reportValidity();
      inputfield2.reportValidity();
      inputfield3.reportValidity();
      inputfield4.reportValidity();
    }
  }
  //Added by Akash as part of US 6931 starts

  // Added by Akash as part of Bug fix starts
  clearErrorsOnSwitch() {
    let inputfield1 = this.template.querySelector(`[data-id="todate"]`);
    let inputfield2 = this.template.querySelector(`[data-id="todatemob"]`);
    let inputfield3 = this.template.querySelector(`[data-id="fromdate"]`);
    let inputfield4 = this.template.querySelector(`[data-id="fromdatemob"]`);
    inputfield1.setCustomValidity("");
    inputfield2.setCustomValidity("");
    inputfield3.setCustomValidity("");
    inputfield4.setCustomValidity("");
    inputfield1.reportValidity();
    inputfield2.reportValidity();
    inputfield3.reportValidity();
    inputfield4.reportValidity();
  }
  // Added by Akash as part of Bug fix Ends.

}