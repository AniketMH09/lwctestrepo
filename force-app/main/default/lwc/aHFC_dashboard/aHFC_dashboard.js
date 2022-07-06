/* Component Name        :    AHFC_dashboard
    * Description        :    This is LWC for Dashboard Main Page. 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aniket                     07/06/2021              Created \
    * Akash                      14/07/2021              Modifed - US 4373 - Blank Dashboard When no finance accounts are available on dashboard carousel.
    * Aniket                     8/2/2021                Modified - bug - 9976 - logo for powersport
    * Prabu                      16/08/2021              Added the code for the US - 8765
    * Narain                     24/08/2021              Added Code for US 2320
    * Prabu                      23/08/2021              Added the code for US - 4338
    * Prabu                      27/08/21                Added the code for US - 12186 to the method - OncommPreffEligible
    * Sagar                      08/09/2021              Added code for US 7659
    * Jordan Holland             10/03/2021              Added code for swipe functionality to navigate through user accounts on mobile
    * Edwin Antony               28/10/2021              Added code for initialse isShowAfterPayoff flag to false in 'onPayoffPayment' method
    * Aniket                     1/12/2022               commennted code econfig powesports images
*/
import {
    LightningElement,
    track,
    wire
} from 'lwc';
import {
    loadStyle
} from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import FORM_FACTOR from "@salesforce/client/formFactor";
import {
    CurrentPageReference
} from "lightning/navigation";
import msgCutoffDate from "@salesforce/label/c.AHFC_EDel_Message_Cutoff_Date";
import accTypeRetail from "@salesforce/label/c.accTypeRetail";
import statusPending from "@salesforce/label/c.statusPending";
import statusProcessing from "@salesforce/label/c.statusProcessing";
import statusPosted from "@salesforce/label/c.statusPosted";
import payoffAmtZero from "@salesforce/label/c.payoffAmtZero";
import bounceBackCount from "@salesforce/label/c.Bounce_Back_Count";
import cancelReasonBBU from "@salesforce/label/c.AHFC_Cancel_Reason_BBU";
import cancelReasonBBC from "@salesforce/label/c.AHFC_Cancel_Reason_BBC";
import hondaLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import acuraLogo from "@salesforce/resourceUrl/AHFC_Acura_Header_Logo";
import hondaCar from "@salesforce/resourceUrl/AHFC_Honda_Header_Car";
import powerequipmentlogo from "@salesforce/resourceUrl/powerequipmentlogo";
import Marinelogo from "@salesforce/resourceUrl/Marinelogo";
import nologo from "@salesforce/resourceUrl/AHFC_nologo";
import AHFC_Acura_services_logo from "@salesforce/resourceUrl/AHFC_Acura_services_logo";
import AHFC_Auto_logo from "@salesforce/resourceUrl/AHFC_Auto_logo";
import { fireAdobeEvent } from "c/aHFC_adobeServices";


import AHFC_static_Image_Marine from "@salesforce/resourceUrl/AHFC_static_Image_Marine";
import AHFC_static_Image_Powerequipment from "@salesforce/resourceUrl/AHFC_static_Image_Powerequipment";
import AHFC_static_Image_Non_honda_acura from "@salesforce/resourceUrl/AHFC_static_Image_Non_honda_acura";
import AHFC_static_Image_Non_available from "@salesforce/resourceUrl/AHFC_static_Image_Non_available";
import blankDashboardMarketingTile from "@salesforce/resourceUrl/AHFC_BlankDashboard_MarketingTile";
import Honda_Powersports_Logo from "@salesforce/resourceUrl/Honda_Powersports_Logo";
import AHFC_PS_Collage from "@salesforce/resourceUrl/AHFC_PS_Collage";

import getServiceAccountDetails from "@salesforce/apex/AHFC_DashboardController.getServiceAccountdetails";
import commPrefEligible from "@salesforce/apex/AHFC_CommunicationPreference.commPrefDetail";
import updateMessageAckDate from "@salesforce/apex/AHFC_EditFinanceAccount.updateMessageAckDate";
import payoffPaymentDetail from "@salesforce/apex/AHFC_Payment.beforeAfterPayoff";
import handleGetAccountInfo from "@salesforce/apex/AHFC_GetAccountInfoIntergationHandler.handleGetAccountInfo";
import getEconfigResponse from "@salesforce/apex/AHFC_EConfigIntegrationHandler.getEconfigResponse";
import getEconfigResponsepower from "@salesforce/apex/AHFC_EconfigModelIntegHandler.getEconfigResponse";
import globalAlertMessage from "@salesforce/apex/AHFC_globalAlert.globalAlertMessage";
import AHFCInventoryShortageSwitch from "@salesforce/apex/AHFC_DashboardController.AHFCInventoryShortageSwitch"; //RSS 53493 added by Narain
import spinnerWheelMessage from "@salesforce/label/c.Spinner_Wheel_Message";
import {
    refreshApex
} from '@salesforce/apex';
import {
    labels
} from "c/aHFC_dashboardConstantsUtil";
import {
    fireEvent
} from 'c/pubsub';
import {
    NavigationMixin
} from "lightning/navigation";

export default class AHFC_dashboard extends NavigationMixin(LightningElement) {


    @track isSMSCommPreffInfo = false;
    @track isUpdateSMSCommPreff = false;
    @track isShowEmailBounce = false;
    @track isUpdateEmailCommPreff;
    @track payoffDetails;
    @track payoffFinId;
    @track isShowBeforePayoff = false;
    @track isShowAfterPayoff = false;
    @track isPayoffPosted = false;
    @track isStmtSuppressed = false;
    @track showCriticalAlertPastDue = false;
    @track isNotLockedCritical = false;
    @track isNotArchivedCritical = false;
    @track wiredAccountList = [];
    @track currentFinAccId = '';
    @track labels = labels;
    @track isHonda = true; // Car Logo Logic
    @track showCarDetailsMobile = false; // Show Car Info in Mobile Logic
    @track showMadePayment;
    @track showBlankDashboard = false;
    @track isEditNickname = false;
    @track lstofServiceAccountwrapper;
    @track selServiceAccountWrapperForHeader = [];
    @track selServiceAccountWrapper;
    @track selServiceAccountWrapperForMobile;
    @track showCarousel;
    @track showdashboard;
    @track isCarousalFirstItem = true;
    @track carousalPrevButtonClass = "slds-button carousal-button-desktop carousal-button-disabled";
    @track isCarousalLastItem = false;
    @track carousalNextButtonClass = "slds-button carousal-button-desktop";
    @track showdesktop;
    @track showmobile;
    @track isPastDueOneTime = false;
    currentItem;
    @track passDataTooStatements;
    @track spinnerMessage = spinnerWheelMessage;
    @track isLoaded = false;
    @track isLocked = false;
    @track lockedmobile = [];
    @track currentFinId = '';
    @track isEOTDashboardInfo = false; // 4674 - EOT info section
    @track isCommPreffInfo = false;
    @track isPaidAheadInfo = false;
    @track isStmtCloseInfo = false;
    @track isBeforePayoffInfo = false;
    @track isAfterPayoffInfo = false;
    @track isEmailCommPreffInfo = false;
    @track isClosePastDue = false;
    @track nickNameNew = '';
    @track isClosed = false;
    @track commPrefFinId;
    @track commPrefData;
    @track commPreffDetails;
    @track lstPayoff;
    @track isCommPreff = false;
    @track isPaidAhead = false;
    @track paymentDueDate;
    /*US 3827 Variables*/
    @track isSmsBounced = false;
    @track isEmailBounced = false;
    @track isSmsAndEmailBounced = false;
    /* US 2320 -- Added by Narain */
    @track globalAlertFlag = false;
    @track alertMessageArray = [];
    @track alertMessage;
    @track alertMessageArrayMain = [];
    @track webDashboardPaymentProgress = true;
    // Swipe functionality start
    @track swipeStart;
    @track swipeEnd;
    @track customerSurvey = false; // Added by Narain 4152
    @track iscustomer;
    @track inventoryShortage = false; // RSS 53493 added by Narain
    @track is4MonthEOT=false; // RSS 53493 added by Narain
    @track is2MonthEOT=false; // RSS 53493 added by Narain
    touchStart(event) {
        this.swipeStart = event.touches[0].clientX;
    }

