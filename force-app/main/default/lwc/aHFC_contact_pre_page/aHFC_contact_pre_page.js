import { LightningElement, track, wire } from 'lwc';
import getBranchData from '@salesforce/apex/AHFC_Contact_Page_Controller.getBranchData';
import getAddressData from '@salesforce/apex/AHFC_Contact_Page_Controller.getAddressData';
//import getErrorNotification from '@salesforce/apex/AHFC_Contact_Page_Controller.getErrorNotification';
import getStateData from '@salesforce/apex/AHFC_Contact_Page_Controller.getStateData';
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import { fireEvent } from 'c/pubsub';

import ahfc_contact_post_back_arrow from "@salesforce/resourceUrl/ahfc_contact_post_back_arrow";
import ahfc_contact_uparrow from "@salesforce/resourceUrl/ahfc_contact_uparrow";
import ahfc_contact_downarrow from "@salesforce/resourceUrl/ahfc_contact_downarrow";
import ahfc_contact_post_back_arrow_mobile from "@salesforce/resourceUrl/ahfc_contact_post_back_arrow_mobile";


import AHFC_cpa_hondaauto from "@salesforce/resourceUrl/AHFC_cpa_hondaauto";
import AHFC_cpa_acura from "@salesforce/resourceUrl/AHFC_cpa_acura";
import AHFC_cpa_marine from "@salesforce/resourceUrl/AHFC_cpa_marine";
import AHFC_cpa_pe from "@salesforce/resourceUrl/AHFC_cpa_pe";
import AHFC_cpa_ps from "@salesforce/resourceUrl/AHFC_cpa_ps";
import globalAlertMessage from "@salesforce/apex/AHFC_globalAlert.globalAlertMessage";


import US_STATES from "@salesforce/label/c.AHFC_US_State";
import US_STATES_CODE from "@salesforce/label/c.AHFC_US_State_Code";

import { fireAdobeEvent } from "c/aHFC_adobeServices";
import { CurrentPageReference } from 'lightning/navigation';

export default class AHFC_contact_pre_page extends LightningElement {

    /* US 2320 -- Added by Narain */
    @track globalAlertFlag = false;
    @track alertMessageArray = [];
    @track alertMessage;
    @track alertMessageArrayMain = [];

    @track States = US_STATES;
    @track StatesCode = US_STATES_CODE;
    @track ahfc_contact_uparrow = ahfc_contact_uparrow;
    @track ahfc_contact_downarrow = ahfc_contact_downarrow;
    @track ahfc_contact_post_back_arrow = ahfc_contact_post_back_arrow;
    @track ahfc_contact_post_back_arrow_mobile = ahfc_contact_post_back_arrow_mobile;
    @track AHFC_cpa_hondaauto = AHFC_cpa_hondaauto;
    @track AHFC_cpa_acura = AHFC_cpa_acura;
    @track AHFC_cpa_marine = AHFC_cpa_marine;
    @track AHFC_cpa_pe = AHFC_cpa_pe;
    @track AHFC_cpa_ps = AHFC_cpa_ps;
    @track hondaClass = 'ahfc-pop-img';
    @track acuraClass = 'ahfc-pop-img';
    @track peClass = 'ahfc-pop-img';
    @track psClass = 'ahfc-pop-img';
    @track marineClass = 'ahfc-pop-img';
    @track selectedState = '';
    @track listofState = [];
    @track branchData = [];
    @track addressData = [];
    @track isErrorState = false;
    @track codeData = [];
    @track productType = '';
    @track phonenumber = '';
    @track branchCodeSelected = '';
    @track isHonda = false;
    @track isAcura = false;
    @track isPE = false;
    @track isPS = false;
    @track isMarine = false;
    @track isSubmit = false;
    @track openPopUp = false;
    @track openPopUp2 = false;
    @track popHead = ''; 
    @track popPhoneNumber = '';
    @track popPhoneNumber2 = '';
    @track businesshours = '';
    @track copyLeaseData = [];
    @track addressDataForNonLease = [{
        id: "0",
        class: "",
        isOpened: false,
        cardTitle: 'Payment Address ',
        address: '',
        isCRDA: false,
        isDiscliamer: false,
    },
    {
        id: "1",
        class: "",
        isOpened: false,
        cardTitle: 'Correspondence Address',
        address: '',
        isCRDA: false,
        isDiscliamer: false,
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
        isCRDA: false,
        isDiscliamer: true,
    },
    {
        id: "3",
        class: "",
        isOpened: false,
        cardTitle: 'Overnight Address',
        address: {
            addr_line1__c: "AMERICAN HONDA FINANCE CORPORATION",
            addr_line2__c: "Lockbox #7829, 400 White Clay Center Drive",
            city__c: "Newark",
            state_cd__c: "DE",
            zip__c: "19711"
        },
        isCRDA: false,
        isDiscliamer: false,
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
        isDiscliamer: false,
        crda: `If you would like to dispute information on your credit report about your account, send your 
        dispute in writing to the following address. Your dispute should include the specific information disputed, the reason you believe your dispute
        is valid and any supporting documentation you would like to provide in support of your dispute.`
    }
    ];

