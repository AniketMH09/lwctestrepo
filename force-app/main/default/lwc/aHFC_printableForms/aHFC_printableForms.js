import {
    api,
    wire,
    LightningElement,
    track
} from 'lwc';
import {
    loadStyle
} from "lightning/platformResourceLoader";
import hondaHeadLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import loadPrintableForm from "@salesforce/resourceUrl/AHFC_printable_forms";
import loadUpdatedPrintableForm from "@salesforce/resourceUrl/AHFC_updated_printable_forms";
import hondaVehImg from "@salesforce/resourceUrl/AHFC_Honda_Header_Car";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import adobeLogo from "@salesforce/resourceUrl/Adobe_Logo";
import {
    NavigationMixin
} from 'lightning/navigation';

import { registerListener, unregisterAllListeners,fireEvent } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import paymentFlagRetrieve from "@salesforce/apex/AHFC_paymentOptionsController.paymentFlagRetrieve";





export default class AHFC_printableForms extends NavigationMixin(LightningElement) {
    @track printForm = "";
    @track form1 = "";
    @track form2 = "";
    @track form3 = "";
    @track form4 = "";
    @track form5 = "";
    @track form6 = "";
    @track form7 = "";
    @track form8 = "";
    @track form9 = "";
    @track form10 = "";
    @track form11 = "";
    @track form13 = "";
    @track domainBrand ='';
    @track isAcurapdf ='';
    @track pdfData;
    @track pageRef;
    @track isFlagData;
   
    get hondaheadLogoUrl() {
        return hondaHeadLogo;
    }
    get hondaVehImgUrl() {
        return hondaVehImg;
    }
    get adobeLogoUrl() {
        return adobeLogo;
    }