    touchEnd(event) {
        const minimumDistanceSwipe = 100;
        this.swipeEnd = event.changedTouches[0].clientX;
        // Right Swipe
        if (this.swipeStart > (this.swipeEnd + minimumDistanceSwipe)) {
            this.onCarousalNextDesktop();
        }
        // Left Swipe
        else if (this.swipeStart < (this.swipeEnd - minimumDistanceSwipe)) {
            this.onCarousalPrevDesktop();
        } else {
            // do nothing
        }
    }
    // Swipe functionality end

    get hondaLogoUrl() {
        return hondaLogo;
    }

    get acuraLogoUrl() {
        return acuraLogo;
    }

    get hondaCarUrl() {
        return hondaCar;
    }


    //Blank State Dashboard - US 4373
    get blankDashboardMarketingTileURL() {
        return blankDashboardMarketingTile;
    }


    @wire(CurrentPageReference) pageRef;

    renderedCallback() {
        let xyz = this.template.querySelector(".slds-combobox__input");
        console.log('xyz>>>', xyz);
        let firstClass = this.template.querySelector(".main-content");
        fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
    }

    //Mobile view for Locked Accounts
    @track lockedmobileSections = [{
        id: "0",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: this.labels.DashboardFaq,
        isGrayedOut: false,
        isFaqs: true
    }

    ];


    // Mobile Section Accordion Logic
    @track mobileSections = [{
        id: "0",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: this.labels.DashboardPaymentProgress,
        isPaymentProgress: true
    },
    {
        id: "1",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: this.labels.DashboardPaymentActivity,
        isPaymentActivity: true
    },
    {
        id: "2",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: this.labels.DashboardStatements,
        isStatements: true
    },
    {
        id: "3",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: this.labels.DashboardSupportRequest,
        isSupportRequest: true
    },
    {
        id: "4",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: this.labels.DashboardCorrespondence,
        isCorrespondence: true
    },
    {
        id: "5",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: this.labels.DashboardFaq,
        isFaqs: true
    }
        // ,
        // {
        //     id: "6",
        //     class: "slds-accordion__section",
        //     contentClass: "slds-accordion__content",
        //     isOpened: false,
        //     header: this.labels.DashboardFaq,
        //     isFaqs: true
        // }

    ];

    // Jordan's Swipe functionality
    testDrag() {
        console.log('I am dragging');
    }
    testClick() {
        console.log('I am clicking');
    }

    //preparetion of e-config service input data
    econfiServicePreapartion() {
        let econfigArray = [];
        let powersportarray = [];
        let str = '';
        let powersportstr = '';


        for (let i = 0; i < this.selServiceAccountWrapperForHeader.length; i++) {
            if (this.selServiceAccountWrapperForHeader[i].serAccRec.AHFC_Product_Type__c != undefined) {
                // this.selServiceAccountWrapperForHeader[i].imageclass = true;
                switch (this.selServiceAccountWrapperForHeader[i].serAccRec.AHFC_Product_Type__c) {

                    //Product type is Auto
                    case 'Auto':

                        if (this.selServiceAccountWrapperForHeader[i].serAccRec.AHFC_Product_Division__c != undefined && this.selServiceAccountWrapperForHeader[i].serAccRec.Vehicle_Identification_Number__c != undefined) {
                            if (this.selServiceAccountWrapperForHeader[i].serAccRec.AHFC_Product_Division__c != "N09") {
                                if (this.selServiceAccountWrapperForHeader[i].serAccRec.AHFC_Product_Division__c == "A03") {
                                    this.selServiceAccountWrapperForHeader[i].logourl = hondaLogo;
                                    this.selServiceAccountWrapperForHeader[i].cls = 'ahfc-honda-blue';
                                } else if (this.selServiceAccountWrapperForHeader[i].serAccRec.AHFC_Product_Division__c == "B04") {
                                    this.selServiceAccountWrapperForHeader[i].logourl = acuraLogo;
                                    this.selServiceAccountWrapperForHeader[i].cls = 'ahfc-honda-black';
                                } else {
                                    this.selServiceAccountWrapperForHeader[i].logourl = nologo;
                                    this.selServiceAccountWrapperForHeader[i].cls = 'ahfc-honda-black';
                                }


                                econfigArray.push({
                                    '@vin_number': this.selServiceAccountWrapperForHeader[i].serAccRec.Vehicle_Identification_Number__c,
                                    "@division_cd": this.selServiceAccountWrapperForHeader[i].serAccRec.AHFC_Product_Division__c.charAt(0)
                                })
                                this.selServiceAccountWrapperForHeader[i].imageurl = AHFC_static_Image_Non_available;
                            } else {
                                if (this.selServiceAccountWrapperForHeader[i].serAccRec.Honda_Brand__c == 'HFS') {
                                    this.selServiceAccountWrapperForHeader[i].logourl = hondaLogo;
                                    this.selServiceAccountWrapperForHeader[i].imageurl = AHFC_static_Image_Non_honda_acura;
                                    this.selServiceAccountWrapperForHeader[i].cls = 'ahfc-honda-blue';
                                }
                                if (this.selServiceAccountWrapperForHeader[i].serAccRec.Honda_Brand__c == 'AFS') {
                                    this.selServiceAccountWrapperForHeader[i].logourl = acuraLogo;
                                    this.selServiceAccountWrapperForHeader[i].imageurl = AHFC_static_Image_Non_honda_acura;
                                    this.selServiceAccountWrapperForHeader[i].cls = 'ahfc-honda-black';
                                }
                            }
                        } else {
                            this.selServiceAccountWrapperForHeader[i].imageurl = AHFC_static_Image_Non_available;
                            this.selServiceAccountWrapperForHeader[i].logourl = nologo;
                            this.selServiceAccountWrapperForHeader[i].cls = 'ahfc-honda-black';
                        }
                        break;

                    //Product type is Power sport
                    case 'Powersports':
                        this.selServiceAccountWrapperForHeader[i].logourl = Honda_Powersports_Logo;
                        this.selServiceAccountWrapperForHeader[i].imageurl = AHFC_PS_Collage;
                        this.selServiceAccountWrapperForHeader[i].cls = 'ahfc-honda-red';
                        // if (this.selServiceAccountWrapperForHeader[i].serAccRec.AHFC_Model_ID__c != undefined) {
                        //     powersportarray.push({
                        //         "@id": this.selServiceAccountWrapperForHeader[i].serAccRec.AHFC_Model_ID__c
                        //     });
                        // }
                        break;

                    //Product type is Marine
                    case 'Marine':
                        this.selServiceAccountWrapperForHeader[i].logourl = Marinelogo;
                        this.selServiceAccountWrapperForHeader[i].imageurl = AHFC_static_Image_Marine;
                        this.selServiceAccountWrapperForHeader[i].cls = 'ahfc-honda-navyblue';
                        break;

                    //Product type is Power Equipment
                    case 'Power Equipment':
                        this.selServiceAccountWrapperForHeader[i].logourl = powerequipmentlogo;
                        this.selServiceAccountWrapperForHeader[i].imageurl = AHFC_static_Image_Powerequipment;
                        this.selServiceAccountWrapperForHeader[i].cls = 'ahfc-honda-red';
                        break;

                    //Product type is Other
                    case 'Other':
                        this.selServiceAccountWrapperForHeader[i].logourl = nologo;
                        this.selServiceAccountWrapperForHeader[i].cls = 'ahfc-honda-black';
                        this.selServiceAccountWrapperForHeader[i].imageurl = AHFC_static_Image_Non_available;
                        if (this.selServiceAccountWrapperForHeader[i].serAccRec.Honda_Brand__c != undefined) {
                            if (this.selServiceAccountWrapperForHeader[i].serAccRec.Honda_Brand__c == 'HFS') {
                                this.selServiceAccountWrapperForHeader[i].logourl = AHFC_Auto_logo;
                                this.selServiceAccountWrapperForHeader[i].cls = 'ahfc-honda-blue';
                            }
                            if (this.selServiceAccountWrapperForHeader[i].serAccRec.Honda_Brand__c == 'AFS') {
                                this.selServiceAccountWrapperForHeader[i].logourl = AHFC_Acura_services_logo;
                                this.selServiceAccountWrapperForHeader[i].cls = 'ahfc-honda-black';
                            }
                        }
                        break;
                    default:
                        this.selServiceAccountWrapperForHeader[i].cls = 'ahfc-honda-black';
                        this.selServiceAccountWrapperForHeader[i].logourl = nologo;
                        this.selServiceAccountWrapperForHeader[i].imageurl = AHFC_static_Image_Non_available;
                }
            } else {
                this.selServiceAccountWrapperForHeader[i].cls = 'ahfc-honda-black';
                this.selServiceAccountWrapperForHeader[i].logourl = nologo;
                this.selServiceAccountWrapperForHeader[i].imageurl = AHFC_static_Image_Non_available;
            }
        }

console.log('396', this.selServiceAccountWrapperForHeader);
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
console.log('410',powersportarray);
        if (econfigArray.length > 0) {
            this.callEconfigWebService(str);
        }

        if (powersportarray.length > 0) {
            this.callPowerSportWebService(powersportstr);
        }



    }

