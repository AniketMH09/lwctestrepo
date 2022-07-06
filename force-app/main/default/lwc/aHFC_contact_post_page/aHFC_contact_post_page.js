/* Component Name        :    AHFC_contact_post_page
    * Description        :    This is LWC for Contact Us post Login Page. 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aniket                     08/06/2021              Created \
   
*/
import { LightningElement, track, wire } from 'lwc';
import getBranchData from '@salesforce/apex/AHFC_Contact_Page_Controller.getBranchData';
import finAccData from '@salesforce/apex/AHFC_Contact_Page_Controller.finData';
import getAddressData from '@salesforce/apex/AHFC_Contact_Page_Controller.getAddressData';
import getErrorNotification from '@salesforce/apex/AHFC_Contact_Page_Controller.getErrorNotification';
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import { CurrentPageReference } from "lightning/navigation";
import { fireEvent } from 'c/pubsub';
import { fireAdobeEvent } from "c/aHFC_adobeServices";

import ahfc_contact_post_back_arrow from "@salesforce/resourceUrl/ahfc_contact_post_back_arrow";
import ahfc_contact_uparrow from "@salesforce/resourceUrl/ahfc_contact_uparrow";
import ahfc_contact_downarrow from "@salesforce/resourceUrl/ahfc_contact_downarrow";
import ahfc_contact_post_back_arrow_mobile from "@salesforce/resourceUrl/ahfc_contact_post_back_arrow_mobile";

export default class AHFC_contact_post_page extends LightningElement {

    @track currentFinId;
    @track branchData = [];
    @track addressData = [];
    @track contactPhone = '';
    @track ahfc_contact_uparrow = ahfc_contact_uparrow;
    @track ahfc_contact_downarrow = ahfc_contact_downarrow;
    @track ahfc_contact_post_back_arrow = ahfc_contact_post_back_arrow;
    @track ahfc_contact_post_back_arrow_mobile = ahfc_contact_post_back_arrow_mobile;
    @track isLease = false;
    @track isNotLease = true;
    @track isMarinePe = false;
    @track popHead = '';
    @track popPhoneNumber = '';
    @track businesshours = '';
    @track openPhoneNumber = false;
    @track openConcern = false;
    @track openConcern2 = false;
    @track accountData = [];
    @track isErrorState = false;
    @track text1 = '';
    @track text2 = '';
    @track headertest1 = '';
    @track headertest2 = '';
    @track headertest3 = '';



    @track sectionCopy = 'Questions about your account? Honda Financial Services℠ (HFS), is available to assist you.';
    @track sectionCopy1 = 'To expedite service, please have your account number available. The number can be found on your monthly statement, your online account, or any Honda Financial Services correspondence.';

    @track hondacopy = "Our Honda Care Vehicle Service Contracts (VSCs) provide additional benefits beyond the manufacturer's warranty";
    @track acuracopy = "Our Acura Care Vehicle Service Contracts (VSCs) provide additional benefits beyond the manufacturer's warranty.";


    @track hondacopynew = 'The Honda Automobiles Customer Service team is happy to help you with questions about your Honda vehicle.';
    @track acuracopynew = 'The Acura Client Relations team is happy to help you with questions about your Acura vehicle.';

    @track pageRef;

    @track middletext1 = 'The Honda Automobiles Customer Service team is happy to help you with questions about your Honda vehicle.';
    @track middletext2 = 'The Honda Automobiles Customer Service team is happy to help you with questions about your Honda vehicle.';

