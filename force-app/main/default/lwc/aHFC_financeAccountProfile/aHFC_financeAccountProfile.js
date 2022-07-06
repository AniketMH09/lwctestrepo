/*
COMPONENT NAME  : AHFC_financeAccountProfile 
AUTHOR          : Akash Solanki
CREATED DATE    : 25-MAY-2021
MODIFICATION LOGs
----------------      
MODIFIED DATE   : 13-AUG-2021                            MODIFIED BY : Akash Solanki
DETAILS         :
* Modified for US# 2287  Navigate contracts by Satish 
* Modifed for US 9362  Name displays on the page
*/
import { api, LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference, NavigationMixin } from "lightning/navigation";
import hondaLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import acurawhiteLogo from "@salesforce/resourceUrl/AHFC_Acura_Header_Logo";
import noLogo from "@salesforce/resourceUrl/AHFC_nologo";
import marineLogo from "@salesforce/resourceUrl/Marinelogo";
import powerEquipmentLogo from "@salesforce/resourceUrl/powerequipmentlogo";
import powersportsLogo from "@salesforce/resourceUrl/Honda_Powersports_Logo";
import carImg from "@salesforce/resourceUrl/AHFC_CAR_LOGO";
import successIcon from "@salesforce/resourceUrl/AHFC_SuccessIcon";
import AHFC_static_Image_Marine from "@salesforce/resourceUrl/AHFC_static_Image_Marine";
import AHFC_static_Image_Powerequipment from "@salesforce/resourceUrl/AHFC_static_Image_Powerequipment";
import AHFC_static_Image_Non_honda_acura from "@salesforce/resourceUrl/AHFC_static_Image_Non_honda_acura";
import AHFC_static_Image_Non_available from "@salesforce/resourceUrl/AHFC_static_Image_Non_available";
import AHFC_Acura_services_logo from "@salesforce/resourceUrl/AHFC_Acura_services_logo";
import AHFC_Auto_logo from "@salesforce/resourceUrl/AHFC_Auto_logo";
import getEconfigResponse from "@salesforce/apex/AHFC_EConfigIntegrationHandler.getEconfigResponse";
import getServiceAccountDetails from "@salesforce/apex/AHFC_DashboardController.getServiceAccountdetails";
import getEconfigResponsepower from "@salesforce/apex/AHFC_EconfigModelIntegHandler.getEconfigResponse";
import getFinannceAccountHandler from "@salesforce/apex/AHFC_EditFinanceAccount.getFinanceAccountDetails";
import getAddressDetails from "@salesforce/apex/AHFC_EditFinanceAccount.getFinannceAccountHandler";

import AHFC_Garaging_Address_Update from "@salesforce/label/c.AHFC_Garaging_Address_Update";
import AHFC_Address_or_Contact_Update_in_Queue from "@salesforce/label/c.AHFC_Address_or_Contact_Update_in_Queue"; // Added by kanagaraj for US_8037
import AHFC_Error_On_Finance_Account_Save from "@salesforce/label/c.AHFC_Error_On_Finance_Account_Save";
import AHFC_Contact_Information_Save from "@salesforce/label/c.AHFC_Contact_Information_Save";
import AHFC_Billing_Address_Update from "@salesforce/label/c.AHFC_Billing_Address_Update";
import aHFC_ContactInfoUpdatedMessage from "@salesforce/label/c.aHFC_ContactInfoUpdatedMessage";
import aHFC_NoContactFoundAccDetail from "@salesforce/label/c.aHFC_NoContactFoundAccDetail"
import spinnerWheelMessage from "@salesforce/label/c.Spinner_Wheel_Message";
import Account_Archived_Message from "@salesforce/label/c.AHFC_Account_Archived_Message"; //Added by Kanagaraj for US - 11720 
import Account_Locked_Message from "@salesforce/label/c.AHFC_Account_Locked_Message"; //Added by Kanagaraj for US - 11720 
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { refreshApex } from '@salesforce/apex';
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import { loadStyle } from "lightning/platformResourceLoader";
import { fireEvent } from 'c/pubsub'; // Added by Kanagaraj for US_8878
import { getConstants } from "c/ahfcConstantUtil";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
const CONSTANTS = getConstants();

export default class AHFC_financeAccountProfile extends NavigationMixin(LightningElement) {
    hondaLogo = hondaLogo;
    carImg = carImg;
    successIcon = successIcon;
    @track isHonda = false;
    @track isAcura = false;
    @track isHondaMarine = false;
    @track isPowerSports = false;
    @track isPowerEquipment = false;
    @track isModalOpen = false;
    @track modalHeaderText = "";
    @track nickNameModal = false;
    @track contactInfoModal = false;
    @track garageAddressModal = false;
    @track billingAddressModal = false;
    @track isEditBillingAddress = false;
    @track isEditGaragingAddress = false;
    @track isEditPhoneNumber = false;
    @track stopFinanceModal = false;
    @track modalBtnSave = "SAVE";
    @track modalBtnCancel = "CANCEL";
    @track boolResultAfterUpdate = false;
    @track boolResultAfterBillingUpdate = false;
    @api sacRecordId;