    callPowerSportWebService(str) {
        getEconfigResponsepower({
            modelId: str
        })
            .then(result => {
console.log('428', result);
                if (result.includes('Error')) {
                    return;
                }
                let imagesUrls = JSON.parse(result);
                for (let key in imagesUrls) {
                    for (let i = 0; i < this.selServiceAccountWrapperForHeader.length; i++) {
                        if (this.selServiceAccountWrapperForHeader[i].serAccRec.AHFC_Model_ID__c == key) {
                            this.selServiceAccountWrapperForHeader[i].imageurl = imagesUrls[key];
                            if(imagesUrls[key].includes('?ps=true')){
                                console.log('466');
                                this.selServiceAccountWrapperForHeader[i].imageclass1 = false;
                                this.selServiceAccountWrapperForHeader[i].imageclass2 = false;
                                this.selServiceAccountWrapperForHeader[i].imageclass3 = true;
                            }
                        }
                    }
                }
            })
            .catch(error => {
                console.log('powersport web service error', error);
            })
    }


    //Actual Econfig web service callout
    callEconfigWebService(str) {
 
        getEconfigResponse({
            inpVin: str
        })
            .then(result => {

                let imagesUrls = JSON.parse(result);
                console.log()
                let errorcode = '@error_reason';
                if (imagesUrls[errorcode] == undefined) {
                    for (let key in imagesUrls) {
                        for (let i = 0; i < this.selServiceAccountWrapperForHeader.length; i++) {
                            if (this.selServiceAccountWrapperForHeader[i].serAccRec.Vehicle_Identification_Number__c == key) {
                                if (!imagesUrls[key].includes('Error')) {
                                    this.selServiceAccountWrapperForHeader[i].imageurl = imagesUrls[key];
                                }
                                if(imagesUrls[key].includes('?css=true')){
                                    console.log('466');
                                    this.selServiceAccountWrapperForHeader[i].imageclass1 = false;
                                    this.selServiceAccountWrapperForHeader[i].imageclass2 = true;
                                    this.selServiceAccountWrapperForHeader[i].imageclass3 = false;
                                }
                                
                            }
                        }
                    }
                }
                console.log('473', this.selServiceAccountWrapperForHeader)
            })
            .catch(error => {
                console.log('170', error);
            })
    }
    testMethod() {
        console.log('xxxxx-1');
        getServiceAccountDetails()
            .then(result => {
                console.log('xxxxx-2');
                this.wiredAccountList = result;
                if (result) {
                    console.log('result', result);
                    this.lstofServiceAccountwrapper = result;
                    this.showCarousel = result.length > 1 ? true : false;
                    if (result.length > 0) {
                        this.formatAccounts(JSON.parse(JSON.stringify(result)));
                        this.econfiServicePreapartion();
                        this.showBlankDashboard = false;

                        console.log('sessionStorage.getItem', sessionStorage.getItem('recentfinanceAccountNo'))
                        if (this.currentFinAccId != '') {
                            console.log('482')
                            for (let i = 0; i < this.selServiceAccountWrapperForHeader.length; i++) {
                                if (this.selServiceAccountWrapperForHeader[i].serAccRec.Id == this.currentFinAccId) {
                                    this.selServiceAccountWrapperForHeader[i].name = this.nickNameNew;
                                    this.setPageData('', i);
                                }
                            }
                        } else if (sessionStorage.getItem('salesforce_id') != null) {
                            console.log('490');
                            if (sessionStorage.getItem('salesforce_id') != null) {
                                let isgot = false;
                                sessionStorage.setItem('reloaded', 'true');
                                for (let i = 0; i < this.selServiceAccountWrapperForHeader.length; i++) {
                                    if (this.selServiceAccountWrapperForHeader[i].serAccRec.Id == sessionStorage.getItem('salesforce_id')) {
                                        isgot = true;
                                        this.setPageData('', i);
                                    }
                                }
                                if (isgot == false) {
                                    if (sessionStorage.getItem('salesforce_id_index') != null) {
                                        if (this.selServiceAccountWrapperForHeader[sessionStorage.getItem('salesforce_id_index')] != undefined) {
                                            this.setPageData('', sessionStorage.getItem('salesforce_id_index'));
                                        } else {
                                            this.setPageData('', 0);
                                        }

                                    } else {
                                        this.setPageData('', 0);
                                    }

                                }
                            } else {
                                this.setPageData('', 0);
                            }
                        } else {
                            this.setPageData('', 0);
                        }
                        // US 6850 by Narain
                        if (sessionStorage.getItem('recentfinanceAccountNo') != null) {

                            for (let i = 0; i < this.selServiceAccountWrapperForHeader.length; i++) {
                                if (this.selServiceAccountWrapperForHeader[i].serAccRec.Id == sessionStorage.getItem('recentfinanceAccountNo')) {
                                    console.log('Checking i', i);

                                    this.setPageData('', i);
                                }
                            }
                            sessionStorage.setItem('recentfinanceAccountNo', null);
                        }

                    } else {
                        //Blank State Dashboard - US 4373
                        this[NavigationMixin.Navigate]({
                            type: "comm__namedPage",
                            attributes: {
                                pageName: 'dashboard-blank'
                            },
                        });
                    }

                    this.showdashboard = true;
                } else {
                    console.log('error', result.error);
                }
            })
            console.log('xxxxx-3');
    }