    // Get service account customer id from previous page
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.pageRef = currentPageReference;
    }
    //Navigation to previous page
    onCheckApplicationStatusClick() {
        window.history.back();
        return false;
    }


    //Close Pop up
    onCloseApp() {
        this.openPhoneNumber = false;
        this.openConcern = false;
        this.openConcern2 = false;
    }

    @track phoneAria = '';
    //when clicked on phone number - lease
    onLeaseClicked() {
        this.popHead = 'Lease Maturity Center Number';
        if (this.accountData[0].Honda_Brand__c == 'HFS') {
            this.popPhoneNumber = '(800) 708-6555';
        } else {
            this.popPhoneNumber = '(866) 777-6495';
        }

        this.businesshours = 'Monday – Friday, 9 a.m. – 5 p.m. local time.'
        this.openPhoneNumber = true;
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Customer Service:Hyperlink:End of Lease Phone",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Post-Login",
            "Page.brand_name": this.accountData[0].Honda_Brand__c
        };
        fireAdobeEvent(adobedata, 'click-event');
        this.phoneAria = this.popHead + this.popPhoneNumber;

    }

    //when clicked on phone number - Honda
    onHondaClicked() {

        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Customer Service:Hyperlink:Honda Care Phone",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Post-Login",
            "Page.brand_name": this.accountData[0].Honda_Brand__c
        };
        fireAdobeEvent(adobedata, 'click-event');

        if (this.accountData[0].AHFC_Product_Type__c == 'Powersports') {
            this.popHead = 'HondaCare Protection Plan Number';
            this.popPhoneNumber = '(800) 555-3496';
            this.businesshours = 'Monday – Friday, 8:30 a.m. – 4:30 p.m. PT.'
            this.openPhoneNumber = true;
            this.phoneAria = this.popHead + this.popPhoneNumber;
            return;
        }
        if (this.accountData[0].Honda_Brand__c == 'HFS') {
            this.popHead = 'Honda Care Number';
            this.popPhoneNumber = '(800) 999-5901';
            this.businesshours = 'Monday – Friday, 6 a.m. – 5 p.m. PT.'
            this.openPhoneNumber = true;
            this.phoneAria = this.popHead + this.popPhoneNumber;
        }

        if (this.accountData[0].Honda_Brand__c == 'AFS') {
            this.popHead = 'Acura Care Number';
            this.popPhoneNumber = '(888) 682-2872';
            this.businesshours = 'Monday – Friday, 6 a.m. – 5 p.m. PT.'
            this.openPhoneNumber = true;
            this.phoneAria = this.popHead + this.popPhoneNumber;
        }

       

    }

    //when clicked on phone number - Concern
    onConcerenrClicked() {
 
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Customer Service:Hyperlink:Auto Customer Service Phone",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Post-Login",
            "Page.brand_name": this.accountData[0].Honda_Brand__c
        };
        fireAdobeEvent(adobedata, 'click-event');
        if (this.accountData[0].AHFC_Product_Type__c == 'Powersports') {
            this.popHead = 'Honda Customer Service Number';
            this.popPhoneNumber = '(866) 784-1870';
            this.businesshours = 'Monday – Friday, 8:30 a.m. – 4:30 p.m. PT.'
            this.openPhoneNumber = true;
            this.phoneAria = this.popHead + this.popPhoneNumber;
            return;
        }
        if (this.accountData[0].AHFC_Product_Type__c == 'Marine' || this.accountData[0].AHFC_Product_Type__c == 'Power Equipment') {
            this.popHead = 'Honda Customer Service Number';
            this.popPhoneNumber = '(770) 497-6400';
            this.businesshours = 'Friday, 9 a.m. – 7:30 p.m. ET.'
            this.openPhoneNumber = true;
            this.phoneAria = this.popHead + this.popPhoneNumber;
            return;
        }
        if (this.accountData[0].Honda_Brand__c == 'HFS') {
            // this.popHead = 'Honda Care Vehicle Service Contracts (VSC) Number';
            // this.popPhoneNumber = '(800) 999-5901';
            // this.businesshours = 'Monday – Friday, 6 a.m. – 5 p.m. PST.'
            // this.openPhoneNumber = true;
            this.openConcern2 = true;
        }

        if (this.accountData[0].Honda_Brand__c == 'AFS') {
            this.openConcern = true;
        }
        

    }

    @track leaseData = [
        {
            id: "0",
            class: "",
            isOpened: false,
            cardTitle: 'Payment Address ',
            address: '',
            isDiscliamer: false,
            isCRDA: false,
        },
        {
            id: "1",
            class: "",
            isOpened: false,
            cardTitle: 'Correspondence Address',
            address: '',
            isDiscliamer: false,
            isCRDA: false,
        },
        {
            id: "2",
            class: "",
            isOpened: false,
            cardTitle: 'Dealer / Third Party Address',
            address: {
                addr_line1__c: "Honda Finance Exchange, Inc.*",
                addr_line2__c: "P.O. Box 70252",
                city__c: "Philadelphia",
                state_cd__c: "PA",
                zip__c: "19176"
            },
            isDiscliamer: true,
            isCRDA: false
        },
        {
            id: "3",
            class: "",
            isOpened: false,
            cardTitle: 'Overnight Address',
            isDiscliamer: false,
            address: {
                addr_line1__c: "AMERICAN HONDA FINANCE CORPORATION",
                addr_line2__c: "Lockbox #7829, 400 White Clay Center Drive",
                city__c: "Newark",
                state_cd__c: "DE",
                zip__c: "19711"
            },
            isCRDA: true
        },
        {
            id: "4",
            class: "",
            isOpened: false,
            cardTitle: 'Credit Reporting Dispute Address',
            address: {
                addr_line1__c: "AMERICAN HONDA FINANCE CORPORATION",
                addr_line2__c: "PO BOX 168128",
                city__c: "Irving",
                state_cd__c: "TX",
                zip__c: "75016"
            },
            isCRDA: true,
            crda: `If you would like to dispute information on your credit report about your account, send your 
            dispute in writing to the following address. Your dispute should include the specific information disputed, the reason you believe your dispute
            is valid and any supporting documentation you would like to provide in support of your dispute.`
        }
        

    ]

    //get branch data from custom metadata
    @wire(getBranchData)
    wiredDataNew(result) {
        if (result.data) {
            this.branchData = result.data;
            console.log('this.branchData', this.branchData)
        } else {
            console.log('error', result.error);
        }
    }

    /* get error notification from custom metadata
    @wire(getErrorNotification)
    wiredData(result) {
        if (result.data) {
            if (result.data[0].AHFC_experiencing_high_call_volume__c) {
                this.isErrorState = true;
            }

        } else {
            console.log('error', result.error);
        }
    }*/

    //get address data from custom metadata
    // @wire(getAddressData)
    // wiredAddressData(result) {
    //     if (result.data) {
    //         this.addressData = JSON.parse(JSON.stringify(result.data));
    //         console.log('263', this.addressData);
    //         for (let i = 0; i < this.addressData.length; i++) {
    //             if (this.addressData[i].zip__c.length > 4) {
    //                 this.addressData[i].zip__c = [this.addressData[i].zip__c.split("").reverse().join("").slice(0, 4), '-', this.addressData[i].zip__c.slice(4)].join('').split('').reverse().join('');
    //             }
    //         }

    //         this.getFinData();

    //     } else {
    //         console.log('error', result.error);
    //     }
    // }

    connectedCallback() {
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
        if (sessionStorage.getItem('salesforce_id') != null) {
            this.currentFinId = sessionStorage.getItem('salesforce_id');
            console.log('281', this.currentFinId)
        }

        getAddressData()
            .then(result => {
                console.log('286', result);
                if (result) {
                    this.addressData = JSON.parse(JSON.stringify(result));
                    console.log('289', this.addressData);
                    for (let i = 0; i < this.addressData.length; i++) {
                        if (this.addressData[i].zip__c.length > 4) {
                            //this.addressData[i].zip__c = this.addressData[i].zip__c.slice(0, -4);
                            this.addressData[i].zip__c = [this.addressData[i].zip__c.split("").reverse().join("").slice(0, 4), '-', this.addressData[i].zip__c.split("").reverse().join("").slice(4)].join('').split('').reverse().join('');
                        }
                    }

                    this.getFinData();

                } else {
                    console.log('error', result.error);
                }
            })
    }

    @track text1aria = '';
    @track text2aria = '';
    //get finance account data from apex
    getFinData() {
        console.log('286', this.currentFinId)
        finAccData({ finid: this.currentFinId })
            .then(data => {

                this.accountData = JSON.parse(JSON.stringify(data));
                console.log('291', this.accountData);               
                
                let adobedata = {
                    "Page.page_name": "Customer Service Post-Login",
                    "Page.site_section": "Customer Service Post-Login",
                    "Page.brand_name": data[0].Honda_Brand__c,
                    "Page.referrer_url": document.referrer
                };
                fireAdobeEvent(adobedata, 'PageLoadReady');
                if (data[0].Honda_Brand__c == 'HFS') {
                    this.text1 = 'QUESTIONS ABOUT HONDA CARE?';
                    this.text1aria = 'QUESTIONS ABOUT HONDA CARE?' + 'View Phone Number';
                    this.text2 = 'CONCERNS ABOUT YOUR VEHICLE?';
                    this.text2aria = 'CONCERNS ABOUT YOUR VEHICLE?' + 'View Phone Number';
                    this.headertest1 = "Our Honda Care Vehicle Service Contracts (VSCs) provide additional benefits beyond the manufacturer's warranty."
                    this.headertest2 = "The Honda Automobiles Customer Service team is happy to help you with questions about your Honda vehicle."
                    this.middletext1 = this.hondacopy;
                    this.middletext2 = this.hondacopynew;
                    for (let i = 0; i < this.branchData.length; i++) {
                        if (this.branchData[i].branch_cd__c == data[0].Origination_Branch_Code__c) {
                            console.log('288');
                            this.contactPhone = this.formatPhoneNumber(Number(this.branchData[i].phone__c));
                        }
                    }
                } else if (data[0].Honda_Brand__c == 'AFS') {
                    this.sectionCopy = 'Questions about your account? Acura Financial Services (AFS) is available to assist you.'
                    this.sectionCopy1 = 'To expedite service, please have your account number available. The number can be found on your monthly statement, your online account, or any AFS correspondence.';
                    this.text1 = 'QUESTIONS ABOUT ACURA CARE?';
                    this.text1aria = 'QUESTIONS ABOUT ACURA CARE?' + 'View Phone Number';
                    this.text2 = 'CONCERNS ABOUT YOUR VEHICLE?';
                    this.text2aria = 'QCONCERNS ABOUT YOUR VEHICLE?' + 'View Phone Number';
                    this.middletext1 = this.acuracopy;
                    this.middletext2 = this.acuracopynew;
                    this.headertest1 = "Our Acura Care Vehicle Service Contracts (VSCs) provide additional benefits beyond the manufacturer's warranty."
                    this.headertest2 = "The Acura Client Relations team is happy to help you with questions about your Acura vehicle."
                    for (let i = 0; i < this.branchData.length; i++) {
                        if (this.branchData[i].branch_cd__c == data[0].Origination_Branch_Code__c) {
                            this.contactPhone = this.formatPhoneNumber(Number(this.branchData[i].afs_phone__c));
                        }
                    }
                } else if (data[0].Honda_Brand__c == 'HFSP') {
                    this.text1 = 'QUESTIONS ABOUT HONDA CARE?';
                    this.text1aria = 'QUESTIONS ABOUT HONDA CARE?' + 'View Phone Number';
                    this.text2 = 'CONCERNS ABOUT YOUR PRODUCT?';
                    this.text2aria = 'CONCERNS ABOUT YOUR PRODUCT?' + 'View Phone Number';
                    for (let i = 0; i < this.branchData.length; i++) {
                        if (this.branchData[i].branch_cd__c == '109') {
                            this.contactPhone = this.formatPhoneNumber(Number(this.branchData[i].phone__c));
                        }
                    }
                }


                if (data[0].Account_Type__c == 'Lease') {
                    this.isLease = true;
                    this.isNotLease = false;
                    this.isMarinePe = false;
                    this.leaseData.push({
                        id: "5",
                        class: "",
                        isOpened: false,
                        cardTitle: 'Lease Purchase Address',
                        isDiscliamer: true,
                        address: {
                            addr_line1__c: "Honda Finance Exchange, Inc.*",
                            addr_line2__c: "P.O. Box 70252",
                            city__c: "Philadelphia",
                            state_cd__c: "PA",
                            zip__c: "19176"
                        }
                    })
                }
                if (data[0].AHFC_Product_Type__c == 'Powersports') {
                    this.middletext1 = 'Our HondaCare Protection Plan provides additional benefits beyond the factory warranty.';
                    this.middletext2 = 'Our Honda Customer Service team is happy to help you with questions about your Honda powersports product.';
                    this.text1 = 'QUESTIONS ABOUT HONDA CARE?';
                    this.text1aria = 'QUESTIONS ABOUT HONDA CARE?' + 'View Phone Number';
                    this.text2 = 'CONCERNS ABOUT YOUR PRODUCT?';
                    this.text2aria = 'CONCERNS ABOUT YOUR PRODUCT?' + 'View Phone Number';
                    this.headertest1 = "Our HondaCare Protection Plan provides additional benefits beyond the factory warranty.";
                    this.headertest2 = "Our Honda Customer Service team is happy to help you with questions about your Honda powersports product."
                }

                if (data[0].AHFC_Product_Type__c == 'Marine' || data[0].AHFC_Product_Type__c == 'Power Equipment') {
                    this.isLease = false;
                    this.isNotLease = false;
                    this.isMarinePe = true;
                    this.text2 = 'CONCERNS ABOUT YOUR PRODUCT?';
                    this.text2aria = 'CONCERNS ABOUT YOUR PRODUCT?' + 'View Phone Number';
                    this.headertest2 = "Our Honda Customer Service team is happy to help you with questions about your Honda powersports product."
                }
                for (let i = 0; i < this.addressData.length; i++) {
                    console.log('Originating Branch==', data[0].Origination_Branch_Code__c);
                    if (this.addressData[i].branch_cd__c == data[0].Origination_Branch_Code__c) {
                        if (data[0].Account_Type__c == 'Lease' && this.addressData[i].acct_type_cd__c == 'L') {
                            if (this.addressData[i].branch_addr_type__c == 'PYMT') {
                                this.leaseData[0].address = JSON.parse(JSON.stringify(this.addressData[i]))
                            }
                            if (this.addressData[i].branch_addr_type__c == 'MAIL') {
                                this.leaseData[1].address = JSON.parse(JSON.stringify(this.addressData[i]))
                            }

                        }
                        if ((data[0].Account_Type__c == 'Retail' || data[0].Account_Type__c == 'Balloon') && this.addressData[i].acct_type_cd__c == 'R') {
                            if (this.addressData[i].branch_addr_type__c == 'PYMT') {                               
                                this.leaseData[0].address = JSON.parse(JSON.stringify(this.addressData[i]))
                            }
                            if (this.addressData[i].branch_addr_type__c == 'MAIL') {
                                this.leaseData[1].address = JSON.parse(JSON.stringify(this.addressData[i]))                                
                            }
                        }
                    }
                }

            }).catch(error => {        
                //Record access check exception handling - Supriya Chakraborty 11-Nov-2021
                console.log('search Error', error);
                if(error.body.message == 'invalid access'){
                    this.returnToDashBoard();
                }                
                
            });
    }


    //accordian open/close
    onCardClick(event) {
        const open = "slds-is-open";
        const close = "";
        this.leaseData.map(function (x, index) {
            if (x.isOpened && index != event.currentTarget.dataset.keyno) {
                x.isOpened = false;
                x.class = "";
            }
            return x
        });
        if (event.currentTarget.dataset.keyno) {
            let keyId = event.currentTarget.dataset.keyno;
            this.leaseData[keyId].isOpened = !this.leaseData[keyId].isOpened;
            this.leaseData[keyId].class = this.leaseData[keyId].class === open ? close : open;
        }
    }




    @track tabItems = [
        {
            key: 'Phone',
            name: 'Phone',
            tabIndex: '0',
            ariaSelected: 'true',
            ariaControls: 'phone-tab',
            ariaLabelledby: 'phone-tab_item',
            headerClass: 'slds-tabs_default__item schedulePayTab ahfc-info-label ahfc-text-dark slds-is-active',
            contentClass: 'slds-tabs_default__content slds-show',
            isScheduledPayment: true
        },
        {
            key: 'Address',
            name: 'Payment Addresses',
            tabIndex: '-1',
            ariaSelected: 'false',
            ariaControls: 'Address-tab',
            ariaLabelledby: 'Address-tab_item',
            headerClass: 'slds-tabs_default__item ahfc-info-label ahfc-text-dark transactionTab ',
            contentClass: 'slds-tabs_default__content slds-hide',
            isTransactionHistory: true
        }
    ];

    //on tab change event
    onTabChange(event) {
        if (event.target.dataset.tabname == 'Phone' && this.tabItems[0].ariaSelected != 'true') {
            this.tabItems[0].ariaSelected = 'true';
            this.tabItems[0].tabIndex = '0';
            this.tabItems[0].headerClass = 'slds-tabs_default__item ahfc-info-label ahfc-text-dark schedulePayTab  slds-is-active';
            this.tabItems[0].contentClass = 'slds-tabs_default__content slds-show';
            this.tabItems[1].ariaSelected = 'false';
            this.tabItems[1].tabIndex = '-1';
            this.tabItems[1].headerClass = 'slds-tabs_default__item ahfc-info-label ahfc-text-dark transactionTab ';
            this.tabItems[1].contentClass = 'slds-tabs_default__content slds-hide';
            let adobedata = {
                'Event_Metadata.action_type': 'Tab',
                "Event_Metadata.action_label": "Customer Service:Tab:Phone",
                "Event_Metadata.action_category": "Contact Us",
                "Page.page_name": "Customer Service Post-Login",
                "Page.brand_name": this.accountData[0].Honda_Brand__c
            };
            fireAdobeEvent(adobedata, 'click-event');
        } else if (event.target.dataset.tabname == 'Address' && this.tabItems[1].ariaSelected != 'true') {
            this.tabItems[1].ariaSelected = 'true';
            this.tabItems[1].tabIndex = '0';
            this.tabItems[1].headerClass = 'slds-tabs_default__item ahfc-info-label ahfc-text-dark transactionTab  slds-is-active';
            this.tabItems[1].contentClass = 'slds-tabs_default__content slds-show';
            this.tabItems[0].ariaSelected = 'false';
            this.tabItems[0].tabIndex = '-1';
            this.tabItems[0].headerClass = 'slds-tabs_default__item ahfc-info-label ahfc-text-dark schedulePayTab ';
            this.tabItems[0].contentClass = 'slds-tabs_default__content slds-hide';
            let adobedata = {
                'Event_Metadata.action_type': 'Tab',
                "Event_Metadata.action_label": "Customer Service:Tab:Payment Address",
                "Event_Metadata.action_category": "Contact Us",
                "Page.page_name": "Customer Service Post-Login",
                "Page.brand_name": this.accountData[0].Honda_Brand__c
            };
            fireAdobeEvent(adobedata, 'click-event');
        }
    }


    formatPhoneNumber(phoneNumberString) {
        var cleaned = ('' + phoneNumberString).replace(/\D/g, '');
        var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
        if (match) {
            return '(' + match[1] + ') ' + match[2] + '-' + match[3];
        }
        return null;
    }


    renderedCallback() {
        let firstClass = this.template.querySelector(".main-content");
        fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
    }

    get linkmobilenumber1() {
        return `tel:+1${this.contactPhone}`;
    }

    get mobilenuimber2() {
        return `tel:+1${this.popPhoneNumber}`;
    }
}