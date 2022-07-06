/* Component Name        :    AHFC_supportRequestDetails
    * Description        :    This is LWC for track support request details Page. 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Edwin                      18/08/2021              Created 
*/
import { LightningElement, track, wire } from 'lwc';
import fetchSupportRequestDetails from '@salesforce/apex/AHFC_SupportRequestController.fetchSupportRequestDetails';
import {
    loadStyle
} from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import {
    getConstants
} from "c/ahfcConstantUtil";
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation'
import { fireAdobeEvent } from "c/aHFC_adobeServices";
const CONSTANTS = getConstants();
export default class AHFC_supportRequestDetails extends NavigationMixin(LightningElement) {
    @track caseType;
    @track isLeaseExtension = false;
    @track isDueDateChange = false;
    @track isDocumentSharing = false;
    @track recId;
    @track requestDetails;
    @track caseObj = [];
    @track currentMaturityDate;
    @track requestedDueDate;
    @track isDataLoaded = false;
    @track createdDate;
    @track currentDueDate;
    @track isLoaded = true;
    @track requestedMonths;
    @track urlId;
    @track isData = true;

    connectedCallback() {
        let adobedata = {
            "Page.page_name": "Case Detail",
            "Page.site_section": "Case Detail",
            "Page.referrer_url": document.referrer,
            // "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
        console.log('Session value:', sessionStorage.getItem('supportRequestId'));
        if (sessionStorage.getItem('supportRequestId') != null) {
            this.recId = sessionStorage.getItem('supportRequestId');
        }
        console.log('recId:', this.recId);     

    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            console.log('Id from url: ' + currentPageReference.attributes.recordId);
            this.urlId = currentPageReference.attributes.recordId;
        }
        this.getRecordDetails();
    }

    /*
    @description: apex call to retrive case details
    @ author edwin
    */
    getRecordDetails() {
        try {
            this.isLoaded = false;
            let caseRecId = this.urlId === CONSTANTS.UNDEFINED? this.recId: this.urlId;
            console.log('caseRecId: '+caseRecId);
            fetchSupportRequestDetails({
                caseId: caseRecId
            })
                .then(result => {
                                        
                    if (result !== null) {                        
                        this.isData =true;
                        this.requestDetails = result;
                        console.log('Easypay: ', this.requestDetails.easyPay);
                        console.log('Result: ', JSON.stringify(result));
                        this.caseObj = result.supportCase;

                        this.createdDate = this.formatDate(this.caseObj.CreatedDate) + ', ' + this.formatDateTime(this.caseObj.CreatedDate);
                        if (this.caseObj.Type === 'Document Sharing') {
                            this.isDocumentSharing = true;
                        }
                        if (this.caseObj.Type === 'Lease Extension') {
                            this.isLeaseExtension = true;
                            this.currentMaturityDate = this.formatDate(this.caseObj.Maturity_Date__c);
                            console.log('this.requestedMonths: ' + this.caseObj.Requested_Months__c);
                            this.requestedMonths = this.caseObj.Requested_Months__c != CONSTANTS.UNDEFINED ? this.caseObj.Requested_Months__c + ' Months' : '';

                        }
                        if (this.caseObj.Type === 'Due Date Change') {
                            let requestedDueDateInt = parseInt(this.caseObj.Requested_Next_Due_Date_Day__c);
                            let currentDueDateInt =parseInt(this.caseObj.Finance_Account__r.Due_On_Day__c) ;
                            console.log('Due date Change');
                            this.isDueDateChange = true;
                            this.requestedDueDate = this.setDateValue(requestedDueDateInt);
                            this.currentDueDate = this.setDateValue(currentDueDateInt);
                            console.log('requestedDueDate:' + this.requestedDueDate);
                            console.log('currentDueDate:' + this.currentDueDate);
                        }
                    }
                    else{
                       this.isData =false; 
                    }
                    this.isLoaded = true;
                });
            this.isDataLoaded = true;
            // this.isLoaded = true;
        }
        catch (ex) {
            this.isLoaded = true;
            console.log('Exception insoide supprtReuestDetails, Ex:', ex);

        }

    }
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

    formatDateTime(dt) {
        var time = new Date(dt);
        console.log(
            time.toLocaleString('en-US', { hour: 'numeric', minute: 'numeric', hour12: true })
        );
        return time.toLocaleString('en-US', { hour: 'numeric', minute: 'numeric', hour12: true });
    }

    setDateValue(dateValue) {
        var dayString = '';
        if (typeof dateValue !== CONSTANTS.UNDEFINED) {
            if (dateValue == 1 || dateValue == 21 || dateValue == 31) {
                dayString = dateValue + 'st of the month';
            } else if (dateValue == 2 || dateValue == 22) {
                dayString = dateValue + 'nd of the month';
            } else if (dateValue == 3 || dateValue == 23) {
                dayString = dateValue + 'rd of the month';
            } else {
                dayString = dateValue + 'th of the month';
            }
        }
        return dayString;
    }
    navigateToDashboard() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "dashboard"
            }
        });
    }

}