    //To get Account info from web sevice call
    getAccountInfo(findata) {

        this.isLocked = false;
        this.isClosed = false;
        let newfindata = JSON.parse(findata);
        let obj = {};
        obj.boolenrolled = newfindata.boolenrolled;
        obj.Id = newfindata.serAccRec.Id;
        if (newfindata.serAccRec.AHFC_Web_Account_Locked__c == undefined && newfindata.serAccRec.AHFC_Fl_Archived__c == undefined) {
            obj.AHFC_Web_Account_Locked__c = "N";
            obj.AHFC_Fl_Archived__c = "N";
        } else if (newfindata.serAccRec.AHFC_Web_Account_Locked__c != undefined && newfindata.serAccRec.AHFC_Fl_Archived__c == undefined) {
            obj.AHFC_Web_Account_Locked__c = newfindata.serAccRec.AHFC_Web_Account_Locked__c;
            obj.AHFC_Fl_Archived__c = 'N';
        } else if (newfindata.serAccRec.AHFC_Web_Account_Locked__c == undefined && newfindata.serAccRec.AHFC_Fl_Archived__c != undefined) {
            obj.AHFC_Web_Account_Locked__c = 'N';
            obj.AHFC_Fl_Archived__c = newfindata.serAccRec.AHFC_Fl_Archived__c;
        } else {
            obj.AHFC_Web_Account_Locked__c = newfindata.serAccRec.AHFC_Web_Account_Locked__c;
            obj.AHFC_Fl_Archived__c = newfindata.serAccRec.AHFC_Fl_Archived__c;
        }

        let payload = {
            finaAccountData: obj,
            getAccountInfo: '',
           
        };
        if (newfindata.serAccRec.AHFC_Fl_Archived__c !== undefined && newfindata.serAccRec.AHFC_Fl_Archived__c == 'Y') {
            this.isLocked = true;
            this.isStmtSuppressed = false;
            this.isClosed = true;
            fireEvent(this.pageRef, 'financeAccountInfo', JSON.stringify(payload));
            return;
        }


        if (sessionStorage.getItem(newfindata.accNo) == null) {
            console.log('540');
            this.isLoaded = true;
            handleGetAccountInfo({
                strFinanceAccount: newfindata.accNo
            })
                .then(data => {
                    console.log('dataxyz', data);
                    if (data != 'FAILED') {
                        sessionStorage.setItem(newfindata.accNo, data);
                        let getaccountdata = JSON.parse(data);
                        console.log('getaccountdata >>>>>> ', getaccountdata);
                        this.onCriticalAlert(this.selServiceAccountWrapper); //Added by Prabu for the US - 8755 
                        this.OncommPrefEligible(this.selServiceAccountWrapper); //Added by Prabu for the US - 8765
                        this.onPayoffPayment(this.selServiceAccountWrapper); //Added by Prabu for the US - 4338 
                        payload.getAccountInfo = getaccountdata;
                        fireEvent(this.pageRef, 'financeAccountInfo', JSON.stringify(payload));
                        if (getaccountdata.isWebsiteRestricted == true) {
                            this.isLocked = true;
                        }
                    } else {
                        fireEvent(this.pageRef, 'financeAccountInfo', JSON.stringify(payload));
                        this.onCriticalAlert(this.selServiceAccountWrapper); //Added by Prabu for the bug - 21540 
                    }

                    this.isLoaded = false;
                })
                .catch(error => {
                    console.log('error 362', error);
                    this.isLoaded = false;
                    fireEvent(this.pageRef, 'financeAccountInfo', JSON.stringify(payload));
                    if (newfindata.serAccRec.AHFC_Web_Account_Locked__c !== undefined) {
                        if (newfindata.serAccRec.AHFC_Web_Account_Locked__c == 'Y') {
                            this.isLocked = true;
                        }
                        if (newfindata.serAccRec.AHFC_Web_Account_Locked__c == 'N') {
                            this.isLocked = false;
                        }
                    }
                })
        } else {
            let sessioneddata = JSON.parse(sessionStorage.getItem(newfindata.accNo));
            this.onCriticalAlert(this.selServiceAccountWrapper); //Added by Prabu for the US - 8755 
            this.OncommPrefEligible(this.selServiceAccountWrapper); //Added by Prabu for the US - 8765
            this.onPayoffPayment(this.selServiceAccountWrapper); //Added by Prabu for the US - 4338 
            payload.getAccountInfo = sessioneddata;
            if (sessioneddata.isWebsiteRestricted) {
                this.isLocked = true;
            }
            fireEvent(this.pageRef, 'financeAccountInfo', JSON.stringify(payload));

        }

    }


    //connected call back
    connectedCallback() {
        // if (sessionStorage.getItem('reloaded') != null) {
        //     if (sessionStorage.getItem('reloaded') == 'false') {
        //         sessionStorage.setItem('reloaded', 'true');
        //         window.location.reload();
        //     }
        // }

        let adobedata = {
            "Page.page_name": "Dashboard",
            "Page.site_section": "Dashboard",
            "Page.referrer_url": document.referrer
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');


        this.globalAlert();
        this.testMethod();        
        this.AHFCInventoryShortageSwitch(); //RSS 53493 added by Narain
        if (sessionStorage.getItem('surveystarted') != 'true') {
            sessionStorage.setItem('surveystarted', 'true');
            console.log('line 668',sessionStorage.getItem('surveystarted'))
            this.customerSurvey = true;
        }
        //this.iscustomer = true;
        console.log('Test survery', this.customerSurvey);
        //  this.OncommPrefEligible();
        this.lockedmobile = JSON.parse(JSON.stringify(this.mobileSections));
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
        if (FORM_FACTOR == this.labels.Large) {
            this.showdesktop = true;
            this.showmobile = false;
        } else if (FORM_FACTOR == this.labels.Medium) {
            this.showdesktop = true;
            this.showmobile = false;
        } else {
            this.showdesktop = false;
            this.showmobile = true;
        }
        this.showdesktop = true;
        /*Bug fix 21924  - to show all my account menu items*/
        sessionStorage.setItem('ContentPageCheck', 'false'); 
        fireEvent(this.pageRef, 'populateMenu');

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

    // Format account to show on dashboard.
    formatAccounts(totalAccounts) {
        this.selServiceAccountWrapperForHeader = [];

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
            val["panelClass"] = "slds-carousel__panel slds-carousel__panel_hide";
            val.name = val.serAccRec ?
                val.serAccRec.AHFC_Product_Nickname__c :
                "";
            val.vin = val.serAccRec ?
                val.serAccRec.Vehicle_Identification_Number__c :
                "";
            val.accNoWoZeros = val.serAccRec ?
                val.serAccRec.Finance_Account_Number_Without_Zeroes__c :
                "";
            val.accNo = val.serAccRec ?
                val.serAccRec.Finance_Account_Number__c :
                "";

            val.accType = val.serAccRec ? val.serAccRec.Account_Type__c : "";
            val.imageclass1 = true;
            val.imageclass2 = false;
            val.imageclass3 = false;
            this.selServiceAccountWrapperForHeader.push(val);

        });




    }

    // 4674 - EOT info section start
    closeinfo(event) {
        this.isEOTDashboardInfo = false;
    }
    // 4674 - EOT info section end