    @wire(CurrentPageReference) pageRef;

    @track leaseData = [{
        id: "0",
        class: "",
        isOpened: false,
        cardTitle: 'Payment Address ',
        address: '',
        isCRDA: false,
        isDiscliamer: false,
    },
    {
        id: "1",
        class: "",
        isOpened: false,
        cardTitle: 'Correspondence Address',
        address: '',
        isCRDA: false,
        isDiscliamer: false,
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
        isCRDA: false,
        isDiscliamer: true,
    },
    {
        id: "3", 
        class: "",
        isOpened: false,
        cardTitle: 'Overnight Address',
        address: {
            addr_line1__c: "AMERICAN HONDA FINANCE CORPORATION",
            addr_line2__c: "Lockbox #7829, 400 White Clay Center Drive",
            city__c: "Newark",
            state_cd__c: "DE",
            zip__c: "19711"
        },
        isCRDA: false,
        isDiscliamer: false,
    },
    {
        id: "4",
        class: "",
        isOpened: false,
        cardTitle: 'Lease Purchase Address',
        address: {
            addr_line1__c: "Honda Finance Exchange, Inc.*",
            addr_line2__c: "P.O. Box 70252",
            city__c: "Philadelphia",
            state_cd__c: "PA",
            zip__c: "19176"
        },
        isCRDA: false,
        isDiscliamer: true,
        
    },
    {
        id: "5",
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
        isDiscliamer: false,
        crda: `If you would like to dispute information on your credit report about your account, send your 
        dispute in writing to the following address. Your dispute should include the specific information disputed, the reason you believe your dispute
        is valid and any supporting documentation you would like to provide in support of your dispute.`
    }

    ];

    //to close pop up
    onCloseApp() {
        this.openPopUp = false;
        this.openPopUp2 = false;
    }


