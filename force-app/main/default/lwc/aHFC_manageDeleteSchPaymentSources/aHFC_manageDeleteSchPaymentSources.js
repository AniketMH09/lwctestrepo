/*Component Name      :    AHFC_manageDeleteSchPaymentSources
    * @description        :    This Component is used to display schedule payment page
    * Modification Log   :   
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Satish                     14/07/2021              Created

*********************************************************************************/
import {
    LightningElement,
    track,
    wire
} from "lwc";
import {
    CurrentPageReference
} from "lightning/navigation";
import { fireEvent } from 'c/pubsub';
import {
    NavigationMixin
} from "lightning/navigation";
import {
    loadStyle
} from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import deleteSchPaymentSource from "@salesforce/apex/AHFC_ManagePaymentSourceClass.deleteSchPaymentSource";
import updatePaymentsDeleteSources from "@salesforce/apex/AHFC_ManagePaymentSourceClass.updatePaymentsDeleteSources";
import getPaymentSource from "@salesforce/apex/AHFC_ManagePaymentSourceClass.getPaymentSource";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
//import searchDetPaymentSource from "@salesforce/apex/AHFC_ManagePaymentSourceClass.searchDetPaymentSource";
export default class AHFC_manageDeleteSchPaymentSources extends NavigationMixin(LightningElement) {

