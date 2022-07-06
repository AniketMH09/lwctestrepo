/* Component Name        :    AHFC_supportRequest
    * Description        :    This is LWC for track support request list Page. 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Edwin                      18/08/2021              Created 
*/
import { LightningElement, track } from 'lwc';
import fetchSupportRequests from '@salesforce/apex/AHFC_SupportRequestController.fetchSupportRequests';
import {
    loadStyle
} from "lightning/platformResourceLoader";
import {
    getConstants
} from "c/ahfcConstantUtil";
const CONSTANTS = getConstants();
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import { NavigationMixin } from "lightning/navigation";
import { fireEvent } from 'c/pubsub';
import { fireAdobeEvent } from "c/aHFC_adobeServices";
export default class AHFC_supportRequest extends NavigationMixin(LightningElement) {

    @track pageName = '';
    @track isData = false;
    @track tableData = [];
    @track defaultDetails;
    @track isDataAvailable = false;
    @track isLoaded = true;
    @track isError = false;
    @track defaultSortItem = 'date';
    @track defaultSortType = 'desc';
    @track totalRecords = [];
    @track finAccId;
    showErrorPage = false;
    currentPageReference = null;
    pageRef;
    accountNumber = '';
    refreshPagination = false;
    @track staticData = [];
    @track sortSelected = '';
    @track sortMethods = [
        { value: 'caseNumberasc', label: 'Case Number (Ascending)' },
        { value: 'caseNumberdesc', label: 'Case Number (Decending)' },
        { value: 'caseTitleasc', label: 'Alphabetical (A-Z)' },
        { value: 'caseTitledesc', label: 'Alphabetical (Z-A)' }
    ]