    //to expand and close curosal
    onCardClick(event) {
        event.stopPropagation();
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



    //get branch data from custom metadata
    @wire(getBranchData)
    wiredDataNew(result) {
        if (result.data) {
            this.branchData = result.data;
        } else {
            console.log('error', result.error);
        }
    }


    testFunctin(){
        getBranchData().then(data => {
            
        })

    }

    /*get error notification from custom metadata
    @wire(getErrorNotification)
    wiredData(result) {
        if (result.data) {
            if (result.data[0].AHFC_experiencing_high_call_volume__c) {
                this.isErrorState = true;
            }

        } else {
            console.log('error', result.error);
        }
    } */

    //get address data from custom metadata
    @wire(getAddressData)
    wiredAddressData(result) {
        if (result.data) {
            this.addressData = JSON.parse(JSON.stringify(result.data));
            for (let i = 0; i < this.addressData.length; i++) {
                if (this.addressData[i].zip__c.length > 4) {
                    this.addressData[i].zip__c = [this.addressData[i].zip__c.split("").reverse().join("").slice(0, 4), '-', this.addressData[i].zip__c.slice(4)].join('').split('').reverse().join('');
                }
            }

        } else {
            console.log('error', result.error);
        }
    }

    //get acode data from custom metadata
    @wire(getStateData)
    wiredCodeData(result) {
        if (result.data) {
            this.codeData = result.data;

        } else {
            console.log('error', result.error);
        }
    }

    connectedCallback() {
        let adobedata = {
            'Event_Metadata.action_type': 'Select',
            "Event_Metadata.action_label": "Customer Service:Select Product:Honda Auto",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Pre-Login",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        //fireAdobeEvent(adobedata, 'click-event');
        adobedata = {
            "Page.page_name": "Customer Service Pre-Login",
            "Page.site_section": "Customer Service Pre-Login",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : '',
            "Page.referrer_url": document.referrer
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        this.globalAlert();
        this.copyLeaseData = JSON.parse(JSON.stringify(this.leaseData));
        this.isHonda = true;
        this.productType = 'honda'
        this.hondaClass = 'ahfc-pop-img ahfc-brd';
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
        this.getStates();
    }

    //US 2320 Start Added by Narain
    globalAlert() {
        globalAlertMessage({}).then(result => {
            let data = result;
            let isErrorOccured = data['isErrorOccured'];

            if (isErrorOccured === true) {
                console.log('error');
            } else {
                this.globalAlertFlag = true;
                this.alertMessageArray = result;
                let alertName;
                if (data.length != 0) {
                    for (let i = 0; i < data.length; i++) {
                        let currTmpDocItem = {};
                        this.alertMessage = result[i].Alert_Message__c;
                        currTmpDocItem.Alert_Message__c = this.alertMessage;
                        currTmpDocItem.Name = alertName;
                        this.alertMessageArrayMain.push(currTmpDocItem);

                    }
                }
            }

        }).catch(error => {
            // Showing errors if any while inserting the files
            console.log('inside catch ', error);

        });

    }

    // US 2320 end Added by Narain
    //Navigation to previous page
    onCheckApplicationStatusClick() {
        window.history.back();
        return false;
    }

    //when click on submit
    onSubmit() {
        if (this.selectedState == '') {
            return;
        }
        console.log('this.selectedState',this.selectedState);
        console.log('this.codeData',this.codeData);
        console.log('this.productType',this.productType);
        this.isSubmit = true;
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Customer Service:Button:Submit",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Pre-Login",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
        if (this.productType != '') {
            if (this.productType == 'honda') {
                this.leaseData = JSON.parse(JSON.stringify(this.copyLeaseData));
                for (let i = 0; i < this.codeData.length; i++) {
                    if (this.codeData[i].state_cd__c.toLowerCase() == this.selectedState.toLowerCase() && this.codeData[i].prod_div_cd__c == 'A') {
                        this.branchCodeSelected = this.codeData[i].branch_cd__c;
                        this.getUIData();
                        return;
                    }
                }
            } else if (this.productType == 'acura') {
                this.leaseData = JSON.parse(JSON.stringify(this.copyLeaseData));
                for (let i = 0; i < this.codeData.length; i++) {
                    if (this.codeData[i].state_cd__c.toLowerCase() == this.selectedState.toLowerCase() && this.codeData[i].prod_div_cd__c == 'B') {
                        this.branchCodeSelected = this.codeData[i].branch_cd__c;
                        this.getUIData();
                        return;
                    }
                }
            } else {
                this.leaseData = JSON.parse(JSON.stringify(this.addressDataForNonLease));
                this.branchCodeSelected = '109';
                this.getUIData();
                return;
            }
        }

    }


    //to get phone number and address
    getUIData() {

        for (let i = 0; i < this.addressData.length; i++) {
            if (this.addressData[i].branch_cd__c == this.branchCodeSelected && this.addressData[i].acct_type_cd__c == 'R') {
                if (this.addressData[i].branch_addr_type__c == 'PYMT') {
                    this.leaseData[0].address = JSON.parse(JSON.stringify(this.addressData[i]))
                }
                if (this.addressData[i].branch_addr_type__c == 'MAIL') {
                    this.leaseData[1].address = JSON.parse(JSON.stringify(this.addressData[i]))
                }
            }
        }
        for (let i = 0; i < this.branchData.length; i++) {
            if (this.branchData[i].branch_cd__c == this.branchCodeSelected) {
                if (this.productType == 'honda') {
                    this.phonenumber = this.formatPhoneNumber(this.branchData[i].phone__c);
                } else if (this.productType == 'acura') {
                    this.phonenumber = this.formatPhoneNumber(this.branchData[i].afs_phone__c);
                } else {
                    this.phonenumber = this.formatPhoneNumber(this.branchData[i].afs_phone__c);
                }
            }
        }

    }

    get linkmobilenumber1() {
        return `tel:+${this.phonenumber}`
    }

    //once user select any state
    handleInputData(event) {
        //console.log('listofState', this.listofState);
        for (let i = 0; i < this.listofState.length; i++) {
            if (this.listofState[i].value == event.target.value) {
                let str = "Customer Service:Select State:" + this.listofState[i].label;
                let adobedata = {
                    'Event_Metadata.action_type': 'Select',
                    "Event_Metadata.action_label": str,
                    "Event_Metadata.action_category": "Contact Us",
                    "Page.page_name": "Customer Service Pre-Login",
                    "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
                };
                fireAdobeEvent(adobedata, 'click-event');
            }
        }
        this.selectedState = event.target.value;
    }

    //get all states
    getStates() {
        let Allstates = String(this.States);
        let Allstatescode = String(this.StatesCode);
        let arrStateSplit = Allstates.split(',');
        let arrStateCodeSplit = Allstatescode.split(',');
        this.listofState = arrStateSplit.map((arr1, arr2) => {
            const obj = {
                label: arr1.trim(),
                value: arrStateCodeSplit[arr2].trim()
            };
            return obj;
        });
    }


    //when user select any brand
    onFindClick(event) {
        event.stopPropagation();

        this.hondaClass = 'ahfc-pop-img';
        this.acuraClass = 'ahfc-pop-img';
        this.peClass = 'ahfc-pop-img';
        this.psClass = 'ahfc-pop-img';
        this.marineClass = 'ahfc-pop-img';

        this.isPE = false;
        this.isPS = false;
        this.isHonda = false;
        this.isMarine = false;
        this.isAcura = false;

        this.productType = event.target.dataset.name;
        let adobedata = {}

        switch (event.target.dataset.name) {
            case 'honda':
                this.isHonda = true;
                this.hondaClass = 'ahfc-pop-img ahfc-brd';
                adobedata = {
                    'Event_Metadata.action_type': 'Select',
                    "Event_Metadata.action_label": "Customer Service:Select Product:Honda Auto",
                    "Event_Metadata.action_category": "Contact Us",
                    "Page.page_name": "Customer Service Pre-Login",
                    "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
                };
                fireAdobeEvent(adobedata, 'click-event');
                break;
            case 'marine':
                this.isMarine = true;
                this.marineClass = 'ahfc-pop-img ahfc-brd';
                adobedata = {
                    'Event_Metadata.action_type': 'Select',
                    "Event_Metadata.action_label": "Customer Service:Select Product:Marine",
                    "Event_Metadata.action_category": "Contact Us",
                    "Page.page_name": "Customer Service Pre-Login",
                    "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
                };
                fireAdobeEvent(adobedata, 'click-event');
                break;
            case 'acura':
                this.isAcura = true;
                this.acuraClass = 'ahfc-pop-img ahfc-brd';
                adobedata = {
                    'Event_Metadata.action_type': 'Select',
                    "Event_Metadata.action_label": "Customer Service:Select Product:Acura Auto",
                    "Event_Metadata.action_category": "Contact Us",
                    "Page.page_name": "Customer Service Pre-Login",
                    "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
                };
                fireAdobeEvent(adobedata, 'click-event');
                break;
            case 'powersport':
                this.isPS = true;
                this.psClass = 'ahfc-pop-img ahfc-brd';
                adobedata = {
                    'Event_Metadata.action_type': 'Select',
                    "Event_Metadata.action_label": "Customer Service:Select Product:Powersports",
                    "Event_Metadata.action_category": "Contact Us",
                    "Page.page_name": "Customer Service Pre-Login",
                    "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
                };
                fireAdobeEvent(adobedata, 'click-event');
                break;
            case 'powerequipment':
                this.isPE = true;
                this.peClass = 'ahfc-pop-img ahfc-brd';
                adobedata = {
                    'Event_Metadata.action_type': 'Select',
                    "Event_Metadata.action_label": "Customer Service:Select Product:Power Equipment",
                    "Event_Metadata.action_category": "Contact Us",
                    "Page.page_name": "Customer Service Pre-Login",
                    "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
                };
                fireAdobeEvent(adobedata, 'click-event');
                break;
        }
    }
    onTabChangeEnterKey(event){
        if(event.keyCode === 13){
            this.onTabChange(event);
        }
    }

    @track tabItems = [{
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
        tabIndex: '0',
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
                "Page.page_name": "Customer Service Pre-Login",
                "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
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
                "Page.page_name": "Customer Service Pre-Login",
                "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
            };
            fireAdobeEvent(adobedata, 'click-event');
        }
    }

    //format phone number
    formatPhoneNumber(phoneNumberString) {
        var cleaned = ('' + phoneNumberString).replace(/\D/g, '');
        var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
        if (match) {
            return '(' + match[1] + ') ' + match[2] + '-' + match[3];
        }
        return null;
    }

    onHonda1() {
        this.openPopUp = true;
        this.popHead = 'Lease Maturity Center Number';
        this.popPhoneNumber = '(800) 708-6555';
        this.businesshours = 'Monday – Friday, 9 a.m. – 5 p.m. local time.';
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Customer Service:Hyperlink:End of Lease Phone",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Pre-Login",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
    }
    onHonda2() {
        this.openPopUp = true;
        this.popHead = 'Honda Care Number';
        this.popPhoneNumber = '(800) 999-5901';
        this.businesshours = 'Monday – Friday, 6 a.m. – 5 p.m. PT.';
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Customer Service:Hyperlink:Honda Care Phone",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Pre-Login",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
    }
    onHonda3() {
        this.openPopUp2 = true;
        this.popHead = 'Honda Automobiles Customer Service Numbers';
        this.popPhoneNumber = 'General Inquiries: (800) 999-1009';
        this.popPhoneNumber2 = 'In-Car Technology Support: (888) 528-7876';
        this.businesshours = 'Monday – Friday, 6 a.m. – 5 p.m. PT.';
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Customer Service:Hyperlink:Auto Customer Service Phone",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Pre-Login",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
    }

    onAcura1() {
        this.openPopUp = true;
        this.popHead = 'Lease Maturity Center Number';
        this.popPhoneNumber = '(866) 777-6495';
        this.businesshours = 'Monday – Friday, 9 a.m. – 5 p.m. local time.';
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Customer Service:Hyperlink:End of Lease Phone",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Pre-Login",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
    }
    onAcura2() {
        this.openPopUp = true;
        this.popHead = 'Acura Care Number';
        this.popPhoneNumber = '(888) 682-2872';
        this.businesshours = 'Monday – Friday, 6 a.m. – 5 p.m. PT.';
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Customer Service:Hyperlink:Acura Care Phone",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Pre-Login",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
    }
    onAcura3() {
        this.openPopUp2 = true;
        this.popHead = 'Acura Client Relations Numbers';
        this.popPhoneNumber = 'General Inquiries: (800) 382-2238';
        this.popPhoneNumber2 = 'In-Car Technology Support: (888) 528-7876';
        this.businesshours = 'Monday – Friday, 6 a.m. – 5 p.m. PT.';
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Customer Service:Hyperlink:Auto Customer Service Phone",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Pre-Login",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
    }
    onPS1() {
        this.openPopUp = true;
        this.popHead = 'HondaCare Protection Plan Number';
        this.popPhoneNumber = '(800) 555-3496';
        this.businesshours = 'Monday - Friday, 8:30 a.m. – 4:30 p.m. PT.';
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Customer Service:Hyperlink:Honda Care Phone",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Pre-Login",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
    }
    onPS2() {
        this.openPopUp = true;
        this.popHead = 'Honda Customer Service Number';
        this.popPhoneNumber = '(866) 784-1870';
        this.businesshours = 'Monday – Friday, 8:30 a.m. – 4:30 p.m. PT.';
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Customer Service:Hyperlink:Honda Customer Service Phone",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Pre-Login",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
    }
    onPE1() {
        this.openPopUp = true;
        this.popHead = 'Honda Customer Service Number';
        this.popPhoneNumber = '(770) 497-6400';
        this.businesshours = 'Monday – Friday, 9 a.m. – 7:30 p.m. ET.';
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Customer Service:Hyperlink:Honda Customer Service Phone",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Pre-Login",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
    }
    onMKarine1() {
        this.openPopUp = true;
        this.popHead = 'Honda Customer Service Number';
        this.popPhoneNumber = '(770) 497-6400';
        this.businesshours = 'Monday – Friday, 9 a.m. – 7:30 p.m. ET.';
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Customer Service:Hyperlink:Honda Customer Service Phone",
            "Event_Metadata.action_category": "Contact Us",
            "Page.page_name": "Customer Service Pre-Login",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
    }


    renderedCallback() {
        let firstClass = this.template.querySelector(".main-content");
        setTimeout(() => { fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id')); }, 1000);
    }


    get mobilenuimber2() {
        return `tel:+${this.popPhoneNumber}`;
    }
    get mobilenuimber3() {
        return `tel:+${this.popPhoneNumber2}`;
    }

}