     // 53493 - EOT info section start
     closeinfo2(event) {
        
        this.is2MonthEOT= false; 
      
    }
    // 53493 - EOT info section end

     // 53493 - EOT info section start
     closeinfo4(event) {
        this.is4MonthEOT = false;
      
    }
    // 53493 - EOT info section end

    closeCommPreff() {
        this.isCommPreffInfo = false;
    }
    closePaidAhead() {
        this.isPaidAheadInfo = false;
    }
    closePastDue() {
        this.isClosePastDue = false;
    }
    closeStmt() {
        this.isStmtCloseInfo = false;
    }
    closeBefore() {
        this.isBeforePayoffInfo = false;
    }
    closeAfter() {
        this.isAfterPayoffInfo = false;
    }
    closeEmail() {
        this.isEmailCommPreffInfo = false;
    }
    closeSMS() {
        this.isSMSCommPreffInfo = false;
    }
    //setup account data when toggle.
    setPageData(prevPage, nextPage) {
        //START - Added by Prabu for clearing variables for Critical Alert, Comm Preff Alert, Payoff Alert US.
        this.isCommPreff = false;
        this.isCommPreffInfo = false;
        this.showCriticalAlertPastDue = false;
        this.isNotLockedCritical = false;
        this.isStmtSuppressed = false;
        this.isStmtCloseInfo = false;
        this.isNotArchivedCritical = false;
        this.isUpdateEmailCommPreff = false;
        this.isUpdateSMSCommPreff = false;
        this.isShowEmailBounce = false;
        this.isSMSCommPreffInfo = false;
        this.isPayoffPosted = false;
        this.isShowBeforePayoff = false;
        this.isBeforePayoffInfo = false;
        this.isAfterPayoffInfo = false;
        this.isShowAfterPayoff = false;
        //END -Added by Prabu for clearing variables for Critical Alert, Comm Preff Alert, Payoff Alert US.
        if (prevPage + "") {
            this.selServiceAccountWrapperForHeader[prevPage].ariaHidden = "true";
            this.selServiceAccountWrapperForHeader[prevPage].tabIndex = "-1";
            this.selServiceAccountWrapperForHeader[prevPage].indicatorClass = "slds-carousel__indicator-action";
            this.selServiceAccountWrapperForHeader[prevPage].ariaSelected = "false";
            this.selServiceAccountWrapperForHeader[prevPage]["panelClass"] = "slds-carousel__panel slds-carousel__panel_hide";
        }
        this.selServiceAccountWrapperForHeader[nextPage].ariaHidden = "false";
        this.selServiceAccountWrapperForHeader[nextPage].tabIndex = "0";
        this.selServiceAccountWrapperForHeader[nextPage].indicatorClass = "slds-carousel__indicator-action slds-is-active";
        this.selServiceAccountWrapperForHeader[nextPage].ariaSelected = "true";
        this.selServiceAccountWrapperForHeader[nextPage]["panelClass"] = "slds-carousel__panel";

        let panelBlock = this.template.querySelector(`.ahfc-carousal .slds-carousel__panels`);
        const transform = nextPage * 100;
        // if (panelBlock) {
        //     panelBlock.style.transform = `translateX(-${transform}%)`;
        // }
        this.currentItem = nextPage;
        this.displayicons();

        this.selServiceAccountWrapper = JSON.stringify(this.selServiceAccountWrapperForHeader[this.currentItem]);
        this.selServiceAccountWrapperForMobile = this.selServiceAccountWrapperForHeader[this.currentItem];
        this.getAccountInfo(this.selServiceAccountWrapper);

        // console.log('this.selServiceAccountWrapper >>>>>>>> '+this.selServiceAccountWrapperForHeader[this.currentItem]);
        // console.log('this.selServiceAccountWrapper.serAccRec >>>>>>>> '+this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec);

        /* US -7659 Start  added by sagar */
        console.log('webDashboardPaymentProgress flag >>>>>>>> ' + this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.AHFC_Web_Dashboard_Payment_Progress__c);

        if (this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.AHFC_Web_Dashboard_Payment_Progress__c == 'N') {
            this.webDashboardPaymentProgress = false;
        } else {
            this.webDashboardPaymentProgress = true;
        }

        console.log('this.webDashboardPaymentProgress >>>>>>>> ' + this.webDashboardPaymentProgress);

        /* US -7659 End  */

        //this.OncommPrefEligible(this.selServiceAccountWrapper); //Added by Prabu for the US - 8765
        this.isPaidAhead = false;
        /*Added by Prabu for US 8765 Start */
        if (this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.Fl_Paid_Ahead__c) {
            if (this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.Paid_to_Date__c !== null &&
                this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.Paid_to_Date__c !== undefined) {
                this.isPaidAhead = true;
                this.isPaidAheadInfo = true;
                console.log('Paidtodate-->', this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.Paid_to_Date__c);
                this.paymentDueDate =
                    this.formatshortdate(this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.Paid_to_Date__c) + '.';
            }
        }
        /*US 8765 End */




        this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.AHFC_Total_days_past_due__c = typeof this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.AHFC_Total_days_past_due__c != "undefined" ? this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.AHFC_Total_days_past_due__c : 0;
        // TO show Aready made payment option only for due date between 2-30 past days
        /* if (
             this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec
             .AHFC_Total_days_past_due__c > 2 &&
             this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec
             .AHFC_Total_days_past_due__c < 30
         ) {
             this.showMadePayment = true;
         } else {
             this.showMadePayment = false;
         } */
        /*  4674 - EOT info section start
        if (this.selServiceAccountWrapperForHeader[this.currentItem].inDaysEOT <= 180 &&
            this.selServiceAccountWrapperForHeader[this.currentItem].inDaysEOT >= 0 &&
            this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.Account_Type__c === 'Lease' &&
            (this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.Region_Code__c !== 'BKC') &&
            this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.AHFC_Web_Payoff_Calendar__c !== 'A') {
            this.isEOTDashboardInfo = true;
        } else {
            this.isEOTDashboardInfo = false;
        }
         4674 - EOT info section end */

         //RSS 53493 start
         if (this.selServiceAccountWrapperForHeader[this.currentItem].inDaysEOT <= 60 &&
            this.selServiceAccountWrapperForHeader[this.currentItem].inDaysEOT >= 0 &&
            this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.Account_Type__c === 'Lease' &&
            (this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.Region_Code__c !== 'BKC') &&
            this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.AHFC_Web_Payoff_Calendar__c !== 'A') {
           
            if(this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.FL_LE_Eligibility__c == true){
                this.is2MonthEOT= true; 
                this.isEOTDashboardInfo = true;
                this.is4MonthEOT= false; 
               
            }
            else{
                this.is4MonthEOT= true; 
                this.isEOTDashboardInfo = true;
                this.is2MonthEOT= false;
                
            }
         } 
		 
 
 else if (this.selServiceAccountWrapperForHeader[this.currentItem].inDaysEOT <= 120 &&
    this.selServiceAccountWrapperForHeader[this.currentItem].inDaysEOT > 60 &&
    this.selServiceAccountWrapperForHeader[this.currentItem].inDaysEOT >= 0 &&
    this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.Account_Type__c === 'Lease' &&
    (this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.Region_Code__c !== 'BKC') &&
    this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.AHFC_Web_Payoff_Calendar__c !== 'A') {
    this.is4MonthEOT= true;
    this.isEOTDashboardInfo = true;
    this.is2MonthEOT= false;
                
}
else if (this.selServiceAccountWrapperForHeader[this.currentItem].inDaysEOT <= 180 &&
            this.selServiceAccountWrapperForHeader[this.currentItem].inDaysEOT >= 0 &&
            this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.Account_Type__c === 'Lease' &&
            (this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.Region_Code__c !== 'BKC') &&
            this.selServiceAccountWrapperForHeader[this.currentItem].serAccRec.AHFC_Web_Payoff_Calendar__c !== 'A') {
            this.isEOTDashboardInfo = true;
            this.is2MonthEOT= false;
            this.is4MonthEOT= false;
			                
        }  
else {
    this.is4MonthEOT = false;
	this.is2MonthEOT= false; 
	this.isEOTDashboardInfo = false;
}
//RSS 53493 end


        if (this.showdashboard && !this.showBlankDashboard) {
            let lwcs = this.template
                .querySelectorAll("c-a-h-f-c_dashboard-payment-activity");
            for (let i = 0; i < lwcs.length; i++) {
                lwcs[i].handleValueChange(this.selServiceAccountWrapper);
            }

            lwcs = this.template
                .querySelectorAll("c-a-h-f-c_supportcorrespondence");
            for (let i = 0; i < lwcs.length; i++) {
                lwcs[i].handleValueChange(this.selServiceAccountWrapper);
            }

            lwcs = this.template
                .querySelectorAll("c-a-h-f-c_dashboard-statements");
            for (let i = 0; i < lwcs.length; i++) {
                lwcs[i].handleValueChange(this.selServiceAccountWrapper);
            }

            let cuBill = this.template
                .querySelectorAll("c-a-h-f-c_dashboard-current-bill");
            for (let i = 0; i < cuBill.length; i++) {
                cuBill[i].handleValueChange(this.selServiceAccountWrapper);
            }

            let testlwc = this.template
                .querySelectorAll("c-payment-progress-tile-dashboard-l-w-c");
            for (let i = 0; i < testlwc.length; i++) {
                testlwc[i].handleValueChange(this.selServiceAccountWrapper);
            }

            let marTile = this.template
                .querySelectorAll("c-a-h-f-c_dashboard-marketing-tile");
            for (let i = 0; i < marTile.length; i++) {
                marTile[i].handleValueChange(this.selServiceAccountWrapper);
            }


        }
    }



