/*
COMPONENT NAME  : ContractViewLWC - contract view page
AUTHOR          : LTI - Satish LOKININDI.
CREATED DATE    : 31-05-2021
MODIFICATION LOG
----------------      
MODIFIED DATE   :                                       MODIFIED BY :
DETAILS         :
*/
import {
    LightningElement,
    api,
    wire,
    track
} from 'lwc';
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import HondaLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import acuraLogo from "@salesforce/resourceUrl/AHFC_Acura_Header_Logo";
import carSvg from "@salesforce/resourceUrl/AHFC_Honda_Header_Car";
import adobeLogo from "@salesforce/resourceUrl/Adobe_Logo";
import AHFC_Header_AccountNumber from "@salesforce/label/c.AHFC_Header_AccountNumber";
import searchContracts from '@salesforce/apex/AHFC_ContractViewIntegrationHandler.searchContracts';
import getContracts from '@salesforce/apex/AHFC_ContractViewIntegrationHandler.getContracts';
import { NavigationMixin } from "lightning/navigation";
import {
    loadStyle
} from "lightning/platformResourceLoader";
import {
    CurrentPageReference
} from "lightning/navigation";
import {
    getConstants
} from "c/ahfcConstantUtil";
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { fireAdobeEvent } from "c/aHFC_adobeServices";

const CONSTANTS = getConstants();
export default class AHFC_ContractViewLWC extends NavigationMixin (LightningElement) {

    @track
    financeAccNumber;
    @track
    serAccountNickName;
    isloading;
    get hondaLogoUrl() {
        return HondaLogo;
    }

    get acuraLogoUrl() {
        return acuraLogo;
    }

    get carImage() {
        return carSvg;
    }
    get adobeLogoUrl() {
        return adobeLogo;
    }
    label = {

        AHFC_Header_AccountNumber

    };

    isDataPresent = false;
    isCalloutError = false;
    currentPageReference = null;
    urlStateParameters = null;
    error;
    @track contractId;
    @track pageRef;
    connectedCallback() {

        registerListener('AHFC_Account_Selected', this.getDataFromPubsubEvent, this);

        loadStyle(this, ahfctheme + "/theme.css").then(() => { });

    }
    disconnectedCallback() {
        unregisterAllListeners(this);
    }
    @track adobedatanew = {};
    //pubsub function
    getDataFromPubsubEvent(data) {
        this.searchContractsMethod(JSON.parse(data));
        this.adobedatanew = JSON.parse(data);
        let adobedata = {
            "Page.page_name": "Contract",
            "Page.site_section": "Contract",
            "Page.referrer_url": document.referrer,
            "Page.brand_name": this.adobedatanew.serAccRec.Honda_Brand__c ? this.adobedatanew.serAccRec.Honda_Brand__c : '',
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        console.log('xyz--')
    }
    // Fetching the data from previous pages
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {

        this.pageRef = currentPageReference;
    }

    searchContractsMethod(data) {
        this.isloading = true;
        console.log(data);
        searchContracts({
            fID: data.serAccRec.Finance_Account_Number__c
            //fID: '00000444549136'
        })
            .then(result => {
                console.log('searchContractsMethod, Result: '+JSON.stringify(result));
                this.isloading = false;
                if (result != null && result != CONSTANTS.FAILED) {
                    if (result.validSearch && result.contractId) {
                        this.isDataPresent = true;
                        this.isCalloutError = false;
                        this.contractId = result.contractId;
                    } else {
                        this.isDataPresent = false;
                        this.isCalloutError = false;
                    }

                } else {
                    console.log('ElseCondition')
                    this.isCalloutError = true;
                }
            })
            .catch(error => {
                console.log('Errorrss-->',error);
                //Record access check exception handling - Supriya Chakraborty 11-Nov-2021
                if(error.body.message == 'invalid access'){
                    this[NavigationMixin.Navigate]({
                        type: "comm__namedPage",
                        attributes: {
                            pageName: "dashboard"
                        }
                    });
                }
                this.isloading = false;
                this.error = error;
                this.isCalloutError = true;
            });
    }
    navigatetoGetContracts() {
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Contract:Button:View your contract",
            "Event_Metadata.action_category": "",
            "Page.page_name": "Contract",
            "Page.brand_name": this.adobedatanew.serAccRec.Honda_Brand__c ? this.adobedatanew.serAccRec.Honda_Brand__c : '',
        };
        fireAdobeEvent(adobedata, 'click-event');
        this.isloading = true;
        getContracts({
            contractId: this.contractId
        })
            .then(result => {
                this.isloading = false;
                let downloadLink = document.createElement("a");
                downloadLink.href = "data:application/pdf;base64," + result;
                downloadLink.download = "Contract.pdf";
                downloadLink.click();
            })
            .catch(error => {
                this.error = error;

            });
    }

    navigatetoContactUs(){
        console.log("Unknown error");
        this[NavigationMixin.Navigate]({
          type: "comm__namedPage",
          attributes: {
            pageName: "contact-us-post-login"
          }
        });
      }
}