    currentPageReference = null;
    urlStateParameters = null;
    @track bankAccId;
    @track paySourceNickName;
    @track paySourceAccNumber;
    @track paySourceBank;
    @track paySourceAccType;
    @track paySourceAccId;
    @track mapPaymentDetails = [];
    @track mapPaymentDetailsval = [];
    @track isModalOpen = false;
    @track isDeleteModalOpen = false;
    @track paySourceDetails = [];
    @track items = [];
    @track value = '';
    @track sacRecordId;
    @track pSourceId;
    @track paymentRec;
    //bug fix 15414 edwin
    @track finAccId;
    @track showAddNewPaymentSourceLink = true;
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            if (typeof currentPageReference.state.psId != "undefined") {
                this.bankAccId = currentPageReference.state.psId;
            }

        }
    }

    @wire(CurrentPageReference) pageRef;

    renderedCallback() {

        let firstClass = this.template.querySelector(".main-content");
        fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
        console.log('firstClass.getAttribute-----> ', firstClass.getAttribute('id'));
    }

    connectedCallback() {
        let adobedata = {
            "Page.page_name": "Manage Shedulde Payments",
            "Page.site_section": "Manage Shedulde Payments",
            "Page.referrer_url": document.referrer,
            // "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
        console.log('this.salesforce_id>>>>>>>>>>' + sessionStorage.getItem('salesforce_id'));
        //bug fix 15414 edwin starts
        this.finAccId = sessionStorage.getItem('salesforce_id');
        if (this.finAccId) {
            this.getAllPaymentSource();
        }
        //bug fix 15414 edwin ends

        if (this.bankAccId)
            this.onDeletepaymentSource();
    }

    getAllPaymentSource() {
        getPaymentSource({
            sacRecId: this.finAccId

        }).then((result) => {
            console.log('getPaymentSource>>>>>result' + JSON.stringify(result));
            if (result) {
                if (result.length >= 4) {
                    console.log('getPaymentSource>>>>>result.length' + result.length);
                    this.showAddNewPaymentSourceLink = false;
                }
            }
        })
            .catch((error) => {
                console.log('Error while fetching payment list' + error);
            });
    }

    get options() {
        return this.items;
    }
    openmodal(event) {
        this.sacRecordId = event.target.dataset.fid;
        this.paymentRec = event.target.dataset.id;
        this.isModalOpen = true;
        const scrollOptions = {
            left: 0,
            top: 0,
            behavior: "smooth"
        };
        window.scrollTo(scrollOptions);
    }
    onNewPaymentModalClose(event) {
        this.isModalOpen = event.detail;

    }
    savePaymentSource(event) {
        let flag = event.detail.paymentAddedStatus;
        let bank = event.detail.personName;
        let ls4 = event.detail.accLast4;
        let payId = this.paymentRec;
    
        if (flag) {            
            this.pSourceId = '';
            this.revokePaySource(bank, payId);          
         /*   console.log(' this.pSourceId>>>>>>>>>>>'+ this.pSourceId);
            console.log(' this.payId>>>>>>>>>>>'+ payId);
            this.getAllPaymentSource();
            for (var i = 0; i < this.mapPaymentDetailsval.length; i++) {
                for (var j = 0; j < this.mapPaymentDetailsval[i].value.length; j++) {
                    console.log('this.mapPaymentDetailsval[i].value[j].Id >>>>>>>>>>>'+this.mapPaymentDetailsval[i].value[j].Id );
                    if (this.mapPaymentDetailsval[i].value[j].Id === payId) {
                        this.mapPaymentDetailsval[i].value[j].psId = this.pSourceId;
                    }
                }
            }     */   
        }

    }
    revokePaySource(bank, payId) {

        deleteSchPaymentSource({
            paymentId: this.bankAccId
        })
            .then((result) => {
                this.paySourceDetails = result.lstPaymentSources;

                for (var i = 0; i < this.paySourceDetails.length; i++) {

                    if (this.paySourceDetails[i].Payment_Source_Nickname__c === bank) {
                        this.items = [...this.items, {
                            value: this.paySourceDetails[i].Id,
                            label: this.paySourceDetails[i].Payment_Source_Nickname__c + '(********' + this.paySourceDetails[i].Last_4__c + ')'
                        }];


                        this.pSourceId = this.paySourceDetails[i].Id;
                        this.template.querySelector('lightning-combobox[data-id="' + payId + '"]').value = this.pSourceId;

                    }
                }
                //fix for bug 21896                
                this.getAllPaymentSource();
                for (var i = 0; i < this.mapPaymentDetailsval.length; i++) {
                    for (var j = 0; j < this.mapPaymentDetailsval[i].value.length; j++) {                       
                        if (this.mapPaymentDetailsval[i].value[j].Id === this.paymentRec) {
                            this.mapPaymentDetailsval[i].value[j].psId = this.pSourceId;
                        }
                    }
                } 
            })
            .catch((error) => { });
    }
    onConfirm() {

        const allValid = [...this.template.querySelectorAll('lightning-combobox')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        if (allValid) {
            this.isDeleteModalOpen = true;

        }

    }
    onCancel() {
        this.goToPaySource();
    }

    onDeleteModalClose(event) {
        this.isDeleteModalOpen = event.detail;
    }
    onDeleteModalSave(event) {
        this.isDeleteModalOpen = event.detail;

        this.onUpdatePaymentsDeleteSources();
    }
    onSourceSelection(event) {
        const allValid = [...this.template.querySelectorAll('lightning-combobox')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);

        let psId = event.detail.value;
        let payId = event.target.dataset.id;

        for (var i = 0; i < this.mapPaymentDetailsval.length; i++) {
            for (var j = 0; j < this.mapPaymentDetailsval[i].value.length; j++) {
                if (this.mapPaymentDetailsval[i].value[j].Id === payId) {
                    this.mapPaymentDetailsval[i].value[j].psId = psId;
                }
            }
        }
    }
    onDeletepaymentSource() {
        deleteSchPaymentSource({
            paymentId: this.bankAccId
        })
            .then((result) => {

                this.paySourceDetails = result.lstPaymentSources;
                this.paySourceBank = result.bank;
                this.paySourceNickName = result.nickName;
                this.paySourceAccType = result.accType;
                this.paySourceAccNumber = result.accNumber;
                this.paySourceAccId = result.id;
                for (var j = 0; j < this.paySourceDetails.length; j++) {

                    this.items = [...this.items, {
                        value: this.paySourceDetails[j].Id,
                        label: this.paySourceDetails[j].Payment_Source_Nickname__c + '(********' + this.paySourceDetails[j].Last_4__c + ')'
                    }];

                }

                for (let key in result.lstPayments) {

                    let plans = {
                        ChargentOrders__Charge_Amount__c: " ",
                        ChargentOrders__Payment_Start_Date__c: " ",
                        isOTP: false,
                        isEP: false,
                        recordType: " ",
                        Confirmation_Number__c: " ",
                        psId: " ",
                        Id: " ",
                        fId: " "
                        //options: [],
                        //isSelectedVal:" "
 
                    };
                    plans = result.lstPayments[key];
 
                    for (var i = 0; i < plans.length; i++) {
                        plans[i].ChargentOrders__Payment_Start_Date__c = plans[i].ChargentOrders__Payment_Start_Date__c;
                        plans[i].ChargentOrders__Charge_Amount__c = this.formatCurrency(plans[i].ChargentOrders__Charge_Amount__c);
                        plans[i].Id = plans[i].Id;
                        plans[i].psId = " ";
                        //plans[i].isSelectedVal = " ";
                        plans[i].fId = plans[i].Finance_Account_Number__c;
                        if (plans[i].RecordType.Name === "Standard One-Time Payment") {
                            plans[i].recordType = "ONE TIME PAYMENT | STANDARD";
                            plans[i].Confirmation_Number__c = plans[i].Confirmation_Number__c;
                        } else if (plans[i].RecordType.Name === "Principal One-Time Payment") {
                            plans[i].recordType = "ONE TIME PAYMENT | PRINCIPAL";
                            plans[i].Confirmation_Number__c = plans[i].Confirmation_Number__c;
                        } else if (plans[i].RecordType.Name === "Recurring Payment") {
                            plans[i].recordType = "EASYPAY";
                            plans[i].Confirmation_Number__c = "-";
                        } else if (plans[i].RecordType.Name === "Payoff Payment") {
                            plans[i].recordType = "PAYOFF";
                            plans[i].Confirmation_Number__c = plans[i].Confirmation_Number__c;
                        }
                        //plans[i].options = this.items;
                    }
                    this.mapPaymentDetails.push({
                        key: key,
                        value: plans
                    });
                    this.mapPaymentDetailsval.push({
                        value: plans
                    });

                }

            })
            .catch((error) => { });
    }
    onUpdatePaymentsDeleteSources() {
        console.log('Payment Vale>>>>>>>>>>>'+JSON.stringify(this.mapPaymentDetailsval[0].value));
        updatePaymentsDeleteSources({
            paymentData: JSON.stringify(this.mapPaymentDetailsval[0].value)

        })
            .then((result) => {
                console.log('updatePaymentsDeleteSources, Result>>>>>'+result);
                if (result) {                    
                    this.goToPaySourcePage();
                }
            })
            .catch((error) => {
                console.log('Error in Payment Source Deletion>>>>>>>>>>>'+JSON.stringify(error));
             });
    }
    goToPaySourcePage() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "payment-source"
            },
            state: {
                issuccess: true
            }
        });
    }
    goToPaySource() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "payment-source"
            }
        });
    }

    formatCurrency(curNumber) {
        var formatter = new Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "USD",
            maximumFractionDigits: 2
        });
        return formatter.format(curNumber);
    }



}