    @track contactPresent = false;
    @track contactUpdated = false;
    @track addressUpdated = false;
    @track loadingspinner = true;
    @track addressUpdateFails = false; // Added by kanagaraj for US_8037
    @track contactUpdateFails = false; // Added by kanagaraj for US_8037
    @track contactUpdateMessage;
    @track addressUpdateMessage;
    @track nickNameUpdated;
    @track nickNameSuccessMsg = "Your vehicle nickname has been updated.";
    @track isCharLimitExceeded = false; // US 9362 by Akash Solanki
    @track spinnerMessage = spinnerWheelMessage;
    //Added by Kanagaraj for US - 9506 start 
    @track marturityDate;
    @track term;
    @track totalAmountFinanced;
    @track interestPaidYear;
    @track interestPaidPriorYear;
    @track interestRate;
    @track isViewContractBtn = true;
    @track primaryOwner;
    //Added by Kanagaraj for US - 9506 end
    @track isArchived = false;
    @track isLocked = false;
    @track financeAcc;
    @track accno;
    @track VIN;
    @track AccountType;
    //@track owner;
    @track nickname;
    @track error;
    @track errorMsg = aHFC_NoContactFoundAccDetail;
    //@track resultData = [];
    @track pageRef;
    @track isContactEditModal = false;
    @track isStopFinAcctModal = false;
    @track isVehicleSwitch = true; // Added by Akash as part of bug Fix - 11658

    @track boolStopFinanceAccount = false;
    @track isUpdateSuccessfully = false;
    @track finaccId;
    @track wiredData = [];
    @track finAccRecordType = '';
    @track RTFinAcc = false;
    @track Archived_Message = Account_Archived_Message;
    @track Locked_Message = Account_Locked_Message;
    //@wire(CurrentPageReference) pageRef; //Added by Prabu Mohanasundaram for US - 7239
    @track accNoMenu;
    @track accNoWithoutZeroes = '';
    @track productName = ''; // US 9362 By Akash
    @track hondaOrAcuraBrand;
    @api resultData = {
        otherDemographics: {
            lookupID: "",
            cellPhone: "",
            cellPhone2: "",
            homePhone: "",
            placeOfEmployment: "",
            workPhone: ""
        },
        garagingAddress: {
            addressLine1: "",
            addressLine2: "",
            addressType: "",
            city: "",
            state: "",
            zipCode: ""
        },
        billToAddress: {
            addressLine1: "",
            addressLine2: "",
            addressType: "",
            city: "",
            state: "",
            zipCode: "",
            isNullBillingAddress: false
        }
    };
    @track customServiceAccounts;
    @track lstofServiceAccountwrapper;
    @track currentFinId;

    get acuraLogo() {
        return acurawhiteLogo;
    }
    get powerEquipmentLogo() {
        return powerEquipmentLogo;
    }
    get marineLogo() {
        return marineLogo;
    }
    get powersportsLogo() {
        return powersportsLogo;
    }
    get noLogo() {
        return noLogo;
    }
    renderedCallback() {
        let firstClass = this.template.querySelector(".main-content");
        console.log('Id of Skip to Main Cntent in detail page---> ', firstClass);
        console.log('Id of Skip to Main Cntent in detail page---> ', firstClass.getAttribute('id'));


        fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
    }