    //Toggle Accordions in Mobile
    onMobileSectionsClick(event) {
        const open = "slds-accordion__section slds-is-open";
        const close = "slds-accordion__section";
        if (event.currentTarget.dataset.keyno) {
            this.mobileSections[event.target.dataset.keyno].isOpened = !this
                .mobileSections[event.target.dataset.keyno].isOpened;
            this.mobileSections[event.target.dataset.keyno].class =
                this.mobileSections[event.target.dataset.keyno].class === open ?
                    close :
                    open;
            this.mobileSections[event.target.dataset.keyno].contentClass = this
                .mobileSections[event.target.dataset.keyno].isOpened ?
                "slds-accordion__content mobile-accordion-content" :
                "slds-accordion__content";
        }
    }

    //Toggle Accordions in Mobile for locked state
    onMobileSectionsClickForLocked(event) {
        const open = "slds-accordion__section slds-is-open";
        const close = "slds-accordion__section";
        if (event.currentTarget.dataset.keyno) {
            this.lockedmobileSections[event.target.dataset.keyno].isOpened = !this
                .lockedmobileSections[event.target.dataset.keyno].isOpened;
            this.lockedmobileSections[event.target.dataset.keyno].class =
                this.lockedmobileSections[event.target.dataset.keyno].class === open ?
                    close :
                    open;
            this.lockedmobileSections[event.target.dataset.keyno].contentClass = this
                .lockedmobileSections[event.target.dataset.keyno].isOpened ?
                "slds-accordion__content mobile-accordion-content" :
                "slds-accordion__content";
        }
    }

    //Toggle View Details in Mobile View
    onMobileCarDetailsClick() {
        this.showCarDetailsMobile = !this.showCarDetailsMobile;
    }

    //On Clicking of Prev in Carousal
    onCarousalPrevDesktop() {
        this.setPageData(parseInt(this.currentItem), parseInt(this.currentItem) - 1);
    }

    //On Clicking of Next in Carousal
    onCarousalNextDesktop() {
        this.setPageData(parseInt(this.currentItem), parseInt(this.currentItem) + 1);
    }

    // Setup whether the Carousal Next/Previous Buttons be clickable
    displayicons() {
        this.isCarousalFirstItem = this.currentItem == 0 ? true : false;
        this.carousalPrevButtonClass = this.isCarousalFirstItem ?
            "slds-button carousal-button-desktop carousal-button-disabled" :
            "slds-button carousal-button-desktop";
        this.isCarousalLastItem =
            parseInt(this.currentItem) + 1 == this.lstofServiceAccountwrapper.length ?
                true :
                false;
        this.carousalNextButtonClass = this.isCarousalLastItem ?
            "slds-button carousal-button-desktop carousal-button-disabled" :
            "slds-button carousal-button-desktop";
    }

    // Setup the page on Carousal Bottom Indicators Click
    onCarousalIndicatorClick(event) {
        if (event.target.dataset.indicator && (event.target.dataset.indicator != this.currentItem)) {
            this.setPageData(this.currentItem, event.target.dataset.indicator);
        }
    }

