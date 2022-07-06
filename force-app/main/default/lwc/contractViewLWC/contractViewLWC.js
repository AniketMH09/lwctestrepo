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
import {
    loadStyle
} from "lightning/platformResourceLoader";
import {
    CurrentPageReference
} from "lightning/navigation";
import {
    getConstants
} from "c/ahfcConstantUtil";
const CONSTANTS = getConstants();
export default class ContractViewLWC extends LightningElement {

    @api
    financeAccNumber;
    @api
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
    @track pdf;

    connectedCallback() {
        loadStyle(this, ahfctheme + "/theme.css").then(() => {});

    }
    isDataPresent = false;
    isCalloutError = false;
    currentPageReference = null;
    urlStateParameters = null;
    error;
    @track contractId;
    // Fetching the data from previous pages
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            if (typeof currentPageReference.state.financeAccNumber != CONSTANTS.UNDEFINED) {
                this.financeAccNumber = currentPageReference.state.financeAccNumber;
            }
            if (typeof currentPageReference.state.serAccountNickName != CONSTANTS.UNDEFINED) {
                this.serAccountNickName = currentPageReference.state.serAccountNickName;
            }

        }
        this.searchContractsMethod();
    }

    searchContractsMethod() {
        this.isloading = true;
        searchContracts({
                fID: '400026160'
            })
            .then(result => {
                this.isloading = false;
                if (result != null && result != CONSTANTS.FAILED) {

                    console.log(JSON.stringify(result));
                    if (result.validsearch && result.contractId) {
                        this.isDataPresent = true;
                        this.isCalloutError = false;
                        this.contractId = result.contractId;
                    } else {
                        this.isDataPresent = false;
                        this.isCalloutError = false;
                    }

                } else {

                    this.isDataPresent = false;
                    this.isCalloutError = true;
                }
            })
            .catch(error => {
                this.isloading = false;
                this.error = error;
                this.isCalloutError = true;
            });
    }
    navigatetoGetContracts() {
        this.isloading = true;
        getContracts({
                contractId: this.contractId
            })
            .then(result => {
                this.isloading = false;
                console.log('HereIn');
                //this.pdf = result;
                //let downloadLink = document.createElement("a");
                //downloadLink.setAttribute("type", "hidden");
                //downloadLink.href = "data:application/pdf;base64," + this.pdf;
                //downloadLink.download = 'CONTRACTS';
                //document.body.appendChild(downloadLink);
                //downloadLink.click();
                //downloadLink.remove();
                let downloadLink = document.createElement("a");
                downloadLink.href = "data:application/pdf;base64," + result;
                downloadLink.download = "filename.pdf";
                downloadLink.click();
            })
            .catch(error => {
                this.error = error;

            });
    }



}