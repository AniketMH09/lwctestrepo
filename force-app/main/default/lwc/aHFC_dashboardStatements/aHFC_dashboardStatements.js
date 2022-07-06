/*
COMPONENT NAME  : AHFC_dashboardStatements 
AUTHOR          : Akash Solanki
CREATED DATE    : 10-MAY-2021
MODIFICATION LOG
----------------      
MODIFIED DATE   : 10-JUN-2021                                   MODIFIED BY : Akash Solanki
DETAILS         : Bug - 6771 Fix
*/
import { LightningElement, track, api, wire } from 'lwc';
import adobeLogo from "@salesforce/resourceUrl/Adobe_Logo";
import documentSearch from '@salesforce/apex/AHFC_FiservIntegrationHandler.documentSearch';
import documentGet from '@salesforce/apex/AHFC_FiservIntegrationHandler.documentGet';
import AHFC_Dashboard_Statements_AccountId from "@salesforce/label/c.AHFC_Dashboard_Statements_AccountId";
import { NavigationMixin } from 'lightning/navigation';
import AHFC_Dashboard_Statements_DocType from "@salesforce/label/c.AHFC_Dashboard_Statements_DocType";
import getFinannceAccountHandler from "@salesforce/apex/AHFC_EditFinanceAccount.getFinanceAccountDetails";
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import commPrefEligible from "@salesforce/apex/AHFC_CommunicationPreference.commPrefDetail";
import { fireAdobeEvent } from "c/aHFC_adobeServices";

export default class AHFC_dashboardStatements extends NavigationMixin(LightningElement) {

    get adobeLogoUrl() {
        return adobeLogo;
    }

    @track objects = [];
    @track error;
    @track documentId;
    @track isLoaded = true;
    @track pdf;
    @api finaccid;
    @track finAccData;
    @track finalFinAccId;
    @track accno;
    @track serviceAccountWrapper;
    @track eDeliveryFlagVisible = true;
    @track finAccIdCommPref = '';
    @track adobebrand = '';

    /* Developer Name: Akash Solanki
        Connected Call back will call AHFC_FiservIntegrationHandler apex class's documentSearch Method to get the letter dates & documentId related to them.
        Params  accountId - Finance account Id, docType - Type of document whether it is a statement or letter  
        */

    connectedCallback() {

        this.setdata(this.finaccid);

        documentSearch({
            accountId: this.accno,
            docType: AHFC_Dashboard_Statements_DocType
        })
            .then(result => {
                this.objects = this.processData(result.listSearchResults);

            })
            .catch(error => {
                this.error = error;
            });
        this.checkCommPrefs(this.finAccIdCommPref);
    }

    // Added by Aakash as part of Bug Fix - 13930
    checkCommPrefs(finId) {
        commPrefEligible({
            finid: finId
        })
            .then(result => {
                console.log('result of dashboard statements------> ', result.commPrefDetails.Statements_Letters__c);
                if (result.commPrefDetails.Statements_Letters__c === 'eDelivery') {

                    this.eDeliveryFlagVisible = false;
                }
                else {
                    this.eDeliveryFlagVisible = true;
                }
            })
            .catch(error => {
                this.error = error;
                //Record access check exception handling - Supriya Chakraborty 17-Nov-2021
                if(error.body.message == 'invalid access'){
                    this[NavigationMixin.Navigate]({
                        type: "comm__namedPage",
                        attributes: {
                            pageName: "dashboard"
                        }
                    });
                }
            });
    }