    //Navigating to Account Profile
    navigatetoAccountprofile() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Dashboard:Hyperlink:Account Details",
            "Event_Metadata.action_category": "Carousel",
            "Page.page_name": "Dashboard",
        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('salesforce_id', JSON.parse(this.selServiceAccountWrapper).serAccRec.Id);
        for (let i = 0; i < this.selServiceAccountWrapperForHeader.length; i++) {
            if (this.selServiceAccountWrapperForHeader[i].serAccRec.Id == sessionStorage.getItem('salesforce_id')) {
                sessionStorage.setItem('salesforce_id_index', i);
            }
        }
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'finance-account-profile'
            }
        });
    }

    //US - 8765 - Start
    navigatetocommpreff() {
        sessionStorage.setItem('salesforce_id', JSON.parse(this.selServiceAccountWrapper).serAccRec.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'communicationpreference'
            }
        });
    }

        //RSS - 53493 - Start
        navigatetoneedHelp() {
            sessionStorage.setItem('salesforce_id', JSON.parse(this.selServiceAccountWrapper).serAccRec.Id);
            this[NavigationMixin.Navigate]({
                type: "comm__namedPage",
                attributes: {
                    pageName: "help-payment"
                },
                state: {
                    sacRecordId: JSON.parse(this.selServiceAccountWrapper).serAccRec.Id
                }
            });
        }
        
        AHFCInventoryShortageSwitch() {
            AHFCInventoryShortageSwitch({}).then(result => {
                let data = result;
                
                if (data == 'true') {
                    this.inventoryShortage = true;
                    console.log('AHFCInventoryShortageSwitch ', this.inventoryShortage);
                } else {
                    this.inventoryShortage = false;
                    console.log('AHFCInventoryShortageSwitch ', this.inventoryShortage);
                }
            }).catch(error => {
                // Showing errors if any while inserting the files
                console.log('inside catch ', error);
            });
        }
         
        //RSS - 53493 - end

    //US - 12186 - Start
    navigateToCommPreffAndUpdateAckDate() {
        updateMessageAckDate({
            finId: JSON.parse(this.selServiceAccountWrapper).serAccRec.Id
        })
            .then((result) => {
                if (result) {
                    console.log('DatabaseUpdateSuccessful', result);

                }
            })
            .catch((error) => {
                console.log('Errorrrr', error);
            }

            );

        sessionStorage.setItem('salesforce_id', JSON.parse(this.selServiceAccountWrapper).serAccRec.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'communicationpreference'
            }

        });
    }


    navigatetomakepayment() {
        sessionStorage.setItem('salesforce_id', JSON.parse(this.selServiceAccountWrapper).serAccRec.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            }
        });
    }

    navigatetootppayment() {
        sessionStorage.setItem('salesforce_id', JSON.parse(this.selServiceAccountWrapper).serAccRec.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                //sacRecordId: this.IDSAC,
                showOTPDefault: true
            }
        });
    }

    //Navigating to Add Finance Account - Added by Akash Solanki as Part of 6030
    navigatetoaddFincanceAccount() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Dashboard:Hyperlink:Add Product",
            "Event_Metadata.action_category": "Carousel",
            "Page.page_name": "Dashboard",
        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('salesforce_id', JSON.parse(this.selServiceAccountWrapper).serAccRec.Id);
        sessionStorage.setItem('addProductFromDashboard', 'true');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'add-a-finance-account'

            },
        });

    }

    //navigate to made-payment page
    navigateToMadePayment() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'already-made-a-payment'
            },
            state: {
                sacRecordId: JSON.parse(this.selServiceAccountWrapper).serAccRec.Id
            }
        });
    }

    //to open nick name model.
    opennicknamemodal() {
        let adobedata = {
            'Event_Metadata.action_type': 'Edit',
            "Event_Metadata.action_label": "Dashboard:Edit:Nickname",
            "Event_Metadata.action_category": "Carousel",
            "Page.page_name": "Dashboard",
        };
        fireAdobeEvent(adobedata, 'click-event');
        this.isEditNickname = true;
    }

    //To close nickname pop up.
    closenicknamepopup(event) {
        if (event.detail != undefined) {
            this.currentFinAccId = event.detail.id;
            this.nickNameNew = event.detail.name;
            //refreshApex(this.wiredAccountList);
            this.testMethod();
        }
        this.isEditNickname = false;

    }

    // Added by Prabu for the US - 4338
    onPayoffPayment(findata) {

        console.log('onPayoffPayment >>>>');

        this.isShowAfterPayoff = false; //added as part of bug fix 20251
        let newfindata = JSON.parse(findata);
        this.payoffFinId = newfindata.serAccRec.Id;       
        payoffPaymentDetail({
            finId: this.payoffFinId
        })
            .then((result) => {
                if (result) {
                    this.payoffDetails = result;
                   console.log('payoffDetails >>>',this.payoffDetails);
                    if (this.payoffDetails !== null && this.payoffDetails !== undefined) {
                        //if the Payment status is Pending or Processing from chargent Order and checking the account type is Retail through the Apex class - AHFC_Payment 
                        if (newfindata.serAccRec.Account_Type__c === accTypeRetail && (this.payoffDetails.Payment_Display_Status__c === statusPending || this.payoffDetails.Payment_Display_Status__c === statusProcessing)) {
                            this.isShowBeforePayoff = true;
                            this.isBeforePayoffInfo = true;
                            //if the Payment status is Posted from chargent Order and checking the account type is Retail and Payoff amount is 0 from the finance Account
                        } else if (newfindata.serAccRec.Payoff_Amount__c == payoffAmtZero && newfindata.serAccRec.Account_Type__c === accTypeRetail && this.payoffDetails.Payment_Display_Status__c === statusPosted) {
                            this.isShowAfterPayoff = true;
                            this.isAfterPayoffInfo = true;
                        } else {
                            this.isShowBeforePayoff = false;
                            this.isShowAfterPayoff = false;

                        }
                    }
                    
                }
                 else{  // block added by sagar for bug fix 22296
                    console.log('payoffDetails inside else block >>>');
                    this.isShowBeforePayoff = false;  
                    this.isBeforePayoffInfo = false;
                } 
            })
            .catch((error) => {
                console.log('Errorrrr', error);
            }

            );

    }


    /*Added by Prabu for the US 8755 - Critical Alert*/
    onCriticalAlert(findata) {
        console.log('InsideCriticalAlert');
        let newfindata = JSON.parse(findata);
        let sessioneddata = JSON.parse(sessionStorage.getItem(newfindata.accNo));

        if (sessioneddata !== null) {
            if (sessioneddata.statementSuppressed == true) {
                this.isStmtSuppressed = true;
                this.isStmtCloseInfo = true;

            }
            if (sessioneddata.isWebsiteRestricted !== undefined &&
                sessioneddata.isWebsiteRestricted == false) {
                this.isNotLockedCritical = true;
                this.showCriticalAlertPastDue = false;
            }
        } else if (sessioneddata == null) {
            if (newfindata.serAccRec.AHFC_Web_Account_Locked__c !== 'Y') {
                this.isNotLockedCritical = true;
                this.showCriticalAlertPastDue = false;
            }

        } else {
            this.isNotLockedCritical = false;
        }
        if (newfindata.serAccRec.AHFC_Fl_Archived__c !== 'Y') {
            this.isNotArchivedCritical = true;
            this.showCriticalAlertPastDue = false;
        } else {
            this.isNotArchivedCritical = false;
        }


        /* Added by Prabu for the US 8755 - Start*/
        // if (newfindata.serAccRec.AHFC_Total_days_past_due__c >= 2 &&
        if (newfindata.serAccRec.AHFC_Total_days_past_due__c >= 1 &&    
            newfindata.serAccRec.Fl_OneTime_Payment_Eligible_Web__c == true) {
            this.isPastDueOneTime = true;
        } else {
            this.isPastDueOneTime = false;
        }

        if (this.isPastDueOneTime && this.isNotArchivedCritical && this.isNotLockedCritical) {
            this.showCriticalAlertPastDue = true;
            this.isClosePastDue = true;
        }
    }


    OncommPrefEligible(findata) {
        this.isLocked = false;
        console.log('InititalCommPreffentry');
        let newfindata = JSON.parse(findata);
        this.commPrefFinId = newfindata.serAccRec.Id;
        commPrefEligible({
            finid: this.commPrefFinId
        })
            .then((result) => {
                if (result) {
                    this.commPreffDetails = result.commPrefDetails;
                    /*START - Added by Prabu for the US- 12186*/
                    let sessioneddata = JSON.parse(sessionStorage.getItem(newfindata.accNo));
                    /*START - SMS Bounceback*/
                    if ((this.commPreffDetails.Account_Status_Updates_via_Text__c === true ||
                        this.commPreffDetails.EasyPay_Communications_via_Text__c === true ||
                        this.commPreffDetails.Payment_Confirmations_via_Text__c === true ||
                        this.commPreffDetails.Payment_Profile_Updates_via_Text__c === true ||
                        this.commPreffDetails.Payment_Reminders_via_Text__c === true) &&
                        (this.commPreffDetails.Is_SMS_Bounced_Back__c === true || this.commPreffDetails.SMS_Bounce_Back_Count__c == bounceBackCount)) {
                        this.isUpdateSMSCommPreff = true;
                        this.isSMSCommPreffInfo = true;
                    } else {
                        this.isUpdateSMSCommPreff = false;
                        this.isSMSCommPreffInfo = false;
                    }
                    /*END - SMS Bounceback*/
                    /*START - Email Bounceback - 1st CRITERIA*/
                    if ((this.commPreffDetails.Account_Status_Updates_via_Email__c === true ||
                        this.commPreffDetails.EasyPay_Communications_via_Email__c === true ||
                        this.commPreffDetails.Marketing_Communications_Via_Email__c === true ||
                        this.commPreffDetails.Payment_Confirmations_via_Email__c === true ||
                        this.commPreffDetails.Payment_Profile_Updates_via_Email__c === true ||
                        this.commPreffDetails.Payment_Reminders_via_Email__c === true) &&
                        (this.commPreffDetails.IsEmailBounced__c === true || this.commPreffDetails.Email_BounceBack_Count__c == bounceBackCount)) {
                        this.isUpdateEmailCommPreff = true;
                        this.isEmailCommPreffInfo = true;
                        this.isShowEmailBounce = true;

                    } else {
                        this.isUpdateEmailCommPreff = false;
                        this.isEmailCommPreffInfo = false;
                        this.isShowEmailBounce = false; // if isShowEmailBounce is false then only subsequent criterias will be executed.
                    }
                    /*END - Email Bounceback - 1st CRITERIA*/
                    /*START - Email Bounceback - 2nd CRITERIA*/
                    if (this.isShowEmailBounce === false) {
                        if ((this.commPreffDetails.Account_Status_Updates_via_Email__c === true ||
                            this.commPreffDetails.EasyPay_Communications_via_Email__c === true ||
                            this.commPreffDetails.Marketing_Communications_Via_Email__c === true ||
                            this.commPreffDetails.Payment_Confirmations_via_Email__c === true ||
                            this.commPreffDetails.Payment_Profile_Updates_via_Email__c === true ||
                            this.commPreffDetails.Payment_Reminders_via_Email__c === true) &&
                            (this.commPreffDetails.EmailBouncedDate__c != null)) {
                            if ((this.commPreffDetails.Finance_Account_Number__r.Message_Ack_Date__c ==
                                null ||
                                this.commPreffDetails.Finance_Account_Number__r.Message_Ack_Date__c ==
                                undefined) || (this.commPreffDetails.EmailBouncedDate__c >
                                    this.commPreffDetails.Finance_Account_Number__r.Message_Ack_Date__c)) {
                                this.isUpdateEmailCommPreff = true;
                                this.isEmailCommPreffInfo = true;
                                this.isShowEmailBounce = true;
                            }

                        } else {
                            this.isUpdateEmailCommPreff = false;
                            this.isEmailCommPreffInfo = false;
                            this.isShowEmailBounce = false;
                        }
                    }

                    /*END - Email Bounceback - 2nd CRITERIA*/
                    /*START - Email Bounceback - 3rd CRITERIA*/
                    if (this.isShowEmailBounce === false) {
                        if (this.commPreffDetails.Paperless_Statements_Letters__c) {
                            if (sessioneddata !== null && sessioneddata != undefined) {
                                if (this.formatISOdate(sessioneddata.eDelLastUndeliverable) != null && this.formatISOdate(sessioneddata.eDelLastEnrollment) != null) {
                                    console.log('msgCutoffDate>>>>>>>>>>>>>>>'+msgCutoffDate);
                                    if ((this.formatISOdate(sessioneddata.eDelLastUndeliverable) > msgCutoffDate) &&
                                        (this.formatISOdate(sessioneddata.eDelLastUndeliverable) > this.formatISOdate(sessioneddata.eDelLastEnrollment)) &&
                                        ((this.commPreffDetails.Finance_Account_Number__r.Message_Ack_Date__c == null ||
                                            this.commPreffDetails.Finance_Account_Number__r.Message_Ack_Date__c ==
                                            undefined) ||
                                            this.formatISOdate(sessioneddata.eDelLastUndeliverable) > this.commPreffDetails.Finance_Account_Number__r.Message_Ack_Date__c)) {
                                        this.isUpdateEmailCommPreff = true;
                                        this.isEmailCommPreffInfo = true;
                                        this.isShowEmailBounce = true;

                                    }


                                }

                            }
                            /*END - Email Bounceback - 3rd CRITERIA*/
                            /*START - Email Bounceback - 4th CRITERIA*/
                        } else {
                            if (sessioneddata !== null && sessioneddata != undefined) {
                                if (this.formatISOdate(sessioneddata.eDelCancelDate) != null &&
                                    this.formatISOdate(sessioneddata.eDelLastEnrollment) != null &&
                                    this.formatISOdate(sessioneddata.eDelLastUndeliverable) != null) {
                                    if ((this.formatISOdate(sessioneddata.eDelCancelDate) > msgCutoffDate) &&
                                        (this.formatISOdate(sessioneddata.eDelCancelDate) > this.formatISOdate(sessioneddata.eDelLastEnrollment)) &&
                                        ((sessioneddata.eDelCancelReason === cancelReasonBBU) ||
                                            (sessioneddata.eDelCancelReason === cancelReasonBBC) &&
                                            ((this.commPreffDetails.Finance_Account_Number__r.Message_Ack_Date__c == null ||
                                                this.commPreffDetails.Finance_Account_Number__r.Message_Ack_Date__c == undefined) || this.formatISOdate(sessioneddata.eDelLastUndeliverable) > this.commPreffDetails.Finance_Account_Number__r.Message_Ack_Date__c))) {
                                        this.isUpdateEmailCommPreff = true;
                                        this.isEmailCommPreffInfo = true;
                                        this.isShowEmailBounce = true;
                                    }
                                }

                            }

                        }
                    }
                    console.log('CommPreffEntry111');
                    /*END - Email Bounceback - 4th CRITERIA*/
                    /*END - Added by Prabu for the US- 12186*/
                    console.log('New field value-->', this.commPreffDetails.Finance_Account_Number__r.AHFC_Web_Manage_Comm_Pref__c);
                    if (this.isLocked === false && this.commPreffDetails.Finance_Account_Number__r.AHFC_Web_Manage_Comm_Pref__c != 'NE') {
                        if (this.commPreffDetails.Account_Status_Updates_via_Email__c === false &&
                            this.commPreffDetails.Account_Status_Updates_via_Text__c === false &&
                            this.commPreffDetails.Payment_Confirmations_via_Email__c === false &&
                            this.commPreffDetails.Payment_Reminders_via_Email__c === false &&
                            this.commPreffDetails.Payment_Confirmations_via_Text__c === false &&
                            this.commPreffDetails.Payment_Reminders_via_Text__c === false &&
                            this.commPreffDetails.EasyPay_Communications_via_Email__c === false) {
                            console.log('CommPreffEntry222');
                            this.isCommPreff = true;
                            this.isCommPreffInfo = true;
                        }
                    }

                }
            })
            .catch((error) => {
                console.log('Errorrrr', error);
            }

            );

    }
    navigateToEndOfTerm(){
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'end-of-lease'
            }
        });
    }
    /*US 8765 End */
    formatshortdate(dt) {
        var formatdate = new Date(dt);
        formatdate = new Date(
            formatdate.getTime() + formatdate.getTimezoneOffset() * 60 * 1000
        );
        if (formatdate != 'Invalid Date') {
            const options = {
                month: "short",
                day: "numeric",
                year: "numeric"
            };
            return formatdate.toLocaleDateString("en-US", options);
        } else {
            return "";
        }
    }

    // Added by Prabu for the US - 12186
    formatISOdate(dt) {
        console.log('formatISOdate>>>>>>>>>>dt:'+dt);
        var d = new Date(dt),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();
            console.log('formatISOdate>>>>>>>>>>month:'+month);
            console.log('formatISOdate>>>>>>>>>>day:'+day);

        if (month.length < 2)
            month = '0' + month;
        if (day.length < 2)
            day = '0' + day;

        return [year, month, day].join('-');


    }

}