    // To get fin account id.
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.pageRef = currentPageReference;
    }
    /*handledata() {
    console('Entering handledata');
    let finId = sessionStorage.getItem('salesforce_id');
    paymentFlagRetrieve({FinanceId:finId})
    .then(result =>{
        if (result) {
            if (result[0] != undefined) {
                if (result[0].isAcuraPaymentOption == false) {   
                    this.form10 = loadUpdatedPrintableForm + '/HFS_Privacy_Notice.pdf';   
                }
                else{
                    this.form10 = loadUpdatedPrintableForm + '/AFS_Privacy_Notice.pdf';
                }
                
            }
        } else {
            console.log('result.error', result.error);
        }
    })
    }*/
    getDataFromPubsubEvent(data) {
        console.log('calling con');
        this.isAcurapdf = JSON.parse(data).serAccRec.Honda_Brand__c;
        if(this.isAcurapdf=="AFS")
        {
            this.form10 = loadUpdatedPrintableForm + '/AFS_Privacy_Notice.pdf';
        }
        else
        {
            this.form10 = loadUpdatedPrintableForm + '/HFS_Privacy_Notice.pdf';
        }
        this.pdfData[3].cardList[0].viewSouce = this.form10;
        this.pdfData[3].cardList[0].downloadSource = this.form10;
        console.log('isAcurapdf-->',this.isAcurapdf);
    }
    connectedCallback() {
        try {
            registerListener('AHFC_Account_Selected', this.getDataFromPubsubEvent, this);
        } catch (error) {
            console.log('157', error);
        }
        let adobedata = {
            "Page.page_name": "Printable Form",
            "Page.site_section": "Printable Form",
            "Page.referrer_url": document.referrer,
            // "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        loadStyle(this, ahfctheme + "/theme.css").then(() => {});
        this.form1 = loadPrintableForm + '/Credit_Pre-approval_Form.pdf';
        this.form2 = loadUpdatedPrintableForm + '/EasyPay_Registration.pdf';
        this.form3 = loadUpdatedPrintableForm + '/EasyPay_Registration_Powersports.pdf';
        this.form4 = loadUpdatedPrintableForm + '/3rd_party_auth.pdf';
        this.form5 = loadUpdatedPrintableForm + '/HFS_RestrictedPowerOfAttorney.pdf';
        this.form6 = loadPrintableForm + '/Ohio Restricted Power of Attorney.pdf';
        this.form7 = loadUpdatedPrintableForm + '/Odometer_Disclosure_Title_Release.pdf';
        this.form8 = loadUpdatedPrintableForm + '/Vehicle_return_receipt_lease.pdf';
        this.form9 = loadUpdatedPrintableForm + '/OH_PowerofAttorney-HFS.pdf';
        this.form10 = loadUpdatedPrintableForm + '/HFS_Privacy_Notice.pdf';
        this.form11 = loadUpdatedPrintableForm + '/HFS_Authorized_Agent_Form.pdf';
        this.form12 = loadUpdatedPrintableForm + '/AFS_Privacy_Notice.pdf';
        this.form13 = loadUpdatedPrintableForm + '/Ohio_Odometer_Disclosure_Title_Release.pdf';
        let finId = sessionStorage.getItem('salesforce_id');
        paymentFlagRetrieve({FinanceId:finId})
        .then(result =>{
        if (result) {
            console.log('result--->',result);
            if (result!= undefined) {
                console.log('Result is coming');
                if (result.acuraPayment == false) {   
                    this.form10 = loadUpdatedPrintableForm + '/HFS_Privacy_Notice.pdf';
                    console.log('it is honda');
                }
                else{
                    this.form10 = loadUpdatedPrintableForm + '/AFS_Privacy_Notice.pdf';
                    console.log('it is acura');
                }
                this.pdfData[3].cardList[0].viewSouce = this.form10;
                this.pdfData[3].cardList[0].downloadSource = this.form10;
            }   
            } else {
            console.log('result.error', result.error);
        }
        })
        this.pdfData = [{
                id: "0",
                class: "",
                contentClass: "",
                cardTitle: 'Apply for credit pre-approval',
                cardList: [{
                    id: "a1",
                    cardData: 'Credit Pre-Approval Application',
                    viewSouce: this.form1,
                    downloadSource: this.form1
                }]
            },
            {
                id: "1",
                class: "",
                contentClass: "",
                cardTitle: 'account management',
                cardList: [{
                        id: "a1",
                        cardData: 'EasyPay Authorization Agreement - Auto',
                        viewSouce: this.form2,
                        downloadSource: this.form2,
                        viewFor: "both"

                    },
                    {
                        id: "a2",
                        cardData: 'EasyPay Authorization Agreement - Powersports/Power Equipment/Marine',
                        viewSouce: this.form3,
                        downloadSource: this.form3,
                        viewFor: "honda"
                    },
                    {
                        id: "a3",
                        cardData: 'Third Party Authorization',
                        viewSouce: this.form4,
                        downloadSource: this.form4,
                        viewFor: "honda"
                    }
                ]
            },
            {
                id: "2",
                class: "",
                contentClass: "",
                cardTitle: 'END OF TERM',
                cardList: [{
                        id: "a1",
                        cardData: 'Restricted Power of Attorney',
                        viewSouce: this.form5,
                        downloadSource: this.form5
                    },
                    {
                        id: "a2",
                        cardData: 'Ohio Restricted Power of Attorney',
                        viewSouce: this.form9,
                        downloadSource: this.form9
                    },
                    {
                        id: "a3",
                        cardData: 'Odometer Disclosure Statement and Title Release Information',
                        viewSouce: this.form7,
                        downloadSource: this.form7
                    },
                    {
                        id: "a3",
                        cardData: 'Vehicle Return Receipt',
                        viewSouce: this.form8,
                        downloadSource: this.form8
                    },
                    {
                        id: "a4",
                        cardData: 'Ohio Odometer Disclosure Statement and Title Release Information',
                        viewSouce: this.form13,
                        downloadSource: this.form13
                    }
                ]
            },
            {
                id: "3",
                class: "",
                contentClass: "",
                cardTitle: 'PRIVACY',
                cardList: [{
                        id: "a1",
                        cardData: 'Privacy Notice',
                        viewSouce: this.form10,
                        downloadSource: this.form10
                    },
                    {
                        id: "a2",
                        cardData: 'Authorized Agent Form',
                        viewSouce: this.form11,
                        downloadSource: this.form11
                    }
                ]
            }

        ];

    }
    returnToDashBoard() {
        window.history.back();
        return false;
    }

    //for ADA
    renderedCallback() {

        let firstClass = this.template.querySelector(".main-content");
        setTimeout(() => { fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id')); }, 1000);

    }
    navigateToCreditPreApproval() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'creditpreapproval'
            }
        });
    }
}