    /*Method by Akash Solanki - To get the record Id as state from dashboard on which ever selected account at dashboard
    /**Params: RecordId from dashboard */
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            if (typeof currentPageReference.state.sacRecordId !== "undefined") {
                this.sacRecordId = currentPageReference.state.sacRecordId;
            }
        }
    }
    // Added by Kanagaraj for US_8878 start
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.pageRef = currentPageReference;
    }

    connectedCallback() {
        if (sessionStorage.getItem('salesforce_id') != null) {
            this.currentFinId = sessionStorage.getItem('salesforce_id');
        }
        registerListener('AHFC_Account_Selected', this.getDataFromPubsubEvent, this); // Added by Kanagaraj for US_8878
        loadStyle(this, ahfctheme + "/theme.css").then(() => { }); // Added by prabu

        this.getdata();
    }

    //Added by Akash as part of Bug 14115 Fix starts
    getdata() {
        getServiceAccountDetails()
            .then(data => {
                if (data) {
                    console.log('data-------> ', data);
                    this.lstofServiceAccountwrapper = data;
                    this.formatAccounts(JSON.parse(JSON.stringify(data)));

                    if (data.length > 0) {
                        let index = 0;
                        if (this.currentFinId != undefined) {
                            console.log('this.finaccId-------> ', this.currentFinId);
                            index = this.customServiceAccounts.findIndex((item) => {
                                return item.serAccRec.Id == this.currentFinId;
                            });
                        }
                        let newArray = this.customServiceAccounts.slice(index, index + 1);
                        this.customServiceAccounts = JSON.parse(JSON.stringify(newArray));
                    }
                    this.callEconfiSerice();

                } else {
                    console.log('error', error);
                }
            })
    }
    formatAccounts(totalAccounts) {
        this.customServiceAccounts = [];

        let testarray = JSON.parse(JSON.stringify(totalAccounts));
        let newtestarray = [];
        let abc = [];

        for (let i = 0; i < testarray.length; i++) {
            if ((testarray[i].serAccRec.AHFC_Web_Account_Locked__c != undefined && testarray[i].serAccRec.AHFC_Web_Account_Locked__c == 'Y') || (testarray[i].serAccRec.AHFC_Fl_Archived__c != undefined && testarray[i].serAccRec.AHFC_Fl_Archived__c == 'Y')) {
                abc.push(testarray[i]);
            } else {
                newtestarray.push(testarray[i]);
            }
        }

        let sortedData = newtestarray.concat(abc);

        sortedData.forEach((val, index) => {

            val.keyNo = index;
            val.panelId = `panel-${index}`;
            val.ariaHidden = "true";
            val.tabIndex = "-1";
            val.indicatorId = `indicator-${index}`;
            val.indicatorClass = "slds-carousel__indicator-action";
            val.ariaSelected = "false";
            val.name = val.serAccRec ?
                val.serAccRec.AHFC_Product_Nickname__c :
                "";
            val.accNoWoZeros = val.serAccRec ?
                val.serAccRec.Finance_Account_Number_Without_Zeroes__c :
                "";
            val.accNo = val.serAccRec ?
                val.serAccRec.Finance_Account_Number__c :
                "";
            this.customServiceAccounts.push(val);
            console.log('this.customServiceAccounts-------> ', this.customServiceAccounts);
        });
    }
    //e-config service
    callEconfiSerice() {
        let econfigArray = [];
        let powersportarray = [];
        let str = '';
        let powersportstr = '';
        console.log('CustomerServicesssaccs-------> ', this.customServiceAccounts);
        for (let i = 0; i < this.customServiceAccounts.length; i++) {
            if (this.customServiceAccounts[i].serAccRec.AHFC_Product_Type__c != undefined) {
                switch (this.customServiceAccounts[i].serAccRec.AHFC_Product_Type__c) {

                    //Product type is Auto
                    case 'Auto':
                        if (this.customServiceAccounts[i].serAccRec.AHFC_Product_Division__c != undefined && this.customServiceAccounts[i].serAccRec.Vehicle_Identification_Number__c != undefined) {
                            if (this.customServiceAccounts[i].serAccRec.AHFC_Product_Division__c != "N09") {
                                if (this.customServiceAccounts[i].serAccRec.AHFC_Product_Division__c == "A03") {
                                    this.customServiceAccounts[i].cls = 'ahfc-honda-blue';
                                } else if (this.customServiceAccounts[i].serAccRec.AHFC_Product_Division__c == "B04") {

                                    this.customServiceAccounts[i].cls = 'ahfc-honda-black';
                                } else {
                                    this.customServiceAccounts[i].cls = 'ahfc-honda-black';
                                }

                                econfigArray.push({ '@vin_number': this.customServiceAccounts[i].serAccRec.Vehicle_Identification_Number__c, "@division_cd": this.customServiceAccounts[i].serAccRec.AHFC_Product_Division__c.charAt(0) })
                                this.customServiceAccounts[i].imageurl = AHFC_static_Image_Non_available;
                                console.log('this.customServiceAccounts[i].imageurl------. ', this.customServiceAccounts[i].imageurl);
                            } else {
                                if (this.customServiceAccounts[i].serAccRec.Honda_Brand__c == 'HFS') {
                                    this.customServiceAccounts[i].cls = 'ahfc-honda-blue';
                                    this.customServiceAccounts[i].imageurl = AHFC_static_Image_Non_honda_acura;
                                    console.log('this.customServiceAccounts[i].imageurl------. ', this.customServiceAccounts[i].imageurl);
                                }
                                if (this.customServiceAccounts[i].serAccRec.Honda_Brand__c == 'AFS') {
                                    this.customServiceAccounts[i].imageurl = AHFC_static_Image_Non_honda_acura;
                                    this.customServiceAccounts[i].cls = 'ahfc-honda-black';
                                    console.log('this.customServiceAccounts[i].imageurl------. ', this.customServiceAccounts[i].imageurl);
                                }
                            }
                        } else {
                            this.customServiceAccounts[i].imageurl = AHFC_static_Image_Non_available;
                            this.customServiceAccounts[i].cls = 'ahfc-honda-black';
                            console.log('this.customServiceAccounts[i].imageurl------. ', this.customServiceAccounts[i].imageurl);
                        }
                        break;

                    //Product type is Power sport
                    case 'Powersports':
                        this.customServiceAccounts[i].imageurl = AHFC_static_Image_Non_available;
                        console.log('this.customServiceAccounts[i].imageurl------. ', this.customServiceAccounts[i].imageurl);
                        this.customServiceAccounts[i].cls = 'ahfc-honda-red';
                        if (this.customServiceAccounts[i].serAccRec.AHFC_Model_ID__c != undefined) {
                            powersportarray.push({ "@id": this.customServiceAccounts[i].serAccRec.AHFC_Model_ID__c });
                        }
                        break;


                    //Product type is Marine
                    case 'Marine':
                        this.customServiceAccounts[i].imageurl = AHFC_static_Image_Marine;
                        this.customServiceAccounts[i].cls = 'ahfc-honda-navyblue';
                        console.log('this.customServiceAccounts[i].imageurl------. ', this.customServiceAccounts[i].imageurl);
                        break;

                    //Product type is Power Equipment
                    case 'Power Equipment':
                        this.customServiceAccounts[i].cls = 'ahfc-honda-red';
                        this.customServiceAccounts[i].imageurl = AHFC_static_Image_Powerequipment;
                        console.log('this.customServiceAccounts[i].imageurl------. ', this.customServiceAccounts[i].imageurl);
                        break;

                    //Product type is Other
                    case 'Other':
                        this.customServiceAccounts[i].cls = 'ahfc-honda-black';
                        this.customServiceAccounts[i].imageurl = AHFC_static_Image_Non_available;
                        console.log('this.customServiceAccounts[i].imageurl------. ', this.customServiceAccounts[i].imageurl);
                        if (this.customServiceAccounts[i].serAccRec.Honda_Brand__c != undefined) {
                            if (this.customServiceAccounts[i].serAccRec.Honda_Brand__c == 'HFS') {
                                this.customServiceAccounts[i].cls = 'ahfc-honda-blue';
                            }
                            if (this.customServiceAccounts[i].serAccRec.Honda_Brand__c == 'AFS') {
                                this.customServiceAccounts[i].cls = 'ahfc-honda-black';
                            }
                        }
                        break;
                }

            } else {
                this.customServiceAccounts[i].cls = 'ahfc-honda-black';
                this.customServiceAccounts[i].imageurl = AHFC_static_Image_Non_available;
                console.log('this.customServiceAccounts[i].imageurl------. ', this.customServiceAccounts[i].imageurl);
            }

        }
        for (let i = 0; i < econfigArray.length; i++) {
            if (i == econfigArray.length - 1) {
                str = str + JSON.stringify(econfigArray[i]);
            } else {
                str = str + JSON.stringify(econfigArray[i]) + ',';
            }

        }

        for (let i = 0; i < powersportarray.length; i++) {
            if (i == powersportarray.length - 1) {
                powersportstr = powersportstr + JSON.stringify(powersportarray[i]);
            } else {
                powersportstr = powersportstr + JSON.stringify(powersportarray[i]) + ',';
            }
        }
        if (powersportarray.length > 0) {
            this.callPowerSportWebService(powersportstr);
        }


        if (econfigArray.length > 0) {
            getEconfigResponse({ inpVin: str })
                .then(result => {

                    let imagesUrls = JSON.parse(result);
                    console.log('imagesUrls in econfig-------> ', imagesUrls);
                    let errorcode = '@error_reason';
                    if (imagesUrls[errorcode] == undefined) {
                        for (let key in imagesUrls) {
                            for (let i = 0; i < this.customServiceAccounts.length; i++) {
                                if (this.customServiceAccounts[i].serAccRec.Vehicle_Identification_Number__c == key) {
                                    this.customServiceAccounts[i].imageurl = imagesUrls[key];
                                }
                            }
                        }
                    }
                    console.log('this.customServiceAccounts-----> in econfig---> ', this.customServiceAccounts);
                })
                .catch(error => {
                    console.log('170', error);
                })
        }

    }


    //Actual web service callout for power sport images.
    callPowerSportWebService(str) {
        getEconfigResponsepower({ modelId: str })
            .then(result => {
                if (result.includes('Error')) {
                    return;
                }
                let imagesUrls = JSON.parse(result);
                console.log('imagesUrls in powersports-------> ', imagesUrls);
                for (let key in imagesUrls) {
                    for (let i = 0; i < this.customServiceAccounts.length; i++) {
                        if (this.customServiceAccounts[i].serAccRec.AHFC_Model_ID__c == key) {
                            this.customServiceAccounts[i].imageurl = imagesUrls[key];
                        }
                    }
                }
            })
            .catch(error => {
                console.log('powersport web service error', error);
            })
    }

    //Added by as part of Bug 14115 Fix Ends


    formatCurrency(curNumber) {
        var formatter = new Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "USD",
            maximumFractionDigits: 2
        });
        return formatter.format(curNumber);
    }

    dateFormater(selectedDate) {
        console.log('date>>>>', selectedDate);
        const months = CONSTANTS.MONTHS_LC;
        let duedate = new Date(selectedDate);
        duedate = new Date(duedate.getTime() + duedate.getTimezoneOffset() * 60 * 1000);
        return (duedate !== CONSTANTS.INVALID_DATE) ? `${months[duedate.getMonth()]} ${duedate.getDate()}, ${duedate.getFullYear()}` : "";
    }
    @track adobedata = {};
    getDataFromPubsubEvent(data) {

        this.adobedata = JSON.parse(data);
        console.log('438', this.adobedata);
        this.contactUpdated = false;
        this.addressUpdated = false;
        this.addressUpdateFails = false;
        this.contactUpdateFails = false;
        this.financeAcc = JSON.parse(data);
        this.sacRecordId = this.financeAcc.serAccRec.Id;
        let adobedata = {
            "Page.page_name": "Finance Account Details",
            "Page.site_section": "Finance Account Details",
            "Page.brand_name": this.adobedata.serAccRec.Honda_Brand__c ? this.adobedata.serAccRec.Honda_Brand__c : '',
            "Page.referrer_url": document.referrer

        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        //  this.OngetFinAccMenu(); // Added by prabu
    }
    // Added by Kanagaraj for US_8878 end

    formatingPhoneNumber(PhoneNumber) {
        var cleaned = ('' + PhoneNumber).replace(/\D/g, '');
        var match = cleaned.match(/^(1|)?(\d{3})(\d{3})(\d{4})$/);
        var formatedNumber = '';
        if (match) {
            var intlCode = (match[1] ? '+1 ' : '');
            formatedNumber = [intlCode, '(', match[2], ') ', match[3], '-', match[4]].join('');
        }
        return formatedNumber;
    }

    /*Method by Akash Solanki - To get the finance account record of the finane account's record Id passed.
    /**Params: Finance account record Id */
    @wire(getFinannceAccountHandler, {
        finId: '$sacRecordId'
        // finId: '00000444549136'
    }) 
    finaccDetails({
        error,
        data
    }) {
        if (data) {

           
            this.isHonda = false;
            this.isAcura = false;
            this.isHondaMarine = false;
            this.isPowerSports = false;
            this.isPowerEquipment = false;
            ``
            this.isNoImage = false;
            this.financeAcc = data;
            this.isArchived = false;
            this.isLocked = false;
            this.accno = this.financeAcc.Finance_Account_Number__c;
            this.accNoWithoutZeroes = this.financeAcc.Finance_Account_Number_Without_Zeroes__c;
            console.log('this.accNoWithoutZeroes----> ', this.accNoWithoutZeroes);
            this.VIN = this.financeAcc.Vehicle_Identification_Number__c
            this.AccountType = this.financeAcc.Account_Type__c;
            this.nickname = this.financeAcc.AHFC_Product_Nickname__c;
            this.hondaOrAcuraBrand = this.financeAcc.Honda_Brand__c;
            console.log('hondaOrAcuraBrand-->', this.hondaOrAcuraBrand);
            console.log('this.financeAcc.AHFC_Product_Type__c', this.financeAcc.AHFC_Product_Type__c);
            if (this.financeAcc.AHFC_Product_Type__c === 'Auto' &&
                this.financeAcc.AHFC_Product_Division__c == 'A03') {
                this.isHonda = true;
            } else if (this.financeAcc.AHFC_Product_Type__c === 'Auto' &&
                this.financeAcc.AHFC_Product_Division__c === 'B04') {
                this.isAcura = true;
            } else if (this.financeAcc.AHFC_Product_Type__c === 'Marine') {
                this.isHondaMarine = true;
            } else if (this.financeAcc.AHFC_Product_Type__c === 'Powersports') {
                this.isPowerSports = true;
            } else if (this.financeAcc.AHFC_Product_Type__c === 'Power Equipment') {
                this.isPowerEquipment = true;
            } else {
                this.isNoImage = true;
            }

            this.productName = this.financeAcc.AHFC_Product_Name__c; // US 9362 by Akash Solanki
            this.finaccId = this.financeAcc.Id;
            this.finAccRecordType = this.financeAcc.RecordType.Name;
            //Added by Kanagaraj for US - 9506 start
            this.marturityDate = this.financeAcc.Maturity_Date__c ? this.dateFormater(this.financeAcc.Maturity_Date__c) : "";
            this.term = this.financeAcc.Term__c ? this.financeAcc.Term__c : 0;
            this.interestRate = this.financeAcc.AHFC_APR__c ? this.financeAcc.AHFC_APR__c : 0;
            this.totalAmountFinanced = this.financeAcc.AHFC_Original_Finance_Amount__c ? this.formatCurrency(this.financeAcc.AHFC_Original_Finance_Amount__c) : "$0";
            this.interestPaidYear = this.financeAcc.AHFC_Current_YTD_Interest__c ? this.formatCurrency(this.financeAcc.AHFC_Current_YTD_Interest__c) : "$0";
            this.interestPaidPriorYear = this.financeAcc.AHFC_Previous_YTD_Interest__c ? this.formatCurrency(this.financeAcc.AHFC_Previous_YTD_Interest__c) : "$0";
            this.primaryOwner = this.financeAcc.Customer_Name__c;
            //Added by Kanagaraj for US - 9506 end

            if (this.AccountType === 'Lease' || this.AccountType === 'Balloon' || this.AccountType === 'Retail') {
                //Added by Kanagaraj for US - 8037 started
                console.log('this.accno>>>>>', this.accno);
                console.log('sessionStorage.getItem(this.accno)>>>>>', sessionStorage.getItem(this.accno));

                if (this.financeAcc.AHFC_Fl_Archived__c === 'Y') {
                    this.isArchived = true; //Added by Kanagaraj for US - 11720 
                    this.isEditBillingAddress = false;
                    this.isEditGaragingAddress = false;
                    this.isViewContractBtn = false;
                    this.isEditPhoneNumber = false;
                } else {
                    if (this.financeAcc.AHFC_Web_Manage_Phone__c === 'Y') {
                        this.isEditPhoneNumber = true;
                    } else {
                        this.isEditPhoneNumber = false;
                    }
                    if (sessionStorage.getItem(this.accno) == null) {
                        if (this.financeAcc.AHFC_Web_Account_Locked__c === 'Y') {
                            this.isLocked = true; //Added by Kanagaraj for US - 11720 
                            this.isEditBillingAddress = false;
                            this.isEditGaragingAddress = false;
                            this.isViewContractBtn = false;
                        } else {
                            this.isLocked = false;
                            this.isViewContractBtn = true;
                            this.buttonPermission();
                        }
                    } else {
                        let getaccountdata = JSON.parse(sessionStorage.getItem(this.accno));
                        if (getaccountdata.isWebsiteRestricted) {
                            this.isLocked = true;
                            this.isEditBillingAddress = false;
                            this.isEditGaragingAddress = false;
                            this.isViewContractBtn = false;
                        } else {
                            this.isLocked = false;
                            this.isViewContractBtn = true;
                            this.buttonPermission();
                        }
                    }
                }
            }
            if (this.AccountType === 'Lease') {
                this.RTFinAcc = true;
            } else { //else condition added by Kanagaraj for US - 9506 
                this.RTFinAcc = false;
            }
            /** Added by Akash Solanki as part of US 9362 starts */
            if (this.productName !== undefined) {
                if (this.productName.length >= 30 || this.primaryOwner.length >= 30) {
                    this.isCharLimitExceeded = true;
                } else {
                    this.isCharLimitExceeded = false;
                }
            }
            /** Added by Akash Solanki as part of US 9362 Ends */
        } else if (error) {
            console.log('error>>>>>> ', error);
            if(error.body.message == 'invalid access'){
                this[NavigationMixin.Navigate]({
                    type: "comm__namedPage",
                    attributes: {
                        pageName: "dashboard"
                    }
                });
            }
        }
    }
    //START - Added by Kanagaraj for the US 14112
    buttonPermission() {
        if (this.financeAcc.AHFC_Web_Manage_Garaging_Address__c === 'Y') {
            this.isEditGaragingAddress = true;
        } else {
            this.isEditGaragingAddress = false;
        }
        if (this.financeAcc.AHFC_Web_Manage_Billing_Address__c === 'Y') {
            this.isEditBillingAddress = true;
        } else {
            this.isEditBillingAddress = false;
        }
    }
    //END - Added by Kanagaraj for the US 14112
    /*Method by Akash Solanki - To get the Address details from the Demographics webservice.
    /**Params: Finance Account Number */

    @wire(getAddressDetails, {
        financeAccNumber: '$accno'
    })
    getAddressDetails({
        error,
        data
    }) {
        if (data) {
            console.log('GetDemoGraphicSuccessError');
            if (data.otherDemographics !== undefined) {
                this.resultData = data;
                console.log('this.resultData>>>>>', this.resultData);
                this.contactPresent = true;
                this.loadingspinner = false;
            } else {
                this.contactPresent = false;
                this.loadingspinner = false;
                console.log(this.resultData, '<--------Inside other demographics null data');
            }

        } else if (error) {
            console.log('661');
            console.log('Errorrrr',error);
            this.loadingspinner = false;
            this.contactPresent = false;
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
        }
    }


    onModalStopFinAcctOpen() {
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Finance Account Details:Button:Stop Managing This Finance Account",
            "Event_Metadata.action_category": "",
            "Page.page_name": "Finance Account Details",
            "Page.brand_name": this.adobedata.serAccRec.Honda_Brand__c ? this.adobedata.serAccRec.Honda_Brand__c : '',
        };
        fireAdobeEvent(adobedata, 'click-event');
        this.isStopFinAcctModal = true;
        const scrollOptions = {
            left: 0,
            top: 0,
            behavior: "smooth"
        };
        window.scrollTo(scrollOptions);
    }
    /*Method by Akash Solanki - Navigate to dashoard on click of return to dashboard . */
    navigateToDashboard() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "dashboard"
            }
        });
        var delayInMilliseconds = 100;

        setTimeout(function () {
            window.location.reload();
        }, delayInMilliseconds);
    }
    /*Method by Akash Solanki - Navigate to home page on click of return to add a finance account button. */
    navigatetoaddFincanceAccount() {
        sessionStorage.setItem('addProductFromDashboard', 'true');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'add-a-finance-account'

            },
        });
        var delayInMilliseconds = 100;

        setTimeout(function () {
            window.location.reload();
        }, delayInMilliseconds);
    }
    navigatetoContracts() {
        sessionStorage.setItem('salesforce_id', this.sacRecordId);
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Finance Account Details:Button:View Contract",
            "Event_Metadata.action_category": "Contract Details",
            "Page.page_name": "Finance Account Details",
            "Page.brand_name": this.adobedata.serAccRec.Honda_Brand__c ? this.adobedata.serAccRec.Honda_Brand__c : '',
        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "contracts"
            },
            state: {
                //financeAccNumber: this.accno,
                //serAccountNickName: this.nickname
            }
        });
    }
    navigateToCommunicationPage() {
        sessionStorage.setItem('salesforce_id', this.finaccId);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "communicationpreference"
            }
        });

    }

    closeAddressSuccesstoast() {
        this.addressUpdated = false;
    }
    closeAddresswarningtoast() {
        this.addressUpdateFails = false;
    }
    closecontactSuccesstoast() {
        this.contactUpdated = false;
    }
    closecontactwarningtoast() {
        this.contactUpdateFails = false;
    }
    onStopModalClose() {
        this.isStopFinAcctModal = false;
        console.log(" Closing cancel");
    }
    onStopModalSave() {
        this.isStopFinAcctModal = false;
        this.boolStopFinanceAccount = true;
        this.isVehicleSwitch = false;
        console.log(" Closing save");
    }

    /*Method to open the modal based on the selections like edit contact, edit garage address, edit billing address */
    onModalOpen(event) {
        console.log('729')
        const targetModal = event.target.getAttribute("data-id");
        console.log('targetModal-->',targetModal);
        this.nickNameModal = false;
        this.contactInfoModal = false;
        this.garageAddressModal = false;
        this.addressUpdated = false;
        this.addressUpdateFails = false;
        this.contactUpdateFails = false;
        this.billingAddressModal = false;
        this.stopFinanceModal = false;
        let adobedata = {};
        switch (targetModal) {
            case "nickNameEdit":
                this.modalHeaderText = "Edit nickname";
                this.nickNameModal = true;
                console.log('729', this.financeAcc);
                adobedata = {
                    'Event_Metadata.action_type': 'Button',
                    "Event_Metadata.action_label": "Finance Account Details:Button:Edit Nickname",
                    "Event_Metadata.action_category": "Vehicle Details",
                    "Page.page_name": "Finance Account Details",
                    "Page.brand_name": this.adobedata.serAccRec.Honda_Brand__c ? this.adobedata.serAccRec.Honda_Brand__c : '',
                };
                fireAdobeEvent(adobedata, 'click-event');
                console.log('729')
                break;
            case "contactInfoEdit":
                adobedata = {
                    'Event_Metadata.action_type': 'Button',
                    "Event_Metadata.action_label": "Finance Account Details:Button:Edit Contact Information",
                    "Event_Metadata.action_category": "Contact Information",
                    "Page.page_name": "Finance Account Details",
                    "Page.brand_name": this.adobedata.serAccRec.Honda_Brand__c ? this.adobedata.serAccRec.Honda_Brand__c : '',
                };
                fireAdobeEvent(adobedata, 'click-event');
                this.modalHeaderText = "Edit contact information";
                this.contactInfoModal = true;
                break;
            case "garagingAddressEdit":
                console.log('824');
                this.modalHeaderText = "Edit garaging address";
                this.garageAddressModal = true;
                adobedata = {
                    'Event_Metadata.action_type': 'Button',
                    "Event_Metadata.action_label": "Finance Account Details:Button:Edit",
                    "Event_Metadata.action_category": "Garaging Address",
                    "Page.page_name": "Finance Account Details",
                    "Page.brand_name": this.adobedata.serAccRec.Honda_Brand__c ? this.adobedata.serAccRec.Honda_Brand__c : '',
                };
                fireAdobeEvent(adobedata, 'click-event');
                break;
            case "billingAddressEdit":
                adobedata = {
                    'Event_Metadata.action_type': 'Button',
                    "Event_Metadata.action_label": "Finance Account Details:Button:Edit",
                    "Event_Metadata.action_category": "Billing Address",
                    "Page.page_name": "Finance Account Details",
                    "Page.brand_name": this.adobedata.serAccRec.Honda_Brand__c ? this.adobedata.serAccRec.Honda_Brand__c : '',
                };
                fireAdobeEvent(adobedata, 'click-event');
                this.modalHeaderText = "Edit billing address";
                this.billingAddressModal = true;
                break;
        }
        this.isModalOpen = true;
        const scrollOptions = {
            left: 0,
            top: 0,
            behavior: "smooth"
        };
        window.scrollTo(scrollOptions);
    }
    /*Method to save the data coming from modal selected*/
    onModalSave(event) {
        if (event.detail.modalName === "Contact") {
            this.isModalOpen = event.detail.isModal;
            this.isUpdateSuccessfully = event.detail.isUpdateSuccessful;
            this.isSussessCode = event.detail.isResponseCode;
            if (this.isUpdateSuccessfully === true) {
                this.resultData = JSON.parse(event.detail.resultData);
                if (this.isSussessCode === '202') { // Added by Kanagaraj for US_9118
                    const topDiv = this.template.querySelector('[data-id="contactInfoEdit"]');
                    topDiv.scrollIntoView({behavior: "smooth", block: "center", inline: "nearest"});
                    this.addressUpdateMessage = AHFC_Address_or_Contact_Update_in_Queue;
                    this.contactUpdateFails = true;
                } else {
                    //this.showSuccessMessage(AHFC_Contact_Information_Save);
                    const topDiv = this.template.querySelector('[data-id="contactInfoEdit"]');
                    topDiv.scrollIntoView({behavior: "smooth", block: "center", inline: "nearest"});
                    
                    this.contactUpdateMessage = AHFC_Contact_Information_Save;
                    this.contactUpdated = true;
                }
            } else {
                this.showErrorMessage(aHFC_ContactInfoUpdatedMessage);
            }
        } else if (event.detail.modalName === "GarageAddress") {
            this.isModalOpen = event.detail.isModal;
            this.isSussessCode = event.detail.isResponseCode;
            this.isUpdateSuccessfully = event.detail.isUpdateSuccessful;
            console.log('address successmsg>>>>', event.detail.isSuccessMessage);
            if (this.isUpdateSuccessfully === true) {
                //START - Added the code for the bug ID - 15545
                if(this.isSussessCode !== '202')
                {
                this.resultData = JSON.parse(event.detail.resultData);
                }
                //END - Added the code for the bug ID - 15545
                if (this.isSussessCode === '200') {
                    const topDiv = this.template.querySelector('[data-id="contactInfoEdit1"]');
                    topDiv.scrollIntoView({behavior: "smooth", block: "center", inline: "nearest"});
                    this.addressUpdateMessage = event.detail.isSuccessMessage;
                    this.addressUpdated = true;
                } else {
                    const topDiv = this.template.querySelector('[data-id="contactInfoEdit1"]');
                    topDiv.scrollIntoView({behavior: "smooth", block: "center", inline: "nearest"});
                    this.addressUpdateMessage = AHFC_Address_or_Contact_Update_in_Queue; // Added by Kanagaraj for US_9118
                    this.addressUpdateFails = true;
                }
            }
        } else if (event.detail.modalName === "BillAddress") {
            this.isModalOpen = event.detail.isModal;
            this.isSussessCode = event.detail.isResponseCode;
            this.isUpdateSuccessfully = event.detail.isUpdateSuccessful;
            var successMessage = event.detail.isSuccessMessage;
            if (this.isUpdateSuccessfully === true) {
                //START - Added the code for the bug ID - 15545
                if(this.isSussessCode !== '202')
                {
                this.resultData = JSON.parse(event.detail.resultData);
                }
                //END - Added the code for the bug ID - 15545
                if (this.isSussessCode === '200') {
                    const topDiv = this.template.querySelector('[data-id="contactInfoEdit1"]');
                    topDiv.scrollIntoView({behavior: "smooth", block: "center", inline: "nearest"});
                    this.addressUpdateMessage = event.detail.isSuccessMessage;
                    this.addressUpdated = true;
                } else {
                    const topDiv = this.template.querySelector('[data-id="contactInfoEdit1"]');
                    topDiv.scrollIntoView({behavior: "smooth", block: "center", inline: "nearest"});
                    this.addressUpdateMessage = AHFC_Address_or_Contact_Update_in_Queue; // Added by Kanagaraj for US_9118
                    this.addressUpdateFails = true;
                }
            }
        } else if (event.detail.modalName === "nickNameModal") {
            this.isModalOpen = event.detail.isModal;
            this.nickname = event.detail.updatedNickname;
            this.showSuccessMessage(this.nickNameSuccessMsg); //Bug 20070
            window.location.reload();


        }
    }

    onModalClose(event) {
        this.isModalOpen = event.detail;
    }
    /*Method to show success message once data is saved*/
    showSuccessMessage(showSuccessMsg) {
        const event = new ShowToastEvent({
            title: "success",
            message: showSuccessMsg,
            variant: "success",
            mode: "dismissable"
        });
        this.dispatchEvent(event);
    }
    /*Method to show error message once data is saved*/
    showErrorMessage(showErrorMsg) {
        const event = new ShowToastEvent({
            title: "Error",
            message: showErrorMsg,
            variant: "error",
            mode: "dismissable"
        });
        this.dispatchEvent(event);
    }

}