    connectedCallback() {
        console.log('###Support Request=====> connectedCallback');
        let adobedata = {
            "Page.page_name": "Track Requests",
            "Page.site_section": "Track Requests",
            "Page.referrer_url": document.referrer,
            // "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
        try {
            this.getSupportRequests();
        } catch (error) {
            this.isError = true;
            console.log('Error in connectedCallback():', error);
        }
    }


    /*
    @description apex call to retrive list of cases
    @ author edwin
    */
    getSupportRequests() { 
        this.isLoaded = false;       
        this.showErrorPage = false;
        this.tableData = [];
        this.totalRecords = [];
        console.log('Session value, financeAccId:', sessionStorage.getItem('financeAccId'));
        this.finAccId = sessionStorage.getItem('financeAccId');
        fetchSupportRequests({
            finAccId : this.finAccId
        })
            .then(result => {
                console.log('xx>>',result)
                if (result == undefined || JSON.parse(JSON.stringify(result)).length == 0) {
                    this.isLoaded = true; 
                    console.log('NoData');
                    this.isData = false;
                    return;
                }
                console.log('########## result >>>>' + JSON.stringify(result));
                this.isData = true;
                this.tableData = JSON.parse(JSON.stringify(result));

                for (let i = 0; i < this.tableData.length; i++) {
                    this.tableData[i].LastModifiedDate = this.formatDate(this.tableData[i].LastModifiedDate);
                    this.tableData[i].CreadtedDate_DateOnly__c = this.formatDate(this.tableData[i].CreadtedDate_DateOnly__c);
                    if(this.tableData[i].Type === 'Document Sharing'){
                        this.tableData[i].Status = '-';
                    }
                }
                this.staticData = JSON.parse(JSON.stringify(this.tableData));
                console.log('########## staticData >>>>' + JSON.stringify(this.staticData));

                this.totalRecords = JSON.stringify(this.tableData);
                this.isDataAvailable = true;
                this.refreshPagination = false;
                this.isLoaded = true;

            }).catch(error => {
                console.log('yyy>>', error);
                this.isLoaded = false;
                // this.showErrorPage = true;
                this.isError = true;
                console.log('Support request Page error', error);

            });
            console.log('qqq>>')
    }
    pageChange(event) {
        console.log('Inside pageChange');
        let pageItems = JSON.parse(event.detail);
        this.tableData.length = 0;
        this.tableData = this.tableData.concat(pageItems);
    }

    onSortSelection(event) {
        this.sortItems(event.target.value);
    }

    // On Sorting Table Column Click
    onSortClick(event) {
        if (this.defaultSortItem != event.target.dataset.sorttype) {
            this.defaultSortItem = event.target.dataset.sorttype;
            this.defaultSortType = 'desc';
        } else {
            this.defaultSortType = this.defaultSortType == 'desc' ? 'asc' : 'desc';
        }
        const key = this.defaultSortItem + this.defaultSortType;
        this.sortItems(key);
    }

    // Sorting Items
    sortItems(key) {
        switch (key) {
            case 'caseNumberasc':
                this.staticData.sort((a, b) => (a.CaseNumber > b.CaseNumber) ? 1 : -1);
                break;

            case 'caseNumberdesc':
                this.staticData.sort((a, b) => (a.CaseNumber < b.CaseNumber) ? 1 : -1);
                break;

            case 'caseTitleasc':
                this.staticData.sort((a, b) => (a.Type > b.Type) ? 1 : -1);
                break;

            case 'caseTitledesc':
                this.staticData.sort((a, b) => (a.Type < b.Type) ? 1 : -1);
                break;

            case 'caseStatusasc':
                this.staticData.sort((a, b) => (a.Status > b.Status) ? 1 : -1);
                break;

            case 'caseStatusdesc':
                this.staticData.sort((a, b) => (a.Status < b.Status) ? 1 : -1);
                break;

            case 'lastModifiedasc':
                this.staticData.sort((a, b) => (a.LastModifiedDate > b.LastModifiedDate) ? 1 : -1);
                break;

            case 'lastModifieddesc':
                this.staticData.sort((a, b) => (a.LastModifiedDate < b.LastModifiedDate) ? 1 : -1);
                break;

            case 'submissionDateasc':
                this.staticData.sort((a, b) => (a.CreadtedDate_DateOnly__c > b.CreadtedDate_DateOnly__c) ? 1 : -1);
                break;

            case 'submissionDatedesc':
                this.staticData.sort((a, b) => (a.CreadtedDate_DateOnly__c < b.CreadtedDate_DateOnly__c) ? 1 : -1);
                break;

            case 'financeAccasc':
                this.staticData.sort((a, b) => (a.Finance_Account__c > b.Finance_Account__c) ? 1 : -1);
                break;

            case 'financeAccdesc':
                this.staticData.sort((a, b) => (a.Finance_Account__c < b.Finance_Account__c) ? 1 : -1);
                break;
        }
        this.setPaginationData(this.staticData);
    }

    setPaginationData() {
        this.tableData = JSON.parse(JSON.stringify(this.staticData));
        this.totalitems = JSON.stringify(this.tableData);
        if (!this.refreshPagination) {
            this.template
                .querySelector("c-a-h-f-c_pagination")
                .handleValueChange(this.totalitems);
        }
    }

    /*
    @description: format date field
    @ author edwin
    */
    formatDate(dt) {
        var formatdate = new Date(dt);
        formatdate = new Date(formatdate.getTime() + formatdate.getTimezoneOffset() * 60 * 1000);
        if (formatdate !== CONSTANTS.INVALID_DATE) {
            const options = {
                year: "numeric",
                month: "short",
                day: "numeric"
            };
            return formatdate.toLocaleDateString("en-US", options);
        } else {
            return "";
        }
    }



    // Navigate to View Case details page
    viewSupportRequestDetails(event) {
        let recId = event.target.dataset.recordId;
        sessionStorage.setItem('supportRequestId', recId);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recId,
                objectApiName: 'Case',
                actionName: 'view'
            },
        });
    }

}