    // Added by Akash as part of Bug 13930
    navigatetocommpreff() {
        sessionStorage.setItem('salesforce_id', JSON.parse(this.finaccid).serAccRec.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'communicationpreference'
            }
        });
    }


    //API function getting value of the Finance account number from the carousel change in Main dashboard.

    @api handleValueChange(data) {

        //   this.isLoaded = false;
        this.setdata(data);
        documentSearch({
            accountId: this.accno,
            docType: AHFC_Dashboard_Statements_DocType
        })
            .then(result => {
                console.log('error result0000000000000000', result);
                this.objects = this.processData(result.listSearchResults);
                this.isLoaded = true;

            })
            .catch(error => {
                console.log('error 000000000000000000000000000', error);
                this.error = error;
                this.isLoaded = true;
            });
        this.checkCommPrefs(this.finAccIdCommPref);
    }

    setdata(wrapper) {
        this.serviceAccountWrapper = JSON.parse(wrapper);
        this.adobebrand = this.serviceAccountWrapper.serAccRec.Honda_Brand__c ? this.serviceAccountWrapper.serAccRec.Honda_Brand__c : '';
            console.log('this.serviceAccountWrapper ', this.serviceAccountWrapper)
        this.accno = this.serviceAccountWrapper.serAccRec.Finance_Account_Number__c;
        console.log('this.accno-----> ', this.accno);
        this.finAccIdCommPref = this.serviceAccountWrapper.serAccRec.Id;
        console.log('this.finAccIdCommPref-----> ', this.finAccIdCommPref);
    }


    processData(data) {
        console.log('23213213213', data);
        let recList = [];
        if (data == null || data == '') {
            let rec = {
                label: "No recent statements",
                value: '',
            }
            console.log('23213213213');
            recList.push(rec);
        } else {
            var statementData = [];
            for (let i = 0; i < data.length; i++) {
                let dateString = data[i].ltrDate.substr(0, 4) + '-' + data[i].ltrDate.substr(4, 2) + '-' + data[i].ltrDate.substr(6, 4);
                let dateConversion = new Date(dateString);
                let statementRecData = {};
                statementRecData.documentId = data[i].documentId;
                statementRecData.ltrDate = data[i].ltrDate;
                statementRecData.reprint = data[i].reprint;

                let currentDate = new Date();
                let sixMonthsBackDate = currentDate.setMonth(currentDate.getMonth() - 6);

                statementRecData.dateParseVal = Date.parse(dateConversion);
                console.log('dateString', dateConversion);
                console.log('statementRecData.dateParseVal', statementRecData.dateParseVal);
                console.log('sixMonthsBackDate', sixMonthsBackDate);
                if (statementRecData.dateParseVal > sixMonthsBackDate) {
                    statementData.push(statementRecData);
                }
                //statementData.push(statementRecData);
            }
            /* 6699 changes done here*/
            statementData = statementData.sort((a, b) => (a.dateParseVal < b.dateParseVal) ? 1 : -1);
            console.log('000000000000000000000001', statementData);
            let dataLength = statementData.length;
            let totalDisplayCount = 6;
            if (dataLength < 6) {
                totalDisplayCount = dataLength;
            }
            for (let i = 0; i < totalDisplayCount; i++) {

                let dateString = statementData[i].ltrDate.substr(0, 4) + '-' + statementData[i].ltrDate.substr(4, 2) + '-' + statementData[i].ltrDate.substr(6, 4);
                let dateConversion = new Date(dateString);

                let finalFormatteddate = dateConversion.toLocaleString('default', {
                    month: 'short'
                }) + ' ' + dateConversion.getDate() + ', ' + dateConversion.getFullYear();
                if (statementData[i].hasOwnProperty('reprint')) {
                    if (statementData[i].reprint == 'Y') {
                        finalFormatteddate = finalFormatteddate + ' (Reprint)';
                    }
                }
                /* 6699 changes ends here*/
                let rec = {
                    label: finalFormatteddate,
                    value: statementData[i].documentId,
                }

                recList.push(rec);

            }
            console.log('recList', recList);
            if (recList.length < 1) {
                let rec = {
                    label: "No recent statements",
                    value: '',
                }
                console.log('23213213213');
                recList.push(rec);
            }
            console.log('23213213213');
        }
        return recList;
    }

    get options() {
        return this.objects;
    }

    downloadreader() {
        let adobedata = {
            'Event_Metadata.action_type': 'Download',
            "Event_Metadata.action_label": "Dashboard:Hyperlink:Download Acrobat",
            "Event_Metadata.action_category": "Statements Tile",
            "Page.page_name": "Dashboard",
            "Page.brand_name": this.adobebrand
        };
        fireAdobeEvent(adobedata, 'click-event');
    }
    navigateToStatementPage() {


        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Dashboard:Hyperlink:View All Statements",
            "Event_Metadata.action_category": "Statements Tile",
            "Page.page_name": "Dashboard",
            "Page.brand_name": this.adobebrand
        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('salesforce_id', JSON.parse(this.finaccid).serAccRec.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "singlestatement"
            }
        });
    }

    /* Developer Name: Akash Solanki
    This method call AHFC_FiservIntegrationHandler apex class's documentGet Method to get actual pdf document
    Params  docId - document Id of the selected letter date coming from documentSearch webservice in the connected callback.
    */

    onMonthSelection(event) {
        const selectedOption = event.detail.value;
        // this.isLoaded = false;
        if (selectedOption !== '') {
            documentGet({
                docId: selectedOption
            }).then(result => {
                this.documentId = result;
                this.pdf = result;
                let byteCharacters = atob(this.pdf);
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
                this.isLoaded = !this.isLoaded;

            })
                .catch(error => {
                    this.error = error;
                    this.isLoaded = !this.isLoaded;
                });
        }
    }


    renderedCallback() {

    }

}